Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E641882A6
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436723AbfHISgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:36:32 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:38448 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407324AbfHISgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:36:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A72FDC0BB8
        for <netdev@vger.kernel.org>; Fri,  9 Aug 2019 18:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565375791; bh=f6r7gn2+H+HxvCY1GQmlHnFMy1ZVWDsa1iyIFzV1j3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=CiWWbmTbDAZpJoeISVOtIN3GFEWDb7MzMxtbAJ1PNZhuebhZLYrEsY7raMenIlxs5
         0uU7nv79eCamsv/HqDigIvUSiKPTnuaeI1Bp9xHUjy2JbQnmI5CusmwBDVYQ3UkSx7
         pnicFi1EPRICh97mu+BSXqlN68N3VNEwiWStP6Ileg7G3khbDEGeJUyvkJfrmsOa2C
         7caB7muAL+Q2ZaC93o/jzOVvANmYzZCdYo/zhrKpqZdLzcWcrIlZpNgIiXHwgCHnL8
         Bx3AYL9ZuT6vN0MGDRHMwb2a/aXS0iceTDsdA/tUNFONeWl2Qd4cTxAai0OjP/+Rar
         ENqX9EYj6I57A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 64B15A0073;
        Fri,  9 Aug 2019 18:36:29 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH net-next 08/12] net: stmmac: Add support for SA Insertion/Replacement in XGMAC cores
Date:   Fri,  9 Aug 2019 20:36:16 +0200
Message-Id: <f1eddda7b88346a792fc4594789966f32fb1b100.1565375521.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for Source Address Insertion and Replacement in XGMAC
cores. Two methods are supported: Descriptor based and register based.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
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
index 2093c996a090..16e3a0a0c826 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_core.c
@@ -1082,6 +1082,16 @@ static int dwxgmac2_flex_pps_config(void __iomem *ioaddr, int index,
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
@@ -1120,6 +1130,7 @@ const struct stmmac_ops dwxgmac210_ops = {
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
index e91dcb5196f6..39911c8e90c1 100644
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
index e74c1d822aaa..a0c276ad5718 100644
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

