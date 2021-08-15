Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01663EC6F6
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236697AbhHODer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:34:47 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:47406 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhHODep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:34:45 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d21 with ME
        id hfZ7250050zjR6y03faDyh; Sun, 15 Aug 2021 05:34:15 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Aug 2021 05:34:15 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>
Subject: [PATCH v5 6/7] can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device
Date:   Sun, 15 Aug 2021 12:32:47 +0900
Message-Id: <20210815033248.98111-7-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

CC: Stefan Mätje <stefan.maetje@esd.eu>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c | 15 ++++++++++++---
 include/linux/can/dev.h       |  1 +
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index f05745c96b9c..776284593b5d 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -362,7 +362,8 @@ static size_t can_tdc_get_size(const struct net_device *dev)
 	}
 
 	if (can_tdc_is_enabled(priv)) {
-		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL)
+		if (priv->ctrlmode & CAN_CTRLMODE_TDC_MANUAL ||
+		    priv->do_get_auto_tdcv)
 			size += nla_total_size(sizeof(u32));	/* IFLA_CAN_TDCV */
 		size += nla_total_size(sizeof(u32));		/* IFLA_CAN_TDCO */
 		if (priv->tdc_const->tdcf_max)
@@ -435,8 +436,16 @@ static int can_tdc_fill_info(struct sk_buff *skb, const struct net_device *dev)
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
index fa75e29182a3..266d0fe9de9d 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -74,6 +74,7 @@ struct can_priv {
 			    enum can_state *state);
 	int (*do_get_berr_counter)(const struct net_device *dev,
 				   struct can_berr_counter *bec);
+	int (*do_get_auto_tdcv)(const struct net_device *dev, u32 *tdcv);
 
 	unsigned int echo_skb_max;
 	struct sk_buff **echo_skb;
-- 
2.31.1

