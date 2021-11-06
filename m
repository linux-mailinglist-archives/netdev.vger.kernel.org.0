Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4684C4470C6
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbhKFV5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234299AbhKFV5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:57:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60DFC061714
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:55:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mjTeO-0000s1-86
        for netdev@vger.kernel.org; Sat, 06 Nov 2021 22:55:00 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 28BB56A5F8A
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 21:54:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6290F6A5F77;
        Sat,  6 Nov 2021 21:54:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73ff5a60;
        Sat, 6 Nov 2021 21:54:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/8] can: etas_es58x: es58x_rx_err_msg(): fix memory leak in error path
Date:   Sat,  6 Nov 2021 22:54:45 +0100
Message-Id: <20211106215449.57946-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106215449.57946-1-mkl@pengutronix.de>
References: <20211106215449.57946-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

In es58x_rx_err_msg(), if can->do_set_mode() fails, the function
directly returns without calling netif_rx(skb). This means that the
skb previously allocated by alloc_can_err_skb() is not freed. In other
terms, this is a memory leak.

This patch simply removes the return statement in the error branch and
let the function continue.

Issue was found with GCC -fanalyzer, please follow the link below for
details.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Link: https://lore.kernel.org/all/20211026180740.1953265-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a..24627ab14626 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -664,7 +664,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 	struct can_device_stats *can_stats = &can->can_stats;
 	struct can_frame *cf = NULL;
 	struct sk_buff *skb;
-	int ret;
+	int ret = 0;
 
 	if (!netif_running(netdev)) {
 		if (net_ratelimit())
@@ -823,8 +823,6 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 			can->state = CAN_STATE_BUS_OFF;
 			can_bus_off(netdev);
 			ret = can->do_set_mode(netdev, CAN_MODE_STOP);
-			if (ret)
-				return ret;
 		}
 		break;
 
@@ -881,7 +879,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 					ES58X_EVENT_BUSOFF, timestamp);
 	}
 
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.33.0


