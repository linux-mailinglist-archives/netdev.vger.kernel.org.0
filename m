Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4029D60B774
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiJXTYo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiJXTWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:22:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3FDC45AB
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 10:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A6DCCE1367
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D43C433D7;
        Mon, 24 Oct 2022 11:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612468;
        bh=fD3etRuvpJArM/b+Ac9/WH1U7euaHBX61O48c9+lgkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XHdvBmlK2xtCYR6U0xOt3c78JNyLX2Mj2nINtnoLfBXtGeFqq2v8ikM3L8HWBmIEh
         /d+Y+hxP5G3eGadRs1xqTEYaXRCEaqxDBEryUxUorpGqFu/ByUTKz77EeVoT1JPAWS
         fgyLKXN+6BEq2Q3JT5wBWwFl5Y0W3rG3DoSxYWjApqJU1Emz3drPtRlssIz8H6v2Ec
         6saC0Tj3M06a8xiLQ9wb5V1H7xYqJ/iJZMPYJjkrzL80/K5pMTmOEtxCXaL3Na7Nyo
         wCOa73+x8Xy/ILnIB0jqR3r0WtrAVGve16b8uW/BzgMGAPuG/ttnXS+Lcd/MQTBgky
         FmIea+4ZMlvVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>
Subject: [V3 net 05/16] net/mlx5e: Update restore chain id for slow path packets
Date:   Mon, 24 Oct 2022 12:53:46 +0100
Message-Id: <20221024115357.37278-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

Currently encap slow path rules just forward to software without
setting the chain id miss register, so driver doesn't restore
the chain, and packets hitting this rule will restart from tc chain
0 instead of continuing to the chain the encap rule was on.

Fix this by setting the chain id miss register to the chain id mapping.

Fixes: 8f1e0b97cc70 ("net/mlx5: E-Switch, Mark miss packets with new chain id mapping")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 62 ++++++++++++++++++-
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index 10c9a8a79d00..2e42d7c5451e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -96,6 +96,7 @@ struct mlx5e_tc_flow {
 	struct encap_flow_item encaps[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5e_tc_flow *peer_flow;
 	struct mlx5e_mod_hdr_handle *mh; /* attached mod header instance */
+	struct mlx5e_mod_hdr_handle *slow_mh; /* attached mod header instance for slow path */
 	struct mlx5e_hairpin_entry *hpe; /* attached hairpin instance */
 	struct list_head hairpin; /* flows sharing the same hairpin */
 	struct list_head peer;    /* flows with peer flow */
@@ -111,6 +112,7 @@ struct mlx5e_tc_flow {
 	struct completion del_hw_done;
 	struct mlx5_flow_attr *attr;
 	struct list_head attrs;
+	u32 chain_mapping;
 };
 
 struct mlx5_flow_handle *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 70a7a61f9708..2cceace36c77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1405,8 +1405,13 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 			      struct mlx5e_tc_flow *flow,
 			      struct mlx5_flow_spec *spec)
 {
+	struct mlx5e_tc_mod_hdr_acts mod_acts = {};
+	struct mlx5e_mod_hdr_handle *mh = NULL;
 	struct mlx5_flow_attr *slow_attr;
 	struct mlx5_flow_handle *rule;
+	bool fwd_and_modify_cap;
+	u32 chain_mapping = 0;
+	int err;
 
 	slow_attr = mlx5_alloc_flow_attr(MLX5_FLOW_NAMESPACE_FDB);
 	if (!slow_attr)
@@ -1417,13 +1422,56 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 	slow_attr->esw_attr->split_count = 0;
 	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
 
+	fwd_and_modify_cap = MLX5_CAP_ESW_FLOWTABLE((esw)->dev, fdb_modify_header_fwd_to_table);
+	if (!fwd_and_modify_cap)
+		goto skip_restore;
+
+	err = mlx5_chains_get_chain_mapping(esw_chains(esw), flow->attr->chain, &chain_mapping);
+	if (err)
+		goto err_get_chain;
+
+	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
+					CHAIN_TO_REG, chain_mapping);
+	if (err)
+		goto err_reg_set;
+
+	mh = mlx5e_mod_hdr_attach(esw->dev, get_mod_hdr_table(flow->priv, flow),
+				  MLX5_FLOW_NAMESPACE_FDB, &mod_acts);
+	if (IS_ERR(mh)) {
+		err = PTR_ERR(mh);
+		goto err_attach;
+	}
+
+	slow_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+	slow_attr->modify_hdr = mlx5e_mod_hdr_get(mh);
+
+skip_restore:
 	rule = mlx5e_tc_offload_fdb_rules(esw, flow, spec, slow_attr);
-	if (!IS_ERR(rule))
-		flow_flag_set(flow, SLOW);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto err_offload;
+	}
 
+	flow->slow_mh = mh;
+	flow->chain_mapping = chain_mapping;
+	flow_flag_set(flow, SLOW);
+
+	mlx5e_mod_hdr_dealloc(&mod_acts);
 	kfree(slow_attr);
 
 	return rule;
+
+err_offload:
+	if (fwd_and_modify_cap)
+		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), mh);
+err_attach:
+err_reg_set:
+	if (fwd_and_modify_cap)
+		mlx5_chains_put_chain_mapping(esw_chains(esw), chain_mapping);
+err_get_chain:
+	mlx5e_mod_hdr_dealloc(&mod_acts);
+	kfree(slow_attr);
+	return ERR_PTR(err);
 }
 
 void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
@@ -1441,7 +1489,17 @@ void mlx5e_tc_unoffload_from_slow_path(struct mlx5_eswitch *esw,
 	slow_attr->action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	slow_attr->esw_attr->split_count = 0;
 	slow_attr->flags |= MLX5_ATTR_FLAG_SLOW_PATH;
+	if (flow->slow_mh) {
+		slow_attr->action |= MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
+		slow_attr->modify_hdr = mlx5e_mod_hdr_get(flow->slow_mh);
+	}
 	mlx5e_tc_unoffload_fdb_rules(esw, flow, slow_attr);
+	if (flow->slow_mh) {
+		mlx5e_mod_hdr_detach(esw->dev, get_mod_hdr_table(flow->priv, flow), flow->slow_mh);
+		mlx5_chains_put_chain_mapping(esw_chains(esw), flow->chain_mapping);
+		flow->chain_mapping = 0;
+		flow->slow_mh = NULL;
+	}
 	flow_flag_clear(flow, SLOW);
 	kfree(slow_attr);
 }
-- 
2.37.3

