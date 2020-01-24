Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB7B148D2E
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403760AbgAXRqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:18 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42924 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387873AbgAXRqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:17 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so1472535pgb.9
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Fz3lNcxvQhTa8okltNIT0RUNWIajAKUozaBZ1xHGEjY=;
        b=Ay2Zq1D2KKa7l3pmcNyjIiPR4toTvXZXLZBIevC3QQebgt/LYRktZQKzAB6r5iag0E
         YbvEf9a9C6qiAQSde0x54szMAfZx5YGibPCULhDjhxqwXbLdbKILchz2TaNThJD2gNi/
         KMQ4S1XBGvdyhkRFkBFdkASZIipec8XlvbBBCwN2XrvE/dnf9V06vgeItVCSUBB2ciHl
         PPylQXCbpWhGbv0klAJsSv10hD7+BkOqWnw3JRlLIOKV9Pl70APS8DatVV7LHtXKx9jm
         Jt9rCHmH864O7Qq/yoQgojI6iZ1nUHh+2Cjmq1MR4s6KphwevTjVIm0nsD+EcHpgYqSC
         ZeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Fz3lNcxvQhTa8okltNIT0RUNWIajAKUozaBZ1xHGEjY=;
        b=hy7FRLlKUb7h8IdTATj+zeSMRDn8yY0atqDbcKPplJ+fn46BvdumJ3dZ3PD+wnalo2
         gPBZGewDgwX+XC6IAA80TtIjiXU+8D5W6uE7ldpdYd7LJ6LFhNrKMRol9uIIbIvpxwzm
         vtA6VuTWTPJlNWmCaz78zR6t7TAo1IDs/lOZj2r1sUmUZj70agy4IhJtTvd770v9KCK5
         zYJUEJQZbOqwAprDabnHz8mhEvxKcZZ3tiljDvb3HF1+7CwUA5Qc9ajAtl0AjTs3ESG4
         H+qSmY+9NIo3GPyOJF6keIs8DhQTsn9KDuJu/boQNs/0cslyiUdnJz20bnQKIB7DuRLU
         acZg==
X-Gm-Message-State: APjAAAXSZk5JzkbxXpSHlJCqhXUjQAHl/0c0X+XymEpF9egxsbGUwuzC
        ugdIGZftNN4sznHfwVXfVhRb6HGzE7Y=
X-Google-Smtp-Source: APXvYqyAMF6aPjY7kVG5UDubv++zMmsQLWXqUOdNxU5OuwLfqvNGtBoNLLRI6R39yzMEH+I//5Gu8Q==
X-Received: by 2002:a63:5243:: with SMTP id s3mr5041419pgl.449.1579887975348;
        Fri, 24 Jan 2020 09:46:15 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:14 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [PATCH v5 04/17] octeontx2-pf: Initialize and config queues
Date:   Fri, 24 Jan 2020 23:15:42 +0530
Message-Id: <1579887955-22172-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

This patch does the initialization of all queues ie the
receive buffer pools, receive and transmit queues, completion
or notification queues etc. Allocates all required resources
(eg transmit schedulers, receive buffers etc) and configures
them for proper functioning of queues. Also sets up receive
queue's RED dropping levels.

Co-developed-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   9 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   | 723 +++++++++++++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   | 131 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 235 ++++++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |  96 +++
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  11 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h | 102 +++
 7 files changed, 1290 insertions(+), 17 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 784207b..cd33c2e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -143,8 +143,13 @@ enum nix_scheduler {
 	NIX_TXSCH_LVL_CNT = 0x5,
 };
 
-#define TXSCH_TL1_DFLT_RR_QTM      ((1 << 24) - 1)
-#define TXSCH_TL1_DFLT_RR_PRIO     (0x1ull)
+#define TXSCH_RR_QTM_MAX		((1 << 24) - 1)
+#define TXSCH_TL1_DFLT_RR_QTM		TXSCH_RR_QTM_MAX
+#define TXSCH_TL1_DFLT_RR_PRIO		(0x1ull)
+#define MAX_SCHED_WEIGHT		0xFF
+#define DFLT_RR_WEIGHT			71
+#define DFLT_RR_QTM	((DFLT_RR_WEIGHT * TXSCH_RR_QTM_MAX) \
+			 / MAX_SCHED_WEIGHT)
 
 /* Min/Max packet sizes, excluding FCS */
 #define	NIC_HW_MIN_FRS			40
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 1fa09e9..3ebbf04 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -15,6 +15,388 @@
 #include "otx2_common.h"
 #include "otx2_struct.h"
 
+dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			   gfp_t gfp)
+{
+	dma_addr_t iova;
+
+	/* Check if request can be accommodated in previous allocated page */
+	if (pool->page && ((pool->page_offset + pool->rbsize) <=
+	    (PAGE_SIZE << pool->rbpage_order))) {
+		pool->pageref++;
+		goto ret;
+	}
+
+	otx2_get_page(pool);
+
+	/* Allocate a new page */
+	pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
+				 pool->rbpage_order);
+	if (unlikely(!pool->page))
+		return -ENOMEM;
+
+	pool->page_offset = 0;
+ret:
+	iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
+				      pool->rbsize, DMA_FROM_DEVICE);
+	if (!iova) {
+		if (!pool->page_offset)
+			__free_pages(pool->page, pool->rbpage_order);
+		pool->page = NULL;
+		return -ENOMEM;
+	}
+	pool->page_offset += pool->rbsize;
+	return iova;
+}
+
+static int otx2_get_link(struct otx2_nic *pfvf)
+{
+	int link = 0;
+	u16 map;
+
+	/* cgx lmac link */
+	if (pfvf->hw.tx_chan_base >= CGX_CHAN_BASE) {
+		map = pfvf->hw.tx_chan_base & 0x7FF;
+		link = 4 * ((map >> 8) & 0xF) + ((map >> 4) & 0xF);
+	}
+	/* LBK channel */
+	if (pfvf->hw.tx_chan_base < SDP_CHAN_BASE)
+		link = 12;
+
+	return link;
+}
+
+int otx2_txschq_config(struct otx2_nic *pfvf, int lvl)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	struct nix_txschq_config *req;
+	u64 schq, parent;
+
+	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	req->lvl = lvl;
+	req->num_regs = 1;
+
+	schq = hw->txschq_list[lvl][0];
+	/* Set topology e.t.c configuration */
+	if (lvl == NIX_TXSCH_LVL_SMQ) {
+		req->reg[0] = NIX_AF_SMQX_CFG(schq);
+		req->regval[0] |= (0x20ULL << 51) | (0x80ULL << 39) |
+				  (0x2ULL << 36);
+		req->num_regs++;
+		/* MDQ config */
+		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
+		req->reg[1] = NIX_AF_MDQX_PARENT(schq);
+		req->regval[1] = parent << 16;
+		req->num_regs++;
+		/* Set DWRR quantum */
+		req->reg[2] = NIX_AF_MDQX_SCHEDULE(schq);
+		req->regval[2] =  DFLT_RR_QTM;
+	} else if (lvl == NIX_TXSCH_LVL_TL4) {
+		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL3][0];
+		req->reg[0] = NIX_AF_TL4X_PARENT(schq);
+		req->regval[0] = parent << 16;
+		req->num_regs++;
+		req->reg[1] = NIX_AF_TL4X_SCHEDULE(schq);
+		req->regval[1] = DFLT_RR_QTM;
+	} else if (lvl == NIX_TXSCH_LVL_TL3) {
+		parent = hw->txschq_list[NIX_TXSCH_LVL_TL2][0];
+		req->reg[0] = NIX_AF_TL3X_PARENT(schq);
+		req->regval[0] = parent << 16;
+		req->num_regs++;
+		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
+		req->regval[1] = DFLT_RR_QTM;
+	} else if (lvl == NIX_TXSCH_LVL_TL2) {
+		parent =  hw->txschq_list[NIX_TXSCH_LVL_TL1][0];
+		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
+		req->regval[0] = parent << 16;
+
+		req->num_regs++;
+		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
+		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | DFLT_RR_QTM;
+
+		req->num_regs++;
+		req->reg[2] = NIX_AF_TL3_TL2X_LINKX_CFG(schq,
+							otx2_get_link(pfvf));
+		/* Enable this queue and backpressure */
+		req->regval[2] = BIT_ULL(13) | BIT_ULL(12);
+
+	} else if (lvl == NIX_TXSCH_LVL_TL1) {
+		/* Default config for TL1.
+		 * For VF this is always ignored.
+		 */
+
+		/* Set DWRR quantum */
+		req->reg[0] = NIX_AF_TL1X_SCHEDULE(schq);
+		req->regval[0] = TXSCH_TL1_DFLT_RR_QTM;
+
+		req->num_regs++;
+		req->reg[1] = NIX_AF_TL1X_TOPOLOGY(schq);
+		req->regval[1] = (TXSCH_TL1_DFLT_RR_PRIO << 1);
+
+		req->num_regs++;
+		req->reg[2] = NIX_AF_TL1X_CIR(schq);
+		req->regval[2] = 0;
+	}
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int otx2_txsch_alloc(struct otx2_nic *pfvf)
+{
+	struct nix_txsch_alloc_req *req;
+	int lvl;
+
+	/* Get memory to put this msg */
+	req = otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
+	if (!req)
+		return -ENOMEM;
+
+	/* Request one schq per level */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		req->schq[lvl] = 1;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int otx2_txschq_stop(struct otx2_nic *pfvf)
+{
+	struct nix_txsch_free_req *free_req;
+	int lvl, schq, err;
+
+	otx2_mbox_lock(&pfvf->mbox);
+	/* Free the transmit schedulers */
+	free_req = otx2_mbox_alloc_msg_nix_txsch_free(&pfvf->mbox);
+	if (!free_req) {
+		otx2_mbox_unlock(&pfvf->mbox);
+		return -ENOMEM;
+	}
+
+	free_req->flags = TXSCHQ_FREE_ALL;
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	otx2_mbox_unlock(&pfvf->mbox);
+
+	/* Clear the txschq list */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		for (schq = 0; schq < MAX_TXSCHQ_PER_FUNC; schq++)
+			pfvf->hw.txschq_list[lvl][schq] = 0;
+	}
+	return err;
+}
+
+void otx2_sqb_flush(struct otx2_nic *pfvf)
+{
+	int qidx, sqe_tail, sqe_head;
+	u64 incr, *ptr, val;
+
+	ptr = (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
+	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+		incr = (u64)qidx << 32;
+		while (1) {
+			val = otx2_atomic64_add(incr, ptr);
+			sqe_head = (val >> 20) & 0x3F;
+			sqe_tail = (val >> 28) & 0x3F;
+			if (sqe_head == sqe_tail)
+				break;
+			usleep_range(1, 3);
+		}
+	}
+}
+
+/* RED and drop levels of CQ on packet reception.
+ * For CQ level is measure of emptiness ( 0x0 = full, 255 = empty).
+ */
+#define RQ_PASS_LVL_CQ(skid, qsize)	((((skid) + 16) * 256) / (qsize))
+#define RQ_DROP_LVL_CQ(skid, qsize)	(((skid) * 256) / (qsize))
+
+/* RED and drop levels of AURA for packet reception.
+ * For AURA level is measure of fullness (0x0 = empty, 255 = full).
+ * Eg: For RQ length 1K, for pass/drop level 204/230.
+ * RED accepts pkts if free pointers > 102 & <= 205.
+ * Drops pkts if free pointers < 102.
+ */
+#define RQ_PASS_LVL_AURA (255 - ((95 * 256) / 100)) /* RED when 95% is full */
+#define RQ_DROP_LVL_AURA (255 - ((99 * 256) / 100)) /* Drop when 99% is full */
+
+/* Send skid of 2000 packets required for CQ size of 4K CQEs. */
+#define SEND_CQ_SKID	2000
+
+static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct nix_aq_enq_req *aq;
+
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->rq.cq = qidx;
+	aq->rq.ena = 1;
+	aq->rq.pb_caching = 1;
+	aq->rq.lpb_aura = lpb_aura; /* Use large packet buffer aura */
+	aq->rq.lpb_sizem1 = (DMA_BUFFER_LEN(pfvf->rbsize) / 8) - 1;
+	aq->rq.xqe_imm_size = 0; /* Copying of packet to CQE not needed */
+	aq->rq.flow_tagw = 32; /* Copy full 32bit flow_tag to CQE header */
+	aq->rq.lpb_drop_ena = 1; /* Enable RED dropping for AURA */
+	aq->rq.xqe_drop_ena = 1; /* Enable RED dropping for CQ/SSO */
+	aq->rq.xqe_pass = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+	aq->rq.xqe_drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
+	aq->rq.lpb_aura_pass = RQ_PASS_LVL_AURA;
+	aq->rq.lpb_aura_drop = RQ_DROP_LVL_AURA;
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_RQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_snd_queue *sq;
+	struct nix_aq_enq_req *aq;
+	struct otx2_pool *pool;
+	int err;
+
+	pool = &pfvf->qset.pool[sqb_aura];
+	sq = &qset->sq[qidx];
+	sq->sqe_size = NIX_SQESZ_W16 ? 64 : 128;
+	sq->sqe_cnt = qset->sqe_cnt;
+
+	err = qmem_alloc(pfvf->dev, &sq->sqe, 1, sq->sqe_size);
+	if (err)
+		return err;
+
+	sq->sqe_base = sq->sqe->base;
+
+	sq->sqe_per_sqb = (pfvf->hw.sqb_size / sq->sqe_size) - 1;
+	sq->num_sqbs = (qset->sqe_cnt + sq->sqe_per_sqb) / sq->sqe_per_sqb;
+	sq->aura_id = sqb_aura;
+	sq->aura_fc_addr = pool->fc_addr->base;
+	sq->lmt_addr = (__force u64 *)(pfvf->reg_base + LMT_LF_LMTLINEX(qidx));
+	sq->io_addr = (__force u64)otx2_get_regaddr(pfvf, NIX_LF_OP_SENDX(0));
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
+	/* Due pipelining impact minimum 2000 unused SQ CQE's
+	 * need to maintain to avoid CQ overflow.
+	 */
+	aq->sq.cq_limit = ((SEND_CQ_SKID * 256) / (sq->sqe_cnt));
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_SQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct nix_aq_enq_req *aq;
+	struct otx2_cq_queue *cq;
+	int err, pool_id;
+
+	cq = &qset->cq[qidx];
+	cq->cq_idx = qidx;
+	if (qidx < pfvf->hw.rx_queues) {
+		cq->cq_type = CQ_RX;
+		cq->cqe_cnt = qset->rqe_cnt;
+	} else {
+		cq->cq_type = CQ_TX;
+		cq->cqe_cnt = qset->sqe_cnt;
+	}
+	cq->cqe_size = pfvf->qset.xqe_size;
+
+	/* Allocate memory for CQEs */
+	err = qmem_alloc(pfvf->dev, &cq->cqe, cq->cqe_cnt, cq->cqe_size);
+	if (err)
+		return err;
+
+	/* Save CQE CPU base for faster reference */
+	cq->cqe_base = cq->cqe->base;
+	/* In case where all RQs auras point to single pool,
+	 * all CQs receive buffer pool also point to same pool.
+	 */
+	pool_id = ((cq->cq_type == CQ_RX) &&
+		   (pfvf->hw.rqpool_cnt != pfvf->hw.rx_queues)) ? 0 : qidx;
+	cq->rbpool = &qset->pool[pool_id];
+
+	/* Get memory to put this msg */
+	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
+	if (!aq)
+		return -ENOMEM;
+
+	aq->cq.ena = 1;
+	aq->cq.qsize = Q_SIZE(cq->cqe_cnt, 4);
+	aq->cq.caching = 1;
+	aq->cq.base = cq->cqe->iova;
+	aq->cq.avg_level = 255;
+
+	if (qidx < pfvf->hw.rx_queues) {
+		aq->cq.drop = RQ_DROP_LVL_CQ(pfvf->hw.rq_skid, cq->cqe_cnt);
+		aq->cq.drop_ena = 1;
+	}
+
+	/* Fill AQ info */
+	aq->qidx = qidx;
+	aq->ctype = NIX_AQ_CTYPE_CQ;
+	aq->op = NIX_AQ_INSTOP_INIT;
+
+	return otx2_sync_mbox_msg(&pfvf->mbox);
+}
+
+int otx2_config_nix_queues(struct otx2_nic *pfvf)
+{
+	int qidx, err;
+
+	/* Initialize RX queues */
+	for (qidx = 0; qidx < pfvf->hw.rx_queues; qidx++) {
+		u16 lpb_aura = otx2_get_pool_idx(pfvf, AURA_NIX_RQ, qidx);
+
+		err = otx2_rq_init(pfvf, qidx, lpb_aura);
+		if (err)
+			return err;
+	}
+
+	/* Initialize TX queues */
+	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
+		u16 sqb_aura = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
+
+		err = otx2_sq_init(pfvf, qidx, sqb_aura);
+		if (err)
+			return err;
+	}
+
+	/* Initialize completion queues */
+	for (qidx = 0; qidx < pfvf->qset.cq_cnt; qidx++) {
+		err = otx2_cq_init(pfvf, qidx);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int otx2_config_nix(struct otx2_nic *pfvf)
 {
 	struct nix_lf_alloc_req  *nixlf;
@@ -58,6 +440,302 @@ int otx2_config_nix(struct otx2_nic *pfvf)
 	return rsp->hdr.rc;
 }
 
+void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
+{
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_snd_queue *sq;
+	int sqb, qidx;
+	u64 iova, pa;
+
+	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
+		sq = &qset->sq[qidx];
+		if (!sq->sqb_ptrs)
+			continue;
+		for (sqb = 0; sqb < sq->sqb_count; sqb++) {
+			if (!sq->sqb_ptrs[sqb])
+				continue;
+			iova = sq->sqb_ptrs[sqb];
+			pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+			dma_unmap_page_attrs(pfvf->dev, iova, hw->sqb_size,
+					     DMA_FROM_DEVICE,
+					     DMA_ATTR_SKIP_CPU_SYNC);
+			put_page(virt_to_page(phys_to_virt(pa)));
+		}
+		sq->sqb_count = 0;
+	}
+}
+
+void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type)
+{
+	int pool_id, pool_start = 0, pool_end = 0, size = 0;
+	u64 iova, pa;
+
+	if (type == AURA_NIX_SQ) {
+		pool_start = otx2_get_pool_idx(pfvf, type, 0);
+		pool_end =  pool_start + pfvf->hw.sqpool_cnt;
+		size = pfvf->hw.sqb_size;
+	}
+	if (type == AURA_NIX_RQ) {
+		pool_start = otx2_get_pool_idx(pfvf, type, 0);
+		pool_end = pfvf->hw.rqpool_cnt;
+		size = pfvf->rbsize;
+	}
+
+	/* Free SQB and RQB pointers from the aura pool */
+	for (pool_id = pool_start; pool_id < pool_end; pool_id++) {
+		iova = otx2_aura_allocptr(pfvf, pool_id);
+		while (iova) {
+			if (type == AURA_NIX_RQ)
+				iova -= OTX2_HEAD_ROOM;
+
+			pa = otx2_iova_to_phys(pfvf->iommu_domain, iova);
+			dma_unmap_page_attrs(pfvf->dev, iova, size,
+					     DMA_FROM_DEVICE,
+					     DMA_ATTR_SKIP_CPU_SYNC);
+			put_page(virt_to_page(phys_to_virt(pa)));
+			iova = otx2_aura_allocptr(pfvf, pool_id);
+		}
+	}
+}
+
+void otx2_aura_pool_free(struct otx2_nic *pfvf)
+{
+	struct otx2_pool *pool;
+	int pool_id;
+
+	if (!pfvf->qset.pool)
+		return;
+
+	for (pool_id = 0; pool_id < pfvf->hw.pool_cnt; pool_id++) {
+		pool = &pfvf->qset.pool[pool_id];
+		qmem_free(pfvf->dev, pool->stack);
+		qmem_free(pfvf->dev, pool->fc_addr);
+	}
+	devm_kfree(pfvf->dev, pfvf->qset.pool);
+}
+
+static int otx2_aura_init(struct otx2_nic *pfvf, int aura_id,
+			  int pool_id, int numptrs)
+{
+	struct npa_aq_enq_req *aq;
+	struct otx2_pool *pool;
+	int err;
+
+	pool = &pfvf->qset.pool[pool_id];
+
+	/* Allocate memory for HW to update Aura count.
+	 * Alloc one cache line, so that it fits all FC_STYPE modes.
+	 */
+	if (!pool->fc_addr) {
+		err = qmem_alloc(pfvf->dev, &pool->fc_addr, 1, OTX2_ALIGN);
+		if (err)
+			return err;
+	}
+
+	/* Initialize this aura's context via AF */
+	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!aq) {
+		/* Shared mbox memory buffer is full, flush it and retry */
+		err = otx2_sync_mbox_msg(&pfvf->mbox);
+		if (err)
+			return err;
+		aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+		if (!aq)
+			return -ENOMEM;
+	}
+
+	aq->aura_id = aura_id;
+	/* Will be filled by AF with correct pool context address */
+	aq->aura.pool_addr = pool_id;
+	aq->aura.pool_caching = 1;
+	aq->aura.shift = ilog2(numptrs) - 8;
+	aq->aura.count = numptrs;
+	aq->aura.limit = numptrs;
+	aq->aura.avg_level = 255;
+	aq->aura.ena = 1;
+	aq->aura.fc_ena = 1;
+	aq->aura.fc_addr = pool->fc_addr->iova;
+	aq->aura.fc_hyst_bits = 0; /* Store count on all updates */
+
+	/* Fill AQ info */
+	aq->ctype = NPA_AQ_CTYPE_AURA;
+	aq->op = NPA_AQ_INSTOP_INIT;
+
+	return 0;
+}
+
+static int otx2_pool_init(struct otx2_nic *pfvf, u16 pool_id,
+			  int stack_pages, int numptrs, int buf_size)
+{
+	struct npa_aq_enq_req *aq;
+	struct otx2_pool *pool;
+	int err;
+
+	pool = &pfvf->qset.pool[pool_id];
+	/* Alloc memory for stack which is used to store buffer pointers */
+	err = qmem_alloc(pfvf->dev, &pool->stack,
+			 stack_pages, pfvf->hw.stack_pg_bytes);
+	if (err)
+		return err;
+
+	pool->rbsize = buf_size;
+	pool->rbpage_order = get_order(buf_size);
+
+	/* Initialize this pool's context via AF */
+	aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+	if (!aq) {
+		/* Shared mbox memory buffer is full, flush it and retry */
+		err = otx2_sync_mbox_msg(&pfvf->mbox);
+		if (err) {
+			qmem_free(pfvf->dev, pool->stack);
+			return err;
+		}
+		aq = otx2_mbox_alloc_msg_npa_aq_enq(&pfvf->mbox);
+		if (!aq) {
+			qmem_free(pfvf->dev, pool->stack);
+			return -ENOMEM;
+		}
+	}
+
+	aq->aura_id = pool_id;
+	aq->pool.stack_base = pool->stack->iova;
+	aq->pool.stack_caching = 1;
+	aq->pool.ena = 1;
+	aq->pool.buf_size = buf_size / 128;
+	aq->pool.stack_max_pages = stack_pages;
+	aq->pool.shift = ilog2(numptrs) - 8;
+	aq->pool.ptr_start = 0;
+	aq->pool.ptr_end = ~0ULL;
+
+	/* Fill AQ info */
+	aq->ctype = NPA_AQ_CTYPE_POOL;
+	aq->op = NPA_AQ_INSTOP_INIT;
+
+	return 0;
+}
+
+int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
+{
+	int qidx, pool_id, stack_pages, num_sqbs;
+	struct otx2_qset *qset = &pfvf->qset;
+	struct otx2_hw *hw = &pfvf->hw;
+	struct otx2_snd_queue *sq;
+	struct otx2_pool *pool;
+	int err, ptr;
+	s64 bufptr;
+
+	/* Calculate number of SQBs needed.
+	 *
+	 * For a 128byte SQE, and 4K size SQB, 31 SQEs will fit in one SQB.
+	 * Last SQE is used for pointing to next SQB.
+	 */
+	num_sqbs = (hw->sqb_size / 128) - 1;
+	num_sqbs = (qset->sqe_cnt + num_sqbs) / num_sqbs;
+
+	/* Get no of stack pages needed */
+	stack_pages =
+		(num_sqbs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+
+	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
+		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
+		/* Initialize aura context */
+		err = otx2_aura_init(pfvf, pool_id, pool_id, num_sqbs);
+		if (err)
+			goto fail;
+
+		/* Initialize pool context */
+		err = otx2_pool_init(pfvf, pool_id, stack_pages,
+				     num_sqbs, hw->sqb_size);
+		if (err)
+			goto fail;
+	}
+
+	/* Flush accumulated messages */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	/* Allocate pointers and free them to aura/pool */
+	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
+		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
+		pool = &pfvf->qset.pool[pool_id];
+
+		sq = &qset->sq[qidx];
+		sq->sqb_count = 0;
+		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(u64 *), GFP_KERNEL);
+		if (!sq->sqb_ptrs)
+			return -ENOMEM;
+
+		for (ptr = 0; ptr < num_sqbs; ptr++) {
+			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
+			if (bufptr <= 0)
+				return bufptr;
+			otx2_aura_freeptr(pfvf, pool_id, bufptr);
+			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
+		}
+		otx2_get_page(pool);
+	}
+
+	return 0;
+fail:
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	otx2_aura_pool_free(pfvf);
+	return err;
+}
+
+int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
+{
+	struct otx2_hw *hw = &pfvf->hw;
+	int stack_pages, pool_id, rq;
+	struct otx2_pool *pool;
+	int err, ptr, num_ptrs;
+	s64 bufptr;
+
+	num_ptrs = pfvf->qset.rqe_cnt;
+
+	stack_pages =
+		(num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
+
+	for (rq = 0; rq < hw->rx_queues; rq++) {
+		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_RQ, rq);
+		/* Initialize aura context */
+		err = otx2_aura_init(pfvf, pool_id, pool_id, num_ptrs);
+		if (err)
+			goto fail;
+	}
+	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
+		err = otx2_pool_init(pfvf, pool_id, stack_pages,
+				     num_ptrs, pfvf->rbsize);
+		if (err)
+			goto fail;
+	}
+
+	/* Flush accumulated messages */
+	err = otx2_sync_mbox_msg(&pfvf->mbox);
+	if (err)
+		goto fail;
+
+	/* Allocate pointers and free them to aura/pool */
+	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
+		pool = &pfvf->qset.pool[pool_id];
+		for (ptr = 0; ptr < num_ptrs; ptr++) {
+			bufptr = otx2_alloc_rbuf(pfvf, pool, GFP_KERNEL);
+			if (bufptr <= 0)
+				return bufptr;
+			otx2_aura_freeptr(pfvf, pool_id,
+					  bufptr + OTX2_HEAD_ROOM);
+		}
+		otx2_get_page(pool);
+	}
+
+	return 0;
+fail:
+	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
+	otx2_aura_pool_free(pfvf);
+	return err;
+}
+
 int otx2_config_npa(struct otx2_nic *pfvf)
 {
 	struct otx2_qset *qset = &pfvf->qset;
@@ -134,6 +812,14 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 		return err;
 	}
 
+	pfvf->nix_blkaddr = BLKADDR_NIX0;
+
+	/* If the platform has two NIX blocks then LF may be
+	 * allocated from NIX1.
+	 */
+	if (otx2_read64(pfvf, RVU_PF_BLOCK_ADDRX_DISC(BLKADDR_NIX1)) & 0x1FFULL)
+		pfvf->nix_blkaddr = BLKADDR_NIX1;
+
 	/* Get NPA and NIX MSIX vector offsets */
 	msix = otx2_mbox_alloc_msg_msix_offset(&pfvf->mbox);
 	if (!msix) {
@@ -158,6 +844,43 @@ int otx2_attach_npa_nix(struct otx2_nic *pfvf)
 	return 0;
 }
 
+void otx2_ctx_disable(struct mbox *mbox, int type, bool npa)
+{
+	struct hwctx_disable_req *req;
+
+	otx2_mbox_lock(mbox);
+	/* Request AQ to disable this context */
+	if (npa)
+		req = otx2_mbox_alloc_msg_npa_hwctx_disable(mbox);
+	else
+		req = otx2_mbox_alloc_msg_nix_hwctx_disable(mbox);
+
+	if (!req) {
+		otx2_mbox_unlock(mbox);
+		return;
+	}
+
+	req->ctype = type;
+
+	if (otx2_sync_mbox_msg(mbox))
+		dev_err(mbox->pfvf->dev, "%s failed to disable context\n",
+			__func__);
+
+	otx2_mbox_unlock(mbox);
+}
+
+void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
+				  struct nix_txsch_alloc_rsp *rsp)
+{
+	int lvl, schq;
+
+	/* Setup transmit scheduler list */
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
+		for (schq = 0; schq < rsp->schq[lvl]; schq++)
+			pf->hw.txschq_list[lvl][schq] =
+				rsp->schq_list[lvl][schq];
+}
+
 /* Mbox message handlers */
 void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 			       struct npa_lf_alloc_rsp *rsp)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index cdb1c56..c1e772a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -12,9 +12,11 @@
 #define OTX2_COMMON_H
 
 #include <linux/pci.h>
+#include <linux/iommu.h>
 
 #include <mbox.h>
 #include "otx2_reg.h"
+#include "otx2_txrx.h"
 
 /* PCI device IDs */
 #define PCI_DEVID_OCTEONTX2_RVU_PF              0xA063
@@ -25,15 +27,9 @@
 
 #define NAME_SIZE                               32
 
-struct otx2_pool {
-	struct qmem		*stack;
-};
-
-struct otx2_qset {
-#define OTX2_MAX_CQ_CNT		64
-	u16			cq_cnt;
-	u16			xqe_size; /* Size of CQE i.e 128 or 512 bytes */
-	struct otx2_pool	*pool;
+enum arua_mapped_qtypes {
+	AURA_NIX_RQ,
+	AURA_NIX_SQ,
 };
 
 struct mbox {
@@ -54,14 +50,21 @@ struct otx2_hw {
 	u16                     tx_queues;
 	u16			max_queues;
 	u16			pool_cnt;
+	u16			rqpool_cnt;
+	u16			sqpool_cnt;
 
 	/* NPA */
 	u32			stack_pg_ptrs;  /* No of ptrs per stack page */
 	u32			stack_pg_bytes; /* Size of stack page */
 	u16			sqb_size;
 
+	/* NIX */
+	u16		txschq_list[NIX_TXSCH_LVL_CNT][MAX_TXSCHQ_PER_FUNC];
+
+	/* HW settings, coalescing etc */
 	u16			rx_chan_base;
 	u16			tx_chan_base;
+	u16			rq_skid;
 
 	/* MSI-X */
 	u16			npa_msixoff; /* Offset of NPA vectors */
@@ -73,6 +76,8 @@ struct otx2_hw {
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
+	void			*iommu_domain;
+	u16			rbsize; /* Receive buffer size */
 
 	struct otx2_qset	qset;
 	struct otx2_hw		hw;
@@ -84,6 +89,9 @@ struct otx2_nic {
 	struct workqueue_struct *mbox_wq;
 
 	u16			pcifunc; /* RVU PF_FUNC */
+
+	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
+	int			nix_blkaddr;
 };
 
 /* Register read/write APIs */
@@ -93,7 +101,7 @@ static inline void __iomem *otx2_get_regaddr(struct otx2_nic *nic, u64 offset)
 
 	switch ((offset >> RVU_FUNC_BLKADDR_SHIFT) & RVU_FUNC_BLKADDR_MASK) {
 	case BLKTYPE_NIX:
-		blkaddr = BLKADDR_NIX0;
+		blkaddr = nic->nix_blkaddr;
 		break;
 	case BLKTYPE_NPA:
 		blkaddr = BLKADDR_NPA;
@@ -184,6 +192,72 @@ static inline void otx2_mbox_unlock(struct mbox *mbox)
 	mutex_unlock(&mbox->lock);
 }
 
+/* With the absence of API for 128-bit IO memory access for arm64,
+ * implement required operations at place.
+ */
+#if defined(CONFIG_ARM64)
+static inline void otx2_write128(u64 lo, u64 hi, void __iomem *addr)
+{
+	__asm__ volatile("stp %x[x0], %x[x1], [%x[p1],#0]!"
+			 ::[x0]"r"(lo), [x1]"r"(hi), [p1]"r"(addr));
+}
+
+static inline u64 otx2_atomic64_add(u64 incr, u64 *ptr)
+{
+	u64 result;
+
+	__asm__ volatile(".cpu   generic+lse\n"
+			 "ldadd %x[i], %x[r], [%[b]]"
+			 : [r]"=r"(result), "+m"(*ptr)
+			 : [i]"r"(incr), [b]"r"(ptr)
+			 : "memory");
+	return result;
+}
+
+#else
+#define otx2_write128(lo, hi, addr)
+#define otx2_atomic64_add(incr, ptr)		({ *ptr = incr; })
+#endif
+
+/* Alloc pointer from pool/aura */
+static inline u64 otx2_aura_allocptr(struct otx2_nic *pfvf, int aura)
+{
+	u64 *ptr = (u64 *)otx2_get_regaddr(pfvf,
+			   NPA_LF_AURA_OP_ALLOCX(0));
+	u64 incr = (u64)aura | BIT_ULL(63);
+
+	return otx2_atomic64_add(incr, ptr);
+}
+
+/* Free pointer to a pool/aura */
+static inline void otx2_aura_freeptr(struct otx2_nic *pfvf,
+				     int aura, s64 buf)
+{
+	otx2_write128((u64)buf, (u64)aura | BIT_ULL(63),
+		      otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_FREE0));
+}
+
+/* Update page ref count */
+static inline void otx2_get_page(struct otx2_pool *pool)
+{
+	if (!pool->page)
+		return;
+
+	if (pool->pageref)
+		page_ref_add(pool->page, pool->pageref);
+	pool->pageref = 0;
+	pool->page = NULL;
+}
+
+static inline int otx2_get_pool_idx(struct otx2_nic *pfvf, int type, int idx)
+{
+	if (type == AURA_NIX_SQ)
+		return pfvf->hw.rqpool_cnt + idx;
+
+	 /* AURA_NIX_RQ */
+	return idx;
+}
+
 /* Mbox APIs */
 static inline int otx2_sync_mbox_msg(struct mbox *mbox)
 {
@@ -263,11 +337,46 @@ MBOX_UP_CGX_MESSAGES
 #define	RVU_PFVF_FUNC_SHIFT	0
 #define	RVU_PFVF_FUNC_MASK	0x3FF
 
+static inline dma_addr_t otx2_dma_map_page(struct otx2_nic *pfvf,
+					   struct page *page,
+					   size_t offset, size_t size,
+					   enum dma_data_direction dir)
+{
+	dma_addr_t iova;
+
+	iova = dma_map_page_attrs(pfvf->dev, page,
+				  offset, size, dir, DMA_ATTR_SKIP_CPU_SYNC);
+	if (unlikely(dma_mapping_error(pfvf->dev, iova)))
+		return (dma_addr_t)NULL;
+	return iova;
+}
+
+static inline void otx2_dma_unmap_page(struct otx2_nic *pfvf,
+				       dma_addr_t addr, size_t size,
+				       enum dma_data_direction dir)
+{
+	dma_unmap_page_attrs(pfvf->dev, addr, size,
+			     dir, DMA_ATTR_SKIP_CPU_SYNC);
+}
+
 /* RVU block related APIs */
 int otx2_attach_npa_nix(struct otx2_nic *pfvf);
 int otx2_detach_resources(struct mbox *mbox);
 int otx2_config_npa(struct otx2_nic *pfvf);
+int otx2_sq_aura_pool_init(struct otx2_nic *pfvf);
+int otx2_rq_aura_pool_init(struct otx2_nic *pfvf);
+void otx2_aura_pool_free(struct otx2_nic *pfvf);
+void otx2_free_aura_ptr(struct otx2_nic *pfvf, int type);
+void otx2_sq_free_sqbs(struct otx2_nic *pfvf);
 int otx2_config_nix(struct otx2_nic *pfvf);
+int otx2_config_nix_queues(struct otx2_nic *pfvf);
+int otx2_txschq_config(struct otx2_nic *pfvf, int lvl);
+int otx2_txsch_alloc(struct otx2_nic *pfvf);
+int otx2_txschq_stop(struct otx2_nic *pfvf);
+void otx2_sqb_flush(struct otx2_nic *pfvf);
+dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
+			   gfp_t gfp);
+void otx2_ctx_disable(struct mbox *mbox, int type, bool npa);
 
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
@@ -276,4 +385,6 @@ void mbox_handler_npa_lf_alloc(struct otx2_nic *pfvf,
 			       struct npa_lf_alloc_rsp *rsp);
 void mbox_handler_nix_lf_alloc(struct otx2_nic *pfvf,
 			       struct nix_lf_alloc_rsp *rsp);
+void mbox_handler_nix_txsch_alloc(struct otx2_nic *pf,
+				  struct nix_txsch_alloc_rsp *rsp);
 #endif /* OTX2_COMMON_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ef5dba4..7351889 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -17,7 +17,10 @@
 #include <linux/iommu.h>
 #include <net/ip.h>
 
+#include "otx2_reg.h"
 #include "otx2_common.h"
+#include "otx2_txrx.h"
+#include "otx2_struct.h"
 
 #define DRV_NAME	"octeontx2-nicpf"
 #define DRV_STRING	"Marvell OcteonTX2 NIC Physical Function Driver"
@@ -123,6 +126,10 @@ static void otx2_process_pfaf_mbox_msg(struct otx2_nic *pf,
 	case MBOX_MSG_NIX_LF_ALLOC:
 		mbox_handler_nix_lf_alloc(pf, (struct nix_lf_alloc_rsp *)msg);
 		break;
+	case MBOX_MSG_NIX_TXSCH_ALLOC:
+		mbox_handler_nix_txsch_alloc(pf,
+					     (struct nix_txsch_alloc_rsp *)msg);
+		break;
 	default:
 		if (msg->rc)
 			dev_err(pf->dev,
@@ -379,26 +386,231 @@ static int otx2_set_real_num_queues(struct net_device *netdev,
 	return err;
 }
 
+static void otx2_free_cq_res(struct otx2_nic *pf)
+{
+	struct otx2_qset *qset = &pf->qset;
+	struct otx2_cq_queue *cq;
+	int qidx;
+
+	/* Disable CQs */
+	otx2_ctx_disable(&pf->mbox, NIX_AQ_CTYPE_CQ, false);
+	for (qidx = 0; qidx < qset->cq_cnt; qidx++) {
+		cq = &qset->cq[qidx];
+		qmem_free(pf->dev, cq->cqe);
+	}
+}
+
+static void otx2_free_sq_res(struct otx2_nic *pf)
+{
+	struct otx2_qset *qset = &pf->qset;
+	struct otx2_snd_queue *sq;
+	int qidx;
+
+	/* Disable SQs */
+	otx2_ctx_disable(&pf->mbox, NIX_AQ_CTYPE_SQ, false);
+	/* Free SQB pointers */
+	otx2_sq_free_sqbs(pf);
+	for (qidx = 0; qidx < pf->hw.tx_queues; qidx++) {
+		sq = &qset->sq[qidx];
+		qmem_free(pf->dev, sq->sqe);
+		kfree(sq->sqb_ptrs);
+	}
+}
+
+static int otx2_init_hw_resources(struct otx2_nic *pf)
+{
+	struct mbox *mbox = &pf->mbox;
+	struct otx2_hw *hw = &pf->hw;
+	struct msg_req *req;
+	int err = 0, lvl;
+
+	/* Set required NPA LF's pool counts
+	 * Auras and Pools are used in a 1:1 mapping,
+	 * so, aura count = pool count.
+	 */
+	hw->rqpool_cnt = hw->rx_queues;
+	hw->sqpool_cnt = hw->tx_queues;
+	hw->pool_cnt = hw->rqpool_cnt + hw->sqpool_cnt;
+
+	/* Get the size of receive buffers to allocate */
+	pf->rbsize = RCV_FRAG_LEN(pf->netdev->mtu);
+
+	otx2_mbox_lock(mbox);
+	/* NPA init */
+	err = otx2_config_npa(pf);
+	if (err)
+		goto exit;
+
+	/* NIX init */
+	err = otx2_config_nix(pf);
+	if (err)
+		goto err_free_npa_lf;
+
+	/* Init Auras and pools used by NIX RQ, for free buffer ptrs */
+	err = otx2_rq_aura_pool_init(pf);
+	if (err) {
+		otx2_mbox_unlock(mbox);
+		goto err_free_nix_lf;
+	}
+	/* Init Auras and pools used by NIX SQ, for queueing SQEs */
+	err = otx2_sq_aura_pool_init(pf);
+	if (err) {
+		otx2_mbox_unlock(mbox);
+		goto err_free_rq_ptrs;
+	}
+
+	err = otx2_txsch_alloc(pf);
+	if (err) {
+		otx2_mbox_unlock(mbox);
+		goto err_free_sq_ptrs;
+	}
+
+	err = otx2_config_nix_queues(pf);
+	if (err) {
+		otx2_mbox_unlock(mbox);
+		goto err_free_txsch;
+	}
+	for (lvl = 0; lvl < NIX_TXSCH_LVL_CNT; lvl++) {
+		err = otx2_txschq_config(pf, lvl);
+		if (err) {
+			otx2_mbox_unlock(mbox);
+			goto err_free_nix_queues;
+		}
+	}
+	otx2_mbox_unlock(mbox);
+	return err;
+
+err_free_nix_queues:
+	otx2_free_sq_res(pf);
+	otx2_free_cq_res(pf);
+	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
+err_free_txsch:
+	if (otx2_txschq_stop(pf))
+		dev_err(pf->dev, "%s failed to stop TX schedulers\n", __func__);
+err_free_sq_ptrs:
+	otx2_sq_free_sqbs(pf);
+err_free_rq_ptrs:
+	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
+	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_POOL, true);
+	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_AURA, true);
+	otx2_aura_pool_free(pf);
+err_free_nix_lf:
+	otx2_mbox_lock(mbox);
+	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
+	if (req) {
+		if (otx2_sync_mbox_msg(mbox))
+			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
+	}
+err_free_npa_lf:
+	/* Reset NPA LF */
+	req = otx2_mbox_alloc_msg_npa_lf_free(mbox);
+	if (req) {
+		if (otx2_sync_mbox_msg(mbox))
+			dev_err(pf->dev, "%s failed to free npalf\n", __func__);
+	}
+exit:
+	otx2_mbox_unlock(mbox);
+	return err;
+}
+
+static void otx2_free_hw_resources(struct otx2_nic *pf)
+{
+	struct mbox *mbox = &pf->mbox;
+	struct msg_req *req;
+	int err;
+
+	/* Ensure all SQE are processed */
+	otx2_sqb_flush(pf);
+
+	/* Stop transmission */
+	err = otx2_txschq_stop(pf);
+	if (err)
+		dev_err(pf->dev, "RVUPF: Failed to stop/free TX schedulers\n");
+
+	/* Disable RQs */
+	otx2_ctx_disable(mbox, NIX_AQ_CTYPE_RQ, false);
+
+	otx2_free_sq_res(pf);
+
+	/* Free RQ buffer pointers*/
+	otx2_free_aura_ptr(pf, AURA_NIX_RQ);
+
+	otx2_free_cq_res(pf);
+
+	otx2_mbox_lock(mbox);
+	/* Reset NIX LF */
+	req = otx2_mbox_alloc_msg_nix_lf_free(mbox);
+	if (req) {
+		if (otx2_sync_mbox_msg(mbox))
+			dev_err(pf->dev, "%s failed to free nixlf\n", __func__);
+	}
+	otx2_mbox_unlock(mbox);
+
+	/* Disable NPA Pool and Aura hw context */
+	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_POOL, true);
+	otx2_ctx_disable(mbox, NPA_AQ_CTYPE_AURA, true);
+	otx2_aura_pool_free(pf);
+
+	otx2_mbox_lock(mbox);
+	/* Reset NPA LF */
+	req = otx2_mbox_alloc_msg_npa_lf_free(mbox);
+	if (req) {
+		if (otx2_sync_mbox_msg(mbox))
+			dev_err(pf->dev, "%s failed to free npalf\n", __func__);
+	}
+	otx2_mbox_unlock(mbox);
+}
+
 static int otx2_open(struct net_device *netdev)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
+	struct otx2_qset *qset = &pf->qset;
 	int err = 0;
 
 	netif_carrier_off(netdev);
 
 	pf->qset.cq_cnt = pf->hw.rx_queues + pf->hw.tx_queues;
 
-	/* NPA init */
-	err = otx2_config_npa(pf);
+	/* CQ size of RQ */
+	qset->rqe_cnt = qset->rqe_cnt ? qset->rqe_cnt : Q_COUNT(Q_SIZE_256);
+	/* CQ size of SQ */
+	qset->sqe_cnt = qset->sqe_cnt ? qset->sqe_cnt : Q_COUNT(Q_SIZE_4K);
+
+	err = -ENOMEM;
+	qset->cq = kcalloc(pf->qset.cq_cnt,
+			   sizeof(struct otx2_cq_queue), GFP_KERNEL);
+	if (!qset->cq)
+		goto err_free_mem;
+
+	qset->sq = kcalloc(pf->hw.tx_queues,
+			   sizeof(struct otx2_snd_queue), GFP_KERNEL);
+	if (!qset->sq)
+		goto err_free_mem;
+
+	err = otx2_init_hw_resources(pf);
 	if (err)
-		return err;
+		goto err_free_mem;
 
-	/* NIX init */
-	return otx2_config_nix(pf);
+	return 0;
+err_free_mem:
+	kfree(qset->sq);
+	kfree(qset->cq);
+	return err;
 }
 
 static int otx2_stop(struct net_device *netdev)
 {
+	struct otx2_nic *pf = netdev_priv(netdev);
+	struct otx2_qset *qset = &pf->qset;
+
+	otx2_free_hw_resources(pf);
+
+	kfree(qset->sq);
+	kfree(qset->cq);
+
+	/* Do not clear RQ/SQ ringsize settings */
+	memset((void *)qset + offsetof(struct otx2_qset, sqe_cnt), 0,
+	       sizeof(*qset) - offsetof(struct otx2_qset, sqe_cnt));
 	return 0;
 }
 
@@ -557,6 +769,19 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_detach_rsrc;
 
+	/* NPA's pool is a stack to which SW frees buffer pointers via Aura.
+	 * HW allocates buffer pointer from stack and uses it for DMA'ing
+	 * ingress packet. In some scenarios HW can free back allocated buffer
+	 * pointers to pool. This makes it impossible for SW to maintain a
+	 * parallel list where physical addresses of buffer pointers (IOVAs)
+	 * given to HW can be saved for later reference.
+	 *
+	 * So the only way to convert Rx packet's buffer address is to use
+	 * IOMMU's iova_to_phys() handler which translates the address by
+	 * walking through the translation tables.
+	 */
+	pf->iommu_domain = iommu_get_domain_for_dev(dev);
+
 	netdev->netdev_ops = &otx2_netdev_ops;
 
 	err = register_netdev(netdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index d0bd64a..7963d41 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -48,4 +48,100 @@
 #define RVU_FUNC_BLKADDR_SHIFT		20
 #define RVU_FUNC_BLKADDR_MASK		0x1FULL
 
+/* NPA LF registers */
+#define NPA_LFBASE			(BLKTYPE_NPA << RVU_FUNC_BLKADDR_SHIFT)
+#define NPA_LF_AURA_OP_ALLOCX(a)	(NPA_LFBASE | 0x10 | (a) << 3)
+#define NPA_LF_AURA_OP_FREE0            (NPA_LFBASE | 0x20)
+#define NPA_LF_AURA_OP_FREE1            (NPA_LFBASE | 0x28)
+#define NPA_LF_AURA_OP_CNT              (NPA_LFBASE | 0x30)
+#define NPA_LF_AURA_OP_LIMIT            (NPA_LFBASE | 0x50)
+#define NPA_LF_AURA_OP_INT              (NPA_LFBASE | 0x60)
+#define NPA_LF_AURA_OP_THRESH           (NPA_LFBASE | 0x70)
+#define NPA_LF_POOL_OP_PC               (NPA_LFBASE | 0x100)
+#define NPA_LF_POOL_OP_AVAILABLE        (NPA_LFBASE | 0x110)
+#define NPA_LF_POOL_OP_PTR_START0       (NPA_LFBASE | 0x120)
+#define NPA_LF_POOL_OP_PTR_START1       (NPA_LFBASE | 0x128)
+#define NPA_LF_POOL_OP_PTR_END0         (NPA_LFBASE | 0x130)
+#define NPA_LF_POOL_OP_PTR_END1         (NPA_LFBASE | 0x138)
+#define NPA_LF_POOL_OP_INT              (NPA_LFBASE | 0x160)
+#define NPA_LF_POOL_OP_THRESH           (NPA_LFBASE | 0x170)
+#define NPA_LF_ERR_INT                  (NPA_LFBASE | 0x200)
+#define NPA_LF_ERR_INT_W1S              (NPA_LFBASE | 0x208)
+#define NPA_LF_ERR_INT_ENA_W1C          (NPA_LFBASE | 0x210)
+#define NPA_LF_ERR_INT_ENA_W1S          (NPA_LFBASE | 0x218)
+#define NPA_LF_RAS                      (NPA_LFBASE | 0x220)
+#define NPA_LF_RAS_W1S                  (NPA_LFBASE | 0x228)
+#define NPA_LF_RAS_ENA_W1C              (NPA_LFBASE | 0x230)
+#define NPA_LF_RAS_ENA_W1S              (NPA_LFBASE | 0x238)
+#define NPA_LF_QINTX_CNT(a)             (NPA_LFBASE | 0x300 | (a) << 12)
+#define NPA_LF_QINTX_INT(a)             (NPA_LFBASE | 0x310 | (a) << 12)
+#define NPA_LF_QINTX_INT_W1S(a)         (NPA_LFBASE | 0x318 | (a) << 12)
+#define NPA_LF_QINTX_ENA_W1S(a)         (NPA_LFBASE | 0x320 | (a) << 12)
+#define NPA_LF_QINTX_ENA_W1C(a)         (NPA_LFBASE | 0x330 | (a) << 12)
+
+/* NIX LF registers */
+#define	NIX_LFBASE			(BLKTYPE_NIX << RVU_FUNC_BLKADDR_SHIFT)
+#define	NIX_LF_RX_SECRETX(a)		(NIX_LFBASE | 0x0 | (a) << 3)
+#define	NIX_LF_CFG			(NIX_LFBASE | 0x100)
+#define	NIX_LF_GINT			(NIX_LFBASE | 0x200)
+#define	NIX_LF_GINT_W1S			(NIX_LFBASE | 0x208)
+#define	NIX_LF_GINT_ENA_W1C		(NIX_LFBASE | 0x210)
+#define	NIX_LF_GINT_ENA_W1S		(NIX_LFBASE | 0x218)
+#define	NIX_LF_ERR_INT			(NIX_LFBASE | 0x220)
+#define	NIX_LF_ERR_INT_W1S		(NIX_LFBASE | 0x228)
+#define	NIX_LF_ERR_INT_ENA_W1C		(NIX_LFBASE | 0x230)
+#define	NIX_LF_ERR_INT_ENA_W1S		(NIX_LFBASE | 0x238)
+#define	NIX_LF_RAS			(NIX_LFBASE | 0x240)
+#define	NIX_LF_RAS_W1S			(NIX_LFBASE | 0x248)
+#define	NIX_LF_RAS_ENA_W1C		(NIX_LFBASE | 0x250)
+#define	NIX_LF_RAS_ENA_W1S		(NIX_LFBASE | 0x258)
+#define	NIX_LF_SQ_OP_ERR_DBG		(NIX_LFBASE | 0x260)
+#define	NIX_LF_MNQ_ERR_DBG		(NIX_LFBASE | 0x270)
+#define	NIX_LF_SEND_ERR_DBG		(NIX_LFBASE | 0x280)
+#define	NIX_LF_TX_STATX(a)		(NIX_LFBASE | 0x300 | (a) << 3)
+#define	NIX_LF_RX_STATX(a)		(NIX_LFBASE | 0x400 | (a) << 3)
+#define	NIX_LF_OP_SENDX(a)		(NIX_LFBASE | 0x800 | (a) << 3)
+#define	NIX_LF_RQ_OP_INT		(NIX_LFBASE | 0x900)
+#define	NIX_LF_RQ_OP_OCTS		(NIX_LFBASE | 0x910)
+#define	NIX_LF_RQ_OP_PKTS		(NIX_LFBASE | 0x920)
+#define	NIX_LF_OP_IPSEC_DYNO_CN		(NIX_LFBASE | 0x980)
+#define	NIX_LF_SQ_OP_INT		(NIX_LFBASE | 0xa00)
+#define	NIX_LF_SQ_OP_OCTS		(NIX_LFBASE | 0xa10)
+#define	NIX_LF_SQ_OP_PKTS		(NIX_LFBASE | 0xa20)
+#define	NIX_LF_SQ_OP_STATUS		(NIX_LFBASE | 0xa30)
+#define	NIX_LF_CQ_OP_INT		(NIX_LFBASE | 0xb00)
+#define	NIX_LF_CQ_OP_DOOR		(NIX_LFBASE | 0xb30)
+#define	NIX_LF_CQ_OP_STATUS		(NIX_LFBASE | 0xb40)
+#define	NIX_LF_QINTX_CNT(a)		(NIX_LFBASE | 0xC00 | (a) << 12)
+#define	NIX_LF_QINTX_INT(a)		(NIX_LFBASE | 0xC10 | (a) << 12)
+#define	NIX_LF_QINTX_INT_W1S(a)		(NIX_LFBASE | 0xC18 | (a) << 12)
+#define	NIX_LF_QINTX_ENA_W1S(a)		(NIX_LFBASE | 0xC20 | (a) << 12)
+#define	NIX_LF_QINTX_ENA_W1C(a)		(NIX_LFBASE | 0xC30 | (a) << 12)
+#define	NIX_LF_CINTX_CNT(a)		(NIX_LFBASE | 0xD00 | (a) << 12)
+#define	NIX_LF_CINTX_WAIT(a)		(NIX_LFBASE | 0xD10 | (a) << 12)
+#define	NIX_LF_CINTX_INT(a)		(NIX_LFBASE | 0xD20 | (a) << 12)
+#define	NIX_LF_CINTX_INT_W1S(a)		(NIX_LFBASE | 0xD30 | (a) << 12)
+#define	NIX_LF_CINTX_ENA_W1S(a)		(NIX_LFBASE | 0xD40 | (a) << 12)
+#define	NIX_LF_CINTX_ENA_W1C(a)		(NIX_LFBASE | 0xD50 | (a) << 12)
+
+/* NIX AF transmit scheduler registers */
+#define NIX_AF_SMQX_CFG(a)		(0x700 | (a) << 16)
+#define NIX_AF_TL1X_SCHEDULE(a)		(0xC00 | (a) << 16)
+#define NIX_AF_TL1X_CIR(a)		(0xC20 | (a) << 16)
+#define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
+#define NIX_AF_TL2X_PARENT(a)		(0xE88 | (a) << 16)
+#define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (a) << 16)
+#define NIX_AF_TL3X_PARENT(a)		(0x1088 | (a) << 16)
+#define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
+#define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
+#define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
+#define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
+#define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
+#define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3)
+
+/* LMT LF registers */
+#define LMT_LFBASE			BIT_ULL(RVU_FUNC_BLKADDR_SHIFT)
+#define LMT_LF_LMTLINEX(a)		(LMT_LFBASE | 0x000 | (a) << 12)
+#define LMT_LF_LMTCANCEL		(LMT_LFBASE | 0x400)
+
 #endif /* OTX2_REG_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index e37f89f..13086b0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -17,4 +17,15 @@ enum nix_cqesz_e {
 	NIX_XQESZ_W16 = 0x1,
 };
 
+enum nix_sqes_e {
+	NIX_SQESZ_W16 = 0x0,
+	NIX_SQESZ_W8 = 0x1,
+};
+
+enum nix_send_ldtype {
+	NIX_SEND_LDTYPE_LDD  = 0x0,
+	NIX_SEND_LDTYPE_LDT  = 0x1,
+	NIX_SEND_LDTYPE_LDWB = 0x2,
+};
+
 #endif /* OTX2_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
new file mode 100644
index 0000000..ce6efcf
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -0,0 +1,102 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Marvell OcteonTx2 RVU Ethernet driver
+ *
+ * Copyright (C) 2020 Marvell International Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef OTX2_TXRX_H
+#define OTX2_TXRX_H
+
+#include <linux/etherdevice.h>
+#include <linux/iommu.h>
+#include <linux/if_vlan.h>
+
+#define LBK_CHAN_BASE	0x000
+#define SDP_CHAN_BASE	0x700
+#define CGX_CHAN_BASE	0x800
+
+#define OTX2_DATA_ALIGN(X)	ALIGN(X, OTX2_ALIGN)
+#define OTX2_HEAD_ROOM		OTX2_ALIGN
+
+/* Rx buffer size should be in multiples of 128bytes */
+#define RCV_FRAG_LEN1(x)				\
+		((OTX2_HEAD_ROOM + OTX2_DATA_ALIGN(x)) + \
+		OTX2_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
+/* Prefer 2048 byte buffers for better last level cache
+ * utilization or data distribution across regions.
+ */
+#define RCV_FRAG_LEN(x)	\
+		((RCV_FRAG_LEN1(x) < 2048) ? 2048 : RCV_FRAG_LEN1(x))
+
+#define DMA_BUFFER_LEN(x)		\
+		((x) - OTX2_HEAD_ROOM - \
+		OTX2_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
+struct otx2_snd_queue {
+	u8			aura_id;
+	u16			sqe_size;
+	u32			sqe_cnt;
+	u16			num_sqbs;
+	u8			sqe_per_sqb;
+	u64			 io_addr;
+	u64			*aura_fc_addr;
+	u64			*lmt_addr;
+	void			*sqe_base;
+	struct qmem		*sqe;
+	u16			sqb_count;
+	u64			*sqb_ptrs;
+} ____cacheline_aligned_in_smp;
+
+struct otx2_pool {
+	struct qmem		*stack;
+	struct qmem		*fc_addr;
+	u8			rbpage_order;
+	u16			rbsize;
+	u32			page_offset;
+	u16			pageref;
+	struct page		*page;
+};
+
+enum cq_type {
+	CQ_RX,
+	CQ_TX,
+	CQS_PER_CINT = 2, /* RQ + SQ */
+};
+
+struct otx2_cq_queue {
+	u8			cq_idx;
+	u8			cq_type;
+	u16			cqe_size;
+	u16			pool_ptrs;
+	u32			cqe_cnt;
+	void			*cqe_base;
+	struct qmem		*cqe;
+	struct otx2_pool	*rbpool;
+} ____cacheline_aligned_in_smp;
+
+struct otx2_qset {
+	u32			rqe_cnt;
+	u32			sqe_cnt; /* Keep these two at top */
+#define OTX2_MAX_CQ_CNT		64
+	u16			cq_cnt;
+	u16			xqe_size;
+	struct otx2_pool	*pool;
+	struct otx2_cq_queue	*cq;
+	struct otx2_snd_queue	*sq;
+};
+
+/* Translate IOVA to physical address */
+static inline u64 otx2_iova_to_phys(void *iommu_domain, dma_addr_t dma_addr)
+{
+	/* Translation is installed only when IOMMU is present */
+	if (likely(iommu_domain))
+		return iommu_iova_to_phys(iommu_domain, dma_addr);
+	return dma_addr;
+}
+
+#endif /* OTX2_TXRX_H */
-- 
2.7.4

