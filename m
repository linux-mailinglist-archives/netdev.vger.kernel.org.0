Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56E97DB4A
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 14:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfHAMVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 08:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:32940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfHAMVv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 08:21:51 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D87BE20838;
        Thu,  1 Aug 2019 12:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564662110;
        bh=xopvglWHZ9srfXypHZJnDYACkd6ANdRZh69er4GNZd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mk32+yAJebJbsZ13eyd8/+8WNyVav5l+KiSfVM2jEV70KhE82Zmf3fmlx/5d93cfQ
         bZ4NgeNSwffDpo0q+Rv1/y+NjqV94xK9cPgwfERmX6OaL7Y2hd1OcjSJg5feJkrQFG
         nSYpwFvDBCK4k8OJqio3QhqdEcgp7OeiVO7jeRiw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next 2/3] IB/mlx5: Expose ODP for DC capabilities to user
Date:   Thu,  1 Aug 2019 15:21:38 +0300
Message-Id: <20190801122139.25224-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190801122139.25224-1-leon@kernel.org>
References: <20190801122139.25224-1-leon@kernel.org>
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
 include/uapi/rdma/mlx5-abi.h      | 2 ++
 2 files changed, 8 insertions(+)

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
index 624f5b53eb1f..12abc585f2ac 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -98,6 +98,7 @@ struct mlx5_ib_alloc_ucontext_req_v2 {
 enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_CORE_CLOCK_OFFSET = 1UL << 0,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY    = 1UL << 1,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DC_ODP_CAPS	   = 1UL << 2,
 };
 
 enum mlx5_user_cmds_supp_uhw {
@@ -147,6 +148,7 @@ struct mlx5_ib_alloc_ucontext_resp {
 	__u32	num_uars_per_page;
 	__u32	num_dyn_bfregs;
 	__u32	dump_fill_mkey;
+	__u32	dc_odp_caps;
 };
 
 struct mlx5_ib_alloc_pd_resp {
-- 
2.20.1

