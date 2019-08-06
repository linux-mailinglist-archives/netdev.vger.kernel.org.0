Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA81782D1C
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 09:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbfHFHsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 03:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfHFHsb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 03:48:31 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3476D206A2;
        Tue,  6 Aug 2019 07:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565077710;
        bh=wSob9UeSfITrkANzxhKX2TkJljgV5+yGRG2sdNOgVF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t2+M/refQjGV8zVlt1I08psa7pIK7bdEl2CFIETOMrvI/Lrih/rlEGw6BUfuPupRp
         /p1ka1upC/InCm48vAm9E+hBw6EUT3e9f+lPKKMrz36apfZC+uv4QGKnGlq6PX2CcD
         iuXXE+dPl03cKF02FsT5WJg9yVOHUga2ov3OftLI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v2 3/4] IB/mlx5: Expose ODP for DC capabilities to user
Date:   Tue,  6 Aug 2019 10:48:06 +0300
Message-Id: <20190806074807.9111-4-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190806074807.9111-1-leon@kernel.org>
References: <20190806074807.9111-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Return ODP capabilities for DC to user in alloc_context.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c | 6 ++++++
 include/uapi/rdma/mlx5-abi.h      | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 4a3d700cd783..a53e0dc7c17f 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1954,6 +1954,12 @@ static int mlx5_ib_alloc_ucontext(struct ib_ucontext *uctx,
 		resp.response_length += sizeof(resp.dump_fill_mkey);
 	}
 
+	if (field_avail(typeof(resp), dc_odp_caps, udata->outlen)) {
+		resp.dc_odp_caps = dev->dc_odp_caps;
+		resp.comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DC_ODP_CAPS;
+		resp.response_length += sizeof(resp.dc_odp_caps);
+	}
+
 	err = ib_copy_to_udata(udata, &resp, resp.response_length);
 	if (err)
 		goto out_mdev;
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 624f5b53eb1f..7cab806d7fa7 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -98,6 +98,7 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY    = 1UL << 1,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DC_ODP_CAPS	   = 1UL << 2,
 };
 
 enum mlx5_user_cmds_supp_uhw {
@@ -147,6 +148,8 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	num_uars_per_page;
 	__u32	num_dyn_bfregs;
 	__u32	dump_fill_mkey;
+	__u32	dc_odp_caps;
+	__u32   reserved;
 };
 
 struct mlx5_ib_alloc_pd_resp {
-- 
2.20.1

