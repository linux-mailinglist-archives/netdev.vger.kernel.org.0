Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6808D13C156
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAOMoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:44:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMoF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:44:05 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91185222C3;
        Wed, 15 Jan 2020 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092244;
        bh=HMU3TpihDFu9dCAIxh/lvjlcCOKgEoXnyTCX47FJGHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeF5Wj2uv1lXEzf0O0dmB5u7mJIxR4Adda5G1RzEyeBaf/ENgS3q0G8rurnTqLhm4
         VK2fenj18GD1dH7SyOp/R+TdjgnCTMpV+XsdMyroFP91XhES+jP4s7hw7eTjjhMHMp
         PEFDehUYMn7gAbuNmBOYmoQrCG1G0+9TYwj2f/Hg=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 05/10] RDMA/mlx5: Don't fake udata for kernel path
Date:   Wed, 15 Jan 2020 14:43:35 +0200
Message-Id: <20200115124340.79108-6-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Kernel paths must not set udata and provide NULL pointer,
instead of faking zeroed udata struct.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 34 +++++++++++++++----------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5d41a2c69400..e34531d5c806 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -815,6 +815,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props,
 				struct ib_udata *uhw)
 {
+	size_t uhw_outlen = (uhw) ? uhw->outlen : 0;
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	struct mlx5_core_dev *mdev = dev->mdev;
 	int err = -ENOMEM;
@@ -828,12 +829,12 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	u64 max_tso;

 	resp_len = sizeof(resp.comp_mask) + sizeof(resp.response_length);
-	if (uhw->outlen && uhw->outlen < resp_len)
+	if (uhw_outlen && uhw_outlen < resp_len)
 		return -EINVAL;

 	resp.response_length = resp_len;

-	if (uhw->inlen && !ib_is_udata_cleared(uhw, 0, uhw->inlen))
+	if (uhw && uhw->inlen && !ib_is_udata_cleared(uhw, 0, uhw->inlen))
 		return -EINVAL;

 	memset(props, 0, sizeof(*props));
@@ -897,7 +898,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			props->raw_packet_caps |=
 				IB_RAW_PACKET_CAP_CVLAN_STRIPPING;

-		if (field_avail(typeof(resp), tso_caps, uhw->outlen)) {
+		if (field_avail(typeof(resp), tso_caps, uhw_outlen)) {
 			max_tso = MLX5_CAP_ETH(mdev, max_lso_cap);
 			if (max_tso) {
 				resp.tso_caps.max_tso = 1 << max_tso;
@@ -907,7 +908,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			}
 		}

-		if (field_avail(typeof(resp), rss_caps, uhw->outlen)) {
+		if (field_avail(typeof(resp), rss_caps, uhw_outlen)) {
 			resp.rss_caps.rx_hash_function =
 						MLX5_RX_HASH_FUNC_TOEPLITZ;
 			resp.rss_caps.rx_hash_fields_mask =
@@ -927,9 +928,9 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			resp.response_length += sizeof(resp.rss_caps);
 		}
 	} else {
-		if (field_avail(typeof(resp), tso_caps, uhw->outlen))
+		if (field_avail(typeof(resp), tso_caps, uhw_outlen))
 			resp.response_length += sizeof(resp.tso_caps);
-		if (field_avail(typeof(resp), rss_caps, uhw->outlen))
+		if (field_avail(typeof(resp), rss_caps, uhw_outlen))
 			resp.response_length += sizeof(resp.rss_caps);
 	}

@@ -1054,7 +1055,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 						MLX5_MAX_CQ_PERIOD;
 	}

-	if (field_avail(typeof(resp), cqe_comp_caps, uhw->outlen)) {
+	if (field_avail(typeof(resp), cqe_comp_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.cqe_comp_caps);

 		if (MLX5_CAP_GEN(dev->mdev, cqe_compression)) {
@@ -1072,7 +1073,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}

-	if (field_avail(typeof(resp), packet_pacing_caps, uhw->outlen) &&
+	if (field_avail(typeof(resp), packet_pacing_caps, uhw_outlen) &&
 	    raw_support) {
 		if (MLX5_CAP_QOS(mdev, packet_pacing) &&
 		    MLX5_CAP_GEN(mdev, qos)) {
@@ -1091,7 +1092,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 	}

 	if (field_avail(typeof(resp), mlx5_ib_support_multi_pkt_send_wqes,
-			uhw->outlen)) {
+			uhw_outlen)) {
 		if (MLX5_CAP_ETH(mdev, multi_pkt_send_wqe))
 			resp.mlx5_ib_support_multi_pkt_send_wqes =
 				MLX5_IB_ALLOW_MPW;
@@ -1104,7 +1105,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 			sizeof(resp.mlx5_ib_support_multi_pkt_send_wqes);
 	}

-	if (field_avail(typeof(resp), flags, uhw->outlen)) {
+	if (field_avail(typeof(resp), flags, uhw_outlen)) {
 		resp.response_length += sizeof(resp.flags);

 		if (MLX5_CAP_GEN(mdev, cqe_compression_128))
@@ -1120,8 +1121,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		resp.flags |= MLX5_IB_QUERY_DEV_RESP_FLAGS_SCAT2CQE_DCT;
 	}

-	if (field_avail(typeof(resp), sw_parsing_caps,
-			uhw->outlen)) {
+	if (field_avail(typeof(resp), sw_parsing_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.sw_parsing_caps);
 		if (MLX5_CAP_ETH(mdev, swp)) {
 			resp.sw_parsing_caps.sw_parsing_offloads |=
@@ -1141,7 +1141,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}

-	if (field_avail(typeof(resp), striding_rq_caps, uhw->outlen) &&
+	if (field_avail(typeof(resp), striding_rq_caps, uhw_outlen) &&
 	    raw_support) {
 		resp.response_length += sizeof(resp.striding_rq_caps);
 		if (MLX5_CAP_GEN(mdev, striding_rq)) {
@@ -1164,8 +1164,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 		}
 	}

-	if (field_avail(typeof(resp), tunnel_offloads_caps,
-			uhw->outlen)) {
+	if (field_avail(typeof(resp), tunnel_offloads_caps, uhw_outlen)) {
 		resp.response_length += sizeof(resp.tunnel_offloads_caps);
 		if (MLX5_CAP_ETH(mdev, tunnel_stateless_vxlan))
 			resp.tunnel_offloads_caps |=
@@ -1186,7 +1185,7 @@ static int mlx5_ib_query_device(struct ib_device *ibdev,
 				MLX5_IB_TUNNELED_OFFLOADS_MPLS_UDP;
 	}

-	if (uhw->outlen) {
+	if (uhw_outlen) {
 		err = ib_copy_to_udata(uhw, &resp, resp.response_length);

 		if (err)
@@ -4790,7 +4789,6 @@ static int __get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	struct ib_device_attr *dprops = NULL;
 	struct ib_port_attr *pprops = NULL;
 	int err = -ENOMEM;
-	struct ib_udata uhw = {.inlen = 0, .outlen = 0};

 	pprops = kzalloc(sizeof(*pprops), GFP_KERNEL);
 	if (!pprops)
@@ -4800,7 +4798,7 @@ static int __get_port_caps(struct mlx5_ib_dev *dev, u8 port)
 	if (!dprops)
 		goto out;

-	err = mlx5_ib_query_device(&dev->ib_dev, dprops, &uhw);
+	err = mlx5_ib_query_device(&dev->ib_dev, dprops, NULL);
 	if (err) {
 		mlx5_ib_warn(dev, "query_device failed %d\n", err);
 		goto out;
--
2.20.1

