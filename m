Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB97163CE9A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233349AbiK3FMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbiK3FM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:12:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5F4769CE
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E470CB81A3A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 05:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFD5C433D6;
        Wed, 30 Nov 2022 05:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669785127;
        bh=2nStQ6nOGek1babZIXl80T5+PRVMNa5FCaI1BXJdAaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTbJAQLsD/UWJIPBdmM66ISXBaG0+1P1bH6XVEGkONZd8phNkVQNcV9+NNv1Ff4+Q
         leudKvGChJx5PstM9L6yVGEmt0A/3T6p2iBq21uoUt7zDdHaCtSzwSCFMpsL0QMRC4
         dzIw5zStjlIJc2entVnJYeT1JxB2Dvnax7G8I775sJMYoW8/FkOLsfGxk86jw6u3PO
         uAR9EAk9/Q/PXilXAp4E9bOiaLy1phR/mE5iyumkEOaEiQDEPPs7Z5Pw2+UZb2/4+9
         e/WleGugM3Dt8v7tJVi5llHP/HdczTC5OWMne28Us0ZnCmJUbhNLgNxbnwKf2Wfv3V
         0+v1mKhJRRaPw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net-next 09/15] net/mlx5e: Don't use termination table when redundant
Date:   Tue, 29 Nov 2022 21:11:46 -0800
Message-Id: <20221130051152.479480-10-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130051152.479480-1-saeed@kernel.org>
References: <20221130051152.479480-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

Current code used termination table for each vport destination
while it's only required for hairpin, i.e. uplink to uplink, or
when vlan push on rx action being used.
Fix to skip using termination table for vport destinations that
do not require it.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index edd910258314..3a9a6bb9158d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -210,6 +210,18 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 	return (port_mask & port_value) == MLX5_VPORT_UPLINK;
 }
 
+static bool
+mlx5_eswitch_is_push_vlan_no_cap(struct mlx5_eswitch *esw,
+				 struct mlx5_flow_act *flow_act)
+{
+	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    !(mlx5_fs_get_capabilities(esw->dev, MLX5_FLOW_NAMESPACE_FDB) &
+	      MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX))
+		return true;
+
+	return false;
+}
+
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_attr *attr,
@@ -225,10 +237,7 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 	    (!mlx5_eswitch_offload_is_uplink_port(esw, spec) && !esw_attr->int_port))
 		return false;
 
-	/* push vlan on RX */
-	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
-	    !(mlx5_fs_get_capabilities(esw->dev, MLX5_FLOW_NAMESPACE_FDB) &
-	      MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX))
+	if (mlx5_eswitch_is_push_vlan_no_cap(esw, flow_act))
 		return true;
 
 	/* hairpin */
@@ -252,19 +261,31 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	struct mlx5_flow_act term_tbl_act = {};
 	struct mlx5_flow_handle *rule = NULL;
 	bool term_table_created = false;
+	bool is_push_vlan_on_rx;
 	int num_vport_dests = 0;
 	int i, curr_dest;
 
+	is_push_vlan_on_rx = mlx5_eswitch_is_push_vlan_no_cap(esw, flow_act);
 	mlx5_eswitch_termtbl_actions_move(flow_act, &term_tbl_act);
 	term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	for (i = 0; i < num_dest; i++) {
 		struct mlx5_termtbl_handle *tt;
+		bool hairpin = false;
 
 		/* only vport destinations can be terminated */
 		if (dest[i].type != MLX5_FLOW_DESTINATION_TYPE_VPORT)
 			continue;
 
+		if (attr->dests[num_vport_dests].rep &&
+		    attr->dests[num_vport_dests].rep->vport == MLX5_VPORT_UPLINK)
+			hairpin = true;
+
+		if (!is_push_vlan_on_rx && !hairpin) {
+			num_vport_dests++;
+			continue;
+		}
+
 		if (attr->dests[num_vport_dests].flags & MLX5_ESW_DEST_ENCAP) {
 			term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			term_tbl_act.pkt_reformat = attr->dests[num_vport_dests].pkt_reformat;
@@ -312,6 +333,9 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		if (!tt)
+			continue;
+
 		attr->dests[curr_dest].termtbl = NULL;
 
 		/* search for the destination associated with the
-- 
2.38.1

