Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CBC2753CB
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIWIyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIWIyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 04:54:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF74C061755
        for <netdev@vger.kernel.org>; Wed, 23 Sep 2020 01:54:31 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kL0Xk-0000uS-Sz; Wed, 23 Sep 2020 10:54:29 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, michael@walle.cc, qiangqing.zhang@nxp.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 15/20] can: flexcan: add CAN-FD mode support
Date:   Wed, 23 Sep 2020 10:54:13 +0200
Message-Id: <20200923085418.2685858-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923085418.2685858-1-mkl@pengutronix.de>
References: <20200923085418.2685858-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

This patch adds CAN-FD mode support to the driver, it means that
payload size can extend up to 64 bytes.

Bit timing always set in the CBT register, not in the CTRL1 register any
more. This has an extend range of all CAN bit timing variables (PRESDIV,
PROPSEG, PSEG1, PSEG2 and RJW), which will improve the bit timing
accuracy.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
[mkl: move cbt-based bitrate support into separate function]
Link: https://lore.kernel.org/r/20200922144429.2613631-16-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 220 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 212 insertions(+), 8 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 20c845c265e1..8dca553fa545 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -9,6 +9,7 @@
 //
 // Based on code originally by Andrey Volkov <avolkov@varma-el.com>
 
+#include <linux/bitfield.h>
 #include <linux/can.h>
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
@@ -53,6 +54,7 @@
 #define FLEXCAN_MCR_IRMQ		BIT(16)
 #define FLEXCAN_MCR_LPRIO_EN		BIT(13)
 #define FLEXCAN_MCR_AEN			BIT(12)
+#define FLEXCAN_MCR_FDEN		BIT(11)
 /* MCR_MAXMB: maximum used MBs is MAXMB + 1 */
 #define FLEXCAN_MCR_MAXMB(x)		((x) & 0x7f)
 #define FLEXCAN_MCR_IDAM_A		(0x0 << 8)
@@ -137,6 +139,30 @@
 	(FLEXCAN_ESR_TWRN_INT | FLEXCAN_ESR_RWRN_INT | \
 	 FLEXCAN_ESR_BOFF_INT | FLEXCAN_ESR_ERR_INT)
 
+/* FLEXCAN Bit Timing register (CBT) bits */
+#define FLEXCAN_CBT_BTF			BIT(31)
+#define FLEXCAN_CBT_EPRESDIV_MASK	GENMASK(30, 21)
+#define FLEXCAN_CBT_ERJW_MASK		GENMASK(20, 16)
+#define FLEXCAN_CBT_EPROPSEG_MASK	GENMASK(15, 10)
+#define FLEXCAN_CBT_EPSEG1_MASK		GENMASK(9, 5)
+#define FLEXCAN_CBT_EPSEG2_MASK		GENMASK(4, 0)
+
+/* FLEXCAN FD control register (FDCTRL) bits */
+#define FLEXCAN_FDCTRL_FDRATE		BIT(31)
+#define FLEXCAN_FDCTRL_MBDSR1		GENMASK(20, 19)
+#define FLEXCAN_FDCTRL_MBDSR0		GENMASK(17, 16)
+#define FLEXCAN_FDCTRL_MBDSR_8		0x0
+#define FLEXCAN_FDCTRL_MBDSR_12		0x1
+#define FLEXCAN_FDCTRL_MBDSR_32		0x2
+#define FLEXCAN_FDCTRL_MBDSR_64		0x3
+
+/* FLEXCAN FD Bit Timing register (FDCBT) bits */
+#define FLEXCAN_FDCBT_FPRESDIV_MASK	GENMASK(29, 20)
+#define FLEXCAN_FDCBT_FRJW_MASK		GENMASK(18, 16)
+#define FLEXCAN_FDCBT_FPROPSEG_MASK	GENMASK(14, 10)
+#define FLEXCAN_FDCBT_FPSEG1_MASK	GENMASK(7, 5)
+#define FLEXCAN_FDCBT_FPSEG2_MASK	GENMASK(2, 0)
+
 /* FLEXCAN interrupt flag register (IFLAG) bits */
 /* Errata ERR005829 step7: Reserve first valid MB */
 #define FLEXCAN_TX_MB_RESERVED_OFF_FIFO		8
@@ -161,6 +187,9 @@
 #define FLEXCAN_MB_CODE_TX_DATA		(0xc << 24)
 #define FLEXCAN_MB_CODE_TX_TANSWER	(0xe << 24)
 
+#define FLEXCAN_MB_CNT_EDL		BIT(31)
+#define FLEXCAN_MB_CNT_BRS		BIT(30)
+#define FLEXCAN_MB_CNT_ESI		BIT(29)
 #define FLEXCAN_MB_CNT_SRR		BIT(22)
 #define FLEXCAN_MB_CNT_IDE		BIT(21)
 #define FLEXCAN_MB_CNT_RTR		BIT(20)
@@ -201,6 +230,8 @@
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN BIT(7)
 /* Setup stop mode to support wakeup */
 #define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
+/* Support CAN-FD mode */
+#define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
 
 /* Structure of the message buffer */
 struct flexcan_mb {
@@ -356,6 +387,30 @@ static const struct can_bittiming_const flexcan_bittiming_const = {
 	.brp_inc = 1,
 };
 
+static const struct can_bittiming_const flexcan_fd_bittiming_const = {
+	.name = DRV_NAME,
+	.tseg1_min = 2,
+	.tseg1_max = 96,
+	.tseg2_min = 2,
+	.tseg2_max = 32,
+	.sjw_max = 16,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const flexcan_fd_data_bittiming_const = {
+	.name = DRV_NAME,
+	.tseg1_min = 2,
+	.tseg1_max = 39,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 1024,
+	.brp_inc = 1,
+};
+
 /* FlexCAN module is essentially modelled as a little-endian IP in most
  * SoCs, i.e the registers as well as the message buffer areas are
  * implemented in a little-endian fashion.
@@ -649,7 +704,7 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 	u32 can_id;
 	u32 data;
-	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | (cfd->len << 16);
+	u32 ctrl = FLEXCAN_MB_CODE_TX_DATA | ((can_len2dlc(cfd->len)) << 16);
 	int i;
 
 	if (can_dropped_invalid_skb(dev, skb))
@@ -667,6 +722,9 @@ static netdev_tx_t flexcan_start_xmit(struct sk_buff *skb, struct net_device *de
 	if (cfd->can_id & CAN_RTR_FLAG)
 		ctrl |= FLEXCAN_MB_CNT_RTR;
 
+	if (can_is_canfd_skb(skb))
+		ctrl |= FLEXCAN_MB_CNT_EDL;
+
 	for (i = 0; i < cfd->len; i += sizeof(u32)) {
 		data = be32_to_cpup((__be32 *)&cfd->data[i]);
 		priv->write(data, &priv->tx_mb->data[i / sizeof(u32)]);
@@ -877,7 +935,10 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		reg_ctrl = priv->read(&mb->can_ctrl);
 	}
 
-	skb = alloc_can_skb(offload->dev, (struct can_frame **)&cfd);
+	if (reg_ctrl & FLEXCAN_MB_CNT_EDL)
+		skb = alloc_canfd_skb(offload->dev, &cfd);
+	else
+		skb = alloc_can_skb(offload->dev, (struct can_frame **)&cfd);
 	if (unlikely(!skb)) {
 		skb = ERR_PTR(-ENOMEM);
 		goto mark_as_read;
@@ -892,9 +953,17 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	else
 		cfd->can_id = (reg_id >> 18) & CAN_SFF_MASK;
 
-	if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
-		cfd->can_id |= CAN_RTR_FLAG;
-	cfd->len = get_can_dlc((reg_ctrl >> 16) & 0xf);
+	if (reg_ctrl & FLEXCAN_MB_CNT_EDL) {
+		cfd->len = can_dlc2len(get_canfd_dlc((reg_ctrl >> 16) & 0xf));
+	} else {
+		cfd->len = get_can_dlc((reg_ctrl >> 16) & 0xf);
+
+		if (reg_ctrl & FLEXCAN_MB_CNT_RTR)
+			cfd->can_id |= CAN_RTR_FLAG;
+	}
+
+	if (reg_ctrl & FLEXCAN_MB_CNT_ESI)
+		cfd->flags |= CANFD_ESI;
 
 	for (i = 0; i < cfd->len; i += sizeof(u32)) {
 		__be32 data = cpu_to_be32(priv->read(&mb->data[i / sizeof(u32)]));
@@ -1065,6 +1134,83 @@ static void flexcan_set_bittiming_ctrl(const struct net_device *dev)
 		   priv->read(&regs->mcr), priv->read(&regs->ctrl));
 }
 
+static void flexcan_set_bittiming_cbt(const struct net_device *dev)
+{
+	struct flexcan_priv *priv = netdev_priv(dev);
+	struct can_bittiming *bt = &priv->can.bittiming;
+	struct can_bittiming *dbt = &priv->can.data_bittiming;
+	struct flexcan_regs __iomem *regs = priv->regs;
+	u32 reg_cbt, reg_fdctrl;
+
+	/* CBT */
+	/* CBT[EPSEG1] is 5 bit long and CBT[EPROPSEG] is 6 bit
+	 * long. The can_calc_bittiming() tries to divide the tseg1
+	 * equally between phase_seg1 and prop_seg, which may not fit
+	 * in CBT register. Therefore, if phase_seg1 is more than
+	 * possible value, increase prop_seg and decrease phase_seg1.
+	 */
+	if (bt->phase_seg1 > 0x20) {
+		bt->prop_seg += (bt->phase_seg1 - 0x20);
+		bt->phase_seg1 = 0x20;
+	}
+
+	reg_cbt = FLEXCAN_CBT_BTF |
+		FIELD_PREP(FLEXCAN_CBT_EPRESDIV_MASK, bt->brp - 1) |
+		FIELD_PREP(FLEXCAN_CBT_ERJW_MASK, bt->sjw - 1) |
+		FIELD_PREP(FLEXCAN_CBT_EPROPSEG_MASK, bt->prop_seg - 1) |
+		FIELD_PREP(FLEXCAN_CBT_EPSEG1_MASK, bt->phase_seg1 - 1) |
+		FIELD_PREP(FLEXCAN_CBT_EPSEG2_MASK, bt->phase_seg2 - 1);
+
+	netdev_dbg(dev, "writing cbt=0x%08x\n", reg_cbt);
+	priv->write(reg_cbt, &regs->cbt);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+		u32 reg_fdcbt;
+
+		if (bt->brp != dbt->brp)
+			netdev_warn(dev, "Data brp=%d and brp=%d don't match, this may result in a phase error. Consider using different bitrate and/or data bitrate.\n",
+				    dbt->brp, bt->brp);
+
+		/* FDCBT */
+		/* FDCBT[FPSEG1] is 3 bit long and FDCBT[FPROPSEG] is
+		 * 5 bit long. The can_calc_bittiming tries to divide
+		 * the tseg1 equally between phase_seg1 and prop_seg,
+		 * which may not fit in FDCBT register. Therefore, if
+		 * phase_seg1 is more than possible value, increase
+		 * prop_seg and decrease phase_seg1
+		 */
+		if (dbt->phase_seg1 > 0x8) {
+			dbt->prop_seg += (dbt->phase_seg1 - 0x8);
+			dbt->phase_seg1 = 0x8;
+		}
+
+		reg_fdcbt = FIELD_PREP(FLEXCAN_FDCBT_FPRESDIV_MASK, dbt->brp - 1) |
+			FIELD_PREP(FLEXCAN_FDCBT_FRJW_MASK, dbt->sjw - 1) |
+			FIELD_PREP(FLEXCAN_FDCBT_FPROPSEG_MASK, dbt->prop_seg) |
+			FIELD_PREP(FLEXCAN_FDCBT_FPSEG1_MASK, dbt->phase_seg1 - 1) |
+			FIELD_PREP(FLEXCAN_FDCBT_FPSEG2_MASK, dbt->phase_seg2 - 1);
+
+		netdev_dbg(dev, "writing fdcbt=0x%08x\n", reg_fdcbt);
+		priv->write(reg_fdcbt, &regs->fdcbt);
+	}
+
+	/* FDCTRL */
+	reg_fdctrl = priv->read(&regs->fdctrl);
+	reg_fdctrl &= ~FLEXCAN_FDCTRL_FDRATE;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		reg_fdctrl |= FLEXCAN_FDCTRL_FDRATE;
+
+	netdev_dbg(dev, "writing fdctrl=0x%08x\n", reg_fdctrl);
+	priv->write(reg_fdctrl, &regs->fdctrl);
+
+	netdev_dbg(dev, "%s: mcr=0x%08x ctrl=0x%08x fdctrl=0x%08x cbt=0x%08x fdcbt=0x%08x\n",
+		   __func__,
+		   priv->read(&regs->mcr), priv->read(&regs->ctrl),
+		   priv->read(&regs->fdctrl), priv->read(&regs->cbt),
+		   priv->read(&regs->fdcbt));
+}
+
 static void flexcan_set_bittiming(struct net_device *dev)
 {
 	const struct flexcan_priv *priv = netdev_priv(dev);
@@ -1085,7 +1231,10 @@ static void flexcan_set_bittiming(struct net_device *dev)
 	netdev_dbg(dev, "writing ctrl=0x%08x\n", reg);
 	priv->write(reg, &regs->ctrl);
 
-	return flexcan_set_bittiming_ctrl(dev);
+	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD)
+		return flexcan_set_bittiming_cbt(dev);
+	else
+		return flexcan_set_bittiming_ctrl(dev);
 }
 
 /* flexcan_chip_start
@@ -1158,6 +1307,12 @@ static int flexcan_chip_start(struct net_device *dev)
 	else
 		reg_mcr |= FLEXCAN_MCR_SRX_DIS;
 
+	/* MCR - CAN-FD */
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		reg_mcr |= FLEXCAN_MCR_FDEN;
+	else
+		reg_mcr &= ~FLEXCAN_MCR_FDEN;
+
 	netdev_dbg(dev, "%s: writing mcr=0x%08x", __func__, reg_mcr);
 	priv->write(reg_mcr, &regs->mcr);
 
@@ -1200,6 +1355,32 @@ static int flexcan_chip_start(struct net_device *dev)
 		priv->write(reg_ctrl2, &regs->ctrl2);
 	}
 
+	if (priv->can.ctrlmode_supported & CAN_CTRLMODE_FD) {
+		u32 reg_fdctrl;
+
+		reg_fdctrl = priv->read(&regs->fdctrl);
+		reg_fdctrl &= ~(FIELD_PREP(FLEXCAN_FDCTRL_MBDSR1, 0x3) |
+				FIELD_PREP(FLEXCAN_FDCTRL_MBDSR0, 0x3));
+
+		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+			reg_fdctrl |=
+				FIELD_PREP(FLEXCAN_FDCTRL_MBDSR1,
+					   FLEXCAN_FDCTRL_MBDSR_64) |
+				FIELD_PREP(FLEXCAN_FDCTRL_MBDSR0,
+					   FLEXCAN_FDCTRL_MBDSR_64);
+		} else {
+			reg_fdctrl |=
+				FIELD_PREP(FLEXCAN_FDCTRL_MBDSR1,
+					   FLEXCAN_FDCTRL_MBDSR_8) |
+				FIELD_PREP(FLEXCAN_FDCTRL_MBDSR0,
+					   FLEXCAN_FDCTRL_MBDSR_8);
+		}
+
+		netdev_dbg(dev, "%s: writing fdctrl=0x%08x",
+			   __func__, reg_fdctrl);
+		priv->write(reg_fdctrl, &regs->fdctrl);
+	}
+
 	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP) {
 		for (i = priv->offload.mb_first; i <= priv->offload.mb_last; i++) {
 			mb = flexcan_get_mb(priv, i);
@@ -1356,6 +1537,12 @@ static int flexcan_open(struct net_device *dev)
 	struct flexcan_priv *priv = netdev_priv(dev);
 	int err;
 
+	if ((priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES) &&
+	    (priv->can.ctrlmode & CAN_CTRLMODE_FD)) {
+		netdev_err(dev, "Three Samples mode and CAN-FD mode can't be used together\n");
+		return -EINVAL;
+	}
+
 	err = pm_runtime_get_sync(priv->dev);
 	if (err < 0)
 		return err;
@@ -1368,7 +1555,10 @@ static int flexcan_open(struct net_device *dev)
 	if (err)
 		goto out_close;
 
-	priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD)
+		priv->mb_size = sizeof(struct flexcan_mb) + CANFD_MAX_DLEN;
+	else
+		priv->mb_size = sizeof(struct flexcan_mb) + CAN_MAX_DLEN;
 	priv->mb_count = (sizeof(priv->regs->mb[0]) / priv->mb_size) +
 			 (sizeof(priv->regs->mb[1]) / priv->mb_size);
 
@@ -1678,6 +1868,12 @@ static int flexcan_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if ((devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) &&
+	    !(devtype_data->quirks & FLEXCAN_QUIRK_USE_OFF_TIMESTAMP)) {
+		dev_err(&pdev->dev, "CAN-FD mode doesn't work with FIFO mode!\n");
+		return -EINVAL;
+	}
+
 	dev = alloc_candev(sizeof(struct flexcan_priv), 1);
 	if (!dev)
 		return -ENOMEM;
@@ -1702,7 +1898,6 @@ static int flexcan_probe(struct platform_device *pdev)
 
 	priv->dev = &pdev->dev;
 	priv->can.clock.freq = clock_freq;
-	priv->can.bittiming_const = &flexcan_bittiming_const;
 	priv->can.do_set_mode = flexcan_set_mode;
 	priv->can.do_get_berr_counter = flexcan_get_berr_counter;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_LOOPBACK |
@@ -1715,6 +1910,15 @@ static int flexcan_probe(struct platform_device *pdev)
 	priv->devtype_data = devtype_data;
 	priv->reg_xceiver = reg_xceiver;
 
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SUPPORT_FD) {
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		priv->can.bittiming_const = &flexcan_fd_bittiming_const;
+		priv->can.data_bittiming_const =
+			&flexcan_fd_data_bittiming_const;
+	} else {
+		priv->can.bittiming_const = &flexcan_bittiming_const;
+	}
+
 	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
-- 
2.28.0

