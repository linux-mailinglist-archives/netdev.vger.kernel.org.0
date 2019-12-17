Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F7122C2E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 13:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbfLQMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 07:46:36 -0500
Received: from us03-smtprelay2.synopsys.com ([149.117.87.133]:38960 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728049AbfLQMqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 07:46:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 5E132C00CC;
        Tue, 17 Dec 2019 12:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576586780; bh=fBmg9YO9gXGptmoawpTJ6ZduoL85BJe/Hw0dREJDins=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=LJAPSpSxVmGXk1gHOmHiD9zjbBRAlVQqot2OVxFJ7Dkm4U2A7HAgeMweKoD3NUZI9
         SlcwJQYHXL8Yr0ADgdeAAhyY0C2hVqo5oOPmbbFHtMOGaMaKW6qdujhlCz3/9ozUkA
         wSzkcpw6L6gEnb/fVsVgspAd7q+BHpPRKaAB6RR9ltHUKM3bdhdq6sC6Y8vYyhK/pp
         /xcn3K8tAZa/vy6nke8sGXFNHmT76BTQg3aiFu1TKJ4Nuzev/fRUEpmPb7FDWgnAZ/
         o/EwXnrfrzT61AkD6+Nh6KoDDzCqhiEcowscf1sr/1QTUIDB5aqaKxqY5+L3jFgbSO
         rYJCYxLmW744Q==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id D9D41A0095;
        Tue, 17 Dec 2019 12:46:17 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: stmmac: Add basic EST support for GMAC5+
Date:   Tue, 17 Dec 2019 13:46:09 +0100
Message-Id: <7657fccefb7f8d916060514a6b4550c932e4cc06.1576586602.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1576586602.git.Jose.Abreu@synopsys.com>
References: <cover.1576586602.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <joabreu@synopsys.com>

Adds the support for EST in GMAC5+ cores. This feature allows to offload
scheduling of queues opening time to the IP.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  4 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  9 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |  3 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c      | 95 +++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      | 19 +++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  5 ++
 include/linux/stmmac.h                            | 11 +++
 8 files changed, 148 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index b210e987a1db..2f1fc93a9b1e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -363,6 +363,10 @@ struct dma_features {
 	unsigned int dvlan;
 	unsigned int l3l4fnum;
 	unsigned int arpoffsel;
+	/* TSN Features */
+	unsigned int estwid;
+	unsigned int estdep;
+	unsigned int estsel;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2dc70d104161..f7f5a2751147 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -176,6 +176,8 @@ enum power_event {
 #define GMAC_CONFIG_SARC		GENMASK(30, 28)
 #define GMAC_CONFIG_SARC_SHIFT		28
 #define GMAC_CONFIG_IPC			BIT(27)
+#define GMAC_CONFIG_IPG			GENMASK(26, 24)
+#define GMAC_CONFIG_IPG_SHIFT		24
 #define GMAC_CONFIG_2K			BIT(22)
 #define GMAC_CONFIG_ACS			BIT(20)
 #define GMAC_CONFIG_BE			BIT(18)
@@ -183,6 +185,7 @@ enum power_event {
 #define GMAC_CONFIG_JE			BIT(16)
 #define GMAC_CONFIG_PS			BIT(15)
 #define GMAC_CONFIG_FES			BIT(14)
+#define GMAC_CONFIG_FES_SHIFT		14
 #define GMAC_CONFIG_DM			BIT(13)
 #define GMAC_CONFIG_LM			BIT(12)
 #define GMAC_CONFIG_DCRS		BIT(9)
@@ -190,6 +193,9 @@ enum power_event {
 #define GMAC_CONFIG_RE			BIT(0)
 
 /* MAC extended config */
+#define GMAC_CONFIG_EIPG		GENMASK(29, 25)
+#define GMAC_CONFIG_EIPG_SHIFT		25
+#define GMAC_CONFIG_EIPG_EN		BIT(24)
 #define GMAC_CONFIG_HDSMS		GENMASK(22, 20)
 #define GMAC_CONFIG_HDSMS_SHIFT		20
 #define GMAC_CONFIG_HDSMS_256		(0x2 << GMAC_CONFIG_HDSMS_SHIFT)
@@ -231,6 +237,9 @@ enum power_event {
 
 /* MAC HW features3 bitmap */
 #define GMAC_HW_FEAT_ASP		GENMASK(29, 28)
+#define GMAC_HW_FEAT_ESTWID		GENMASK(21, 20)
+#define GMAC_HW_FEAT_ESTDEP		GENMASK(19, 17)
+#define GMAC_HW_FEAT_ESTSEL		BIT(16)
 #define GMAC_HW_FEAT_FRPES		GENMASK(14, 13)
 #define GMAC_HW_FEAT_FRPBS		GENMASK(12, 11)
 #define GMAC_HW_FEAT_FRPSEL		BIT(10)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 40ca00e596dd..8df7496411a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -984,6 +984,7 @@ const struct stmmac_ops dwmac410_ops = {
 	.set_arp_offload = dwmac4_set_arp_offload,
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
+	.est_configure = dwmac5_est_configure,
 };
 
 const struct stmmac_ops dwmac510_ops = {
@@ -1027,6 +1028,7 @@ const struct stmmac_ops dwmac510_ops = {
 	.set_arp_offload = dwmac4_set_arp_offload,
 	.config_l3_filter = dwmac4_config_l3_filter,
 	.config_l4_filter = dwmac4_config_l4_filter,
+	.est_configure = dwmac5_est_configure,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
index c15409030710..3552ce1201ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c
@@ -404,6 +404,9 @@ static void dwmac4_get_hw_feature(void __iomem *ioaddr,
 
 	/* 5.10 Features */
 	dma_cap->asp = (hw_cap & GMAC_HW_FEAT_ASP) >> 28;
+	dma_cap->estwid = (hw_cap & GMAC_HW_FEAT_ESTWID) >> 20;
+	dma_cap->estdep = (hw_cap & GMAC_HW_FEAT_ESTDEP) >> 17;
+	dma_cap->estsel = (hw_cap & GMAC_HW_FEAT_ESTSEL) >> 16;
 	dma_cap->frpes = (hw_cap & GMAC_HW_FEAT_FRPES) >> 13;
 	dma_cap->frpbs = (hw_cap & GMAC_HW_FEAT_FRPBS) >> 11;
 	dma_cap->frpsel = (hw_cap & GMAC_HW_FEAT_FRPSEL) >> 10;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index e436fa160c7d..8047f402fb3f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -550,3 +550,98 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 	writel(val, ioaddr + MAC_PPS_CONTROL);
 	return 0;
 }
+
+static int dwmac5_est_write(void __iomem *ioaddr, u32 reg, u32 val, bool gcl)
+{
+	u32 ctrl;
+
+	writel(val, ioaddr + MTL_EST_GCL_DATA);
+
+	ctrl = (reg << ADDR_SHIFT);
+	ctrl |= gcl ? 0 : GCRR;
+
+	writel(ctrl, ioaddr + MTL_EST_GCL_CONTROL);
+
+	ctrl |= SRWO;
+	writel(ctrl, ioaddr + MTL_EST_GCL_CONTROL);
+
+	return readl_poll_timeout(ioaddr + MTL_EST_GCL_CONTROL,
+				  ctrl, !(ctrl & SRWO), 100, 5000);
+}
+
+int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
+			 unsigned int ptp_rate)
+{
+	u32 speed, total_offset, offset, ctrl, ctr_low;
+	u32 extcfg = readl(ioaddr + GMAC_EXT_CONFIG);
+	u32 mac_cfg = readl(ioaddr + GMAC_CONFIG);
+	int i, ret = 0x0;
+	u64 total_ctr;
+
+	if (extcfg & GMAC_CONFIG_EIPG_EN) {
+		offset = (extcfg & GMAC_CONFIG_EIPG) >> GMAC_CONFIG_EIPG_SHIFT;
+		offset = 104 + (offset * 8);
+	} else {
+		offset = (mac_cfg & GMAC_CONFIG_IPG) >> GMAC_CONFIG_IPG_SHIFT;
+		offset = 96 - (offset * 8);
+	}
+
+	speed = mac_cfg & (GMAC_CONFIG_PS | GMAC_CONFIG_FES);
+	speed = speed >> GMAC_CONFIG_FES_SHIFT;
+
+	switch (speed) {
+	case 0x0:
+		offset = offset * 1000; /* 1G */
+		break;
+	case 0x1:
+		offset = offset * 400; /* 2.5G */
+		break;
+	case 0x2:
+		offset = offset * 100000; /* 10M */
+		break;
+	case 0x3:
+		offset = offset * 10000; /* 100M */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	offset = offset / 1000;
+
+	ret |= dwmac5_est_write(ioaddr, BTR_LOW, cfg->btr[0], false);
+	ret |= dwmac5_est_write(ioaddr, BTR_HIGH, cfg->btr[1], false);
+	ret |= dwmac5_est_write(ioaddr, TER, cfg->ter, false);
+	ret |= dwmac5_est_write(ioaddr, LLR, cfg->gcl_size, false);
+	if (ret)
+		return ret;
+
+	total_offset = 0;
+	for (i = 0; i < cfg->gcl_size; i++) {
+		ret = dwmac5_est_write(ioaddr, i, cfg->gcl[i] + offset, true);
+		if (ret)
+			return ret;
+
+		total_offset += offset;
+	}
+
+	total_ctr = cfg->ctr[0] + cfg->ctr[1] * 1000000000;
+	total_ctr += total_offset;
+
+	ctr_low = do_div(total_ctr, 1000000000);
+
+	ret |= dwmac5_est_write(ioaddr, CTR_LOW, ctr_low, false);
+	ret |= dwmac5_est_write(ioaddr, CTR_HIGH, total_ctr, false);
+	if (ret)
+		return ret;
+
+	ctrl = readl(ioaddr + MTL_EST_CONTROL);
+	ctrl &= ~PTOV;
+	ctrl |= ((1000000000 / ptp_rate) * 6) << PTOV_SHIFT;
+	if (cfg->enable)
+		ctrl |= EEST | SSWL;
+	else
+		ctrl &= ~EEST;
+
+	writel(ctrl, ioaddr + MTL_EST_CONTROL);
+	return 0;
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 23fecf68f781..70e6d8837dd9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -30,6 +30,23 @@
 #define MAC_PPSx_INTERVAL(x)		(0x00000b88 + ((x) * 0x10))
 #define MAC_PPSx_WIDTH(x)		(0x00000b8c + ((x) * 0x10))
 
+#define MTL_EST_CONTROL			0x00000c50
+#define PTOV				GENMASK(31, 24)
+#define PTOV_SHIFT			24
+#define SSWL				BIT(1)
+#define EEST				BIT(0)
+#define MTL_EST_GCL_CONTROL		0x00000c80
+#define BTR_LOW				0x0
+#define BTR_HIGH			0x1
+#define CTR_LOW				0x2
+#define CTR_HIGH			0x3
+#define TER				0x4
+#define LLR				0x5
+#define ADDR_SHIFT			8
+#define GCRR				BIT(2)
+#define SRWO				BIT(0)
+#define MTL_EST_GCL_DATA		0x00000c84
+
 #define MTL_RXP_CONTROL_STATUS		0x00000ca0
 #define RXPI				BIT(31)
 #define NPE				GENMASK(23, 16)
@@ -83,5 +100,7 @@ int dwmac5_rxp_config(void __iomem *ioaddr, struct stmmac_tc_entry *entries,
 int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 			   struct stmmac_pps_cfg *cfg, bool enable,
 			   u32 sub_second_inc, u32 systime_flags);
+int dwmac5_est_configure(void __iomem *ioaddr, struct stmmac_est *cfg,
+			 unsigned int ptp_rate);
 
 #endif /* __DWMAC5_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 098fbe7a5862..9fd34df6eb16 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -276,6 +276,7 @@ struct stmmac_safety_stats;
 struct stmmac_tc_entry;
 struct stmmac_pps_cfg;
 struct stmmac_rss;
+struct stmmac_est;
 
 /* Helpers to program the MAC core */
 struct stmmac_ops {
@@ -373,6 +374,8 @@ struct stmmac_ops {
 				bool en, bool udp, bool sa, bool inv,
 				u32 match);
 	void (*set_arp_offload)(struct mac_device_info *hw, bool en, u32 addr);
+	int (*est_configure)(void __iomem *ioaddr, struct stmmac_est *cfg,
+			     unsigned int ptp_rate);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -459,6 +462,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, config_l4_filter, __args)
 #define stmmac_set_arp_offload(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_arp_offload, __args)
+#define stmmac_est_configure(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, est_configure, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index d4bcd9387136..55587cc10567 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -109,6 +109,16 @@ struct stmmac_axi {
 	bool axi_rb;
 };
 
+#define EST_GCL		1024
+struct stmmac_est {
+	int enable;
+	u32 btr[2];
+	u32 ctr[2];
+	u32 ter;
+	u32 gcl[EST_GCL];
+	u32 gcl_size;
+};
+
 struct stmmac_rxq_cfg {
 	u8 mode_to_use;
 	u32 chan;
@@ -139,6 +149,7 @@ struct plat_stmmacenet_data {
 	struct device_node *phylink_node;
 	struct device_node *mdio_node;
 	struct stmmac_dma_cfg *dma_cfg;
+	struct stmmac_est *est;
 	int clk_csr;
 	int has_gmac;
 	int enh_desc;
-- 
2.7.4

