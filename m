Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F9D14A479
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbgA0NGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:08 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39086 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0NGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:08 -0500
Received: by mail-pf1-f193.google.com with SMTP id q10so4893130pfs.6
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1GMQ98zvkzEm3Twz1RDIvGgMxGi94X9osHF9/1rSS5w=;
        b=XHx3/eIc0rfyZrkPlG5SuQCUPIUQCKF6Y8KGlT90X4j13aYsNs695cVqlxkdGmCRVH
         nrfCqktIikLa2cxNYo44IAU4mtRKEhi/IyaW3q6aoYdDtRKG6/YcSM52T1zsJNaarzEJ
         ORnJnlU/r7hcRBhq00DDBSsFye4mHJh9VE3aI57uBLdc6o5/swbIGhdckC9OTSWXFAdi
         /5cX5+gC0NzlTn/G2vzXDhimDKLgJ4ACfYPmrf0T4d+nx1nQOD6THNXeLGouxKip0Lhe
         fReDpTf4EjCIBsGw2NmQvsm7Hv3MO1sP5X4+m3IiZEgqA82r6tXWLQRiPtLxfa3xHlfD
         vf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1GMQ98zvkzEm3Twz1RDIvGgMxGi94X9osHF9/1rSS5w=;
        b=bLggvsF0lTX/Gsrt7gT7hOxYYSCYukNxRhVFGNAjh8bEYqzidQKKmlzyQknEz4+WMJ
         mfphoGdqPauXlKZvEmQvyXc+/KK8g+luGjNzoV+Gf802nsOI0VY3inlOIde/0S6kacVW
         NMHuz9wb7x0etVofyygZu+vlkqWGHXBarHXfWxBDmdcTFu2p3JFoboB3RCd0zCW65j8h
         yjrkgucC9AziGi5P8SjrYQirfNH3pgMYy2MPez7woQzkhAZnUPyeO4TpfZlmp0p7pL7k
         1zed4Q0ndeegDkcpxyEM2oJRoqsNBTf74iaZU/672bAIEfpv0021mR6DNK16c6gztELW
         uoxw==
X-Gm-Message-State: APjAAAVIR3Z6n1HAbHcQlkQ4eA+ERbvryxc7iXeF91H1y1gzsZFgYFEk
        NJgDu7J3rFxBLSAuhvH4MVw6uozB53E=
X-Google-Smtp-Source: APXvYqyQUvdXgYd+BP3n4loklzOOWbJEQZFK6MU9VTm6p6eRs37stm6YC1xv714yOXe6JFrEMIvyyw==
X-Received: by 2002:a62:6342:: with SMTP id x63mr16081544pfb.103.1580130366862;
        Mon, 27 Jan 2020 05:06:06 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:06 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [PATCH v6 07/17] octeontx2-pf: Add packet transmission support
Date:   Mon, 27 Jan 2020 18:35:21 +0530
Message-Id: <1580130331-8964-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch adds the packet transmission support.
For a given skb prepares send queue descriptors (SQEs) and pushes them
to HW. Here driver doesn't maintain it's own SQ rings, SQEs are pushed
to HW using a silicon specific operations called LMTST. From the
instuction HW derives the transmit queue number and queues the SQE to
that queue. These LMTST instructions are designed to avoid queue
maintenance in SW and lockless behavior ie when multiple cores are trying
to add SQEs to same queue then HW will takecare of serialization, no need
for SW to hold locks.

Also supports scatter/gather.

Co-developed-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   7 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  38 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   | 109 ++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 291 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |  14 +
 6 files changed, 470 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 6b54831..e9bd2d6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -287,9 +287,15 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 		return err;
 
 	sq->sqe_base = sq->sqe->base;
+	sq->sg = kcalloc(qset->sqe_cnt, sizeof(struct sg_list), GFP_KERNEL);
+	if (!sq->sg)
+		return -ENOMEM;
 
+	sq->head = 0;
 	sq->sqe_per_sqb = (pfvf->hw.sqb_size / sq->sqe_size) - 1;
 	sq->num_sqbs = (qset->sqe_cnt + sq->sqe_per_sqb) / sq->sqe_per_sqb;
+	/* Set SQE threshold to 10% of total SQEs */
+	sq->sqe_thresh = ((sq->num_sqbs * sq->sqe_per_sqb) * 10) / 100;
 	sq->aura_id = sqb_aura;
 	sq->aura_fc_addr = pool->fc_addr->base;
 	sq->lmt_addr = (__force u64 *)(pfvf->reg_base + LMT_LF_LMTLINEX(qidx));
@@ -338,6 +344,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 		cq->cqe_cnt = qset->rqe_cnt;
 	} else {
 		cq->cq_type = CQ_TX;
+		cq->cint_idx = qidx - pfvf->hw.rx_queues;
 		cq->cqe_cnt = qset->sqe_cnt;
 	}
 	cq->cqe_size = pfvf->qset.xqe_size;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 622c4f8..1194854 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -300,9 +300,21 @@ static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
 	return result;
 }
 
+static inline u64 otx2_lmt_flush(uint64_t addr)
+{
+	u64 result = 0;
+
+	__asm__ volatile(".cpu  generic+lse\n"
+			 "ldeor xzr,%x[rf],[%[rs]]"
+			 : [rf]"=r"(result)
+			 : [rs]"r"(addr));
+	return result;
+}
+
 #else
 #define otx2_write128(lo, hi, addr)
 #define otx2_atomic64_add(incr, ptr)		({ *ptr += incr; })
+#define otx2_lmt_flush(addr)			({ 0; })
 #endif
 
 /* Alloc pointer from pool/aura */
@@ -475,6 +487,7 @@ dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			   gfp_t gfp);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
+void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 37362ef..a18bf5f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -445,6 +445,7 @@ static void otx2_free_sq_res(struct otx2_nic *pf)
 	for (qidx = 0; qidx < pf->hw.tx_queues; qidx++) {
 		sq = &qset->sq[qidx];
 		qmem_free(pf->dev, sq->sqe);
+		kfree(sq->sg);
 		kfree(sq->sqb_ptrs);
 	}
 }
@@ -569,6 +570,8 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 		cq = &qset->cq[qidx];
 		if (cq->cq_type == CQ_RX)
 			otx2_cleanup_rx_cqes(pf, cq);
+		else
+			otx2_cleanup_tx_cqes(pf, cq);
 	}
 
 	otx2_free_sq_res(pf);
@@ -741,9 +744,41 @@ static int otx2_stop(struct net_device *netdev)
 	return 0;
 }
 
+static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
+{
+	struct otx2_nic *pf = netdev_priv(netdev);
+	int qidx = skb_get_queue_mapping(skb);
+	struct otx2_snd_queue *sq;
+	struct netdev_queue *txq;
+
+	/* Check for minimum packet length */
+	if (skb->len <= ETH_HLEN) {
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
+	sq = &pf->qset.sq[qidx];
+	txq = netdev_get_tx_queue(netdev, qidx);
+
+	if (!otx2_sq_append_skb(netdev, sq, skb, qidx)) {
+		netif_tx_stop_queue(txq);
+
+		/* Check again, incase SQBs got freed up */
+		smp_mb();
+		if (((sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb)
+							> sq->sqe_thresh)
+			netif_tx_wake_queue(txq);
+
+		return NETDEV_TX_BUSY;
+	}
+
+	return NETDEV_TX_OK;
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
+	.ndo_start_xmit		= otx2_xmit,
 };
 
 static int otx2_check_pf_usable(struct otx2_nic *nic)
@@ -910,7 +945,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
-	netdev->hw_features = NETIF_F_RXCSUM;
+	netdev->hw_features = (NETIF_F_RXCSUM | NETIF_F_IP_CSUM |
+			       NETIF_F_IPV6_CSUM | NETIF_F_SG);
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index dad73cb..04a9f12 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -28,6 +28,21 @@ enum nix_send_ldtype {
 	NIX_SEND_LDTYPE_LDWB = 0x2,
 };
 
+/* CSUM offload */
+enum nix_sendl3type {
+	NIX_SENDL3TYPE_NONE = 0x0,
+	NIX_SENDL3TYPE_IP4 = 0x2,
+	NIX_SENDL3TYPE_IP4_CKSUM = 0x3,
+	NIX_SENDL3TYPE_IP6 = 0x4,
+};
+
+enum nix_sendl4type {
+	NIX_SENDL4TYPE_NONE,
+	NIX_SENDL4TYPE_TCP_CKSUM,
+	NIX_SENDL4TYPE_SCTP_CKSUM,
+	NIX_SENDL4TYPE_UDP_CKSUM,
+};
+
 /* NIX wqe/cqe types */
 enum nix_xqe_type {
 	NIX_XQE_TYPE_INVALID   = 0x0,
@@ -51,6 +66,20 @@ enum nix_subdc {
 	NIX_SUBDC_SOD  = 0xf,
 };
 
+/* Algorithm for nix_sqe_mem_s header (value of the `alg` field) */
+enum nix_sendmemalg {
+	NIX_SENDMEMALG_E_SET       = 0x0,
+	NIX_SENDMEMALG_E_SETTSTMP  = 0x1,
+	NIX_SENDMEMALG_E_SETRSLT   = 0x2,
+	NIX_SENDMEMALG_E_ADD       = 0x8,
+	NIX_SENDMEMALG_E_SUB       = 0x9,
+	NIX_SENDMEMALG_E_ADDLEN    = 0xa,
+	NIX_SENDMEMALG_E_SUBLEN    = 0xb,
+	NIX_SENDMEMALG_E_ADDMBUF   = 0xc,
+	NIX_SENDMEMALG_E_SUBMBUF   = 0xd,
+	NIX_SENDMEMALG_E_ENUM_LAST = 0xe,
+};
+
 /* NIX CQE header structure */
 struct nix_cqe_hdr_s {
 	u64 flow_tag              : 32;
@@ -130,10 +159,90 @@ struct nix_rx_sg_s {
 	u64 seg3_addr;
 };
 
+struct nix_send_comp_s {
+	u64 status	: 8;
+	u64 sqe_id	: 16;
+	u64 rsvd_24_63	: 40;
+};
+
 struct nix_cqe_rx_s {
 	struct nix_cqe_hdr_s  hdr;
 	struct nix_rx_parse_s parse;
 	struct nix_rx_sg_s sg;
 };
 
+struct nix_cqe_tx_s {
+	struct nix_cqe_hdr_s  hdr;
+	struct nix_send_comp_s comp;
+};
+
+/* NIX SQE header structure */
+struct nix_sqe_hdr_s {
+	u64 total		: 18; /* W0 */
+	u64 reserved_18		: 1;
+	u64 df			: 1;
+	u64 aura		: 20;
+	u64 sizem1		: 3;
+	u64 pnc			: 1;
+	u64 sq			: 20;
+	u64 ol3ptr		: 8; /* W1 */
+	u64 ol4ptr		: 8;
+	u64 il3ptr		: 8;
+	u64 il4ptr		: 8;
+	u64 ol3type		: 4;
+	u64 ol4type		: 4;
+	u64 il3type		: 4;
+	u64 il4type		: 4;
+	u64 sqe_id		: 16;
+
+};
+
+/* NIX send extended header subdescriptor structure */
+struct nix_sqe_ext_s {
+	u64 lso_mps       : 14; /* W0 */
+	u64 lso           : 1;
+	u64 tstmp         : 1;
+	u64 lso_sb        : 8;
+	u64 lso_format    : 5;
+	u64 rsvd_31_29    : 3;
+	u64 shp_chg       : 9;
+	u64 shp_dis       : 1;
+	u64 shp_ra        : 2;
+	u64 markptr       : 8;
+	u64 markform      : 7;
+	u64 mark_en       : 1;
+	u64 subdc         : 4;
+	u64 vlan0_ins_ptr : 8; /* W1 */
+	u64 vlan0_ins_tci : 16;
+	u64 vlan1_ins_ptr : 8;
+	u64 vlan1_ins_tci : 16;
+	u64 vlan0_ins_ena : 1;
+	u64 vlan1_ins_ena : 1;
+	u64 rsvd_127_114  : 14;
+};
+
+struct nix_sqe_sg_s {
+	u64 seg1_size	: 16;
+	u64 seg2_size	: 16;
+	u64 seg3_size	: 16;
+	u64 segs	: 2;
+	u64 rsvd_54_50	: 5;
+	u64 i1		: 1;
+	u64 i2		: 1;
+	u64 i3		: 1;
+	u64 ld_type	: 2;
+	u64 subdc	: 4;
+};
+
+/* NIX send memory subdescriptor structure */
+struct nix_sqe_mem_s {
+	u64 offset        : 16; /* W0 */
+	u64 rsvd_52_16    : 37;
+	u64 wmem          : 1;
+	u64 dsz           : 2;
+	u64 alg           : 4;
+	u64 subdc         : 4;
+	u64 addr; /* W1 */
+};
+
 #endif /* OTX2_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 0c1519a..f19f5d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -32,6 +32,74 @@ static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
 	return cqe_hdr;
 }
 
+static unsigned int frag_num(unsigned int i)
+{
+#ifdef __BIG_ENDIAN
+	return (i & ~3) + 3 - (i & 3);
+#else
+	return i;
+#endif
+}
+
+static dma_addr_t otx2_dma_map_skb_frag(struct otx2_nic *pfvf,
+					struct sk_buff *skb, int seg, int *len)
+{
+	const skb_frag_t *frag;
+	struct page *page;
+	int offset;
+
+	/* First segment is always skb->data */
+	if (!seg) {
+		page = virt_to_page(skb->data);
+		offset = offset_in_page(skb->data);
+		*len = skb_headlen(skb);
+	} else {
+		frag = &skb_shinfo(skb)->frags[seg - 1];
+		page = skb_frag_page(frag);
+		offset = skb_frag_off(frag);
+		*len = skb_frag_size(frag);
+	}
+	return otx2_dma_map_page(pfvf, page, offset, *len, DMA_TO_DEVICE);
+}
+
+static void otx2_dma_unmap_skb_frags(struct otx2_nic *pfvf, struct sg_list *sg)
+{
+	int seg;
+
+	for (seg = 0; seg < sg->num_segs; seg++) {
+		otx2_dma_unmap_page(pfvf, sg->dma_addr[seg],
+				    sg->size[seg], DMA_TO_DEVICE);
+	}
+	sg->num_segs = 0;
+}
+
+static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
+				 struct otx2_cq_queue *cq,
+				 struct otx2_snd_queue *sq,
+				 struct nix_cqe_tx_s *cqe,
+				 int budget, int *tx_pkts, int *tx_bytes)
+{
+	struct nix_send_comp_s *snd_comp = &cqe->comp;
+	struct sk_buff *skb = NULL;
+	struct sg_list *sg;
+
+	if (unlikely(snd_comp->status))
+		net_err_ratelimited("%s: TX%d: Error in send CQ status:%x\n",
+				    pfvf->netdev->name, cq->cint_idx,
+				    snd_comp->status);
+
+	sg = &sq->sg[snd_comp->sqe_id];
+	skb = (struct sk_buff *)sg->skb;
+	if (unlikely(!skb))
+		return;
+
+	*tx_bytes += skb->len;
+	(*tx_pkts)++;
+	otx2_dma_unmap_skb_frags(pfvf, sg);
+	napi_consume_skb(skb, budget);
+	sg->skb = (u64)NULL;
+}
+
 static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
 			      u64 iova, int len)
 {
@@ -182,7 +250,39 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 				struct otx2_cq_queue *cq, int budget)
 {
-	 /* Nothing to do, for now */
+	int tx_pkts = 0, tx_bytes = 0;
+	struct nix_cqe_tx_s *cqe;
+	int processed_cqe = 0;
+
+	while (likely(processed_cqe < budget)) {
+		cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq);
+		if (unlikely(!cqe)) {
+			if (!processed_cqe)
+				return 0;
+			break;
+		}
+		otx2_snd_pkt_handler(pfvf, cq, &pfvf->qset.sq[cq->cint_idx],
+				     cqe, budget, &tx_pkts, &tx_bytes);
+
+		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
+		processed_cqe++;
+	}
+
+	/* Free CQEs to HW */
+	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
+		     ((u64)cq->cq_idx << 32) | processed_cqe);
+
+	if (likely(tx_pkts)) {
+		struct netdev_queue *txq;
+
+		txq = netdev_get_tx_queue(pfvf->netdev, cq->cint_idx);
+		netdev_tx_completed_queue(txq, tx_pkts, tx_bytes);
+		/* Check if queue was stopped earlier due to ring full */
+		smp_mb();
+		if (netif_tx_queue_stopped(txq) &&
+		    netif_carrier_ok(pfvf->netdev))
+			netif_tx_wake_queue(txq);
+	}
 	return 0;
 }
 
@@ -222,6 +322,169 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 	return workdone;
 }
 
+static void otx2_sqe_flush(struct otx2_snd_queue *sq, int size)
+{
+	u64 status;
+
+	/* Packet data stores should finish before SQE is flushed to HW */
+	dma_wmb();
+
+	do {
+		memcpy(sq->lmt_addr, sq->sqe_base, size);
+		status = otx2_lmt_flush(sq->io_addr);
+	} while (status == 0);
+
+	sq->head++;
+	sq->head &= (sq->sqe_cnt - 1);
+}
+
+#define MAX_SEGS_PER_SG	3
+/* Add SQE scatter/gather subdescriptor structure */
+static bool otx2_sqe_add_sg(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
+			    struct sk_buff *skb, int num_segs, int *offset)
+{
+	struct nix_sqe_sg_s *sg = NULL;
+	u64 dma_addr, *iova = NULL;
+	u16 *sg_lens = NULL;
+	int seg, len;
+
+	sq->sg[sq->head].num_segs = 0;
+
+	for (seg = 0; seg < num_segs; seg++) {
+		if ((seg % MAX_SEGS_PER_SG) == 0) {
+			sg = (struct nix_sqe_sg_s *)(sq->sqe_base + *offset);
+			sg->ld_type = NIX_SEND_LDTYPE_LDD;
+			sg->subdc = NIX_SUBDC_SG;
+			sg->segs = 0;
+			sg_lens = (void *)sg;
+			iova = (void *)sg + sizeof(*sg);
+			/* Next subdc always starts at a 16byte boundary.
+			 * So if sg->segs is whether 2 or 3, offset += 16bytes.
+			 */
+			if ((num_segs - seg) >= (MAX_SEGS_PER_SG - 1))
+				*offset += sizeof(*sg) + (3 * sizeof(u64));
+			else
+				*offset += sizeof(*sg) + sizeof(u64);
+		}
+		dma_addr = otx2_dma_map_skb_frag(pfvf, skb, seg, &len);
+		if (dma_mapping_error(pfvf->dev, dma_addr))
+			return false;
+
+		sg_lens[frag_num(seg % MAX_SEGS_PER_SG)] = len;
+		sg->segs++;
+		*iova++ = dma_addr;
+
+		/* Save DMA mapping info for later unmapping */
+		sq->sg[sq->head].dma_addr[seg] = dma_addr;
+		sq->sg[sq->head].size[seg] = len;
+		sq->sg[sq->head].num_segs++;
+	}
+
+	sq->sg[sq->head].skb = (u64)skb;
+	return true;
+}
+
+/* Add SQE header subdescriptor structure */
+static void otx2_sqe_add_hdr(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
+			     struct nix_sqe_hdr_s *sqe_hdr,
+			     struct sk_buff *skb, u16 qidx)
+{
+	int proto = 0;
+
+	/* Check if SQE was framed before, if yes then no need to
+	 * set these constants again and again.
+	 */
+	if (!sqe_hdr->total) {
+		/* Don't free Tx buffers to Aura */
+		sqe_hdr->df = 1;
+		sqe_hdr->aura = sq->aura_id;
+		/* Post a CQE Tx after pkt transmission */
+		sqe_hdr->pnc = 1;
+		sqe_hdr->sq = qidx;
+	}
+	sqe_hdr->total = skb->len;
+	/* Set SQE identifier which will be used later for freeing SKB */
+	sqe_hdr->sqe_id = sq->head;
+
+	/* Offload TCP/UDP checksum to HW */
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		sqe_hdr->ol3ptr = skb_network_offset(skb);
+		sqe_hdr->ol4ptr = skb_transport_offset(skb);
+		/* get vlan protocol Ethertype */
+		if (eth_type_vlan(skb->protocol))
+			skb->protocol = vlan_get_protocol(skb);
+
+		if (skb->protocol == htons(ETH_P_IP)) {
+			proto = ip_hdr(skb)->protocol;
+			/* In case of TSO, HW needs this to be explicitly set.
+			 * So set this always, instead of adding a check.
+			 */
+			sqe_hdr->ol3type = NIX_SENDL3TYPE_IP4_CKSUM;
+		} else if (skb->protocol == htons(ETH_P_IPV6)) {
+			proto = ipv6_hdr(skb)->nexthdr;
+		}
+
+		if (proto == IPPROTO_TCP)
+			sqe_hdr->ol4type = NIX_SENDL4TYPE_TCP_CKSUM;
+		else if (proto == IPPROTO_UDP)
+			sqe_hdr->ol4type = NIX_SENDL4TYPE_UDP_CKSUM;
+	}
+}
+
+bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
+			struct sk_buff *skb, u16 qidx)
+{
+	struct netdev_queue *txq = netdev_get_tx_queue(netdev, qidx);
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	int offset, num_segs, free_sqe;
+	struct nix_sqe_hdr_s *sqe_hdr;
+
+	/* Check if there is room for new SQE.
+	 * 'Num of SQBs freed to SQ's pool - SQ's Aura count'
+	 * will give free SQE count.
+	 */
+	free_sqe = (sq->num_sqbs - *sq->aura_fc_addr) * sq->sqe_per_sqb;
+
+	if (!free_sqe || free_sqe < sq->sqe_thresh)
+		return false;
+
+	num_segs = skb_shinfo(skb)->nr_frags + 1;
+
+	/* If SKB doesn't fit in a single SQE, linearize it.
+	 * TODO: Consider adding JUMP descriptor instead.
+	 */
+	if (unlikely(num_segs > OTX2_MAX_FRAGS_IN_SQE)) {
+		if (__skb_linearize(skb)) {
+			dev_kfree_skb_any(skb);
+			return true;
+		}
+		num_segs = skb_shinfo(skb)->nr_frags + 1;
+	}
+
+	/* Set SQE's SEND_HDR.
+	 * Do not clear the first 64bit as it contains constant info.
+	 */
+	memset(sq->sqe_base + 8, 0, sq->sqe_size - 8);
+	sqe_hdr = (struct nix_sqe_hdr_s *)(sq->sqe_base);
+	otx2_sqe_add_hdr(pfvf, sq, sqe_hdr, skb, qidx);
+	offset = sizeof(*sqe_hdr);
+
+	/* Add SG subdesc with data frags */
+	if (!otx2_sqe_add_sg(pfvf, sq, skb, num_segs, &offset)) {
+		otx2_dma_unmap_skb_frags(pfvf, &sq->sg[sq->head]);
+		return false;
+	}
+
+	sqe_hdr->sizem1 = (offset / 16) - 1;
+
+	netdev_tx_sent_queue(txq, skb->len);
+
+	/* Flush SQE to HW */
+	otx2_sqe_flush(sq, offset);
+
+	return true;
+}
+
 void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 {
 	struct nix_cqe_rx_s *cqe;
@@ -242,3 +505,29 @@ void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
 	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
 		     ((u64)cq->cq_idx << 32) | processed_cqe);
 }
+
+void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
+{
+	struct sk_buff *skb = NULL;
+	struct otx2_snd_queue *sq;
+	struct nix_cqe_tx_s *cqe;
+	int processed_cqe = 0;
+	struct sg_list *sg;
+
+	sq = &pfvf->qset.sq[cq->cint_idx];
+
+	while ((cqe = (struct nix_cqe_tx_s *)otx2_get_next_cqe(cq))) {
+		sg = &sq->sg[cqe->comp.sqe_id];
+		skb = (struct sk_buff *)sg->skb;
+		if (skb) {
+			otx2_dma_unmap_skb_frags(pfvf, sg);
+			dev_kfree_skb_any(skb);
+			sg->skb = (u64)NULL;
+		}
+		processed_cqe++;
+	}
+
+	/* Free CQEs to HW */
+	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
+		     ((u64)cq->cq_idx << 32) | processed_cqe);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index 0944c17..d9683c3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -22,6 +22,8 @@
 #define OTX2_DATA_ALIGN(X)	ALIGN(X, OTX2_ALIGN)
 #define OTX2_HEAD_ROOM		OTX2_ALIGN
 
+#define OTX2_MAX_FRAGS_IN_SQE	9
+
 /* Rx buffer size should be in multiples of 128bytes */
 #define RCV_FRAG_LEN1(x)				\
 		((OTX2_HEAD_ROOM + OTX2_DATA_ALIGN(x)) + \
@@ -53,17 +55,27 @@
  */
 #define CQ_QCOUNT_DEFAULT	1
 
+struct sg_list {
+	u16	num_segs;
+	u64	skb;
+	u64	size[OTX2_MAX_FRAGS_IN_SQE];
+	u64	dma_addr[OTX2_MAX_FRAGS_IN_SQE];
+};
+
 struct otx2_snd_queue {
 	u8			aura_id;
+	u16			head;
 	u16			sqe_size;
 	u32			sqe_cnt;
 	u16			num_sqbs;
+	u16			sqe_thresh;
 	u8			sqe_per_sqb;
 	u64			 io_addr;
 	u64			*aura_fc_addr;
 	u64			*lmt_addr;
 	void			*sqe_base;
 	struct qmem		*sqe;
+	struct sg_list		*sg;
 	u16			sqb_count;
 	u64			*sqb_ptrs;
 } ____cacheline_aligned_in_smp;
@@ -127,4 +139,6 @@ static inline u64 otx2_iova_to_phys(void *iommu_domain, dma_addr_t dma_addr)
 }
 
 int otx2_napi_handler(struct napi_struct *napi, int budget);
+bool otx2_sq_append_skb(struct net_device *netdev, struct otx2_snd_queue *sq,
+			struct sk_buff *skb, u16 qidx);
 #endif /* OTX2_TXRX_H */
-- 
2.7.4

