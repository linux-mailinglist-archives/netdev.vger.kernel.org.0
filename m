Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953BC3ADBE7
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 00:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFSWDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 18:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbhFSWDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 18:03:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDD6C061760
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 15:01:26 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luj1o-0005WI-HW
        for netdev@vger.kernel.org; Sun, 20 Jun 2021 00:01:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0722663F804
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 22:01:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 33A0163F7E5;
        Sat, 19 Jun 2021 22:01:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bc9ba118;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/5] can: isotp: isotp_release(): omit unintended hrtimer restart on socket release
Date:   Sun, 20 Jun 2021 00:01:13 +0200
Message-Id: <20210619220115.2830761-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210619220115.2830761-1-mkl@pengutronix.de>
References: <20210619220115.2830761-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

When closing the isotp socket, the potentially running hrtimers are
canceled before removing the subscription for CAN identifiers via
can_rx_unregister().

This may lead to an unintended (re)start of a hrtimer in
isotp_rcv_cf() and isotp_rcv_fc() in the case that a CAN frame is
received by isotp_rcv() while the subscription removal is processed.

However, isotp_rcv() is called under RCU protection, so after calling
can_rx_unregister, we may call synchronize_rcu in order to wait for
any RCU read-side critical sections to finish. This prevents the
reception of CAN frames after hrtimer_cancel() and therefore the
unintended (re)start of the hrtimers.

Link: https://lore.kernel.org/r/20210618173713.2296-1-socketcan@hartkopp.net
Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index be6183f8ca11..234cc4ad179a 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1028,9 +1028,6 @@ static int isotp_release(struct socket *sock)
 
 	lock_sock(sk);
 
-	hrtimer_cancel(&so->txtimer);
-	hrtimer_cancel(&so->rxtimer);
-
 	/* remove current filters & unregister */
 	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
@@ -1042,10 +1039,14 @@ static int isotp_release(struct socket *sock)
 						  SINGLE_MASK(so->rxid),
 						  isotp_rcv, sk);
 				dev_put(dev);
+				synchronize_rcu();
 			}
 		}
 	}
 
+	hrtimer_cancel(&so->txtimer);
+	hrtimer_cancel(&so->rxtimer);
+
 	so->ifindex = 0;
 	so->bound = 0;
 
-- 
2.30.2


