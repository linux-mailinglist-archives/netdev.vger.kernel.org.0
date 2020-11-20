Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ECB2BAB3E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:34:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgKTNdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728226AbgKTNdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:33 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222E2C0617A7
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:33 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6Xb-0006Fn-8L; Fri, 20 Nov 2020 14:33:31 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Christer Beskow <chbe@kvaser.com>,
        Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 23/25] can: kvaser_usb: kvaser_usb_hydra: Add support for new device variant
Date:   Fri, 20 Nov 2020 14:33:16 +0100
Message-Id: <20201120133318.3428231-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120133318.3428231-1-mkl@pengutronix.de>
References: <20201120133318.3428231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christer Beskow <chbe@kvaser.com>

Add support for a new variant of devices using the hydra platform, based on
NXP i.MX RT (flexcan).

Signed-off-by: Christer Beskow <chbe@kvaser.com>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/r/20201115163027.16851-5-jimmyassarsson@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 107b205b77ab..480bd2ecb296 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -34,6 +34,7 @@
 /* Forward declarations */
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_kcan;
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc;
+static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt;
 
 #define KVASER_USB_HYDRA_BULK_EP_IN_ADDR	0x82
 #define KVASER_USB_HYDRA_BULK_EP_OUT_ADDR	0x02
@@ -135,6 +136,7 @@ struct kvaser_cmd_sw_detail_req {
 #define KVASER_USB_HYDRA_SW_FLAG_CANFD		BIT(10)
 #define KVASER_USB_HYDRA_SW_FLAG_NONISO		BIT(11)
 #define KVASER_USB_HYDRA_SW_FLAG_EXT_CAP	BIT(12)
+#define KVASER_USB_HYDRA_SW_FLAG_CAN_FREQ_80M	BIT(13)
 struct kvaser_cmd_sw_detail_res {
 	__le32 sw_flags;
 	__le32 sw_version;
@@ -383,6 +385,30 @@ static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
 	.brp_inc = 1,
 };
 
+static const struct can_bittiming_const kvaser_usb_hydra_rt_bittiming_c = {
+	.name = "kvaser_usb_rt",
+	.tseg1_min = 2,
+	.tseg1_max = 96,
+	.tseg2_min = 2,
+	.tseg2_max = 32,
+	.sjw_max = 32,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const kvaser_usb_hydra_rtd_bittiming_c = {
+	.name = "kvaser_usb_rt",
+	.tseg1_min = 2,
+	.tseg1_max = 39,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 8,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
+};
+
 #define KVASER_USB_HYDRA_TRANSID_BITS		12
 #define KVASER_USB_HYDRA_TRANSID_MASK \
 				GENMASK(KVASER_USB_HYDRA_TRANSID_BITS - 1, 0)
@@ -1727,6 +1753,8 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 
 	if (flags &  KVASER_USB_HYDRA_SW_FLAG_FREQ_80M)
 		dev->cfg = &kvaser_usb_hydra_dev_cfg_kcan;
+	else if (flags & KVASER_USB_HYDRA_SW_FLAG_CAN_FREQ_80M)
+		dev->cfg = &kvaser_usb_hydra_dev_cfg_rt;
 	else
 		dev->cfg = &kvaser_usb_hydra_dev_cfg_flexc;
 
@@ -2026,3 +2054,12 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 	.timestamp_freq = 1,
 	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
 };
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
+	.clock = {
+		.freq = 80000000,
+	},
+	.timestamp_freq = 24,
+	.bittiming_const = &kvaser_usb_hydra_rt_bittiming_c,
+	.data_bittiming_const = &kvaser_usb_hydra_rtd_bittiming_c,
+};
-- 
2.29.2

