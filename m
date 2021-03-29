Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2F34CC0E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhC2IzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236039AbhC2Iwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 04:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A64D60234;
        Mon, 29 Mar 2021 08:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617007955;
        bh=Z5OKzme76ghaNaepRIQFE57KWlPU7Rs31k/32j5e6d0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXCKKQ52LBdTIJO9rwCThaYJRAT7ufx+gxMae8I0FycSTwNg4cQMqSQoDucsCXRmZ
         WC7HX3DNjOivJOJ8R8sF/8QvnXLZQeTQjb25Iu307xe3185PYfO+CtJFgX7DYGLlKK
         D/PdVB6h5qnJSL/K+6chzORcqzemdT3Cyn6QRT3Q7xO9J8zuc4+hrvk1ZYQrGv19kE
         k8hvMVSpv5L7hXFx54NLUic3ltTlWASh51VA1FZDssTJSAZhuMoJscbdugH4sIbrSU
         XbTgsUNUgEgFFyihWyhdx0ua3tJrlfgDBIzQPVNN1LgCNmT3fK1mZW0rq0FfAnhxi2
         12ENWJvFQQmBA==
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
Subject: [PATCH rdma-next v1 5/5] net/bnxt: Use direct API instead of useless indirection
Date:   Mon, 29 Mar 2021 11:52:12 +0300
Message-Id: <20210329085212.257771-6-leon@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085212.257771-1-leon@kernel.org>
References: <20210329085212.257771-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

There is no need in any indirection complexity for one ULP user,
remove all this complexity in favour of direct calls to the exported
symbols. This allows us to greatly simplify the code.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 70 ++++---------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 70 +++++++------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 26 +++----
 4 files changed, 50 insertions(+), 118 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 8bfbf0231a9e..b3f8fe8314a8 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -351,24 +351,6 @@ static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
 
 /* RoCE -> Net driver */
 
-/* Driver registration routines used to let the networking driver (bnxt_en)
- * to know that the RoCE driver is now installed
- */
-static int bnxt_re_unregister_netdev(struct bnxt_re_dev *rdev)
-{
-	struct bnxt_en_dev *en_dev;
-	int rc;
-
-	if (!rdev)
-		return -EINVAL;
-
-	en_dev = rdev->en_dev;
-
-	rc = en_dev->en_ops->bnxt_unregister_device(rdev->en_dev,
-						    BNXT_ROCE_ULP);
-	return rc;
-}
-
 static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 {
 	struct bnxt_en_dev *en_dev;
@@ -379,28 +361,11 @@ static int bnxt_re_register_netdev(struct bnxt_re_dev *rdev)
 
 	en_dev = rdev->en_dev;
 
-	rc = en_dev->en_ops->bnxt_register_device(en_dev, BNXT_ROCE_ULP,
-						  &bnxt_re_ulp_ops, rdev);
+	rc = bnxt_register_dev(en_dev, &bnxt_re_ulp_ops, rdev);
 	rdev->qplib_res.pdev = rdev->en_dev->pdev;
 	return rc;
 }
 
-static int bnxt_re_free_msix(struct bnxt_re_dev *rdev)
-{
-	struct bnxt_en_dev *en_dev;
-	int rc;
-
-	if (!rdev)
-		return -EINVAL;
-
-	en_dev = rdev->en_dev;
-
-
-	rc = en_dev->en_ops->bnxt_free_msix(rdev->en_dev, BNXT_ROCE_ULP);
-
-	return rc;
-}
-
 static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 {
 	int rc = 0, num_msix_want = BNXT_RE_MAX_MSIX, num_msix_got;
@@ -413,9 +378,8 @@ static int bnxt_re_request_msix(struct bnxt_re_dev *rdev)
 
 	num_msix_want = min_t(u32, BNXT_RE_MAX_MSIX, num_online_cpus());
 
-	num_msix_got = en_dev->en_ops->bnxt_request_msix(en_dev, BNXT_ROCE_ULP,
-							 rdev->msix_entries,
-							 num_msix_want);
+	num_msix_got =
+		bnxt_req_msix_vecs(en_dev, rdev->msix_entries, num_msix_want);
 	if (num_msix_got < BNXT_RE_MIN_MSIX) {
 		rc = -EINVAL;
 		goto done;
@@ -471,7 +435,7 @@ static int bnxt_re_net_ring_free(struct bnxt_re_dev *rdev,
 	req.ring_id = cpu_to_le16(fw_ring_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW ring:%d :%#x",
 			  req.ring_id, rc);
@@ -508,7 +472,7 @@ static int bnxt_re_net_ring_alloc(struct bnxt_re_dev *rdev,
 	req.int_mode = ring_attr->mode;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_ring_id = le16_to_cpu(resp.ring_id);
 
@@ -535,7 +499,7 @@ static int bnxt_re_net_stats_ctx_free(struct bnxt_re_dev *rdev,
 	req.stat_ctx_id = cpu_to_le32(fw_stats_ctx_id);
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&req,
 			    sizeof(req), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		ibdev_err(&rdev->ibdev, "Failed to free HW stats context %#x",
 			  rc);
@@ -567,7 +531,7 @@ static int bnxt_re_net_stats_ctx_alloc(struct bnxt_re_dev *rdev,
 	req.stat_ctx_flags = STAT_CTX_ALLOC_REQ_STAT_CTX_FLAGS_ROCE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (!rc)
 		*fw_stats_ctx_id = le32_to_cpu(resp.stat_ctx_id);
 
@@ -1119,7 +1083,7 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc)
 		return rc;
 
@@ -1302,7 +1266,7 @@ static void bnxt_re_query_hwrm_intf_version(struct bnxt_re_dev *rdev)
 	req.hwrm_intf_upd = HWRM_VERSION_UPDATE;
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
-	rc = en_dev->en_ops->bnxt_send_fw_msg(en_dev, BNXT_ROCE_ULP, &fw_msg);
+	rc = bnxt_send_msg(en_dev, &fw_msg);
 	if (rc) {
 		ibdev_err(&rdev->ibdev, "Failed to query HW version, rc = 0x%x",
 			  rc);
@@ -1365,20 +1329,12 @@ static void bnxt_re_dev_uninit(struct bnxt_re_dev *rdev)
 		bnxt_re_net_ring_free(rdev, rdev->rcfw.creq.ring_id, type);
 		bnxt_qplib_free_rcfw_channel(&rdev->rcfw);
 	}
-	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags)) {
-		rc = bnxt_re_free_msix(rdev);
-		if (rc)
-			ibdev_warn(&rdev->ibdev,
-				   "Failed to free MSI-X vectors: %#x", rc);
-	}
+	if (test_and_clear_bit(BNXT_RE_FLAG_GOT_MSIX, &rdev->flags))
+		bnxt_free_msix_vecs(rdev->en_dev);
 
 	bnxt_re_destroy_chip_ctx(rdev);
-	if (test_and_clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags)) {
-		rc = bnxt_re_unregister_netdev(rdev);
-		if (rc)
-			ibdev_warn(&rdev->ibdev,
-				   "Failed to unregister with netdev: %#x", rc);
-	}
+	if (test_and_clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags))
+		bnxt_unregister_dev(rdev->en_dev);
 }
 
 /* worker thread for polling periodic events. Now used for QoS programming*/
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 3f0e4bde5dc9..aafee562e782 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5346,7 +5346,7 @@ int bnxt_hwrm_vnic_cfg(struct bnxt *bp, u16 vnic_id)
 #endif
 	if ((bp->flags & BNXT_FLAG_STRIP_VLAN) || def_vlan)
 		req.flags |= cpu_to_le32(VNIC_CFG_REQ_FLAGS_VLAN_STRIP_MODE);
-	if (!vnic_id && bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP))
+	if (!vnic_id && bnxt_ulp_registered(bp->edev))
 		req.flags |= cpu_to_le32(bnxt_get_roce_vnic_mode(bp));
 
 	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index f7af900afaed..6aefb348cf44 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -24,8 +24,8 @@
 #include "bnxt.h"
 #include "bnxt_ulp.h"
 
-static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
-			     struct bnxt_ulp_ops *ulp_ops, void *handle)
+int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
+		      void *handle)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -45,15 +45,16 @@ static int bnxt_register_dev(struct bnxt_en_dev *edev, int ulp_id,
 
 	edev->ulp_tbl = ulp;
 	ulp->handle = handle;
-	rcu_assign_pointer(ulp->ulp_ops, ulp_ops);
+	ulp->ulp_ops = ulp_ops;
 
 	if (test_bit(BNXT_STATE_OPEN, &bp->state))
 		bnxt_hwrm_vnic_cfg(bp, 0);
 
 	return 0;
 }
+EXPORT_SYMBOL(bnxt_register_dev);
 
-static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
+void bnxt_unregister_dev(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -64,13 +65,11 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 
 	ulp = edev->ulp_tbl;
 	if (ulp->msix_requested)
-		edev->en_ops->bnxt_free_msix(edev, ulp_id);
+		bnxt_free_msix_vecs(edev);
 
 	if (ulp->max_async_event_id)
 		bnxt_hwrm_func_drv_rgtr(bp, NULL, 0, true);
 
-	RCU_INIT_POINTER(ulp->ulp_ops, NULL);
-	synchronize_rcu();
 	ulp->max_async_event_id = 0;
 	ulp->async_events_bmap = NULL;
 	while (atomic_read(&ulp->ref_count) != 0 && i < 10) {
@@ -79,8 +78,8 @@ static int bnxt_unregister_dev(struct bnxt_en_dev *edev, int ulp_id)
 	}
 	kfree(ulp);
 	edev->ulp_tbl = NULL;
-	return 0;
 }
+EXPORT_SYMBOL(bnxt_unregister_dev);
 
 static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 {
@@ -102,8 +101,8 @@ static void bnxt_fill_msix_vecs(struct bnxt *bp, struct bnxt_msix_entry *ent)
 	}
 }
 
-static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
-			      struct bnxt_msix_entry *ent, int num_msix)
+int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, struct bnxt_msix_entry *ent,
+		       int num_msix)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -163,8 +162,9 @@ static int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, int ulp_id,
 	edev->flags |= BNXT_EN_FLAG_MSIX_REQUESTED;
 	return avail_msix;
 }
+EXPORT_SYMBOL(bnxt_req_msix_vecs);
 
-static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
+void bnxt_free_msix_vecs(struct bnxt_en_dev *edev)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -172,7 +172,7 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
 	ASSERT_RTNL();
 
 	if (!(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
-		return 0;
+		return;
 
 	edev->ulp_tbl->msix_requested = 0;
 	edev->flags &= ~BNXT_EN_FLAG_MSIX_REQUESTED;
@@ -180,12 +180,12 @@ static int bnxt_free_msix_vecs(struct bnxt_en_dev *edev, int ulp_id)
 		bnxt_close_nic(bp, true, false);
 		bnxt_open_nic(bp, true, false);
 	}
-	return 0;
 }
+EXPORT_SYMBOL(bnxt_free_msix_vecs);
 
 int bnxt_get_ulp_msix_num(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
 		return edev->ulp_tbl->msix_requested;
@@ -195,7 +195,7 @@ int bnxt_get_ulp_msix_num(struct bnxt *bp)
 
 int bnxt_get_ulp_msix_base(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
 		if (edev->ulp_tbl->msix_requested)
@@ -206,7 +206,7 @@ int bnxt_get_ulp_msix_base(struct bnxt *bp)
 
 int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 {
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_en_dev *edev = bp->edev;
 
 		if (edev->ulp_tbl->msix_requested)
@@ -216,8 +216,7 @@ int bnxt_get_ulp_stat_ctxs(struct bnxt *bp)
 	return 0;
 }
 
-static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
-			 struct bnxt_fw_msg *fw_msg)
+int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg)
 {
 	struct net_device *dev = edev->net;
 	struct bnxt *bp = netdev_priv(dev);
@@ -241,6 +240,7 @@ static int bnxt_send_msg(struct bnxt_en_dev *edev, int ulp_id,
 	mutex_unlock(&bp->hwrm_cmd_lock);
 	return rc;
 }
+EXPORT_SYMBOL(bnxt_send_msg);
 
 static void bnxt_ulp_get(struct bnxt_ulp *ulp)
 {
@@ -303,14 +303,11 @@ void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
 
 	ulp = edev->ulp_tbl;
 
-	rcu_read_lock();
-	ops = rcu_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_sriov_config) {
-		rcu_read_unlock();
+	ops = ulp->ulp_ops;
+	if (!ops || !ops->ulp_sriov_config)
 		return;
-	}
+
 	bnxt_ulp_get(ulp);
-	rcu_read_unlock();
 	ops->ulp_sriov_config(ulp->handle, num_vfs);
 	bnxt_ulp_put(ulp);
 }
@@ -341,7 +338,7 @@ void bnxt_ulp_irq_stop(struct bnxt *bp)
 	if (!edev || !(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return;
 
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_ulp *ulp = edev->ulp_tbl;
 
 		if (!ulp->msix_requested)
@@ -362,7 +359,7 @@ void bnxt_ulp_irq_restart(struct bnxt *bp, int err)
 	if (!edev || !(edev->flags & BNXT_EN_FLAG_MSIX_REQUESTED))
 		return;
 
-	if (bnxt_ulp_registered(bp->edev, BNXT_ROCE_ULP)) {
+	if (bnxt_ulp_registered(bp->edev)) {
 		struct bnxt_ulp *ulp = edev->ulp_tbl;
 		struct bnxt_msix_entry *ent = NULL;
 
@@ -395,32 +392,20 @@ void bnxt_ulp_async_events(struct bnxt *bp, struct hwrm_async_event_cmpl *cmpl)
 	if (!edev)
 		return;
 
-	rcu_read_lock();
 	ulp = edev->ulp_tbl;
-
-	ops = rcu_dereference(ulp->ulp_ops);
+	ops = ulp->ulp_ops;
 	if (!ops || !ops->ulp_async_notifier)
-		goto out;
+		return;
+
 	if (!ulp->async_events_bmap || event_id > ulp->max_async_event_id)
-		goto out;
+		return;
 
 	/* Read max_async_event_id first before testing the bitmap. */
 	smp_rmb();
 	if (test_bit(event_id, ulp->async_events_bmap))
 		ops->ulp_async_notifier(ulp->handle, cmpl);
-
-out:
-	rcu_read_unlock();
 }
 
-static const struct bnxt_en_ops bnxt_en_ops_tbl = {
-	.bnxt_register_device	= bnxt_register_dev,
-	.bnxt_unregister_device	= bnxt_unregister_dev,
-	.bnxt_request_msix	= bnxt_req_msix_vecs,
-	.bnxt_free_msix		= bnxt_free_msix_vecs,
-	.bnxt_send_fw_msg	= bnxt_send_msg,
-};
-
 struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -431,7 +416,6 @@ struct bnxt_en_dev *bnxt_ulp_probe(struct net_device *dev)
 		edev = kzalloc(sizeof(*edev), GFP_KERNEL);
 		if (!edev)
 			return ERR_PTR(-ENOMEM);
-		edev->en_ops = &bnxt_en_ops_tbl;
 		if (bp->flags & BNXT_FLAG_ROCEV1_CAP)
 			edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
 		if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 3caee7c2f8c9..367f70ab0d3a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -10,10 +10,6 @@
 #ifndef BNXT_ULP_H
 #define BNXT_ULP_H
 
-#define BNXT_ROCE_ULP	0
-#define BNXT_OTHER_ULP	1
-#define BNXT_MAX_ULP	2
-
 #define BNXT_MIN_ROCE_CP_RINGS	2
 #define BNXT_MIN_ROCE_STAT_CTXS	1
 
@@ -47,7 +43,7 @@ struct bnxt_fw_msg {
 
 struct bnxt_ulp {
 	void		*handle;
-	struct bnxt_ulp_ops __rcu *ulp_ops;
+	struct bnxt_ulp_ops *ulp_ops;
 	unsigned long	*async_events_bmap;
 	u16		max_async_event_id;
 	u16		msix_requested;
@@ -65,7 +61,6 @@ struct bnxt_en_dev {
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
-	const struct bnxt_en_ops	*en_ops;
 	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
@@ -77,18 +72,15 @@ struct bnxt_en_dev {
 							 */
 };
 
-struct bnxt_en_ops {
-	int (*bnxt_register_device)(struct bnxt_en_dev *, int,
-				    struct bnxt_ulp_ops *, void *);
-	int (*bnxt_unregister_device)(struct bnxt_en_dev *, int);
-	int (*bnxt_request_msix)(struct bnxt_en_dev *, int,
-				 struct bnxt_msix_entry *, int);
-	int (*bnxt_free_msix)(struct bnxt_en_dev *, int);
-	int (*bnxt_send_fw_msg)(struct bnxt_en_dev *, int,
-				struct bnxt_fw_msg *);
-};
+int bnxt_register_dev(struct bnxt_en_dev *edev, struct bnxt_ulp_ops *ulp_ops,
+		      void *handle);
+void bnxt_unregister_dev(struct bnxt_en_dev *edev);
+int bnxt_req_msix_vecs(struct bnxt_en_dev *edev, struct bnxt_msix_entry *ent,
+		       int num_msix);
+void bnxt_free_msix_vecs(struct bnxt_en_dev *edev);
+int bnxt_send_msg(struct bnxt_en_dev *edev, struct bnxt_fw_msg *fw_msg);
 
-static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev, int ulp_id)
+static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
 {
 	if (edev && edev->ulp_tbl)
 		return true;
-- 
2.30.2

