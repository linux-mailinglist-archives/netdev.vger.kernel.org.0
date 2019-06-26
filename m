Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D4E56B14
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbfFZNsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 09:48:03 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51176 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727880AbfFZNrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 09:47:55 -0400
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C8414C0C4D;
        Wed, 26 Jun 2019 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1561556874; bh=+Ym19PhJrtzWq7kmLyPlQj3OgYihQHO41R3orpZdj2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=hry0JJ5TF9KtugHyhV7ZEOIkt4d9HmyRlrwdhEarIPoHv8yw/vSosrE6ZWAe6zf/K
         l+yf/lIZCas07bzNyIWaPB87d2VJqKv6cFrKWp1yTYXYxHChSFoKYAdyQgQoWVGtZ7
         5zmS9kn1tr/dnnk1kIzXyF7nQuC7paHCLFUSLgDjcIvKDwFh7gmez9Jlk/qfZddEp3
         jpx/gFSDp9OXVlrE/xAKIwFm3hAbQhuBgOwoCFXHfJYv1xGRLInVjM+84DAFNENYnO
         KFWu+72ozuuvNd4THK/WIEB8SXGGbdwhi+JKWT4GRAg7Ba9abOBxVB32JqNA9YdwCE
         S/yWFGkr+yQAw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 4D7E1A0072;
        Wed, 26 Jun 2019 13:47:52 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 203F93B572;
        Wed, 26 Jun 2019 15:47:52 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>
Subject: [PATCH net-next 07/10] net: stmmac: Enable support for > 32 Bits addressing in XGMAC
Date:   Wed, 26 Jun 2019 15:47:41 +0200
Message-Id: <64b73591f981b3a280ea61d21a0dc7362a25348a.1561556556.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
In-Reply-To: <cover.1561556555.git.joabreu@synopsys.com>
References: <cover.1561556555.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, stmmac only supports 32 bits addressing for SKB. Enable the
support for upto 48 bits addressing in XGMAC core.

This avoids the use of bounce buffers and increases performance.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Joao Pinto <jpinto@synopsys.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h       |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  2 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |  4 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 19 ++++++++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 46 ++++++++++++++++------
 5 files changed, 57 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 9e8f4dbdcc22..2403a65167b2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -351,6 +351,7 @@ struct dma_features {
 	unsigned int frpsel;
 	unsigned int frpbs;
 	unsigned int frpes;
+	unsigned int addr64;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 9077b54cbfac..49b0d945052c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -87,6 +87,7 @@
 #define XGMAC_HWFEAT_GMIISEL		BIT(1)
 #define XGMAC_HW_FEATURE1		0x00000120
 #define XGMAC_HWFEAT_TSOEN		BIT(18)
+#define XGMAC_HWFEAT_ADDR64		GENMASK(15, 14)
 #define XGMAC_HWFEAT_TXFIFOSIZE		GENMASK(10, 6)
 #define XGMAC_HWFEAT_RXFIFOSIZE		GENMASK(4, 0)
 #define XGMAC_HW_FEATURE2		0x00000124
@@ -172,6 +173,7 @@
 #define XGMAC_EN_LPI			BIT(15)
 #define XGMAC_LPI_XIT_PKT		BIT(14)
 #define XGMAC_AAL			BIT(12)
+#define XGMAC_EAME			BIT(11)
 #define XGMAC_BLEN			GENMASK(7, 1)
 #define XGMAC_BLEN256			BIT(7)
 #define XGMAC_BLEN128			BIT(6)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index 98fa471da7c0..c4c45402b8f8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -242,8 +242,8 @@ static void dwxgmac2_get_addr(struct dma_desc *p, unsigned int *addr)
 
 static void dwxgmac2_set_addr(struct dma_desc *p, dma_addr_t addr)
 {
-	p->des0 = cpu_to_le32(addr);
-	p->des1 = 0;
+	p->des0 = cpu_to_le32(lower_32_bits(addr));
+	p->des1 = cpu_to_le32(upper_32_bits(addr));
 }
 
 static void dwxgmac2_clear(struct dma_desc *p)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 3f84271da836..08f3ed675a39 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -27,7 +27,7 @@ static void dwxgmac2_dma_init(void __iomem *ioaddr,
 	if (dma_cfg->aal)
 		value |= XGMAC_AAL;
 
-	writel(value, ioaddr + XGMAC_DMA_SYSBUS_MODE);
+	writel(value | XGMAC_EAME, ioaddr + XGMAC_DMA_SYSBUS_MODE);
 }
 
 static void dwxgmac2_dma_init_chan(void __iomem *ioaddr,
@@ -361,6 +361,23 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	/* MAC HW feature 1 */
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
 	dma_cap->tsoen = (hw_cap & XGMAC_HWFEAT_TSOEN) >> 18;
+
+	dma_cap->addr64 = (hw_cap & XGMAC_HWFEAT_ADDR64) >> 14;
+	switch (dma_cap->addr64) {
+	case 0:
+		dma_cap->addr64 = 32;
+		break;
+	case 1:
+		dma_cap->addr64 = 40;
+		break;
+	case 2:
+		dma_cap->addr64 = 48;
+		break;
+	default:
+		dma_cap->addr64 = 32;
+		break;
+	}
+
 	dma_cap->tx_fifo_size =
 		128 << ((hw_cap & XGMAC_HWFEAT_TXFIFOSIZE) >> 6);
 	dma_cap->rx_fifo_size =
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3a6fac22854e..65ff2a2a15e4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2768,7 +2768,7 @@ static int stmmac_release(struct net_device *dev)
  *  This function fills descriptor and request new descriptors according to
  *  buffer length to fill
  */
-static void stmmac_tso_allocator(struct stmmac_priv *priv, unsigned int des,
+static void stmmac_tso_allocator(struct stmmac_priv *priv, dma_addr_t des,
 				 int total_len, bool last_segment, u32 queue)
 {
 	struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
@@ -2779,11 +2779,18 @@ static void stmmac_tso_allocator(struct stmmac_priv *priv, unsigned int des,
 	tmp_len = total_len;
 
 	while (tmp_len > 0) {
+		dma_addr_t curr_addr;
+
 		tx_q->cur_tx = STMMAC_GET_ENTRY(tx_q->cur_tx, DMA_TX_SIZE);
 		WARN_ON(tx_q->tx_skbuff[tx_q->cur_tx]);
 		desc = tx_q->dma_tx + tx_q->cur_tx;
 
-		desc->des0 = cpu_to_le32(des + (total_len - tmp_len));
+		curr_addr = des + (total_len - tmp_len);
+		if (priv->dma_cap.addr64 <= 32)
+			desc->des0 = cpu_to_le32(curr_addr);
+		else
+			stmmac_set_desc_addr(priv, desc, curr_addr);
+
 		buff_size = tmp_len >= TSO_MAX_BUFF_SIZE ?
 			    TSO_MAX_BUFF_SIZE : tmp_len;
 
@@ -2829,11 +2836,12 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int nfrags = skb_shinfo(skb)->nr_frags;
 	u32 queue = skb_get_queue_mapping(skb);
-	unsigned int first_entry, des;
+	unsigned int first_entry;
 	struct stmmac_tx_queue *tx_q;
 	int tmp_pay_len = 0;
 	u32 pay_len, mss;
 	u8 proto_hdr_len;
+	dma_addr_t des;
 	int i;
 
 	tx_q = &priv->tx_queue[queue];
@@ -2890,14 +2898,19 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_q->tx_skbuff_dma[first_entry].buf = des;
 	tx_q->tx_skbuff_dma[first_entry].len = skb_headlen(skb);
 
-	first->des0 = cpu_to_le32(des);
+	if (priv->dma_cap.addr64 <= 32) {
+		first->des0 = cpu_to_le32(des);
 
-	/* Fill start of payload in buff2 of first descriptor */
-	if (pay_len)
-		first->des1 = cpu_to_le32(des + proto_hdr_len);
+		/* Fill start of payload in buff2 of first descriptor */
+		if (pay_len)
+			first->des1 = cpu_to_le32(des + proto_hdr_len);
 
-	/* If needed take extra descriptors to fill the remaining payload */
-	tmp_pay_len = pay_len - TSO_MAX_BUFF_SIZE;
+		/* If needed take extra descriptors to fill the remaining payload */
+		tmp_pay_len = pay_len - TSO_MAX_BUFF_SIZE;
+	} else {
+		stmmac_set_desc_addr(priv, first, des);
+		tmp_pay_len = pay_len;
+	}
 
 	stmmac_tso_allocator(priv, des, tmp_pay_len, (nfrags == 0), queue);
 
@@ -3024,12 +3037,12 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	int i, csum_insertion = 0, is_jumbo = 0;
 	u32 queue = skb_get_queue_mapping(skb);
 	int nfrags = skb_shinfo(skb)->nr_frags;
-	int entry;
-	unsigned int first_entry;
 	struct dma_desc *desc, *first;
 	struct stmmac_tx_queue *tx_q;
+	unsigned int first_entry;
 	unsigned int enh_desc;
-	unsigned int des;
+	dma_addr_t des;
+	int entry;
 
 	tx_q = &priv->tx_queue[queue];
 
@@ -4306,6 +4319,15 @@ int stmmac_dvr_probe(struct device *device,
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
+
+	if (priv->dma_cap.addr64) {
+		ret = dma_set_mask_and_coherent(device,
+				DMA_BIT_MASK(priv->dma_cap.addr64));
+		if (!ret)
+			dev_info(priv->device, "Using %d bits DMA width\n",
+				 priv->dma_cap.addr64);
+	}
+
 	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
-- 
2.7.4

