Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFE66DC380
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjDJGUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjDJGT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F4744A4
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C1B2617BF
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FF0C433B0;
        Mon, 10 Apr 2023 06:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107590;
        bh=qVKUUNtbYtW/8TfnZ5igKymOsjQcTKsQkrv5KunTVeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s01GQ+xgksIJ6UXPWq8phZo/D4iR6gU/J2PpC02LFyq4NfIjMAMK97ytFJiXFx7u5
         sGqE5n0K6xKEExGahqZrpDItdhO4Zusl/1Z3T8lrNHg5PhNtmSI+MCFYvkoUnkiBDj
         u+sW8kZOnSQIsfSypFiACQpze+py1zTMjOqQDqzQSkSLMI8fQaNo2KOSb7g7HZAXg7
         xV1j/AzF0wWNiEmudhbaG76ov1BOtkgisgX/k2Vj2m4VI+eWJrDZO4Ndey0pYwaQQQ
         SoB3rSphXeWN4IKQ8kYLst761DlMFIE+wubNAogyRsMsmEdGo7TOm4isV0ZTB1CaoA
         p0Kh3rbjTOaNA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 09/10] net/mlx5e: Create IPsec table with tunnel support only when encap is disabled
Date:   Mon, 10 Apr 2023 09:19:11 +0300
Message-Id: <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
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
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index b64281fd4142..e95004ac7a20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -668,6 +668,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
 	if (err)
 		goto err_hw_ctx;
 
+	if (x->props.mode == XFRM_MODE_TUNNEL &&
+	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
+	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
+		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
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
index b1f759c378d9..6a8f1c0f4912 100644
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
@@ -37,6 +38,7 @@ struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_rule status;
 	struct mlx5e_ipsec_fc *fc;
 	struct mlx5_fs_chains *chains;
+	u8 allow_tunnel_mode : 1;
 };
 
 struct mlx5e_ipsec_tx {
@@ -46,6 +48,7 @@ struct mlx5e_ipsec_tx {
 	struct mlx5_flow_namespace *ns;
 	struct mlx5e_ipsec_fc *fc;
 	struct mlx5_fs_chains *chains;
+	u8 allow_tunnel_mode : 1;
 };
 
 /* IPsec RX flow steering */
@@ -253,7 +256,8 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 	mlx5_del_flow_rules(rx->sa.rule);
 	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
-
+	if (rx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 	mlx5_destroy_flow_table(rx->ft.status);
@@ -304,6 +308,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	/* Create FT */
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		rx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+	if (rx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(ns, MLX5E_ACCEL_FS_ESP_FT_LEVEL, MLX5E_NIC_PRIO, 2,
 			     flags);
@@ -361,6 +367,8 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs:
 	mlx5_destroy_flow_table(rx->ft.sa);
 err_fs_ft:
+	if (rx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(rx->status.rule);
 	mlx5_modify_header_dealloc(mdev, rx->status.modify_hdr);
 err_add:
@@ -495,7 +503,8 @@ static int ipsec_counter_rule_tx(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_
 }
 
 /* IPsec TX flow steering */
-static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
+static void tx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
+		       struct mlx5_ipsec_fs *roce)
 {
 	mlx5_ipsec_fs_roce_tx_destroy(roce);
 	if (tx->chains) {
@@ -507,6 +516,8 @@ static void tx_destroy(struct mlx5e_ipsec_tx *tx, struct mlx5_ipsec_fs *roce)
 	}
 
 	mlx5_destroy_flow_table(tx->ft.sa);
+	if (tx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(tx->status.rule);
 	mlx5_destroy_flow_table(tx->ft.status);
 }
@@ -529,6 +540,8 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 		goto err_status_rule;
 
 	if (mlx5_ipsec_device_caps(mdev) & MLX5_IPSEC_CAP_TUNNEL)
+		tx->allow_tunnel_mode = mlx5_eswitch_block_encap(mdev);
+	if (tx->allow_tunnel_mode)
 		flags = MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT;
 	ft = ipsec_ft_create(tx->ns, 1, 0, 4, flags);
 	if (IS_ERR(ft)) {
@@ -580,6 +593,8 @@ static int tx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_tx *tx,
 err_pol_ft:
 	mlx5_destroy_flow_table(tx->ft.sa);
 err_sa_ft:
+	if (tx->allow_tunnel_mode)
+		mlx5_eswitch_unblock_encap(mdev);
 	mlx5_del_flow_rules(tx->status.rule);
 err_status_rule:
 	mlx5_destroy_flow_table(tx->ft.status);
@@ -608,7 +623,7 @@ static void tx_put(struct mlx5e_ipsec *ipsec, struct mlx5e_ipsec_tx *tx)
 	if (--tx->ft.refcnt)
 		return;
 
-	tx_destroy(tx, ipsec->roce);
+	tx_destroy(ipsec->mdev, tx, ipsec->roce);
 }
 
 static struct mlx5_flow_table *tx_ft_get_policy(struct mlx5_core_dev *mdev,
@@ -1607,3 +1622,15 @@ void mlx5e_accel_ipsec_fs_modify(struct mlx5e_ipsec_sa_entry *sa_entry)
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

