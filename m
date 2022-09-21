Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B615BF9CB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiIUItC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiIUIso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:48:44 -0400
Received: from relmlie5.idc.renesas.com (relmlor1.renesas.com [210.160.252.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6958B786EE;
        Wed, 21 Sep 2022 01:48:42 -0700 (PDT)
X-IronPort-AV: E=Sophos;i="5.93,332,1654527600"; 
   d="scan'208";a="133517198"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 21 Sep 2022 17:48:39 +0900
Received: from localhost.localdomain (unknown [10.166.15.32])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 584F441D879A;
        Wed, 21 Sep 2022 17:48:39 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     kishon@ti.com, vkoul@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, geert+renesas@glider.be
Cc:     andrew@lunn.ch, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 6/8] net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support
Date:   Wed, 21 Sep 2022 17:47:43 +0900
Message-Id: <20220921084745.3355107-7-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
References: <20220921084745.3355107-1-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add R-Car Gen4 gPTP support into the rswitch driver.

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/net/ethernet/renesas/Makefile        |   2 +-
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c | 151 +++++++++++++++++++
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h |  71 +++++++++
 drivers/net/ethernet/renesas/rswitch.c       | 150 +++++++++++++++++-
 drivers/net/ethernet/renesas/rswitch.h       |   2 +
 5 files changed, 374 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h

diff --git a/drivers/net/ethernet/renesas/Makefile b/drivers/net/ethernet/renesas/Makefile
index 32845ba53970..592005893464 100644
--- a/drivers/net/ethernet/renesas/Makefile
+++ b/drivers/net/ethernet/renesas/Makefile
@@ -9,6 +9,6 @@ ravb-objs := ravb_main.o ravb_ptp.o
 
 obj-$(CONFIG_RAVB) += ravb.o
 
-rswitch_drv-objs := rswitch.o
+rswitch_drv-objs := rswitch.o rcar_gen4_ptp.o
 
 obj-$(CONFIG_RENESAS_ETHER_SWITCH) += rswitch_drv.o
diff --git a/drivers/net/ethernet/renesas/rcar_gen4_ptp.c b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
new file mode 100644
index 000000000000..9ac9aeff7213
--- /dev/null
+++ b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Renesas R-Car Gen4 gPTP device driver
+ *
+ * Copyright (C) 2022 Renesas Electronics Corporation
+ */
+
+#include <linux/err.h>
+#include <linux/etherdevice.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+
+#include "rcar_gen4_ptp.h"
+#define ptp_to_priv(ptp)	container_of(ptp, struct rcar_gen4_ptp_private, info)
+
+static const struct rcar_gen4_ptp_reg_offset s4_offs = {
+	.enable = PTPTMEC,
+	.disable = PTPTMDC,
+	.increment = PTPTIVC0,
+	.config_t0 = PTPTOVC00,
+	.config_t1 = PTPTOVC10,
+	.config_t2 = PTPTOVC20,
+	.monitor_t0 = PTPGPTPTM00,
+	.monitor_t1 = PTPGPTPTM10,
+	.monitor_t2 = PTPGPTPTM20,
+};
+
+static int rcar_gen4_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
+{
+	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
+	bool neg_adj = scaled_ppm < 0 ? true : false;
+	s64 addend = ptp_priv->default_addend;
+	s64 diff;
+
+	if (neg_adj)
+		scaled_ppm = -scaled_ppm;
+	diff = div_s64(addend * scaled_ppm_to_ppb(scaled_ppm), NSEC_PER_SEC);
+	addend = neg_adj ? addend - diff : addend + diff;
+
+	iowrite32(addend, ptp_priv->addr + ptp_priv->offs->increment);
+
+	return 0;
+}
+
+static int rcar_gen4_ptp_gettime(struct ptp_clock_info *ptp,
+				 struct timespec64 *ts)
+{
+	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
+
+	ts->tv_nsec = ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t0);
+	ts->tv_sec = ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t1) |
+		     ((s64)ioread32(ptp_priv->addr + ptp_priv->offs->monitor_t2) << 32);
+
+	return 0;
+}
+
+static int rcar_gen4_ptp_settime(struct ptp_clock_info *ptp,
+				 const struct timespec64 *ts)
+{
+	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
+
+	iowrite32(1, ptp_priv->addr + ptp_priv->offs->disable);
+	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t2);
+	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t1);
+	iowrite32(0, ptp_priv->addr + ptp_priv->offs->config_t0);
+	iowrite32(1, ptp_priv->addr + ptp_priv->offs->enable);
+	iowrite32(ts->tv_sec >> 32, ptp_priv->addr + ptp_priv->offs->config_t2);
+	iowrite32(ts->tv_sec, ptp_priv->addr + ptp_priv->offs->config_t1);
+	iowrite32(ts->tv_nsec, ptp_priv->addr + ptp_priv->offs->config_t0);
+
+	return 0;
+}
+
+static int rcar_gen4_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct timespec64 ts;
+	s64 now;
+
+	rcar_gen4_ptp_gettime(ptp, &ts);
+	now = ktime_to_ns(timespec64_to_ktime(ts));
+	ts = ns_to_timespec64(now + delta);
+	rcar_gen4_ptp_settime(ptp, &ts);
+
+	return 0;
+}
+
+static int rcar_gen4_ptp_enable(struct ptp_clock_info *ptp,
+				struct ptp_clock_request *rq, int on)
+{
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info rcar_gen4_ptp_info = {
+	.owner = THIS_MODULE,
+	.name = "rcar_gen4_ptp",
+	.max_adj = 50000000,
+	.adjfine = rcar_gen4_ptp_adjfine,
+	.adjtime = rcar_gen4_ptp_adjtime,
+	.gettime64 = rcar_gen4_ptp_gettime,
+	.settime64 = rcar_gen4_ptp_settime,
+	.enable = rcar_gen4_ptp_enable,
+};
+
+static void rcar_gen4_ptp_set_offs(struct rcar_gen4_ptp_private *ptp_priv,
+				   enum rcar_gen4_ptp_reg_layout layout)
+{
+	WARN_ON(layout != RCAR_GEN4_PTP_REG_LAYOUT_S4);
+
+	ptp_priv->offs = &s4_offs;
+}
+
+int rcar_gen4_ptp_register(struct rcar_gen4_ptp_private *ptp_priv,
+			   enum rcar_gen4_ptp_reg_layout layout, u32 clock)
+{
+	if (ptp_priv->initialized)
+		return 0;
+
+	rcar_gen4_ptp_set_offs(ptp_priv, layout);
+
+	ptp_priv->default_addend = clock;
+	iowrite32(ptp_priv->default_addend, ptp_priv->addr + ptp_priv->offs->increment);
+	ptp_priv->clock = ptp_clock_register(&ptp_priv->info, NULL);
+	if (IS_ERR(ptp_priv->clock))
+		return PTR_ERR(ptp_priv->clock);
+
+	iowrite32(0x01, ptp_priv->addr + ptp_priv->offs->enable);
+	ptp_priv->initialized = true;
+
+	return 0;
+}
+
+int rcar_gen4_ptp_unregister(struct rcar_gen4_ptp_private *ptp_priv)
+{
+	iowrite32(1, ptp_priv->addr + ptp_priv->offs->disable);
+
+	return ptp_clock_unregister(ptp_priv->clock);
+}
+
+struct rcar_gen4_ptp_private *rcar_gen4_ptp_alloc(struct platform_device *pdev)
+{
+	struct rcar_gen4_ptp_private *ptp;
+
+	ptp = devm_kzalloc(&pdev->dev, sizeof(*ptp), GFP_KERNEL);
+	if (!ptp)
+		return NULL;
+
+	ptp->info = rcar_gen4_ptp_info;
+
+	return ptp;
+}
diff --git a/drivers/net/ethernet/renesas/rcar_gen4_ptp.h b/drivers/net/ethernet/renesas/rcar_gen4_ptp.h
new file mode 100644
index 000000000000..aac1403b5ab3
--- /dev/null
+++ b/drivers/net/ethernet/renesas/rcar_gen4_ptp.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Renesas R-Car Gen4 gPTP device driver
+ *
+ * Copyright (C) 2022 Renesas Electronics Corporation
+ */
+
+#ifndef __RCAR_GEN4_PTP_H__
+#define __RCAR_GEN4_PTP_H__
+
+#include <linux/ptp_clock_kernel.h>
+
+#define PTPTIVC_INIT			0x19000000	/* 320MHz */
+#define RCAR_GEN4_PTP_CLOCK_S4		PTPTIVC_INIT
+#define RCAR_GEN4_GPTP_OFFSET_S4	0x00018000
+
+/* for rcar_gen4_ptp_init */
+enum rcar_gen4_ptp_reg_layout {
+	RCAR_GEN4_PTP_REG_LAYOUT_S4
+};
+
+/* driver's definitions */
+#define RCAR_GEN4_RXTSTAMP_ENABLED		BIT(0)
+#define RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT	BIT(1)
+#define RCAR_GEN4_RXTSTAMP_TYPE_ALL		(RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT | BIT(2))
+#define RCAR_GEN4_RXTSTAMP_TYPE			RCAR_GEN4_RXTSTAMP_TYPE_ALL
+
+#define RCAR_GEN4_TXTSTAMP_ENABLED		BIT(0)
+
+#define PTPRO				0
+
+enum rcar_gen4_ptp_reg_s4 {
+	PTPTMEC		= PTPRO + 0x0010,
+	PTPTMDC		= PTPRO + 0x0014,
+	PTPTIVC0	= PTPRO + 0x0020,
+	PTPTOVC00	= PTPRO + 0x0030,
+	PTPTOVC10	= PTPRO + 0x0034,
+	PTPTOVC20	= PTPRO + 0x0038,
+	PTPGPTPTM00	= PTPRO + 0x0050,
+	PTPGPTPTM10	= PTPRO + 0x0054,
+	PTPGPTPTM20	= PTPRO + 0x0058,
+};
+
+struct rcar_gen4_ptp_reg_offset {
+	u16 enable;
+	u16 disable;
+	u16 increment;
+	u16 config_t0;
+	u16 config_t1;
+	u16 config_t2;
+	u16 monitor_t0;
+	u16 monitor_t1;
+	u16 monitor_t2;
+};
+
+struct rcar_gen4_ptp_private {
+	void __iomem *addr;
+	struct ptp_clock *clock;
+	struct ptp_clock_info info;
+	const struct rcar_gen4_ptp_reg_offset *offs;
+	u32 tstamp_tx_ctrl;
+	u32 tstamp_rx_ctrl;
+	s64 default_addend;
+	bool initialized;
+};
+
+int rcar_gen4_ptp_register(struct rcar_gen4_ptp_private *ptp_priv,
+			   enum rcar_gen4_ptp_reg_layout layout, u32 clock);
+int rcar_gen4_ptp_unregister(struct rcar_gen4_ptp_private *ptp_priv);
+struct rcar_gen4_ptp_private *rcar_gen4_ptp_alloc(struct platform_device *pdev);
+
+#endif	/* #ifndef __RCAR_GEN4_PTP_H__ */
diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 2723dffad93a..994bbc7a40d6 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -117,6 +117,13 @@ static void rswitch_fwd_init(struct rswitch_private *priv)
 	iowrite32(GENMASK(RSWITCH_NUM_ETHA - 1, 0), priv->addr + FWPBFC(3));
 }
 
+/* gPTP timer (gPTP) */
+static void rswitch_get_timestamp(struct rswitch_private *priv,
+				  struct timespec64 *ts)
+{
+	priv->ptp_priv->info.gettime64(&priv->ptp_priv->info, ts);
+}
+
 /* Gateway CPU agent block (GWCA) */
 static int rswitch_gwca_change_mode(struct rswitch_private *priv,
 				    enum rswitch_gwca_mode mode)
@@ -637,6 +644,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	struct sk_buff *skb;
 	dma_addr_t dma_addr;
 	u16 pkt_len;
+	u32 get_ts;
 
 	boguscnt = min_t(int, c->dirty + c->num_ring - c->cur, *quota);
 	limit = boguscnt;
@@ -651,6 +659,17 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 		c->skb[entry] = NULL;
 		dma_addr = le32_to_cpu(desc->dptrl) | ((__le64)le32_to_cpu(desc->dptrh) << 32);
 		dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ, DMA_FROM_DEVICE);
+		get_ts = rdev->priv->ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT;
+		if (get_ts) {
+			struct skb_shared_hwtstamps *shhwtstamps;
+			struct timespec64 ts;
+
+			shhwtstamps = skb_hwtstamps(skb);
+			memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+			ts.tv_sec = (u64)le32_to_cpu(desc->ts_sec);
+			ts.tv_nsec = le32_to_cpu(desc->ts_nsec & 0x3FFFFFFF);
+			shhwtstamps->hwtstamp = timespec64_to_ktime(ts);
+		}
 		skb_put(skb, pkt_len);
 		skb->protocol = eth_type_trans(skb, ndev);
 		netif_receive_skb(skb);
@@ -700,6 +719,15 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 		size = le16_to_cpu(desc->info_ds) & TX_DS;
 		skb = c->skb[entry];
 		if (skb) {
+			if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+				struct skb_shared_hwtstamps shhwtstamps;
+				struct timespec64 ts;
+
+				rswitch_get_timestamp(rdev->priv, &ts);
+				memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+				shhwtstamps.hwtstamp = timespec64_to_ktime(ts);
+				skb_tstamp_tx(skb, &shhwtstamps);
+			}
 			dma_addr = le32_to_cpu(desc->dptrl) |
 				   ((__le64)le32_to_cpu(desc->dptrh) << 32);
 			dma_unmap_single(ndev->dev.parent, dma_addr,
@@ -1322,6 +1350,13 @@ static int rswitch_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	desc->dptrh = cpu_to_le32(upper_32_bits(dma_addr));
 	desc->info_ds = cpu_to_le16(skb->len);
 
+	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		rdev->ts_tag++;
+		desc->info1 = (rdev->ts_tag << 8) | BIT(3);
+	}
+	skb_tx_timestamp(skb);
+
 	dma_wmb();
 
 	desc->die_dt = DT_FSINGLE | DIE;
@@ -1338,6 +1373,75 @@ static struct net_device_stats *rswitch_get_stats(struct net_device *ndev)
 	return &ndev->stats;
 }
 
+static int rswitch_hwstamp_get(struct net_device *ndev, struct ifreq *req)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	struct rcar_gen4_ptp_private *ptp_priv;
+	struct hwtstamp_config config;
+
+	ptp_priv = rdev->priv->ptp_priv;
+
+	config.flags = 0;
+	config.tx_type = ptp_priv->tstamp_tx_ctrl ? HWTSTAMP_TX_ON :
+						    HWTSTAMP_TX_OFF;
+	switch (ptp_priv->tstamp_rx_ctrl & RCAR_GEN4_RXTSTAMP_TYPE) {
+	case RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT:
+		config.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	case RCAR_GEN4_RXTSTAMP_TYPE_ALL:
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	default:
+		config.rx_filter = HWTSTAMP_FILTER_NONE;
+		break;
+	}
+
+	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
+static int rswitch_hwstamp_set(struct net_device *ndev, struct ifreq *req)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+	u32 tstamp_rx_ctrl = RCAR_GEN4_RXTSTAMP_ENABLED;
+	struct hwtstamp_config config;
+	u32 tstamp_tx_ctrl;
+
+	if (copy_from_user(&config, req->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	if (config.flags)
+		return -EINVAL;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		tstamp_tx_ctrl = 0;
+		break;
+	case HWTSTAMP_TX_ON:
+		tstamp_tx_ctrl = RCAR_GEN4_TXTSTAMP_ENABLED;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		tstamp_rx_ctrl = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+		tstamp_rx_ctrl |= RCAR_GEN4_RXTSTAMP_TYPE_V2_L2_EVENT;
+		break;
+	default:
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		tstamp_rx_ctrl |= RCAR_GEN4_RXTSTAMP_TYPE_ALL;
+		break;
+	}
+
+	rdev->priv->ptp_priv->tstamp_tx_ctrl = tstamp_tx_ctrl;
+	rdev->priv->ptp_priv->tstamp_rx_ctrl = tstamp_rx_ctrl;
+
+	return copy_to_user(req->ifr_data, &config, sizeof(config)) ? -EFAULT : 0;
+}
+
 static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 {
 	struct phy_device *phydev = ndev->phydev;
@@ -1347,7 +1451,14 @@ static int rswitch_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd
 	if (!phydev)
 		return -ENODEV;
 
-	return phy_mii_ioctl(phydev, req, cmd);
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return rswitch_hwstamp_get(ndev, req);
+	case SIOCSHWTSTAMP:
+		return rswitch_hwstamp_set(ndev, req);
+	default:
+		return phy_mii_ioctl(phydev, req, cmd);
+	}
 }
 
 static const struct net_device_ops rswitch_netdev_ops = {
@@ -1360,6 +1471,27 @@ static const struct net_device_ops rswitch_netdev_ops = {
 	.ndo_set_mac_address = eth_mac_addr,
 };
 
+static int rswitch_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
+{
+	struct rswitch_device *rdev = netdev_priv(ndev);
+
+	info->phc_index = ptp_clock_index(rdev->priv->ptp_priv->clock);
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE |
+				SOF_TIMESTAMPING_TX_HARDWARE |
+				SOF_TIMESTAMPING_RX_HARDWARE |
+				SOF_TIMESTAMPING_RAW_HARDWARE;
+	info->tx_types = BIT(HWTSTAMP_TX_OFF) | BIT(HWTSTAMP_TX_ON);
+	info->rx_filters = BIT(HWTSTAMP_FILTER_NONE) | BIT(HWTSTAMP_FILTER_ALL);
+
+	return 0;
+}
+
+static const struct ethtool_ops rswitch_ethtool_ops = {
+	.get_ts_info = rswitch_get_ts_info,
+};
+
 static const struct of_device_id renesas_eth_sw_of_table[] = {
 	{ .compatible = "renesas,r8a779f0-ether-switch", },
 	{ }
@@ -1407,6 +1539,7 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
 	ndev->base_addr = (unsigned long)rdev->addr;
 	snprintf(ndev->name, IFNAMSIZ, "tsn%d", index);
 	ndev->netdev_ops = &rswitch_netdev_ops;
+	ndev->ethtool_ops = &rswitch_ethtool_ops;
 
 	netif_napi_add(ndev, &rdev->napi, rswitch_poll, 64);
 
@@ -1491,6 +1624,11 @@ static int rswitch_init(struct rswitch_private *priv)
 
 	rswitch_fwd_init(priv);
 
+	err = rcar_gen4_ptp_register(priv->ptp_priv, RCAR_GEN4_PTP_REG_LAYOUT_S4,
+				     RCAR_GEN4_PTP_CLOCK_S4);
+	if (err < 0)
+		goto err_ptp_register;
+
 	err = rswitch_gwca_request_irqs(priv);
 	if (err < 0)
 		goto err_gwca_request_irq;
@@ -1518,6 +1656,9 @@ static int rswitch_init(struct rswitch_private *priv)
 
 err_gwca_hw_init:
 err_gwca_request_irq:
+	rcar_gen4_ptp_unregister(priv->ptp_priv);
+
+err_ptp_register:
 	for (i = 0; i < RSWITCH_NUM_NDEV; i++)
 		rswitch_device_free(priv, i);
 
@@ -1543,6 +1684,10 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->ptp_priv = rcar_gen4_ptp_alloc(pdev);
+	if (!priv->ptp_priv)
+		return -ENOMEM;
+
 	priv->tsn_clk = devm_clk_get(&pdev->dev, "tsn");
 	if (IS_ERR(priv->tsn_clk)) {
 		dev_err(&pdev->dev, "Failed to get tsn clock: %ld\n", PTR_ERR(priv->tsn_clk));
@@ -1555,6 +1700,8 @@ static int renesas_eth_sw_probe(struct platform_device *pdev)
 	if (IS_ERR(priv->addr))
 		return PTR_ERR(priv->addr);
 
+	priv->ptp_priv->addr = priv->addr + RCAR_GEN4_GPTP_OFFSET_S4;
+
 	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(40));
 	if (ret < 0) {
 		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
@@ -1587,6 +1734,7 @@ static void rswitch_deinit(struct rswitch_private *priv)
 	int i;
 
 	rswitch_gwca_hw_deinit(priv);
+	rcar_gen4_ptp_unregister(priv->ptp_priv);
 
 	for (i = 0; i < RSWITCH_NUM_NDEV; i++) {
 		struct rswitch_device *rdev = priv->rdev[i];
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 3dd62f82abb1..bb728ccd5c86 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -8,6 +8,7 @@
 #define __RSWITCH_H__
 
 #include <linux/platform_device.h>
+#include "rcar_gen4_ptp.h"
 
 #define RSWITCH_NUM_HW		5
 #define RSWITCH_MAX_NUM_ETHA	3
@@ -947,6 +948,7 @@ struct rswitch_mfwd {
 struct rswitch_private {
 	struct platform_device *pdev;
 	void __iomem *addr;
+	struct rcar_gen4_ptp_private *ptp_priv;
 	struct rswitch_desc *desc_bat;
 	dma_addr_t desc_bat_dma;
 	u32 desc_bat_size;
-- 
2.25.1

