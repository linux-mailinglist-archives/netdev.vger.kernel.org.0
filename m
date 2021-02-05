Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA7311937
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhBFC6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:58:46 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42748 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231904AbhBFCqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:46:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 115MfxAC031246;
        Fri, 5 Feb 2021 14:51:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=lZppum/GHNfuW2HbQKuaXwPUt4s4rbgAqrMoDeHleqI=;
 b=QMLw3yElJSrz5+7wrr4lv0sOoQbxiWXU5GUrkqiXYqqFMsn6gf4ulYjpZpnVQWUCaKVD
 t+qN8bvuicTqLjD0X6roSFNmKvOA9U/9g5y/PcYdh/K9Dr1txB2dfWif17YZrsAanCpY
 JqFFhG4bD9iIr2yE9xgPXy7bnCP8lag2sz+PIueOpTVJ8jFtijaNfE2x/kX2YfPGczxb
 5Xi/MS6fXwAkBYJ1AFXpkx2os3QmD+G6Q6MrB+ijvvWSavzG6VkVdWiYtzV5bpJwyHZL
 hL/zL36rVKQM8iLRgDfEOmoXXwM/bo8bqetOOoC8bEc9Dgmax1wLyeSeddnA2KmY8laf lw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36fnr6ag20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Feb 2021 14:51:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 5 Feb
 2021 14:51:24 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 5 Feb 2021 14:51:24 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 99E9E3F703F;
        Fri,  5 Feb 2021 14:51:20 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <jerinj@marvell.com>,
        <lcherian@marvell.com>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <schalla@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v4 05/14] octeontx2-pf: cn10k: Initialise NIX context
Date:   Sat, 6 Feb 2021 04:20:04 +0530
Message-ID: <20210205225013.15961-6-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205225013.15961-1-gakula@marvell.com>
References: <20210205225013.15961-1-gakula@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-05_13:2021-02-05,2021-02-05 signatures=0
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

