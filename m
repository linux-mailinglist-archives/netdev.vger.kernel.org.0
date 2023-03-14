Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F696B8DFE
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 10:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCNJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 05:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjCNJAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 05:00:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412194F71
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 01:59:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73B816164E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E18C4339C;
        Tue, 14 Mar 2023 08:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678784387;
        bh=3mJ8gNu5CXKe0Sf2QxnZ5EgHjt4yU5iiraLEqGbHqjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVhE0TvkxFrYjTqqgoCE8ks7uHuVGmBwUayYEbMrI4yLylWxtiSjsqUgW8CQggNdF
         F3Q01YX3a8e785jTO4o/PKOrsIuHOkxMENYmbKRAu5dJx/RGAsmssg7ldjXf5PYyVK
         HMKLmoBP281D3fhuBBEkeVfopRFtLGZ6EfQ2u8Q+PXl86vrn53pgQHxSnT0LSkRUYW
         7pSVpGgU/n0lFRAyuoegB1Yr7uTA6LejHGS0BEYlLV+GPqOvLozkyIQ3cG1u2CrS6N
         DxK07WyVtaZa+wUOomX6y4bymUDYWIFBc7WXBA58v7YZf8oIGrKBNLriLYAcKLrjM3
         qlPYqHs8bxRLg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 9/9] net/mlx5e: Update IPsec per SA packets/bytes count
Date:   Tue, 14 Mar 2023 10:58:44 +0200
Message-Id: <7d5ce20ac495f3054afb633128700e7b7eeeb3cd.1678714336.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678714336.git.leon@kernel.org>
References: <cover.1678714336.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

Providing per SA packets/bytes statistics mandates creating unique
counter per SA flow for Rx/Tx, whenever offloaded SA statistics is
desired query the specific SA counter to provide the stack with the
needed data.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 20 +++------
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  4 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 44 ++++++++++++++-----
 .../mlx5/core/en_accel/ipsec_offload.c        | 15 -------
 4 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 20a6bd1c03a3..91fa0a366316 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -495,24 +495,18 @@ static void mlx5e_xfrm_advance_esn_state(struct xfrm_state *x)
 static void mlx5e_xfrm_update_curlft(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = to_ipsec_sa_entry(x);
-	int err;
+	struct mlx5e_ipsec_rule *ipsec_rule = &sa_entry->ipsec_rule;
+	u64 packets, bytes, lastuse;
 
-	lockdep_assert_held(&x->lock);
+	lockdep_assert(lockdep_is_held(&x->lock) ||
+		       lockdep_is_held(&dev_net(x->xso.real_dev)->xfrm.xfrm_cfg_mutex));
 
 	if (x->xso.flags & XFRM_DEV_OFFLOAD_FLAG_ACQ)
 		return;
 
-	if (sa_entry->attrs.soft_packet_limit == XFRM_INF)
-		/* Limits are not configured, as soft limit
-		 * must be lowever than hard limit.
-		 */
-		return;
-
-	err = mlx5e_ipsec_aso_query(sa_entry, NULL);
-	if (err)
-		return;
-
-	mlx5e_ipsec_aso_update_curlft(sa_entry, &x->curlft.packets);
+	mlx5_fc_query_cached(ipsec_rule->fc, &bytes, &packets, &lastuse);
+	x->curlft.packets += packets;
+	x->curlft.bytes += bytes;
 }
 
 static int mlx5e_xfrm_validate_policy(struct mlx5_core_dev *mdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index f3e81c3383e5..68ae5230eb75 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -162,6 +162,7 @@ struct mlx5e_ipsec_rule {
 	struct mlx5_flow_handle *rule;
 	struct mlx5_modify_hdr *modify_hdr;
 	struct mlx5_pkt_reformat *pkt_reformat;
+	struct mlx5_fc *fc;
 };
 
 struct mlx5e_ipsec_modify_state_work {
@@ -235,9 +236,6 @@ void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
 
 int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 			  struct mlx5_wqe_aso_ctrl_seg *data);
-void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
-				   u64 *packets);
-
 void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv,
 				     void *ipsec_stats);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index d1e4fd1e21d5..0539640a4d88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -876,11 +876,12 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_rx *rx;
+	struct mlx5_fc *counter;
 	int err;
 
 	rx = rx_ft_get(mdev, ipsec, attrs->family);
@@ -917,14 +918,22 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		break;
 	}
 
+	counter = mlx5_fc_create(mdev, true);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_add_cnt;
+	}
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.status;
-	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, &dest, 1);
+			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
+			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[0].ft = rx->ft.status;
+	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest[1].counter_id = mlx5_fc_id(counter);
+	rule = mlx5_add_flow_rules(rx->ft.sa, spec, &flow_act, dest, 2);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add RX ipsec rule err=%d\n", err);
@@ -934,10 +943,13 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	sa_entry->ipsec_rule.rule = rule;
 	sa_entry->ipsec_rule.modify_hdr = flow_act.modify_hdr;
+	sa_entry->ipsec_rule.fc = counter;
 	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
 	return 0;
 
 err_add_flow:
+	mlx5_fc_destroy(mdev, counter);
+err_add_cnt:
 	if (flow_act.pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
 err_pkt_reformat:
@@ -954,11 +966,12 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_tx *tx;
+	struct mlx5_fc *counter;
 	int err;
 
 	tx = tx_ft_get(mdev, ipsec);
@@ -996,15 +1009,23 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 		break;
 	}
 
+	counter = mlx5_fc_create(mdev, true);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_add_cnt;
+	}
+
 	flow_act.crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
 			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
-	dest.ft = tx->ft.status;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, &dest, 1);
+	dest[0].ft = tx->ft.status;
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest[1].counter_id = mlx5_fc_id(counter);
+	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, dest, 2);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
@@ -1013,10 +1034,13 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 	kvfree(spec);
 	sa_entry->ipsec_rule.rule = rule;
+	sa_entry->ipsec_rule.fc = counter;
 	sa_entry->ipsec_rule.pkt_reformat = flow_act.pkt_reformat;
 	return 0;
 
 err_add_flow:
+	mlx5_fc_destroy(mdev, counter);
+err_add_cnt:
 	if (flow_act.pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
 err_pkt_reformat:
@@ -1299,7 +1323,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 
 	mlx5_del_flow_rules(ipsec_rule->rule);
-
+	mlx5_fc_destroy(mdev, ipsec_rule->fc);
 	if (ipsec_rule->pkt_reformat)
 		mlx5_packet_reformat_dealloc(mdev, ipsec_rule->pkt_reformat);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 67be8d36bb76..5342b0b07681 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -489,18 +489,3 @@ int mlx5e_ipsec_aso_query(struct mlx5e_ipsec_sa_entry *sa_entry,
 	spin_unlock_bh(&aso->lock);
 	return ret;
 }
-
-void mlx5e_ipsec_aso_update_curlft(struct mlx5e_ipsec_sa_entry *sa_entry,
-				   u64 *packets)
-{
-	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
-	struct mlx5e_ipsec_aso *aso = ipsec->aso;
-	u64 hard_cnt;
-
-	hard_cnt = MLX5_GET(ipsec_aso, aso->ctx, remove_flow_pkt_cnt);
-	/* HW decresases the limit till it reaches zero to fire an avent.
-	 * We need to fix the calculations, so the returned count is a total
-	 * number of passed packets and not how much left.
-	 */
-	*packets = sa_entry->attrs.hard_packet_limit - hard_cnt;
-}
-- 
2.39.2

