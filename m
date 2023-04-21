Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864346EA145
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbjDUBv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbjDUBv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0239072AB
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E36064C64
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC62C433D2;
        Fri, 21 Apr 2023 01:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041906;
        bh=OO44sk/qI8PkzC1Szvy0pZUGlnA0NkGbSY5aUDWhflQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kHkbY8qWI8vEgiTaAqvrf3q0JjSEWg2GvSwE5KstbsqyQcr0r2QmasQwFxDugZSb8
         Nj/coEzHB5I0x2U0hHUWNGUM7wZGAQqxDJNohghluSlUxTWs3yUre2W093Ck/Ocol2
         fnOVsdyzNxTg7EMv6WQfWSVCvJAp3cYQRm3TBA4FhZiIlsaO0NUjcbO4gbT2ODvrmr
         pPFj+aVdK69qwX42EnkfY1ndFg+yxbiq+SJTDngsaBkIXu1KpFL1CIH0Tq673jjdoX
         HjYHYKYltaBEbrZtd/vUU0XiD5Z90mJTMmSoIaTizZu9Dv30EcGGcpF+DPbvz1vCUG
         1lG7s9MX1ji+Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net V2 10/10] Revert "net/mlx5e: Don't use termination table when redundant"
Date:   Thu, 20 Apr 2023 18:50:57 -0700
Message-Id: <20230421015057.355468-11-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421015057.355468-1-saeed@kernel.org>
References: <20230421015057.355468-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

This reverts commit 14624d7247fcd0f3114a6f5f17b3c8d1020fbbb7.

The termination table usage is requires for DMFS steering mode as firmware
doesn't support mixed table destinations list which causes following
syndrome with hairpin rules:

[81922.283225] mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 25977): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0xaca205), err(-22)

Fixes: 14624d7247fc ("net/mlx5e: Don't use termination table when redundant")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 32 +++----------------
 1 file changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 3a9a6bb9158d..edd910258314 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -210,18 +210,6 @@ static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch *esw,
 	return (port_mask & port_value) == MLX5_VPORT_UPLINK;
 }
 
-static bool
-mlx5_eswitch_is_push_vlan_no_cap(struct mlx5_eswitch *esw,
-				 struct mlx5_flow_act *flow_act)
-{
-	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
-	    !(mlx5_fs_get_capabilities(esw->dev, MLX5_FLOW_NAMESPACE_FDB) &
-	      MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX))
-		return true;
-
-	return false;
-}
-
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_attr *attr,
@@ -237,7 +225,10 @@ mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 	    (!mlx5_eswitch_offload_is_uplink_port(esw, spec) && !esw_attr->int_port))
 		return false;
 
-	if (mlx5_eswitch_is_push_vlan_no_cap(esw, flow_act))
+	/* push vlan on RX */
+	if (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    !(mlx5_fs_get_capabilities(esw->dev, MLX5_FLOW_NAMESPACE_FDB) &
+	      MLX5_FLOW_STEERING_CAP_VLAN_PUSH_ON_RX))
 		return true;
 
 	/* hairpin */
@@ -261,31 +252,19 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	struct mlx5_flow_act term_tbl_act = {};
 	struct mlx5_flow_handle *rule = NULL;
 	bool term_table_created = false;
-	bool is_push_vlan_on_rx;
 	int num_vport_dests = 0;
 	int i, curr_dest;
 
-	is_push_vlan_on_rx = mlx5_eswitch_is_push_vlan_no_cap(esw, flow_act);
 	mlx5_eswitch_termtbl_actions_move(flow_act, &term_tbl_act);
 	term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
 	for (i = 0; i < num_dest; i++) {
 		struct mlx5_termtbl_handle *tt;
-		bool hairpin = false;
 
 		/* only vport destinations can be terminated */
 		if (dest[i].type != MLX5_FLOW_DESTINATION_TYPE_VPORT)
 			continue;
 
-		if (attr->dests[num_vport_dests].rep &&
-		    attr->dests[num_vport_dests].rep->vport == MLX5_VPORT_UPLINK)
-			hairpin = true;
-
-		if (!is_push_vlan_on_rx && !hairpin) {
-			num_vport_dests++;
-			continue;
-		}
-
 		if (attr->dests[num_vport_dests].flags & MLX5_ESW_DEST_ENCAP) {
 			term_tbl_act.action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			term_tbl_act.pkt_reformat = attr->dests[num_vport_dests].pkt_reformat;
@@ -333,9 +312,6 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
-		if (!tt)
-			continue;
-
 		attr->dests[curr_dest].termtbl = NULL;
 
 		/* search for the destination associated with the
-- 
2.39.2

