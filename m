Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70B31E6B83
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgE1Tqq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbgE1TqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:46:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824BFC008639
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:08 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s1so59852qkf.9
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 12:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SLNpw3g3oyPSil+aTW+VTA5ZSO7dCK2VQRQdfkdRGlI=;
        b=P8v6PJ1OQFePm+wp2p3YOzW9DuPA6tu4b+o0oJvPLFh13APvZYXE+MO94sRaBdVab9
         FeUE5TM5+7amwZ/TCrnpCfALyu1tFuLDdrQn4pME+k0lm4eVSQfmyV0NkiZb/n2gFk1b
         3/l/7lqztyrMLoBLmfrMAuJL0PKIBMEY90AonnoA/yClC0ruLL9JfNl2mmV0qVo1t8Zy
         MqKNGnGQve0pgfpl1+T7xfJ2jOUJd02ttxZSPtl27aBr1R0CDefU0KheHPU7+8UqsROg
         UGoRqvpHLCYSvtsKWjZwdzedC9csi2ag1TkD8x3upJyev7L05JA1Fd5nsmeyr9R6Mnsr
         s5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SLNpw3g3oyPSil+aTW+VTA5ZSO7dCK2VQRQdfkdRGlI=;
        b=WPyM3MC96UM4TURuwDIsR4ifOvo3S7/xjBehnUJ3WWTldNsiUtAXROpf4LaFzrxn2T
         uweANjPuc14rKMKNtbyjaBeRSXsH4tu7CXzl+UDkU7Fv/5tY3ycjROKj6wssu8gOzr/I
         LLHESrCpjh87pCVjLY80JTi1lC81pWMMU+i0AEmeF8POTiLqfmG+IDamIQyuxOfl0Mwh
         uIE4fafJUPKTZpX9O/FjSUXdRs7vcreSNuOIP5uw/Xvwszg2EihFhErGIwU3/IR+tsvV
         xxB0pc7YWILDcMpILDWSvbIvIRdVDkyx/4jm1Jrk2Kplh2y530yYOii/4Mg9UTQNDGE4
         1JYw==
X-Gm-Message-State: AOAM532SH7X8+jkBBKO9D1PL2+G2GB8XSGFAaoaYKr4gPeb19i20tUkf
        PJlUxuBLkPek0VcczR/BuZj/TQ==
X-Google-Smtp-Source: ABdhPJz5111S0M4vi1bW4mpAX6WOLfDqCyUHw+9zMazqOBa+hyXbp0H0WUBFZTi2PNNeEQV0kloz7A==
X-Received: by 2002:a37:e50b:: with SMTP id e11mr4791996qkg.224.1590695167702;
        Thu, 28 May 2020 12:46:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id i94sm5831714qtd.2.2020.05.28.12.45.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 May 2020 12:45:57 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jeOTU-0006iF-HP; Thu, 28 May 2020 16:45:56 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Ariel Elior <aelior@marvell.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Michal Kalderon <mkalderon@marvell.com>, oren@mellanox.com,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: [PATCH v3 12/13] RDMA: Remove 'max_fmr'
Date:   Thu, 28 May 2020 16:45:54 -0300
Message-Id: <12-v3-f58e6669d5d3+2cf-fmr_removal_jgg@mellanox.com>
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
Cc: Bernard Metzler <bmt@zurich.ibm.com>
Cc: Selvin Xavier <selvin.xavier@broadcom.com>
Cc: Devesh Sharma <devesh.sharma@broadcom.com>
Cc: Michal Kalderon <mkalderon@marvell.com>
Cc: Ariel Elior <aelior@marvell.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
---
 drivers/infiniband/core/uverbs_cmd.c        | 1 -
 drivers/infiniband/hw/ocrdma/ocrdma.h       | 1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c    | 1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 1 -
 drivers/infiniband/hw/qedr/main.c           | 1 -
 drivers/infiniband/hw/qedr/qedr.h           | 1 -
 drivers/infiniband/hw/qedr/verbs.c          | 1 -
 drivers/infiniband/sw/rdmavt/mr.c           | 1 -
 drivers/infiniband/sw/siw/siw.h             | 2 --
 drivers/infiniband/sw/siw/siw_main.c        | 1 -
 drivers/infiniband/sw/siw/siw_verbs.c       | 1 -
 drivers/net/ethernet/qlogic/qed/qed_rdma.c  | 1 -
 drivers/net/ethernet/qlogic/qed/qed_rdma.h  | 1 -
 include/linux/qed/qed_rdma_if.h             | 1 -
 include/rdma/ib_verbs.h                     | 1 -
 net/rds/ib.c                                | 2 +-
 16 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 2067a939788bd5..56d207405dbd1c 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -356,7 +356,6 @@ static void copy_query_dev_fields(struct ib_ucontext *ucontext,
 	resp->max_mcast_qp_attach	= attr->max_mcast_qp_attach;
 	resp->max_total_mcast_qp_attach	= attr->max_total_mcast_qp_attach;
 	resp->max_ah			= attr->max_ah;
-	resp->max_fmr			= attr->max_fmr;
 	resp->max_map_per_fmr		= attr->max_map_per_fmr;
 	resp->max_srq			= attr->max_srq;
 	resp->max_srq_wr		= attr->max_srq_wr;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma.h b/drivers/infiniband/hw/ocrdma/ocrdma.h
index 7baedc74e39d7e..fcfe0e82197a24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma.h
@@ -98,7 +98,6 @@ struct ocrdma_dev_attr {
 	u64 max_mr_size;
 	u32 max_num_mr_pbl;
 	int max_mw;
-	int max_fmr;
 	int max_map_per_fmr;
 	int max_pages_per_frmr;
 	u16 max_ord_per_qp;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
index d82d3ec3649ea0..e07bf0b2209a4c 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_hw.c
@@ -1190,7 +1190,6 @@ static void ocrdma_get_attr(struct ocrdma_dev *dev,
 	attr->max_mr = rsp->max_mr;
 	attr->max_mr_size = ((u64)rsp->max_mr_size_hi << 32) |
 			      rsp->max_mr_size_lo;
-	attr->max_fmr = 0;
 	attr->max_pages_per_frmr = rsp->max_pages_per_frmr;
 	attr->max_num_mr_pbl = rsp->max_num_mr_pbl;
 	attr->max_cqe = rsp->max_cq_cqes_per_cq &
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 10e34389459592..890e3fd41d2199 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -99,7 +99,6 @@ int ocrdma_query_device(struct ib_device *ibdev, struct ib_device_attr *attr,
 	attr->max_mw = dev->attr.max_mw;
 	attr->max_pd = dev->attr.max_pd;
 	attr->atomic_cap = 0;
-	attr->max_fmr = 0;
 	attr->max_map_per_fmr = 0;
 	attr->max_qp_rd_atom =
 	    min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index dcdc85a1ab2540..ccaedfd53e49e2 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -632,7 +632,6 @@ static int qedr_set_device_attr(struct qedr_dev *dev)
 	attr->max_mr_size = qed_attr->max_mr_size;
 	attr->max_cqe = min_t(u64, qed_attr->max_cqe, QEDR_MAX_CQES);
 	attr->max_mw = qed_attr->max_mw;
-	attr->max_fmr = qed_attr->max_fmr;
 	attr->max_mr_mw_fmr_pbl = qed_attr->max_mr_mw_fmr_pbl;
 	attr->max_mr_mw_fmr_size = qed_attr->max_mr_mw_fmr_size;
 	attr->max_pd = qed_attr->max_pd;
diff --git a/drivers/infiniband/hw/qedr/qedr.h b/drivers/infiniband/hw/qedr/qedr.h
index 5488dbd59d3c15..fdf90ecb26990f 100644
--- a/drivers/infiniband/hw/qedr/qedr.h
+++ b/drivers/infiniband/hw/qedr/qedr.h
@@ -103,7 +103,6 @@ struct qedr_device_attr {
 	u64	max_mr_size;
 	u32	max_cqe;
 	u32	max_mw;
-	u32	max_fmr;
 	u32	max_mr_mw_fmr_pbl;
 	u64	max_mr_mw_fmr_size;
 	u32	max_pd;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index d6b94a71357323..ca88006eaa667c 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -145,7 +145,6 @@ int qedr_query_device(struct ib_device *ibdev,
 	attr->max_mw = qattr->max_mw;
 	attr->max_pd = qattr->max_pd;
 	attr->atomic_cap = dev->atomic_cap;
-	attr->max_fmr = qattr->max_fmr;
 	attr->max_map_per_fmr = 16;
 	attr->max_qp_init_rd_atom =
 	    1 << (fls(qattr->max_qp_req_rd_atomic_resc) - 1);
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index ddb0c0d771c257..60864e5ca7cb67 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -97,7 +97,6 @@ int rvt_driver_mr_init(struct rvt_dev_info *rdi)
 		RCU_INIT_POINTER(rdi->lkey_table.table[i], NULL);
 
 	rdi->dparms.props.max_mr = rdi->lkey_table.max;
-	rdi->dparms.props.max_fmr = rdi->lkey_table.max;
 	return 0;
 }
 
diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index 5a58a1cc7a7e84..e9753831ac3f33 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -30,7 +30,6 @@
 #define SIW_MAX_MR (SIW_MAX_QP * 10)
 #define SIW_MAX_PD SIW_MAX_QP
 #define SIW_MAX_MW 0 /* to be set if MW's are supported */
-#define SIW_MAX_FMR SIW_MAX_MR
 #define SIW_MAX_SRQ SIW_MAX_QP
 #define SIW_MAX_SRQ_WR (SIW_MAX_QP_WR * 10)
 #define SIW_MAX_CONTEXT SIW_MAX_PD
@@ -59,7 +58,6 @@ struct siw_dev_cap {
 	int max_mr;
 	int max_pd;
 	int max_mw;
-	int max_fmr;
 	int max_srq;
 	int max_srq_wr;
 	int max_srq_sge;
diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index 5cd40fb9e20ce5..a0b8cc643c5cfc 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -413,7 +413,6 @@ static struct siw_device *siw_device_create(struct net_device *netdev)
 	sdev->attrs.max_mr = SIW_MAX_MR;
 	sdev->attrs.max_pd = SIW_MAX_PD;
 	sdev->attrs.max_mw = SIW_MAX_MW;
-	sdev->attrs.max_fmr = SIW_MAX_FMR;
 	sdev->attrs.max_srq = SIW_MAX_SRQ;
 	sdev->attrs.max_srq_wr = SIW_MAX_SRQ_WR;
 	sdev->attrs.max_srq_sge = SIW_MAX_SGE;
diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index aeb842bc7a1ee9..987e2ba05dbc06 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -136,7 +136,6 @@ int siw_query_device(struct ib_device *base_dev, struct ib_device_attr *attr,
 	attr->max_cq = sdev->attrs.max_cq;
 	attr->max_cqe = sdev->attrs.max_cqe;
 	attr->max_fast_reg_page_list_len = SIW_MAX_SGE_PBL;
-	attr->max_fmr = sdev->attrs.max_fmr;
 	attr->max_mr = sdev->attrs.max_mr;
 	attr->max_mw = sdev->attrs.max_mw;
 	attr->max_mr_size = ~0ull;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index 38b1f402f7ed29..5dc18a4bdda4a8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -499,7 +499,6 @@ static void qed_rdma_init_devinfo(struct qed_hwfn *p_hwfn,
 		dev->max_cqe = QED_RDMA_MAX_CQE_16_BIT;
 
 	dev->max_mw = 0;
-	dev->max_fmr = QED_RDMA_MAX_FMR;
 	dev->max_mr_mw_fmr_pbl = (PAGE_SIZE / 8) * (PAGE_SIZE / 8);
 	dev->max_mr_mw_fmr_size = dev->max_mr_mw_fmr_pbl * PAGE_SIZE;
 	dev->max_pkey = QED_RDMA_MAX_P_KEY;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.h b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
index 3689fe3e593542..dfaa2f552627f7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.h
@@ -45,7 +45,6 @@
 #include "qed_iwarp.h"
 #include "qed_roce.h"
 
-#define QED_RDMA_MAX_FMR                    (RDMA_MAX_TIDS)
 #define QED_RDMA_MAX_P_KEY                  (1)
 #define QED_RDMA_MAX_WQE                    (0x7FFF)
 #define QED_RDMA_MAX_SRQ_WQE_ELEM           (0x7FFF)
diff --git a/include/linux/qed/qed_rdma_if.h b/include/linux/qed/qed_rdma_if.h
index 74efca15fde7dd..c90276cda5c162 100644
--- a/include/linux/qed/qed_rdma_if.h
+++ b/include/linux/qed/qed_rdma_if.h
@@ -91,7 +91,6 @@ struct qed_rdma_device {
 	u64 max_mr_size;
 	u32 max_cqe;
 	u32 max_mw;
-	u32 max_fmr;
 	u32 max_mr_mw_fmr_pbl;
 	u64 max_mr_mw_fmr_size;
 	u32 max_pd;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d275ca1e97b7d3..a84f91c2816add 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -430,7 +430,6 @@ struct ib_device_attr {
 	int			max_mcast_qp_attach;
 	int			max_total_mcast_qp_attach;
 	int			max_ah;
-	int			max_fmr;
 	int			max_map_per_fmr;
 	int			max_srq;
 	int			max_srq_wr;
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 6c43b3e4c73618..deecbdcdae84ef 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -217,7 +217,7 @@ static int rds_ib_add_one(struct ib_device *device)
 	}
 
 	rdsdebug("RDS/IB: max_mr = %d, max_wrs = %d, max_sge = %d, max_1m_mrs = %d, max_8k_mrs = %d\n",
-		 device->attrs.max_fmr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
+		 device->attrs.max_mr, rds_ibdev->max_wrs, rds_ibdev->max_sge,
 		 rds_ibdev->max_1m_mrs, rds_ibdev->max_8k_mrs);
 
 	pr_info("RDS/IB: %s: added\n", device->name);
-- 
2.26.2

