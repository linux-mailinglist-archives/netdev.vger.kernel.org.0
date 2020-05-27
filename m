Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E59E1E3DDD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgE0Jqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:46:47 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:51619 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729110AbgE0Jqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:46:42 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maxg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 May 2020 12:46:36 +0300
Received: from mtr-vdi-031.wap.labs.mlnx. (mtr-vdi-031.wap.labs.mlnx [10.209.102.136])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 04R9kYiq009430;
        Wed, 27 May 2020 12:46:36 +0300
From:   Max Gurtovoy <maxg@mellanox.com>
To:     jgg@mellanox.com, dledford@redhat.com, leon@kernel.org,
        galpress@amazon.com, dennis.dalessandro@intel.com,
        netdev@vger.kernel.org, sagi@grimberg.me,
        linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com
Cc:     aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 9/9] RDMA/core: remove FMR device ops
Date:   Wed, 27 May 2020 12:46:34 +0300
Message-Id: <20200527094634.24240-10-maxg@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200527094634.24240-1-maxg@mellanox.com>
References: <20200527094634.24240-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After removing FMR support from all the RDMA ULPs and providers, there
is no need to keep FMR operation for IB devices.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 Documentation/infiniband/core_locking.rst |  2 --
 drivers/infiniband/core/device.c          |  4 ---
 drivers/infiniband/core/verbs.c           | 48 -------------------------------
 include/rdma/ib_verbs.h                   | 45 -----------------------------
 4 files changed, 99 deletions(-)

diff --git a/Documentation/infiniband/core_locking.rst b/Documentation/infiniband/core_locking.rst
index 8f76a8a..efd5e76 100644
--- a/Documentation/infiniband/core_locking.rst
+++ b/Documentation/infiniband/core_locking.rst
@@ -22,7 +22,6 @@ Sleeping and interrupt context
     - post_recv
     - poll_cq
     - req_notify_cq
-    - map_phys_fmr
 
   which may not sleep and must be callable from any context.
 
@@ -36,7 +35,6 @@ Sleeping and interrupt context
     - ib_post_send
     - ib_post_recv
     - ib_req_notify_cq
-    - ib_map_phys_fmr
 
   are therefore safe to call from any context.
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d0b3d35..4acbef2 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2557,7 +2557,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, add_gid);
 	SET_DEVICE_OP(dev_ops, advise_mr);
 	SET_DEVICE_OP(dev_ops, alloc_dm);
-	SET_DEVICE_OP(dev_ops, alloc_fmr);
 	SET_DEVICE_OP(dev_ops, alloc_hw_stats);
 	SET_DEVICE_OP(dev_ops, alloc_mr);
 	SET_DEVICE_OP(dev_ops, alloc_mr_integrity);
@@ -2584,7 +2583,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, create_wq);
 	SET_DEVICE_OP(dev_ops, dealloc_dm);
 	SET_DEVICE_OP(dev_ops, dealloc_driver);
-	SET_DEVICE_OP(dev_ops, dealloc_fmr);
 	SET_DEVICE_OP(dev_ops, dealloc_mw);
 	SET_DEVICE_OP(dev_ops, dealloc_pd);
 	SET_DEVICE_OP(dev_ops, dealloc_ucontext);
@@ -2628,7 +2626,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, iw_rem_ref);
 	SET_DEVICE_OP(dev_ops, map_mr_sg);
 	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
-	SET_DEVICE_OP(dev_ops, map_phys_fmr);
 	SET_DEVICE_OP(dev_ops, mmap);
 	SET_DEVICE_OP(dev_ops, mmap_free);
 	SET_DEVICE_OP(dev_ops, modify_ah);
@@ -2662,7 +2659,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, resize_cq);
 	SET_DEVICE_OP(dev_ops, set_vf_guid);
 	SET_DEVICE_OP(dev_ops, set_vf_link_state);
-	SET_DEVICE_OP(dev_ops, unmap_fmr);
 
 	SET_OBJ_SIZE(dev_ops, ib_ah);
 	SET_OBJ_SIZE(dev_ops, ib_cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 56a7133..fa6689b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2160,54 +2160,6 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
 }
 EXPORT_SYMBOL(ib_alloc_mr_integrity);
 
-/* "Fast" memory regions */
-
-struct ib_fmr *ib_alloc_fmr(struct ib_pd *pd,
-			    int mr_access_flags,
-			    struct ib_fmr_attr *fmr_attr)
-{
-	struct ib_fmr *fmr;
-
-	if (!pd->device->ops.alloc_fmr)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	fmr = pd->device->ops.alloc_fmr(pd, mr_access_flags, fmr_attr);
-	if (!IS_ERR(fmr)) {
-		fmr->device = pd->device;
-		fmr->pd     = pd;
-		atomic_inc(&pd->usecnt);
-	}
-
-	return fmr;
-}
-EXPORT_SYMBOL(ib_alloc_fmr);
-
-int ib_unmap_fmr(struct list_head *fmr_list)
-{
-	struct ib_fmr *fmr;
-
-	if (list_empty(fmr_list))
-		return 0;
-
-	fmr = list_entry(fmr_list->next, struct ib_fmr, list);
-	return fmr->device->ops.unmap_fmr(fmr_list);
-}
-EXPORT_SYMBOL(ib_unmap_fmr);
-
-int ib_dealloc_fmr(struct ib_fmr *fmr)
-{
-	struct ib_pd *pd;
-	int ret;
-
-	pd = fmr->pd;
-	ret = fmr->device->ops.dealloc_fmr(fmr);
-	if (!ret)
-		atomic_dec(&pd->usecnt);
-
-	return ret;
-}
-EXPORT_SYMBOL(ib_dealloc_fmr);
-
 /* Multicast groups */
 
 static bool is_valid_mcast_lid(struct ib_qp *qp, u16 lid)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bbc5cfb..1850b3a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2453,12 +2453,6 @@ struct ib_device_ops {
 	struct ib_mw *(*alloc_mw)(struct ib_pd *pd, enum ib_mw_type type,
 				  struct ib_udata *udata);
 	int (*dealloc_mw)(struct ib_mw *mw);
-	struct ib_fmr *(*alloc_fmr)(struct ib_pd *pd, int mr_access_flags,
-				    struct ib_fmr_attr *fmr_attr);
-	int (*map_phys_fmr)(struct ib_fmr *fmr, u64 *page_list, int list_len,
-			    u64 iova);
-	int (*unmap_fmr)(struct list_head *fmr_list);
-	int (*dealloc_fmr)(struct ib_fmr *fmr);
 	int (*attach_mcast)(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 	int (*detach_mcast)(struct ib_qp *qp, union ib_gid *gid, u16 lid);
 	struct ib_xrcd *(*alloc_xrcd)(struct ib_device *device,
@@ -4209,45 +4203,6 @@ static inline u32 ib_inc_rkey(u32 rkey)
 }
 
 /**
- * ib_alloc_fmr - Allocates a unmapped fast memory region.
- * @pd: The protection domain associated with the unmapped region.
- * @mr_access_flags: Specifies the memory access rights.
- * @fmr_attr: Attributes of the unmapped region.
- *
- * A fast memory region must be mapped before it can be used as part of
- * a work request.
- */
-struct ib_fmr *ib_alloc_fmr(struct ib_pd *pd,
-			    int mr_access_flags,
-			    struct ib_fmr_attr *fmr_attr);
-
-/**
- * ib_map_phys_fmr - Maps a list of physical pages to a fast memory region.
- * @fmr: The fast memory region to associate with the pages.
- * @page_list: An array of physical pages to map to the fast memory region.
- * @list_len: The number of pages in page_list.
- * @iova: The I/O virtual address to use with the mapped region.
- */
-static inline int ib_map_phys_fmr(struct ib_fmr *fmr,
-				  u64 *page_list, int list_len,
-				  u64 iova)
-{
-	return fmr->device->ops.map_phys_fmr(fmr, page_list, list_len, iova);
-}
-
-/**
- * ib_unmap_fmr - Removes the mapping from a list of fast memory regions.
- * @fmr_list: A linked list of fast memory regions to unmap.
- */
-int ib_unmap_fmr(struct list_head *fmr_list);
-
-/**
- * ib_dealloc_fmr - Deallocates a fast memory region.
- * @fmr: The fast memory region to deallocate.
- */
-int ib_dealloc_fmr(struct ib_fmr *fmr);
-
-/**
  * ib_attach_mcast - Attaches the specified QP to a multicast group.
  * @qp: QP to attach to the multicast group.  The QP must be type
  *   IB_QPT_UD.
-- 
1.8.3.1

