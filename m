Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A686E0D7B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjDMMah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbjDMMae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3615AAD0F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AED463E09
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AEFC433EF;
        Thu, 13 Apr 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681389019;
        bh=ZWpAK1tMaQfomcNTmCa8S88VyalaBfnG0DdFL+F/7Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWJM/4Zal68KTcP/7KOLR1bfWJVy7vwORSD6miL5AyWLMNWDObp1xylhk5IEEE/1w
         3iVvevhLsRxZJWSj0TIwOAyNZKqYunrlseACnQM2UrKlgzxWTjJ5WIsA4B2AghUDcG
         VyEtRCiPphCQQ3VeZWFcYbQ6r9rA3NahUKvcGDRDNoN+9AbkJUi9rDcqz9ZJ1MwxWJ
         zVgc6JpmbRMoow5owcKryEr4KlUSacdJWd2hF9IoRMBUIQPoV6OT4DuGrQeBlFMkbx
         0ZLrd+Ud6nM0tcSSTC3229YACqGORzEBSA2OkfoPW/z+50gRLRKkTitYlTaV+nvtnj
         wnE7YYj8UvmEg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v1 09/10] net/mlx5e: Create IPsec table with tunnel support only when encap is disabled
Date:   Thu, 13 Apr 2023 15:29:27 +0300
Message-Id: <95b253445bedd2167a6c156d242fd47f37de6ad1.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Current hardware doesn't support double encapsulation which is
happening when IPsec packet offload tunnel mode is configured
together with eswitch encap option.

Any user attempt to add new SA/policy after he/she sets encap mode, will
generate the following FW syndrome:

 mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
 status bad parameter(0x3), syndrome (0xa43321), err(-22)

Make sure that we block encap changes before creating flow steering tables.
This is applicable only for packet offload in tunnel mode, while packet
offload in transport mode and crypto offload, don't have such limitation
as they don't perform encapsulation.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  8 +++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
 3 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b64281fd4142..0bda5a91bff6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -668,6 +668,14 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (err)
 		goto err_hw_ctx;
 
+	if (x->props.mode == XFRM_MODE_TUNNEL &&
+	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
+	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
+		err = -EINVAL;
+		goto err_add_rule;
+	}
+
 	/* We use *_bh() variant because xfrm_timer_handler(), which runs
 	 * in softirq context, can reach our state delete logic and we need
 	 * xa_erase_bh() there.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index d06c896eadb6..f7f7c09d2b32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -251,6 +251,7 @@ void mlx5e_accel_ipsec_fs_del_rule(struct mlx5e_ipsec_sa_entry *sa_entry);
 int mlx5e_accel_ipsec_fs_add_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_del_pol(struct mlx5e_ipsec_pol_entry *pol_entry);
 void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry);
+bool mlx5e_ipsec_fs_tunnel_enabled(struct mlx5e_ipsec_sa_entry *sa_entry);
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
 void mlx5_ipsec_free_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 4c800b54d8b6..5a8fcd30fcb1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include "en.h"
 #include "en/fs.h"
+#include "eswitch.h"
 #include "ipsec.h"
 #include "fs_core.h"
 #include "lib/ipsec_fs_roce.h"
@@ -38,6 +39,7 @@ struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_rule status;
 	struct mlx5e_ipsec_fc *fc;
 	struct mlx5_fs_chains *chains;
+	u8 allow_tunnel_mode : 1;
 };
 
 struct mlx5e_ipsec_tx {
@@ -47,6 +49,7 @@ struct mlx5e_ipsec_tx {
 	struct mlx5_flow_namespace *ns;
 	struct mlx5e_ipsec_fc *fc;
 	struct mlx5_fs_chains *chains;
+	u8 allow_tunnel_mode : 1;
 };
 
 /* IPsec RX flow steering */
@@ -254,7 +257,8 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_del_flow_rules(rx->sa.rule);
 	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
-
+	if (rx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 	mlx5_destroy_flow_table(rx->ft.status);
@@ -305,6 +309,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	/* Create FT */
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		rx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+	if (rx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO, 2,
 			     flags);
@@ -362,6 +368,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs:
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
+	if (rx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 err_add:
@@ -496,7 +504,8 @@ static int ipsec_counter_rule_tx(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_
 }
 
 /* IPsec TX flow steering */
-static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
+static void tx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
+		       struct mlx5_ipsec_fs *roce)
 {
 	mlx5_ipsec_fs_roce_tx_destroy(roce);
 	if (tx->chains) {
@@ -508,6 +517,8 @@ static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
 	}
 
 	mlx5_destroy_flow_table(tx->ft.sa);
+	if (tx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(tx->status.rule);
 	mlx5_destroy_flow_table(tx->ft.status);
 }
@@ -530,6 +541,8 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 		goto err_status_rule;
 
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		tx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+	if (tx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(tx->ns, 1, 0, 4, flags);
 	if (IS_ERR(ft)) {
@@ -581,6 +594,8 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 err_pol_ft:
 	mlx5_destroy_flow_table(tx->ft.sa);
 err_sa_ft:
+	if (tx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(tx->status.rule);
 err_status_rule:
 	mlx5_destroy_flow_table(tx->ft.status);
@@ -609,7 +624,7 @@ static void tx_put(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx)
 	if (--tx->ft.refcnt)
 		return;
 
-	tx_destroy(tx, ipsec->roce);
+	tx_destroy(ipsec->mdev, tx, ipsec->roce);
 }
 
 static struct mlx5_flow_table *tx_ft_get_policy(struct mlx5_core_dev *mdev,
@@ -1603,3 +1618,15 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
 	mlx5e_accel_ipsec_fs_del_rule(sa_entry);
 	memcpy(sa_entry, &sa_entry_shadow, sizeof(*sa_entry));
 }
+
+bool mlx5e_ipsec_fs_tunnel_enabled(struct mlx5e_ipsec_sa_entry *sa_entry)
+{
+	struct mlx5e_ipsec_rx *rx =
+		ipsec_rx(sa_entry->ipsec, sa_entry->attrs.family);
+	struct mlx5e_ipsec_tx *tx = sa_entry->ipsec->tx;
+
+	if (sa_entry->attrs.dir == XFRM_DEV_OFFLOAD_OUT)
+		return tx->allow_tunnel_mode;
+
+	return rx->allow_tunnel_mode;
+}
-- 
2.39.2

