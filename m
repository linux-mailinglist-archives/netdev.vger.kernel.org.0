Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE5D846A0
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387620AbfHGIDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 04:03:31 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:33714 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728214AbfHGID3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 04:03:29 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id AE95FC0BD1;
        Wed,  7 Aug 2019 08:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565165008; bh=YmouqCHEovEpWqePc5VIWdhiHVfRxJuEXabwNH3MBHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=YrcmB9NunHcnkmOKRjF7xIyq31xB+2+UuD8vw2wiGsJiGf3kEOe2HBEyN/Sj6Ia58
         AD08g+MP8bBryn8G432uBLDr2T3CP+cjLJ6JOMloe/auOILR1GERP22SEMPaFoAQFn
         XhGNqKivo0MxkaGfZVQTwYB2Uqt+o/LGlG7cXNVE+UhL9dk9tSCXIDWKinRC986299
         bEfv2ReVOG+/nyUgALJ56pwJc715P//9dNfL1FHwoStN2/f5dQ4dNfkVetNVCOXOk9
         jLmS6KktNmdKrNEOJJE0aWHN88aXaBfsA0/xnthVQwiS9mSX50BWsAUNRJ08HNDcm2
         jjM9BL2eqAidw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 53C82A0069;
        Wed,  7 Aug 2019 08:03:26 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v3 04/10] net: stmmac: Implement RSS and enable it in XGMAC core
Date:   Wed,  7 Aug 2019 10:03:12 +0200
Message-Id: <41a1b2810c87ac8a7affa1dce2a9f96af8d315e7.1565164729.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565164729.git.joabreu@synopsys.com>
References: <cover.1565164729.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the RSS functionality and add the corresponding callbacks in
XGMAC core.

Changes from v1:
	- Do not use magic constants (Jakub)
	- Use ethtool_rxfh_indir_default() (Jakub)

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
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  5 ++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     | 22 ++++++-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    | 52 +++++++++++++++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   | 29 +++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |  1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         | 11 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  9 +++
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   | 75 ++++++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 41 +++++++++++-
 include/linux/stmmac.h                             |  1 +
 10 files changed, 242 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index ed872eed1cab..45a997fe571c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -354,6 +354,7 @@ struct dma_features {
 	unsigned int frpbs;
 	unsigned int frpes;
 	unsigned int addr64;
+	unsigned int rssen;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
@@ -381,6 +382,10 @@ struct dma_features {
 
 #define JUMBO_LEN		9000
 
+/* Receive Side Scaling */
+#define STMMAC_RSS_HASH_KEY_SIZE	40
+#define STMMAC_RSS_MAX_TABLE_SIZE	256
+
 extern const struct stmmac_desc_ops enh_desc_ops;
 extern const struct stmmac_desc_ops ndesc_ops;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index b77091161765..ed3a85f73a72 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -89,6 +89,7 @@
 #define XGMAC_HWFEAT_RWKSEL		BIT(6)
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
 #define XGMAC_HW_FEATURE1		0x00000120
+#define XGMAC_HWFEAT_RSSEN		BIT(20)
 #define XGMAC_HWFEAT_TSOEN		BIT(18)
 #define XGMAC_HWFEAT_ADDR64		GENMASK(15, 14)
 #define XGMAC_HWFEAT_TXFIFOSIZE		GENMASK(10, 6)
@@ -109,6 +110,17 @@
 #define XGMAC_DCS_SHIFT			16
 #define XGMAC_ADDRx_LOW(x)		(0x00000304 + (x) * 0x8)
 #define XGMAC_ARP_ADDR			0x00000c10
+#define XGMAC_RSS_CTRL			0x00000c80
+#define XGMAC_UDP4TE			BIT(3)
+#define XGMAC_TCP4TE			BIT(2)
+#define XGMAC_IP2TE			BIT(1)
+#define XGMAC_RSSE			BIT(0)
+#define XGMAC_RSS_ADDR			0x00000c88
+#define XGMAC_RSSIA_SHIFT		8
+#define XGMAC_ADDRT			BIT(2)
+#define XGMAC_CT			BIT(1)
+#define XGMAC_OB			BIT(0)
+#define XGMAC_RSS_DATA			0x00000c8c
 #define XGMAC_TIMESTAMP_STATUS		0x00000d20
 #define XGMAC_TXTSC			BIT(15)
 #define XGMAC_TXTIMESTAMP_NSEC		0x00000d30
@@ -125,8 +137,9 @@
 #define XGMAC_MTL_INT_STATUS		0x00001020
 #define XGMAC_MTL_RXQ_DMA_MAP0		0x00001030
 #define XGMAC_MTL_RXQ_DMA_MAP1		0x00001034
-#define XGMAC_QxMDMACH(x)		GENMASK((x) * 8 + 3, (x) * 8)
+#define XGMAC_QxMDMACH(x)		GENMASK((x) * 8 + 7, (x) * 8)
 #define XGMAC_QxMDMACH_SHIFT(x)		((x) * 8)
+#define XGMAC_QDDMACH			BIT(7)
 #define XGMAC_TC_PRTY_MAP0		0x00001040
 #define XGMAC_TC_PRTY_MAP1		0x00001044
 #define XGMAC_PSTC(x)			GENMASK((x) * 8 + 7, (x) * 8)
@@ -261,6 +274,13 @@
 #define XGMAC_RDES3_IOC			BIT(30)
 #define XGMAC_RDES3_LD			BIT(28)
 #define XGMAC_RDES3_CDA			BIT(27)
+#define XGMAC_RDES3_RSV			BIT(26)
+#define XGMAC_RDES3_L34T		GENMASK(23, 20)
+#define XGMAC_RDES3_L34T_SHIFT		20
+#define XGMAC_L34T_IP4TCP		0x1
+#define XGMAC_L34T_IP4UDP		0x2
+#define XGMAC_L34T_IP6TCP		0x9
+#define XGMAC_L34T_IP6UDP		0xA
 #define XGMAC_RDES3_ES			BIT(15)
 #define XGMAC_RDES3_PL			GENMASK(13, 0)
 #define XGMAC_RDES3_TSD			BIT(6)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index bfbd5ae11540..04eec85acc59 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -6,6 +6,7 @@
 
 #include <linux/bitrev.h>
 #include <linux/crc32.h>
+#include <linux/iopoll.h>
 #include "stmmac.h"
 #include "dwxgmac2.h"
 
@@ -439,6 +440,56 @@ static void dwxgmac2_set_mac_loopback(void __iomem *ioaddr, bool enable)
 	writel(value, ioaddr + XGMAC_RX_CONFIG);
 }
 
+static int dwxgmac2_rss_write_reg(void __iomem *ioaddr, bool is_key, int idx,
+				  u32 val)
+{
+	u32 ctrl = 0;
+
+	writel(val, ioaddr + XGMAC_RSS_DATA);
+	ctrl |= idx << XGMAC_RSSIA_SHIFT;
+	ctrl |= is_key ? XGMAC_ADDRT : 0x0;
+	ctrl |= XGMAC_OB;
+	writel(ctrl, ioaddr + XGMAC_RSS_ADDR);
+
+	return readl_poll_timeout(ioaddr + XGMAC_RSS_ADDR, ctrl,
+				  !(ctrl & XGMAC_OB), 100, 10000);
+}
+
+static int dwxgmac2_rss_configure(struct mac_device_info *hw,
+				  struct stmmac_rss *cfg, u32 num_rxq)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 *key = (u32 *)cfg->key;
+	int i, ret;
+	u32 value;
+
+	value = readl(ioaddr + XGMAC_RSS_CTRL);
+	if (!cfg->enable) {
+		value &= ~XGMAC_RSSE;
+		writel(value, ioaddr + XGMAC_RSS_CTRL);
+		return 0;
+	}
+
+	for (i = 0; i < (sizeof(cfg->key) / sizeof(u32)); i++) {
+		ret = dwxgmac2_rss_write_reg(ioaddr, true, i, *key++);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cfg->table); i++) {
+		ret = dwxgmac2_rss_write_reg(ioaddr, false, i, cfg->table[i]);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < num_rxq; i++)
+		dwxgmac2_map_mtl_to_dma(hw, i, XGMAC_QDDMACH);
+
+	value |= XGMAC_UDP4TE | XGMAC_TCP4TE | XGMAC_IP2TE | XGMAC_RSSE;
+	writel(value, ioaddr + XGMAC_RSS_CTRL);
+	return 0;
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -469,6 +520,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.debug = NULL,
 	.set_filter = dwxgmac2_set_filter,
 	.set_mac_loopback = dwxgmac2_set_mac_loopback,
+	.rss_configure = dwxgmac2_rss_configure,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index c4c45402b8f8..8c5dd6a36157 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -254,6 +254,34 @@ static void dwxgmac2_clear(struct dma_desc *p)
 	p->des3 = 0;
 }
 
+static int dwxgmac2_get_rx_hash(struct dma_desc *p, u32 *hash,
+				enum pkt_hash_types *type)
+{
+	unsigned int rdes3 = le32_to_cpu(p->des3);
+	u32 ptype;
+
+	if (rdes3 & XGMAC_RDES3_RSV) {
+		ptype = (rdes3 & XGMAC_RDES3_L34T) >> XGMAC_RDES3_L34T_SHIFT;
+
+		switch (ptype) {
+		case XGMAC_L34T_IP4TCP:
+		case XGMAC_L34T_IP4UDP:
+		case XGMAC_L34T_IP6TCP:
+		case XGMAC_L34T_IP6UDP:
+			*type = PKT_HASH_TYPE_L4;
+			break;
+		default:
+			*type = PKT_HASH_TYPE_L3;
+			break;
+		}
+
+		*hash = le32_to_cpu(p->des1);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
 const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.tx_status = dwxgmac2_get_tx_status,
 	.rx_status = dwxgmac2_get_rx_status,
@@ -277,4 +305,5 @@ const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.get_addr = dwxgmac2_get_addr,
 	.set_addr = dwxgmac2_set_addr,
 	.clear = dwxgmac2_clear,
+	.get_rx_hash = dwxgmac2_get_rx_hash,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 0f1c772e892a..45a6634ee397 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -363,6 +363,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 
 	/* MAC HW feature 1 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
+	dma_cap->rssen = (hw_cap & XGMAC_HWFEAT_RSSEN) >> 20;
 	dma_cap->tsoen = (hw_cap & XGMAC_HWFEAT_TSOEN) >> 18;
 
 	dma_cap->addr64 = (hw_cap & XGMAC_HWFEAT_ADDR64) >> 14;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 00539a09d1db..bfe7efee9481 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -86,6 +86,9 @@ struct stmmac_desc_ops {
 	void (*set_addr)(struct dma_desc *p, dma_addr_t addr);
 	/* clear descriptor */
 	void (*clear)(struct dma_desc *p);
+	/* RSS */
+	int (*get_rx_hash)(struct dma_desc *p, u32 *hash,
+			   enum pkt_hash_types *type);
 };
 
 #define stmmac_init_rx_desc(__priv, __args...) \
@@ -136,6 +139,8 @@ struct stmmac_desc_ops {
 	stmmac_do_void_callback(__priv, desc, set_addr, __args)
 #define stmmac_clear_desc(__priv, __args...) \
 	stmmac_do_void_callback(__priv, desc, clear, __args)
+#define stmmac_get_rx_hash(__priv, __args...) \
+	stmmac_do_callback(__priv, desc, get_rx_hash, __args)
 
 struct stmmac_dma_cfg;
 struct dma_features;
@@ -249,6 +254,7 @@ struct rgmii_adv;
 struct stmmac_safety_stats;
 struct stmmac_tc_entry;
 struct stmmac_pps_cfg;
+struct stmmac_rss;
 
 /* Helpers to program the MAC core */
 struct stmmac_ops {
@@ -327,6 +333,9 @@ struct stmmac_ops {
 			       u32 sub_second_inc, u32 systime_flags);
 	/* Loopback for selftests */
 	void (*set_mac_loopback)(void __iomem *ioaddr, bool enable);
+	/* RSS */
+	int (*rss_configure)(struct mac_device_info *hw,
+			     struct stmmac_rss *cfg, u32 num_rxq);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -397,6 +406,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, flex_pps_config, __args)
 #define stmmac_set_mac_loopback(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, set_mac_loopback, __args)
+#define stmmac_rss_configure(__priv, __args...) \
+	stmmac_do_callback(__priv, mac, rss_configure, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 5cd966c154f3..d2f6f56ae29c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -113,6 +113,12 @@ struct stmmac_pps_cfg {
 	struct timespec64 period;
 };
 
+struct stmmac_rss {
+	int enable;
+	u8 key[STMMAC_RSS_HASH_KEY_SIZE];
+	u32 table[STMMAC_RSS_MAX_TABLE_SIZE];
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames;
@@ -203,6 +209,9 @@ struct stmmac_priv {
 
 	/* Pulse Per Second output */
 	struct stmmac_pps_cfg pps[STMMAC_PPS_MAX];
+
+	/* Receive Side Scaling */
+	struct stmmac_rss rss;
 };
 
 enum stmmac_state {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index d294590cba27..2423160ab582 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -764,6 +764,76 @@ static int stmmac_set_coalesce(struct net_device *dev,
 	return 0;
 }
 
+static int stmmac_get_rxnfc(struct net_device *dev,
+			    struct ethtool_rxnfc *rxnfc, u32 *rule_locs)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	switch (rxnfc->cmd) {
+	case ETHTOOL_GRXRINGS:
+		rxnfc->data = priv->plat->rx_queues_to_use;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static u32 stmmac_get_rxfh_key_size(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	return sizeof(priv->rss.key);
+}
+
+static u32 stmmac_get_rxfh_indir_size(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	return ARRAY_SIZE(priv->rss.table);
+}
+
+static int stmmac_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
+			   u8 *hfunc)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	int i;
+
+	if (indir) {
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			indir[i] = priv->rss.table[i];
+	}
+
+	if (key)
+		memcpy(key, priv->rss.key, sizeof(priv->rss.key));
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	return 0;
+}
+
+static int stmmac_set_rxfh(struct net_device *dev, const u32 *indir,
+			   const u8 *key, const u8 hfunc)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+	int i;
+
+	if ((hfunc != ETH_RSS_HASH_NO_CHANGE) && (hfunc != ETH_RSS_HASH_TOP))
+		return -EOPNOTSUPP;
+
+	if (indir) {
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = indir[i];
+	}
+
+	if (key)
+		memcpy(priv->rss.key, key, sizeof(priv->rss.key));
+
+	return stmmac_rss_configure(priv, priv->hw, &priv->rss,
+				    priv->plat->rx_queues_to_use);
+}
+
 static int stmmac_get_ts_info(struct net_device *dev,
 			      struct ethtool_ts_info *info)
 {
@@ -855,6 +925,11 @@ static const struct ethtool_ops stmmac_ethtool_ops = {
 	.get_eee = stmmac_ethtool_op_get_eee,
 	.set_eee = stmmac_ethtool_op_set_eee,
 	.get_sset_count	= stmmac_get_sset_count,
+	.get_rxnfc = stmmac_get_rxnfc,
+	.get_rxfh_key_size = stmmac_get_rxfh_key_size,
+	.get_rxfh_indir_size = stmmac_get_rxfh_indir_size,
+	.get_rxfh = stmmac_get_rxfh,
+	.set_rxfh = stmmac_set_rxfh,
 	.get_ts_info = stmmac_get_ts_info,
 	.get_coalesce = stmmac_get_coalesce,
 	.set_coalesce = stmmac_set_coalesce,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fd54c7c87485..404a0548f213 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2417,6 +2417,22 @@ static void stmmac_mac_config_rx_queues_routing(struct stmmac_priv *priv)
 	}
 }
 
+static void stmmac_mac_config_rss(struct stmmac_priv *priv)
+{
+	if (!priv->dma_cap.rssen || !priv->plat->rss_en) {
+		priv->rss.enable = false;
+		return;
+	}
+
+	if (priv->dev->features & NETIF_F_RXHASH)
+		priv->rss.enable = true;
+	else
+		priv->rss.enable = false;
+
+	stmmac_rss_configure(priv, priv->hw, &priv->rss,
+			     priv->plat->rx_queues_to_use);
+}
+
 /**
  *  stmmac_mtl_configuration - Configure MTL
  *  @priv: driver private structure
@@ -2461,6 +2477,10 @@ static void stmmac_mtl_configuration(struct stmmac_priv *priv)
 	/* Set RX routing */
 	if (rx_queues_count > 1)
 		stmmac_mac_config_rx_queues_routing(priv);
+
+	/* Receive Side Scaling */
+	if (rx_queues_count > 1)
+		stmmac_mac_config_rss(priv);
 }
 
 static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
@@ -3385,9 +3405,11 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			priv->dev->stats.rx_errors++;
 			buf->page = NULL;
 		} else {
+			enum pkt_hash_types hash_type;
 			struct sk_buff *skb;
-			int frame_len;
 			unsigned int des;
+			int frame_len;
+			u32 hash;
 
 			stmmac_get_desc_addr(priv, p, &des);
 			frame_len = stmmac_get_rx_frame_len(priv, p, coe);
@@ -3452,6 +3474,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			else
 				skb->ip_summed = CHECKSUM_UNNECESSARY;
 
+			if (!stmmac_get_rx_hash(priv, p, &hash, &hash_type))
+				skb_set_hash(skb, hash, hash_type);
+
+			skb_record_rx_queue(skb, queue);
 			napi_gro_receive(&ch->rx_napi, skb);
 
 			/* Data payload copied into SKB, page ready for recycle */
@@ -4175,8 +4201,8 @@ int stmmac_dvr_probe(struct device *device,
 {
 	struct net_device *ndev = NULL;
 	struct stmmac_priv *priv;
-	u32 queue, maxq;
-	int ret = 0;
+	u32 queue, rxq, maxq;
+	int i, ret = 0;
 
 	ndev = devm_alloc_etherdev_mqs(device, sizeof(struct stmmac_priv),
 				       MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES);
@@ -4284,6 +4310,15 @@ int stmmac_dvr_probe(struct device *device,
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
 
+	/* Initialize RSS */
+	rxq = priv->plat->rx_queues_to_use;
+	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
+	for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rxq);
+
+	if (priv->dma_cap.rssen && priv->plat->rss_en)
+		ndev->features |= NETIF_F_RXHASH;
+
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
 	if ((priv->plat->enh_desc) || (priv->synopsys_id >= DWMAC_CORE_4_00))
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 7b3e354bcd3c..5cc6b6faf359 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -173,6 +173,7 @@ struct plat_stmmacenet_data {
 	int has_gmac4;
 	bool has_sun8i;
 	bool tso_en;
+	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
 	int has_xgmac;
-- 
2.7.4

