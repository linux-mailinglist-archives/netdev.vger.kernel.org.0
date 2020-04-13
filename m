Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCEDF1A672D
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgDMNhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgDMNhO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 09:37:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E29C820774;
        Mon, 13 Apr 2020 13:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785033;
        bh=XeJoBjw65CdEI/2PWky6smS2GhC4yYBYaFnK7FUp+T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYmvZLZjIKFSoXB54vdwICeSlLAMRwvA0N6ws9uV5QG3O6+1BeYyyDt8PB5ws6GBf
         HBol+62axZnl6Vr46HUXwflFNIoZl/exj40tP7DrwWwdSug0BPW+7tE8IXVp/KvFsa
         MbeSwKuYbP3hBT9YnBW+msXU2FK92ZMQkjTZlLy0=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v2 1/6] net/mlx5: Refactor HCA capability set flow
Date:   Mon, 13 Apr 2020 16:36:58 +0300
Message-Id: <20200413133703.932731-2-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413133703.932731-1-leon@kernel.org>
References: <20200413133703.932731-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Reduce the amount of kzalloc/kfree cycles by allocating
command structure in the parent function and leverage the
knowledge that set_caps() is called for HCA capabilities
only with specific HW structure as parameter to calculate
mailbox size.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 66 +++++++------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7af4210c1b96..8b9182add689 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -407,20 +407,19 @@ int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type)
 	return mlx5_core_get_caps_mode(dev, cap_type, HCA_CAP_OPMOD_GET_MAX);
 }
 
-static int set_caps(struct mlx5_core_dev *dev, void *in, int in_sz, int opmod)
+static int set_caps(struct mlx5_core_dev *dev, void *in, int opmod)
 {
-	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(set_hca_cap_out)] = {};
 
 	MLX5_SET(set_hca_cap_in, in, opcode, MLX5_CMD_OP_SET_HCA_CAP);
 	MLX5_SET(set_hca_cap_in, in, op_mod, opmod << 1);
-	return mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
+	return mlx5_cmd_exec(dev, in, MLX5_ST_SZ_BYTES(set_hca_cap_in), out,
+			     sizeof(out));
 }
 
-static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
+static int handle_hca_cap_atomic(struct mlx5_core_dev *dev, void *set_ctx)
 {
-	void *set_ctx;
 	void *set_hca_cap;
-	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	int req_endianness;
 	int err;
 
@@ -439,27 +438,19 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
 	if (req_endianness != MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS)
 		return 0;
 
-	set_ctx = kzalloc(set_sz, GFP_KERNEL);
-	if (!set_ctx)
-		return -ENOMEM;
-
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
 
 	/* Set requestor to host endianness */
 	MLX5_SET(atomic_caps, set_hca_cap, atomic_req_8B_endianness_mode,
 		 MLX5_ATOMIC_REQ_MODE_HOST_ENDIANNESS);
 
-	err = set_caps(dev, set_ctx, set_sz, MLX5_SET_HCA_CAP_OP_MOD_ATOMIC);
-
-	kfree(set_ctx);
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ATOMIC);
 	return err;
 }
 
-static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
+static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	void *set_hca_cap;
-	void *set_ctx;
-	int set_sz;
 	bool do_set = false;
 	int err;
 
@@ -471,11 +462,6 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	if (err)
 		return err;
 
-	set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
-	set_ctx = kzalloc(set_sz, GFP_KERNEL);
-	if (!set_ctx)
-		return -ENOMEM;
-
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
 	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ODP],
 	       MLX5_ST_SZ_BYTES(odp_cap));
@@ -505,29 +491,20 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
 	ODP_CAP_SET_MAX(dev, dc_odp_caps.atomic);
 
 	if (do_set)
-		err = set_caps(dev, set_ctx, set_sz,
-			       MLX5_SET_HCA_CAP_OP_MOD_ODP);
-
-	kfree(set_ctx);
+		err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ODP);
 
 	return err;
 }
 
-static int handle_hca_cap(struct mlx5_core_dev *dev)
+static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
-	void *set_ctx = NULL;
 	struct mlx5_profile *prof = dev->profile;
-	int err = -ENOMEM;
-	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
 	void *set_hca_cap;
-
-	set_ctx = kzalloc(set_sz, GFP_KERNEL);
-	if (!set_ctx)
-		goto query_ex;
+	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
 	if (err)
-		goto query_ex;
+		return err;
 
 	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx,
 				   capability);
@@ -578,37 +555,42 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
 			 num_vhca_ports,
 			 MLX5_CAP_GEN_MAX(dev, num_vhca_ports));
 
-	err = set_caps(dev, set_ctx, set_sz,
-		       MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
-
-query_ex:
-	kfree(set_ctx);
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 	return err;
 }
 
 static int set_hca_cap(struct mlx5_core_dev *dev)
 {
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *set_ctx;
 	int err;
 
-	err = handle_hca_cap(dev);
+	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	err = handle_hca_cap(dev, set_ctx);
 	if (err) {
 		mlx5_core_err(dev, "handle_hca_cap failed\n");
 		goto out;
 	}
 
-	err = handle_hca_cap_atomic(dev);
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_atomic(dev, set_ctx);
 	if (err) {
 		mlx5_core_err(dev, "handle_hca_cap_atomic failed\n");
 		goto out;
 	}
 
-	err = handle_hca_cap_odp(dev);
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_odp(dev, set_ctx);
 	if (err) {
 		mlx5_core_err(dev, "handle_hca_cap_odp failed\n");
 		goto out;
 	}
 
 out:
+	kfree(set_ctx);
 	return err;
 }
 
-- 
2.25.2

