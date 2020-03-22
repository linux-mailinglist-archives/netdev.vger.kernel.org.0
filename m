Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 190A118E7DB
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 10:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgCVJa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 05:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgCVJa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 05:30:59 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B27020753;
        Sun, 22 Mar 2020 09:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584869457;
        bh=YYHQsucDnC/2E3qSeyqr0AWH6szActMiGxMBpd2Pm14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StvHzNx9j0tsBhooVf89CrA+1/P9rWfnMg3dZ6PIXf+i4MDSl6pViMpLap8u9Nevs
         G3X7RAXGJ/BiR679uVCfsZqJFVRZPAVL/Furv2dmkBsQTT1deUon/+zD7YYzE+0pqN
         QQnaiH1Ar+H6ztEqwa552SUn9oj4/MPvOLGqovn8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v1 1/7] net/mlx5: Refactor HCA capability set flow
Date:   Sun, 22 Mar 2020 11:30:25 +0200
Message-Id: <20200322093031.918447-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200322093031.918447-1-leon@kernel.org>
References: <20200322093031.918447-1-leon@kernel.org>
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
index 6b38ec72215a..150a4a67e572 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -406,20 +406,19 @@ int mlx5_core_get_caps(struct mlx5_core_dev *dev, enum mlx5_cap_type cap_type)
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

@@ -438,27 +437,19 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
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

@@ -470,11 +461,6 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
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
@@ -504,29 +490,20 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
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
@@ -577,37 +554,42 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
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
2.24.1

