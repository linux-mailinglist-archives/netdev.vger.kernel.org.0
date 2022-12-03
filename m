Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631CC64196F
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiLCWOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLCWOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:14:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811BF1E73A
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:14:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9029260C42
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBDBC433D7;
        Sat,  3 Dec 2022 22:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105640;
        bh=o40VJUu2yHRFhRtUOzDCa//BM3fKix+uTkH8aZBoAr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LKRkbjjDDadni+lcaOlzGXbSJREp/hhabDq13j++AZ3R+zMEzFds1PevXE8dT1Yny
         VdKsNyOgyOBp5SfRUy9UuUr1/DIjddHlodGp9uTdr5RAlWummMC4cffQE1MOBTPacf
         YstTsWjA2f6vLeOFDpxoTc2VW8pJL/mL4ZJFNll8NLO1uMDl93ErLXLQhp8GiAcxrA
         SI1pgmxFwi3+11pKvq2D3LGuXRjAsazpEOfDOflCJ58eBiNRDKywMENSfSU6L1lGYP
         OI7tijDOryw7THdYD8HRy3pvXbO5JKbQqB/HNov+71UYwu4RYkg04FMb47C5UUiKIJ
         5Un18yXOxnuew==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 15/15] net/mlx5: SRIOV, Allow ingress tagged packets on VST
Date:   Sat,  3 Dec 2022 14:13:37 -0800
Message-Id: <20221203221337.29267-16-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

Depends on esw capability, VST mode behavior is changed to insert cvlan
tag either if there is already vlan tag on the packet or not. Previous
VST mode behavior was to insert cvlan tag only if there is no vlan tag
already on the packet.

This change enables sending packets with two cvlan tags, the outer is
added by the eswitch.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c |  4 +--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 26 ++++++++++++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h | 12 +++++++--
 include/linux/mlx5/device.h                   |  7 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  3 ++-
 5 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index eb68d6e6d5aa..5c10e487497a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -33,7 +33,7 @@ static int esw_acl_ingress_lgcy_groups_create(struct mlx5_eswitch *esw,
 
 	match_criteria = MLX5_ADDR_OF(create_flow_group_in, flow_group_in, match_criteria);
 
-	push_on_any_pkt = (vst_mode == ESW_VST_MODE_STEERING && !vport->info.spoofchk);
+	push_on_any_pkt = (vst_mode != ESW_VST_MODE_BASIC && !vport->info.spoofchk);
 	if (!push_on_any_pkt)
 		MLX5_SET(create_flow_group_in, flow_group_in, match_criteria_enable,
 			 MLX5_MATCH_OUTER_HEADERS);
@@ -141,7 +141,7 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	push_on_any_pkt = (vst_mode == ESW_VST_MODE_STEERING && !vport->info.spoofchk);
+	push_on_any_pkt = (vst_mode != ESW_VST_MODE_BASIC && !vport->info.spoofchk);
 	if (!push_on_any_pkt)
 		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9d4599a1b8a6..caa03e13a28b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -145,7 +145,8 @@ int mlx5_eswitch_modify_esw_vport_context(struct mlx5_core_dev *dev, u16 vport,
 }
 
 static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
-				  u16 vlan, u8 qos, u8 set_flags)
+				  u16 vlan, u8 qos, u8 set_flags,
+				  enum esw_vst_mode vst_mode)
 {
 	u32 in[MLX5_ST_SZ_DW(modify_esw_vport_context_in)] = {};
 
@@ -161,10 +162,17 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 			 esw_vport_context.vport_cvlan_strip, 1);
 
 	if (set_flags & SET_VLAN_INSERT) {
-		/* insert only if no vlan in packet */
-		MLX5_SET(modify_esw_vport_context_in, in,
-			 esw_vport_context.vport_cvlan_insert, 1);
-
+		if (vst_mode == ESW_VST_MODE_INSERT_ALWAYS) {
+			/* insert either if vlan exist in packet or not */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_ALWAYS);
+		} else {
+			/* insert only if no vlan in packet */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN);
+		}
 		MLX5_SET(modify_esw_vport_context_in, in,
 			 esw_vport_context.cvlan_pcp, qos);
 		MLX5_SET(modify_esw_vport_context_in, in,
@@ -801,9 +809,9 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 
 	flags = (vport->info.vlan || vport->info.qos) ?
 		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
-	if (vst_mode == ESW_VST_MODE_BASIC)
+	if (vst_mode != ESW_VST_MODE_STEERING)
 		modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
-				       vport->info.qos, flags);
+				       vport->info.qos, flags, vst_mode);
 
 	return 0;
 }
@@ -1823,8 +1831,8 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw, u16 vport, u16 vlan,
 	if (proto == ETH_P_8021AD && vst_mode != ESW_VST_MODE_STEERING)
 		return -EPROTONOSUPPORT;
 
-	if (esw->mode == MLX5_ESWITCH_OFFLOADS || vst_mode == ESW_VST_MODE_BASIC) {
-		err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || vst_mode != ESW_VST_MODE_STEERING) {
+		err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags, vst_mode);
 		if (err)
 			return err;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 6f368c0442bf..15adb6f20c0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -520,15 +520,23 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw, u16 vport, u16 vlan,
 enum esw_vst_mode {
 	ESW_VST_MODE_BASIC,
 	ESW_VST_MODE_STEERING,
+	ESW_VST_MODE_INSERT_ALWAYS,
 };
 
 static inline enum esw_vst_mode esw_get_vst_mode(struct mlx5_eswitch *esw)
 {
+	/*  vst mode precedence:
+	 *  if vst steering mode is supported use it
+	 *  if not, look for vst vport insert always support
+	 *  if both not supported, we use basic vst, can't support QinQ
+	 */
 	if (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, pop_vlan) &&
 	    MLX5_CAP_ESW_INGRESS_ACL(esw->dev, push_vlan))
 		return ESW_VST_MODE_STEERING;
-
-	return ESW_VST_MODE_BASIC;
+	else if (MLX5_CAP_ESW(esw->dev, vport_cvlan_insert_always))
+		return ESW_VST_MODE_INSERT_ALWAYS;
+	else
+		return ESW_VST_MODE_BASIC;
 }
 
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 5fe5d198b57a..84ec364e0751 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1090,6 +1090,13 @@ enum {
 	MLX5_VPORT_ADMIN_STATE_AUTO  = 0x2,
 };
 
+enum {
+	MLX5_VPORT_CVLAN_NO_INSERT             = 0x0,
+	MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN  = 0x1,
+	MLX5_VPORT_CVLAN_INSERT_OR_OVERWRITE   = 0x2,
+	MLX5_VPORT_CVLAN_INSERT_ALWAYS         = 0x3,
+};
+
 enum {
 	MLX5_L3_PROT_TYPE_IPV4		= 0,
 	MLX5_L3_PROT_TYPE_IPV6		= 1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5a4e914e2a6f..e45bdec73baf 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -907,7 +907,8 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x2];
+	u8         reserved_at_5[0x1];
+	u8         vport_cvlan_insert_always[0x1];
 	u8         esw_shared_ingress_acl[0x1];
 	u8         esw_uplink_ingress_acl[0x1];
 	u8         root_ft_on_other_esw[0x1];
-- 
2.38.1

