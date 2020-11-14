Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFCA2B2F04
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKNRej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 12:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgKNRei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 12:34:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DFAC0613D2
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 09:34:38 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kdzRc-0000mY-K1; Sat, 14 Nov 2020 18:34:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        =?UTF-8?q?Remigiusz=20Ko=C5=82=C5=82=C4=85taj?= 
        <remigiusz.kollataj@mobica.com>
Subject: [net 05/15] can: mcba_usb: mcba_usb_start_xmit(): first fill skb, then pass to can_put_echo_skb()
Date:   Sat, 14 Nov 2020 18:33:49 +0100
Message-Id: <20201114173358.2058600-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201114173358.2058600-1-mkl@pengutronix.de>
References: <20201114173358.2058600-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver has to first fill the skb with data and then handle it to
can_put_echo_skb(). This patch moves the can_put_echo_skb() down, right before
sending the skb out via USB.

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Cc: Remigiusz Kołłątaj <remigiusz.kollataj@mobica.com>
Link: https://lore.kernel.org/r/20201111221204.1639007-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/mcba_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 5857b37dcd96..e97f2e0da6b0 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -326,8 +326,6 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	if (!ctx)
 		return NETDEV_TX_BUSY;
 
-	can_put_echo_skb(skb, priv->netdev, ctx->ndx);
-
 	if (cf->can_id & CAN_EFF_FLAG) {
 		/* SIDH    | SIDL                 | EIDH   | EIDL
 		 * 28 - 21 | 20 19 18 x x x 17 16 | 15 - 8 | 7 - 0
@@ -357,6 +355,8 @@ static netdev_tx_t mcba_usb_start_xmit(struct sk_buff *skb,
 	if (cf->can_id & CAN_RTR_FLAG)
 		usb_msg.dlc |= MCBA_DLC_RTR_MASK;
 
+	can_put_echo_skb(skb, priv->netdev, ctx->ndx);
+
 	err = mcba_usb_xmit(priv, (struct mcba_usb_msg *)&usb_msg, ctx);
 	if (err)
 		goto xmit_failed;
-- 
2.29.2

