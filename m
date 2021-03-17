Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCBE33E31C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhCQA4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhCQAzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 290B164F92;
        Wed, 17 Mar 2021 00:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942541;
        bh=mKEPERNOYfkzWVcJ4UHPu4I9uhgPVq1cDVFgL2FNbp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFmcxvwulXQ7NL54ASOBrLNQYqg3rKjflyDbA/qYFy0qo82OFzdxQ0HXHwUZQQZpA
         wlMivEY7zoYCYrHeHKNT2WGjnaZGQrZTn+XqyuAiUVwVftcf3nxrK35ODJAsPt4EVt
         ghYSRzxI4u0JPA9Wtg7OZm8vIC29CWBbtOTsJ7VgrrH7RNvztSgC5glND5g3WKAIhp
         qdEA5qElXA0G6SpWawsF4DJFzMnQ0w6n9ogESxi1ao/cpTGWLRMRlNqCXEKnj5+40B
         N1Q5ViWX08nT3naTSLiTWXRgxfJfSWUggZ6yIJIipsBOEtK01igUQt3uoZq22uadh5
         JfPrMkJVzqPVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 03/61] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Tue, 16 Mar 2021 20:54:37 -0400
Message-Id: <20210317005536.724046-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

[ Upstream commit bfaf91ca848e758ed7be99b61fd936d03819fa56 ]

Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
dma_alloc_coherent will return both the virtual address and physical
address. AFAIK, virt_to_phys could not convert virtual address to
physical address, for which memory is allocated by dma_alloc_coherent.

dwmac4_display_ring() function is broken for various descriptor, it only
support normal descriptor(struct dma_desc) now, this patch also extends to
support all descriptor types.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    | 50 +++++++++++++---
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  9 ++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |  9 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 57 ++++++++++++-------
 5 files changed, 94 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index c6540b003b43..ee87811b0ca5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -402,19 +402,53 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
 	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
 }
 
-static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
+static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
+				dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
-	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
-	for (i = 0; i < size; i++) {
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(p),
-			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
-			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
-		p++;
+	if (desc_size == sizeof(struct dma_desc)) {
+		struct dma_desc *p = (struct dma_desc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*p);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(p->des0), le32_to_cpu(p->des1),
+				le32_to_cpu(p->des2), le32_to_cpu(p->des3));
+			p++;
+		}
+	} else if (desc_size == sizeof(struct dma_extended_desc)) {
+		struct dma_extended_desc *extp = (struct dma_extended_desc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*extp);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(extp->basic.des0), le32_to_cpu(extp->basic.des1),
+				le32_to_cpu(extp->basic.des2), le32_to_cpu(extp->basic.des3),
+				le32_to_cpu(extp->des4), le32_to_cpu(extp->des5),
+				le32_to_cpu(extp->des6), le32_to_cpu(extp->des7));
+			extp++;
+		}
+	} else if (desc_size == sizeof(struct dma_edesc)) {
+		struct dma_edesc *ep = (struct dma_edesc *)head;
+
+		for (i = 0; i < size; i++) {
+			dma_addr = dma_rx_phy + i * sizeof(*ep);
+			pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x\n",
+				i, &dma_addr,
+				le32_to_cpu(ep->des4), le32_to_cpu(ep->des5),
+				le32_to_cpu(ep->des6), le32_to_cpu(ep->des7),
+				le32_to_cpu(ep->basic.des0), le32_to_cpu(ep->basic.des1),
+				le32_to_cpu(ep->basic.des2), le32_to_cpu(ep->basic.des3));
+			ep++;
+		}
+	} else {
+		pr_err("unsupported descriptor!");
 	}
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
index d02cec296f51..6650edfab5bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/enh_desc.c
@@ -417,19 +417,22 @@ static int enh_desc_get_rx_timestamp_status(void *desc, void *next_desc,
 	}
 }
 
-static void enh_desc_display_ring(void *head, unsigned int size, bool rx)
+static void enh_desc_display_ring(void *head, unsigned int size, bool rx,
+				  dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("Extended %s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
 		u64 x;
+		dma_addr = dma_rx_phy + i * sizeof(*ep);
 
 		x = *(u64 *)ep;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-			i, (unsigned int)virt_to_phys(ep),
+		pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+			i, &dma_addr,
 			(unsigned int)x, (unsigned int)(x >> 32),
 			ep->basic.des2, ep->basic.des3);
 		ep++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index b40b2e0667bb..7417db31402f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -78,7 +78,8 @@ struct stmmac_desc_ops {
 	/* get rx timestamp status */
 	int (*get_rx_timestamp_status)(void *desc, void *next_desc, u32 ats);
 	/* Display ring */
-	void (*display_ring)(void *head, unsigned int size, bool rx);
+	void (*display_ring)(void *head, unsigned int size, bool rx,
+			     dma_addr_t dma_rx_phy, unsigned int desc_size);
 	/* set MSS via context descriptor */
 	void (*set_mss)(struct dma_desc *p, unsigned int mss);
 	/* get descriptor skbuff address */
diff --git a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
index f083360e4ba6..98ef43f35802 100644
--- a/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/norm_desc.c
@@ -269,19 +269,22 @@ static int ndesc_get_rx_timestamp_status(void *desc, void *next_desc, u32 ats)
 		return 1;
 }
 
-static void ndesc_display_ring(void *head, unsigned int size, bool rx)
+static void ndesc_display_ring(void *head, unsigned int size, bool rx,
+			       dma_addr_t dma_rx_phy, unsigned int desc_size)
 {
 	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 	int i;
 
 	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
 
 	for (i = 0; i < size; i++) {
 		u64 x;
+		dma_addr = dma_rx_phy + i * sizeof(*p);
 
 		x = *(u64 *)p;
-		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x",
-			i, (unsigned int)virt_to_phys(p),
+		pr_info("%03d [%pad]: 0x%x 0x%x 0x%x 0x%x",
+			i, &dma_addr,
 			(unsigned int)x, (unsigned int)(x >> 32),
 			p->des2, p->des3);
 		p++;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..9d87c252560d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1133,6 +1133,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 {
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	unsigned int desc_size;
 	void *head_rx;
 	u32 queue;
 
@@ -1142,19 +1143,24 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tRX Queue %u rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_rx = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			head_rx = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
 		/* Display RX ring */
-		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, head_rx, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 }
 
 static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
+	unsigned int desc_size;
 	void *head_tx;
 	u32 queue;
 
@@ -1164,14 +1170,19 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
 		pr_info("\tTX Queue %d rings\n", queue);
 
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			head_tx = (void *)tx_q->dma_etx;
-		else if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			desc_size = sizeof(struct dma_extended_desc);
+		} else if (tx_q->tbs & STMMAC_TBS_AVAIL) {
 			head_tx = (void *)tx_q->dma_entx;
-		else
+			desc_size = sizeof(struct dma_edesc);
+		} else {
 			head_tx = (void *)tx_q->dma_tx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false);
+		stmmac_display_ring(priv, head_tx, priv->dma_tx_size, false,
+				    tx_q->dma_tx_phy, desc_size);
 	}
 }
 
@@ -3736,18 +3747,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 	unsigned int count = 0, error = 0, len = 0;
 	int status = 0, coe = priv->hw->rx_csum;
 	unsigned int next_entry = rx_q->cur_rx;
+	unsigned int desc_size;
 	struct sk_buff *skb = NULL;
 
 	if (netif_msg_rx_status(priv)) {
 		void *rx_head;
 
 		netdev_dbg(priv->dev, "%s: descriptor ring:\n", __func__);
-		if (priv->extend_desc)
+		if (priv->extend_desc) {
 			rx_head = (void *)rx_q->dma_erx;
-		else
+			desc_size = sizeof(struct dma_extended_desc);
+		} else {
 			rx_head = (void *)rx_q->dma_rx;
+			desc_size = sizeof(struct dma_desc);
+		}
 
-		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true);
+		stmmac_display_ring(priv, rx_head, priv->dma_rx_size, true,
+				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
 		unsigned int buf1_len = 0, buf2_len = 0;
@@ -4315,24 +4331,27 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 static struct dentry *stmmac_fs_dir;
 
 static void sysfs_display_ring(void *head, int size, int extend_desc,
-			       struct seq_file *seq)
+			       struct seq_file *seq, dma_addr_t dma_phy_addr)
 {
 	int i;
 	struct dma_extended_desc *ep = (struct dma_extended_desc *)head;
 	struct dma_desc *p = (struct dma_desc *)head;
+	dma_addr_t dma_addr;
 
 	for (i = 0; i < size; i++) {
 		if (extend_desc) {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(ep),
+			dma_addr = dma_phy_addr + i * sizeof(*ep);
+			seq_printf(seq, "%d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, &dma_addr,
 				   le32_to_cpu(ep->basic.des0),
 				   le32_to_cpu(ep->basic.des1),
 				   le32_to_cpu(ep->basic.des2),
 				   le32_to_cpu(ep->basic.des3));
 			ep++;
 		} else {
-			seq_printf(seq, "%d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
-				   i, (unsigned int)virt_to_phys(p),
+			dma_addr = dma_phy_addr + i * sizeof(*p);
+			seq_printf(seq, "%d [%pad]: 0x%x 0x%x 0x%x 0x%x\n",
+				   i, &dma_addr,
 				   le32_to_cpu(p->des0), le32_to_cpu(p->des1),
 				   le32_to_cpu(p->des2), le32_to_cpu(p->des3));
 			p++;
@@ -4360,11 +4379,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_erx,
-					   priv->dma_rx_size, 1, seq);
+					   priv->dma_rx_size, 1, seq, rx_q->dma_rx_phy);
 		} else {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)rx_q->dma_rx,
-					   priv->dma_rx_size, 0, seq);
+					   priv->dma_rx_size, 0, seq, rx_q->dma_rx_phy);
 		}
 	}
 
@@ -4376,11 +4395,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
 		if (priv->extend_desc) {
 			seq_printf(seq, "Extended descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_etx,
-					   priv->dma_tx_size, 1, seq);
+					   priv->dma_tx_size, 1, seq, tx_q->dma_tx_phy);
 		} else if (!(tx_q->tbs & STMMAC_TBS_AVAIL)) {
 			seq_printf(seq, "Descriptor ring:\n");
 			sysfs_display_ring((void *)tx_q->dma_tx,
-					   priv->dma_tx_size, 0, seq);
+					   priv->dma_tx_size, 0, seq, tx_q->dma_tx_phy);
 		}
 	}
 
-- 
2.30.1

