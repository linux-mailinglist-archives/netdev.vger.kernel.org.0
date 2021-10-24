Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB2438BF0
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhJXUrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhJXUrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0395DC061225
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMS-0006Pj-6A
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CCCA369C5EB
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2F79869C568;
        Sun, 24 Oct 2021 20:43:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 260c9281;
        Sun, 24 Oct 2021 20:43:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 07/15] can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device
Date:   Sun, 24 Oct 2021 22:43:17 +0200
Message-Id: <20211024204325.3293425-8-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Some CAN device can measure the TDCV (Transmission Delay Compensation
Value) automatically for each transmitted CAN frames.

A callback function do_get_auto_tdcv() is added to retrieve that
value. This function is used only if CAN_CTRLMODE_TDC_AUTO is enabled
(if CAN_CTRLMODE_TDC_MANUAL is selected, the TDCV value is provided by
the user).

If the device does not support reporting of TDCV, do_get_auto_tdcv()
should be set to NULL and TDCV will not be reported by the netlink
interface.

On success, do_get_auto_tdcv() shall return 0. If the value can not be
measured by the device, for example because network is down or because
no frames were transmitted yet, can_priv::do_get_auto_tdcv() shall
return a negative error code (e.g. -EINVAL) to signify that the value
is not yet available. In such cases, TDCV is not reported by the
netlink interface.

Link: https://lore.kernel.org/all/20210918095637.20108-6-mailhol.vincent@wanadoo.fr
CC: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 15 ++++++++++++---
 include/linux/can/dev.h       |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index c77cc6ae88b6..95cca4e5251f 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -372,7 +372,8 @@ static size_t can_tdc_get_size(const struct net_device *dev)
 	}
 
 	if (can_tdc_is_enabled(priv)) {
-		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL)
+		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL ||
+		    priv->do_get_auto_tdcv)
 			size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
 		size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO */
 		if (priv->tdc_const->tdcf_max)
@@ -445,8 +446,16 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
 		goto err_cancel;
 
 	if (can_tdc_is_enabled(priv)) {
-		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL &&
-		    nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdc->tdcv))
+		u32 tdcv;
+		int err = -EINVAL;
+
+		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL) {
+			tdcv = tdc->tdcv;
+			err = 0;
+		} else if (priv->do_get_auto_tdcv) {
+			err = priv->do_get_auto_tdcv(dev, &tdcv);
+		}
+		if (!err && nla_put_u32(skb, IFLA_CAN_TDC_TDCV, tdcv))
 			goto err_cancel;
 		if (nla_put_u32(skb, IFLA_CAN_TDC_TDCO, tdc->tdco))
 			goto err_cancel;
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 6dacbbb41e68..b4aa0f048cab 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -82,6 +82,7 @@ struct can_priv {
 			    enum can_state *state);
 	int (*do_get_berr_counter)(const struct net_device *dev,
 				   struct can_berr_counter *bec);
+	int (*do_get_auto_tdcv)(const struct net_device *dev, u32 *tdcv);
 
 	unsigned int echo_skb_max;
 	struct sk_buff **echo_skb;
-- 
2.33.0


