Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E8B1E6B82
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgE1Tqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbgE1TqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2C7C00863B
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:09 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id w3so80502qkb.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S0NaWE4enarNpKAgN8g8UsBoWL2YGpdNlXWzyIiHghA=;
        b=dy+cp++cUmJiNqUWVYtZoN3vtukzz4TbHliVX5CuMV8kXZLKuR0UxucqcR2FLmkCPb
         FwFiDzM1bz3a9AsESyAlR7nNCUbahsz6AN5uVN1eJYgCTEf0sHq8o/uuYBK43C2rJswW
         BrqS7sSdUSPWifdXkl0XCTAgGaSkfBLN36RJITPmqYldPRnqS1iMGoBTPj4zNPL6ldbe
         Nc9R2HgRFGJ804kY3jDH9Zd3m2X/AZI34JVaQbuyfq5+A8mVeHJFEElvzkWOlUs4YhUF
         7xySrTNGr+mvXqdFD5jMOhHw1lWd0ItlK+YQYDiOG5uL+BWxjAt6VW6n8ObBRiK9AilJ
         GLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S0NaWE4enarNpKAgN8g8UsBoWL2YGpdNlXWzyIiHghA=;
        b=S4LXujDUUva7tUCRnH3FfPukPwSkdl+t+pAJhiSXhGpWZqz0Ts2mQ3YULh+AUKThyP
         t8t2ZtPJ9e9dcO8XAutZiJVyRl74fjiPUwN3QQ5AZqY4M6qsdIJqj2erMEMki8vU2akV
         gBIua8mZcQaZUrBMh1SESIpezLYA7RFwNAvZBwJDvvHkZhtzrgVmfm5XxwlpZVearc6M
         fAa9UoGSoa//e3fKH5UyTyzy0EnUDq3NF66vnfJbMNsDbx3zTB4BxYlRTdAIZH69zqhG
         1z+5Zu6HD1VLZ4sP8k5xr21WPQlJuJe8ACrsA7blum/u4DGFulMvJns7GoZ3rIrfpd9Z
         QIgA==
X-Gm-Message-State: AOAM533ZeX85i/GzNd67PdWRCKWIVt1aZ4/oanLyQEPoWA1dqn3xn1q5
        jV+1FoM+8A9DSDYGt5u/One9WA==
X-Google-Smtp-Source: ABdhPJw7vDF5zzJ00XPUz/4aokRaN4xcJ/mx4I+Gq1DESAnMvtRQmdQnt+vMRda0RBPBc4aPQ9I2Hg==
X-Received: by 2002:a37:a0b:: with SMTP id 11mr4382540qkk.501.1590695168291;
        Thu, 28 May 2020 12:46:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id z194sm5500820qkb.73.2020.05.28.12.45.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006i6-Fj; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Max Gurtovoy <maxg@mellanox.com>, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 11/13] RDMA/core: Remove FMR device ops
Date:   Thu, 28 May 2020 16:45:53 -0300
Message-Id: <11-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max Gurtovoy <maxg@mellanox.com>

After removing FMR support from all the RDMA ULPs and providers, there
is no need to keep FMR operation for IB devices.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 Documentation/infiniband/core_locking.rst |  2 -
 drivers/infiniband/core/device.c          |  4 --
 drivers/infiniband/core/verbs.c           | 48 ------------------
 include/rdma/ib_verbs.h                   | 59 -----------------------
 4 files changed, 113 deletions(-)

diff --git a/Documentation/infiniband/core_locking.rst b/Documentation/infiniband/core_locking.rst
index 8f76a8a5a38f01..efd5e7603014db 100644
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
index d9f565a779dfda..96d4d8295e97d7 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2569,7 +2569,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, add_gid);
 	SET_DEVICE_OP(dev_ops, advise_mr);
 	SET_DEVICE_OP(dev_ops, alloc_dm);
-	SET_DEVICE_OP(dev_ops, alloc_fmr);
 	SET_DEVICE_OP(dev_ops, alloc_hw_stats);
 	SET_DEVICE_OP(dev_ops, alloc_mr);
 	SET_DEVICE_OP(dev_ops, alloc_mr_integrity);
@@ -2596,7 +2595,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, create_wq);
 	SET_DEVICE_OP(dev_ops, dealloc_dm);
 	SET_DEVICE_OP(dev_ops, dealloc_driver);
-	SET_DEVICE_OP(dev_ops, dealloc_fmr);
 	SET_DEVICE_OP(dev_ops, dealloc_mw);
 	SET_DEVICE_OP(dev_ops, dealloc_pd);
 	SET_DEVICE_OP(dev_ops, dealloc_ucontext);
@@ -2640,7 +2638,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, iw_rem_ref);
 	SET_DEVICE_OP(dev_ops, map_mr_sg);
 	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
-	SET_DEVICE_OP(dev_ops, map_phys_fmr);
 	SET_DEVICE_OP(dev_ops, mmap);
 	SET_DEVICE_OP(dev_ops, mmap_free);
 	SET_DEVICE_OP(dev_ops, modify_ah);
@@ -2674,7 +2671,6 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, resize_cq);
 	SET_DEVICE_OP(dev_ops, set_vf_guid);
 	SET_DEVICE_OP(dev_ops, set_vf_link_state);
-	SET_DEVICE_OP(dev_ops, unmap_fmr);
 
 	SET_OBJ_SIZE(dev_ops, ib_ah);
 	SET_OBJ_SIZE(dev_ops, ib_cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e2c9430a3ff1f3..1681eee2f7f3e8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2203,54 +2203,6 @@ struct ib_mr *ib_alloc_mr_integrity(struct ib_pd *pd,
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
index 94533ae1669734..d275ca1e97b7d3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1475,12 +1475,6 @@ enum ib_mr_rereg_flags {
 	IB_MR_REREG_SUPPORTED	= ((IB_MR_REREG_ACCESS << 1) - 1)
 };
 
-struct ib_fmr_attr {
-	int	max_pages;
-	int	max_maps;
-	u8	page_shift;
-};
-
 struct ib_umem;
 
 enum rdma_remove_reason {
@@ -1849,14 +1843,6 @@ struct ib_mw {
 	enum ib_mw_type         type;
 };
 
-struct ib_fmr {
-	struct ib_device	*device;
-	struct ib_pd		*pd;
-	struct list_head	list;
-	u32			lkey;
-	u32			rkey;
-};
-
 /* Supported steering options */
 enum ib_flow_attr_type {
 	/* steering according to rule specifications */
@@ -2499,12 +2485,6 @@ struct ib_device_ops {
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
@@ -4301,45 +4281,6 @@ static inline u32 ib_inc_rkey(u32 rkey)
 	return ((rkey + 1) & mask) | (rkey & ~mask);
 }
 
-/**
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
 /**
  * ib_attach_mcast - Attaches the specified QP to a multicast group.
  * @qp: QP to attach to the multicast group.  The QP must be type
-- 
2.26.2

