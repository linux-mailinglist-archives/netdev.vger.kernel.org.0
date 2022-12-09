Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46AE647A94
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLIAOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIAOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:14:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D5E89AD3
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA9D6B826B7
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 00:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA1CC433F0;
        Fri,  9 Dec 2022 00:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544871;
        bh=f0DNy4pA787U43qixE2g4e10tVVIs1rixV8JPHQhjbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X/XiIdxEufIdTO33abNw6E2Ftpqk/kEJdotkr+g9xMRaQpzT18YVJ3R9Z9EhMoPEp
         nT7uiLBBzBcd7Heka0gKOqLR/R/WA4RAg49J4reG0scyv6hoNqrTVf7LwCydxcyURZ
         mm160Q1o322Sx06Dx69JcZPfMn51Q1koQgY+tOF6yjfgUYiuR9LV+PLZuWlSxSaBfO
         whyrtw+UUoAF1XZbUOmKqAFqzMmeNmaV2dZQa0rfFRzBicv1zO2m8wIMUp9KCaNt8e
         uT5yYmi2nIl49Rhidssj9QSjigMe7fcAV95g4Xbc3SvSIIQPtXGuO1qW0TPBpQMhpA
         LkFSXZycII57w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 02/15] net/mlx5: fs, add match on ranges API
Date:   Thu,  8 Dec 2022 16:14:07 -0800
Message-Id: <20221209001420.142794-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221209001420.142794-1-saeed@kernel.org>
References: <20221209001420.142794-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Range is a new flow destination type which allows matching on
a range of values instead of matching on a specific value.

Range flow destination has the following fields:
 - hit_ft: flow table to forward the traffic in case of hit
 - miss_ft: flow table to forward the traffic in case of miss
 - field: which packet characteristic to match on
 - min: minimal value for the selected field
 - max: maximal value for the selected field

Note:
 - In order to match, the value in the packet should meet
   the following criteria: min <= value < max
 - Currently, the only supported field type is L2 packet length

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/diag/fs_tracepoint.c      | 16 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/fs_core.c    | 11 +++++++++--
 .../net/ethernet/mellanox/mlx5/core/fs_core.h    |  1 +
 include/linux/mlx5/fs.h                          | 12 ++++++++++++
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
index c5bb79a4fa57..2732128e7a6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c
@@ -228,6 +228,17 @@ const char *parse_fs_hdrs(struct trace_seq *p,
 	return ret;
 }
 
+static const char
+*fs_dest_range_field_to_str(enum mlx5_flow_dest_range_field field)
+{
+	switch (field) {
+	case MLX5_FLOW_DEST_RANGE_FIELD_PKT_LEN:
+		return "packet len";
+	default:
+		return "unknown dest range field";
+	}
+}
+
 const char *parse_fs_dst(struct trace_seq *p,
 			 const struct mlx5_flow_destination *dst,
 			 u32 counter_id)
@@ -259,6 +270,11 @@ const char *parse_fs_dst(struct trace_seq *p,
 	case MLX5_FLOW_DESTINATION_TYPE_PORT:
 		trace_seq_printf(p, "port\n");
 		break;
+	case MLX5_FLOW_DESTINATION_TYPE_RANGE:
+		trace_seq_printf(p, "field=%s min=%d max=%d\n",
+				 fs_dest_range_field_to_str(dst->range.field),
+				 dst->range.min, dst->range.max);
+		break;
 	case MLX5_FLOW_DESTINATION_TYPE_NONE:
 		trace_seq_printf(p, "none\n");
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d53190f22871..4dcd26b86662 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -448,7 +448,8 @@ static bool is_fwd_dest_type(enum mlx5_flow_destination_type type)
 		type == MLX5_FLOW_DESTINATION_TYPE_UPLINK ||
 		type == MLX5_FLOW_DESTINATION_TYPE_VPORT ||
 		type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER ||
-		type == MLX5_FLOW_DESTINATION_TYPE_TIR;
+		type == MLX5_FLOW_DESTINATION_TYPE_TIR ||
+		type == MLX5_FLOW_DESTINATION_TYPE_RANGE;
 }
 
 static bool check_valid_spec(const struct mlx5_flow_spec *spec)
@@ -1578,7 +1579,13 @@ static bool mlx5_flow_dests_cmp(struct mlx5_flow_destination *d1,
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM &&
 		     d1->ft_num == d2->ft_num) ||
 		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_FLOW_SAMPLER &&
-		     d1->sampler_id == d2->sampler_id))
+		     d1->sampler_id == d2->sampler_id) ||
+		    (d1->type == MLX5_FLOW_DESTINATION_TYPE_RANGE &&
+		     d1->range.field == d2->range.field &&
+		     d1->range.hit_ft == d2->range.hit_ft &&
+		     d1->range.miss_ft == d2->range.miss_ft &&
+		     d1->range.min == d2->range.min &&
+		     d1->range.max == d2->range.max))
 			return true;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 3af50fd04d28..f137a0611b77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -123,6 +123,7 @@ enum mlx5_flow_steering_mode {
 enum mlx5_flow_steering_capabilty {
 	MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX = 1UL << 0,
 	MLX5_FLOW_STEERING_CAP_VLAN_POP_ON_TX = 1UL << 1,
+	MLX5_FLOW_STEERING_CAP_MATCH_RANGES = 1UL << 2,
 };
 
 struct mlx5_flow_steering {
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index c7a91981cd5a..ba6958b49a8e 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -50,6 +50,7 @@ enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_PORT,
 	MLX5_FLOW_DESTINATION_TYPE_COUNTER,
 	MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE_NUM,
+	MLX5_FLOW_DESTINATION_TYPE_RANGE,
 };
 
 enum {
@@ -143,6 +144,10 @@ enum {
 	MLX5_FLOW_DEST_VPORT_REFORMAT_ID  = BIT(1),
 };
 
+enum mlx5_flow_dest_range_field {
+	MLX5_FLOW_DEST_RANGE_FIELD_PKT_LEN = 0,
+};
+
 struct mlx5_flow_destination {
 	enum mlx5_flow_destination_type	type;
 	union {
@@ -156,6 +161,13 @@ struct mlx5_flow_destination {
 			struct mlx5_pkt_reformat *pkt_reformat;
 			u8		flags;
 		} vport;
+		struct {
+			struct mlx5_flow_table         *hit_ft;
+			struct mlx5_flow_table         *miss_ft;
+			enum mlx5_flow_dest_range_field field;
+			u32                             min;
+			u32                             max;
+		} range;
 		u32			sampler_id;
 	};
 };
-- 
2.38.1

