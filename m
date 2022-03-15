Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 651374D9762
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346465AbiCOJQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346395AbiCOJQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:16:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E7D74BBAF;
        Tue, 15 Mar 2022 02:15:23 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0E22163018;
        Tue, 15 Mar 2022 10:13:03 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 5/6] net/mlx5: Support GRE conntrack offload
Date:   Tue, 15 Mar 2022 10:15:12 +0100
Message-Id: <20220315091513.66544-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315091513.66544-1-pablo@netfilter.org>
References: <20220315091513.66544-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toshiaki Makita <toshiaki.makita1@gmail.com>

Support GREv0 without NAT.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
Acked-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 875e77af0ae6..675bd6ede845 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -258,7 +258,8 @@ mlx5_tc_ct_rule_to_tuple(struct mlx5_ct_tuple *tuple, struct flow_rule *rule)
 			return -EOPNOTSUPP;
 		}
 	} else {
-		return -EOPNOTSUPP;
+		if (tuple->ip_proto != IPPROTO_GRE)
+			return -EOPNOTSUPP;
 	}
 
 	return 0;
@@ -807,7 +808,11 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->dest_chain = 0;
 	attr->dest_ft = mlx5e_tc_post_act_get_ft(ct_priv->post_act);
 	attr->ft = nat ? ct_priv->ct_nat : ct_priv->ct;
-	attr->outer_match_level = MLX5_MATCH_L4;
+	if (entry->tuple.ip_proto == IPPROTO_TCP ||
+	    entry->tuple.ip_proto == IPPROTO_UDP)
+		attr->outer_match_level = MLX5_MATCH_L4;
+	else
+		attr->outer_match_level = MLX5_MATCH_L3;
 	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
@@ -1224,16 +1229,20 @@ mlx5_tc_ct_skb_to_tuple(struct sk_buff *skb, struct mlx5_ct_tuple *tuple,
 	struct flow_keys flow_keys;
 
 	skb_reset_network_header(skb);
-	skb_flow_dissect_flow_keys(skb, &flow_keys, 0);
+	skb_flow_dissect_flow_keys(skb, &flow_keys, FLOW_DISSECTOR_F_STOP_BEFORE_ENCAP);
 
 	tuple->zone = zone;
 
 	if (flow_keys.basic.ip_proto != IPPROTO_TCP &&
-	    flow_keys.basic.ip_proto != IPPROTO_UDP)
+	    flow_keys.basic.ip_proto != IPPROTO_UDP &&
+	    flow_keys.basic.ip_proto != IPPROTO_GRE)
 		return false;
 
-	tuple->port.src = flow_keys.ports.src;
-	tuple->port.dst = flow_keys.ports.dst;
+	if (flow_keys.basic.ip_proto == IPPROTO_TCP ||
+	    flow_keys.basic.ip_proto == IPPROTO_UDP) {
+		tuple->port.src = flow_keys.ports.src;
+		tuple->port.dst = flow_keys.ports.dst;
+	}
 	tuple->n_proto = flow_keys.basic.n_proto;
 	tuple->ip_proto = flow_keys.basic.ip_proto;
 
-- 
2.30.2

