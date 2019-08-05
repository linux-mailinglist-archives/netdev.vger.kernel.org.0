Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635A3822D9
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730111AbfHEQqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:46:21 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:39912 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729001AbfHEQpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:30 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 38F06C01C5;
        Mon,  5 Aug 2019 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023529; bh=kbqd7Pd0ftOuwKtxo0J87TsV9ByL7kf96qpQ1FecyPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=HKEUnZs95tNsoBm7+WGONJzpd7hDk4Np3X35uU87/m/65JOAb+1Fa4yD0RuFeiLLc
         bhzSdPIO/1T21TSWRgEobQqlwhgswzF00cfI5MTykL16YslIJbv0AX801nqobNucHf
         bWq2YBdxUNf6r/o+2Yjssx0GZC5VXozzScjRrOjxHOjeNtCnr/aTxzL9Dfqihe63Cs
         MmljHKb2Gzbc4GWfw6lm/Iecsy1t4Y249WBs4S13rDRl7N+yrmQ+PsJjuP0tuOLbf6
         Sav1p4qX04N6iOjtLIqqRVUgjP6gNa9fj2SdvfNXK+Pn7N3S2QZS82bbFq4i3hFZYC
         ECecc07PAMF0A==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 0001DA0090;
        Mon,  5 Aug 2019 16:45:27 +0000 (UTC)
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
Subject: [PATCH net-next 17/26] net: stmmac: Add Split Header support and enable it in XGMAC cores
Date:   Mon,  5 Aug 2019 18:44:44 +0200
Message-Id: <0ff86f0e550bbbb932672fba5ed9a10f17d4fc32.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the support for Split Header feature in the RX path and enable it in
XGMAC cores.

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
 drivers/net/ethernet/stmicro/stmmac/common.h       |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |  6 ++
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   | 18 +++++-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c | 18 ++++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |  9 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 68 +++++++++++++++++++++-
 7 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index e1e6f67041ec..527f961579f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -356,6 +356,7 @@ struct dma_features {
 	unsigned int addr64;
 	unsigned int rssen;
 	unsigned int vlhash;
+	unsigned int sphen;
 };
 
 /* GMAC TX FIFO is 8K, Rx FIFO is 16K */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 01bd20ab34a5..067cedb48706 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -32,6 +32,9 @@
 #define XGMAC_CONFIG_ARPEN		BIT(31)
 #define XGMAC_CONFIG_GPSL		GENMASK(29, 16)
 #define XGMAC_CONFIG_GPSL_SHIFT		16
+#define XGMAC_CONFIG_HDSMS		GENMASK(14, 12)
+#define XGMAC_CONFIG_HDSMS_SHIFT	12
+#define XGMAC_CONFIG_HDSMS_256		(0x2 << XGMAC_CONFIG_HDSMS_SHIFT)
 #define XGMAC_CONFIG_S2KP		BIT(11)
 #define XGMAC_CONFIG_LM			BIT(10)
 #define XGMAC_CONFIG_IPC		BIT(9)
@@ -101,6 +104,7 @@
 #define XGMAC_HW_FEATURE1		0x00000120
 #define XGMAC_HWFEAT_RSSEN		BIT(20)
 #define XGMAC_HWFEAT_TSOEN		BIT(18)
+#define XGMAC_HWFEAT_SPHEN		BIT(17)
 #define XGMAC_HWFEAT_ADDR64		GENMASK(15, 14)
 #define XGMAC_HWFEAT_TXFIFOSIZE		GENMASK(10, 6)
 #define XGMAC_HWFEAT_RXFIFOSIZE		GENMASK(4, 0)
@@ -258,6 +262,7 @@
 #define XGMAC_TCEIE			BIT(0)
 #define XGMAC_DMA_ECC_INT_STATUS	0x0000306c
 #define XGMAC_DMA_CH_CONTROL(x)		(0x00003100 + (0x80 * (x)))
+#define XGMAC_SPH			BIT(24)
 #define XGMAC_PBLx8			BIT(16)
 #define XGMAC_DMA_CH_TX_CONTROL(x)	(0x00003104 + (0x80 * (x)))
 #define XGMAC_TxPBL			GENMASK(21, 16)
@@ -318,6 +323,7 @@
 #define XGMAC_TDES3_CIC_SHIFT		16
 #define XGMAC_TDES3_TPL			GENMASK(17, 0)
 #define XGMAC_TDES3_FL			GENMASK(14, 0)
+#define XGMAC_RDES2_HL			GENMASK(9, 0)
 #define XGMAC_RDES3_OWN			BIT(31)
 #define XGMAC_RDES3_CTXT		BIT(30)
 #define XGMAC_RDES3_IOC			BIT(30)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
index bae8bd41a769..4cef7a3bf8df 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_descs.c
@@ -29,6 +29,8 @@ static int dwxgmac2_get_rx_status(void *data, struct stmmac_extra_stats *x,
 
 	if (unlikely(rdes3 & XGMAC_RDES3_OWN))
 		return dma_own;
+	if (unlikely(rdes3 & XGMAC_RDES3_CTXT))
+		return discard_frame;
 	if (likely(!(rdes3 & XGMAC_RDES3_LD)))
 		return rx_not_ls;
 	if (unlikely((rdes3 & XGMAC_RDES3_ES) && (rdes3 & XGMAC_RDES3_LD)))
@@ -54,7 +56,7 @@ static void dwxgmac2_set_tx_owner(struct dma_desc *p)
 
 static void dwxgmac2_set_rx_owner(struct dma_desc *p, int disable_rx_ic)
 {
-	p->des3 = cpu_to_le32(XGMAC_RDES3_OWN);
+	p->des3 |= cpu_to_le32(XGMAC_RDES3_OWN);
 
 	if (!disable_rx_ic)
 		p->des3 |= cpu_to_le32(XGMAC_RDES3_IOC);
@@ -285,6 +287,18 @@ static int dwxgmac2_get_rx_hash(struct dma_desc *p, u32 *hash,
 	return -EINVAL;
 }
 
+static int dwxgmac2_get_rx_header_len(struct dma_desc *p, unsigned int *len)
+{
+	*len = le32_to_cpu(p->des2) & XGMAC_RDES2_HL;
+	return 0;
+}
+
+static void dwxgmac2_set_sec_addr(struct dma_desc *p, dma_addr_t addr)
+{
+	p->des2 = cpu_to_le32(lower_32_bits(addr));
+	p->des3 = cpu_to_le32(upper_32_bits(addr));
+}
+
 const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.tx_status = dwxgmac2_get_tx_status,
 	.rx_status = dwxgmac2_get_rx_status,
@@ -309,4 +323,6 @@ const struct stmmac_desc_ops dwxgmac210_desc_ops = {
 	.set_addr = dwxgmac2_set_addr,
 	.clear = dwxgmac2_clear,
 	.get_rx_hash = dwxgmac2_get_rx_hash,
+	.get_rx_header_len = dwxgmac2_get_rx_header_len,
+	.set_sec_addr = dwxgmac2_set_sec_addr,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
index 18cbf4ab4ad2..0f3de4895cf7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c
@@ -366,6 +366,7 @@ static void dwxgmac2_get_hw_feature(void __iomem *ioaddr,
 	hw_cap = readl(ioaddr + XGMAC_HW_FEATURE1);
 	dma_cap->rssen = (hw_cap & XGMAC_HWFEAT_RSSEN) >> 20;
 	dma_cap->tsoen = (hw_cap & XGMAC_HWFEAT_TSOEN) >> 18;
+	dma_cap->sphen = (hw_cap & XGMAC_HWFEAT_SPHEN) >> 17;
 
 	dma_cap->addr64 = (hw_cap & XGMAC_HWFEAT_ADDR64) >> 14;
 	switch (dma_cap->addr64) {
@@ -472,6 +473,22 @@ static void dwxgmac2_set_bfsize(void __iomem *ioaddr, int bfsize, u32 chan)
 	writel(value, ioaddr + XGMAC_DMA_CH_RX_CONTROL(chan));
 }
 
+static void dwxgmac2_enable_sph(void __iomem *ioaddr, bool en, u32 chan)
+{
+	u32 value = readl(ioaddr + XGMAC_RX_CONFIG);
+
+	value &= ~XGMAC_CONFIG_HDSMS;
+	value |= XGMAC_CONFIG_HDSMS_256; /* Segment max 256 bytes */
+	writel(value, ioaddr + XGMAC_RX_CONFIG);
+
+	value = readl(ioaddr + XGMAC_DMA_CH_CONTROL(chan));
+	if (en)
+		value |= XGMAC_SPH;
+	else
+		value &= ~XGMAC_SPH;
+	writel(value, ioaddr + XGMAC_DMA_CH_CONTROL(chan));
+}
+
 const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.reset = dwxgmac2_dma_reset,
 	.init = dwxgmac2_dma_init,
@@ -498,4 +515,5 @@ const struct stmmac_dma_ops dwxgmac210_dma_ops = {
 	.enable_tso = dwxgmac2_enable_tso,
 	.qmode = dwxgmac2_qmode,
 	.set_bfsize = dwxgmac2_set_bfsize,
+	.enable_sph = dwxgmac2_enable_sph,
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 7e1523c6f456..ed9fda50ee22 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -89,6 +89,8 @@ struct stmmac_desc_ops {
 	/* RSS */
 	int (*get_rx_hash)(struct dma_desc *p, u32 *hash,
 			   enum pkt_hash_types *type);
+	int (*get_rx_header_len)(struct dma_desc *p, unsigned int *len);
+	void (*set_sec_addr)(struct dma_desc *p, dma_addr_t addr);
 };
 
 #define stmmac_init_rx_desc(__priv, __args...) \
@@ -141,6 +143,10 @@ struct stmmac_desc_ops {
 	stmmac_do_void_callback(__priv, desc, clear, __args)
 #define stmmac_get_rx_hash(__priv, __args...) \
 	stmmac_do_callback(__priv, desc, get_rx_hash, __args)
+#define stmmac_get_rx_header_len(__priv, __args...) \
+	stmmac_do_callback(__priv, desc, get_rx_header_len, __args)
+#define stmmac_set_desc_sec_addr(__priv, __args...) \
+	stmmac_do_void_callback(__priv, desc, set_sec_addr, __args)
 
 struct stmmac_dma_cfg;
 struct dma_features;
@@ -191,6 +197,7 @@ struct stmmac_dma_ops {
 	void (*enable_tso)(void __iomem *ioaddr, bool en, u32 chan);
 	void (*qmode)(void __iomem *ioaddr, u32 channel, u8 qmode);
 	void (*set_bfsize)(void __iomem *ioaddr, int bfsize, u32 chan);
+	void (*enable_sph)(void __iomem *ioaddr, bool en, u32 chan);
 };
 
 #define stmmac_reset(__priv, __args...) \
@@ -247,6 +254,8 @@ struct stmmac_dma_ops {
 	stmmac_do_void_callback(__priv, dma, qmode, __args)
 #define stmmac_set_dma_bfsize(__priv, __args...) \
 	stmmac_do_void_callback(__priv, dma, set_bfsize, __args)
+#define stmmac_enable_sph(__priv, __args...) \
+	stmmac_do_void_callback(__priv, dma, enable_sph, __args)
 
 struct mac_device_info;
 struct net_device;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index be9ee3d7ec35..e91dcb5196f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -58,7 +58,9 @@ struct stmmac_tx_queue {
 
 struct stmmac_rx_buffer {
 	struct page *page;
+	struct page *sec_page;
 	dma_addr_t addr;
+	dma_addr_t sec_addr;
 };
 
 struct stmmac_rx_queue {
@@ -136,6 +138,7 @@ struct stmmac_priv {
 	int hwts_tx_en;
 	bool tx_path_in_lpi_mode;
 	bool tso;
+	int sph;
 
 	unsigned int dma_buf_sz;
 	unsigned int rx_copybreak;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e1ef8de952cc..fef64e415447 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1206,6 +1206,17 @@ static int stmmac_init_rx_buffers(struct stmmac_priv *priv, struct dma_desc *p,
 	if (!buf->page)
 		return -ENOMEM;
 
+	if (priv->sph) {
+		buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+		if (!buf->sec_page)
+			return -ENOMEM;
+
+		buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
+	} else {
+		buf->sec_page = NULL;
+	}
+
 	buf->addr = page_pool_get_dma_addr(buf->page);
 	stmmac_set_desc_addr(priv, p, buf->addr);
 	if (priv->dma_buf_sz == BUF_SIZE_16KiB)
@@ -1228,6 +1239,10 @@ static void stmmac_free_rx_buffer(struct stmmac_priv *priv, u32 queue, int i)
 	if (buf->page)
 		page_pool_put_page(rx_q->page_pool, buf->page, false);
 	buf->page = NULL;
+
+	if (buf->sec_page)
+		page_pool_put_page(rx_q->page_pool, buf->sec_page, false);
+	buf->sec_page = NULL;
 }
 
 /**
@@ -2602,6 +2617,12 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			stmmac_enable_tso(priv, priv->ioaddr, 1, chan);
 	}
 
+	/* Enable Split Header */
+	if (priv->sph && priv->hw->rx_csum) {
+		for (chan = 0; chan < rx_cnt; chan++)
+			stmmac_enable_sph(priv, priv->ioaddr, 1, chan);
+	}
+
 	/* Start the ball rolling... */
 	stmmac_start_all_dma(priv);
 
@@ -3321,6 +3342,14 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 				break;
 		}
 
+		if (priv->sph && !buf->sec_page) {
+			buf->sec_page = page_pool_dev_alloc_pages(rx_q->page_pool);
+			if (!buf->sec_page)
+				break;
+
+			buf->sec_addr = page_pool_get_dma_addr(buf->sec_page);
+		}
+
 		buf->addr = page_pool_get_dma_addr(buf->page);
 
 		/* Sync whole allocation to device. This will invalidate old
@@ -3330,6 +3359,7 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
 					   DMA_FROM_DEVICE);
 
 		stmmac_set_desc_addr(priv, p, buf->addr);
+		stmmac_set_desc_sec_addr(priv, p, buf->sec_addr);
 		stmmac_refill_desc3(priv, rx_q, p);
 
 		rx_q->rx_count_frames++;
@@ -3376,10 +3406,11 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_display_ring(priv, rx_head, DMA_RX_SIZE, true);
 	}
 	while (count < limit) {
+		unsigned int hlen = 0, prev_len = 0;
 		enum pkt_hash_types hash_type;
 		struct stmmac_rx_buffer *buf;
-		unsigned int prev_len = 0;
 		struct dma_desc *np, *p;
+		unsigned int sec_len;
 		int entry;
 		u32 hash;
 
@@ -3395,6 +3426,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 read_again:
+		sec_len = 0;
+
 		if (count >= limit)
 			break;
 
@@ -3464,6 +3497,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		}
 
 		if (!skb) {
+			int ret = stmmac_get_rx_header_len(priv, p, &hlen);
+
+			if (priv->sph && !ret && (hlen > 0)) {
+				sec_len = len;
+				if (!(status & rx_not_ls))
+					sec_len = sec_len - hlen;
+				len = hlen;
+			}
+
 			skb = netdev_alloc_skb_ip_align(priv->dev, len);
 			if (!skb) {
 				priv->dev->stats.rx_dropped++;
@@ -3496,6 +3538,18 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			buf->page = NULL;
 		}
 
+		if (sec_len > 0) {
+			dma_sync_single_for_cpu(priv->device, buf->sec_addr,
+						sec_len, DMA_FROM_DEVICE);
+			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+					buf->sec_page, 0, sec_len,
+					priv->dma_buf_sz);
+
+			/* Data payload appended into SKB */
+			page_pool_release_page(rx_q->page_pool, buf->sec_page);
+			buf->sec_page = NULL;
+		}
+
 		if (likely(status & rx_not_ls))
 			goto read_again;
 
@@ -3670,6 +3724,8 @@ static int stmmac_set_features(struct net_device *netdev,
 			       netdev_features_t features)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
+	bool sph_en;
+	u32 chan;
 
 	/* Keep the COE Type in case of csum is supporting */
 	if (features & NETIF_F_RXCSUM)
@@ -3681,6 +3737,10 @@ static int stmmac_set_features(struct net_device *netdev,
 	 */
 	stmmac_rx_ipc(priv, priv->hw);
 
+	sph_en = (priv->hw->rx_csum > 0) && priv->sph;
+	for (chan = 0; chan < priv->plat->rx_queues_to_use; chan++)
+		stmmac_enable_sph(priv, priv->ioaddr, sph_en, chan);
+
 	return 0;
 }
 
@@ -4398,6 +4458,12 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
+	if (priv->dma_cap.sphen) {
+		ndev->hw_features |= NETIF_F_GRO;
+		priv->sph = true;
+		dev_info(priv->device, "SPH feature enabled\n");
+	}
+
 	if (priv->dma_cap.addr64) {
 		ret = dma_set_mask_and_coherent(device,
 				DMA_BIT_MASK(priv->dma_cap.addr64));
-- 
2.7.4

