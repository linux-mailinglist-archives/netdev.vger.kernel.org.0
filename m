Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9519350FA4
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 08:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233482AbhDAG5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 02:57:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233351AbhDAG5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 02:57:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9A9861057;
        Thu,  1 Apr 2021 06:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617260250;
        bh=5Y/aFjmo9XWqmsBR1kgXS9WcD2apHtF8QEnNjTHShr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVbGrGb/KyQp47ukzPZqGH+rll2rqjeZnWXLCsx9uSu0MyB6Im7KbOc1POwA1GM1C
         NqVLdbIkvbZYI4/sK5461f3o20UC4G3jOCpS0QhQSSUqeIkQb+E0NSwnKR+1+E5xHN
         go3Y/hhEpqduF5A7mQ7CvSh8akc3+ykUwlp29+qEaJtECLXI21PsHh1G2k+1ZXtTqe
         P+UYV1pBmVk2upicSzIVypWBNzZzt2bFx/iem2bHlzgPeUQWYeLWZgF1dEVcpmK5uU
         YRg7DLBn5c7Nu1d0oyOgYRjKTM/IRvLA6Ps0muCPVbI1CPXlIiSCsw20QSYIeGLofM
         SNguScA2oH8HA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: [PATCH rdma-next v2 4/5] net/bnxt: Remove useless check of non-existent ULP id
Date:   Thu,  1 Apr 2021 09:57:14 +0300
Message-Id: <20210401065715.565226-5-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401065715.565226-1-leon@kernel.org>
References: <20210401065715.565226-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no other bnxt ULP driver in the upstream and all checks
for the ULP id are useless, so remove them and convert double array
table to proper pointer structure.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 189 +++++++-----------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   6 +-
 2 files changed, 73 insertions(+), 122 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index a918e374f3c5..f7af900afaed 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -29,34 +29,26 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
+	unsigned int max_stat_ctxs;
 	struct bnxt_ulp *ulp;
 
 	ASSERT_RTNL();
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
 
-	ulp = &edev->ulp_tbl[ulp_id];
-	if (rcu_access_pointer(ulp->ulp_ops)) {
-		netdev_err(bp->dev, "ulp id %d already registered\n", ulp_id);
-		return -EBUSY;
-	}
-	if (ulp_id == BNXT_ROCE_ULP) {
-		unsigned int max_stat_ctxs;
+	max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
+	if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
+	    bp->cp_nr_rings == max_stat_ctxs)
+		return -ENOMEM;
 
-		max_stat_ctxs = bnxt_get_max_func_stat_ctxs(bp);
-		if (max_stat_ctxs <= BNXT_MIN_ROCE_STAT_CTXS ||
-		    bp->cp_nr_rings == max_stat_ctxs)
-			return -ENOMEM;
-	}
+	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
+	if (!ulp)
+		return -ENOMEM;
 
-	atomic_set(&ulp->ref_count, 0);
+	edev->ulp_tbl = ulp;
 	ulp->handle = handle;
 	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
 
-	if (ulp_id == BNXT_ROCE_ULP) {
-		if (test_bit(BNXT_STATE_OPEN, &bp->state))
-			bnxt_hwrm_vnic_cfg(bp, 0);
-	}
+	if (test_bit(BNXT_STATE_OPEN, &bp->state))
+		bnxt_hwrm_vnic_cfg(bp, 0);
 
 	return 0;
 }
@@ -69,15 +61,9 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 	int i = 0;
 
 	ASSERT_RTNL();
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
 
-	ulp = &edev->ulp_tbl[ulp_id];
-	if (!rcu_access_pointer(ulp->ulp_ops)) {
-		netdev_err(bp->dev, "ulp id %d not registered\n", ulp_id);
-		return -EINVAL;
-	}
-	if (ulp_id == BNXT_ROCE_ULP && ulp->msix_requested)
+	ulp = edev->ulp_tbl;
+	if (ulp->msix_requested)
 		edev->en_ops->bnxt_free_msix(edev, ulp_id);
 
 	if (ulp->max_async_event_id)
@@ -91,6 +77,8 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 		msleep(100);
 		i++;
 	}
+	kfree(ulp);
+	edev->ulp_tbl = NULL;
 	return 0;
 }
 
@@ -99,8 +87,8 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	struct bnxt_en_dev *edev = bp->edev;
 	int num_msix, idx, i;
 
-	num_msix = edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested;
-	idx = edev->ulp_tbl[BNXT_ROCE_ULP].msix_base;
+	num_msix = edev->ulp_tbl->msix_requested;
+	idx = edev->ulp_tbl->msix_base;
 	for (i = 0; i < num_msix; i++) {
 		ent[i].vector = bp->irq_tbl[idx + i].vector;
 		ent[i].ring_idx = idx + i;
@@ -126,13 +114,11 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	int rc = 0;
 
 	ASSERT_RTNL();
-	if (ulp_id != BNXT_ROCE_ULP)
-		return -EINVAL;
 
 	if (!(bp->flags & BNXT_FLAG_USING_MSIX))
 		return -ENODEV;
 
-	if (edev->ulp_tbl[ulp_id].msix_requested)
+	if (edev->ulp_tbl->msix_requested)
 		return -EAGAIN;
 
 	max_cp_rings = bnxt_get_max_func_cp_rings(bp);
@@ -148,8 +134,8 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 		max_idx = min_t(int, bp->total_irqs, max_cp_rings);
 		idx = max_idx - avail_msix;
 	}
-	edev->ulp_tbl[ulp_id].msix_base = idx;
-	edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
+	edev->ulp_tbl->msix_base = idx;
+	edev->ulp_tbl->msix_requested = avail_msix;
 	hw_resc = &bp->hw_resc;
 	total_vecs = idx + avail_msix;
 	if (bp->total_irqs < total_vecs ||
@@ -162,7 +148,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 		}
 	}
 	if (rc) {
-		edev->ulp_tbl[ulp_id].msix_requested = 0;
+		edev->ulp_tbl->msix_requested = 0;
 		return -EAGAIN;
 	}
 
@@ -171,7 +157,7 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 
 		resv_msix = hw_resc->resv_irqs - bp->cp_nr_rings;
 		avail_msix = min_t(int, resv_msix, avail_msix);
-		edev->ulp_tbl[ulp_id].msix_requested = avail_msix;
+		edev->ulp_tbl->msix_requested = avail_msix;
 	}
 	bnxt_fill_msix_vecs(bp, ent);
 	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
@@ -184,13 +170,11 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
 	struct bnxt *bp = netdev_priv(dev);
 
 	ASSERT_RTNL();
-	if (ulp_id != BNXT_ROCE_ULP)
-		return -EINVAL;
 
 	if (!(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return 0;
 
-	edev->ulp_tbl[ulp_id].msix_requested = 0;
+	edev->ulp_tbl->msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
 	if (netif_running(dev) && !(edev->flags & BNXT_EN_FLAG_ULP_STOPPED)) {
 		bnxt_close_nic(bp, true, false);
@@ -204,7 +188,7 @@ int bnxt_get_ulp_msix_num(struct bnxt *bp)
 	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		return edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested;
+		return edev->ulp_tbl->msix_requested;
 	}
 	return 0;
 }
@@ -214,8 +198,8 @@ int bnxt_get_ulp_msix_base(struct bnxt *bp)
 	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
-			return edev->ulp_tbl[BNXT_ROCE_ULP].msix_base;
+		if (edev->ulp_tbl->msix_requested)
+			return edev->ulp_tbl->msix_base;
 	}
 	return 0;
 }
@@ -225,7 +209,7 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
-		if (edev->ulp_tbl[BNXT_ROCE_ULP].msix_requested)
+		if (edev->ulp_tbl->msix_requested)
 			return BNXT_MIN_ROCE_STAT_CTXS;
 	}
 
@@ -240,9 +224,6 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 	struct input *req;
 	int rc;
 
-	if (ulp_id != BNXT_ROCE_ULP && bp->fw_reset_state)
-		return -EBUSY;
-
 	mutex_lock(&bp->hwrm_cmd_lock);
 	req = fw_msg->msg;
 	req->resp_addr = cpu_to_le64(bp->hwrm_cmd_resp_dma_addr);
@@ -275,27 +256,25 @@ void bnxt_ulp_stop(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
 	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
+	ulp = edev->ulp_tbl;
 
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_stop)
-			continue;
-		ops->ulp_stop(ulp->handle);
-	}
+	ops = rtnl_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_stop)
+		return;
+	ops->ulp_stop(ulp->handle);
 }
 
 void bnxt_ulp_start(struct bnxt *bp, int err)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
@@ -305,58 +284,53 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 	if (err)
 		return;
 
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
+	ulp = edev->ulp_tbl;
 
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_start)
-			continue;
-		ops->ulp_start(ulp->handle);
-	}
+	ops = rtnl_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_start)
+		return;
+	ops->ulp_start(ulp->handle);
 }
 
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
+	ulp = edev->ulp_tbl;
 
-		rcu_read_lock();
-		ops = rcu_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_sriov_config) {
-			rcu_read_unlock();
-			continue;
-		}
-		bnxt_ulp_get(ulp);
+	rcu_read_lock();
+	ops = rcu_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_sriov_config) {
 		rcu_read_unlock();
-		ops->ulp_sriov_config(ulp->handle, num_vfs);
-		bnxt_ulp_put(ulp);
+		return;
 	}
+	bnxt_ulp_get(ulp);
+	rcu_read_unlock();
+	ops->ulp_sriov_config(ulp->handle, num_vfs);
+	bnxt_ulp_put(ulp);
 }
 
 void bnxt_ulp_shutdown(struct bnxt *bp)
 {
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
+	ulp = edev->ulp_tbl;
 
-		ops = rtnl_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_shutdown)
-			continue;
-		ops->ulp_shutdown(ulp->handle);
-	}
+	ops = rtnl_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_shutdown)
+		return;
+
+	ops->ulp_shutdown(ulp->handle);
 }
 
 void bnxt_ulp_irq_stop(struct bnxt *bp)
@@ -368,7 +342,7 @@ void bnxt_ulp_irq_stop(struct bnxt *bp)
 		return;
 
 	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[BNXT_ROCE_ULP];
+		struct bnxt_ulp *ulp = edev->ulp_tbl;
 
 		if (!ulp->msix_requested)
 			return;
@@ -389,7 +363,7 @@ void bnxt_ulp_irq_restart(struct bnxt *bp, int err)
 		return;
 
 	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[BNXT_ROCE_ULP];
+		struct bnxt_ulp *ulp = edev->ulp_tbl;
 		struct bnxt_msix_entry *ent = NULL;
 
 		if (!ulp->msix_requested)
@@ -416,47 +390,27 @@ void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl)
 	u16 event_id = le16_to_cpu(cmpl->event_id);
 	struct bnxt_en_dev *edev = bp->edev;
 	struct bnxt_ulp_ops *ops;
-	int i;
+	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
 	rcu_read_lock();
-	for (i = 0; i < BNXT_MAX_ULP; i++) {
-		struct bnxt_ulp *ulp = &edev->ulp_tbl[i];
-
-		ops = rcu_dereference(ulp->ulp_ops);
-		if (!ops || !ops->ulp_async_notifier)
-			continue;
-		if (!ulp->async_events_bmap ||
-		    event_id > ulp->max_async_event_id)
-			continue;
-
-		/* Read max_async_event_id first before testing the bitmap. */
-		smp_rmb();
-		if (test_bit(event_id, ulp->async_events_bmap))
-			ops->ulp_async_notifier(ulp->handle, cmpl);
-	}
-	rcu_read_unlock();
-}
+	ulp = edev->ulp_tbl;
 
-static int bnxt_register_async_events(struct bnxt_en_dev *edev, int ulp_id,
-				      unsigned long *events_bmap, u16 max_id)
-{
-	struct net_device *dev = edev->net;
-	struct bnxt *bp = netdev_priv(dev);
-	struct bnxt_ulp *ulp;
+	ops = rcu_dereference(ulp->ulp_ops);
+	if (!ops || !ops->ulp_async_notifier)
+		goto out;
+	if (!ulp->async_events_bmap || event_id > ulp->max_async_event_id)
+		goto out;
 
-	if (ulp_id >= BNXT_MAX_ULP)
-		return -EINVAL;
+	/* Read max_async_event_id first before testing the bitmap. */
+	smp_rmb();
+	if (test_bit(event_id, ulp->async_events_bmap))
+		ops->ulp_async_notifier(ulp->handle, cmpl);
 
-	ulp = &edev->ulp_tbl[ulp_id];
-	ulp->async_events_bmap = events_bmap;
-	/* Make sure bnxt_ulp_async_events() sees this order */
-	smp_wmb();
-	ulp->max_async_event_id = max_id;
-	bnxt_hwrm_func_drv_rgtr(bp, events_bmap, max_id + 1, true);
-	return 0;
+out:
+	rcu_read_unlock();
 }
 
 static const struct bnxt_en_ops bnxt_en_ops_tbl = {
@@ -465,7 +419,6 @@ static const struct bnxt_en_ops bnxt_en_ops_tbl = {
 	.bnxt_request_msix	= bnxt_req_msix_vecs,
 	.bnxt_free_msix		= bnxt_free_msix_vecs,
 	.bnxt_send_fw_msg	= bnxt_send_msg,
-	.bnxt_register_fw_async_events	= bnxt_register_async_events,
 };
 
 struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 6b4d2556a6df..3caee7c2f8c9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -66,7 +66,7 @@ struct bnxt_en_dev {
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
 	const struct bnxt_en_ops	*en_ops;
-	struct bnxt_ulp			ulp_tbl[BNXT_MAX_ULP];
+	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
 							 * driver.
@@ -86,13 +86,11 @@ struct bnxt_en_ops {
 	int (*bnxt_free_msix)(struct bnxt_en_dev *, int);
 	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *, int,
 				struct bnxt_fw_msg *);
-	int (*bnxt_register_fw_async_events)(struct bnxt_en_dev *, int,
-					     unsigned long *, u16);
 };
 
 static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev, int ulp_id)
 {
-	if (edev && rcu_access_pointer(edev->ulp_tbl[ulp_id].ulp_ops))
+	if (edev && edev->ulp_tbl)
 		return true;
 	return false;
 }
-- 
2.30.2

