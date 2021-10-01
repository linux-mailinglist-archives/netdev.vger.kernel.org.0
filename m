Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40F941E4B3
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350134AbhI3XWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348196AbhI3XWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 19:22:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F2C61A35;
        Thu, 30 Sep 2021 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633044056;
        bh=sB7DQex5CBHKckz5bP4gibgPqR4Zy6fLm3OEhV3BEBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwzqEq32pH30A/ycBS0Wxe+waokJxi8vT4zxJHQ/dftszvHatgq5Stcere23ayQ0b
         pRgkN9UyG+DulBnv6NIzhyXzSwAU7nyx2T8/k8q45Y1Itut53PBmcymfxVPxE6GZuG
         PqdLZ81JB3waktquNAkQjgbrgMpGcGCBfCqF0f6g96bBur+4h81vtR/fbvA+h09IXs
         ST1F4rz+DuswEas1SruWTmZyyUEH+7HaTxFVkDhzh5ttT8DSR4sLjCKq8P8+G9t+sN
         fTgkGZZ++N2t3f4PDvDjrn15a1ZMUb4UUwuuxhQlAiNi/YCZc8T/2mDp+10cXUnfg8
         E2YD5O/MQgu2w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Muhammad Sammar <muhammads@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: DR, Add support for SF vports
Date:   Thu, 30 Sep 2021 16:20:41 -0700
Message-Id: <20210930232050.41779-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210930232050.41779-1-saeed@kernel.org>
References: <20210930232050.41779-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Move all the vport capabilities to a separate struct and store vport caps
in XArray: SFs vport numbers will not come in the same range as VF vports,
so the existing implementation of vport capabilities as a fixed size array
is not suitable here.

XArray is a perfect fit: it is efficient when the indices used are densely
clustered. In addition to being a perfect fit as a dynamic data structure,
XArray also provides locking - it uses RCU and an internal spinlock to
synchronise access, so no additional protection needed.

Now except for the eswitch manager vport, all other vports (including the
uplink vport) are handled in the same way: when a new go-to-vport action
is added, this vport's caps are loaded from the xarray. If it is the first
time for this particular vport number, then its capabilities are queried
from FW and filled in into the appropriate entry.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Muhammad Sammar <muhammads@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_action.c   |   2 +-
 .../mellanox/mlx5/core/steering/dr_domain.c   | 138 +++++++++++++-----
 .../mellanox/mlx5/core/steering/dr_ste_v0.c   |  11 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c   |  10 +-
 .../mellanox/mlx5/core/steering/dr_types.h    |  27 +---
 5 files changed, 120 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index a41fac349981..0179d386ee48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -1767,7 +1767,7 @@ mlx5dr_action_create_dest_vport(struct mlx5dr_domain *dmn,
 		return NULL;
 	}
 
-	vport_cap = mlx5dr_get_vport_cap(&vport_dmn->info.caps, vport);
+	vport_cap = mlx5dr_domain_get_vport_cap(vport_dmn, vport);
 	if (!vport_cap) {
 		mlx5dr_err(dmn,
 			   "Failed to get vport 0x%x caps - vport is disabled or invalid\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index bb12e8faf096..49089cbe897c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -121,6 +121,18 @@ static void dr_domain_uninit_resources(struct mlx5dr_domain *dmn)
 	mlx5_core_dealloc_pd(dmn->mdev, dmn->pdn);
 }
 
+static void dr_domain_fill_uplink_caps(struct mlx5dr_domain *dmn,
+				       struct mlx5dr_cmd_vport_cap *uplink_vport)
+{
+	struct mlx5dr_esw_caps *esw_caps = &dmn->info.caps.esw_caps;
+
+	uplink_vport->num = MLX5_VPORT_UPLINK;
+	uplink_vport->icm_address_rx = esw_caps->uplink_icm_address_rx;
+	uplink_vport->icm_address_tx = esw_caps->uplink_icm_address_tx;
+	uplink_vport->vport_gvmi = 0;
+	uplink_vport->vhca_gvmi = dmn->info.caps.gvmi;
+}
+
 static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 				 u16 vport_number,
 				 struct mlx5dr_cmd_vport_cap *vport_caps)
@@ -129,6 +141,11 @@ static int dr_domain_query_vport(struct mlx5dr_domain *dmn,
 	bool other_vport = true;
 	int ret;
 
+	if (vport_number == MLX5_VPORT_UPLINK) {
+		dr_domain_fill_uplink_caps(dmn, vport_caps);
+		return 0;
+	}
+
 	if (dmn->info.caps.is_ecpf && vport_number == MLX5_VPORT_ECPF) {
 		other_vport = false;
 		cmd_vport = 0;
@@ -159,36 +176,78 @@ static int dr_domain_query_esw_mngr(struct mlx5dr_domain *dmn)
 {
 	return dr_domain_query_vport(dmn,
 				     dmn->info.caps.is_ecpf ? MLX5_VPORT_ECPF : 0,
-				     &dmn->info.caps.esw_manager_vport_caps);
+				     &dmn->info.caps.vports.esw_manager_caps);
 }
 
-static int dr_domain_query_vports(struct mlx5dr_domain *dmn)
+static struct mlx5dr_cmd_vport_cap *
+dr_domain_add_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
 {
-	struct mlx5dr_esw_caps *esw_caps = &dmn->info.caps.esw_caps;
-	struct mlx5dr_cmd_vport_cap *wire_vport;
-	int vport;
+	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
+	struct mlx5dr_cmd_vport_cap *vport_caps;
 	int ret;
 
-	ret = dr_domain_query_esw_mngr(dmn);
-	if (ret)
-		return ret;
+	vport_caps = kvzalloc(sizeof(*vport_caps), GFP_KERNEL);
+	if (!vport_caps)
+		return NULL;
 
-	/* Query vports (except wire vport) */
-	for (vport = 0; vport < dmn->info.caps.num_esw_ports - 1; vport++) {
-		ret = dr_domain_query_vport(dmn,
-					    vport,
-					    &dmn->info.caps.vports_caps[vport]);
-		if (ret)
-			return ret;
+	ret = dr_domain_query_vport(dmn, vport, vport_caps);
+	if (ret) {
+		kvfree(vport_caps);
+		return NULL;
 	}
 
-	/* Last vport is the wire port */
-	wire_vport = &dmn->info.caps.vports_caps[vport];
-	wire_vport->num = MLX5_VPORT_UPLINK;
-	wire_vport->icm_address_rx = esw_caps->uplink_icm_address_rx;
-	wire_vport->icm_address_tx = esw_caps->uplink_icm_address_tx;
-	wire_vport->vport_gvmi = 0;
-	wire_vport->vhca_gvmi = dmn->info.caps.gvmi;
+	ret = xa_insert(&caps->vports.vports_caps_xa, vport,
+			vport_caps, GFP_KERNEL);
+	if (ret) {
+		mlx5dr_dbg(dmn, "Couldn't insert new vport into xarray (%d)\n", ret);
+		kvfree(vport_caps);
+		return ERR_PTR(ret);
+	}
+
+	return vport_caps;
+}
+
+struct mlx5dr_cmd_vport_cap *
+mlx5dr_domain_get_vport_cap(struct mlx5dr_domain *dmn, u16 vport)
+{
+	struct mlx5dr_cmd_caps *caps = &dmn->info.caps;
+	struct mlx5dr_cmd_vport_cap *vport_caps;
+
+	if ((caps->is_ecpf && vport == MLX5_VPORT_ECPF) ||
+	    (!caps->is_ecpf && vport == 0))
+		return &caps->vports.esw_manager_caps;
+
+vport_load:
+	vport_caps = xa_load(&caps->vports.vports_caps_xa, vport);
+	if (vport_caps)
+		return vport_caps;
+
+	vport_caps = dr_domain_add_vport_cap(dmn, vport);
+	if (PTR_ERR(vport_caps) == -EBUSY)
+		/* caps were already stored by another thread */
+		goto vport_load;
+
+	return vport_caps;
+}
+
+static void dr_domain_clear_vports(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_cmd_vport_cap *vport_caps;
+	unsigned long i;
+
+	xa_for_each(&dmn->info.caps.vports.vports_caps_xa, i, vport_caps) {
+		vport_caps = xa_erase(&dmn->info.caps.vports.vports_caps_xa, i);
+		kvfree(vport_caps);
+	}
+}
+
+static int dr_domain_query_uplink(struct mlx5dr_domain *dmn)
+{
+	struct mlx5dr_cmd_vport_cap *vport_caps;
+
+	vport_caps = mlx5dr_domain_get_vport_cap(dmn, MLX5_VPORT_UPLINK);
+	if (!vport_caps)
+		return -EINVAL;
 
 	return 0;
 }
@@ -210,25 +269,29 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 	dmn->info.caps.esw_rx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_rx;
 	dmn->info.caps.esw_tx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_tx;
 
-	dmn->info.caps.vports_caps = kcalloc(dmn->info.caps.num_esw_ports,
-					     sizeof(dmn->info.caps.vports_caps[0]),
-					     GFP_KERNEL);
-	if (!dmn->info.caps.vports_caps)
-		return -ENOMEM;
+	xa_init(&dmn->info.caps.vports.vports_caps_xa);
+
+	/* Query eswitch manager and uplink vports only. Rest of the
+	 * vports (vport 0, VFs and SFs) will be queried dynamically.
+	 */
 
-	ret = dr_domain_query_vports(dmn);
+	ret = dr_domain_query_esw_mngr(dmn);
 	if (ret) {
-		mlx5dr_err(dmn, "Failed to query vports caps (err: %d)", ret);
-		goto free_vports_caps;
+		mlx5dr_err(dmn, "Failed to query eswitch manager vport caps (err: %d)", ret);
+		goto free_vports_caps_xa;
 	}
 
-	dmn->info.caps.num_vports = dmn->info.caps.num_esw_ports - 1;
+	ret = dr_domain_query_uplink(dmn);
+	if (ret) {
+		mlx5dr_err(dmn, "Failed to query uplink vport caps (err: %d)", ret);
+		goto free_vports_caps_xa;
+	}
 
 	return 0;
 
-free_vports_caps:
-	kfree(dmn->info.caps.vports_caps);
-	dmn->info.caps.vports_caps = NULL;
+free_vports_caps_xa:
+	xa_destroy(&dmn->info.caps.vports.vports_caps_xa);
+
 	return ret;
 }
 
@@ -243,8 +306,6 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		return -EOPNOTSUPP;
 	}
 
-	dmn->info.caps.num_esw_ports = mlx5_eswitch_get_total_vports(mdev);
-
 	ret = mlx5dr_cmd_query_device(mdev, &dmn->info.caps);
 	if (ret)
 		return ret;
@@ -281,7 +342,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 
 		dmn->info.rx.type = DR_DOMAIN_NIC_TYPE_RX;
 		dmn->info.tx.type = DR_DOMAIN_NIC_TYPE_TX;
-		vport_cap = &dmn->info.caps.esw_manager_vport_caps;
+		vport_cap = &dmn->info.caps.vports.esw_manager_caps;
 
 		dmn->info.supp_sw_steering = true;
 		dmn->info.tx.default_icm_addr = vport_cap->icm_address_tx;
@@ -300,7 +361,8 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 
 static void dr_domain_caps_uninit(struct mlx5dr_domain *dmn)
 {
-	kfree(dmn->info.caps.vports_caps);
+	dr_domain_clear_vports(dmn);
+	xa_destroy(&dmn->info.caps.vports.vports_caps_xa);
 }
 
 struct mlx5dr_domain *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
index 507719322af8..b0649c2877dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v0.c
@@ -1645,7 +1645,7 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	struct mlx5dr_match_misc *misc = &value->misc;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
-	struct mlx5dr_cmd_caps *caps;
+	struct mlx5dr_domain *vport_dmn;
 	u8 *bit_mask = sb->bit_mask;
 	bool source_gvmi_set;
 
@@ -1654,21 +1654,22 @@ dr_ste_v0_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	if (sb->vhca_id_valid) {
 		/* Find port GVMI based on the eswitch_owner_vhca_id */
 		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
-			caps = &dmn->info.caps;
+			vport_dmn = dmn;
 		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
 					   dmn->peer_dmn->info.caps.gvmi))
-			caps = &dmn->peer_dmn->info.caps;
+			vport_dmn = dmn->peer_dmn;
 		else
 			return -EINVAL;
 
 		misc->source_eswitch_owner_vhca_id = 0;
 	} else {
-		caps = &dmn->info.caps;
+		vport_dmn = dmn;
 	}
 
 	source_gvmi_set = MLX5_GET(ste_src_gvmi_qp, bit_mask, source_gvmi);
 	if (source_gvmi_set) {
-		vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
+		vport_cap = mlx5dr_domain_get_vport_cap(vport_dmn,
+							misc->source_port);
 		if (!vport_cap) {
 			mlx5dr_err(dmn, "Vport 0x%x is disabled or invalid\n",
 				   misc->source_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
index 33e6299026f7..3497c2cf3118 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.c
@@ -1776,7 +1776,7 @@ static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	struct mlx5dr_match_misc *misc = &value->misc;
 	struct mlx5dr_cmd_vport_cap *vport_cap;
 	struct mlx5dr_domain *dmn = sb->dmn;
-	struct mlx5dr_cmd_caps *caps;
+	struct mlx5dr_domain *vport_dmn;
 	u8 *bit_mask = sb->bit_mask;
 
 	DR_STE_SET_TAG(src_gvmi_qp_v1, tag, source_qp, misc, source_sqn);
@@ -1784,22 +1784,22 @@ static int dr_ste_v1_build_src_gvmi_qpn_tag(struct mlx5dr_match_param *value,
 	if (sb->vhca_id_valid) {
 		/* Find port GVMI based on the eswitch_owner_vhca_id */
 		if (misc->source_eswitch_owner_vhca_id == dmn->info.caps.gvmi)
-			caps = &dmn->info.caps;
+			vport_dmn = dmn;
 		else if (dmn->peer_dmn && (misc->source_eswitch_owner_vhca_id ==
 					   dmn->peer_dmn->info.caps.gvmi))
-			caps = &dmn->peer_dmn->info.caps;
+			vport_dmn = dmn->peer_dmn;
 		else
 			return -EINVAL;
 
 		misc->source_eswitch_owner_vhca_id = 0;
 	} else {
-		caps = &dmn->info.caps;
+		vport_dmn = dmn;
 	}
 
 	if (!MLX5_GET(ste_src_gvmi_qp_v1, bit_mask, source_gvmi))
 		return 0;
 
-	vport_cap = mlx5dr_get_vport_cap(caps, misc->source_port);
+	vport_cap = mlx5dr_domain_get_vport_cap(vport_dmn, misc->source_port);
 	if (!vport_cap) {
 		mlx5dr_err(dmn, "Vport 0x%x is disabled or invalid\n",
 			   misc->source_port);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index a9cf4f55cacf..01787b9d5a57 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -762,6 +762,11 @@ struct mlx5dr_roce_cap {
 	u8 fl_rc_qp_when_roce_enabled:1;
 };
 
+struct mlx5dr_vports {
+	struct mlx5dr_cmd_vport_cap esw_manager_caps;
+	struct xarray vports_caps_xa;
+};
+
 struct mlx5dr_cmd_caps {
 	u16 gvmi;
 	u64 nic_rx_drop_address;
@@ -785,7 +790,6 @@ struct mlx5dr_cmd_caps {
 	u8 flex_parser_id_gtpu_first_ext_dw_0;
 	u8 max_ft_level;
 	u16 roce_min_src_udp;
-	u8 num_esw_ports;
 	u8 sw_format_ver;
 	bool eswitch_manager;
 	bool rx_sw_owner;
@@ -794,10 +798,8 @@ struct mlx5dr_cmd_caps {
 	u8 rx_sw_owner_v2:1;
 	u8 tx_sw_owner_v2:1;
 	u8 fdb_sw_owner_v2:1;
-	u32 num_vports;
 	struct mlx5dr_esw_caps esw_caps;
-	struct mlx5dr_cmd_vport_cap *vports_caps;
-	struct mlx5dr_cmd_vport_cap esw_manager_vport_caps;
+	struct mlx5dr_vports vports;
 	bool prio_tag_required;
 	struct mlx5dr_roce_cap roce_caps;
 	u8 is_ecpf:1;
@@ -1099,21 +1101,8 @@ mlx5dr_ste_htbl_may_grow(struct mlx5dr_ste_htbl *htbl)
 	return true;
 }
 
-static inline struct mlx5dr_cmd_vport_cap *
-mlx5dr_get_vport_cap(struct mlx5dr_cmd_caps *caps, u16 vport)
-{
-	if (caps->is_ecpf && vport == MLX5_VPORT_ECPF)
-		return &caps->esw_manager_vport_caps;
-
-	if (!caps->vports_caps ||
-	    (vport >= caps->num_vports && vport != MLX5_VPORT_UPLINK))
-		return NULL;
-
-	if (vport == MLX5_VPORT_UPLINK)
-		vport = caps->num_vports;
-
-	return &caps->vports_caps[vport];
-}
+struct mlx5dr_cmd_vport_cap *
+mlx5dr_domain_get_vport_cap(struct mlx5dr_domain *dmn, u16 vport);
 
 struct mlx5dr_cmd_query_flow_table_details {
 	u8 status;
-- 
2.31.1

