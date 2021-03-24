Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4472A3482A8
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbhCXUPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:11 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48691 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238106AbhCXUOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D5A2C5C005E;
        Wed, 24 Mar 2021 16:14:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=Nqfck1eA6df7C/THbcH3ugAXHqE8UJCATPGLJ4kD0Xo=; b=cJSqPtfx
        iO+jg4yoM/NkNToidUuLdaFHVBc5jsQEWyrFcJWSn1NKYq0BJ5iovT0am/9Ct23g
        CFTueB90L3oK5MG0Wsq5em9JAbze3o19Y6IgQxSuPq9sdFluTFph1y9z7FKAKG7q
        /BBIsfdFWAiy22e024LFBumGE3MSgHhuqS38iuOujJKm907Tk63kDG1xZeSSLY9z
        9fwpSbu2W+Sr0l+4FsM5QhBBwgvkrbRbeyG7LQm5JRazgyPgZrdjrkWD6KLiUMLS
        MNxvpqmSmN4fcUI+EXCVE6KC2kAOi7nO+RSkvDg5oMy0TaCKCkqk4i1FLBamk5Kl
        nGariJ8yEhDijQ==
X-ME-Sender: <xms:tZ1bYK9xw-bBoi4B6hKR4Utd7Z1dOnWlMwS7XH8u6YpM8toblhAu3w>
    <xme:tZ1bYKu9pLAIe3tpted2hMVUWkPykdYHhd6TTJ4CjaJLBvyaO8oVwUmJ0AbcM92Gd
    V3xd-dmf1woigg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:tZ1bYAC8kFOV6jPAwm6t203zEZd2MbpT2TUUIqbZrquzzKslULl3Ew>
    <xmx:tZ1bYCd4azKgBl3aBZD1ezcbCAlUeae5AVGcVOWdNkFKI7urbjhcsQ>
    <xmx:tZ1bYPP27Ne9QTWyBupk1sWqB269RG1E6kcAJ8E60FkqIbzKBaHbvg>
    <xmx:tZ1bYEprdo_qx2pXzHjpmGl_ztclaMYyMhQHvVcrNS2JjNVDsMA1nA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id AA54A240422;
        Wed, 24 Mar 2021 16:14:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/10] mlxsw: spectrum_router: Add support for resilient nexthop groups
Date:   Wed, 24 Mar 2021 22:14:15 +0200
Message-Id: <20210324201424.157387-2-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Parse the configuration of resilient nexthop groups to existing mlxsw
data structures. Unlike non-resilient groups, nexthops without a valid
MAC or router interface (RIF) are programmed with a trap action instead
of not being programmed at all.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 75c9fc47cd69..db859c2bd810 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2911,7 +2911,8 @@ struct mlxsw_sp_nexthop_group_info {
 	u16 count;
 	int sum_norm_weight;
 	u8 adj_index_valid:1,
-	   gateway:1; /* routes using the group use a gateway */
+	   gateway:1, /* routes using the group use a gateway */
+	   is_resilient:1;
 	struct mlxsw_sp_nexthop nexthops[0];
 #define nh_rif	nexthops[0].rif
 };
@@ -3905,6 +3906,9 @@ static void __mlxsw_sp_nexthop_neigh_update(struct mlxsw_sp_nexthop *nh,
 	if (!removing) {
 		nh->action = MLXSW_SP_NEXTHOP_ACTION_FORWARD;
 		nh->should_offload = 1;
+	} else if (nh->nhgi->is_resilient) {
+		nh->action = MLXSW_SP_NEXTHOP_ACTION_TRAP;
+		nh->should_offload = 1;
 	} else {
 		nh->should_offload = 0;
 	}
@@ -4484,6 +4488,15 @@ mlxsw_sp_nexthop_obj_init(struct mlxsw_sp *mlxsw_sp,
 	if (nh_obj->is_reject)
 		mlxsw_sp_nexthop_obj_blackhole_init(mlxsw_sp, nh);
 
+	/* In a resilient nexthop group, all the nexthops must be written to
+	 * the adjacency table. Even if they do not have a valid neighbour or
+	 * RIF.
+	 */
+	if (nh_grp->nhgi->is_resilient && !nh->should_offload) {
+		nh->action = MLXSW_SP_NEXTHOP_ACTION_TRAP;
+		nh->should_offload = 1;
+	}
+
 	return 0;
 
 err_type_init:
@@ -4500,6 +4513,7 @@ static void mlxsw_sp_nexthop_obj_fini(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_type_fini(mlxsw_sp, nh);
 	list_del(&nh->router_list_node);
 	mlxsw_sp_nexthop_counter_free(mlxsw_sp, nh);
+	nh->should_offload = 0;
 }
 
 static int
@@ -4509,6 +4523,7 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 {
 	struct mlxsw_sp_nexthop_group_info *nhgi;
 	struct mlxsw_sp_nexthop *nh;
+	bool is_resilient = false;
 	unsigned int nhs;
 	int err, i;
 
@@ -4519,6 +4534,10 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 	case NH_NOTIFIER_INFO_TYPE_GRP:
 		nhs = info->nh_grp->num_nh;
 		break;
+	case NH_NOTIFIER_INFO_TYPE_RES_TABLE:
+		nhs = info->nh_res_table->num_nh_buckets;
+		is_resilient = true;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -4529,6 +4548,7 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 	nh_grp->nhgi = nhgi;
 	nhgi->nh_grp = nh_grp;
 	nhgi->gateway = mlxsw_sp_nexthop_obj_is_gateway(mlxsw_sp, info);
+	nhgi->is_resilient = is_resilient;
 	nhgi->count = nhs;
 	for (i = 0; i < nhgi->count; i++) {
 		struct nh_notifier_single_info *nh_obj;
@@ -4544,6 +4564,10 @@ mlxsw_sp_nexthop_obj_group_info_init(struct mlxsw_sp *mlxsw_sp,
 			nh_obj = &info->nh_grp->nh_entries[i].nh;
 			weight = info->nh_grp->nh_entries[i].weight;
 			break;
+		case NH_NOTIFIER_INFO_TYPE_RES_TABLE:
+			nh_obj = &info->nh_res_table->nhs[i];
+			weight = 1;
+			break;
 		default:
 			err = -EINVAL;
 			goto err_nexthop_obj_init;
-- 
2.30.2

