Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2836514A07
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359592AbiD2M7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359593AbiD2M7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:59:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35AF3614F
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:56:18 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nkQAT-00008N-1z
        for netdev@vger.kernel.org; Fri, 29 Apr 2022 14:56:17 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0C85670EF7
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:56:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A60AD70EDB;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0a78f4ea;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/5] can: isotp: remove re-binding of bound socket
Date:   Fri, 29 Apr 2022 14:56:08 +0200
Message-Id: <20220429125612.1792561-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429125612.1792561-1-mkl@pengutronix.de>
References: <20220429125612.1792561-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

As a carry over from the CAN_RAW socket (which allows to change the CAN
interface while mantaining the filter setup) the re-binding of the
CAN_ISOTP socket needs to take care about CAN ID address information and
subscriptions. It turned out that this feature is so limited (e.g. the
sockopts remain fix) that it finally has never been needed/used.

In opposite to the stateless CAN_RAW socket the switching of the CAN ID
subscriptions might additionally lead to an interrupted ongoing PDU
reception. So better remove this unneeded complexity.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220422082337.1676-1-socketcan@hartkopp.net
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index ff5d7870294e..1e7c6a460ef9 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1189,6 +1189,11 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	lock_sock(sk);
 
+	if (so->bound) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg = 0;
@@ -1199,10 +1204,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		goto out;
 	}
 
-	if (so->bound && addr->can_ifindex == so->ifindex &&
-	    rx_id == so->rxid && tx_id == so->txid)
-		goto out;
-
 	dev = dev_get_by_index(net, addr->can_ifindex);
 	if (!dev) {
 		err = -ENODEV;
@@ -1237,22 +1238,6 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 
 	dev_put(dev);
 
-	if (so->bound && do_rx_reg) {
-		/* unregister old filter */
-		if (so->ifindex) {
-			dev = dev_get_by_index(net, so->ifindex);
-			if (dev) {
-				can_rx_unregister(net, dev, so->rxid,
-						  SINGLE_MASK(so->rxid),
-						  isotp_rcv, sk);
-				can_rx_unregister(net, dev, so->txid,
-						  SINGLE_MASK(so->txid),
-						  isotp_rcv_echo, sk);
-				dev_put(dev);
-			}
-		}
-	}
-
 	/* switch to new settings */
 	so->ifindex = ifindex;
 	so->rxid = rx_id;

base-commit: d9157f6806d1499e173770df1f1b234763de5c79
-- 
2.35.1


