Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE68105E0C
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 02:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVBIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 20:08:43 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:48195 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVBIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 20:08:42 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAM18Z4N011881;
        Thu, 21 Nov 2019 17:08:36 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v2 1/3] cxgb4/chcr: update SGL DMA unmap for USO
Date:   Fri, 22 Nov 2019 06:30:01 +0530
Message-Id: <6cf3a3928ff2ee84cca34bfcb61d3f7fcb4c4cac.1574383652.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The FW_ETH_TX_EO_WR used for sending UDP Segmentation Offload (USO)
requests expects the headers to be part of the descriptor and the
payload to be part of the SGL containing the DMA mapped addresses.
Hence, the DMA address in the first entry of the SGL can start after
the packet headers. Currently, unmap_sgl() tries to unmap from this
wrong offset, instead of the originally mapped DMA address.

So, use existing unmap_skb() instead, which takes originally saved DMA
addresses as input. Update all necessary Tx paths to save the original
DMA addresses, so that unmap_skb() can unmap them properly.

v2:
- No change.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/crypto/chelsio/chcr_ipsec.c           |  27 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  19 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 119 +++++-------------
 4 files changed, 52 insertions(+), 115 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_ipsec.c b/drivers/crypto/chelsio/chcr_ipsec.c
index 24355680f30a..9da0f93a330b 100644
--- a/drivers/crypto/chelsio/chcr_ipsec.c
+++ b/drivers/crypto/chelsio/chcr_ipsec.c
@@ -673,16 +673,16 @@ static inline void txq_advance(struct sge_txq *q, unsigned int n)
 int chcr_ipsec_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct xfrm_state *x = xfrm_input_state(skb);
+	unsigned int last_desc, ndesc, flits = 0;
 	struct ipsec_sa_entry *sa_entry;
 	u64 *pos, *end, *before, *sgl;
+	struct tx_sw_desc *sgl_sdesc;
 	int qidx, left, credits;
-	unsigned int flits = 0, ndesc;
-	struct adapter *adap;
+	bool immediate = false;
 	struct sge_eth_txq *q;
+	struct adapter *adap;
 	struct port_info *pi;
-	dma_addr_t addr[MAX_SKB_FRAGS + 1];
 	struct sec_path *sp;
-	bool immediate = false;
 
 	if (!x->xso.offload_handle)
 		return NETDEV_TX_BUSY;
@@ -715,8 +715,14 @@ out_free:       dev_kfree_skb_any(skb);
 		return NETDEV_TX_BUSY;
 	}
 
+	last_desc = q->q.pidx + ndesc - 1;
+	if (last_desc >= q->q.size)
+		last_desc -= q->q.size;
+	sgl_sdesc = &q->q.sdesc[last_desc];
+
 	if (!immediate &&
-	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, addr) < 0)) {
+	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
+		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
 		q->mapping_err++;
 		goto out_free;
 	}
@@ -742,17 +748,10 @@ out_free:       dev_kfree_skb_any(skb);
 		cxgb4_inline_tx_skb(skb, &q->q, sgl);
 		dev_consume_skb_any(skb);
 	} else {
-		int last_desc;
-
 		cxgb4_write_sgl(skb, &q->q, (void *)sgl, end,
-				0, addr);
+				0, sgl_sdesc->addr);
 		skb_orphan(skb);
-
-		last_desc = q->q.pidx + ndesc - 1;
-		if (last_desc >= q->q.size)
-			last_desc -= q->q.size;
-		q->q.sdesc[last_desc].skb = skb;
-		q->q.sdesc[last_desc].sgl = (struct ulptx_sgl *)sgl;
+		sgl_sdesc->skb = skb;
 	}
 	txq_advance(&q->q, ndesc);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 3121ed83d8e2..61a2cf62f694 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -735,7 +735,12 @@ struct tx_desc {
 	__be64 flit[8];
 };
 
-struct tx_sw_desc;
+struct ulptx_sgl;
+
+struct tx_sw_desc {
+	struct sk_buff *skb; /* SKB to free after getting completion */
+	dma_addr_t addr[MAX_SKB_FRAGS + 1]; /* DMA mapped addresses */
+};
 
 struct sge_txq {
 	unsigned int  in_use;       /* # of in-use Tx descriptors */
@@ -814,15 +819,10 @@ enum sge_eosw_state {
 	CXGB4_EO_STATE_FLOWC_CLOSE_REPLY, /* Waiting for FLOWC close reply */
 };
 
-struct sge_eosw_desc {
-	struct sk_buff *skb; /* SKB to free after getting completion */
-	dma_addr_t addr[MAX_SKB_FRAGS + 1]; /* DMA mapped addresses */
-};
-
 struct sge_eosw_txq {
 	spinlock_t lock; /* Per queue lock to synchronize completions */
 	enum sge_eosw_state state; /* Current ETHOFLD State */
-	struct sge_eosw_desc *desc; /* Descriptor ring to hold packets */
+	struct tx_sw_desc *desc; /* Descriptor ring to hold packets */
 	u32 ndesc; /* Number of descriptors */
 	u32 pidx; /* Current Producer Index */
 	u32 last_pidx; /* Last successfully transmitted Producer Index */
@@ -1151,11 +1151,6 @@ enum {
 	SCHED_CLASS_RATEMODE_ABS = 1,   /* Kb/s */
 };
 
-struct tx_sw_desc {                /* SW state per Tx descriptor */
-	struct sk_buff *skb;
-	struct ulptx_sgl *sgl;
-};
-
 /* Support for "sched_queue" command to allow one or more NIC TX Queues
  * to be bound to a TX Scheduling Class.
  */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
index db55673b77bd..477973d2e341 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
@@ -70,7 +70,7 @@ static int cxgb4_init_eosw_txq(struct net_device *dev,
 			       u32 eotid, u32 hwqid)
 {
 	struct adapter *adap = netdev2adap(dev);
-	struct sge_eosw_desc *ring;
+	struct tx_sw_desc *ring;
 
 	memset(eosw_txq, 0, sizeof(*eosw_txq));
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index a0400b9a11e9..5ad54493f825 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -300,65 +300,6 @@ static void deferred_unmap_destructor(struct sk_buff *skb)
 }
 #endif
 
-static void unmap_sgl(struct device *dev, const struct sk_buff *skb,
-		      const struct ulptx_sgl *sgl, const struct sge_txq *q)
-{
-	const struct ulptx_sge_pair *p;
-	unsigned int nfrags = skb_shinfo(skb)->nr_frags;
-
-	if (likely(skb_headlen(skb)))
-		dma_unmap_single(dev, be64_to_cpu(sgl->addr0), ntohl(sgl->len0),
-				 DMA_TO_DEVICE);
-	else {
-		dma_unmap_page(dev, be64_to_cpu(sgl->addr0), ntohl(sgl->len0),
-			       DMA_TO_DEVICE);
-		nfrags--;
-	}
-
-	/*
-	 * the complexity below is because of the possibility of a wrap-around
-	 * in the middle of an SGL
-	 */
-	for (p = sgl->sge; nfrags >= 2; nfrags -= 2) {
-		if (likely((u8 *)(p + 1) <= (u8 *)q->stat)) {
-unmap:			dma_unmap_page(dev, be64_to_cpu(p->addr[0]),
-				       ntohl(p->len[0]), DMA_TO_DEVICE);
-			dma_unmap_page(dev, be64_to_cpu(p->addr[1]),
-				       ntohl(p->len[1]), DMA_TO_DEVICE);
-			p++;
-		} else if ((u8 *)p == (u8 *)q->stat) {
-			p = (const struct ulptx_sge_pair *)q->desc;
-			goto unmap;
-		} else if ((u8 *)p + 8 == (u8 *)q->stat) {
-			const __be64 *addr = (const __be64 *)q->desc;
-
-			dma_unmap_page(dev, be64_to_cpu(addr[0]),
-				       ntohl(p->len[0]), DMA_TO_DEVICE);
-			dma_unmap_page(dev, be64_to_cpu(addr[1]),
-				       ntohl(p->len[1]), DMA_TO_DEVICE);
-			p = (const struct ulptx_sge_pair *)&addr[2];
-		} else {
-			const __be64 *addr = (const __be64 *)q->desc;
-
-			dma_unmap_page(dev, be64_to_cpu(p->addr[0]),
-				       ntohl(p->len[0]), DMA_TO_DEVICE);
-			dma_unmap_page(dev, be64_to_cpu(addr[0]),
-				       ntohl(p->len[1]), DMA_TO_DEVICE);
-			p = (const struct ulptx_sge_pair *)&addr[1];
-		}
-	}
-	if (nfrags) {
-		__be64 addr;
-
-		if ((u8 *)p == (u8 *)q->stat)
-			p = (const struct ulptx_sge_pair *)q->desc;
-		addr = (u8 *)p + 16 <= (u8 *)q->stat ? p->addr[0] :
-						       *(const __be64 *)q->desc;
-		dma_unmap_page(dev, be64_to_cpu(addr), ntohl(p->len[0]),
-			       DMA_TO_DEVICE);
-	}
-}
-
 /**
  *	free_tx_desc - reclaims Tx descriptors and their buffers
  *	@adapter: the adapter
@@ -372,15 +313,16 @@ unmap:			dma_unmap_page(dev, be64_to_cpu(p->addr[0]),
 void free_tx_desc(struct adapter *adap, struct sge_txq *q,
 		  unsigned int n, bool unmap)
 {
-	struct tx_sw_desc *d;
 	unsigned int cidx = q->cidx;
-	struct device *dev = adap->pdev_dev;
+	struct tx_sw_desc *d;
 
 	d = &q->sdesc[cidx];
 	while (n--) {
 		if (d->skb) {                       /* an SGL is present */
-			if (unmap)
-				unmap_sgl(dev, d->skb, d->sgl, q);
+			if (unmap && d->addr[0]) {
+				unmap_skb(adap->pdev_dev, d->skb, d->addr);
+				memset(d->addr, 0, sizeof(d->addr));
+			}
 			dev_consume_skb_any(d->skb);
 			d->skb = NULL;
 		}
@@ -1414,13 +1356,13 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	enum cpl_tx_tnl_lso_type tnl_type = TX_TNL_TYPE_OPAQUE;
 	bool ptp_enabled = is_ptp_enabled(skb, dev);
-	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+	unsigned int last_desc, flits, ndesc;
 	const struct skb_shared_info *ssi;
+	struct tx_sw_desc *sgl_sdesc;
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
 	int len, qidx, credits, ret;
 	const struct port_info *pi;
-	unsigned int flits, ndesc;
 	bool immediate = false;
 	u32 wr_mid, ctrl0, op;
 	u64 cntrl, *end, *sgl;
@@ -1489,8 +1431,14 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (skb->encapsulation && chip_ver > CHELSIO_T5)
 		tnl_type = cxgb_encap_offload_supported(skb);
 
+	last_desc = q->q.pidx + ndesc - 1;
+	if (last_desc >= q->q.size)
+		last_desc -= q->q.size;
+	sgl_sdesc = &q->q.sdesc[last_desc];
+
 	if (!immediate &&
-	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, addr) < 0)) {
+	    unlikely(cxgb4_map_skb(adap->pdev_dev, skb, sgl_sdesc->addr) < 0)) {
+		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
 		q->mapping_err++;
 		if (ptp_enabled)
 			spin_unlock(&adap->ptp_lock);
@@ -1618,16 +1566,10 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		cxgb4_inline_tx_skb(skb, &q->q, sgl);
 		dev_consume_skb_any(skb);
 	} else {
-		int last_desc;
-
-		cxgb4_write_sgl(skb, &q->q, (void *)sgl, end, 0, addr);
+		cxgb4_write_sgl(skb, &q->q, (void *)sgl, end, 0,
+				sgl_sdesc->addr);
 		skb_orphan(skb);
-
-		last_desc = q->q.pidx + ndesc - 1;
-		if (last_desc >= q->q.size)
-			last_desc -= q->q.size;
-		q->q.sdesc[last_desc].skb = skb;
-		q->q.sdesc[last_desc].sgl = (struct ulptx_sgl *)sgl;
+		sgl_sdesc->skb = skb;
 	}
 
 	txq_advance(&q->q, ndesc);
@@ -1725,12 +1667,12 @@ static inline unsigned int t4vf_calc_tx_flits(const struct sk_buff *skb)
 static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
-	dma_addr_t addr[MAX_SKB_FRAGS + 1];
+	unsigned int last_desc, flits, ndesc;
 	const struct skb_shared_info *ssi;
 	struct fw_eth_tx_pkt_vm_wr *wr;
+	struct tx_sw_desc *sgl_sdesc;
 	struct cpl_tx_pkt_core *cpl;
 	const struct port_info *pi;
-	unsigned int flits, ndesc;
 	struct sge_eth_txq *txq;
 	struct adapter *adapter;
 	int qidx, credits, ret;
@@ -1782,12 +1724,19 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	last_desc = txq->q.pidx + ndesc - 1;
+	if (last_desc >= txq->q.size)
+		last_desc -= txq->q.size;
+	sgl_sdesc = &txq->q.sdesc[last_desc];
+
 	if (!t4vf_is_eth_imm(skb) &&
-	    unlikely(cxgb4_map_skb(adapter->pdev_dev, skb, addr) < 0)) {
+	    unlikely(cxgb4_map_skb(adapter->pdev_dev, skb,
+				   sgl_sdesc->addr) < 0)) {
 		/* We need to map the skb into PCI DMA space (because it can't
 		 * be in-lined directly into the Work Request) and the mapping
 		 * operation failed.  Record the error and drop the packet.
 		 */
+		memset(sgl_sdesc->addr, 0, sizeof(sgl_sdesc->addr));
 		txq->mapping_err++;
 		goto out_free;
 	}
@@ -1962,7 +1911,6 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 		 */
 		struct ulptx_sgl *sgl = (struct ulptx_sgl *)(cpl + 1);
 		struct sge_txq *tq = &txq->q;
-		int last_desc;
 
 		/* If the Work Request header was an exact multiple of our TX
 		 * Descriptor length, then it's possible that the starting SGL
@@ -1976,14 +1924,9 @@ static netdev_tx_t cxgb4_vf_eth_xmit(struct sk_buff *skb,
 				       ((void *)end - (void *)tq->stat));
 		}
 
-		cxgb4_write_sgl(skb, tq, sgl, end, 0, addr);
+		cxgb4_write_sgl(skb, tq, sgl, end, 0, sgl_sdesc->addr);
 		skb_orphan(skb);
-
-		last_desc = tq->pidx + ndesc - 1;
-		if (last_desc >= tq->size)
-			last_desc -= tq->size;
-		tq->sdesc[last_desc].skb = skb;
-		tq->sdesc[last_desc].sgl = sgl;
+		sgl_sdesc->skb = skb;
 	}
 
 	/* Advance our internal TX Queue state, tell the hardware about
@@ -2035,7 +1978,7 @@ static inline void eosw_txq_advance_index(u32 *idx, u32 n, u32 max)
 void cxgb4_eosw_txq_free_desc(struct adapter *adap,
 			      struct sge_eosw_txq *eosw_txq, u32 ndesc)
 {
-	struct sge_eosw_desc *d;
+	struct tx_sw_desc *d;
 
 	d = &eosw_txq->desc[eosw_txq->last_cidx];
 	while (ndesc--) {
@@ -2167,7 +2110,7 @@ static void ethofld_hard_xmit(struct net_device *dev,
 	struct cpl_tx_pkt_core *cpl;
 	struct fw_eth_tx_eo_wr *wr;
 	bool skip_eotx_wr = false;
-	struct sge_eosw_desc *d;
+	struct tx_sw_desc *d;
 	struct sk_buff *skb;
 	u8 flits, ndesc;
 	int left;
-- 
2.24.0

