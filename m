Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 614173671BE
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244945AbhDURsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244869AbhDURsN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7208E61455;
        Wed, 21 Apr 2021 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027259;
        bh=l5awlyuJvojEyVCqrYWh99f1hLxtq4tEkVWox2A7zS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UomXTBpCzDttI/LgVjC/bzYk1E6abZVaqUPKxLiLt/I2wNXCkUzgC+PMB3JHVyIMh
         6TzrToCWIVJF3hwUNBqPrhqesiRh9xoMG1UYGuzH8FyrEh4gxlEOp8f5NRtUXjnO92
         U1bx3P8J0B7T8v+KTFra0NaKB0W+eCyHW86lvD64ZIwSv796k9t4T3KI015YGrMR6z
         TGYhqLIycWybNk1K4XLcNlP5Msh9RLF8m+9Jxiy1tFFTgvtBqf8Ko+xbB7gculXqa5
         Mu0vuCmwOeqrOA/9nHYkIFVTJUIRy4Hjx842nu+3Homrvkb1tApecUw9YOT0oWNW7L
         4e0RI0O/XyxFA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/11] net/mlx5: E-Switch, Consider SF ports of host PF
Date:   Wed, 21 Apr 2021 10:47:16 -0700
Message-Id: <20210421174723.159428-5-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Query SF vports count and base id of host PF from the firmware.

Account these ports in the total port calculation whenever it is non
zero.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 55 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 90d8bda87579..570f2280823c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1566,6 +1566,48 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 	up_write(&esw->mode_lock);
 }
 
+static int mlx5_query_hca_cap_host_pf(struct mlx5_core_dev *dev, void *out)
+{
+	u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
+	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
+
+	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
+	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
+	MLX5_SET(query_hca_cap_in, in, function_id, MLX5_VPORT_PF);
+	MLX5_SET(query_hca_cap_in, in, other_function, true);
+	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
+}
+
+int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *sf_base_id)
+
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_ctx;
+	void *hca_caps;
+	int err;
+
+	if (!mlx5_core_is_ecpf(dev)) {
+		*max_sfs = 0;
+		return 0;
+	}
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	err = mlx5_query_hca_cap_host_pf(dev, query_ctx);
+	if (err)
+		goto out_free;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	*max_sfs = MLX5_GET(cmd_hca_cap, hca_caps, max_num_sf);
+	*sf_base_id = MLX5_GET(cmd_hca_cap, hca_caps, sf_base_id);
+
+out_free:
+	kfree(query_ctx);
+	return err;
+}
+
 static int mlx5_esw_vport_alloc(struct mlx5_eswitch *esw, struct mlx5_core_dev *dev,
 				int index, u16 vport_num)
 {
@@ -1612,6 +1654,7 @@ static void mlx5_esw_vports_cleanup(struct mlx5_eswitch *esw)
 static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 {
 	struct mlx5_core_dev *dev = esw->dev;
+	u16 max_host_pf_sfs;
 	u16 base_sf_num;
 	int idx = 0;
 	int err;
@@ -1642,6 +1685,18 @@ static int mlx5_esw_vports_init(struct mlx5_eswitch *esw)
 		xa_set_mark(&esw->vports, base_sf_num + i, MLX5_ESW_VPT_SF);
 		idx++;
 	}
+
+	err = mlx5_esw_sf_max_hpf_functions(dev, &max_host_pf_sfs, &base_sf_num);
+	if (err)
+		goto err;
+	for (i = 0; i < max_host_pf_sfs; i++) {
+		err = mlx5_esw_vport_alloc(esw, dev, idx, base_sf_num + i);
+		if (err)
+			goto err;
+		xa_set_mark(&esw->vports, base_sf_num + i, MLX5_ESW_VPT_SF);
+		idx++;
+	}
+
 	if (mlx5_ecpf_vport_exists(dev)) {
 		err = mlx5_esw_vport_alloc(esw, dev, idx, MLX5_VPORT_ECPF);
 		if (err)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 7b5f9b8dc7df..0812cee8f603 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -668,6 +668,7 @@ void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num
 int mlx5_esw_offloads_sf_vport_enable(struct mlx5_eswitch *esw, struct devlink_port *dl_port,
 				      u16 vport_num, u32 sfnum);
 void mlx5_esw_offloads_sf_vport_disable(struct mlx5_eswitch *esw, u16 vport_num);
+int mlx5_esw_sf_max_hpf_functions(struct mlx5_core_dev *dev, u16 *max_sfs, u16 *sf_base_id);
 
 int mlx5_esw_vport_vhca_id_set(struct mlx5_eswitch *esw, u16 vport_num);
 void mlx5_esw_vport_vhca_id_clear(struct mlx5_eswitch *esw, u16 vport_num);
-- 
2.30.2

