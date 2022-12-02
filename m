Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45424640EFD
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiLBUPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbiLBUPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD546D7FC
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD3F0623AF
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95313C433C1;
        Fri,  2 Dec 2022 20:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670012130;
        bh=yGOcdWTluOuSVuNddQZQZSuJclsMLTiAl3b/anaSyM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q4Hl95VvLiMs9nlpta+2zT3etfzJcjgb8Q7x2eRBSVHqXgU10+wLdm18bhViaitYG
         UmXKpshvOcyDkxr3ec7wslXXA4dpzcdHH2QzWSYPlBSdvBE0KbV3jXvbU5gtuWn4bL
         jRSa/rFMs4TJRmrNOk8ZqvQDPyZBiuj/dUmv+wnHylaLZ4kaIZ+ubeSILNhOmH0LW2
         FC1nG1VjOldQboTbM1F6w3jL4Sk9B06DjDTRpaCLENn0/CIXPxqkL+KC1NiJ5HxWtR
         M1Fg0gg96YtX/UjzdgSng4NQTbW6O6i0fZi64hBZMeU62kCz/UwjxP8IPlxzjcL7bu
         IE1kgbiKFL1zg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Raed Salem <raeds@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next 06/13] net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows
Date:   Fri,  2 Dec 2022 22:14:50 +0200
Message-Id: <cdedf4ca8184665c7e665cd61c3ea4a19856fc88.1670011885.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011885.git.leonro@nvidia.com>
References: <cover.1670011885.git.leonro@nvidia.com>
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

From: Raed Salem <raeds@nvidia.com>

Add the following statistics:
RX successfully IPsec flows:
ipsec_rx_pkts  : Number of packets passed Rx IPsec flow
ipsec_rx_bytes : Number of bytes passed Rx IPsec flow

Rx dropped IPsec policy packets:
ipsec_rx_drop_pkts: Number of packets dropped in Rx datapath due to IPsec drop policy
ipsec_rx_drop_bytes: Number of bytes dropped in Rx datapath due to IPsec drop policy

TX successfully encrypted and encapsulated IPsec packets:
ipsec_tx_pkts  : Number of packets encrypted and encapsulated successfully
ipsec_tx_bytes : Number of bytes encrypted and encapsulated successfully

Tx dropped IPsec policy packets:
ipsec_tx_drop_pkts: Number of packets dropped in Tx datapath due to IPsec drop policy
ipsec_tx_drop_bytes: Number of bytes dropped in Tx datapath due to IPsec drop policy

The above can be seen using:
ethtool -S <ifc> |grep ipsec

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  15 ++
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 188 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c |  52 +++++
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   1 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   1 +
 5 files changed, 233 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 25b865590488..2e7654e90314 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -87,6 +87,17 @@ enum mlx5_ipsec_cap {
 
 struct mlx5e_priv;
 
+struct mlx5e_ipsec_hw_stats {
+	u64 ipsec_rx_pkts;
+	u64 ipsec_rx_bytes;
+	u64 ipsec_rx_drop_pkts;
+	u64 ipsec_rx_drop_bytes;
+	u64 ipsec_tx_pkts;
+	u64 ipsec_tx_bytes;
+	u64 ipsec_tx_drop_pkts;
+	u64 ipsec_tx_drop_bytes;
+};
+
 struct mlx5e_ipsec_sw_stats {
 	atomic64_t ipsec_rx_drop_sp_alloc;
 	atomic64_t ipsec_rx_drop_sadb_miss;
@@ -111,6 +122,7 @@ struct mlx5e_ipsec {
 	DECLARE_HASHTABLE(sadb_rx, MLX5E_IPSEC_SADB_RX_BITS);
 	spinlock_t sadb_rx_lock; /* Protects sadb_rx */
 	struct mlx5e_ipsec_sw_stats sw_stats;
+	struct mlx5e_ipsec_hw_stats hw_stats;
 	struct workqueue_struct *wq;
 	struct mlx5e_flow_steering *fs;
 	struct mlx5e_ipsec_rx *rx_ipv4;
@@ -200,6 +212,9 @@ void mlx5_accel_esp_modify_xfrm(struct mlx5e_ipsec_sa_entry *sa_entry,
 int mlx5e_ipsec_aso_init(struct mlx5e_ipsec *ipsec);
 void mlx5e_ipsec_aso_cleanup(struct mlx5e_ipsec *ipsec);
 
+void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv,
+				     void *ipsec_stats);
+
 static inline struct mlx5_core_dev *
 mlx5e_ipsec_sa2dev(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 0af831128c4e..8ba92b00afdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -9,6 +9,11 @@
 
 #define NUM_IPSEC_FTE BIT(15)
 
+struct mlx5e_ipsec_fc {
+	struct mlx5_fc *cnt;
+	struct mlx5_fc *drop;
+};
+
 struct mlx5e_ipsec_ft {
 	struct mutex mutex; /* Protect changes to this struct */
 	struct mlx5_flow_table *pol;
@@ -27,12 +32,14 @@ struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_miss pol;
 	struct mlx5e_ipsec_miss sa;
 	struct mlx5e_ipsec_rule status;
+	struct mlx5e_ipsec_fc *fc;
 };
 
 struct mlx5e_ipsec_tx {
 	struct mlx5e_ipsec_ft ft;
 	struct mlx5e_ipsec_miss pol;
 	struct mlx5_flow_namespace *ns;
+	struct mlx5e_ipsec_fc *fc;
 };
 
 /* IPsec RX flow steering */
@@ -93,9 +100,10 @@ static int ipsec_status_rule(struct mlx5_core_dev *mdev,
 
 	/* create fte */
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_MOD_HDR |
-			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+			  MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
+			  MLX5_FLOW_CONTEXT_ACTION_COUNT;
 	flow_act.modify_hdr = modify_hdr;
-	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act, dest, 1);
+	fte = mlx5_add_flow_rules(rx->ft.status, spec, &flow_act, dest, 2);
 	if (IS_ERR(fte)) {
 		err = PTR_ERR(fte);
 		mlx5_core_err(mdev, "fail to add ipsec rx err copy rule err=%d\n", err);
@@ -178,7 +186,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 {
 	struct mlx5_flow_namespace *ns = mlx5e_fs_get_ns(ipsec->fs, false);
 	struct mlx5_ttc_table *ttc = mlx5e_fs_get_ttc(ipsec->fs, false);
-	struct mlx5_flow_destination dest;
+	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_table *ft;
 	int err;
 
@@ -189,8 +197,10 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	rx->ft.status = ft;
 
-	dest = mlx5_ttc_get_default_dest(ttc, family2tt(family));
-	err = ipsec_status_rule(mdev, rx, &dest);
+	dest[0] = mlx5_ttc_get_default_dest(ttc, family2tt(family));
+	dest[1].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest[1].counter_id = mlx5_fc_id(rx->fc->cnt);
+	err = ipsec_status_rule(mdev, rx, dest);
 	if (err)
 		goto err_add;
 
@@ -203,7 +213,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	}
 	rx->ft.sa = ft;
 
-	err = ipsec_miss_create(mdev, rx->ft.sa, &rx->sa, &dest);
+	err = ipsec_miss_create(mdev, rx->ft.sa, &rx->sa, dest);
 	if (err)
 		goto err_fs;
 
@@ -214,10 +224,10 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		goto err_pol_ft;
 	}
 	rx->ft.pol = ft;
-	memset(&dest, 0x00, sizeof(dest));
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.sa;
-	err = ipsec_miss_create(mdev, rx->ft.pol, &rx->pol, &dest);
+	memset(dest, 0x00, 2 * sizeof(*dest));
+	dest[0].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[0].ft = rx->ft.sa;
+	err = ipsec_miss_create(mdev, rx->ft.pol, &rx->pol, dest);
 	if (err)
 		goto err_pol_miss;
 
@@ -605,6 +615,7 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct mlx5e_ipsec *ipsec = sa_entry->ipsec;
+	struct mlx5_flow_destination dest = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
@@ -647,8 +658,11 @@ static int tx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 	flow_act.crypto.obj_id = sa_entry->ipsec_obj_id;
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
 	flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_ALLOW |
-			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
-	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, NULL, 0);
+			   MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT |
+			   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+	dest.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dest.counter_id = mlx5_fc_id(tx->fc->cnt);
+	rule = mlx5_add_flow_rules(tx->ft.sa, spec, &flow_act, &dest, 1);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
@@ -674,12 +688,12 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	struct mlx5_accel_pol_xfrm_attrs *attrs = &pol_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
-	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_destination dest[2] = {};
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_tx *tx;
-	int err;
+	int err, dstn = 0;
 
 	tx = tx_ft_get(mdev, pol_entry->ipsec);
 	if (IS_ERR(tx))
@@ -703,7 +717,11 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 		break;
 	case XFRM_POLICY_BLOCK:
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP |
+				   MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		dest[dstn].counter_id = mlx5_fc_id(tx->fc->drop);
+		dstn++;
 		break;
 	default:
 		WARN_ON(true);
@@ -712,9 +730,10 @@ static int tx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	}
 
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	dest.ft = tx->ft.sa;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	rule = mlx5_add_flow_rules(tx->ft.pol, spec, &flow_act, &dest, 1);
+	dest[dstn].ft = tx->ft.sa;
+	dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dstn++;
+	rule = mlx5_add_flow_rules(tx->ft.pol, spec, &flow_act, dest, dstn);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "fail to add TX ipsec rule err=%d\n", err);
@@ -736,12 +755,12 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 {
 	struct mlx5_accel_pol_xfrm_attrs *attrs = &pol_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_pol2dev(pol_entry);
-	struct mlx5_flow_destination dest = {};
+	struct mlx5_flow_destination dest[2];
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
 	struct mlx5_flow_spec *spec;
 	struct mlx5e_ipsec_rx *rx;
-	int err;
+	int err, dstn = 0;
 
 	rx = rx_ft_get(mdev, pol_entry->ipsec, attrs->family);
 	if (IS_ERR(rx))
@@ -765,7 +784,10 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 		break;
 	case XFRM_POLICY_BLOCK:
-		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_DROP | MLX5_FLOW_CONTEXT_ACTION_COUNT;
+		dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+		dest[dstn].counter_id = mlx5_fc_id(rx->fc->drop);
+		dstn++;
 		break;
 	default:
 		WARN_ON(true);
@@ -774,9 +796,10 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	}
 
 	flow_act.flags |= FLOW_ACT_NO_APPEND;
-	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest.ft = rx->ft.sa;
-	rule = mlx5_add_flow_rules(rx->ft.pol, spec, &flow_act, &dest, 1);
+	dest[dstn].type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest[dstn].ft = rx->ft.sa;
+	dstn++;
+	rule = mlx5_add_flow_rules(rx->ft.pol, spec, &flow_act, dest, dstn);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
 		mlx5_core_err(mdev, "Fail to add RX IPsec policy rule err=%d\n", err);
@@ -794,6 +817,116 @@ static int rx_add_policy(struct mlx5e_ipsec_pol_entry *pol_entry)
 	return err;
 }
 
+static void ipsec_fs_destroy_counters(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5e_ipsec_rx *rx_ipv4 = ipsec->rx_ipv4;
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
+
+	mlx5_fc_destroy(mdev, tx->fc->drop);
+	mlx5_fc_destroy(mdev, tx->fc->cnt);
+	kfree(tx->fc);
+	mlx5_fc_destroy(mdev, rx_ipv4->fc->drop);
+	mlx5_fc_destroy(mdev, rx_ipv4->fc->cnt);
+	kfree(rx_ipv4->fc);
+}
+
+static int ipsec_fs_init_counters(struct mlx5e_ipsec *ipsec)
+{
+	struct mlx5e_ipsec_rx *rx_ipv4 = ipsec->rx_ipv4;
+	struct mlx5e_ipsec_rx *rx_ipv6 = ipsec->rx_ipv6;
+	struct mlx5_core_dev *mdev = ipsec->mdev;
+	struct mlx5e_ipsec_tx *tx = ipsec->tx;
+	struct mlx5e_ipsec_fc *fc;
+	struct mlx5_fc *counter;
+	int err;
+
+	fc = kzalloc(sizeof(*rx_ipv4->fc), GFP_KERNEL);
+	if (!fc)
+		return -ENOMEM;
+
+	/* Both IPv4 and IPv6 point to same flow counters struct. */
+	rx_ipv4->fc = fc;
+	rx_ipv6->fc = fc;
+	counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_rx_cnt;
+	}
+
+	fc->cnt = counter;
+	counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_rx_drop;
+	}
+
+	fc->drop = counter;
+	fc = kzalloc(sizeof(*tx->fc), GFP_KERNEL);
+	if (!fc) {
+		err = -ENOMEM;
+		goto err_tx_fc;
+	}
+
+	tx->fc = fc;
+	counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_tx_cnt;
+	}
+
+	fc->cnt = counter;
+	counter = mlx5_fc_create(mdev, false);
+	if (IS_ERR(counter)) {
+		err = PTR_ERR(counter);
+		goto err_tx_drop;
+	}
+
+	fc->drop = counter;
+	return 0;
+
+err_tx_drop:
+	mlx5_fc_destroy(mdev, tx->fc->cnt);
+err_tx_cnt:
+	kfree(tx->fc);
+err_tx_fc:
+	mlx5_fc_destroy(mdev, rx_ipv4->fc->drop);
+err_rx_drop:
+	mlx5_fc_destroy(mdev, rx_ipv4->fc->cnt);
+err_rx_cnt:
+	kfree(rx_ipv4->fc);
+	return err;
+}
+
+void mlx5e_accel_ipsec_fs_read_stats(struct mlx5e_priv *priv, void *ipsec_stats)
+{
+	struct mlx5_core_dev *mdev = priv->mdev;
+	struct mlx5e_ipsec *ipsec = priv->ipsec;
+	struct mlx5e_ipsec_hw_stats *stats;
+	struct mlx5e_ipsec_fc *fc;
+
+	stats = (struct mlx5e_ipsec_hw_stats *)ipsec_stats;
+
+	stats->ipsec_rx_pkts = 0;
+	stats->ipsec_rx_bytes = 0;
+	stats->ipsec_rx_drop_pkts = 0;
+	stats->ipsec_rx_drop_bytes = 0;
+	stats->ipsec_tx_pkts = 0;
+	stats->ipsec_tx_bytes = 0;
+	stats->ipsec_tx_drop_pkts = 0;
+	stats->ipsec_tx_drop_bytes = 0;
+
+	fc = ipsec->rx_ipv4->fc;
+	mlx5_fc_query(mdev, fc->cnt, &stats->ipsec_rx_pkts, &stats->ipsec_rx_bytes);
+	mlx5_fc_query(mdev, fc->drop, &stats->ipsec_rx_drop_pkts,
+		      &stats->ipsec_rx_drop_bytes);
+
+	fc = ipsec->tx->fc;
+	mlx5_fc_query(mdev, fc->cnt, &stats->ipsec_tx_pkts, &stats->ipsec_tx_bytes);
+	mlx5_fc_query(mdev, fc->drop, &stats->ipsec_tx_drop_pkts,
+		      &stats->ipsec_tx_drop_bytes);
+}
+
 int mlx5e_accel_ipsec_fs_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
@@ -848,6 +981,7 @@ void mlx5e_accel_ipsec_fs_cleanup(struct mlx5e_ipsec *ipsec)
 	if (!ipsec->tx)
 		return;
 
+	ipsec_fs_destroy_counters(ipsec);
 	mutex_destroy(&ipsec->tx->ft.mutex);
 	WARN_ON(ipsec->tx->ft.refcnt);
 	kfree(ipsec->tx);
@@ -883,6 +1017,10 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 	if (!ipsec->rx_ipv6)
 		goto err_rx_ipv6;
 
+	err = ipsec_fs_init_counters(ipsec);
+	if (err)
+		goto err_counters;
+
 	mutex_init(&ipsec->tx->ft.mutex);
 	mutex_init(&ipsec->rx_ipv4->ft.mutex);
 	mutex_init(&ipsec->rx_ipv6->ft.mutex);
@@ -890,6 +1028,8 @@ int mlx5e_accel_ipsec_fs_init(struct mlx5e_ipsec *ipsec)
 
 	return 0;
 
+err_counters:
+	kfree(ipsec->rx_ipv6);
 err_rx_ipv6:
 	kfree(ipsec->rx_ipv4);
 err_rx_ipv4:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
index 9de84821dafb..e0e36a09721c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_stats.c
@@ -37,6 +37,17 @@
 #include "en.h"
 #include "ipsec.h"
 
+static const struct counter_desc mlx5e_ipsec_hw_stats_desc[] = {
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_rx_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_rx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_rx_drop_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_rx_drop_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_tx_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_tx_bytes) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_tx_drop_pkts) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_hw_stats, ipsec_tx_drop_bytes) },
+};
+
 static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sp_alloc) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_ipsec_sw_stats, ipsec_rx_drop_sadb_miss) },
@@ -50,8 +61,48 @@ static const struct counter_desc mlx5e_ipsec_sw_stats_desc[] = {
 #define MLX5E_READ_CTR_ATOMIC64(ptr, dsc, i) \
 	atomic64_read((atomic64_t *)((char *)(ptr) + (dsc)[i].offset))
 
+#define NUM_IPSEC_HW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_hw_stats_desc)
 #define NUM_IPSEC_SW_COUNTERS ARRAY_SIZE(mlx5e_ipsec_sw_stats_desc)
 
+static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_hw)
+{
+	if (!priv->ipsec)
+		return 0;
+
+	return NUM_IPSEC_HW_COUNTERS;
+}
+
+static inline MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(ipsec_hw) {}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STRS(ipsec_hw)
+{
+	unsigned int i;
+
+	if (!priv->ipsec)
+		return idx;
+
+	for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       mlx5e_ipsec_hw_stats_desc[i].format);
+
+	return idx;
+}
+
+static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_hw)
+{
+	int i;
+
+	if (!priv->ipsec)
+		return idx;
+
+	mlx5e_accel_ipsec_fs_read_stats(priv, &priv->ipsec->hw_stats);
+	for (i = 0; i < NUM_IPSEC_HW_COUNTERS; i++)
+		data[idx++] = MLX5E_READ_CTR_ATOMIC64(&priv->ipsec->hw_stats,
+						      mlx5e_ipsec_hw_stats_desc, i);
+
+	return idx;
+}
+
 static MLX5E_DECLARE_STATS_GRP_OP_NUM_STATS(ipsec_sw)
 {
 	return priv->ipsec ? NUM_IPSEC_SW_COUNTERS : 0;
@@ -81,4 +132,5 @@ static MLX5E_DECLARE_STATS_GRP_OP_FILL_STATS(ipsec_sw)
 	return idx;
 }
 
+MLX5E_DEFINE_STATS_GRP(ipsec_hw, 0);
 MLX5E_DEFINE_STATS_GRP(ipsec_sw, 0);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 70c4ea3841d7..6687b8136e44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2480,6 +2480,7 @@ mlx5e_stats_grp_t mlx5e_nic_stats_grps[] = {
 	&MLX5E_STATS_GRP(per_prio),
 	&MLX5E_STATS_GRP(pme),
 #ifdef CONFIG_MLX5_EN_IPSEC
+	&MLX5E_STATS_GRP(ipsec_hw),
 	&MLX5E_STATS_GRP(ipsec_sw),
 #endif
 	&MLX5E_STATS_GRP(tls),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index cbc831ca646b..712cac10ba49 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -490,6 +490,7 @@ extern MLX5E_DECLARE_STATS_GRP(per_prio);
 extern MLX5E_DECLARE_STATS_GRP(pme);
 extern MLX5E_DECLARE_STATS_GRP(channels);
 extern MLX5E_DECLARE_STATS_GRP(per_port_buff_congest);
+extern MLX5E_DECLARE_STATS_GRP(ipsec_hw);
 extern MLX5E_DECLARE_STATS_GRP(ipsec_sw);
 extern MLX5E_DECLARE_STATS_GRP(ptp);
 extern MLX5E_DECLARE_STATS_GRP(macsec_hw);
-- 
2.38.1

