Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB2A3AE3B8
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbhFUHIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhFUHIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 03:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE56E61156;
        Mon, 21 Jun 2021 07:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624259187;
        bh=hb6D3sgBTVn2DYOmVk2efYeS2ZlIhQzxF1c8OG44nGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goijfz0bl5IOQKaBoKXPq/jse3a3iWbjlHCs8FdS/diE4MWRYJO8ZpBqU3hZJTK5o
         o31Q5K9nmFZbFeulU63lDpN3WSoKMC7ro5msTpUN7S/ia6zDKHEz0xCAkxvzrpggAb
         dI3p6Ru9nESV1IveKULkuCdiZmV+QcBgNcHWifhAt+8FzeBhZXmyhpObu/Cezx7jN1
         7xFNexbYVkhN2kZTduznrR4uQNc2YVYuFgqjIm2KFDDTF9Ge6Qu5t416XFvg6XV+JN
         46lMHqc4qCJEgnROK2svvZR2iL5EHNtDXFIXcqdxtkvWaP8FUefvKwcp7aOhDK5vEq
         g5rSsAUOjADvg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lior Nahmanson <liorna@mellanox.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Meir Lichtinger <meirl@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 3/3] RDMA/mlx5: Add DCS offload support
Date:   Mon, 21 Jun 2021 10:06:16 +0300
Message-Id: <491c2c2afdb5b07de7f03eab3f93cf0704549dbc.1624258894.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624258894.git.leonro@nvidia.com>
References: <cover.1624258894.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@mellanox.com>

DCS is an offload to SW load balancing of DC initiator work requests.

A single DCI can be connected to only one target at the time and can't
start new connection until the previous work request is completed.
This limitation will cause to delay when the initiator process needs to
transfer data to multiple targets at the same time.
The SW solution is to use a process that handling and spreading the work
request on many DCIs according to destinations.

This feature is an offload to this process and coming to reduce the load
from the CPU and improve the performance.

Reviewed-by: Meir Lichtinger <meirl@nvidia.com>
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c | 10 ++++++++++
 drivers/infiniband/hw/mlx5/qp.c   | 11 +++++++++++
 include/uapi/rdma/mlx5-abi.h      | 17 +++++++++++++++--
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b145e477e3ba..c12517b63a8d 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1174,6 +1174,16 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}
 
+	if (offsetofend(typeof(resp), dci_streams_caps) <= uhw_outlen) {
+		resp.response_length += sizeof(resp.dci_streams_caps);
+
+		resp.dci_streams_caps.max_log_num_concurent =
+			MLX5_CAP_GEN(mdev, log_max_dci_stream_channels);
+
+		resp.dci_streams_caps.max_log_num_errored =
+			MLX5_CAP_GEN(mdev, log_max_dci_errored_streams);
+	}
+
 	if (uhw_outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 65a380543f5a..7b545eac37a3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2056,6 +2056,13 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		MLX5_SET(qpc, qpc, log_rq_size, ilog2(qp->rq.wqe_cnt));
 	}
 
+	if (qp->flags_en & MLX5_QP_FLAG_DCI_STREAM) {
+		MLX5_SET(qpc, qpc, log_num_dci_stream_channels,
+			 ucmd->dci_streams.log_num_concurent);
+		MLX5_SET(qpc, qpc, log_num_dci_errored_streams,
+			 ucmd->dci_streams.log_num_errored);
+	}
+
 	MLX5_SET(qpc, qpc, ts_format, ts_format);
 	MLX5_SET(qpc, qpc, rq_type, get_rx_type(qp, init_attr));
 
@@ -2799,6 +2806,10 @@ static int process_vendor_flags(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	process_vendor_flag(dev, &flags, MLX5_QP_FLAG_TYPE_DCI, true, qp);
 	process_vendor_flag(dev, &flags, MLX5_QP_FLAG_TYPE_DCT, true, qp);
+	process_vendor_flag(dev, &flags, MLX5_QP_FLAG_DCI_STREAM,
+			    MLX5_CAP_GEN(mdev, log_max_dci_stream_channels) &&
+			    MLX5_CAP_GEN(mdev, log_max_dci_errored_streams),
+			    qp);
 
 	process_vendor_flag(dev, &flags, MLX5_QP_FLAG_SIGNATURE, true, qp);
 	process_vendor_flag(dev, &flags, MLX5_QP_FLAG_SCATTER_CQE,
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 995faf8f44bd..6f54ab3d99e5 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -50,6 +50,7 @@ enum {
 	MLX5_QP_FLAG_ALLOW_SCATTER_CQE	= 1 << 8,
 	MLX5_QP_FLAG_PACKET_BASED_CREDIT_MODE	= 1 << 9,
 	MLX5_QP_FLAG_UAR_PAGE_INDEX = 1 << 10,
+	MLX5_QP_FLAG_DCI_STREAM	= 1 << 11,
 };
 
 enum {
@@ -237,6 +238,11 @@ struct mlx5_ib_striding_rq_caps {
 	__u32 reserved;
 };
 
+struct mlx5_ib_dci_streams_caps {
+	__u8 max_log_num_concurent;
+	__u8 max_log_num_errored;
+};
+
 enum mlx5_ib_query_dev_resp_flags {
 	/* Support 128B CQE compression */
 	MLX5_IB_QUERY_DEV_RESP_FLAGS_CQE_128B_COMP = 1 << 0,
@@ -265,7 +271,8 @@ struct mlx5_ib_query_device_resp {
 	struct mlx5_ib_sw_parsing_caps sw_parsing_caps;
 	struct mlx5_ib_striding_rq_caps striding_rq_caps;
 	__u32	tunnel_offloads_caps; /* enum mlx5_ib_tunnel_offloads */
-	__u32	reserved;
+	struct  mlx5_ib_dci_streams_caps dci_streams_caps;
+	__u16 reserved;
 };
 
 enum mlx5_ib_create_cq_flags {
@@ -311,6 +318,11 @@ struct mlx5_ib_create_srq_resp {
 	__u32	reserved;
 };
 
+struct mlx5_ib_create_qp_dci_streams {
+	__u8 log_num_concurent;
+	__u8 log_num_errored;
+};
+
 struct mlx5_ib_create_qp {
 	__aligned_u64 buf_addr;
 	__aligned_u64 db_addr;
@@ -325,7 +337,8 @@ struct mlx5_ib_create_qp {
 		__aligned_u64 access_key;
 	};
 	__u32  ece_options;
-	__u32  reserved;
+	struct  mlx5_ib_create_qp_dci_streams dci_streams;
+	__u16 reserved;
 };
 
 /* RX Hash function flags */
-- 
2.31.1

