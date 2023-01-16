Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A4566BEAD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbjAPNHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjAPNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3AA272C;
        Mon, 16 Jan 2023 05:06:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFC8960F9C;
        Mon, 16 Jan 2023 13:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EFCC433D2;
        Mon, 16 Jan 2023 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874374;
        bh=WAO+ONgqCraZR3yFcifYnEjOC2lBkvnTXTYmd++BW0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM0T4s2IJ0FDTKt1QqH1Ja6+4wlUM9LuKIb7UeMv8Is4hBnKRT4LPtYykvf2yXcHP
         sS4B8DzDvptm/UcueHCYuLj41X/BDBs+xCV3rcY9avIHMClwgyXjeBIu7VNSd52Wbw
         ZaSUr4nBJnGEohv+f1PoH9FjXAME+MWVEHZZsfGSQHAuy+4H9qjbp5TfhpD6XJ475R
         iEja0YyoCJsFuwHcgXOqnNGMfEp7XlrsDay1zJfd4DGNrtRgfA617UrNC4BmhUpVlz
         pGYE5bUmFZt3Oi2qaZPmEpeRpkM0Gc8jL5sgA49rP9N7Vhuugkj2OAaFx0WeQ4Jf0k
         DVEONyK8FEurA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 03/13] RDMA: Split kernel-only create QP flags from uverbs create QP flags
Date:   Mon, 16 Jan 2023 15:05:50 +0200
Message-Id: <6e46859a58645d9f16a63ff76592487aabc9971d.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

The current code limits the create_flags to being the same bitmap that
will be copied to user space. Extend the create QP flags to 64 bits and
move all the flags that are only used internally in the kernel to the
upper 32 bits. This cleanly split out the uverbs flags from the kernel
flags to avoid confusion in the flags bitmap. Also add some short
comments describing which each of the kernel flags is connected to.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_qp.c | 12 +++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |  4 ++--
 drivers/infiniband/hw/mlx4/qp.c               |  4 ++--
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |  2 +-
 drivers/infiniband/hw/mlx5/qp.c               |  9 ++++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  2 +-
 include/rdma/ib_verbs.h                       | 22 ++++++++++++++-----
 8 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_qp.c b/drivers/infiniband/core/uverbs_std_types_qp.c
index 7b4773fa4bc0..fe2c7427eac4 100644
--- a/drivers/infiniband/core/uverbs_std_types_qp.c
+++ b/drivers/infiniband/core/uverbs_std_types_qp.c
@@ -97,6 +97,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	struct ib_uobject *xrcd_uobj = NULL;
 	struct ib_device *device;
 	u64 user_handle;
+	u32 create_flags;
 	int ret;
 
 	ret = uverbs_copy_from_or_zero(&cap, attrs,
@@ -191,7 +192,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 		return -EINVAL;
 	}
 
-	ret = uverbs_get_flags32(&attr.create_flags, attrs,
+	ret = uverbs_get_flags32(&create_flags, attrs,
 			 UVERBS_ATTR_CREATE_QP_FLAGS,
 			 IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK |
 			 IB_UVERBS_QP_CREATE_SCATTER_FCS |
@@ -201,7 +202,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	if (ret)
 		return ret;
 
-	ret = check_creation_flags(attr.qp_type, attr.create_flags);
+	ret = check_creation_flags(attr.qp_type, create_flags);
 	if (ret)
 		return ret;
 
@@ -211,7 +212,7 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 				       UVERBS_ATTR_CREATE_QP_SOURCE_QPN);
 		if (ret)
 			return ret;
-		attr.create_flags |= IB_QP_CREATE_SOURCE_QPN;
+		create_flags |= IB_QP_CREATE_SOURCE_QPN;
 	}
 
 	srq = uverbs_attr_get_obj(attrs,
@@ -234,16 +235,17 @@ static int UVERBS_HANDLER(UVERBS_METHOD_QP_CREATE)(
 	attr.send_cq = send_cq;
 	attr.recv_cq = recv_cq;
 	attr.xrcd = xrcd;
-	if (attr.create_flags & IB_UVERBS_QP_CREATE_SQ_SIG_ALL) {
+	if (create_flags & IB_UVERBS_QP_CREATE_SQ_SIG_ALL) {
 		/* This creation bit is uverbs one, need to mask before
 		 * calling drivers. It was added to prevent an extra user attr
 		 * only for that when using ioctl.
 		 */
-		attr.create_flags &= ~IB_UVERBS_QP_CREATE_SQ_SIG_ALL;
+		create_flags &= ~IB_UVERBS_QP_CREATE_SQ_SIG_ALL;
 		attr.sq_sig_type = IB_SIGNAL_ALL_WR;
 	} else {
 		attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	}
+	attr.create_flags = create_flags;
 
 	set_caps(&attr, &cap, true);
 	mutex_init(&obj->mcast_lock);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 989edc789633..1493ee9ed2b8 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1273,7 +1273,7 @@ static int bnxt_re_init_qp_attr(struct bnxt_re_qp *qp, struct bnxt_re_pd *pd,
 	qplqp->dpi = &rdev->dpi_privileged; /* Doorbell page */
 	if (init_attr->create_flags) {
 		ibdev_dbg(&rdev->ibdev,
-			  "QP create flags 0x%x not supported",
+			  "QP create flags 0x%llx not supported",
 			  init_attr->create_flags);
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 17fee1e73a45..c553bf0eb257 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -184,7 +184,7 @@ enum mlx4_ib_qp_flags {
 	/* Mellanox specific flags start from IB_QP_CREATE_RESERVED_START */
 	MLX4_IB_ROCE_V2_GSI_QP = MLX4_IB_QP_CREATE_ROCE_V2_GSI,
 	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
-	MLX4_IB_SRIOV_SQP = 1 << 31,
+	MLX4_IB_SRIOV_SQP = 1ULL << 31,
 };
 
 struct mlx4_ib_gid_entry {
@@ -342,7 +342,7 @@ struct mlx4_ib_qp {
 	int			buf_size;
 	struct mutex		mutex;
 	u16			xrcdn;
-	u32			flags;
+	u64			flags;
 	u8			port;
 	u8			alt_port;
 	u8			atomic_rd_en;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 884825b2e5f7..f3ad436bf5c9 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -287,7 +287,7 @@ static void mlx4_ib_wq_event(struct mlx4_qp *qp, enum mlx4_event type)
 			    type, qp->qpn);
 }
 
-static int send_wqe_overhead(enum mlx4_ib_qp_type type, u32 flags)
+static int send_wqe_overhead(enum mlx4_ib_qp_type type, u64 flags)
 {
 	/*
 	 * UD WQEs must have a datagram segment.
@@ -1514,7 +1514,7 @@ static int _mlx4_ib_create_qp(struct ib_pd *pd, struct mlx4_ib_qp *qp,
 			      struct ib_udata *udata)
 {
 	int err;
-	int sup_u_create_flags = MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
+	u64 sup_u_create_flags = MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK;
 	u16 xrcdn = 0;
 
 	if (init_attr->rwq_ind_tbl)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index ddb36c757074..295502692da2 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -500,7 +500,7 @@ struct mlx5_ib_qp {
 	 */
 	struct mutex		mutex;
 	/* cached variant of create_flags from struct ib_qp_init_attr */
-	u32			flags;
+	u64			flags;
 	u32			port;
 	u8			state;
 	int			max_inline_data;
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 80504db92ee9..f04adc18e63b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2938,7 +2938,7 @@ static int process_vendor_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return (flags) ? -EINVAL : 0;
 	}
 
-static void process_create_flag(struct mlx5_ib_dev *dev, int *flags, int flag,
+static void process_create_flag(struct mlx5_ib_dev *dev, u64 *flags, u64 flag,
 				bool cond, struct mlx5_ib_qp *qp)
 {
 	if (!(*flags & flag))
@@ -2958,7 +2958,8 @@ static void process_create_flag(struct mlx5_ib_dev *dev, int *flags, int flag,
 		*flags &= ~MLX5_IB_QP_CREATE_WC_TEST;
 		return;
 	}
-	mlx5_ib_dbg(dev, "Verbs create QP flag 0x%X is not supported\n", flag);
+	mlx5_ib_dbg(dev, "Verbs create QP flag 0x%llX is not supported\n",
+		    flag);
 }
 
 static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
@@ -2966,7 +2967,7 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 {
 	enum ib_qp_type qp_type = qp->type;
 	struct mlx5_core_dev *mdev = dev->mdev;
-	int create_flags = attr->create_flags;
+	u64 create_flags = attr->create_flags;
 	bool cond;
 
 	if (qp_type == MLX5_IB_QPT_DCT)
@@ -3024,7 +3025,7 @@ static int process_create_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			    true, qp);
 
 	if (create_flags) {
-		mlx5_ib_dbg(dev, "Create QP has unsupported flags 0x%X\n",
+		mlx5_ib_dbg(dev, "Create QP has unsupported flags 0x%llX\n",
 			    create_flags);
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index f83cd4a9d992..0dbfc3c9e274 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -206,7 +206,7 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 
 	if (init_attr->create_flags) {
 		dev_warn(&dev->pdev->dev,
-			 "invalid create queuepair flags %#x\n",
+			 "invalid create queuepair flags 0x%llx\n",
 			 init_attr->create_flags);
 		return -EOPNOTSUPP;
 	}
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 949cf4ffc536..cc2ddd4e6c12 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1140,16 +1140,15 @@ enum ib_qp_type {
 	IB_QPT_RESERVED10,
 };
 
+/*
+ * bits 0, 5, 6 and 7 may be set by old kernels and should not be used.
+ */
 enum ib_qp_create_flags {
-	IB_QP_CREATE_IPOIB_UD_LSO		= 1 << 0,
 	IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK	=
 		IB_UVERBS_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
 	IB_QP_CREATE_CROSS_CHANNEL              = 1 << 2,
 	IB_QP_CREATE_MANAGED_SEND               = 1 << 3,
 	IB_QP_CREATE_MANAGED_RECV               = 1 << 4,
-	IB_QP_CREATE_NETIF_QP			= 1 << 5,
-	IB_QP_CREATE_INTEGRITY_EN		= 1 << 6,
-	IB_QP_CREATE_NETDEV_USE			= 1 << 7,
 	IB_QP_CREATE_SCATTER_FCS		=
 		IB_UVERBS_QP_CREATE_SCATTER_FCS,
 	IB_QP_CREATE_CVLAN_STRIPPING		=
@@ -1159,7 +1158,18 @@ enum ib_qp_create_flags {
 		IB_UVERBS_QP_CREATE_PCI_WRITE_END_PADDING,
 	/* reserve bits 26-31 for low level drivers' internal use */
 	IB_QP_CREATE_RESERVED_START		= 1 << 26,
-	IB_QP_CREATE_RESERVED_END		= 1 << 31,
+	IB_QP_CREATE_RESERVED_END		= 1ULL << 31,
+
+	/* The below flags are used only by the kernel */
+
+	 /* The created QP will be used for IPoIB UD LSO */
+	IB_QP_CREATE_IPOIB_UD_LSO		= 1ULL << 32,
+	/* Create a QP that supports flow-steering */
+	IB_QP_CREATE_NETIF_QP			= 1ULL << 33,
+	/* The created QP can carry out integrity handover operations */
+	IB_QP_CREATE_INTEGRITY_EN		= 1ULL << 34,
+	/* Create an accelerated UD QP */
+	IB_QP_CREATE_NETDEV_USE			= 1ULL << 35,
 };
 
 /*
@@ -1179,7 +1189,7 @@ struct ib_qp_init_attr {
 	struct ib_qp_cap	cap;
 	enum ib_sig_type	sq_sig_type;
 	enum ib_qp_type		qp_type;
-	u32			create_flags;
+	u64			create_flags;
 
 	/*
 	 * Only needed for special QP types, or when using the RW API.
-- 
2.39.0

