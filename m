Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32092148D35
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 18:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390892AbgAXRqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 12:46:36 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38029 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390583AbgAXRqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 12:46:36 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so1466518pfc.5
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 09:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DI55oXYMsb9xRiQPEOr3CAW/CsmguG2EFhsx4VLw3mo=;
        b=Ru4wo4l57K/4spPw2mKoviH4x8yzf0zHvwREfZEEIvz5kNgOaKGiJ570ZSi0F68U/R
         zwxYQrKVgUWkSfDOD5p/pk3zs6KR8m/NW+leCO2Xi1kz8T1Lo0LcyAne3nZKb0tTfypK
         ZIUoh6Xq8K4cjSETcZFGY2Htwm4L8VWjMKN8GOghqm/8OreP4ezgwuOzu1S5ELZQ4StG
         VHfFWk67NaaTExQ7qyWcxjvdCRqOMR2ZsKVV+Yy7fJaTmbgnWLpm0x5gs+IXAvIHT3kj
         0rmcOrbPo9wtWj1kI0hERFg7hBRRar9dRZ0ltFuymkB9bQNWu3neFzXNs8srU22247Xb
         HR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DI55oXYMsb9xRiQPEOr3CAW/CsmguG2EFhsx4VLw3mo=;
        b=p6Qxtn7EB0yE7i1Uw/Cwb3Gyp/48idLg8EKm8C0yPIyFF32O6VlY/Sq+hH9B4tEg68
         G8U2PRW2P3sDPezg9f1t3jy87PlaTasmbXdCCdN1RtgB75cljEp2g1dmyVVYZn/9BUjP
         fBwNJAJie+OG9yOcHh22Qo2RcVoxJL/p0zD0IJ3rXCYqyT40QlfC4TrhOG5+CWr+Ag6w
         9RDRc6n7QOyyYEa3IbxkjOGPaK8d8I3/cPocvemBpFogjy6ctJv+dQWbTX9hXrVjM+u2
         /Tm3dg4sRqLIMg+Mz9am0Wsww3N5olsratplNXn6PoCWF9aNpOEPIdv73d7mhUHCNVXb
         RUfA==
X-Gm-Message-State: APjAAAWlH63bzIj+0SPGt/U+fSF2bMwdm2AbYEYYYT538aKSFIxWl9mF
        LRi/e4wltV0As7sInLNeackeHtYtzkY=
X-Google-Smtp-Source: APXvYqxZIy7/OR9l1jrFQbuex2AdpXL4o4HwUboZoPaxd1FfVx1dZbTslA7KFE87iWdeGGyw/bSgmg==
X-Received: by 2002:a62:5343:: with SMTP id h64mr4105326pfb.171.1579887994916;
        Fri, 24 Jan 2020 09:46:34 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm7310849pgs.60.2020.01.24.09.46.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 Jan 2020 09:46:34 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Geetha sowjanya <gakula@marvell.com>,
        Aleksey Makarov <amakarov@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v5 10/17] octeontx2-pf: Error handling support
Date:   Fri, 24 Jan 2020 23:15:48 +0530
Message-Id: <1579887955-22172-11-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579887955-22172-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

HW reports many errors on the receive and transmit paths.
Such as incorrect queue configuration, pkt transmission errors,
LMTST instruction errors, transmit queue full etc. These are reported
via QINT interrupt. Most of the errors are fatal and needs
reinitialization.

Also added support to allocate receive buffers in non-atomic context
when allocation fails in NAPI context.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  63 ++++++++++
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |  13 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   | 133 ++++++++++++++++++++-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |  28 +++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  20 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |   1 +
 6 files changed, 255 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 836b3c8..2b50306 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -154,6 +154,13 @@ dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
 	return iova;
 }
 
+void otx2_tx_timeout(struct net_device *netdev, unsigned int txq)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	schedule_work(&pfvf->reset_task);
+}
+
 void otx2_get_mac_from_af(struct net_device *netdev)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
@@ -362,6 +369,7 @@ static int otx2_rq_init(struct otx2_nic *pfvf, u16 qidx, u16 lpb_aura)
 	aq->rq.lpb_sizem1 = (DMA_BUFFER_LEN(pfvf->rbsize) / 8) - 1;
 	aq->rq.xqe_imm_size = 0; /* Copying of packet to CQE not needed */
 	aq->rq.flow_tagw = 32; /* Copy full 32bit flow_tag to CQE header */
+	aq->rq.qint_idx = 0;
 	aq->rq.lpb_drop_ena = 1; /* Enable RED dropping for AURA */
 	aq->rq.xqe_drop_ena = 1; /* Enable RED dropping for CQ/SSO */
 	aq->rq.xqe_pass = RQ_PASS_LVL_CQ(pfvf->hw.rq_skid, qset->rqe_cnt);
@@ -424,6 +432,8 @@ static int otx2_sq_init(struct otx2_nic *pfvf, u16 qidx, u16 sqb_aura)
 	aq->sq.default_chan = pfvf->hw.tx_chan_base;
 	aq->sq.sqe_stype = NIX_STYPE_STF; /* Cache SQB */
 	aq->sq.sqb_aura = sqb_aura;
+	aq->sq.sq_int_ena = NIX_SQINT_BITS;
+	aq->sq.qint_idx = 0;
 	/* Due pipelining impact minimum 2000 unused SQ CQE's
 	 * need to maintain to avoid CQ overflow.
 	 */
@@ -470,6 +480,7 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	pool_id = ((cq->cq_type == CQ_RX) &&
 		   (pfvf->hw.rqpool_cnt != pfvf->hw.rx_queues)) ? 0 : qidx;
 	cq->rbpool = &qset->pool[pool_id];
+	cq->refill_task_sched = false;
 
 	/* Get memory to put this msg */
 	aq = otx2_mbox_alloc_msg_nix_aq_enq(&pfvf->mbox);
@@ -481,6 +492,8 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	aq->cq.caching = 1;
 	aq->cq.base = cq->cqe->iova;
 	aq->cq.cint_idx = cq->cint_idx;
+	aq->cq.cq_err_int_ena = NIX_CQERRINT_BITS;
+	aq->cq.qint_idx = 0;
 	aq->cq.avg_level = 255;
 
 	if (qidx < pfvf->hw.rx_queues) {
@@ -496,6 +509,45 @@ static int otx2_cq_init(struct otx2_nic *pfvf, u16 qidx)
 	return otx2_sync_mbox_msg(&pfvf->mbox);
 }
 
+static void otx2_pool_refill_task(struct work_struct *work)
+{
+	struct otx2_cq_queue *cq;
+	struct otx2_pool *rbpool;
+	struct refill_work *wrk;
+	int qidx, free_ptrs = 0;
+	struct otx2_nic *pfvf;
+	s64 bufptr;
+
+	wrk = container_of(work, struct refill_work, pool_refill_work.work);
+	pfvf = wrk->pf;
+	qidx = wrk - pfvf->refill_wrk;
+	cq = &pfvf->qset.cq[qidx];
+	rbpool = cq->rbpool;
+	free_ptrs = cq->pool_ptrs;
+
+	while (cq->pool_ptrs) {
+		bufptr = otx2_alloc_rbuf(pfvf, rbpool, GFP_KERNEL);
+		if (bufptr <= 0) {
+			/* Schedule a WQ if we fails to free atleast half of the
+			 * pointers else enable napi for this RQ.
+			 */
+			if (!((free_ptrs - cq->pool_ptrs) > free_ptrs / 2)) {
+				struct delayed_work *dwork;
+
+				dwork = &wrk->pool_refill_work;
+				schedule_delayed_work(dwork,
+						      msecs_to_jiffies(100));
+			} else {
+				cq->refill_task_sched = false;
+			}
+			return;
+		}
+		otx2_aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
+		cq->pool_ptrs--;
+	}
+	cq->refill_task_sched = false;
+}
+
 int otx2_config_nix_queues(struct otx2_nic *pfvf)
 {
 	int qidx, err;
@@ -525,6 +577,17 @@ int otx2_config_nix_queues(struct otx2_nic *pfvf)
 			return err;
 	}
 
+	/* Initialize work queue for receive buffer refill */
+	pfvf->refill_wrk = devm_kcalloc(pfvf->dev, pfvf->qset.cq_cnt,
+					sizeof(struct refill_work), GFP_KERNEL);
+	if (!pfvf->refill_wrk)
+		return -ENOMEM;
+
+	for (qidx = 0; qidx < pfvf->qset.cq_cnt; qidx++) {
+		pfvf->refill_wrk[qidx].pf = pfvf;
+		INIT_DELAYED_WORK(&pfvf->refill_wrk[qidx].pool_refill_work,
+				  otx2_pool_refill_task);
+	}
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index c13001c..762c1ce 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -129,6 +129,11 @@ struct otx2_hw {
 	struct otx2_drv_stats	drv_stats;
 };
 
+struct refill_work {
+	struct delayed_work pool_refill_work;
+	struct otx2_nic *pf;
+};
+
 struct otx2_nic {
 	void __iomem		*reg_base;
 	struct net_device	*netdev;
@@ -151,6 +156,10 @@ struct otx2_nic {
 	u16			pcifunc; /* RVU PF_FUNC */
 	struct cgx_link_user_info linfo;
 
+	u64			reset_count;
+	struct work_struct	reset_task;
+	struct refill_work	*refill_wrk;
+
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
 };
@@ -435,6 +444,9 @@ otx2_mbox_up_handler_ ## _fn_name(struct otx2_nic *pfvf,		\
 MBOX_UP_CGX_MESSAGES
 #undef M
 
+/* Time to wait before watchdog kicks off */
+#define OTX2_TX_TIMEOUT		(100 * HZ)
+
 #define	RVU_PFVF_PF_SHIFT	10
 #define	RVU_PFVF_PF_MASK	0x3F
 #define	RVU_PFVF_FUNC_SHIFT	0
@@ -472,6 +484,7 @@ void otx2_free_cints(struct otx2_nic *pfvf, int n);
 void otx2_set_cints_affinity(struct otx2_nic *pfvf);
 int otx2_set_mac_address(struct net_device *netdev, void *p);
 int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu);
+void otx2_tx_timeout(struct net_device *netdev, unsigned int txq);
 void otx2_get_mac_from_af(struct net_device *netdev);
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 60a67b9..171bab0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -478,6 +478,85 @@ static int otx2_set_real_num_queues(struct net_device *netdev,
 	return err;
 }
 
+static irqreturn_t otx2_q_intr_handler(int irq, void *data)
+{
+	struct otx2_nic *pf = data;
+	u64 val, *ptr;
+	u64 qidx = 0;
+
+	/* CQ */
+	for (qidx = 0; qidx < pf->qset.cq_cnt; qidx++) {
+		ptr = otx2_get_regaddr(pf, NIX_LF_CQ_OP_INT);
+		val = otx2_atomic64_add((qidx << 44), ptr);
+
+		otx2_write64(pf, NIX_LF_CQ_OP_INT, (qidx << 44) |
+			     (val & NIX_CQERRINT_BITS));
+		if (!(val & (NIX_CQERRINT_BITS | BIT_ULL(42))))
+			continue;
+
+		if (val & BIT_ULL(42)) {
+			netdev_err(pf->netdev, "CQ%lld: error reading NIX_LF_CQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
+				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
+		} else {
+			if (val & BIT_ULL(NIX_CQERRINT_DOOR_ERR))
+				netdev_err(pf->netdev, "CQ%lld: Doorbell error",
+					   qidx);
+			if (val & BIT_ULL(NIX_CQERRINT_CQE_FAULT))
+				netdev_err(pf->netdev, "CQ%lld: Memory fault on CQE write to LLC/DRAM",
+					   qidx);
+		}
+
+		schedule_work(&pf->reset_task);
+	}
+
+	/* SQ */
+	for (qidx = 0; qidx < pf->hw.tx_queues; qidx++) {
+		ptr = otx2_get_regaddr(pf, NIX_LF_SQ_OP_INT);
+		val = otx2_atomic64_add((qidx << 44), ptr);
+		otx2_write64(pf, NIX_LF_SQ_OP_INT, (qidx << 44) |
+			     (val & NIX_SQINT_BITS));
+
+		if (!(val & (NIX_SQINT_BITS | BIT_ULL(42))))
+			continue;
+
+		if (val & BIT_ULL(42)) {
+			netdev_err(pf->netdev, "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
+				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
+		} else {
+			if (val & BIT_ULL(NIX_SQINT_LMT_ERR)) {
+				netdev_err(pf->netdev, "SQ%lld: LMT store error NIX_LF_SQ_OP_ERR_DBG:0x%llx",
+					   qidx,
+					   otx2_read64(pf,
+						       NIX_LF_SQ_OP_ERR_DBG));
+				otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG,
+					     BIT_ULL(44));
+			}
+			if (val & BIT_ULL(NIX_SQINT_MNQ_ERR)) {
+				netdev_err(pf->netdev, "SQ%lld: Meta-descriptor enqueue error NIX_LF_MNQ_ERR_DGB:0x%llx\n",
+					   qidx,
+					   otx2_read64(pf, NIX_LF_MNQ_ERR_DBG));
+				otx2_write64(pf, NIX_LF_MNQ_ERR_DBG,
+					     BIT_ULL(44));
+			}
+			if (val & BIT_ULL(NIX_SQINT_SEND_ERR)) {
+				netdev_err(pf->netdev, "SQ%lld: Send error, NIX_LF_SEND_ERR_DBG 0x%llx",
+					   qidx,
+					   otx2_read64(pf,
+						       NIX_LF_SEND_ERR_DBG));
+				otx2_write64(pf, NIX_LF_SEND_ERR_DBG,
+					     BIT_ULL(44));
+			}
+			if (val & BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
+				netdev_err(pf->netdev, "SQ%lld: SQB allocation failed",
+					   qidx);
+		}
+
+		schedule_work(&pf->reset_task);
+	}
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t otx2_cq_intr_handler(int irq, void *cq_irq)
 {
 	struct otx2_cq_poll *cq_poll = (struct otx2_cq_poll *)cq_irq;
@@ -759,6 +838,24 @@ int otx2_open(struct net_device *netdev)
 	if (err)
 		goto err_disable_napi;
 
+	/* Register Queue IRQ handlers */
+	vec = pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START;
+	irq_name = &pf->hw.irq_name[vec * NAME_SIZE];
+
+	snprintf(irq_name, NAME_SIZE, "%s-qerr", pf->netdev->name);
+
+	err = request_irq(pci_irq_vector(pf->pdev, vec),
+			  otx2_q_intr_handler, 0, irq_name, pf);
+	if (err) {
+		dev_err(pf->dev,
+			"RVUPF%d: IRQ registration failed for QERR\n",
+			rvu_get_pf(pf->pcifunc));
+		goto err_disable_napi;
+	}
+
+	/* Enable QINT IRQ */
+	otx2_write64(pf, NIX_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
+
 	/* Register CQ IRQ handlers */
 	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
 	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
@@ -803,6 +900,11 @@ int otx2_open(struct net_device *netdev)
 
 err_free_cints:
 	otx2_free_cints(pf, qidx);
+	vec = pci_irq_vector(pf->pdev,
+			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
+	otx2_write64(pf, NIX_LF_QINTX_ENA_W1C(0), BIT_ULL(0));
+	synchronize_irq(vec);
+	free_irq(vec, pf);
 err_disable_napi:
 	otx2_disable_napi(pf);
 	otx2_free_hw_resources(pf);
@@ -818,7 +920,7 @@ int otx2_stop(struct net_device *netdev)
 	struct otx2_nic *pf = netdev_priv(netdev);
 	struct otx2_cq_poll *cq_poll = NULL;
 	struct otx2_qset *qset = &pf->qset;
-	int qidx, vec;
+	int qidx, vec, wrk;
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
@@ -830,6 +932,13 @@ int otx2_stop(struct net_device *netdev)
 	/* First stop packet Rx/Tx */
 	otx2_rxtx_enable(pf, false);
 
+	/* Cleanup Queue IRQ */
+	vec = pci_irq_vector(pf->pdev,
+			     pf->hw.nix_msixoff + NIX_LF_QINT_VEC_START);
+	otx2_write64(pf, NIX_LF_QINTX_ENA_W1C(0), BIT_ULL(0));
+	synchronize_irq(vec);
+	free_irq(vec, pf);
+
 	/* Cleanup CQ NAPI and IRQ */
 	vec = pf->hw.nix_msixoff + NIX_LF_CINT_VEC_START;
 	for (qidx = 0; qidx < pf->hw.cint_cnt; qidx++) {
@@ -852,6 +961,10 @@ int otx2_stop(struct net_device *netdev)
 	for (qidx = 0; qidx < netdev->num_tx_queues; qidx++)
 		netdev_tx_reset_queue(netdev_get_tx_queue(netdev, qidx));
 
+	for (wrk = 0; wrk < pf->qset.cq_cnt; wrk++)
+		cancel_delayed_work_sync(&pf->refill_wrk[wrk].pool_refill_work);
+	devm_kfree(pf->dev, pf->refill_wrk);
+
 	kfree(qset->sq);
 	kfree(qset->cq);
 	kfree(qset->napi);
@@ -931,6 +1044,19 @@ static int otx2_set_features(struct net_device *netdev,
 	return 0;
 }
 
+static void otx2_reset_task(struct work_struct *work)
+{
+	struct otx2_nic *pf = container_of(work, struct otx2_nic, reset_task);
+
+	if (!netif_running(pf->netdev))
+		return;
+
+	otx2_stop(pf->netdev);
+	pf->reset_count++;
+	otx2_open(pf->netdev);
+	netif_trans_update(pf->netdev);
+}
+
 static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_open		= otx2_open,
 	.ndo_stop		= otx2_stop,
@@ -939,6 +1065,7 @@ static const struct net_device_ops otx2_netdev_ops = {
 	.ndo_change_mtu		= otx2_change_mtu,
 	.ndo_set_rx_mode	= otx2_set_rx_mode,
 	.ndo_set_features	= otx2_set_features,
+	.ndo_tx_timeout		= otx2_tx_timeout,
 };
 
 static int otx2_check_pf_usable(struct otx2_nic *nic)
@@ -1115,12 +1242,16 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
 
+	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
+
 	netdev->netdev_ops = &otx2_netdev_ops;
 
 	/* MTU range: 64 - 9190 */
 	netdev->min_mtu = OTX2_MIN_MTU;
 	netdev->max_mtu = OTX2_MAX_MTU;
 
+	INIT_WORK(&pf->reset_task, otx2_reset_task);
+
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(dev, "Failed to register netdevice\n");
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
index 04a9f12..cba59ddf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_struct.h
@@ -245,4 +245,32 @@ struct nix_sqe_mem_s {
 	u64 addr; /* W1 */
 };
 
+enum nix_cqerrint_e {
+	NIX_CQERRINT_DOOR_ERR = 0,
+	NIX_CQERRINT_WR_FULL = 1,
+	NIX_CQERRINT_CQE_FAULT = 2,
+};
+
+#define NIX_CQERRINT_BITS (BIT_ULL(NIX_CQERRINT_DOOR_ERR) | \
+			   BIT_ULL(NIX_CQERRINT_CQE_FAULT))
+
+enum nix_rqint_e {
+	NIX_RQINT_DROP = 0,
+	NIX_RQINT_RED = 1,
+};
+
+#define NIX_RQINT_BITS (BIT_ULL(NIX_RQINT_DROP) | BIT_ULL(NIX_RQINT_RED))
+
+enum nix_sqint_e {
+	NIX_SQINT_LMT_ERR = 0,
+	NIX_SQINT_MNQ_ERR = 1,
+	NIX_SQINT_SEND_ERR = 2,
+	NIX_SQINT_SQB_ALLOC_FAIL = 3,
+};
+
+#define NIX_SQINT_BITS (BIT_ULL(NIX_SQINT_LMT_ERR) | \
+			BIT_ULL(NIX_SQINT_MNQ_ERR) | \
+			BIT_ULL(NIX_SQINT_SEND_ERR) | \
+			BIT_ULL(NIX_SQINT_SQB_ALLOC_FAIL))
+
 #endif /* OTX2_STRUCT_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 87b579a..94dac84 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -237,12 +237,23 @@ static int otx2_rx_napi_handler(struct otx2_nic *pfvf,
 	/* Refill pool with new buffers */
 	while (cq->pool_ptrs) {
 		bufptr = otx2_alloc_rbuf(pfvf, cq->rbpool, GFP_ATOMIC);
-		if (unlikely(bufptr <= 0))
+		if (unlikely(bufptr <= 0)) {
+			struct refill_work *work;
+			struct delayed_work *dwork;
+
+			work = &pfvf->refill_wrk[cq->cq_idx];
+			dwork = &work->pool_refill_work;
+			/* Schedule a task if no other task is running */
+			if (!cq->refill_task_sched) {
+				cq->refill_task_sched = true;
+				schedule_delayed_work(dwork,
+						      msecs_to_jiffies(100));
+			}
 			break;
+		}
 		otx2_aura_freeptr(pfvf, cq->cq_idx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
-	otx2_get_page(cq->rbpool);
 
 	return processed_cqe;
 }
@@ -304,6 +315,11 @@ int otx2_napi_handler(struct napi_struct *napi, int budget)
 			continue;
 		cq = &qset->cq[cq_idx];
 		if (cq->cq_type == CQ_RX) {
+			/* If the RQ refill WQ task is running, skip napi
+			 * scheduler for this queue.
+			 */
+			if (cq->refill_task_sched)
+				continue;
 			workdone += otx2_rx_napi_handler(pfvf, napi,
 							 cq, budget);
 		} else {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index bad2259..a889b49 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -112,6 +112,7 @@ struct otx2_cq_queue {
 	u8			cq_idx;
 	u8			cq_type;
 	u8			cint_idx; /* CQ interrupt id */
+	u8			refill_task_sched;
 	u16			cqe_size;
 	u16			pool_ptrs;
 	u32			cqe_cnt;
-- 
2.7.4

