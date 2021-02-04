Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A1930F21D
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 12:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235824AbhBDL1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 06:27:00 -0500
Received: from [1.6.215.26] ([1.6.215.26]:40115 "EHLO hyd1soter2"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S235729AbhBDL0u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 06:26:50 -0500
Received: from hyd1soter2.caveonetworks.com (localhost [127.0.0.1])
        by hyd1soter2 (8.15.2/8.15.2/Debian-3) with ESMTP id 114BQ2Zh051966;
        Thu, 4 Feb 2021 16:56:02 +0530
Received: (from geetha@localhost)
        by hyd1soter2.caveonetworks.com (8.15.2/8.15.2/Submit) id 114BQ2xH051965;
        Thu, 4 Feb 2021 16:56:02 +0530
From:   Geetha sowjanya <gakula@marvell.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sbhatta@marvell.com, hkelam@marvell.com,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v3 05/14] octeontx2-pf: cn10k: Initialise NIX context
Date:   Thu,  4 Feb 2021 16:56:00 +0530
Message-Id: <1612437960-51925-1-git-send-email-gakula@marvell.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On CN10K platform NIX RQ and SQ context structure got changed.
This patch uses new mbox message "NIX_CN10K_AQ_ENQ" for NIX
context initialization on CN10K platform.

This patch also updates the nix_rx_parse_s and nix_sqe_sg_s
structures to add packet steering bit feilds.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 101 +++++++++++++++------
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  10 +-
 2 files changed, 80 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 5ddedc3..0ae2c0a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -751,11 +751,79 @@ static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
+static int cn10k_sq_aq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
+{
+	struct nix_cn10k_aq_enq_req *aq;
+
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_cn10k_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->sq.cq = pfvf->hw.rx_queues + qidx;
+	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
+	aq->sq.cq_ena = 1;
+	aq->sq.ena = 1;
+	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
+	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	/* FIXME: set based on NIX_AF_DWRR_RPM_MTU*/
+	aq->sq.smq_rr_weight = OTX2_MAX_MTU;
+	aq->sq.default_chan = pfvf->hw.tx_chan_base;
+	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
+	aq->sq.sqb_aura = sqb_aura;
+	aq->sq.sq_int_ena = NIX_SQINT_BITS;
+	aq->sq.qint_idx = 0;
+	/* Due pipelining impact minimum 2000 unused SQ CQE's
+	 * need to maintain to avoid CQ overflow.
+	 */
+	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (pfvf->qset.sqe_cnt));
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_SQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int otx2_sq_aq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
+{
+	struct nix_aq_enq_req *aq;
+
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->sq.cq = pfvf->hw.rx_queues + qidx;
+	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
+	aq->sq.cq_ena = 1;
+	aq->sq.ena = 1;
+	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
+	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
+	aq->sq.smq_rr_quantum = DFLT_RR_QTM;
+	aq->sq.default_chan = pfvf->hw.tx_chan_base;
+	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
+	aq->sq.sqb_aura = sqb_aura;
+	aq->sq.sq_int_ena = NIX_SQINT_BITS;
+	aq->sq.qint_idx = 0;
+	/* Due pipelining impact minimum 2000 unused SQ CQE's
+	 * need to maintain to avoid CQ overflow.
+	 */
+	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (pfvf->qset.sqe_cnt));
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_SQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
 static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 {
 	struct otx2_qset *qset = &pfvf->qset;
 	struct otx2_snd_queue *sq;
-	struct nix_aq_enq_req *aq;
 	struct otx2_pool *pool;
 	int err;
 
@@ -798,34 +866,11 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	sq->stats.bytes = 0;
 	sq->stats.pkts = 0;
 
-	/* Get memory to put this msg */
-	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
-	if (!aq)
-		return -ENOMEM;
-
-	aq->sq.cq = pfvf->hw.rx_queues + qidx;
-	aq->sq.max_sqe_size = NIX_MAXSQESZ_W16; /* 128 byte */
-	aq->sq.cq_ena = 1;
-	aq->sq.ena = 1;
-	/* Only one SMQ is allocated, map all SQ's to that SMQ  */
-	aq->sq.smq = pfvf->hw.txschq_list[NIX_TXSCH_LVL_SMQ][0];
-	aq->sq.smq_rr_quantum = DFLT_RR_QTM;
-	aq->sq.default_chan = pfvf->hw.tx_chan_base;
-	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
-	aq->sq.sqb_aura = sqb_aura;
-	aq->sq.sq_int_ena = NIX_SQINT_BITS;
-	aq->sq.qint_idx = 0;
-	/* Due pipelining impact minimum 2000 unused SQ CQE's
-	 * need to maintain to avoid CQ overflow.
-	 */
-	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (sq->sqe_cnt));
-
-	/* Fill AQ info */
-	aq->qidx = qidx;
-	aq->ctype = NIX_AQ_CTYPE_SQ;
-	aq->op = NIX_AQ_INSTOP_INIT;
+	if (is_dev_otx2(pfvf->pdev))
+		return otx2_sq_aq_init(pfvf, qidx, sqb_aura);
+	else
+		return cn10k_sq_aq_init(pfvf, qidx, sqb_aura);
 
-	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
 static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index cba59ddf..1f49b3c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -142,7 +142,9 @@ struct nix_rx_parse_s {
 	u64 vtag0_ptr    : 8; /* W5 */
 	u64 vtag1_ptr    : 8;
 	u64 flow_key_alg : 5;
-	u64 rsvd_383_341 : 43;
+	u64 rsvd_359_341 : 19;
+	u64 color	 : 2;
+	u64 rsvd_383_362 : 22;
 	u64 rsvd_447_384;     /* W6 */
 };
 
@@ -218,7 +220,8 @@ struct nix_sqe_ext_s {
 	u64 vlan1_ins_tci : 16;
 	u64 vlan0_ins_ena : 1;
 	u64 vlan1_ins_ena : 1;
-	u64 rsvd_127_114  : 14;
+	u64 init_color    : 2;
+	u64 rsvd_127_116  : 12;
 };
 
 struct nix_sqe_sg_s {
@@ -237,7 +240,8 @@ struct nix_sqe_sg_s {
 /* NIX send memory subdescriptor structure */
 struct nix_sqe_mem_s {
 	u64 offset        : 16; /* W0 */
-	u64 rsvd_52_16    : 37;
+	u64 rsvd_51_16    : 36;
+	u64 per_lso_seg   : 1;
 	u64 wmem          : 1;
 	u64 dsz           : 2;
 	u64 alg           : 4;
-- 
2.7.4

