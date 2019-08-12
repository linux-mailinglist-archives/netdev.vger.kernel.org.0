Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136E689A2D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 11:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfHLJoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 05:44:32 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:50852 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727399AbfHLJoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 05:44:25 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 93E6CC2179;
        Mon, 12 Aug 2019 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565603065; bh=f5jI78zyJS8quNNNMVpvCPHz+8g5Kx8OosU494cOmWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=IRS4NgXIy6rKrtP7Hz0vNTck7I9EOeWTG29V17GtD0DrdQBCOxfR2ddyz19SW4oJ+
         CDOKONeJy3raPxy5NfyXebkGX3jkXpaGn+96j7fvwajzZbJjSfsNcCyCjYIf+ns4Fc
         n6gKB6loErvnjqR4fhuRSWgXcey/muiuSGT08T+DEoCUaQFUuXhOXAQX3f1nmZWPX/
         u3RtsH1sYuuggO4M2sr3iMhWzHdVdX5/taOZTtiP5pSv0DRXJ8D2l3flCFo0XhdAhL
         mSiUbdAH/WcBUvPs0Rw2emOrG4nU4WAjkQGMWbL4kifIVEnzb7WhpKzD56dMfHpf9F
         Y58Zi43grdJcw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4FBADA0074;
        Mon, 12 Aug 2019 09:44:23 +0000 (UTC)
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
Subject: [PATCH net-next v2 08/12] net: stmmac: Add support for SA Insertion/Replacement in XGMAC cores
Date:   Mon, 12 Aug 2019 11:44:07 +0200
Message-Id: <9f7f7c413a4e3ad80fa7270a965008ce8875b1f4.1565602974.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565602974.git.joabreu@synopsys.com>
References: <cover.1565602974.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for Source Address Insertion and Replacement in XGMAC
cores. Two methods are supported: Descriptor based and register based.

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
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h       |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c  | 11 +++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c | 10 +++++++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h           |  7 +++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h         |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  6 ++++++
 6 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 7fed3d2d4a95..3fb023953023 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -337,6 +337,8 @@
 #define XGMAC_TDES3_CPC			GENMASK(27, 26)
 #define XGMAC_TDES3_CPC_SHIFT		26
 #define XGMAC_TDES3_TCMSSV		BIT(26)
+#define XGMAC_TDES3_SAIC		GENMASK(25, 23)
+#define XGMAC_TDES3_SAIC_SHIFT		23
 #define XGMAC_TDES3_THL			GENMASK(22, 19)
 #define XGMAC_TDES3_THL_SHIFT		19
 #define XGMAC_TDES3_TSE			BIT(18)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
index a161285340c6..d0e7b62cc2ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1075,6 +1075,16 @@ static int dwxgmac2_flex_pps_config(void __iomem *ioaddr, int index,
 	return 0;
 }
 
+static void dwxgmac2_sarc_configure(void __iomem *ioaddr, int val)
+{
+	u32 value = readl(ioaddr + XGMAC_TX_CONFIG);
+
+	value &= ~XGMAC_CONFIG_SARC;
+	value |= val << XGMAC_CONFIG_SARC_SHIFT;
+
+	writel(value, ioaddr + XGMAC_TX_CONFIG);
+}
+
 const struct stmmac_ops dwxgmac210_ops = {
 	.core_init = dwxgmac2_core_init,
 	.set_mac = dwxgmac2_set_mac,
@@ -1113,6 +1123,7 @@ const struct stmmac_ops dwxgmac210_ops = {
 	.rxp_config = dwxgmac3_rxp_config,
 	.get_mac_tx_timestamp = dwxgmac2_get_mac_tx_timestamp,
 	.flex_pps_config = dwxgmac2_flex_pps_config,
+	.sarc_configure = dwxgmac2_sarc_configure,
 };
 
 int dwxgmac2_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 6d79d6fac049..c51691f7c4c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -149,7 +149,7 @@ static void dwxgmac2_prepare_tx_desc(struct dma_desc *p, int is_fs, int len,
 
 	p->des2 |= cpu_to_le32(len & XGMAC_TDES2_B1L);
 
-	tdes3 = tot_pkt_len & XGMAC_TDES3_FL;
+	tdes3 |= tot_pkt_len & XGMAC_TDES3_FL;
 	if (is_fs)
 		tdes3 |= XGMAC_TDES3_FD;
 	else
@@ -299,6 +299,13 @@ static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
 	p->des3 = cpu_to_le32(upper_32_bits(addr));
 }
 
+static void dwxgmac2_set_sarc(struct dma_desc *p, u32 sarc_type)
+{
+	sarc_type <<= XGMAC_TDES3_SAIC_SHIFT;
+
+	p->des3 |= cpu_to_le32(sarc_type & XGMAC_TDES3_SAIC);
+}
+
 const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.tx_status = dwxgmac2_get_tx_status,
 	.rx_status = dwxgmac2_get_rx_status,
@@ -325,4 +332,5 @@ const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.get_rx_hash = dwxgmac2_get_rx_hash,
 	.get_rx_header_len = dwxgmac2_get_rx_header_len,
 	.set_sec_addr = dwxgmac2_set_sec_addr,
+	.set_sarc = dwxgmac2_set_sarc,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index ed9fda50ee22..e54864cde01b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -91,6 +91,7 @@ struct stmmac_desc_ops {
 			   enum pkt_hash_types *type);
 	int (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
 	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
+	void (*set_sarc)(struct dma_desc *p, u32 sarc_type);
 };
 
 #define stmmac_init_rx_desc(__priv, __args...) \
@@ -147,6 +148,8 @@ struct stmmac_desc_ops {
 	stmmac_do_callback(__priv, desc, get_rx_header_len, __args)
 #define stmmac_set_desc_sec_addr(__priv, __args...) \
 	stmmac_do_void_callback(__priv, desc, set_sec_addr, __args)
+#define stmmac_set_desc_sarc(__priv, __args...) \
+	stmmac_do_void_callback(__priv, desc, set_sarc, __args)
 
 struct stmmac_dma_cfg;
 struct dma_features;
@@ -350,6 +353,8 @@ struct stmmac_ops {
 				 bool is_double);
 	/* TX Timestamp */
 	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
+	/* Source Address Insertion / Replacement */
+	void (*sarc_configure)(void __iomem *ioaddr, int val);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -426,6 +431,8 @@ struct stmmac_ops {
 	stmmac_do_void_callback(__priv, mac, update_vlan_hash, __args)
 #define stmmac_get_mac_tx_timestamp(__priv, __args...) \
 	stmmac_do_callback(__priv, mac, get_mac_tx_timestamp, __args)
+#define stmmac_sarc_configure(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, sarc_configure, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 4597811fd325..dcb2e29a5717 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -139,6 +139,7 @@ struct stmmac_priv {
 	bool tx_path_in_lpi_mode;
 	bool tso;
 	int sph;
+	u32 sarc_type;
 
 	unsigned int dma_buf_sz;
 	unsigned int rx_copybreak;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1fd00e18c65a..bae2f40b169a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3004,6 +3004,9 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		priv->xstats.tx_set_ic_bit++;
 	}
 
+	if (priv->sarc_type)
+		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
+
 	skb_tx_timestamp(skb);
 
 	if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
@@ -3217,6 +3220,9 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 		priv->xstats.tx_set_ic_bit++;
 	}
 
+	if (priv->sarc_type)
+		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
+
 	skb_tx_timestamp(skb);
 
 	/* Ready to fill the first descriptor and set the OWN bit w/o any
-- 
2.7.4

