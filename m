Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A520145739
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAVNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:53:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41205 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726181AbgAVNxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:53:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Jan 2020 15:53:05 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00MDr4fH013119;
        Wed, 22 Jan 2020 15:53:05 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next-mlx5 v2 10/13] net/mlx5e: Disallow inserting vxlan/vlan egress rules without decap/pop
Date:   Wed, 22 Jan 2020 15:52:55 +0200
Message-Id: <1579701178-24624-11-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, rules on tunnel devices can be offloaded without decap action
when a vlan pop action exists. Similarly, the driver will offload rules
on vlan interfaces with no pop action when a decap action exists.

Disallow the faulty behavior by checking that vlan egress rules do pop or
drop and vxlan egress rules do decap, as intended.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 71c4e78..af7c917 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2636,6 +2636,8 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 				    struct mlx5e_tc_flow *flow,
 				    struct netlink_ext_ack *extack)
 {
+	struct net_device *filter_dev = parse_attr->filter_dev;
+	bool drop_action, decap_action, pop_action;
 	u32 actions;
 
 	if (mlx5e_is_eswitch_flow(flow))
@@ -2643,11 +2645,19 @@ static bool actions_match_supported(struct mlx5e_priv *priv,
 	else
 		actions = flow->nic_attr->action;
 
-	if (flow_flag_test(flow, EGRESS) &&
-	    !((actions & MLX5_FLOW_CONTEXT_ACTION_DECAP) ||
-	      (actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP) ||
-	      (actions & MLX5_FLOW_CONTEXT_ACTION_DROP)))
-		return false;
+	drop_action = actions & MLX5_FLOW_CONTEXT_ACTION_DROP;
+	decap_action = actions & MLX5_FLOW_CONTEXT_ACTION_DECAP;
+	pop_action = actions & MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
+
+	if (flow_flag_test(flow, EGRESS) && !drop_action) {
+		/* If no drop, we must decap (vxlan) or pop (vlan) */
+		if (mlx5e_get_tc_tun(filter_dev) && !decap_action)
+			return false;
+		else if (is_vlan_dev(filter_dev) && !pop_action)
+			return false;
+		else
+			return false; /* Sanity */
+	}
 
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR)
 		return modify_header_match_supported(&parse_attr->spec,
-- 
1.8.3.1

