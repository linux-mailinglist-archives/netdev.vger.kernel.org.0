Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D48C1576DB7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 14:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiGPMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 08:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGPMJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 08:09:33 -0400
X-Greylist: delayed 203 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 16 Jul 2022 05:09:30 PDT
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE4913CDD;
        Sat, 16 Jul 2022 05:09:29 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc29a.ng.seznam.cz (email-smtpc29a.ng.seznam.cz [10.23.18.42])
        id 730cc56697a0165872d16408;
        Sat, 16 Jul 2022 14:09:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1657973368; bh=XYu56n9XHgWjNR6No+oO+feJy36LToPiGP7tHG52ML0=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:X-szn-frgn:X-szn-frgc;
        b=GP4Kp9JwMsIux7Rmzp4+lcY+wIkwWmjlYa0Qh6nmxsK6F3j40AB3Q/U40VA8NnHP6
         vM3CpqDurvVrsbccIxmeeJVLT4uNrEgQu0NPxyUekZgSpDaZoX5BNGtbEInUoErAaI
         oNihRlzkxLMLIPwyqIeNFtS0w/puZ+QSeWPbgZcU=
Received: from localhost.localdomain (2a02:8308:900d:2400:1ed6:b9cb:54c9:767 [2a02:8308:900d:2400:1ed6:b9cb:54c9:767])
        by email-relay10.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Sat, 16 Jul 2022 14:05:47 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>,
        Martin Jerabek <martin.jerabek01@gmail.com>
Subject: [PATCH] can: xilinx_can: add support for RX timestamps on Zynq
Date:   Sat, 16 Jul 2022 14:04:09 +0200
Message-Id: <20220716120408.450405-1-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <96685b1d-cc65-4703-9144-318c95f84ba9>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for hardware RX timestamps from Xilinx Zynq CAN
controllers. The timestamp is calculated against a timepoint reference
stored when the first CAN message is received.

When CAN bus traffic does not contain long idle pauses (so that
the clocks would drift by a multiple of the counter rollover time),
then the hardware timestamps provide precise relative time between
received messages. This can be used e.g. for latency testing.

Co-authored-by: Martin Jerabek <martin.jerabek01@gmail.com>
Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 drivers/net/can/xilinx_can.c | 171 ++++++++++++++++++++++++++++++++++-
 1 file changed, 168 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 393b2d9f9d2a..12e3ca856684 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -11,11 +11,14 @@
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
+#include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include "linux/ktime.h"
+#include "linux/math64.h"
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
@@ -165,6 +168,10 @@ enum xcan_reg {
 #define XCAN_FLAG_RX_FIFO_MULTI	0x0010
 #define XCAN_FLAG_CANFD_2	0x0020
 
+#define XCAN_ZYNQ_TSTAMP_BITS	16
+#define XCAN_ZYNQ_TSTAMP_BIT_MASK	GENMASK(15, 0)
+#define XCAN_ZYNQ_TSTAMP_MAX_VAL	BIT(XCAN_ZYNQ_TSTAMP_BITS)
+
 enum xcan_ip_type {
 	XAXI_CAN = 0,
 	XZYNQ_CANPS,
@@ -181,6 +188,11 @@ struct xcan_devtype_data {
 	unsigned int btr_sjw_shift;
 };
 
+struct xcan_timepoint {
+	u64 ktime_ns;
+	u16 ts;
+};
+
 /**
  * struct xcan_priv - This definition define CAN driver instance
  * @can:			CAN private data structure.
@@ -197,6 +209,11 @@ struct xcan_devtype_data {
  * @bus_clk:			Pointer to struct clk
  * @can_clk:			Pointer to struct clk
  * @devtype:			Device type specific constants
+ * @ref_timepoint:		Reference timepoint for synchronizing ktime with HW ticks
+ * @tstamp_rollover_ns:		Timestamping counter rollover time in nanoseconds
+ * @cantime2ns_mul:		Mult. constant for converting from counter time to nanoseconds
+ * @cantime2ns_shr:		Right shift for converting from counter time to nanoseconds
+ * @rx_timestamps_enabled:	Boolean flag indicating whether rx timestamps should be computed
  */
 struct xcan_priv {
 	struct can_priv can;
@@ -214,6 +231,11 @@ struct xcan_priv {
 	struct clk *bus_clk;
 	struct clk *can_clk;
 	struct xcan_devtype_data devtype;
+	struct xcan_timepoint ref_timepoint;
+	u64 tstamp_rollover_ns;
+	u32 cantime2ns_mul;
+	u32 cantime2ns_shr;
+	bool rx_timestamps_enabled;
 };
 
 /* CAN Bittiming constants as per Xilinx CAN specs */
@@ -759,6 +781,50 @@ static netdev_tx_t xcan_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
+/**
+ * xcan_timestamp_to_ktime - Converts the hardware timestamp to ktime timestamp
+ * @priv:	Driver private data structure
+ * @ts:		Timestamp from the hardware counter
+ *
+ * Calculating the frame ktime using rollover count and initial timepoint
+ * reference allows to have constant delay between the moment the frame is
+ * timestamped in hardware, and the timestamp reported by the driver.
+ * When CAN bus traffic does not contain long idle pauses (so that the clocks
+ * would drift by a multiple of the counter rollover time), then timestamps
+ * provide precise relative time between received messages.
+ *
+ * Return: hardware timestamp in ktime
+ */
+static ktime_t xcan_timestamp_to_ktime(struct xcan_priv *priv, u16 ts)
+{
+	struct xcan_timepoint *ref = &priv->ref_timepoint;
+	u64 ktime_now_ns;
+	u64 ktime_diff_ns;
+	u16 tstamp_diff;
+	u64 tstamp_diff_ns;
+	u64 time_diff_ns;
+	u64 rollover_count;
+
+	ktime_now_ns = ktime_get_real_ns();
+	if (ref->ktime_ns == 0) {
+		/* first received frame */
+		ref->ktime_ns = ktime_now_ns;
+		ref->ts = ts;
+		return ns_to_ktime(ktime_now_ns);
+	}
+
+	tstamp_diff = ts > ref->ts ? ts - ref->ts : ref->ts - ts;
+	tstamp_diff_ns = mul_u32_u32((u32)tstamp_diff, priv->cantime2ns_mul)
+			 >> priv->cantime2ns_shr;
+	ktime_diff_ns = ktime_now_ns - ref->ktime_ns;
+	time_diff_ns = ktime_diff_ns - tstamp_diff_ns;
+	rollover_count = div_u64(time_diff_ns + (priv->tstamp_rollover_ns / 2),
+				 priv->tstamp_rollover_ns);
+
+	return ns_to_ktime(tstamp_diff_ns + rollover_count * priv->tstamp_rollover_ns)
+	       + ref->ktime_ns;
+}
+
 /**
  * xcan_rx -  Is called from CAN isr to complete the received
  *		frame  processing
@@ -776,7 +842,8 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 	struct net_device_stats *stats = &ndev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
-	u32 id_xcan, dlc, data[2] = {0, 0};
+	struct skb_shared_hwtstamps *hwts;
+	u32 id_xcan, dlc_reg, dlc, rawts, data[2] = {0, 0};
 
 	skb = alloc_can_skb(ndev, &cf);
 	if (unlikely(!skb)) {
@@ -786,12 +853,19 @@ static int xcan_rx(struct net_device *ndev, int frame_base)
 
 	/* Read a frame from Xilinx zynq CANPS */
 	id_xcan = priv->read_reg(priv, XCAN_FRAME_ID_OFFSET(frame_base));
-	dlc = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base)) >>
-				   XCAN_DLCR_DLC_SHIFT;
+	dlc_reg = priv->read_reg(priv, XCAN_FRAME_DLC_OFFSET(frame_base));
+	dlc = dlc_reg >> XCAN_DLCR_DLC_SHIFT;
 
 	/* Change Xilinx CAN data length format to socketCAN data format */
 	cf->len = can_cc_dlc2len(dlc);
 
+	if (priv->rx_timestamps_enabled) {
+		hwts = skb_hwtstamps(skb);
+		memset(hwts, 0, sizeof(*hwts));
+		rawts = dlc_reg & XCAN_ZYNQ_TSTAMP_BIT_MASK;
+		hwts->hwtstamp = xcan_timestamp_to_ktime(priv, rawts);
+	}
+
 	/* Change Xilinx CAN ID format to socketCAN ID format */
 	if (id_xcan & XCAN_IDR_IDE_MASK) {
 		/* The received frame is an Extended format frame */
@@ -1532,11 +1606,95 @@ static int xcan_get_auto_tdcv(const struct net_device *ndev, u32 *tdcv)
 	return 0;
 }
 
+static int xcan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	struct xcan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (priv->devtype.cantype != XZYNQ_CANPS)
+		return -EOPNOTSUPP;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags)
+		return -EINVAL;
+
+	if (cfg.tx_type != HWTSTAMP_TX_OFF)
+		return -ERANGE;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		priv->rx_timestamps_enabled = false;
+		break;
+	case HWTSTAMP_FILTER_ALL:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+		fallthrough;
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		priv->rx_timestamps_enabled = true;
+		cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int xcan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct xcan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (priv->devtype.cantype != XZYNQ_CANPS)
+		return -EOPNOTSUPP;
+
+	cfg.flags = 0;
+	cfg.tx_type = HWTSTAMP_TX_OFF;
+	cfg.rx_filter = priv->rx_timestamps_enabled ? HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int xcan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return xcan_hwtstamp_set(dev, ifr);
+	case SIOCGHWTSTAMP:
+		return xcan_hwtstamp_get(dev, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops xcan_netdev_ops = {
 	.ndo_open	= xcan_open,
 	.ndo_stop	= xcan_close,
 	.ndo_start_xmit	= xcan_start_xmit,
 	.ndo_change_mtu	= can_change_mtu,
+	.ndo_eth_ioctl	= xcan_ioctl,
 };
 
 /**
@@ -1854,6 +2012,13 @@ static int xcan_probe(struct platform_device *pdev)
 
 	priv->can.clock.freq = clk_get_rate(priv->can_clk);
 
+	clocks_calc_mult_shift(&priv->cantime2ns_mul, &priv->cantime2ns_shr,
+			       priv->can.clock.freq, NSEC_PER_SEC, 0);
+	priv->rx_timestamps_enabled = false;
+	priv->tstamp_rollover_ns = mul_u32_u32((u32)XCAN_ZYNQ_TSTAMP_MAX_VAL, priv->cantime2ns_mul)
+				   >> priv->cantime2ns_shr;
+	memset(&priv->ref_timepoint, 0, sizeof(priv->ref_timepoint));
+
 	netif_napi_add_weight(ndev, &priv->napi, xcan_rx_poll, rx_max);
 
 	ret = register_candev(ndev);

base-commit: 874bdbfe624e577687c2053a26aab44715c68453
-- 
2.25.1

