Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B016272DBA
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfGXLgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:36:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfGXLgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TUAIyN+terahhzrvCO5pS7HYDyySl5Lg5EMJzSnqo/Q=; b=W6iYOzGFvjLAIAqxBGW42xp4v
        uvC/iZEajp3i5RM+DhDr2sOfEbvu4kPisd63QTvPoKpNXexId6k9HvrHauyq86c5NsR6Jefkga4hZ
        68l0QMmcpLYcA291QwW7kZMTI8gngJDUVA64m5j9sruU4ia8uJlgbr3lAbCV1og1pAmRTg9fkIPNt
        iePMKiLfj1I8rKRdeu6vQ6WT7oDnQ3K+8s7MXdoVJ0aIA2Zr0YtICw8sUYtGkxZoW6XG7f8s6PUI2
        Wn+LWcEU+NcRM5TbnhnqLJGJ6e22XD592CypDLcD9t8TXFxqnMHoAixyj0JP3HlanmG3D4rfMF9J+
        a8jrvXq5Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hqFZE-00037o-NB; Wed, 24 Jul 2019 11:36:20 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH] Build fixes for skb_frag_size conversion
Date:   Wed, 24 Jul 2019 04:36:15 -0700
Message-Id: <20190724113615.11961-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

I missed a few places.  One is in some ifdeffed code which will probably
never be re-enabled; the others are in drivers which can't currently be
compiled on x86.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/atm/he.c                               | 7 +++----
 drivers/net/ethernet/aeroflex/greth.c          | 2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c    | 3 ++-
 drivers/staging/octeon/ethernet-tx.c           | 2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c    | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 211607986134..70b00ae4ec38 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -2580,10 +2580,9 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			slot = 0;
 		}
 
-		tpd->iovec[slot].addr = dma_map_single(&he_dev->pci_dev->dev,
-			(void *) page_address(frag->page) + frag->page_offset,
-				frag->size, DMA_TO_DEVICE);
-		tpd->iovec[slot].len = frag->size;
+		tpd->iovec[slot].addr = skb_frag_dma_map(&he_dev->pci_dev->dev,
+				frag, 0, skb_frag_size(frag), DMA_TO_DEVICE);
+		tpd->iovec[slot].len = skb_frag_size(frag);
 		++slot;
 
 	}
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 010a2f48aea5..2a9f8643629c 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -110,7 +110,7 @@ static void greth_print_tx_packet(struct sk_buff *skb)
 
 		print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
 			       skb_frag_address(&skb_shinfo(skb)->frags[i]),
-			       skb_shinfo(skb)->frags[i].size, true);
+			       skb_frag_size(&skb_shinfo(skb)->frags[i]), true);
 	}
 }
 
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f38c3fa7d705..9c4d1afa34e5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1958,7 +1958,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	/* populate the rest of SGT entries */
 	for (i = 0; i < nr_frags; i++) {
 		frag = &skb_shinfo(skb)->frags[i];
-		frag_len = frag->size;
+		frag_len = skb_frag_size(frag);
 		WARN_ON(!skb_frag_page(frag));
 		addr = skb_frag_dma_map(dev, frag, 0,
 					frag_len, dma_dir);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 00991df44ed6..e529d86468b8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -787,7 +787,8 @@ static inline int mtk_cal_txd_req(struct sk_buff *skb)
 	if (skb_is_gso(skb)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			frag = &skb_shinfo(skb)->frags[i];
-			nfrags += DIV_ROUND_UP(frag->size, MTK_TX_DMA_BUF_LEN);
+			nfrags += DIV_ROUND_UP(skb_frag_size(frag),
+						MTK_TX_DMA_BUF_LEN);
 		}
 	} else {
 		nfrags += skb_shinfo(skb)->nr_frags;
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index cc12c78f73f1..46a6fcf1414d 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -284,7 +284,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 
 			hw_buffer.s.addr =
 				XKPHYS_TO_PHYS((u64)skb_frag_address(fs));
-			hw_buffer.s.size = fs->size;
+			hw_buffer.s.size = skb_drag_size(fs);
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
 		hw_buffer.s.addr = XKPHYS_TO_PHYS((u64)CVM_OCT_SKB_CB(skb));
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 93212b9fd310..c25315431ad0 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1448,7 +1448,7 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 		hpdu_cb->frags++;
 		hpdu_cb->hfrag_idx = hfrag_idx;
 
-		len = skb_frag_size(&hssi->frags[hfrag_idx]);;
+		len = skb_frag_size(&hssi->frags[hfrag_idx]);
 		hskb->len += len;
 		hskb->data_len += len;
 		hskb->truesize += len;
-- 
2.20.1

