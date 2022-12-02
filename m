Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F11E640EF2
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiLBUMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiLBULl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F3BF1426
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C57C7622CB
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC953C433D6;
        Fri,  2 Dec 2022 20:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011898;
        bh=O7vsvAOyCGRPlXB6A6nGeUCHGA1+K3UDQX1qblRMGC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rzr3KTa734y05C6GDCdpi0hRlebpE42UXY3gIxdkNUwq6T1bNiuKwqBBU0jIGxSP/
         WTuMWfWj25vsvwqnVNu6rWSZzcCDcb7y96Rw26JbG9gfrMsOfvqUtz2/G7KMvQzQcH
         6EDJG7//xPi+otT2V0tPCH4th8+ZjSKsUfzg/QQOwcrFVqrfd8cmS4KcMXCEoK3FM7
         XS0+iB6qQ/UPeCj4si7D7lURqpCsQ0Fl2Mvrw/1QjTFe90YnRJseUMeXyZHtflCyDL
         Q5dcMRC021er7RzNg0VXibg9ksn7hGpMrxGj734v94zfWnlHsFOMapNE2k3cPeFJQk
         bTuiw/4ys+5Dw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next 10/16] net/mlx5e: Create hardware IPsec packet offload objects
Date:   Fri,  2 Dec 2022 22:10:31 +0200
Message-Id: <a4dabd6a36a87d34519996f840a4240b038b52e9.1670011671.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670011671.git.leonro@nvidia.com>
References: <cover.1670011671.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Create initial hardware IPsec packet offload object and connect it
to advanced steering operation (ASO) context and queue, so the data
path can communicate with the stack.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  3 +-
 .../mlx5/core/en_accel/ipsec_offload.c        | 37 +++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index d2c814e7af97..c5bccc0df60d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -176,6 +176,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
 	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
 	attrs->family = x->props.family;
+	attrs->type = x->xso.type;
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 8e2f88f269ac..2c9aedf6b0ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -73,6 +73,7 @@ struct mlx5_accel_esp_xfrm_attrs {
 	u8 dir : 2;
 	u8 esn_overlap : 1;
 	u8 esn_trigger : 1;
+	u8 type : 2;
 	u8 family;
 	u32 replay_window;
 };
@@ -102,8 +103,6 @@ struct mlx5e_ipsec_aso {
 	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
-	u32 pdn;
-	u32 mkey;
 };
 
 struct mlx5e_ipsec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 7fef5de55229..fc88454aaf8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -53,6 +53,38 @@ u32 mlx5_ipsec_device_caps(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_ipsec_device_caps);
 
+static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
+				     struct mlx5_accel_esp_xfrm_attrs *attrs)
+{
+	void *aso_ctx;
+
+	aso_ctx = MLX5_ADDR_OF(ipsec_obj, obj, ipsec_aso);
+	if (attrs->esn_trigger) {
+		MLX5_SET(ipsec_aso, aso_ctx, esn_event_arm, 1);
+
+		if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
+			MLX5_SET(ipsec_aso, aso_ctx, window_sz,
+				 attrs->replay_window / 64);
+			MLX5_SET(ipsec_aso, aso_ctx, mode,
+				 MLX5_IPSEC_ASO_REPLAY_PROTECTION);
+			}
+	}
+
+	/* ASO context */
+	MLX5_SET(ipsec_obj, obj, ipsec_aso_access_pd, pdn);
+	MLX5_SET(ipsec_obj, obj, full_offload, 1);
+	MLX5_SET(ipsec_aso, aso_ctx, valid, 1);
+	/* MLX5_IPSEC_ASO_REG_C_4_5 is type C register that is used
+	 * in flow steering to perform matching against. Please be
+	 * aware that this register was chosen arbitrary and can't
+	 * be used in other places as long as IPsec packet offload
+	 * active.
+	 */
+	MLX5_SET(ipsec_obj, obj, aso_return_reg, MLX5_IPSEC_ASO_REG_C_4_5);
+	if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
+		MLX5_SET(ipsec_aso, aso_ctx, mode, MLX5_IPSEC_ASO_INC_SN);
+}
+
 static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 {
 	struct mlx5_accel_esp_xfrm_attrs *attrs = &sa_entry->attrs;
@@ -61,6 +93,7 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
 	void *obj, *salt_p, *salt_iv_p;
+	struct mlx5e_hw_objs *res;
 	int err;
 
 	obj = MLX5_ADDR_OF(create_ipsec_obj_in, in, ipsec_object);
@@ -87,6 +120,10 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
 
+	res = &mdev->mlx5e_res.hw_objs;
+	if (attrs->type == XFRM_DEV_OFFLOAD_PACKET)
+		mlx5e_ipsec_packet_setup(obj, res->pdn, attrs);
+
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
 		sa_entry->ipsec_obj_id =
-- 
2.38.1

