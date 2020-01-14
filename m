Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F22CE13A13F
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 08:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728924AbgANHDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 02:03:11 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42269 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbgANHDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 02:03:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so6120282pfz.9
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 23:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2YlSgbfocNmci2STFEp0gfzZ0NZXZ+dGxTbLYV9Hd/s=;
        b=j5SVRlNtJsGFpy4DYK5ppM/Jk5OfhtW2f3obOonuvKG64RezLA9uVV9vS+H2FB3KVq
         MlPNMv6qNiIpOO0yDBuFLAK4JmUnDKXrVhOjwsTGdjDUeqoVarfXIETqWG0LGHdAA+Gn
         u/rh5mPTB3MYDY22JBOka4Kg07tvvw84HFLLcaZSLlyfdy8Xo74xy59mdhUDwZObv313
         kVddKt5qFT5T8TGurdtPpqbvn15G5mJL12pdHq/AaxSAo2UVx2CKrqHjni9UGv6RPWeF
         IJy0QVlw/k0SpkAcIdFUi7wSx9RDF7GCkoXDf9iBdXo53rFKvAZbdHYYROyeGtcgG1El
         fQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2YlSgbfocNmci2STFEp0gfzZ0NZXZ+dGxTbLYV9Hd/s=;
        b=nPJS8RKZo/xUmlbHlq0gG02CsVSxUZTWk9OZI0Xh+Jo+h367qJ9uO2qHdyh/vIqSo2
         5SwKiAFUQpmJ6H+2Z8Mll4Hr8j5nOSkdt5ADfZO+ooW10VK7Vs97B0/98kG1ejzLPldV
         ZPhUC9/nPUALgRAbBhcgQ2Ir47NtUBrGqEv0/oX5JFG+KkfKtLGgVKagaLrYwTeYMZP/
         D8pONcY/JnkjNH5Mlh2/RF21gPAo1CbJzztljxUOT6mlkzDBVCCo1379uwIMQX5VW/Qu
         GaQ0izAMsAy4NWSgkoClp+0TMsNlGn4Za3DQKuspMfHV2a73VU1WmcPdwM/PZiWBh4Eu
         kdIA==
X-Gm-Message-State: APjAAAX2pUFYnJ6NxuUwpS1eqrMG//++qeqaBN/GoBY7lOvzeLWZGr+W
        QFFtPrqys5087+Qu6DmnIXfTMHgoAKI=
X-Google-Smtp-Source: APXvYqwLs3OXMZWsLmLMHHsJQ0yXehLJcJNk6PcFlS7hItPDdAlKWysQHSQjN5TrG0GqCRHy+a9ySw==
X-Received: by 2002:a63:e0c:: with SMTP id d12mr24492471pgl.3.1578985384253;
        Mon, 13 Jan 2020 23:03:04 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm2241014pjr.2.2020.01.13.23.03.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 13 Jan 2020 23:03:03 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 06/17] octeontx2-pf: Receive packet handling support
Date:   Tue, 14 Jan 2020 12:32:09 +0530
Message-Id: <1578985340-28775-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578985340-28775-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   | 195 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c | 185 ++++++++++++++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   2 +
 6 files changed, 441 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 0d55131..5f31cf8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -337,6 +337,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	cq->cq_idx = qidx;
 	if (qidx < pfvf->hw.rx_queues) {
 		cq->cq_type = CQ_RX;
+		cq->cint_idx = qidx;
 		cq->cqe_cnt = qset->rqe_cnt;
 	} else {
 		cq->cq_type = CQ_TX;
@@ -367,6 +368,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	aq->cq.qsize = Q_SIZE(cq->cqe_cnt, 4);
 	aq->cq.caching = 1;
 	aq->cq.base = cq->cqe->iova;
+	aq->cq.cint_idx = cq->cint_idx;
 	aq->cq.avg_level = 255;
 
 	if (qidx < pfvf->hw.rx_queues) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index a4bf752..fb833c8 100644
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
 struct  mbox {
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
index d15e089..1f03fd6 100644
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
@@ -910,6 +919,11 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
index 13086b0..1d8d3e8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -28,4 +28,199 @@ enum nix_send_ldtype {
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
+#if defined(__BIG_ENDIAN_BITFIELD)
+	u64 cqe_type              : 4;
+	u64 node                  : 2;
+	u64 reserved_52_57        : 6;
+	u64 q                     : 20;
+	u64 flow_tag              : 32;
+#else
+	u64 flow_tag              : 32;
+	u64 q                     : 20;
+	u64 reserved_52_57        : 6;
+	u64 node                  : 2;
+	u64 cqe_type              : 4;
+#endif
+};
+
+/* NIX CQE RX parse structure */
+struct nix_rx_parse_s {
+#if defined(__BIG_ENDIAN_BITFIELD)  /* W0 */
+	u64 lhtype       : 4;
+	u64 lgtype       : 4;
+	u64 lftype       : 4;
+	u64 letype       : 4;
+	u64 ldtype       : 4;
+	u64 lctype       : 4;
+	u64 lbtype       : 4;
+	u64 latype       : 4;
+	u64 errcode      : 8;
+	u64 errlev       : 4;
+	u64 wqwd         : 1;
+	u64 express      : 1;
+	u64 rsvd_17      : 1;
+	u64 desc_sizem1  : 5;
+	u64 chan         : 12;
+#else
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
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)  /* W1 */
+	u64 vtag1_tci    : 16;
+	u64 vtag0_tci    : 16;
+	u64 rsvd_95_94   : 2;
+	u64 pkind        : 6;
+	u64 vtag1_gone   : 1;
+	u64 vtag1_valid  : 1;
+	u64 vtag0_gone   : 1;
+	u64 vtag0_valid  : 1;
+	u64 l3b          : 1;
+	u64 l3m          : 1;
+	u64 l2b          : 1;
+	u64 l2m          : 1;
+	u64 pkt_lenm1    : 16;
+#else
+	u64 pkt_lenm1    : 16;
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
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)  /* W2 */
+	u64 lhflags      : 8;
+	u64 lgflags      : 8;
+	u64 lfflags      : 8;
+	u64 leflags      : 8;
+	u64 ldflags      : 8;
+	u64 lcflags      : 8;
+	u64 lbflags      : 8;
+	u64 laflags      : 8;
+#else
+	u64 laflags      : 8;
+	u64 lbflags      : 8;
+	u64 lcflags      : 8;
+	u64 ldflags      : 8;
+	u64 leflags      : 8;
+	u64 lfflags      : 8;
+	u64 lgflags      : 8;
+	u64 lhflags      : 8;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)  /* W3 */
+	u64 match_id     : 16;
+	u64 pb_aura      : 20;
+	u64 wqe_aura     : 20;
+	u64 eoh_ptr      : 8;
+#else
+	u64 eoh_ptr      : 8;
+	u64 wqe_aura     : 20;
+	u64 pb_aura      : 20;
+	u64 match_id     : 16;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)  /* W4 */
+	u64 lhptr        : 8;
+	u64 lgptr        : 8;
+	u64 lfptr        : 8;
+	u64 leptr        : 8;
+	u64 ldptr        : 8;
+	u64 lcptr        : 8;
+	u64 lbptr        : 8;
+	u64 laptr        : 8;
+#else
+	u64 laptr        : 8;
+	u64 lbptr        : 8;
+	u64 lcptr        : 8;
+	u64 ldptr        : 8;
+	u64 leptr        : 8;
+	u64 lfptr        : 8;
+	u64 lgptr        : 8;
+	u64 lhptr        : 8;
+#endif
+#if defined(__BIG_ENDIAN_BITFIELD)	/* W5 */
+	u64 rsvd_383_341 : 43;
+	u64 flow_key_alg : 5;
+	u64 vtag1_ptr    : 8;
+	u64 vtag0_ptr    : 8;
+#else
+	u64 vtag0_ptr    : 8;
+	u64 vtag1_ptr    : 8;
+	u64 flow_key_alg : 5;
+	u64 rsvd_383_341 : 43;
+#endif
+	u64 rsvd_447_384;		/* W6 */
+};
+
+/* NIX CQE RX scatter/gather subdescriptor structure */
+struct nix_rx_sg_s {
+#if defined(__BIG_ENDIAN_BITFIELD)	/* W0 */
+	u64 subdc      : 4;
+	u64 rsvd_59_50 : 10;
+	u64 segs       : 2;
+	u64 seg3_size  : 16;
+	u64 seg2_size  : 16;
+	u64 seg_size   : 16;
+#else
+	u64 seg_size   : 16;
+	u64 seg2_size  : 16;
+	u64 seg3_size  : 16;
+	u64 segs       : 2;
+	u64 rsvd_59_50 : 10;
+	u64 subdc      : 4;
+#endif
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
index b07082e..e6be18d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -16,12 +16,170 @@
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
+			      u64 iova, int len, struct nix_rx_parse_s *parse)
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
+	otx2_skb_add_frag(pfvf, skb, cqe->sg.seg_addr,
+			  cqe->sg.seg_size, parse);
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
+	/* Make sure HW writes to CQ are done */
+	dma_rmb();
+	while (likely(processed_cqe < budget)) {
+		cqe = (struct nix_cqe_rx_s *)CQE_ADDR(cq, cq->cq_head);
+		if (cqe->hdr.cqe_type == NIX_XQE_TYPE_INVALID ||
+		    !cqe->sg.subdc) {
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
+		cqe->sg.subdc = NIX_SUBDC_NOP;
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
@@ -66,3 +224,26 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
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
+	/* Make sure HW writes to CQ are done */
+	dma_rmb();
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

