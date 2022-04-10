Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A194FACE0
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiDJIc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbiDJIb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:31:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3185A09B;
        Sun, 10 Apr 2022 01:29:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A594460A77;
        Sun, 10 Apr 2022 08:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAD8C385AA;
        Sun, 10 Apr 2022 08:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579380;
        bh=P0LPrpRFiSWkYa75MX6pPK6ScNLx3HOJkeZ8HbW1Zz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O06cm5e5KLgTuULJnlCrU8vACgO8a9rXdJYuJXjs1lMaKJ5Fe4IMN70QEGPVQpgV1
         5IZml9xdImGteGnoWckCIOdJ20/TJ/NDvLeRP9Xm/LmOO0tZcH4kMIyQxEtnhMWit5
         bxaCfkew4JmqzZ+qVh6CoXAnnPG5T4or62LCiZmsCX986jbgZ8A7VifAbgpsB3X3Oy
         vSOQVu1r1eSnw2IyIGKFLTxuuc8ucMEemzSklNFLnnNIEzU6sUptGOuEd/bQAJS9jO
         1XOYVlDAlPim58pddkA9GYWdKdhOQT+VAeovMP7R99F3YAiTemXluV946DpaDV7zMT
         P16F5UjyjJ8tA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 15/17] net/mlx5: Cleanup XFRM attributes struct
Date:   Sun, 10 Apr 2022 11:28:33 +0300
Message-Id: <54957129978046acbf5858508d6dcba59196f9ea.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Remove everything that is not used or from mlx5_accel_esp_xfrm_attrs,
together with change type of spi to store proper type from the beginning.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 ++-------
 .../mellanox/mlx5/core/en_accel/ipsec.h       | 21 ++-----------------
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    |  4 ++--
 .../mlx5/core/en_accel/ipsec_offload.c        |  4 ++--
 4 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index e138a4d1a9c0..4476397d3d22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -137,7 +137,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				   struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
 	struct xfrm_state *x = sa_entry->x;
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	struct aead_geniv_ctx *geniv_ctx;
 	struct crypto_aead *aead;
 	unsigned int crypto_data_len, key_len;
@@ -171,12 +171,6 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			attrs->flags |= MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP;
 	}
 
-	/* rx handle */
-	attrs->sa_handle = sa_entry->handle;
-
-	/* algo type */
-	attrs->keymat_type = MLX5_ACCEL_ESP_KEYMAT_AES_GCM;
-
 	/* action */
 	attrs->action = (!(x->xso.flags & XFRM_OFFLOAD_INBOUND)) ?
 			MLX5_ACCEL_ESP_ACTION_ENCRYPT :
@@ -187,7 +181,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 			MLX5_ACCEL_ESP_FLAGS_TUNNEL;
 
 	/* spi */
-	attrs->spi = x->id.spi;
+	attrs->spi = be32_to_cpu(x->id.spi);
 
 	/* source , destination ips */
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 998a812fbd15..1e31acc04a44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -55,11 +55,6 @@ enum mlx5_accel_esp_action {
 	MLX5_ACCEL_ESP_ACTION_ENCRYPT,
 };
 
-enum mlx5_accel_esp_keymats {
-	MLX5_ACCEL_ESP_KEYMAT_AES_NONE,
-	MLX5_ACCEL_ESP_KEYMAT_AES_GCM,
-};
-
 struct aes_gcm_keymat {
 	u64   seq_iv;
 
@@ -73,21 +68,9 @@ struct aes_gcm_keymat {
 struct mlx5_accel_esp_xfrm_attrs {
 	enum mlx5_accel_esp_action action;
 	u32   esn;
-	__be32 spi;
-	u32   seq;
-	u32   tfc_pad;
+	u32   spi;
 	u32   flags;
-	u32   sa_handle;
-	union {
-		struct {
-			u32 size;
-
-		} bmp;
-	} replay;
-	enum mlx5_accel_esp_keymats keymat_type;
-	union {
-		struct aes_gcm_keymat aes_gcm;
-	} keymat;
+	struct aes_gcm_keymat aes_gcm;
 
 	union {
 		__be32 a4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 2975788292ec..b6a389ca8ce3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -356,8 +356,8 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 
 	/* SPI number */
 	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria, misc_parameters.outer_esp_spi);
-	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.outer_esp_spi,
-		 be32_to_cpu(attrs->spi));
+	MLX5_SET(fte_match_param, spec->match_value,
+		 misc_parameters.outer_esp_spi, attrs->spi);
 
 	if (ip_version == 4) {
 		memcpy(MLX5_ADDR_OF(fte_match_param, spec->match_value,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 4f3ffe5a09fa..2f32d53761b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -51,7 +51,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
-	struct aes_gcm_keymat *aes_gcm = &attrs->keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
@@ -107,7 +107,7 @@ static void mlx5_destroy_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 
 int mlx5_ipsec_create_sa_ctx(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
-	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.keymat.aes_gcm;
+	struct aes_gcm_keymat *aes_gcm = &sa_entry->attrs.aes_gcm;
 	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	int err;
 
-- 
2.35.1

