Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8D86D8D2F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbjDFCDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbjDFCDA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:03:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1D486A8
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC7F62D0C
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA7FC433D2;
        Thu,  6 Apr 2023 02:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680746570;
        bh=6PUOL3n1gkoSupPMeXj5TqXFPhFOxjqJWJO9m8yWXmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJ+yqvtLv8VZnjRqqlKZXkaMTu4RmyZlRZl+0dZg4//aF1ixioa76JxA87wguG3pK
         LTVdppeCtvxngHZts1QFaG9hv57j7+plUZ7EUQtGp9katejZTFbsh+zQLmE2W+ysoO
         bINbPECOQt7KX6e3bZZ32wDEdGmJ26SKrULGXPi+FlksjHsOetyHvyKZaqWjz1kYXZ
         G4zunk6PmDRczjJ8DFYnSdP7awvlk+P2sqMA3m64z6LBOLOO74VqViDqQ+eR8yUYvM
         qtTSO2xLDzAAJxmlKK3194Jmcs19zIV9hL+dhtxDxz+2v/R5OaHBm0p6j4C2MLmtZa
         BG0AoZGt+sXaA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 08/15] net/mlx5e: TC, Remove tuple rewrite and ct limitation
Date:   Wed,  5 Apr 2023 19:02:25 -0700
Message-Id: <20230406020232.83844-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406020232.83844-1-saeed@kernel.org>
References: <20230406020232.83844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Tuple rewrite and ct action was not supported when only chain was
restored on misses. To work around that limitation, ct action was
reordered to be first (so if hw misses on ct action, packet wasn't
modified). This reordering wasn't possible for tuple rewrite
actions before ct action since the ct action result was
dependent on the tuple info.

Now that the misses continue from the relevant tc ct action
in software and ct action is no longer reordered, this case
is supported.

Remove this limitation.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 142 ++++--------------
 1 file changed, 33 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d8fa8f0c0fbf..b6469abc7012 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3423,114 +3423,59 @@ struct ipv6_hoplimit_word {
 };
 
 static bool
-is_action_keys_supported(const struct flow_action_entry *act, bool ct_flow,
-			 bool *modify_ip_header, bool *modify_tuple,
-			 struct netlink_ext_ack *extack)
+is_flow_action_modify_ip_header(struct flow_action *flow_action)
 {
+	const struct flow_action_entry *act;
 	u32 mask, offset;
 	u8 htype;
+	int i;
 
-	htype = act->mangle.htype;
-	offset = act->mangle.offset;
-	mask = ~act->mangle.mask;
 	/* For IPv4 & IPv6 header check 4 byte word,
 	 * to determine that modified fields
 	 * are NOT ttl & hop_limit only.
 	 */
-	if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP4) {
-		struct ip_ttl_word *ttl_word =
-			(struct ip_ttl_word *)&mask;
-
-		if (offset != offsetof(struct iphdr, ttl) ||
-		    ttl_word->protocol ||
-		    ttl_word->check) {
-			*modify_ip_header = true;
-		}
-
-		if (offset >= offsetof(struct iphdr, saddr))
-			*modify_tuple = true;
+	flow_action_for_each(i, act, flow_action) {
+		if (act->id != FLOW_ACTION_MANGLE &&
+		    act->id != FLOW_ACTION_ADD)
+			continue;
 
-		if (ct_flow && *modify_tuple) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "can't offload re-write of ipv4 address with action ct");
-			return false;
-		}
-	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
-		struct ipv6_hoplimit_word *hoplimit_word =
-			(struct ipv6_hoplimit_word *)&mask;
-
-		if (offset != offsetof(struct ipv6hdr, payload_len) ||
-		    hoplimit_word->payload_len ||
-		    hoplimit_word->nexthdr) {
-			*modify_ip_header = true;
-		}
-
-		if (ct_flow && offset >= offsetof(struct ipv6hdr, saddr))
-			*modify_tuple = true;
-
-		if (ct_flow && *modify_tuple) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "can't offload re-write of ipv6 address with action ct");
-			return false;
-		}
-	} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_TCP ||
-		   htype == FLOW_ACT_MANGLE_HDR_TYPE_UDP) {
-		*modify_tuple = true;
-		if (ct_flow) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "can't offload re-write of transport header ports with action ct");
-			return false;
+		htype = act->mangle.htype;
+		offset = act->mangle.offset;
+		mask = ~act->mangle.mask;
+
+		if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP4) {
+			struct ip_ttl_word *ttl_word =
+				(struct ip_ttl_word *)&mask;
+
+			if (offset != offsetof(struct iphdr, ttl) ||
+			    ttl_word->protocol ||
+			    ttl_word->check)
+				return true;
+		} else if (htype == FLOW_ACT_MANGLE_HDR_TYPE_IP6) {
+			struct ipv6_hoplimit_word *hoplimit_word =
+				(struct ipv6_hoplimit_word *)&mask;
+
+			if (offset != offsetof(struct ipv6hdr, payload_len) ||
+			    hoplimit_word->payload_len ||
+			    hoplimit_word->nexthdr)
+				return true;
 		}
 	}
 
-	return true;
-}
-
-static bool modify_tuple_supported(bool modify_tuple, bool ct_clear,
-				   bool ct_flow, struct netlink_ext_ack *extack,
-				   struct mlx5e_priv *priv,
-				   struct mlx5_flow_spec *spec)
-{
-	if (!modify_tuple || ct_clear)
-		return true;
-
-	if (ct_flow) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload tuple modification with non-clear ct()");
-		netdev_info(priv->netdev,
-			    "can't offload tuple modification with non-clear ct()");
-		return false;
-	}
-
-	/* Add ct_state=-trk match so it will be offloaded for non ct flows
-	 * (or after clear action), as otherwise, since the tuple is changed,
-	 * we can't restore ct state
-	 */
-	if (mlx5_tc_ct_add_no_trk_match(spec)) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "can't offload tuple modification with ct matches and no ct(clear) action");
-		netdev_info(priv->netdev,
-			    "can't offload tuple modification with ct matches and no ct(clear) action");
-		return false;
-	}
-
-	return true;
+	return false;
 }
 
 static bool modify_header_match_supported(struct mlx5e_priv *priv,
 					  struct mlx5_flow_spec *spec,
 					  struct flow_action *flow_action,
-					  u32 actions, bool ct_flow,
-					  bool ct_clear,
+					  u32 actions,
 					  struct netlink_ext_ack *extack)
 {
-	const struct flow_action_entry *act;
-	bool modify_ip_header, modify_tuple;
+	bool modify_ip_header;
 	void *headers_c;
 	void *headers_v;
 	u16 ethertype;
 	u8 ip_proto;
-	int i;
 
 	headers_c = mlx5e_get_match_headers_criteria(actions, spec);
 	headers_v = mlx5e_get_match_headers_value(actions, spec);
@@ -3541,23 +3486,7 @@ static bool modify_header_match_supported(struct mlx5e_priv *priv,
 	    ethertype != ETH_P_IP && ethertype != ETH_P_IPV6)
 		goto out_ok;
 
-	modify_ip_header = false;
-	modify_tuple = false;
-	flow_action_for_each(i, act, flow_action) {
-		if (act->id != FLOW_ACTION_MANGLE &&
-		    act->id != FLOW_ACTION_ADD)
-			continue;
-
-		if (!is_action_keys_supported(act, ct_flow,
-					      &modify_ip_header,
-					      &modify_tuple, extack))
-			return false;
-	}
-
-	if (!modify_tuple_supported(modify_tuple, ct_clear, ct_flow, extack,
-				    priv, spec))
-		return false;
-
+	modify_ip_header = is_flow_action_modify_ip_header(flow_action);
 	ip_proto = MLX5_GET(fte_match_set_lyr_2_4, headers_v, ip_protocol);
 	if (modify_ip_header && ip_proto != IPPROTO_TCP &&
 	    ip_proto != IPPROTO_UDP && ip_proto != IPPROTO_ICMP) {
@@ -3611,14 +3540,9 @@ actions_match_supported(struct mlx5e_priv *priv,
 			struct mlx5e_tc_flow *flow,
 			struct netlink_ext_ack *extack)
 {
-	bool ct_flow, ct_clear;
-
-	ct_clear = flow->attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR;
-	ct_flow = flow_flag_test(flow, CT) && !ct_clear;
-
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
-	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action,
-					   actions, ct_flow, ct_clear, extack))
+	    !modify_header_match_supported(priv, &parse_attr->spec, flow_action, actions,
+					   extack))
 		return false;
 
 	if (mlx5e_is_eswitch_flow(flow) &&
-- 
2.39.2

