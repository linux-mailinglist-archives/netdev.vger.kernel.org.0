Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF91B079D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDTLlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:41:48 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5823A21473;
        Mon, 20 Apr 2020 11:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382906;
        bh=EUtwYMjBkyDFQl2M4JngFVGhB/0gH3XFlWwGsGZh17k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjniwTUfcvPUSk/oL94OZKD+KvpAROrSfjTiFyJz0PS7cddTsLlNeeZULcrf3/tBt
         lJvewxU/k3niTn0WCJGYXgR+oVxV6sMFgbdP+IFC4XwarGKUPxK0PEFFXNBAVTk/k+
         U+S+hemln+c3bbz2ltNFx2lkXuzoPq6h+E+tptBM=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 01/24] net/mlx5: Update vport.c to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:13 +0300
Message-Id: <20200420114136.264924-2-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of vport.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/ib_virt.c          |   2 +-
 drivers/infiniband/hw/mlx5/mad.c              |   4 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   | 142 +++++++++---------
 include/linux/mlx5/vport.h                    |   3 +-
 4 files changed, 71 insertions(+), 80 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/ib_virt.c b/drivers/infiniband/hw/mlx5/ib_virt.c
index b61165359954..46b2d370fb3f 100644
--- a/drivers/infiniband/hw/mlx5/ib_virt.c
+++ b/drivers/infiniband/hw/mlx5/ib_virt.c
@@ -134,7 +134,7 @@ int mlx5_ib_get_vf_stats(struct ib_device *device, int vf,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_core_query_vport_counter(mdev, true, vf, port, out, out_sz);
+	err = mlx5_core_query_vport_counter(mdev, true, vf, port, out);
 	if (err)
 		goto ex;
 
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index f0ab6d7d8497..454ce5de2de7 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -187,8 +187,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
 			goto done;
 		}
 
-		err = mlx5_core_query_vport_counter(mdev, 0, 0,
-						    mdev_port_num, out_cnt, sz);
+		err = mlx5_core_query_vport_counter(mdev, 0, 0, mdev_port_num,
+						    out_cnt);
 		if (!err)
 			pma_cnt_ext_assign(pma_cnt_ext, out_cnt);
 	} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 23f879da9104..c107d92dc118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -40,10 +40,11 @@
 /* Mutex to hold while enabling or disabling RoCE */
 static DEFINE_MUTEX(mlx5_roce_en_lock);
 
-static int _mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod,
-				   u16 vport, u32 *out, int outlen)
+u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
 {
-	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {0};
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
+	int err;
 
 	MLX5_SET(query_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_VPORT_STATE);
@@ -52,14 +53,9 @@ static int _mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod,
 	if (vport)
 		MLX5_SET(query_vport_state_in, in, other_vport, 1);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
-}
-
-u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
-{
-	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {0};
-
-	_mlx5_query_vport_state(mdev, opmod, vport, out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+	if (err)
+		return 0;
 
 	return MLX5_GET(query_vport_state_out, out, state);
 }
@@ -67,8 +63,7 @@ u8 mlx5_query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
 int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 				  u16 vport, u8 other_vport, u8 state)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(modify_vport_state_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(modify_vport_state_in)] = {};
 
 	MLX5_SET(modify_vport_state_in, in, opcode,
 		 MLX5_CMD_OP_MODIFY_VPORT_STATE);
@@ -77,13 +72,13 @@ int mlx5_modify_vport_admin_state(struct mlx5_core_dev *mdev, u8 opmod,
 	MLX5_SET(modify_vport_state_in, in, other_vport, other_vport);
 	MLX5_SET(modify_vport_state_in, in, admin_state, state);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	return mlx5_cmd_exec_in(mdev, modify_vport_state, in);
 }
 
 static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
-					u32 *out, int outlen)
+					u32 *out)
 {
-	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)] = {0};
+	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)] = {};
 
 	MLX5_SET(query_nic_vport_context_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
@@ -91,26 +86,16 @@ static int mlx5_query_nic_vport_context(struct mlx5_core_dev *mdev, u16 vport,
 	if (vport)
 		MLX5_SET(query_nic_vport_context_in, in, other_vport, 1);
 
-	return mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
-}
-
-static int mlx5_modify_nic_vport_context(struct mlx5_core_dev *mdev, void *in,
-					 int inlen)
-{
-	u32 out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)] = {0};
-
-	MLX5_SET(modify_nic_vport_context_in, in, opcode,
-		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
-	return mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
+	return mlx5_cmd_exec_inout(mdev, query_nic_vport_context, in, out);
 }
 
 int mlx5_query_nic_vport_min_inline(struct mlx5_core_dev *mdev,
 				    u16 vport, u8 *min_inline)
 {
-	u32 out[MLX5_ST_SZ_DW(query_nic_vport_context_out)] = {0};
+	u32 out[MLX5_ST_SZ_DW(query_nic_vport_context_out)] = {};
 	int err;
 
-	err = mlx5_query_nic_vport_context(mdev, vport, out, sizeof(out));
+	err = mlx5_query_nic_vport_context(mdev, vport, out);
 	if (!err)
 		*min_inline = MLX5_GET(query_nic_vport_context_out, out,
 				       nic_vport_context.min_wqe_inline_mode);
@@ -139,8 +124,7 @@ EXPORT_SYMBOL_GPL(mlx5_query_min_inline);
 int mlx5_modify_nic_vport_min_inline(struct mlx5_core_dev *mdev,
 				     u16 vport, u8 min_inline)
 {
-	u32 in[MLX5_ST_SZ_DW(modify_nic_vport_context_in)] = {0};
-	int inlen = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in);
+	u32 in[MLX5_ST_SZ_DW(modify_nic_vport_context_in)] = {};
 	void *nic_vport_ctx;
 
 	MLX5_SET(modify_nic_vport_context_in, in,
@@ -152,23 +136,20 @@ int mlx5_modify_nic_vport_min_inline(struct mlx5_core_dev *mdev,
 				     in, nic_vport_context);
 	MLX5_SET(nic_vport_context, nic_vport_ctx,
 		 min_wqe_inline_mode, min_inline);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	return mlx5_modify_nic_vport_context(mdev, in, inlen);
+	return mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 }
 
 int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
 				     u16 vport, bool other, u8 *addr)
 {
-	int outlen = MLX5_ST_SZ_BYTES(query_nic_vport_context_out);
+	u32 out[MLX5_ST_SZ_DW(query_nic_vport_context_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)] = {};
 	u8 *out_addr;
-	u32 *out;
 	int err;
 
-	out = kvzalloc(outlen, GFP_KERNEL);
-	if (!out)
-		return -ENOMEM;
-
 	out_addr = MLX5_ADDR_OF(query_nic_vport_context_out, out,
 				nic_vport_context.permanent_address);
 
@@ -177,11 +158,10 @@ int mlx5_query_nic_vport_mac_address(struct mlx5_core_dev *mdev,
 	MLX5_SET(query_nic_vport_context_in, in, vport_number, vport);
 	MLX5_SET(query_nic_vport_context_in, in, other_vport, other);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, outlen);
+	err = mlx5_cmd_exec_inout(mdev, query_nic_vport_context, in, out);
 	if (!err)
 		ether_addr_copy(addr, &out_addr[2]);
 
-	kvfree(out);
 	return err;
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_vport_mac_address);
@@ -216,8 +196,10 @@ int mlx5_modify_nic_vport_mac_address(struct mlx5_core_dev *mdev,
 				permanent_address);
 
 	ether_addr_copy(&perm_mac[2], addr);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	kvfree(in);
 
@@ -235,7 +217,7 @@ int mlx5_query_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 *mtu)
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	err = mlx5_query_nic_vport_context(mdev, 0, out);
 	if (!err)
 		*mtu = MLX5_GET(query_nic_vport_context_out, out,
 				nic_vport_context.mtu);
@@ -257,8 +239,10 @@ int mlx5_modify_nic_vport_mtu(struct mlx5_core_dev *mdev, u16 mtu)
 
 	MLX5_SET(modify_nic_vport_context_in, in, field_select.mtu, 1);
 	MLX5_SET(modify_nic_vport_context_in, in, nic_vport_context.mtu, mtu);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	kvfree(in);
 	return err;
@@ -292,7 +276,7 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 		req_list_size = max_list_size;
 	}
 
-	out_sz = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in) +
+	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_in) +
 			req_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
 	out = kzalloc(out_sz, GFP_KERNEL);
@@ -332,7 +316,7 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 				   u8 addr_list[][ETH_ALEN],
 				   int list_size)
 {
-	u32 out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)];
+	u32 out[MLX5_ST_SZ_DW(modify_nic_vport_context_out)] = {};
 	void *nic_vport_ctx;
 	int max_list_size;
 	int in_sz;
@@ -350,7 +334,6 @@ int mlx5_modify_nic_vport_mac_list(struct mlx5_core_dev *dev,
 	in_sz = MLX5_ST_SZ_BYTES(modify_nic_vport_context_in) +
 		list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
-	memset(out, 0, sizeof(out));
 	in = kzalloc(in_sz, GFP_KERNEL);
 	if (!in)
 		return -ENOMEM;
@@ -442,7 +425,7 @@ int mlx5_query_nic_vport_system_image_guid(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;
 
-	mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	mlx5_query_nic_vport_context(mdev, 0, out);
 
 	*system_image_guid = MLX5_GET64(query_nic_vport_context_out, out,
 					nic_vport_context.system_image_guid);
@@ -462,7 +445,7 @@ int mlx5_query_nic_vport_node_guid(struct mlx5_core_dev *mdev, u64 *node_guid)
 	if (!out)
 		return -ENOMEM;
 
-	mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	mlx5_query_nic_vport_context(mdev, 0, out);
 
 	*node_guid = MLX5_GET64(query_nic_vport_context_out, out,
 				nic_vport_context.node_guid);
@@ -498,8 +481,10 @@ int mlx5_modify_nic_vport_node_guid(struct mlx5_core_dev *mdev,
 	nic_vport_context = MLX5_ADDR_OF(modify_nic_vport_context_in,
 					 in, nic_vport_context);
 	MLX5_SET64(nic_vport_context, nic_vport_context, node_guid, node_guid);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	kvfree(in);
 
@@ -516,7 +501,7 @@ int mlx5_query_nic_vport_qkey_viol_cntr(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;
 
-	mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	mlx5_query_nic_vport_context(mdev, 0, out);
 
 	*qkey_viol_cntr = MLX5_GET(query_nic_vport_context_out, out,
 				   nic_vport_context.qkey_violation_counter);
@@ -664,7 +649,7 @@ int mlx5_query_hca_vport_context(struct mlx5_core_dev *dev,
 				 struct mlx5_hca_vport_context *rep)
 {
 	int out_sz = MLX5_ST_SZ_BYTES(query_hca_vport_context_out);
-	int in[MLX5_ST_SZ_DW(query_hca_vport_context_in)] = {0};
+	int in[MLX5_ST_SZ_DW(query_hca_vport_context_in)] = {};
 	int is_group_manager;
 	void *out;
 	void *ctx;
@@ -691,7 +676,7 @@ int mlx5_query_hca_vport_context(struct mlx5_core_dev *dev,
 	if (MLX5_CAP_GEN(dev, num_ports) == 2)
 		MLX5_SET(query_hca_vport_context_in, in, port_num, port_num);
 
-	err = mlx5_cmd_exec(dev, in, sizeof(in), out,  out_sz);
+	err = mlx5_cmd_exec_inout(dev, query_hca_vport_context, in, out);
 	if (err)
 		goto ex;
 
@@ -788,7 +773,7 @@ int mlx5_query_nic_vport_promisc(struct mlx5_core_dev *mdev,
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_query_nic_vport_context(mdev, vport, out, outlen);
+	err = mlx5_query_nic_vport_context(mdev, vport, out);
 	if (err)
 		goto out;
 
@@ -825,8 +810,10 @@ int mlx5_modify_nic_vport_promisc(struct mlx5_core_dev *mdev,
 		 nic_vport_context.promisc_mc, promisc_mc);
 	MLX5_SET(modify_nic_vport_context_in, in,
 		 nic_vport_context.promisc_all, promisc_all);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	kvfree(in);
 
@@ -865,8 +852,10 @@ int mlx5_nic_vport_update_local_lb(struct mlx5_core_dev *mdev, bool enable)
 	if (MLX5_CAP_GEN(mdev, disable_local_lb_uc))
 		MLX5_SET(modify_nic_vport_context_in, in,
 			 field_select.disable_uc_local_lb, 1);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	if (!err)
 		mlx5_core_dbg(mdev, "%s local_lb\n",
@@ -888,7 +877,7 @@ int mlx5_nic_vport_query_local_lb(struct mlx5_core_dev *mdev, bool *status)
 	if (!out)
 		return -ENOMEM;
 
-	err = mlx5_query_nic_vport_context(mdev, 0, out, outlen);
+	err = mlx5_query_nic_vport_context(mdev, 0, out);
 	if (err)
 		goto out;
 
@@ -925,8 +914,10 @@ static int mlx5_nic_vport_update_roce_state(struct mlx5_core_dev *mdev,
 	MLX5_SET(modify_nic_vport_context_in, in, field_select.roce_en, 1);
 	MLX5_SET(modify_nic_vport_context_in, in, nic_vport_context.roce_en,
 		 state);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(mdev, in, inlen);
+	err = mlx5_cmd_exec_in(mdev, modify_nic_vport_context, in);
 
 	kvfree(in);
 
@@ -965,16 +956,15 @@ int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev)
 	mutex_unlock(&mlx5_roce_en_lock);
 	return err;
 }
-EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
+EXPORT_SYMBOL(mlx5_nic_vport_disable_roce);
 
 int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
-				  int vf, u8 port_num, void *out,
-				  size_t out_sz)
+				  int vf, u8 port_num, void *out)
 {
-	int	in_sz = MLX5_ST_SZ_BYTES(query_vport_counter_in);
-	int	is_group_manager;
-	void   *in;
-	int	err;
+	int in_sz = MLX5_ST_SZ_BYTES(query_vport_counter_in);
+	int is_group_manager;
+	void *in;
+	int err;
 
 	is_group_manager = MLX5_CAP_GEN(dev, vport_group_manager);
 	in = kvzalloc(in_sz, GFP_KERNEL);
@@ -997,7 +987,7 @@ int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
 	if (MLX5_CAP_GEN(dev, num_ports) == 2)
 		MLX5_SET(query_vport_counter_in, in, port_num, port_num);
 
-	err = mlx5_cmd_exec(dev, in, in_sz, out,  out_sz);
+	err = mlx5_cmd_exec_inout(dev, query_vport_counter, in, out);
 free:
 	kvfree(in);
 	return err;
@@ -1008,8 +998,8 @@ int mlx5_query_vport_down_stats(struct mlx5_core_dev *mdev, u16 vport,
 				u8 other_vport, u64 *rx_discard_vport_down,
 				u64 *tx_discard_vport_down)
 {
-	u32 out[MLX5_ST_SZ_DW(query_vnic_env_out)] = {0};
-	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {0};
+	u32 out[MLX5_ST_SZ_DW(query_vnic_env_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
 	int err;
 
 	MLX5_SET(query_vnic_env_in, in, opcode,
@@ -1018,7 +1008,7 @@ int mlx5_query_vport_down_stats(struct mlx5_core_dev *mdev, u16 vport,
 	MLX5_SET(query_vnic_env_in, in, vport_number, vport);
 	MLX5_SET(query_vnic_env_in, in, other_vport, other_vport);
 
-	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	err = mlx5_cmd_exec_inout(mdev, query_vnic_env, in, out);
 	if (err)
 		return err;
 
@@ -1035,11 +1025,10 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 				       struct mlx5_hca_vport_context *req)
 {
 	int in_sz = MLX5_ST_SZ_BYTES(modify_hca_vport_context_in);
-	u8 out[MLX5_ST_SZ_BYTES(modify_hca_vport_context_out)];
 	int is_group_manager;
+	void *ctx;
 	void *in;
 	int err;
-	void *ctx;
 
 	mlx5_core_dbg(dev, "vf %d\n", vf);
 	is_group_manager = MLX5_CAP_GEN(dev, vport_group_manager);
@@ -1047,7 +1036,6 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 	if (!in)
 		return -ENOMEM;
 
-	memset(out, 0, sizeof(out));
 	MLX5_SET(modify_hca_vport_context_in, in, opcode, MLX5_CMD_OP_MODIFY_HCA_VPORT_CONTEXT);
 	if (other_vport) {
 		if (is_group_manager) {
@@ -1074,7 +1062,7 @@ int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 	MLX5_SET(hca_vport_context, ctx, cap_mask1, req->cap_mask1);
 	MLX5_SET(hca_vport_context, ctx, cap_mask1_field_select,
 		 req->cap_mask1_perm);
-	err = mlx5_cmd_exec(dev, in, in_sz, out, sizeof(out));
+	err = mlx5_cmd_exec_in(dev, modify_hca_vport_context, in);
 ex:
 	kfree(in);
 	return err;
@@ -1103,8 +1091,10 @@ int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
 	MLX5_SET(modify_nic_vport_context_in, in,
 		 nic_vport_context.affiliation_criteria,
 		 MLX5_CAP_GEN(port_mdev, affiliate_nic_vport_criteria));
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(port_mdev, in, inlen);
+	err = mlx5_cmd_exec_in(port_mdev, modify_nic_vport_context, in);
 	if (err)
 		mlx5_nic_vport_disable_roce(port_mdev);
 
@@ -1129,8 +1119,10 @@ int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev)
 		 nic_vport_context.affiliated_vhca_id, 0);
 	MLX5_SET(modify_nic_vport_context_in, in,
 		 nic_vport_context.affiliation_criteria, 0);
+	MLX5_SET(modify_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_MODIFY_NIC_VPORT_CONTEXT);
 
-	err = mlx5_modify_nic_vport_context(port_mdev, in, inlen);
+	err = mlx5_cmd_exec_in(port_mdev, modify_nic_vport_context, in);
 	if (!err)
 		mlx5_nic_vport_disable_roce(port_mdev);
 
@@ -1170,4 +1162,4 @@ u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev)
 {
 	return MLX5_SPECIAL_VPORTS(dev) + mlx5_core_max_vfs(dev);
 }
-EXPORT_SYMBOL(mlx5_eswitch_get_total_vports);
+EXPORT_SYMBOL_GPL(mlx5_eswitch_get_total_vports);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index 16060fb9b5e5..8170da1e9f70 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -127,8 +127,7 @@ int mlx5_query_vport_down_stats(struct mlx5_core_dev *mdev, u16 vport,
 				u8 other_vport, u64 *rx_discard_vport_down,
 				u64 *tx_discard_vport_down);
 int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
-				  int vf, u8 port_num, void *out,
-				  size_t out_sz);
+				  int vf, u8 port_num, void *out);
 int mlx5_core_modify_hca_vport_context(struct mlx5_core_dev *dev,
 				       u8 other_vport, u8 port_num,
 				       int vf,
-- 
2.25.2

