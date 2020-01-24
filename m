Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6799148D30
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbgAXRqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45760 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403766AbgAXRqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:22 -0500
Received: by mail-pf1-f195.google.com with SMTP id 2so1447884pfg.12
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5oJ8KJ7wjC/Js2saeSvqrkeZK4+G5Nt9C88kXTKTP1E=;
        b=sskBn1s5tZD7bNwtjfAhG/gMCaF1EkLcZBNFb3+bllb7curYYVxSBYc+2Igiu0+zLI
         HRy3YgRpATFMZeaVwbbFrstyPU2LIba6PUq3oDAE+UWu5537aqJwXaTm9vs6bDN5k7Fp
         ZaTBj17U/0+6QbxMwgY3MkG09scyLN+ovVQyKbD5iPnY+3dDE77ZC7RYsR3LQLdVMknW
         m/Gn1wx9AQxavp2Qe38K9fVrOrBXWZgo+tEenfW2rRtCNBZ04F+a7MJKDBL/0HHloCH/
         b6/CYt/8vGxRBwqaNdzEDoYTCgkMcb/tBwJy+R3HnbE8BO5qTncLAdYmbpJL0EcnfL7O
         2NYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5oJ8KJ7wjC/Js2saeSvqrkeZK4+G5Nt9C88kXTKTP1E=;
        b=unsp/fwoFRdC22QHcmcrhCXqYXs+/7iATXxh+dRq3LALHMAvLpqTlUs9JJz4m5pB8/
         Eoz4BYjNXLzRPGqFmeCA4jrpyNAzMj8NP9sPo7dFRV3gSJKDhmxfhsnhsOla5wDSKW1D
         4J7aoI6a9yJFedNXiQIC7GyR16WzJO0VLCJANnYETBs8dmLAz79fFD2efrUqn1KxwsfS
         toRx96/MT+X+WpP6EmrfO1Nk7LzshSkhjBhTF4WVyLw5MTJCTOK1wvjyCI+LnbFob4fv
         PGow7sS9nl+fwJtwaGNIcVqAXaTB+4PXDdragy1zZ6C1fHMremiiuf/+etqMwUXOdF90
         /yCw==
X-Gm-Message-State: APjAAAXKvc3W4L3Op0g5ekHR90sakF0QM7kVzowI07nkgOlaolSmD+VY
        BXBac+sMa/Vu81OGGM8Ph14rAkL3gO4=
X-Google-Smtp-Source: APXvYqywaCFfvJGgmd1qeQU0crXAd/f9o6/jrqd1OMb1+FD0Jl/mF5MKURXy67ZJYyZaToBuS4dnCQ==
X-Received: by 2002:a63:646:: with SMTP id 67mr5326385pgg.150.1579887981212;
        Fri, 24 Jan 2020 09:46:21 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:20 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 06/17] octeontx2-pf: Receive packet handling support
Date:   Fri, 24 Jan 2020 23:15:44 +0530
Message-Id: <1579887955-22172-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added receive packet handling (NAPI) support, error stats, RX_ALL
capability config option to passon error pkts to stack upon user request.

In subsequent patches these error stats will be added to ethttool.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   2 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  44 +++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  16 +-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   | 108 +++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 180 ++++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   2 +
 6 files changed, 349 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 8f7b2cf..6b54831 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -334,6 +334,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	cq->cq_idx = qidx;
 	if (qidx < pfvf->hw.rx_queues) {
 		cq->cq_type = CQ_RX;
+		cq->cint_idx = qidx;
 		cq->cqe_cnt = qset->rqe_cnt;
 	} else {
 		cq->cq_type = CQ_TX;
@@ -364,6 +365,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	aq->cq.qsize = Q_SIZE(cq->cqe_cnt, 4);
 	aq->cq.caching = 1;
 	aq->cq.base = cq->cqe->iova;
+	aq->cq.cint_idx = cq->cint_idx;
 	aq->cq.avg_level = 255;
 
 	if (qidx < pfvf->hw.rx_queues) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4565032..b42232d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -41,6 +41,46 @@ enum arua_mapped_qtypes {
 #define NIX_LF_ERR_VEC				0x81
 #define NIX_LF_POISON_VEC			0x82
 
+/* NIX (or NPC) RX errors */
+enum otx2_errlvl {
+	NPC_ERRLVL_RE,
+	NPC_ERRLVL_LID_LA,
+	NPC_ERRLVL_LID_LB,
+	NPC_ERRLVL_LID_LC,
+	NPC_ERRLVL_LID_LD,
+	NPC_ERRLVL_LID_LE,
+	NPC_ERRLVL_LID_LF,
+	NPC_ERRLVL_LID_LG,
+	NPC_ERRLVL_LID_LH,
+	NPC_ERRLVL_NIX = 0x0F,
+};
+
+enum otx2_errcodes_re {
+	/* NPC_ERRLVL_RE errcodes */
+	ERRCODE_FCS = 0x7,
+	ERRCODE_FCS_RCV = 0x8,
+	ERRCODE_UNDERSIZE = 0x10,
+	ERRCODE_OVERSIZE = 0x11,
+	ERRCODE_OL2_LEN_MISMATCH = 0x12,
+	/* NPC_ERRLVL_NIX errcodes */
+	ERRCODE_OL3_LEN = 0x10,
+	ERRCODE_OL4_LEN = 0x11,
+	ERRCODE_OL4_CSUM = 0x12,
+	ERRCODE_IL3_LEN = 0x20,
+	ERRCODE_IL4_LEN = 0x21,
+	ERRCODE_IL4_CSUM = 0x22,
+};
+
+/* Driver counted stats */
+struct otx2_drv_stats {
+	atomic_t rx_fcs_errs;
+	atomic_t rx_oversize_errs;
+	atomic_t rx_undersize_errs;
+	atomic_t rx_csum_errs;
+	atomic_t rx_len_errs;
+	atomic_t rx_other_errs;
+};
+
 struct mbox {
 	struct otx2_mbox	mbox;
 	struct work_struct	mbox_wrk;
@@ -84,6 +124,9 @@ struct otx2_hw {
 	u16			nix_msixoff; /* Offset of NIX vectors */
 	char			*irq_name;
 	cpumask_var_t           *affinity_mask;
+
+	/* Stats */
+	struct otx2_drv_stats	drv_stats;
 };
 
 struct otx2_nic {
@@ -431,6 +474,7 @@ void otx2_sqb_flush(struct otx2_nic *pfvf);
 dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 			   gfp_t gfp);
 void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 32c8bc4..37362ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -547,9 +547,11 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 
 static void otx2_free_hw_resources(struct otx2_nic *pf)
 {
+	struct otx2_qset *qset = &pf->qset;
 	struct mbox *mbox = &pf->mbox;
+	struct otx2_cq_queue *cq;
 	struct msg_req *req;
-	int err;
+	int qidx, err;
 
 	/* Ensure all SQE are processed */
 	otx2_sqb_flush(pf);
@@ -562,6 +564,13 @@ static void otx2_free_hw_resources(struct otx2_nic *pf)
 	/* Disable RQs */
 	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
 
+	/*Dequeue all CQEs */
+	for (qidx = 0; qidx < qset->cq_cnt; qidx++) {
+		cq = &qset->cq[qidx];
+		if (cq->cq_type == CQ_RX)
+			otx2_cleanup_rx_cqes(pf, cq);
+	}
+
 	otx2_free_sq_res(pf);
 
 	/* Free RQ buffer pointers*/
@@ -901,6 +910,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 	pf->iommu_domain = iommu_get_domain_for_dev(dev);
 
+	netdev->hw_features = NETIF_F_RXCSUM;
+	netdev->features |= netdev->hw_features;
+
+	netdev->hw_features |= NETIF_F_RXALL;
+
 	netdev->netdev_ops = &otx2_netdev_ops;
 
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 13086b0..dad73cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -28,4 +28,112 @@ enum nix_send_ldtype {
 	NIX_SEND_LDTYPE_LDWB = 0x2,
 };
 
+/* NIX wqe/cqe types */
+enum nix_xqe_type {
+	NIX_XQE_TYPE_INVALID   = 0x0,
+	NIX_XQE_TYPE_RX        = 0x1,
+	NIX_XQE_TYPE_RX_IPSECS = 0x2,
+	NIX_XQE_TYPE_RX_IPSECH = 0x3,
+	NIX_XQE_TYPE_RX_IPSECD = 0x4,
+	NIX_XQE_TYPE_SEND      = 0x8,
+};
+
+/* NIX CQE/SQE subdescriptor types */
+enum nix_subdc {
+	NIX_SUBDC_NOP  = 0x0,
+	NIX_SUBDC_EXT  = 0x1,
+	NIX_SUBDC_CRC  = 0x2,
+	NIX_SUBDC_IMM  = 0x3,
+	NIX_SUBDC_SG   = 0x4,
+	NIX_SUBDC_MEM  = 0x5,
+	NIX_SUBDC_JUMP = 0x6,
+	NIX_SUBDC_WORK = 0x7,
+	NIX_SUBDC_SOD  = 0xf,
+};
+
+/* NIX CQE header structure */
+struct nix_cqe_hdr_s {
+	u64 flow_tag              : 32;
+	u64 q                     : 20;
+	u64 reserved_52_57        : 6;
+	u64 node                  : 2;
+	u64 cqe_type              : 4;
+};
+
+/* NIX CQE RX parse structure */
+struct nix_rx_parse_s {
+	u64 chan         : 12;
+	u64 desc_sizem1  : 5;
+	u64 rsvd_17      : 1;
+	u64 express      : 1;
+	u64 wqwd         : 1;
+	u64 errlev       : 4;
+	u64 errcode      : 8;
+	u64 latype       : 4;
+	u64 lbtype       : 4;
+	u64 lctype       : 4;
+	u64 ldtype       : 4;
+	u64 letype       : 4;
+	u64 lftype       : 4;
+	u64 lgtype       : 4;
+	u64 lhtype       : 4;
+	u64 pkt_lenm1    : 16; /* W1 */
+	u64 l2m          : 1;
+	u64 l2b          : 1;
+	u64 l3m          : 1;
+	u64 l3b          : 1;
+	u64 vtag0_valid  : 1;
+	u64 vtag0_gone   : 1;
+	u64 vtag1_valid  : 1;
+	u64 vtag1_gone   : 1;
+	u64 pkind        : 6;
+	u64 rsvd_95_94   : 2;
+	u64 vtag0_tci    : 16;
+	u64 vtag1_tci    : 16;
+	u64 laflags      : 8; /* W2 */
+	u64 lbflags      : 8;
+	u64 lcflags      : 8;
+	u64 ldflags      : 8;
+	u64 leflags      : 8;
+	u64 lfflags      : 8;
+	u64 lgflags      : 8;
+	u64 lhflags      : 8;
+	u64 eoh_ptr      : 8; /* W3 */
+	u64 wqe_aura     : 20;
+	u64 pb_aura      : 20;
+	u64 match_id     : 16;
+	u64 laptr        : 8; /* W4 */
+	u64 lbptr        : 8;
+	u64 lcptr        : 8;
+	u64 ldptr        : 8;
+	u64 leptr        : 8;
+	u64 lfptr        : 8;
+	u64 lgptr        : 8;
+	u64 lhptr        : 8;
+	u64 vtag0_ptr    : 8; /* W5 */
+	u64 vtag1_ptr    : 8;
+	u64 flow_key_alg : 5;
+	u64 rsvd_383_341 : 43;
+	u64 rsvd_447_384;     /* W6 */
+};
+
+/* NIX CQE RX scatter/gather subdescriptor structure */
+struct nix_rx_sg_s {
+	u64 seg_size   : 16; /* W0 */
+	u64 seg2_size  : 16;
+	u64 seg3_size  : 16;
+	u64 segs       : 2;
+	u64 rsvd_59_50 : 10;
+	u64 subdc      : 4;
+	u64 seg_addr;
+	u64 seg2_addr;
+	u64 seg3_addr;
+};
+
+struct nix_cqe_rx_s {
+	struct nix_cqe_hdr_s  hdr;
+	struct nix_rx_parse_s parse;
+	struct nix_rx_sg_s sg;
+};
+
 #endif /* OTX2_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index b07082e..0c1519a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -16,12 +16,167 @@
 #include "otx2_struct.h"
 #include "otx2_txrx.h"
 
+#define CQE_ADDR(CQ, idx) ((CQ)->cqe_base + ((CQ)->cqe_size * (idx)))
+
+static struct nix_cqe_hdr_s *otx2_get_next_cqe(struct otx2_cq_queue *cq)
+{
+	struct nix_cqe_hdr_s *cqe_hdr;
+
+	cqe_hdr = (struct nix_cqe_hdr_s *)CQE_ADDR(cq, cq->cq_head);
+	if (cqe_hdr->cqe_type == NIX_XQE_TYPE_INVALID)
+		return NULL;
+
+	cq->cq_head++;
+	cq->cq_head &= (cq->cqe_cnt - 1);
+
+	return cqe_hdr;
+}
+
+static void otx2_skb_add_frag(struct otx2_nic *pfvf, struct sk_buff *skb,
+			      u64 iova, int len)
+{
+	struct page *page;
+	void *va;
+
+	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, iova));
+	page = virt_to_page(va);
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
+			va - page_address(page), len, pfvf->rbsize);
+
+	otx2_dma_unmap_page(pfvf, iova - OTX2_HEAD_ROOM,
+			    pfvf->rbsize, DMA_FROM_DEVICE);
+}
+
+static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
+				  struct nix_cqe_rx_s *cqe, int qidx)
+{
+	struct otx2_drv_stats *stats = &pfvf->hw.drv_stats;
+	struct nix_rx_parse_s *parse = &cqe->parse;
+
+	if (parse->errlev == NPC_ERRLVL_RE) {
+		switch (parse->errcode) {
+		case ERRCODE_FCS:
+		case ERRCODE_FCS_RCV:
+			atomic_inc(&stats->rx_fcs_errs);
+			break;
+		case ERRCODE_UNDERSIZE:
+			atomic_inc(&stats->rx_undersize_errs);
+			break;
+		case ERRCODE_OVERSIZE:
+			atomic_inc(&stats->rx_oversize_errs);
+			break;
+		case ERRCODE_OL2_LEN_MISMATCH:
+			atomic_inc(&stats->rx_len_errs);
+			break;
+		default:
+			atomic_inc(&stats->rx_other_errs);
+			break;
+		}
+	} else if (parse->errlev == NPC_ERRLVL_NIX) {
+		switch (parse->errcode) {
+		case ERRCODE_OL3_LEN:
+		case ERRCODE_OL4_LEN:
+		case ERRCODE_IL3_LEN:
+		case ERRCODE_IL4_LEN:
+			atomic_inc(&stats->rx_len_errs);
+			break;
+		case ERRCODE_OL4_CSUM:
+		case ERRCODE_IL4_CSUM:
+			atomic_inc(&stats->rx_csum_errs);
+			break;
+		default:
+			atomic_inc(&stats->rx_other_errs);
+			break;
+		}
+	} else {
+		atomic_inc(&stats->rx_other_errs);
+		/* For now ignore all the NPC parser errors and
+		 * pass the packets to stack.
+		 */
+		return false;
+	}
+
+	/* If RXALL is enabled pass on packets to stack. */
+	if (cqe->sg.segs && (pfvf->netdev->features & NETIF_F_RXALL))
+		return false;
+
+	/* Free buffer back to pool */
+	if (cqe->sg.segs)
+		otx2_aura_freeptr(pfvf, qidx, cqe->sg.seg_addr & ~0x07ULL);
+	return true;
+}
+
+static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
+				 struct napi_struct *napi,
+				 struct otx2_cq_queue *cq,
+				 struct nix_cqe_rx_s *cqe)
+{
+	struct nix_rx_parse_s *parse = &cqe->parse;
+	struct sk_buff *skb = NULL;
+
+	if (unlikely(parse->errlev || parse->errcode)) {
+		if (otx2_check_rcv_errors(pfvf, cqe, cq->cq_idx))
+			return;
+	}
+
+	skb = napi_get_frags(napi);
+	if (unlikely(!skb))
+		return;
+
+	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr, cqe->sg.seg_size);
+	cq->pool_ptrs++;
+
+	skb_record_rx_queue(skb, cq->cq_idx);
+	if (pfvf->netdev->features & NETIF_F_RXCSUM)
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	napi_gro_frags(napi);
+}
+
 static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 				struct napi_struct *napi,
 				struct otx2_cq_queue *cq, int budget)
 {
-	 /* Nothing to do, for now */
-	return 0;
+	struct nix_cqe_rx_s *cqe;
+	int processed_cqe = 0;
+	s64 bufptr;
+
+	while (likely(processed_cqe < budget)) {
+		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
+		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
+		    !cqe->sg.seg_addr) {
+			if (!processed_cqe)
+				return 0;
+			break;
+		}
+		cq->cq_head++;
+		cq->cq_head &= (cq->cqe_cnt - 1);
+
+		otx2_rcv_pkt_handler(pfvf, napi, cq, cqe);
+
+		cqe->hdr.cqe_type = NIX_XQE_TYPE_INVALID;
+		cqe->sg.seg_addr = 0x00;
+		processed_cqe++;
+	}
+
+	/* Free CQEs to HW */
+	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
+		     ((u64)cq->cq_idx << 32) | processed_cqe);
+
+	if (unlikely(!cq->pool_ptrs))
+		return 0;
+
+	/* Refill pool with new buffers */
+	while (cq->pool_ptrs) {
+		bufptr = otx2_alloc_rbuf(pfvf, cq->rbpool, GFP_ATOMIC);
+		if (unlikely(bufptr <= 0))
+			break;
+		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
+		cq->pool_ptrs--;
+	}
+	otx2_get_page(cq->rbpool);
+
+	return processed_cqe;
 }
 
 static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
@@ -66,3 +221,24 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 	}
 	return workdone;
 }
+
+void otx2_cleanup_rx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq)
+{
+	struct nix_cqe_rx_s *cqe;
+	int processed_cqe = 0;
+	u64 iova, pa;
+
+	while ((cqe = (struct nix_cqe_rx_s *)otx2_get_next_cqe(cq))) {
+		if (!cqe->sg.subdc)
+			continue;
+		iova = cqe->sg.seg_addr - OTX2_HEAD_ROOM;
+		pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+		otx2_dma_unmap_page(pfvf, iova, pfvf->rbsize, DMA_FROM_DEVICE);
+		put_page(virt_to_page(phys_to_virt(pa)));
+		processed_cqe++;
+	}
+
+	/* Free CQEs to HW */
+	otx2_write64(pfvf, NIX_LF_CQ_OP_DOOR,
+		     ((u64)cq->cq_idx << 32) | processed_cqe);
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index a81bdc6..0944c17 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -95,9 +95,11 @@ struct otx2_pool {
 struct otx2_cq_queue {
 	u8			cq_idx;
 	u8			cq_type;
+	u8			cint_idx; /* CQ interrupt id */
 	u16			cqe_size;
 	u16			pool_ptrs;
 	u32			cqe_cnt;
+	u32			cq_head;
 	void			*cqe_base;
 	struct qmem		*cqe;
 	struct otx2_pool	*rbpool;
-- 
2.7.4

