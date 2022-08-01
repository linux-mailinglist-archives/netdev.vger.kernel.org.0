Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5A4587086
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiHASsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbiHASst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:48:49 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FAE25293;
        Mon,  1 Aug 2022 11:48:46 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc17b.ng.seznam.cz (email-smtpc17b.ng.seznam.cz [10.23.18.19])
        id 26cb56b5c267858b2716f7db;
        Mon, 01 Aug 2022 20:47:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659379677; bh=B4VNA/M2+dEgBP36aFOCVXeofL1v12Q6JysAXHnSN/8=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:X-szn-frgn:
         X-szn-frgc;
        b=a5wv6+asNqXkOY8ss0N7ytfS3Zrr87ETopzSWb6du/4X6xE+0qsp2JmwDg7Ewnnfq
         7A6of0a4ZpM8BdkPJZr1bvTO4IF/2Mll4FJdn34AgAXGLC6C815+rU94tbV97UbdkS
         MvcjKEz+SPgo+KZAeMrSr/77TIEzz79GPDw1vcvE=
Received: from localhost.localdomain (2a02:8308:900d:2400:95cc:114a:1ae8:6a72 [2a02:8308:900d:2400:95cc:114a:1ae8:6a72])
        by email-relay1.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 01 Aug 2022 20:47:54 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v2 1/3] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Mon,  1 Aug 2022 20:46:54 +0200
Message-Id: <20220801184656.702930-2-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
References: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <504437a8-5c6b-4993-9004-1c51a8731506>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for retrieving hardware timestamps to RX and
error CAN frames. It uses timecounter and cyclecounter structures,
because the timestamping counter width depends on the IP core integration
(it might not always be 64-bit).
For platform devices, you should specify "ts_clk" clock in device tree.
For PCI devices, the timestamping frequency is assumed to be the same
as bus frequency.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 +++++++++++++++++-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
 4 files changed, 315 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c

diff --git a/drivers/net/can/ctucanfd/Makefile b/drivers/net/can/ctucanfd/Makefile
index 8078f1f2c30f..a36e66f2cea7 100644
--- a/drivers/net/can/ctucanfd/Makefile
+++ b/drivers/net/can/ctucanfd/Makefile
@@ -4,7 +4,7 @@
 #
 
 obj-$(CONFIG_CAN_CTUCANFD) := ctucanfd.o
-ctucanfd-y := ctucanfd_base.o
+ctucanfd-y := ctucanfd_base.o ctucanfd_timestamp.o
 
 obj-$(CONFIG_CAN_CTUCANFD_PCI) += ctucanfd_pci.o
 obj-$(CONFIG_CAN_CTUCANFD_PLATFORM) += ctucanfd_platform.o
diff --git a/drivers/net/can/ctucanfd/ctucanfd.h b/drivers/net/can/ctucanfd/ctucanfd.h
index 0e9904f6a05d..43d9c73ce244 100644
--- a/drivers/net/can/ctucanfd/ctucanfd.h
+++ b/drivers/net/can/ctucanfd/ctucanfd.h
@@ -23,6 +23,10 @@
 #include <linux/netdevice.h>
 #include <linux/can/dev.h>
 #include <linux/list.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
+
+#define CTUCANFD_MAX_WORK_DELAY_SEC 86400U	/* one day == 24 * 3600 seconds */
 
 enum ctu_can_fd_can_registers;
 
@@ -51,6 +55,15 @@ struct ctucan_priv {
 	u32 rxfrm_first_word;
 
 	struct list_head peers_on_pdev;
+
+	struct cyclecounter cc;
+	struct timecounter tc;
+	struct delayed_work timestamp;
+
+	struct clk *timestamp_clk;
+	u32 work_delay_jiffies;
+	bool timestamp_enabled;
+	bool timestamp_possible;
 };
 
 /**
@@ -79,4 +92,11 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr,
 int ctucan_suspend(struct device *dev) __maybe_unused;
 int ctucan_resume(struct device *dev) __maybe_unused;
 
+u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc);
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv);
+u32 ctucan_calculate_work_delay(const u32 timestamp_bit_size, const u32 timestamp_freq);
+void ctucan_skb_set_timestamp(const struct ctucan_priv *priv, struct sk_buff *skb,
+			      u64 timestamp);
+void ctucan_timestamp_init(struct ctucan_priv *priv);
+void ctucan_timestamp_stop(struct ctucan_priv *priv);
 #endif /*__CTUCANFD__*/
diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 3c18d028bd8c..35b37de51811 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -18,6 +18,7 @@
  ******************************************************************************/
 
 #include <linux/clk.h>
+#include <linux/clocksource.h>
 #include <linux/errno.h>
 #include <linux/ethtool.h>
 #include <linux/init.h>
@@ -148,6 +149,27 @@ static void ctucan_write_txt_buf(struct ctucan_priv *priv, enum ctu_can_fd_can_r
 	priv->write_reg(priv, buf_base + offset, val);
 }
 
+static u64 concatenate_two_u32(u32 high, u32 low)
+{
+	return ((u64)high << 32) | ((u64)low);
+}
+
+u64 ctucan_read_timestamp_counter(struct ctucan_priv *priv)
+{
+	u32 ts_low;
+	u32 ts_high;
+	u32 ts_high2;
+
+	ts_high = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+	ts_low = ctucan_read32(priv, CTUCANFD_TIMESTAMP_LOW);
+	ts_high2 = ctucan_read32(priv, CTUCANFD_TIMESTAMP_HIGH);
+
+	if (ts_high2 != ts_high)
+		ts_low = priv->read_reg(priv, CTUCANFD_TIMESTAMP_LOW);
+
+	return concatenate_two_u32(ts_high2, ts_low) & priv->cc.mask;
+}
+
 #define CTU_CAN_FD_TXTNF(priv) (!!FIELD_GET(REG_STATUS_TXNF, ctucan_read32(priv, CTUCANFD_STATUS)))
 #define CTU_CAN_FD_ENABLED(priv) (!!FIELD_GET(REG_MODE_ENA, ctucan_read32(priv, CTUCANFD_MODE)))
 
@@ -640,12 +662,16 @@ static netdev_tx_t ctucan_start_xmit(struct sk_buff *skb, struct net_device *nde
  * @priv:	Pointer to CTU CAN FD's private data
  * @cf:		Pointer to CAN frame struct
  * @ffw:	Previously read frame format word
+ * @skb:	Pointer to buffer to store timestamp
  *
  * Note: Frame format word must be read separately and provided in 'ffw'.
  */
-static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf, u32 ffw)
+static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *cf,
+				 u32 ffw, u64 *timestamp)
 {
 	u32 idw;
+	u32 tstamp_high;
+	u32 tstamp_low;
 	unsigned int i;
 	unsigned int wc;
 	unsigned int len;
@@ -682,9 +708,10 @@ static void ctucan_read_rx_frame(struct ctucan_priv *priv, struct canfd_frame *c
 	if (unlikely(len > wc * 4))
 		len = wc * 4;
 
-	/* Timestamp - Read and throw away */
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
-	ctucan_read32(priv, CTUCANFD_RX_DATA);
+	/* Timestamp */
+	tstamp_low = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	tstamp_high = ctucan_read32(priv, CTUCANFD_RX_DATA);
+	*timestamp = concatenate_two_u32(tstamp_high, tstamp_low) & priv->cc.mask;
 
 	/* Data */
 	for (i = 0; i < len; i += 4) {
@@ -713,6 +740,7 @@ static int ctucan_rx(struct net_device *ndev)
 	struct net_device_stats *stats = &ndev->stats;
 	struct canfd_frame *cf;
 	struct sk_buff *skb;
+	u64 timestamp;
 	u32 ffw;
 
 	if (test_bit(CTUCANFD_FLAG_RX_FFW_BUFFERED, &priv->drv_flags)) {
@@ -736,7 +764,9 @@ static int ctucan_rx(struct net_device *ndev)
 		return 0;
 	}
 
-	ctucan_read_rx_frame(priv, cf, ffw);
+	ctucan_read_rx_frame(priv, cf, ffw, &timestamp);
+	if (priv->timestamp_enabled)
+		ctucan_skb_set_timestamp(priv, skb, timestamp);
 
 	stats->rx_bytes += cf->len;
 	stats->rx_packets++;
@@ -906,6 +936,11 @@ static void ctucan_err_interrupt(struct net_device *ndev, u32 isr)
 	if (skb) {
 		stats->rx_packets++;
 		stats->rx_bytes += cf->can_dlc;
+		if (priv->timestamp_enabled) {
+			u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+			ctucan_skb_set_timestamp(priv, skb, tstamp);
+		}
 		netif_rx(skb);
 	}
 }
@@ -951,6 +986,11 @@ static int ctucan_rx_poll(struct napi_struct *napi, int quota)
 			cf->data[1] |= CAN_ERR_CRTL_RX_OVERFLOW;
 			stats->rx_packets++;
 			stats->rx_bytes += cf->can_dlc;
+			if (priv->timestamp_enabled) {
+				u64 tstamp = ctucan_read_timestamp_counter(priv);
+
+				ctucan_skb_set_timestamp(priv, skb, tstamp);
+			}
 			netif_rx(skb);
 		}
 
@@ -1231,6 +1271,9 @@ static int ctucan_open(struct net_device *ndev)
 		goto err_chip_start;
 	}
 
+	if (priv->timestamp_possible)
+		ctucan_timestamp_init(priv);
+
 	netdev_info(ndev, "ctu_can_fd device registered\n");
 	napi_enable(&priv->napi);
 	netif_start_queue(ndev);
@@ -1263,6 +1306,9 @@ static int ctucan_close(struct net_device *ndev)
 	ctucan_chip_stop(ndev);
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
+	if (priv->timestamp_possible)
+		ctucan_timestamp_stop(priv);
+
 
 	pm_runtime_put(priv->dev);
 
@@ -1295,15 +1341,117 @@ static int ctucan_get_berr_counter(const struct net_device *ndev, struct can_ber
 	return 0;
 }
 
+static int ctucan_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ctucan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (!priv->timestamp_possible)
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
+		priv->timestamp_enabled = false;
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
+		priv->timestamp_enabled = true;
+		cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int ctucan_hwtstamp_get(struct net_device *dev, struct ifreq *ifr)
+{
+	struct ctucan_priv *priv = netdev_priv(dev);
+	struct hwtstamp_config cfg;
+
+	if (!priv->timestamp_possible)
+		return -EOPNOTSUPP;
+
+	cfg.flags = 0;
+	cfg.tx_type = HWTSTAMP_TX_OFF;
+	cfg.rx_filter = priv->timestamp_enabled ? HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE;
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static int ctucan_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+{
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ctucan_hwtstamp_set(dev, ifr);
+	case SIOCGHWTSTAMP:
+		return ctucan_hwtstamp_get(dev, ifr);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int ctucan_ethtool_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
+{
+	struct ctucan_priv *priv = netdev_priv(ndev);
+
+	ethtool_op_get_ts_info(ndev, info);
+
+	if (!priv->timestamp_possible)
+		return 0;
+
+	info->so_timestamping |= SOF_TIMESTAMPING_RX_HARDWARE |
+				 SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) |
+			   BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
 static const struct net_device_ops ctucan_netdev_ops = {
 	.ndo_open	= ctucan_open,
 	.ndo_stop	= ctucan_close,
 	.ndo_start_xmit	= ctucan_start_xmit,
 	.ndo_change_mtu	= can_change_mtu,
+	.ndo_eth_ioctl	= ctucan_ioctl,
 };
 
 static const struct ethtool_ops ctucan_ethtool_ops = {
-	.get_ts_info = ethtool_op_get_ts_info,
+	.get_ts_info = ctucan_ethtool_get_ts_info,
 };
 
 int ctucan_suspend(struct device *dev)
@@ -1345,6 +1493,8 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 	struct ctucan_priv *priv;
 	struct net_device *ndev;
 	int ret;
+	u32 timestamp_freq = 0;
+	u32 timestamp_bit_size = 0;
 
 	/* Create a CAN device instance */
 	ndev = alloc_candev(sizeof(struct ctucan_priv), ntxbufs);
@@ -1386,7 +1536,9 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	/* Getting the can_clk info */
 	if (!can_clk_rate) {
-		priv->can_clk = devm_clk_get(dev, NULL);
+		priv->can_clk = devm_clk_get_optional(dev, "core-clk");
+		if (!priv->can_clk)
+			priv->can_clk = devm_clk_get(dev, NULL);
 		if (IS_ERR(priv->can_clk)) {
 			dev_err(dev, "Device clock not found.\n");
 			ret = PTR_ERR(priv->can_clk);
@@ -1425,6 +1577,54 @@ int ctucan_probe_common(struct device *dev, void __iomem *addr, int irq, unsigne
 
 	priv->can.clock.freq = can_clk_rate;
 
+	priv->timestamp_enabled = false;
+	priv->timestamp_possible = true;
+	priv->timestamp_clk = NULL;
+
+	/* Obtain timestamping frequency */
+	if (pm_enable_call) {
+		/* Plaftorm device: get tstamp clock from device tree */
+		priv->timestamp_clk = devm_clk_get(dev, "ts-clk");
+		if (IS_ERR(priv->timestamp_clk)) {
+			/* Take the core clock frequency instead */
+			timestamp_freq = can_clk_rate;
+		} else {
+			timestamp_freq = clk_get_rate(priv->timestamp_clk);
+		}
+	} else {
+		/* PCI device: assume tstamp freq is equal to bus clk rate */
+		timestamp_freq = can_clk_rate;
+	}
+
+	/* Obtain timestamping counter bit size */
+	timestamp_bit_size = (ctucan_read32(priv, CTUCANFD_ERR_CAPT) & REG_ERR_CAPT_TS_BITS) >> 24;
+	timestamp_bit_size += 1;	/* the register value was bit_size - 1 */
+
+	/* For 2.x versions of the IP core, we will assume 64-bit counter
+	 * if there was a 0 in the register.
+	 */
+	if (timestamp_bit_size == 1) {
+		u32 version_reg = ctucan_read32(priv, CTUCANFD_DEVICE_ID);
+		u32 major = (version_reg & REG_DEVICE_ID_VER_MAJOR) >> 24;
+
+		if (major == 2)
+			timestamp_bit_size = 64;
+		else
+			priv->timestamp_possible = false;
+	}
+
+	/* Setup conversion constants and work delay */
+	priv->cc.read = ctucan_read_timestamp_cc_wrapper;
+	priv->cc.mask = CYCLECOUNTER_MASK(timestamp_bit_size);
+	if (priv->timestamp_possible) {
+		clocks_calc_mult_shift(&priv->cc.mult, &priv->cc.shift, timestamp_freq,
+				       NSEC_PER_SEC, CTUCANFD_MAX_WORK_DELAY_SEC);
+		priv->work_delay_jiffies =
+			ctucan_calculate_work_delay(timestamp_bit_size, timestamp_freq);
+		if (priv->work_delay_jiffies == 0)
+			priv->timestamp_possible = false;
+	}
+
 	netif_napi_add(ndev, &priv->napi, ctucan_rx_poll, NAPI_POLL_WEIGHT);
 
 	ret = register_candev(ndev);
diff --git a/drivers/net/can/ctucanfd/ctucanfd_timestamp.c b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
new file mode 100644
index 000000000000..c802123bbfbb
--- /dev/null
+++ b/drivers/net/can/ctucanfd/ctucanfd_timestamp.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*******************************************************************************
+ *
+ * CTU CAN FD IP Core
+ *
+ * Copyright (C) 2022 Matej Vasilevski <matej.vasilevski@seznam.cz> FEE CTU
+ *
+ * Project advisors:
+ *     Jiri Novak <jnovak@fel.cvut.cz>
+ *     Pavel Pisa <pisa@cmp.felk.cvut.cz>
+ *
+ * Department of Measurement         (http://meas.fel.cvut.cz/)
+ * Faculty of Electrical Engineering (http://www.fel.cvut.cz)
+ * Czech Technical University        (http://www.cvut.cz/)
+ ******************************************************************************/
+
+#include "vdso/time64.h"
+#include <linux/bitops.h>
+#include <linux/clocksource.h>
+#include <linux/math64.h>
+#include <linux/timecounter.h>
+#include <linux/workqueue.h>
+
+#include "ctucanfd.h"
+#include "ctucanfd_kregs.h"
+
+u64 ctucan_read_timestamp_cc_wrapper(const struct cyclecounter *cc)
+{
+	struct ctucan_priv *priv;
+
+	priv = container_of(cc, struct ctucan_priv, cc);
+	return ctucan_read_timestamp_counter(priv);
+}
+
+static void ctucan_timestamp_work(struct work_struct *work)
+{
+	struct delayed_work *delayed_work = to_delayed_work(work);
+	struct ctucan_priv *priv;
+
+	priv = container_of(delayed_work, struct ctucan_priv, timestamp);
+	timecounter_read(&priv->tc);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+}
+
+u32 ctucan_calculate_work_delay(const u32 timestamp_bit_size, const u32 timestamp_freq)
+{
+	u32 jiffies_order = fls(HZ);
+	u32 max_shift_left = 63 - jiffies_order;
+	s32 final_shift = (timestamp_bit_size - 1) - max_shift_left;
+	u64 work_delay_jiffies;
+
+	/* The formula is work_delay_jiffies = 2**(bit_size - 1) / ts_frequency * HZ
+	 * using (bit_size - 1) instead of full bit_size to read the counter
+	 * roughly twice per period
+	 */
+	work_delay_jiffies = div_u64((u64)HZ << max_shift_left, timestamp_freq);
+
+	if (final_shift > 0)
+		work_delay_jiffies = work_delay_jiffies << final_shift;
+	else
+		work_delay_jiffies = work_delay_jiffies >> -final_shift;
+
+	work_delay_jiffies = min(work_delay_jiffies,
+				 (unsigned long long)CTUCANFD_MAX_WORK_DELAY_SEC * HZ);
+	return (u32)work_delay_jiffies;
+}
+
+void ctucan_skb_set_timestamp(const struct ctucan_priv *priv, struct sk_buff *skb, u64 timestamp)
+{
+	struct skb_shared_hwtstamps *hwtstamps = skb_hwtstamps(skb);
+	u64 ns;
+
+	ns = timecounter_cyc2time(&priv->tc, timestamp);
+	hwtstamps->hwtstamp = ns_to_ktime(ns);
+}
+
+void ctucan_timestamp_init(struct ctucan_priv *priv)
+{
+	timecounter_init(&priv->tc, &priv->cc, ktime_get_real_ns());
+	INIT_DELAYED_WORK(&priv->timestamp, ctucan_timestamp_work);
+	schedule_delayed_work(&priv->timestamp, priv->work_delay_jiffies);
+}
+
+void ctucan_timestamp_stop(struct ctucan_priv *priv)
+{
+	cancel_delayed_work_sync(&priv->timestamp);
+}
-- 
2.25.1

