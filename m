Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E58263334B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbiKVC2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiKVC2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E6B523E9A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A08AD61543
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7C1C433D6;
        Tue, 22 Nov 2022 02:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084110;
        bh=e5Iiydur7cuX3m0AvON/jnuZBmbjVxSwCsPmbZH21TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Be2Ftmp80rPKOoc9p5yVKfMLf5ctB9tGZj4RZN+zRpvhRAWrLCcwoBNPnylqD1I+7
         yhihRrEXDGYlL0S/M3J8yWyiAewuL3uTy4dm+IvQ24cReuneGVFh1EUb9BK/Z+8hFC
         QyRoeORNguTXcMuSw6HzYusRIkmeW2SvY82lmDav5IXUhW5t+ueeI7mAWwZkdgZg4K
         9IJPuoV73DMuY7olwx72BmXwb1OFzu8/TmsLJaSkYYv5ACPhagH0VjtkZHxF8r91ep
         9y2zPhmGbb1sOfEMltbYKOmpZliVDyva7f1CRVeJOeyXpM805xtpXmy39AMrtxBz9Q
         c/iyNEfUbuQqQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Chris Mi <cmi@nvidia.com>
Subject: [net 07/14] net/mlx5: E-Switch, Set correctly vport destination
Date:   Mon, 21 Nov 2022 18:25:52 -0800
Message-Id: <20221122022559.89459-8-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
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

The cited commit moved from using reformat_id integer to packet_reformat
pointer which introduced the possibility to null pointer dereference.
When setting packet reformat flag and pkt_reformat pointer must
exists so checking MLX5_ESW_DEST_ENCAP is not enough, we need
to make sure the pkt_reformat is valid and check for MLX5_ESW_DEST_ENCAP_VALID.
If the dest encap valid flag does not exists then pkt_reformat can be
either invalid address or null.
Also, to make sure we don't try to access invalid pkt_reformat set it to
null when invalidated and invalidate it before calling add flow code as
its logically more correct and to be safe.

Fixes: 2b688ea5efde ("net/mlx5: Add flow steering actions to fs_cmd shim layer")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  | 10 ++++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 5aff97914367..5b6a79d2034e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -224,15 +224,16 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	list_for_each_entry(flow, flow_list, tmp_list) {
 		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
 			continue;
-		spec = &flow->attr->parse_attr->spec;
-
-		/* update from encap rule to slow path rule */
-		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 
 		attr = mlx5e_tc_get_encap_attr(flow);
 		esw_attr = attr->esw_attr;
 		/* mark the flow's encap dest as non-valid */
 		esw_attr->dests[flow->tmp_entry_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
+		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = NULL;
+
+		/* update from encap rule to slow path rule */
+		spec = &flow->attr->parse_attr->spec;
+		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 
 		if (IS_ERR(rule)) {
 			err = PTR_ERR(rule);
@@ -251,6 +252,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	/* we know that the encap is valid */
 	e->flags &= ~MLX5_ENCAP_ENTRY_VALID;
 	mlx5_packet_reformat_dealloc(priv->mdev, e->pkt_reformat);
+	e->pkt_reformat = NULL;
 }
 
 static void mlx5e_take_tmp_flow(struct mlx5e_tc_flow *flow,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 728ca9f2bb9d..3fda75fe168c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -433,7 +433,7 @@ esw_setup_vport_dest(struct mlx5_flow_destination *dest, struct mlx5_flow_act *f
 		    mlx5_lag_mpesw_is_activated(esw->dev))
 			dest[dest_idx].type = MLX5_FLOW_DESTINATION_TYPE_UPLINK;
 	}
-	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP) {
+	if (esw_attr->dests[attr_idx].flags & MLX5_ESW_DEST_ENCAP_VALID) {
 		if (pkt_reformat) {
 			flow_act->action |= MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT;
 			flow_act->pkt_reformat = esw_attr->dests[attr_idx].pkt_reformat;
-- 
2.38.1

