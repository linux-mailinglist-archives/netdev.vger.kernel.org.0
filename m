Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0836A33E3A5
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhCQA5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:57:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhCQA46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D796964F9F;
        Wed, 17 Mar 2021 00:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942617;
        bh=UsgIXwcuigBG4LZMF4muFLysDeQVL5fAny4wM2Rmlxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKrYNuk5CM0NUDsLZoUOmGXzoA90JNKjprCQTn6nxoBzYZLmufJy+2oQKp6+M2vTk
         KvEo46B9CCrt6V+g2XRMgnNLkrZFi7NXj8h98TC5+k0qyy9EJnlnBVEjmjlOmCr1Ih
         ucktWqdrAXHdIx69p/ttHylISMFmFc6gdNuIcFvJJo27iecYps3yoguIrnVowU7DGF
         bSYqvudM8xCsT58xKM5WzyeVPockx7HEYvh1IvBIcXxpgX0tya4Vjg2PLskaVBSZoW
         rFrEjSEzF9ikfN0x7ijH6HGQaws7aMwFjjeA9iG64OK6IJCyCB5BoO/0EaSH/xo0En
         6DzAyL28RgtCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 02/54] net: stmmac: fix dma physical address of descriptor when display ring
Date:   Tue, 16 Mar 2021 20:56:01 -0400
Message-Id: <20210317005654.724862-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index e2dca9b6e992..0b82088bc592 100644
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
index b3d6d8e3f4de..bc98d82f8ed3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1109,6 +1109,7 @@ static int stmmac_phy_setup(struct stmmac_priv *priv)
 static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 {
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
+	unsigned int desc_size;
 	void *head_rx;
 	u32 queue;
 
@@ -1118,19 +1119,24 @@ static void stmmac_display_rx_rings(struct stmmac_priv *priv)
 
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
 
@@ -1140,14 +1146,19 @@ static void stmmac_display_tx_rings(struct stmmac_priv *priv)
 
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
 
@@ -3706,18 +3717,23 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
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
@@ -4285,24 +4301,27 @@ static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
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
@@ -4330,11 +4349,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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
 
@@ -4346,11 +4365,11 @@ static int stmmac_rings_status_show(struct seq_file *seq, void *v)
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

