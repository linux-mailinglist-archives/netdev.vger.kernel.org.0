Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2CB1E6B85
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbgE1Tqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728720AbgE1TqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:11 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E617DC008636
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:06 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id v79so53047qkb.10
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DvqrFc5us5AENcnTjWi7Qvd28BVKjzHbaD6hAjCwCcw=;
        b=jT502ZWeRUKl36e62GyqgPc7+4DvXpdV7yFSipOhkKrUwRNc0wsIQfw6519+BmgIfm
         F/a6KN0uIBXFZXhZtmT64vVslm+HbXDTLl4O3dSWHUQxCCESahu3qOET7qEGA7Mzuodp
         x+fBzaLrXQLUetFPSNCoKUH/jQawj1KHKzXR1gE97uLv/6su8RXPOHTIdE58nTOskrE1
         Q7zWNucYQ3vysm9YNERn+PPpr6u0sGGOb3e2qJQX6CWe8jXoCQ2EAeUQxo6BT+cFAaG4
         8ONNVmUQV8hkrYIKMpl1wO1kckmMdqjB+xQR7OjKoLdr1YY0Cj7Whmk/JK+uv3eNdccR
         VVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DvqrFc5us5AENcnTjWi7Qvd28BVKjzHbaD6hAjCwCcw=;
        b=siVsTxt2Og803QYE3hKumPklaNnFEQrrlfoyDOYe3FJ2spcDjo8VvZD3sFscMqfwzI
         FBoxQwYw+HEX22X/cG6FefyyYh32DIiZvzTj5fWwfGbKS0ybf5XW5Ou6XA1PzCFE3TPq
         e5BItnQWJ7Fm5Zbr1dif60Pmv6uITjvabxeud6D6a1WjJyp98/A67ToyhTq42ANXZIZQ
         Z5UGtMnA6tzV14HYp3qUop9kOiJpaFHkkANVBFwton9D4yI3i0iDROqyOfqe2cANPnHK
         F5kz9ouP9qY27L5Y4G7pa5hBsdP4AhM68gv5+NLnG60duc2NIRaR0uClogtKzh4/+nRA
         E0MA==
X-Gm-Message-State: AOAM533/lFW+JtvIWzNGCfoK8SucwIdVQo+3kjEwzGZ/WXZg0ukrhqUh
        Fx1yv2jhLfBylWFYDTM425EQSQ==
X-Google-Smtp-Source: ABdhPJxU0xkrYQdgIkToONbqR7fBeqL94pYQ6sbl1O7xo/HJTNTBrMBIGYm9VZhQ3NBTwXXTS4EYIw==
X-Received: by 2002:a05:620a:749:: with SMTP id i9mr3312130qki.276.1590695166174;
        Thu, 28 May 2020 12:46:06 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id l2sm3150qtc.80.2020.05.28.12.45.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006iU-JH; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Michal Kalderon <mkalderon@marvell.com>, oren@mellanox.com,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>, shlomin@mellanox.com,
        vladimirk@mellanox.com
Subject: [PATCH v3 13/13] RDMA: Remove 'max_map_per_fmr'
Date:   Thu, 28 May 2020 16:45:55 -0300
Message-Id: <13-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
In-Reply-To: <0-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Now that FMR support is gone, this attribute can be deleted from all
places.

Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: Faisal Latif <faisal.latif@intel.com>
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>
Cc: Michal Kalderon <mkalderon@marvell.com>
---
 drivers/infiniband/core/uverbs_cmd.c         |  1 -
 drivers/infiniband/hw/hfi1/verbs.c           |  1 -
 drivers/infiniband/hw/i40iw/i40iw_verbs.c    |  1 -
 drivers/infiniband/hw/mlx5/main.c            |  1 -
 drivers/infiniband/hw/mthca/mthca_provider.c | 10 ----------
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  1 -
 drivers/infiniband/hw/qedr/verbs.c           |  1 -
 drivers/infiniband/hw/qib/qib_verbs.c        |  1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  1 -
 include/rdma/ib_verbs.h                      |  1 -
 10 files changed, 19 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 56d207405dbd1c..b48b3f6e632d46 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -356,7 +356,6 @@ static void copy_query_dev_fields(struct ib_ucontext *ucontext,
 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
 	resp->max_ah			= attr->max_ah;
-	resp->max_map_per_fmr		= attr->max_map_per_fmr;
 	resp->max_srq			= attr->max_srq;
 	resp->max_srq_wr		= attr->max_srq_wr;
 	resp->max_srq_sge		= attr->max_srq_sge;
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 43ddced15951b7..30865635b44991 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1361,7 +1361,6 @@ static void hfi1_fill_device_attr(struct hfi1_devdata *dd)
 	rdi->dparms.props.max_cq = hfi1_max_cqs;
 	rdi->dparms.props.max_ah = hfi1_max_ahs;
 	rdi->dparms.props.max_cqe = hfi1_max_cqes;
-	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_pd = hfi1_max_pds;
 	rdi->dparms.props.max_qp_rd_atom = HFI1_MAX_RDMA_ATOMIC;
 	rdi->dparms.props.max_qp_init_rd_atom = 255;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 1b6fb13809619d..19af29a48c5593 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -83,7 +83,6 @@ static int i40iw_query_device(struct ib_device *ibdev,
 	props->max_qp_rd_atom = I40IW_MAX_IRD_SIZE;
 	props->max_qp_init_rd_atom = props->max_qp_rd_atom;
 	props->atomic_cap = IB_ATOMIC_NONE;
-	props->max_map_per_fmr = 1;
 	props->max_fast_reg_page_list_len = I40IW_MAX_PAGES_PER_FMR;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 6557c83391614c..d5b3cffd5a8409 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -999,7 +999,6 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	props->max_mcast_qp_attach = MLX5_CAP_GEN(mdev, max_qp_mcg);
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
-	props->max_map_per_fmr = INT_MAX; /* no limit in ConnectIB */
 	props->max_ah = INT_MAX;
 	props->hca_core_clock = MLX5_CAP_GEN(mdev, device_frequency_khz);
 	props->timestamp_mask = 0x7FFFFFFFFFFFFFFFULL;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index de2124a8ee2be6..9fa2f9164a47b6 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -118,16 +118,6 @@ static int mthca_query_device(struct ib_device *ibdev, struct ib_device_attr *pr
 	props->max_mcast_qp_attach = MTHCA_QP_PER_MGM;
 	props->max_total_mcast_qp_attach = props->max_mcast_qp_attach *
 					   props->max_mcast_grp;
-	/*
-	 * If Sinai memory key optimization is being used, then only
-	 * the 8-bit key portion will change.  For other HCAs, the
-	 * unused index bits will also be used for FMR remapping.
-	 */
-	if (mdev->mthca_flags & MTHCA_FLAG_SINAI_OPT)
-		props->max_map_per_fmr = 255;
-	else
-		props->max_map_per_fmr =
-			(1 << (32 - ilog2(mdev->limits.num_mpts))) - 1;
 
 	err = 0;
  out:
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 890e3fd41d2199..d11c74390a1242 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -99,7 +99,6 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 	attr->max_mw = dev->attr.max_mw;
 	attr->max_pd = dev->attr.max_pd;
 	attr->atomic_cap = 0;
-	attr->max_map_per_fmr = 0;
 	attr->max_qp_rd_atom =
 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
 	attr->max_qp_init_rd_atom = dev->attr.max_ord_per_qp;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index ca88006eaa667c..9b9e802663674c 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -145,7 +145,6 @@ int qedr_query_device(struct ib_device *ibdev,
 	attr->max_mw = qattr->max_mw;
 	attr->max_pd = qattr->max_pd;
 	attr->atomic_cap = dev->atomic_cap;
-	attr->max_map_per_fmr = 16;
 	attr->max_qp_init_rd_atom =
 	    1 << (fls(qattr->max_qp_req_rd_atomic_resc) - 1);
 	attr->max_qp_rd_atom =
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 7508abb6a0fa1e..7acf9ba5358a41 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1460,7 +1460,6 @@ static void qib_fill_device_attr(struct qib_devdata *dd)
 	rdi->dparms.props.max_cq = ib_qib_max_cqs;
 	rdi->dparms.props.max_cqe = ib_qib_max_cqes;
 	rdi->dparms.props.max_ah = ib_qib_max_ahs;
-	rdi->dparms.props.max_map_per_fmr = 32767;
 	rdi->dparms.props.max_qp_rd_atom = QIB_MAX_RDMA_ATOMIC;
 	rdi->dparms.props.max_qp_init_rd_atom = 255;
 	rdi->dparms.props.max_srq = ib_qib_max_srqs;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 71f82339446c29..b8a77ce1159086 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -322,7 +322,6 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 	props->max_mcast_grp = 0;
 	props->max_mcast_qp_attach = 0;
 	props->max_total_mcast_qp_attach = 0;
-	props->max_map_per_fmr = 0;
 	/* Owned by Userspace
 	 * max_qp_wr, max_sge, max_sge_rd, max_cqe */
 	mutex_unlock(&us_ibdev->usdev_lock);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index a84f91c2816add..4926508bbd9be9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -430,7 +430,6 @@ struct ib_device_attr {
 	int			max_mcast_qp_attach;
 	int			max_total_mcast_qp_attach;
 	int			max_ah;
-	int			max_map_per_fmr;
 	int			max_srq;
 	int			max_srq_wr;
 	int			max_srq_sge;
-- 
2.26.2

