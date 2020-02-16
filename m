Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C46160347
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 11:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgBPKBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 05:01:47 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:44746 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727329AbgBPKBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 05:01:46 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 16 Feb 2020 12:01:39 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01GA1ce2007834;
        Sun, 16 Feb 2020 12:01:39 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v3 06/16] net/mlx5: E-Switch, Move source port on reg_c0 to the upper 16 bits
Date:   Sun, 16 Feb 2020 12:01:26 +0200
Message-Id: <1581847296-19194-7-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Multi chain support requires the miss path to continue the processing
from the last chain id, and for that we need to save the chain
miss tag (a mapping for 32bit chain id) on reg_c0 which will
come in a next patch.

Currently reg_c0 is exclusively used to store the source port
metadata, giving it 32bit, it is created from 16bits of vcha_id,
and 16bits of vport number.

We will move this source port metadata to upper 16bits, and leave the
lower bits for the chain miss tag. We compress the reg_c0 source port
metadata to 16bits by taking 8 bits from vhca_id, and 8bits from
the vport number.

Since we compress the vport number to 8bits statically, and leave two
top ids for special PF/ECPF numbers, we will only support a max of 254
vports with this strategy.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/infiniband/hw/mlx5/main.c                  |  3 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 64 ++++++++++++++++++----
 include/linux/mlx5/eswitch.h                       | 29 +++++++++-
 3 files changed, 83 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e874d68..230028c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3570,7 +3570,8 @@ static void mlx5_ib_set_rule_source_port(struct mlx5_ib_dev *dev,
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 				    misc_parameters_2);
 
-		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
+		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
 	} else {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_value,
 				    misc_parameters);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 979f13b..788bb83 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -85,7 +85,8 @@ static struct mlx5_eswitch_rep *mlx5_eswitch_get_rep(struct mlx5_eswitch *esw,
 								   attr->in_rep->vport));
 
 		misc2 = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
-		MLX5_SET_TO_ONES(fte_match_set_misc2, misc2, metadata_reg_c_0);
+		MLX5_SET(fte_match_set_misc2, misc2, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
 
 		spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_2;
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters);
@@ -621,7 +622,8 @@ static void peer_miss_rules_setup(struct mlx5_eswitch *esw,
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw)) {
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria,
 				    misc_parameters_2);
-		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
+		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
 
 		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
 	} else {
@@ -851,8 +853,9 @@ static void esw_set_flow_group_source_port(struct mlx5_eswitch *esw,
 			 match_criteria_enable,
 			 MLX5_MATCH_MISC_PARAMETERS_2);
 
-		MLX5_SET_TO_ONES(fte_match_param, match_criteria,
-				 misc_parameters_2.metadata_reg_c_0);
+		MLX5_SET(fte_match_param, match_criteria,
+			 misc_parameters_2.metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
 	} else {
 		MLX5_SET(create_flow_group_in, flow_group_in,
 			 match_criteria_enable,
@@ -1134,7 +1137,8 @@ struct mlx5_flow_handle *
 			 mlx5_eswitch_get_vport_metadata_for_match(esw, vport));
 
 		misc = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_2);
-		MLX5_SET_TO_ONES(fte_match_set_misc2, misc, metadata_reg_c_0);
+		MLX5_SET(fte_match_set_misc2, misc, metadata_reg_c_0,
+			 mlx5_eswitch_get_vport_metadata_mask());
 
 		spec->match_criteria_enable = MLX5_MATCH_MISC_PARAMETERS_2;
 	} else {
@@ -1604,11 +1608,19 @@ static int esw_vport_add_ingress_acl_modify_metadata(struct mlx5_eswitch *esw,
 	static const struct mlx5_flow_spec spec = {};
 	struct mlx5_flow_act flow_act = {};
 	int err = 0;
+	u32 key;
+
+	key = mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport);
+	key >>= ESW_SOURCE_PORT_METADATA_OFFSET;
 
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
-	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
-	MLX5_SET(set_action_in, action, data,
-		 mlx5_eswitch_get_vport_metadata_for_match(esw, vport->vport));
+	MLX5_SET(set_action_in, action, field,
+		 MLX5_ACTION_IN_FIELD_METADATA_REG_C_0);
+	MLX5_SET(set_action_in, action, data, key);
+	MLX5_SET(set_action_in, action, offset,
+		 ESW_SOURCE_PORT_METADATA_OFFSET);
+	MLX5_SET(set_action_in, action, length,
+		 ESW_SOURCE_PORT_METADATA_BITS);
 
 	vport->ingress.offloads.modify_metadata =
 		mlx5_modify_header_alloc(esw->dev, MLX5_FLOW_NAMESPACE_ESW_INGRESS,
@@ -2470,9 +2482,41 @@ bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw)
 }
 EXPORT_SYMBOL(mlx5_eswitch_vport_match_metadata_enabled);
 
-u32 mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
+u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num)
 {
-	return ((MLX5_CAP_GEN(esw->dev, vhca_id) & 0xffff) << 16) | vport_num;
+	u32 vport_num_mask = GENMASK(ESW_VPORT_BITS - 1, 0);
+	u32 vhca_id_mask = GENMASK(ESW_VHCA_ID_BITS - 1, 0);
+	u32 vhca_id = MLX5_CAP_GEN(esw->dev, vhca_id);
+	u32 val;
+
+	/* Make sure the vhca_id fits the ESW_VHCA_ID_BITS */
+	WARN_ON_ONCE(vhca_id >= BIT(ESW_VHCA_ID_BITS));
+
+	/* Trim vhca_id to ESW_VHCA_ID_BITS */
+	vhca_id &= vhca_id_mask;
+
+	/* Make sure pf and ecpf map to end of ESW_VPORT_BITS range so they
+	 * don't overlap with VF numbers, and themselves, after trimming.
+	 */
+	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) <
+		     vport_num_mask - 1);
+	WARN_ON_ONCE((MLX5_VPORT_ECPF & vport_num_mask) <
+		     vport_num_mask - 1);
+	WARN_ON_ONCE((MLX5_VPORT_UPLINK & vport_num_mask) ==
+		     (MLX5_VPORT_ECPF & vport_num_mask));
+
+	/* Make sure that the VF vport_num fits ESW_VPORT_BITS and don't
+	 * overlap with pf and ecpf.
+	 */
+	if (vport_num != MLX5_VPORT_UPLINK &&
+	    vport_num != MLX5_VPORT_ECPF)
+		WARN_ON_ONCE(vport_num >= vport_num_mask - 1);
+
+	/* We can now trim vport_num to ESW_VPORT_BITS */
+	vport_num &= vport_num_mask;
+
+	val = (vhca_id << ESW_VPORT_BITS) | vport_num;
+	return val << (32 - ESW_SOURCE_PORT_METADATA_BITS);
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_vport_metadata_for_match);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 98e667b..dd1333f 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -71,7 +71,26 @@ enum devlink_eswitch_encap_mode
 mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev);
 
 bool mlx5_eswitch_vport_match_metadata_enabled(const struct mlx5_eswitch *esw);
-u32 mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
+
+/* Reg C0 usage:
+ * Reg C0 = < ESW_VHCA_ID_BITS(8) | ESW_VPORT BITS(8) | ESW_CHAIN_TAG(16) >
+ *
+ * Highest 8 bits of the reg c0 is the vhca_id, next 8 bits is vport_num,
+ * the rest (lowest 16 bits) is left for tc chain tag restoration.
+ * VHCA_ID + VPORT comprise the SOURCE_PORT matching.
+ */
+#define ESW_VHCA_ID_BITS 8
+#define ESW_VPORT_BITS 8
+#define ESW_SOURCE_PORT_METADATA_BITS (ESW_VHCA_ID_BITS + ESW_VPORT_BITS)
+#define ESW_SOURCE_PORT_METADATA_OFFSET (32 - ESW_SOURCE_PORT_METADATA_BITS)
+#define ESW_CHAIN_TAG_METADATA_BITS (32 - ESW_SOURCE_PORT_METADATA_BITS)
+
+static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)
+{
+	return GENMASK(31, 32 - ESW_SOURCE_PORT_METADATA_BITS);
+}
+
+u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num);
 u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
 #else  /* CONFIG_MLX5_ESWITCH */
@@ -94,11 +113,17 @@ static inline u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
 };
 
 static inline u32
-mlx5_eswitch_get_vport_metadata_for_match(const struct mlx5_eswitch *esw,
+mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					  int vport_num)
 {
 	return 0;
 };
+
+static inline u32
+mlx5_eswitch_get_vport_metadata_mask(void)
+{
+	return 0;
+}
 #endif /* CONFIG_MLX5_ESWITCH */
 
 #endif
-- 
1.8.3.1

