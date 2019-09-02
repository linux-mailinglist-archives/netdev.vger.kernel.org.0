Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66EA50C3
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbfIBIDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:03:13 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:51450 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729997AbfIBICS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:02:18 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 86AFBC0435;
        Mon,  2 Sep 2019 08:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567411337; bh=zyYycWzI3gP2R1iAinTx/pHfNFFo0/m1lRGmhYuogfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=GmwU4ZgTom4yDw3RgzC0hI6eoKDOTre2b+6WdDF/SgGybmOhX6WS1ZFEqUWV0v23a
         vmPL4g4w9yvYMPniLQ7Nl+cgEJftzbx/Ja5/ZLJGfMceSZZvuXiha8YFaKUqGtDXQ1
         Tb+yz+cw27w01YDcUqmmylccFwzoITvNc4cBkA3KOARDvDBxVO1XNR7naLqgTUxlsD
         WTgj9VV8nnk5Npf4q30HgAgqICv4CaspHSqAKdfHX5Vfff/16zqkLtoFIp6DeFDi8g
         STXdQGBQKpekdUJ5/kyNvypGd7ICFpsW2DpbgwVVPSSAgty/QqqAbptA+XyTk7a132
         b6VpRs48AOVlQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 44235A006F;
        Mon,  2 Sep 2019 08:02:15 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 04/13] net: stmmac: Implement L3/L4 Filters using TC Flower
Date:   Mon,  2 Sep 2019 10:01:46 +0200
Message-Id: <8a70617cff7919534ae17e92239e8ffdb37f5b78.1567410970.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
In-Reply-To: <cover.1567410970.git.joabreu@synopsys.com>
References: <cover.1567410970.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement filters for Layer 3 and Layer 4 using TC Flower API. Add the
corresponding callbacks in XGMAC core.

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
 drivers/net/ethernet/stmicro/stmmac/common.h       |   1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  30 +++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 177 +++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  16 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  12 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    | 244 +++++++++++++++++++++
 8 files changed, 488 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 49aa56ca09cc..19538057c24e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -360,6 +360,7 @@ struct dma_features {
 	unsigned int sphen;
 	unsigned int vlins;
 	unsigned int dvlan;
+	unsigned int l3l4fnum;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 7357b8bdc128..f942ac975c29 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -47,6 +47,7 @@
 #define XGMAC_CORE_INIT_RX		0
 #define XGMAC_PACKET_FILTER		0x00000008
 #define XGMAC_FILTER_RA			BIT(31)
+#define XGMAC_FILTER_IPFE		BIT(20)
 #define XGMAC_FILTER_VTFE		BIT(16)
 #define XGMAC_FILTER_HPF		BIT(10)
 #define XGMAC_FILTER_PCF		BIT(7)
@@ -119,6 +120,7 @@
 #define XGMAC_HWFEAT_VLHASH		BIT(4)
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
 #define XGMAC_HW_FEATURE1		0x00000120
+#define XGMAC_HWFEAT_L3L4FNUM		GENMASK(30, 27)
 #define XGMAC_HWFEAT_RSSEN		BIT(20)
 #define XGMAC_HWFEAT_TSOEN		BIT(18)
 #define XGMAC_HWFEAT_SPHEN		BIT(17)
@@ -150,6 +152,34 @@
 #define XGMAC_DCS			GENMASK(19, 16)
 #define XGMAC_DCS_SHIFT			16
 #define XGMAC_ADDRx_LOW(x)		(0x00000304 + (x) * 0x8)
+#define XGMAC_L3L4_ADDR_CTRL		0x00000c00
+#define XGMAC_IDDR			GENMASK(15, 8)
+#define XGMAC_IDDR_SHIFT		8
+#define XGMAC_IDDR_FNUM			4
+#define XGMAC_TT			BIT(1)
+#define XGMAC_XB			BIT(0)
+#define XGMAC_L3L4_DATA			0x00000c04
+#define XGMAC_L3L4_CTRL			0x0
+#define XGMAC_L4DPIM0			BIT(21)
+#define XGMAC_L4DPM0			BIT(20)
+#define XGMAC_L4SPIM0			BIT(19)
+#define XGMAC_L4SPM0			BIT(18)
+#define XGMAC_L4PEN0			BIT(16)
+#define XGMAC_L3HDBM0			GENMASK(15, 11)
+#define XGMAC_L3HSBM0			GENMASK(10, 6)
+#define XGMAC_L3DAIM0			BIT(5)
+#define XGMAC_L3DAM0			BIT(4)
+#define XGMAC_L3SAIM0			BIT(3)
+#define XGMAC_L3SAM0			BIT(2)
+#define XGMAC_L3PEN0			BIT(0)
+#define XGMAC_L4_ADDR			0x1
+#define XGMAC_L4DP0			GENMASK(31, 16)
+#define XGMAC_L4DP0_SHIFT		16
+#define XGMAC_L4SP0			GENMASK(15, 0)
+#define XGMAC_L3_ADDR0			0x4
+#define XGMAC_L3_ADDR1			0x5
+#define XGMAC_L3_ADDR2			0x6
+#define XMGAC_L3_ADDR3			0x7
 #define XGMAC_ARP_ADDR			0x00000c10
 #define XGMAC_RSS_CTRL			0x00000c80
 #define XGMAC_UDP4TE			BIT(3)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index e534a3aaf4a3..9f568b54b339 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1163,6 +1163,181 @@ static void dwxgmac2_enable_vlan(struct mac_device_info *hw, u32 type)
 	writel(value, ioaddr + XGMAC_VLAN_INCL);
 }
 
+static int dwxgmac2_filter_wait(struct mac_device_info *hw)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+
+	if (readl_poll_timeout(ioaddr + XGMAC_L3L4_ADDR_CTRL, value,
+			       !(value & XGMAC_XB), 100, 10000))
+		return -EBUSY;
+	return 0;
+}
+
+static int dwxgmac2_filter_read(struct mac_device_info *hw, u32 filter_no,
+				u8 reg, u32 *data)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	int ret;
+
+	ret = dwxgmac2_filter_wait(hw);
+	if (ret)
+		return ret;
+
+	value = ((filter_no << XGMAC_IDDR_FNUM) | reg) << XGMAC_IDDR_SHIFT;
+	value |= XGMAC_TT | XGMAC_XB;
+	writel(value, ioaddr + XGMAC_L3L4_ADDR_CTRL);
+
+	ret = dwxgmac2_filter_wait(hw);
+	if (ret)
+		return ret;
+
+	*data = readl(ioaddr + XGMAC_L3L4_DATA);
+	return 0;
+}
+
+static int dwxgmac2_filter_write(struct mac_device_info *hw, u32 filter_no,
+				 u8 reg, u32 data)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	int ret;
+
+	ret = dwxgmac2_filter_wait(hw);
+	if (ret)
+		return ret;
+
+	writel(data, ioaddr + XGMAC_L3L4_DATA);
+
+	value = ((filter_no << XGMAC_IDDR_FNUM) | reg) << XGMAC_IDDR_SHIFT;
+	value |= XGMAC_XB;
+	writel(value, ioaddr + XGMAC_L3L4_ADDR_CTRL);
+
+	return dwxgmac2_filter_wait(hw);
+}
+
+static int dwxgmac2_config_l3_filter(struct mac_device_info *hw, u32 filter_no,
+				     bool en, bool ipv6, bool sa, bool inv,
+				     u32 match)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	int ret;
+
+	value = readl(ioaddr + XGMAC_PACKET_FILTER);
+	value |= XGMAC_FILTER_IPFE;
+	writel(value, ioaddr + XGMAC_PACKET_FILTER);
+
+	ret = dwxgmac2_filter_read(hw, filter_no, XGMAC_L3L4_CTRL, &value);
+	if (ret)
+		return ret;
+
+	/* For IPv6 not both SA/DA filters can be active */
+	if (ipv6) {
+		value |= XGMAC_L3PEN0;
+		value &= ~(XGMAC_L3SAM0 | XGMAC_L3SAIM0);
+		value &= ~(XGMAC_L3DAM0 | XGMAC_L3DAIM0);
+		if (sa) {
+			value |= XGMAC_L3SAM0;
+			if (inv)
+				value |= XGMAC_L3SAIM0;
+		} else {
+			value |= XGMAC_L3DAM0;
+			if (inv)
+				value |= XGMAC_L3DAIM0;
+		}
+	} else {
+		value &= ~XGMAC_L3PEN0;
+		if (sa) {
+			value |= XGMAC_L3SAM0;
+			if (inv)
+				value |= XGMAC_L3SAIM0;
+		} else {
+			value |= XGMAC_L3DAM0;
+			if (inv)
+				value |= XGMAC_L3DAIM0;
+		}
+	}
+
+	ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L3L4_CTRL, value);
+	if (ret)
+		return ret;
+
+	if (sa) {
+		ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L3_ADDR0, match);
+		if (ret)
+			return ret;
+	} else {
+		ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L3_ADDR1, match);
+		if (ret)
+			return ret;
+	}
+
+	if (!en)
+		return dwxgmac2_filter_write(hw, filter_no, XGMAC_L3L4_CTRL, 0);
+
+	return 0;
+}
+
+static int dwxgmac2_config_l4_filter(struct mac_device_info *hw, u32 filter_no,
+				     bool en, bool udp, bool sa, bool inv,
+				     u32 match)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	int ret;
+
+	value = readl(ioaddr + XGMAC_PACKET_FILTER);
+	value |= XGMAC_FILTER_IPFE;
+	writel(value, ioaddr + XGMAC_PACKET_FILTER);
+
+	ret = dwxgmac2_filter_read(hw, filter_no, XGMAC_L3L4_CTRL, &value);
+	if (ret)
+		return ret;
+
+	if (udp) {
+		value |= XGMAC_L4PEN0;
+	} else {
+		value &= ~XGMAC_L4PEN0;
+	}
+
+	value &= ~(XGMAC_L4SPM0 | XGMAC_L4SPIM0);
+	value &= ~(XGMAC_L4DPM0 | XGMAC_L4DPIM0);
+	if (sa) {
+		value |= XGMAC_L4SPM0;
+		if (inv)
+			value |= XGMAC_L4SPIM0;
+	} else {
+		value |= XGMAC_L4DPM0;
+		if (inv)
+			value |= XGMAC_L4DPIM0;
+	}
+
+	ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L3L4_CTRL, value);
+	if (ret)
+		return ret;
+
+	if (sa) {
+		value = match & XGMAC_L4SP0;
+
+		ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L4_ADDR, value);
+		if (ret)
+			return ret;
+	} else {
+		value = (match << XGMAC_L4DP0_SHIFT) & XGMAC_L4DP0;
+
+		ret = dwxgmac2_filter_write(hw, filter_no, XGMAC_L4_ADDR, value);
+		if (ret)
+			return ret;
+	}
+
+	if (!en)
+		return dwxgmac2_filter_write(hw, filter_no, XGMAC_L3L4_CTRL, 0);
+
+	return 0;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1203,6 +1378,8 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.flex_pps_config = dwxgmac2_flex_pps_config,
 	.sarc_configure = dwxgmac2_sarc_configure,
 	.enable_vlan = dwxgmac2_enable_vlan,
+	.config_l3_filter = dwxgmac2_config_l3_filter,
+	.config_l4_filter = dwxgmac2_config_l4_filter,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index e77eb0ddf9b5..fb0283b15c77 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -378,6 +378,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature 1 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
+	dma_cap->l3l4fnum = (hw_cap & XGMAC_HWFEAT_L3L4FNUM) >> 27;
 	dma_cap->rssen = (hw_cap & XGMAC_HWFEAT_RSSEN) >> 20;
 	dma_cap->tsoen = (hw_cap & XGMAC_HWFEAT_TSOEN) >> 18;
 	dma_cap->sphen = (hw_cap & XGMAC_HWFEAT_SPHEN) >> 17;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 9435b312495d..47c8ad9ec671 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -363,6 +363,13 @@ struct stmmac_ops {
 	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
 	/* Source Address Insertion / Replacement */
 	void (*sarc_configure)(void __iomem *ioaddr, int val);
+	/* Filtering */
+	int (*config_l3_filter)(struct mac_device_info *hw, u32 filter_no,
+				bool en, bool ipv6, bool sa, bool inv,
+				u32 match);
+	int (*config_l4_filter)(struct mac_device_info *hw, u32 filter_no,
+				bool en, bool udp, bool sa, bool inv,
+				u32 match);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -443,6 +450,10 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, get_mac_tx_timestamp, __args)
 #define stmmac_sarc_configure(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, sarc_configure, __args)
+#define stmmac_config_l3_filter(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, config_l3_filter, __args)
+#define stmmac_config_l4_filter(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, config_l4_filter, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
@@ -499,6 +510,7 @@ struct stmmac_mode_ops {
 struct stmmac_priv;
 struct tc_cls_u32_offload;
 struct tc_cbs_qopt_offload;
+struct flow_cls_offload;
 
 struct stmmac_tc_ops {
 	int (*init)(struct stmmac_priv *priv);
@@ -506,6 +518,8 @@ struct stmmac_tc_ops {
 			     struct tc_cls_u32_offload *cls);
 	int (*setup_cbs)(struct stmmac_priv *priv,
 			 struct tc_cbs_qopt_offload *qopt);
+	int (*setup_cls)(struct stmmac_priv *priv,
+			 struct flow_cls_offload *cls);
 };
 
 #define stmmac_tc_init(__priv, __args...) \
@@ -514,6 +528,8 @@ struct stmmac_tc_ops {
 	stmmac_do_callback(__priv, tc, setup_cls_u32, __args)
 #define stmmac_tc_setup_cbs(__priv, __args...) \
 	stmmac_do_callback(__priv, tc, setup_cbs, __args)
+#define stmmac_tc_setup_cls(__priv, __args...) \
+	stmmac_do_callback(__priv, tc, setup_cls, __args)
 
 struct stmmac_counters;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index dcb2e29a5717..d993fc7e82c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -128,6 +128,16 @@ struct stmmac_rss {
 	u32 table[STMMAC_RSS_MAX_TABLE_SIZE];
 };
 
+#define STMMAC_FLOW_ACTION_DROP		BIT(0)
+struct stmmac_flow_entry {
+	unsigned long cookie;
+	unsigned long action;
+	u8 ip_proto;
+	int in_use;
+	int idx;
+	int is_l4;
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames;
@@ -216,6 +226,8 @@ struct stmmac_priv {
 	unsigned int tc_entries_max;
 	unsigned int tc_off_max;
 	struct stmmac_tc_entry *tc_entries;
+	unsigned int flow_entries_max;
+	struct stmmac_flow_entry *flow_entries;
 
 	/* Pulse Per Second output */
 	struct stmmac_pps_cfg pps[STMMAC_PPS_MAX];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06ccd216ae90..c59c232aca64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3931,12 +3931,17 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	struct stmmac_priv *priv = cb_priv;
 	int ret = -EOPNOTSUPP;
 
+	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
+		return ret;
+
 	stmmac_disable_all_queues(priv);
 
 	switch (type) {
 	case TC_SETUP_CLSU32:
-		if (tc_cls_can_offload_and_chain0(priv->dev, type_data))
-			ret = stmmac_tc_setup_cls_u32(priv, priv, type_data);
+		ret = stmmac_tc_setup_cls_u32(priv, priv, type_data);
+		break;
+	case TC_SETUP_CLSFLOWER:
+		ret = stmmac_tc_setup_cls(priv, priv, type_data);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 8dbbbf181ada..e231098061b6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -242,6 +242,23 @@ static int tc_init(struct stmmac_priv *priv)
 {
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
+	int i;
+
+	if (dma_cap->l3l4fnum) {
+		priv->flow_entries_max = dma_cap->l3l4fnum;
+		priv->flow_entries = devm_kcalloc(priv->device,
+						  dma_cap->l3l4fnum,
+						  sizeof(*priv->flow_entries),
+						  GFP_KERNEL);
+		if (!priv->flow_entries)
+			return -ENOMEM;
+
+		for (i = 0; i < priv->flow_entries_max; i++)
+			priv->flow_entries[i].idx = i;
+
+		dev_info(priv->device, "Enabled Flow TC (entries=%d)\n",
+			 priv->flow_entries_max);
+	}
 
 	/* Fail silently as we can still use remaining features, e.g. CBS */
 	if (!dma_cap->frpsel)
@@ -350,8 +367,235 @@ static int tc_setup_cbs(struct stmmac_priv *priv,
 	return 0;
 }
 
+static int tc_parse_flow_actions(struct stmmac_priv *priv,
+				 struct flow_action *action,
+				 struct stmmac_flow_entry *entry)
+{
+	struct flow_action_entry *act;
+	int i;
+
+	if (!flow_action_has_entries(action))
+		return -EINVAL;
+
+	flow_action_for_each(i, act, action) {
+		switch (act->id) {
+		case FLOW_ACTION_DROP:
+			entry->action |= STMMAC_FLOW_ACTION_DROP;
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	/* Nothing to do, maybe inverse filter ? */
+	return 0;
+}
+
+static int tc_add_basic_flow(struct stmmac_priv *priv,
+			     struct flow_cls_offload *cls,
+			     struct stmmac_flow_entry *entry)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	struct flow_match_basic match;
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_BASIC))
+		return -EINVAL;
+
+	flow_rule_match_basic(rule, &match);
+	entry->ip_proto = match.key->ip_proto;
+	return 0;
+}
+
+static int tc_add_ip4_flow(struct stmmac_priv *priv,
+			   struct flow_cls_offload *cls,
+			   struct stmmac_flow_entry *entry)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	bool inv = entry->action & STMMAC_FLOW_ACTION_DROP;
+	struct flow_match_ipv4_addrs match;
+	u32 hw_match;
+	int ret;
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_IPV4_ADDRS))
+		return -EINVAL;
+
+	flow_rule_match_ipv4_addrs(rule, &match);
+	hw_match = ntohl(match.key->src) & ntohl(match.mask->src);
+	if (hw_match) {
+		ret = stmmac_config_l3_filter(priv, priv->hw, entry->idx, true,
+					      false, true, inv, hw_match);
+		if (ret)
+			return ret;
+	}
+
+	hw_match = ntohl(match.key->dst) & ntohl(match.mask->dst);
+	if (hw_match) {
+		ret = stmmac_config_l3_filter(priv, priv->hw, entry->idx, true,
+					      false, false, inv, hw_match);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int tc_add_ports_flow(struct stmmac_priv *priv,
+			     struct flow_cls_offload *cls,
+			     struct stmmac_flow_entry *entry)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct flow_dissector *dissector = rule->match.dissector;
+	bool inv = entry->action & STMMAC_FLOW_ACTION_DROP;
+	struct flow_match_ports match;
+	u32 hw_match;
+	bool is_udp;
+	int ret;
+
+	/* Nothing to do here */
+	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_PORTS))
+		return -EINVAL;
+
+	switch (entry->ip_proto) {
+	case IPPROTO_TCP:
+		is_udp = false;
+		break;
+	case IPPROTO_UDP:
+		is_udp = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	flow_rule_match_ports(rule, &match);
+
+	hw_match = ntohs(match.key->src) & ntohs(match.mask->src);
+	if (hw_match) {
+		ret = stmmac_config_l4_filter(priv, priv->hw, entry->idx, true,
+					      is_udp, true, inv, hw_match);
+		if (ret)
+			return ret;
+	}
+
+	hw_match = ntohs(match.key->dst) & ntohs(match.mask->dst);
+	if (hw_match) {
+		ret = stmmac_config_l4_filter(priv, priv->hw, entry->idx, true,
+					      is_udp, false, inv, hw_match);
+		if (ret)
+			return ret;
+	}
+
+	entry->is_l4 = true;
+	return 0;
+}
+
+static struct stmmac_flow_entry *tc_find_flow(struct stmmac_priv *priv,
+					      struct flow_cls_offload *cls,
+					      bool get_free)
+{
+	int i;
+
+	for (i = 0; i < priv->flow_entries_max; i++) {
+		struct stmmac_flow_entry *entry = &priv->flow_entries[i];
+
+		if (entry->cookie == cls->cookie)
+			return entry;
+		if (get_free && (entry->in_use == false))
+			return entry;
+	}
+
+	return NULL;
+}
+
+struct {
+	int (*fn)(struct stmmac_priv *priv, struct flow_cls_offload *cls,
+		  struct stmmac_flow_entry *entry);
+} tc_flow_parsers[] = {
+	{ .fn = tc_add_basic_flow },
+	{ .fn = tc_add_ip4_flow },
+	{ .fn = tc_add_ports_flow },
+};
+
+static int tc_add_flow(struct stmmac_priv *priv,
+		       struct flow_cls_offload *cls)
+{
+	struct stmmac_flow_entry *entry = tc_find_flow(priv, cls, false);
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	int i, ret;
+
+	if (!entry) {
+		entry = tc_find_flow(priv, cls, true);
+		if (!entry)
+			return -ENOENT;
+	}
+
+	ret = tc_parse_flow_actions(priv, &rule->action, entry);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(tc_flow_parsers); i++) {
+		ret = tc_flow_parsers[i].fn(priv, cls, entry);
+		if (!ret) {
+			entry->in_use = true;
+			continue;
+		}
+	}
+
+	if (!entry->in_use)
+		return -EINVAL;
+
+	entry->cookie = cls->cookie;
+	return 0;
+}
+
+static int tc_del_flow(struct stmmac_priv *priv,
+		       struct flow_cls_offload *cls)
+{
+	struct stmmac_flow_entry *entry = tc_find_flow(priv, cls, false);
+	int ret;
+
+	if (!entry || !entry->in_use)
+		return -ENOENT;
+
+	if (entry->is_l4) {
+		ret = stmmac_config_l4_filter(priv, priv->hw, entry->idx, false,
+					      false, false, false, 0);
+	} else {
+		ret = stmmac_config_l3_filter(priv, priv->hw, entry->idx, false,
+					      false, false, false, 0);
+	}
+
+	entry->in_use = false;
+	entry->cookie = 0;
+	entry->is_l4 = false;
+	return ret;
+}
+
+static int tc_setup_cls(struct stmmac_priv *priv,
+			struct flow_cls_offload *cls)
+{
+	int ret = 0;
+
+	switch (cls->command) {
+	case FLOW_CLS_REPLACE:
+		ret = tc_add_flow(priv, cls);
+		break;
+	case FLOW_CLS_DESTROY:
+		ret = tc_del_flow(priv, cls);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
 const struct stmmac_tc_ops dwmac510_tc_ops = {
 	.init = tc_init,
 	.setup_cls_u32 = tc_setup_cls_u32,
 	.setup_cbs = tc_setup_cbs,
+	.setup_cls = tc_setup_cls,
 };
-- 
2.7.4

