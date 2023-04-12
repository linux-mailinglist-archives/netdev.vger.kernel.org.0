Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F7C6DEA27
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 06:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDLEIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 00:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDLEII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 00:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9480E44B9
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 21:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 671F462DA3
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DC0C433EF;
        Wed, 12 Apr 2023 04:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681272484;
        bh=KfUu7/U/tndimpRCbY2kBD7wd4P2DeMFKxRuiG55gjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/7srb+wvgehtF25PWyD7o796/OZ15JwIqzG5B4+ZWriuizACh9JeJllaR8wh17PD
         SbPwPnvYzZpKkFZd8O2spnYubif2RewQgZKJ9EQ+aEY+ucDkfqPkGS8lbvkWNvcbz6
         6qTjfq78J97k5p8pszVIvKPnVJdV6KEMGhJYXCuDSsf09aoCVvK/fJFDvxzVvefDjg
         Cv7CizFmR3c1sxWnPcXU4bJ7YbnDDVTsBo9Suj1wnLugt2E68909dvSq2hjsmw4zG1
         YrRUqAJ9oYOFnFV4wCuw0P9oD1SBKmDCYCc9aE2E6kFqOZoGBC+JO8+WlBOC7nf7I2
         XqZW/RcawtyRg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 05/15] net/mlx5: Bridge, snoop igmp/mld packets
Date:   Tue, 11 Apr 2023 21:07:42 -0700
Message-Id: <20230412040752.14220-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412040752.14220-1-saeed@kernel.org>
References: <20230412040752.14220-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Handle SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute notification to
dynamically toggle bridge multicast offload. Set new
MLX5_ESW_BRIDGE_MCAST_FLAG bridge flag when multicast offload is enabled.
Put multicast-specific code into new bridge_mcast.c file.

When initializing bridge multicast pipeline create a static rule for
snooping on IGMP traffic and three rules for snooping on MLD traffic (for
query, report and done message types). Note that matching MLD traffic
requires having flexparser MLX5_FLEX_PROTO_ICMPV6 capability enabled.

By default Linux bridge is created with multicast enabled which can be
modified by 'mcast_snooping' argument:

$ ip link set name my_bridge type bridge mcast_snooping 0

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en/rep/bridge.c        |   4 +
 .../ethernet/mellanox/mlx5/core/esw/bridge.c  |  31 ++
 .../ethernet/mellanox/mlx5/core/esw/bridge.h  |   9 +
 .../mellanox/mlx5/core/esw/bridge_mcast.c     | 316 ++++++++++++++++++
 .../mellanox/mlx5/core/esw/bridge_priv.h      |  27 +-
 6 files changed, 384 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
index 6c2f1d4a58ab..4a009b720bee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -75,7 +75,7 @@ mlx5_core-$(CONFIG_MLX5_ESWITCH)   += esw/acl/helper.o \
 				      esw/acl/egress_lgcy.o esw/acl/egress_ofld.o \
 				      esw/acl/ingress_lgcy.o esw/acl/ingress_ofld.o
 
-mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o en/rep/bridge.o
+mlx5_core-$(CONFIG_MLX5_BRIDGE)    += esw/bridge.o esw/bridge_mcast.o en/rep/bridge.o
 
 mlx5_core-$(CONFIG_THERMAL)        += thermal.o
 mlx5_core-$(CONFIG_MLX5_MPFS)      += lib/mpfs.o
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
index ce85b48d327d..9701eb3c5f1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
@@ -306,6 +306,10 @@ mlx5_esw_bridge_port_obj_attr_set(struct net_device *dev,
 						     attr->u.vlan_protocol,
 						     br_offloads);
 		break;
+	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
+		err = mlx5_esw_bridge_mcast_set(vport_num, esw_owner_vhca_id,
+						!attr->u.mc_disabled, br_offloads);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
index bbbf982bbbc0..35436aa9548d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
@@ -868,6 +868,7 @@ static void mlx5_esw_bridge_put(struct mlx5_esw_bridge_offloads *br_offloads,
 		return;
 
 	mlx5_esw_bridge_egress_table_cleanup(bridge);
+	mlx5_esw_bridge_mcast_disable(bridge);
 	list_del(&bridge->list);
 	rhashtable_destroy(&bridge->fdb_ht);
 	kvfree(bridge);
@@ -1458,6 +1459,36 @@ int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 pro
 	return 0;
 }
 
+int mlx5_esw_bridge_mcast_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
+			      struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_eswitch *esw = br_offloads->esw;
+	struct mlx5_esw_bridge *bridge;
+	int err = 0;
+	bool mcast;
+
+	if (!(MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_multi_path_any_table) ||
+	      MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_multi_path_any_table_limit_regc)) ||
+	    !MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_uplink_hairpin) ||
+	    !MLX5_CAP_ESW_FLOWTABLE_FDB((esw)->dev, ignore_flow_level))
+		return -EOPNOTSUPP;
+
+	bridge = mlx5_esw_bridge_from_port_lookup(vport_num, esw_owner_vhca_id, br_offloads);
+	if (!bridge)
+		return -EINVAL;
+
+	mcast = bridge->flags & MLX5_ESW_BRIDGE_MCAST_FLAG;
+	if (mcast == enable)
+		return 0;
+
+	if (enable)
+		err = mlx5_esw_bridge_mcast_enable(bridge);
+	else
+		mlx5_esw_bridge_mcast_disable(bridge);
+
+	return err;
+}
+
 static int mlx5_esw_bridge_vport_init(u16 vport_num, u16 esw_owner_vhca_id, u16 flags,
 				      struct mlx5_esw_bridge_offloads *br_offloads,
 				      struct mlx5_esw_bridge *bridge)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
index 10851a515bca..b18f137173d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
@@ -25,12 +25,19 @@ struct mlx5_esw_bridge_offloads {
 	struct delayed_work update_work;
 
 	struct mlx5_flow_table *ingress_ft;
+	struct mlx5_flow_group *ingress_igmp_fg;
+	struct mlx5_flow_group *ingress_mld_fg;
 	struct mlx5_flow_group *ingress_vlan_fg;
 	struct mlx5_flow_group *ingress_vlan_filter_fg;
 	struct mlx5_flow_group *ingress_qinq_fg;
 	struct mlx5_flow_group *ingress_qinq_filter_fg;
 	struct mlx5_flow_group *ingress_mac_fg;
 
+	struct mlx5_flow_handle *igmp_handle;
+	struct mlx5_flow_handle *mld_query_handle;
+	struct mlx5_flow_handle *mld_report_handle;
+	struct mlx5_flow_handle *mld_done_handle;
+
 	struct mlx5_flow_table *skip_ft;
 };
 
@@ -64,6 +71,8 @@ int mlx5_esw_bridge_vlan_filtering_set(u16 vport_num, u16 esw_owner_vhca_id, boo
 				       struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_vlan_proto_set(u16 vport_num, u16 esw_owner_vhca_id, u16 proto,
 				   struct mlx5_esw_bridge_offloads *br_offloads);
+int mlx5_esw_bridge_mcast_set(u16 vport_num, u16 esw_owner_vhca_id, bool enable,
+			      struct mlx5_esw_bridge_offloads *br_offloads);
 int mlx5_esw_bridge_port_vlan_add(u16 vport_num, u16 esw_owner_vhca_id, u16 vid, u16 flags,
 				  struct mlx5_esw_bridge_offloads *br_offloads,
 				  struct netlink_ext_ack *extack);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
new file mode 100644
index 000000000000..d5a89a86c9e8
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved. */
+
+#include "bridge.h"
+#include "eswitch.h"
+#include "bridge_priv.h"
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_igmp_fg_create(struct mlx5_eswitch *esw,
+				       struct mlx5_flow_table *ingress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable, MLX5_MATCH_OUTER_HEADERS);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ip_version);
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ip_protocol);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(ingress_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create IGMP flow group for bridge ingress table (err=%pe)\n",
+			 fg);
+
+	return fg;
+}
+
+static struct mlx5_flow_group *
+mlx5_esw_bridge_ingress_mld_fg_create(struct mlx5_eswitch *esw,
+				      struct mlx5_flow_table *ingress_ft)
+{
+	int inlen = MLX5_ST_SZ_BYTES(create_flow_group_in);
+	struct mlx5_flow_group *fg;
+	u32 *in, *match;
+
+	if (!(MLX5_CAP_GEN(esw->dev, flex_parser_protocols) & MLX5_FLEX_PROTO_ICMPV6)) {
+		esw_warn(esw->dev,
+			 "Can't create MLD flow group due to missing hardware ICMPv6 parsing support\n");
+		return NULL;
+	}
+
+	in = kvzalloc(inlen, GFP_KERNEL);
+	if (!in)
+		return ERR_PTR(-ENOMEM);
+
+	MLX5_SET(create_flow_group_in, in, match_criteria_enable,
+		 MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_3);
+	match = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
+
+	MLX5_SET_TO_ONES(fte_match_param, match, outer_headers.ip_version);
+	MLX5_SET_TO_ONES(fte_match_param, match, misc_parameters_3.icmpv6_type);
+
+	MLX5_SET(create_flow_group_in, in, start_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_FROM);
+	MLX5_SET(create_flow_group_in, in, end_flow_index,
+		 MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_TO);
+
+	fg = mlx5_create_flow_group(ingress_ft, in);
+	kvfree(in);
+	if (IS_ERR(fg))
+		esw_warn(esw->dev,
+			 "Failed to create MLD flow group for bridge ingress table (err=%pe)\n",
+			 fg);
+
+	return fg;
+}
+
+static int
+mlx5_esw_bridge_ingress_mcast_fgs_init(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_flow_table *ingress_ft = br_offloads->ingress_ft;
+	struct mlx5_eswitch *esw = br_offloads->esw;
+	struct mlx5_flow_group *igmp_fg, *mld_fg;
+
+	igmp_fg = mlx5_esw_bridge_ingress_igmp_fg_create(esw, ingress_ft);
+	if (IS_ERR(igmp_fg))
+		return PTR_ERR(igmp_fg);
+
+	mld_fg = mlx5_esw_bridge_ingress_mld_fg_create(esw, ingress_ft);
+	if (IS_ERR(mld_fg)) {
+		mlx5_destroy_flow_group(igmp_fg);
+		return PTR_ERR(mld_fg);
+	}
+
+	br_offloads->ingress_igmp_fg = igmp_fg;
+	br_offloads->ingress_mld_fg = mld_fg;
+	return 0;
+}
+
+static void
+mlx5_esw_bridge_ingress_mcast_fgs_cleanup(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	if (br_offloads->ingress_mld_fg)
+		mlx5_destroy_flow_group(br_offloads->ingress_mld_fg);
+	br_offloads->ingress_mld_fg = NULL;
+	if (br_offloads->ingress_igmp_fg)
+		mlx5_destroy_flow_group(br_offloads->ingress_igmp_fg);
+	br_offloads->ingress_igmp_fg = NULL;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_igmp_fh_create(struct mlx5_flow_table *ingress_ft,
+				       struct mlx5_flow_table *skip_ft)
+{
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+		.ft = skip_ft,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_version, 4);
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria, outer_headers.ip_protocol);
+	MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_protocol, IPPROTO_IGMP);
+
+	handle = mlx5_add_flow_rules(ingress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
+static struct mlx5_flow_handle *
+mlx5_esw_bridge_ingress_mld_fh_create(u8 type, struct mlx5_flow_table *ingress_ft,
+				      struct mlx5_flow_table *skip_ft)
+{
+	struct mlx5_flow_destination dest = {
+		.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE,
+		.ft = skip_ft,
+	};
+	struct mlx5_flow_act flow_act = {
+		.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
+		.flags = FLOW_ACT_NO_APPEND,
+	};
+	struct mlx5_flow_spec *rule_spec;
+	struct mlx5_flow_handle *handle;
+
+	rule_spec = kvzalloc(sizeof(*rule_spec), GFP_KERNEL);
+	if (!rule_spec)
+		return ERR_PTR(-ENOMEM);
+
+	rule_spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS | MLX5_MATCH_MISC_PARAMETERS_3;
+
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria, outer_headers.ip_version);
+	MLX5_SET(fte_match_param, rule_spec->match_value, outer_headers.ip_version, 6);
+	MLX5_SET_TO_ONES(fte_match_param, rule_spec->match_criteria, misc_parameters_3.icmpv6_type);
+	MLX5_SET(fte_match_param, rule_spec->match_value, misc_parameters_3.icmpv6_type, type);
+
+	handle = mlx5_add_flow_rules(ingress_ft, rule_spec, &flow_act, &dest, 1);
+
+	kvfree(rule_spec);
+	return handle;
+}
+
+static int
+mlx5_esw_bridge_ingress_mcast_fhs_create(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_flow_handle *igmp_handle, *mld_query_handle, *mld_report_handle,
+		*mld_done_handle;
+	struct mlx5_flow_table *ingress_ft = br_offloads->ingress_ft,
+		*skip_ft = br_offloads->skip_ft;
+	int err;
+
+	igmp_handle = mlx5_esw_bridge_ingress_igmp_fh_create(ingress_ft, skip_ft);
+	if (IS_ERR(igmp_handle))
+		return PTR_ERR(igmp_handle);
+
+	if (br_offloads->ingress_mld_fg) {
+		mld_query_handle = mlx5_esw_bridge_ingress_mld_fh_create(ICMPV6_MGM_QUERY,
+									 ingress_ft,
+									 skip_ft);
+		if (IS_ERR(mld_query_handle)) {
+			err = PTR_ERR(mld_query_handle);
+			goto err_mld_query;
+		}
+
+		mld_report_handle = mlx5_esw_bridge_ingress_mld_fh_create(ICMPV6_MGM_REPORT,
+									  ingress_ft,
+									  skip_ft);
+		if (IS_ERR(mld_report_handle)) {
+			err = PTR_ERR(mld_report_handle);
+			goto err_mld_report;
+		}
+
+		mld_done_handle = mlx5_esw_bridge_ingress_mld_fh_create(ICMPV6_MGM_REDUCTION,
+									ingress_ft,
+									skip_ft);
+		if (IS_ERR(mld_done_handle)) {
+			err = PTR_ERR(mld_done_handle);
+			goto err_mld_done;
+		}
+	} else {
+		mld_query_handle = NULL;
+		mld_report_handle = NULL;
+		mld_done_handle = NULL;
+	}
+
+	br_offloads->igmp_handle = igmp_handle;
+	br_offloads->mld_query_handle = mld_query_handle;
+	br_offloads->mld_report_handle = mld_report_handle;
+	br_offloads->mld_done_handle = mld_done_handle;
+
+	return 0;
+
+err_mld_done:
+	mlx5_del_flow_rules(mld_report_handle);
+err_mld_report:
+	mlx5_del_flow_rules(mld_query_handle);
+err_mld_query:
+	mlx5_del_flow_rules(igmp_handle);
+	return err;
+}
+
+static void
+mlx5_esw_bridge_ingress_mcast_fhs_cleanup(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	if (br_offloads->mld_done_handle)
+		mlx5_del_flow_rules(br_offloads->mld_done_handle);
+	br_offloads->mld_done_handle = NULL;
+	if (br_offloads->mld_report_handle)
+		mlx5_del_flow_rules(br_offloads->mld_report_handle);
+	br_offloads->mld_report_handle = NULL;
+	if (br_offloads->mld_query_handle)
+		mlx5_del_flow_rules(br_offloads->mld_query_handle);
+	br_offloads->mld_query_handle = NULL;
+	if (br_offloads->igmp_handle)
+		mlx5_del_flow_rules(br_offloads->igmp_handle);
+	br_offloads->igmp_handle = NULL;
+}
+
+static int mlx5_esw_brige_mcast_global_enable(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	int err;
+
+	if (br_offloads->ingress_igmp_fg)
+		return 0; /* already enabled by another bridge */
+
+	err = mlx5_esw_bridge_ingress_mcast_fgs_init(br_offloads);
+	if (err) {
+		esw_warn(br_offloads->esw->dev,
+			 "Failed to create global multicast flow groups (err=%d)\n",
+			 err);
+		return err;
+	}
+
+	err = mlx5_esw_bridge_ingress_mcast_fhs_create(br_offloads);
+	if (err) {
+		esw_warn(br_offloads->esw->dev,
+			 "Failed to create global multicast flows (err=%d)\n",
+			 err);
+		goto err_fhs;
+	}
+
+	return 0;
+
+err_fhs:
+	mlx5_esw_bridge_ingress_mcast_fgs_cleanup(br_offloads);
+	return err;
+}
+
+static void mlx5_esw_brige_mcast_global_disable(struct mlx5_esw_bridge_offloads *br_offloads)
+{
+	struct mlx5_esw_bridge *br;
+
+	list_for_each_entry(br, &br_offloads->bridges, list) {
+		/* Ingress table is global, so only disable snooping when all
+		 * bridges on esw have multicast disabled.
+		 */
+		if (br->flags & MLX5_ESW_BRIDGE_MCAST_FLAG)
+			return;
+	}
+
+	mlx5_esw_bridge_ingress_mcast_fhs_cleanup(br_offloads);
+	mlx5_esw_bridge_ingress_mcast_fgs_cleanup(br_offloads);
+}
+
+int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge)
+{
+	int err;
+
+	err = mlx5_esw_brige_mcast_global_enable(bridge->br_offloads);
+	if (err)
+		return err;
+
+	bridge->flags |= MLX5_ESW_BRIDGE_MCAST_FLAG;
+	return 0;
+}
+
+void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge)
+{
+	bridge->flags &= ~MLX5_ESW_BRIDGE_MCAST_FLAG;
+	mlx5_esw_brige_mcast_global_disable(bridge->br_offloads);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
index b99761e73c1b..dbb935db1b3c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
@@ -12,11 +12,26 @@
 #include <linux/xarray.h>
 #include "fs_core.h"
 
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_SIZE 1
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_SIZE 3
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE 131072
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE 524288
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM 0
-#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO		\
-	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_UNTAGGED_GRP_SIZE			\
+	(524288 - MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_SIZE -		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_SIZE)
+
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_IDX_FROM 0
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_FROM	\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_IGMP_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_TO		\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_FROM +	\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_SIZE - 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_MLD_GRP_IDX_TO + 1)
+#define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO			\
+	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_FROM +		\
+	 MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_SIZE - 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_FROM	\
 	(MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_GRP_IDX_TO + 1)
 #define MLX5_ESW_BRIDGE_INGRESS_TABLE_VLAN_FILTER_GRP_IDX_TO		\
@@ -74,6 +89,7 @@ enum {
 
 enum {
 	MLX5_ESW_BRIDGE_VLAN_FILTERING_FLAG = BIT(0),
+	MLX5_ESW_BRIDGE_MCAST_FLAG = BIT(1),
 };
 
 struct mlx5_esw_bridge_fdb_key {
@@ -145,4 +161,7 @@ struct mlx5_esw_bridge {
 	u16 vlan_proto;
 };
 
+int mlx5_esw_bridge_mcast_enable(struct mlx5_esw_bridge *bridge);
+void mlx5_esw_bridge_mcast_disable(struct mlx5_esw_bridge *bridge);
+
 #endif /* _MLX5_ESW_BRIDGE_PRIVATE_ */
-- 
2.39.2

