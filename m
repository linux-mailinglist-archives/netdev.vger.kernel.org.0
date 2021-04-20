Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081763650D0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhDTDV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:21:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234265AbhDTDVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1475E613B4;
        Tue, 20 Apr 2021 03:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618888840;
        bh=hxpSVyVtMyPrAyYy5AWo1Z9wtuIaPg8oSFk5ItnJHNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hfyGN5u3WxBmMggsBOSFp39C/LVXmsY8PKD5pFN2n/gVLKQiUpojUHUaVnUEGV58/
         /4otVi8jg9t3dvbD0e/b2lMXgatPrZo/1ZpPXlT4cvZ3jm0lLRnPVAWbs3RhxSYSYp
         M20JSOfOlJkQay2VMOFpc4t0skyAZ/z4cGS32N4Y7tF3yh0GaiaIZc9kFSaUqywjFo
         HITMlIp5OaYimMl/Rcxc/FiYeNs5MOipKTgokJzGF76KKJFg4L2EJfiPA734/PCFfM
         hPVjJtXHVZVeDrktI+S2hwGDpUpieKWYeIfRD+yzu+ynHXlYNyxDTMMzcpK/g692ig
         zA9ljWsqlwDmQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: DR, Add support for force-loopback QP
Date:   Mon, 19 Apr 2021 20:20:17 -0700
Message-Id: <20210420032018.58639-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210420032018.58639-1-saeed@kernel.org>
References: <20210420032018.58639-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

When supported by the device, SW steering RoCE RC QP that is used to
write/read to/from ICM will be created with force-loopback attribute.
Such QP doesn't require GID index upon creation.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c      | 36 +++++++++++++++++++
 .../mellanox/mlx5/core/steering/dr_send.c     | 34 +++++++++++++++---
 .../mellanox/mlx5/core/steering/dr_types.h    |  7 ++++
 include/linux/mlx5/mlx5_ifc.h                 |  7 ++--
 4 files changed, 77 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 6f9d7aa9fb4c..68d898e144fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -85,15 +85,51 @@ int mlx5dr_cmd_query_esw_caps(struct mlx5_core_dev *mdev,
 	return 0;
 }
 
+static int dr_cmd_query_nic_vport_roce_en(struct mlx5_core_dev *mdev,
+					  u16 vport, bool *roce_en)
+{
+	u32 out[MLX5_ST_SZ_DW(query_nic_vport_context_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_nic_vport_context_in)] = {};
+	int err;
+
+	MLX5_SET(query_nic_vport_context_in, in, opcode,
+		 MLX5_CMD_OP_QUERY_NIC_VPORT_CONTEXT);
+	MLX5_SET(query_nic_vport_context_in, in, vport_number, vport);
+	MLX5_SET(query_nic_vport_context_in, in, other_vport, !!vport);
+
+	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
+	if (err)
+		return err;
+
+	*roce_en = MLX5_GET(query_nic_vport_context_out, out,
+			    nic_vport_context.roce_en);
+	return 0;
+}
+
 int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 			    struct mlx5dr_cmd_caps *caps)
 {
+	bool roce_en;
+	int err;
+
 	caps->prio_tag_required	= MLX5_CAP_GEN(mdev, prio_tag_required);
 	caps->eswitch_manager	= MLX5_CAP_GEN(mdev, eswitch_manager);
 	caps->gvmi		= MLX5_CAP_GEN(mdev, vhca_id);
 	caps->flex_protocols	= MLX5_CAP_GEN(mdev, flex_parser_protocols);
 	caps->sw_format_ver	= MLX5_CAP_GEN(mdev, steering_format_version);
 
+	if (MLX5_CAP_GEN(mdev, roce)) {
+		err = dr_cmd_query_nic_vport_roce_en(mdev, 0, &roce_en);
+		if (err)
+			return err;
+
+		caps->roce_caps.roce_en = roce_en;
+		caps->roce_caps.fl_rc_qp_when_roce_disabled =
+			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_disabled);
+		caps->roce_caps.fl_rc_qp_when_roce_enabled =
+			MLX5_CAP_ROCE(mdev, fl_rc_qp_when_roce_enabled);
+	}
+
 	if (caps->flex_protocols & MLX5_FLEX_PARSER_ICMP_V4_ENABLED) {
 		caps->flex_parser_id_icmp_dw0 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw0);
 		caps->flex_parser_id_icmp_dw1 = MLX5_CAP_GEN(mdev, flex_parser_id_icmp_dw1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 37377d668057..69d623bedefe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -32,6 +32,7 @@ struct dr_qp_rtr_attr {
 	u8 min_rnr_timer;
 	u8 sgid_index;
 	u16 udp_src_port;
+	u8 fl:1;
 };
 
 struct dr_qp_rts_attr {
@@ -650,6 +651,7 @@ static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
 			 attr->udp_src_port);
 
 	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, attr->port_num);
+	MLX5_SET(qpc, qpc, primary_address_path.fl, attr->fl);
 	MLX5_SET(qpc, qpc, min_rnr_nak, 1);
 
 	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
@@ -658,6 +660,19 @@ static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
 	return mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 }
 
+static bool dr_send_allow_fl(struct mlx5dr_cmd_caps *caps)
+{
+	/* Check whether RC RoCE QP creation with force loopback is allowed.
+	 * There are two separate capability bits for this:
+	 *  - force loopback when RoCE is enabled
+	 *  - force loopback when RoCE is disabled
+	 */
+	return ((caps->roce_caps.roce_en &&
+		 caps->roce_caps.fl_rc_qp_when_roce_enabled) ||
+		(!caps->roce_caps.roce_en &&
+		 caps->roce_caps.fl_rc_qp_when_roce_disabled));
+}
+
 static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 {
 	struct mlx5dr_qp *dr_qp = dmn->send_ring->qp;
@@ -676,17 +691,26 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 	}
 
 	/* RTR */
-	ret = mlx5dr_cmd_query_gid(dmn->mdev, port, gid_index, &rtr_attr.dgid_attr);
-	if (ret)
-		return ret;
-
 	rtr_attr.mtu		= mtu;
 	rtr_attr.qp_num		= dr_qp->qpn;
 	rtr_attr.min_rnr_timer	= 12;
 	rtr_attr.port_num	= port;
-	rtr_attr.sgid_index	= gid_index;
 	rtr_attr.udp_src_port	= dmn->info.caps.roce_min_src_udp;
 
+	/* If QP creation with force loopback is allowed, then there
+	 * is no need for GID index when creating the QP.
+	 * Otherwise we query GID attributes and use GID index.
+	 */
+	rtr_attr.fl = dr_send_allow_fl(&dmn->info.caps);
+	if (!rtr_attr.fl) {
+		ret = mlx5dr_cmd_query_gid(dmn->mdev, port, gid_index,
+					   &rtr_attr.dgid_attr);
+		if (ret)
+			return ret;
+
+		rtr_attr.sgid_index = gid_index;
+	}
+
 	ret = dr_cmd_modify_qp_init2rtr(dmn->mdev, dr_qp, &rtr_attr);
 	if (ret) {
 		mlx5dr_err(dmn, "Failed modify QP init2rtr\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 7c1ab0b6417e..8de70566f85b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -747,6 +747,12 @@ struct mlx5dr_cmd_vport_cap {
 	u32 num;
 };
 
+struct mlx5dr_roce_cap {
+	u8 roce_en:1;
+	u8 fl_rc_qp_when_roce_disabled:1;
+	u8 fl_rc_qp_when_roce_enabled:1;
+};
+
 struct mlx5dr_cmd_caps {
 	u16 gvmi;
 	u64 nic_rx_drop_address;
@@ -783,6 +789,7 @@ struct mlx5dr_cmd_caps {
 	struct mlx5dr_esw_caps esw_caps;
 	struct mlx5dr_cmd_vport_cap *vports_caps;
 	bool prio_tag_required;
+	struct mlx5dr_roce_cap roce_caps;
 };
 
 struct mlx5dr_domain_rx_tx {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index aa6effe1dd6d..4d9569c4b96c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -961,7 +961,9 @@ struct mlx5_ifc_roce_cap_bits {
 	u8         roce_apm[0x1];
 	u8         reserved_at_1[0x3];
 	u8         sw_r_roce_src_udp_port[0x1];
-	u8         reserved_at_5[0x19];
+	u8         fl_rc_qp_when_roce_disabled[0x1];
+	u8         fl_rc_qp_when_roce_enabled[0x1];
+	u8         reserved_at_7[0x17];
 	u8	   qp_ts_format[0x2];
 
 	u8         reserved_at_20[0x60];
@@ -2942,7 +2944,8 @@ struct mlx5_ifc_qpc_bits {
 	u8         state[0x4];
 	u8         lag_tx_port_affinity[0x4];
 	u8         st[0x8];
-	u8         reserved_at_10[0x3];
+	u8         reserved_at_10[0x2];
+	u8	   isolate_vl_tc[0x1];
 	u8         pm_state[0x2];
 	u8         reserved_at_15[0x1];
 	u8         req_e2e_credit_mode[0x2];
-- 
2.30.2

