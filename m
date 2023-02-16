Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3BA69891E
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 01:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjBPAJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 19:09:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjBPAJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 19:09:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0946C4391D
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 16:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9330761E17
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62DDC433A7;
        Thu, 16 Feb 2023 00:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676506165;
        bh=wft+r/SI49U6z7aCPZPZNiBVeb/xOepFD3Pqf1jhGh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=haAdSIJv57vP8fpBEUG/FktCPdZZzgG9hAsiy29Rguyq55yoshUpFXrtfwRvNDCOE
         GCREofVCB0oerLr4oV/XZhquNkVvhsmJEgUNORxyvFcL/Uvnt+DuR3hPpQQ+BYx4ba
         AR3JzEfz+o+lOA9zQBICq1yRERML0gBjdD1wjnJwSETHsn1OjsJEVYnah1jDKKEekJ
         2889O5BMiQ5D/a6K5NWwTYZK8uqBzGyckzclbOJiLPvtKFnAu0P+syb8TeHc3y+9dY
         m5f2gBA15CyX0K9f5VOAKSQX1YoQSbMtdGampmrGfSztLytyMoAtPVAuBjLi4Lfa4i
         ufUpXdJqddFbA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [net-next 6/9] net/mlx5e: Allow offloading of ct 'new' match
Date:   Wed, 15 Feb 2023 16:09:15 -0800
Message-Id: <20230216000918.235103-7-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230216000918.235103-1-saeed@kernel.org>
References: <20230216000918.235103-1-saeed@kernel.org>
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

Allow offloading filters that match on conntrack 'new' state in order to
enable UDP NEW offload in the following patch.

Unhardcode ct 'established' from ct modify header infrastructure code and
determine correct ct state bit according to the metadata action 'cookie'
field.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    | 21 ++++++++-----------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 76e86f83b6ac..58bbd0780260 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -35,6 +35,7 @@
 #define MLX5_CT_STATE_REPLY_BIT BIT(4)
 #define MLX5_CT_STATE_RELATED_BIT BIT(5)
 #define MLX5_CT_STATE_INVALID_BIT BIT(6)
+#define MLX5_CT_STATE_NEW_BIT BIT(7)
 
 #define MLX5_CT_LABELS_BITS MLX5_REG_MAPPING_MBITS(LABELS_TO_REG)
 #define MLX5_CT_LABELS_MASK MLX5_REG_MAPPING_MASK(LABELS_TO_REG)
@@ -721,12 +722,14 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
 	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
 	struct flow_action_entry *meta;
+	enum ip_conntrack_info ctinfo;
 	u16 ct_state = 0;
 	int err;
 
 	meta = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
 	if (!meta)
 		return -EOPNOTSUPP;
+	ctinfo = meta->ct_metadata.cookie & NFCT_INFOMASK;
 
 	err = mlx5_get_label_mapping(ct_priv, meta->ct_metadata.labels,
 				     &attr->ct_attr.ct_labels_id);
@@ -742,7 +745,8 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 		ct_state |= MLX5_CT_STATE_NAT_BIT;
 	}
 
-	ct_state |= MLX5_CT_STATE_ESTABLISHED_BIT | MLX5_CT_STATE_TRK_BIT;
+	ct_state |= MLX5_CT_STATE_TRK_BIT;
+	ct_state |= ctinfo == IP_CT_NEW ? MLX5_CT_STATE_NEW_BIT : MLX5_CT_STATE_ESTABLISHED_BIT;
 	ct_state |= meta->ct_metadata.orig_dir ? 0 : MLX5_CT_STATE_REPLY_BIT;
 	err = mlx5_tc_ct_entry_set_registers(ct_priv, &mod_acts,
 					     ct_state,
@@ -1181,16 +1185,12 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 	struct mlx5_tc_ct_priv *ct_priv = ft->ct_priv;
 	struct flow_action_entry *meta_action;
 	unsigned long cookie = flow->cookie;
-	enum ip_conntrack_info ctinfo;
 	struct mlx5_ct_entry *entry;
 	int err;
 
 	meta_action = mlx5_tc_ct_get_ct_metadata_action(flow_rule);
 	if (!meta_action)
 		return -EOPNOTSUPP;
-	ctinfo = meta_action->ct_metadata.cookie & NFCT_INFOMASK;
-	if (ctinfo == IP_CT_NEW)
-		return -EOPNOTSUPP;
 
 	spin_lock_bh(&ct_priv->ht_lock);
 	entry = rhashtable_lookup_fast(&ft->ct_entries_ht, &cookie, cts_ht_params);
@@ -1443,7 +1443,7 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		     struct mlx5_ct_attr *ct_attr,
 		     struct netlink_ext_ack *extack)
 {
-	bool trk, est, untrk, unest, new, rpl, unrpl, rel, unrel, inv, uninv;
+	bool trk, est, untrk, unnew, unest, new, rpl, unrpl, rel, unrel, inv, uninv;
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector_key_ct *mask, *key;
 	u32 ctstate = 0, ctstate_mask = 0;
@@ -1489,15 +1489,18 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 	rel = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_RELATED;
 	inv = ct_state_on & TCA_FLOWER_KEY_CT_FLAGS_INVALID;
 	untrk = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_TRACKED;
+	unnew = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_NEW;
 	unest = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED;
 	unrpl = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_REPLY;
 	unrel = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_RELATED;
 	uninv = ct_state_off & TCA_FLOWER_KEY_CT_FLAGS_INVALID;
 
 	ctstate |= trk ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate |= new ? MLX5_CT_STATE_NEW_BIT : 0;
 	ctstate |= est ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
 	ctstate |= rpl ? MLX5_CT_STATE_REPLY_BIT : 0;
 	ctstate_mask |= (untrk || trk) ? MLX5_CT_STATE_TRK_BIT : 0;
+	ctstate_mask |= (unnew || new) ? MLX5_CT_STATE_NEW_BIT : 0;
 	ctstate_mask |= (unest || est) ? MLX5_CT_STATE_ESTABLISHED_BIT : 0;
 	ctstate_mask |= (unrpl || rpl) ? MLX5_CT_STATE_REPLY_BIT : 0;
 	ctstate_mask |= unrel ? MLX5_CT_STATE_RELATED_BIT : 0;
@@ -1515,12 +1518,6 @@ mlx5_tc_ct_match_add(struct mlx5_tc_ct_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
-	if (new) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "matching on ct_state +new isn't supported");
-		return -EOPNOTSUPP;
-	}
-
 	if (mask->ct_zone)
 		mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG,
 					    key->ct_zone, MLX5_CT_ZONE_MASK);
-- 
2.39.1

