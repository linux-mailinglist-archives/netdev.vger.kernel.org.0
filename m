Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF69F5959FF
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 13:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiHPLZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 07:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiHPLZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 07:25:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C637E42F5
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 03:39:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41DB0B8169C
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 10:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70EAC433D6;
        Tue, 16 Aug 2022 10:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660646365;
        bh=tkNrqIdN9140UAR6xOufak3DaGJowm84cdYY27o54Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+0t46YcLo0OeST53QaaVnZNTHFOhel5ZgBshwiS/HfU0Pck8ezrqp36TMwinSznd
         rBIPF6bgOQq0g3oZfvoRwNWIcJxSmtIIG6NAHStIfOtnurg3+mKgOdeBNPdiDmW3sk
         gPIswu8t3y5XH45ey7+im4zgiIYCgOx1iVx7TWev+OU5WFaLx05dUTkDzYv8Oj4g60
         HB92gBKOoORjj/1AV8MmuHAeCl5xaqhpf7IYWFd1rWUKBNppdq/RLV2Z0TI7VgFx/X
         qwph1KVRHbmJCMzojmeocE6gL5GNcZyYrzIaiECcy4d8KPnXoh3foEyZ08pAxZM6Px
         adnCsK88ppiyg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH xfrm-next 12/26] net/mlx5e: Create hardware IPsec full offload objects
Date:   Tue, 16 Aug 2022 13:38:00 +0300
Message-Id: <67bac0f27f98d86934853a95f96901a26c68a935.1660641154.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1660641154.git.leonro@nvidia.com>
References: <cover.1660641154.git.leonro@nvidia.com>
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

Create initial hardware IPsec full offload object and connect it
to advanced steering operation (ASO) context and queue, so the data
path can communicate with the stack.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  1 +
 .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
 .../mlx5/core/en_accel/ipsec_offload.c        | 31 ++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index f65305281ac4..9e936e9cc673 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -179,6 +179,7 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 	memcpy(&attrs->saddr, x->props.saddr.a6, sizeof(attrs->saddr));
 	memcpy(&attrs->daddr, x->id.daddr.a6, sizeof(attrs->daddr));
 	attrs->family = x->props.family;
+	attrs->type = x->xso.type;
 }
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 2be7fb7db456..9acb3e98c823 100644
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 7ebdfe560398..4fc472722859 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -63,10 +63,12 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	struct aes_gcm_keymat *aes_gcm = &attrs->aes_gcm;
 	u32 out[MLX5_ST_SZ_DW(general_obj_out_cmd_hdr)];
 	u32 in[MLX5_ST_SZ_DW(create_ipsec_obj_in)] = {};
-	void *obj, *salt_p, *salt_iv_p;
+	void *obj, *salt_p, *salt_iv_p, *aso_ctx;
+	u32 pdn = sa_entry->ipsec->pdn;
 	int err;
 
 	obj = MLX5_ADDR_OF(create_ipsec_obj_in, in, ipsec_object);
+	aso_ctx = MLX5_ADDR_OF(ipsec_obj, obj, ipsec_aso);
 
 	/* salt and seq_iv */
 	salt_p = MLX5_ADDR_OF(ipsec_obj, obj, salt);
@@ -80,6 +82,17 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 		MLX5_SET(ipsec_obj, obj, esn_en, 1);
 		MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
 		MLX5_SET(ipsec_obj, obj, esn_overlap, attrs->esn_overlap);
+
+		if (attrs->type == XFRM_DEV_OFFLOAD_FULL) {
+			MLX5_SET(ipsec_aso, aso_ctx, esn_event_arm, 1);
+
+			if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
+				MLX5_SET(ipsec_aso, aso_ctx, window_sz,
+					 attrs->replay_window / 64);
+				MLX5_SET(ipsec_aso, aso_ctx, mode,
+					 MLX5_IPSEC_ASO_REPLAY_PROTECTION);
+			}
+		}
 	}
 
 	MLX5_SET(ipsec_obj, obj, dekn, sa_entry->enc_key_id);
@@ -90,6 +103,22 @@ static int mlx5_create_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry)
 	MLX5_SET(general_obj_in_cmd_hdr, in, obj_type,
 		 MLX5_GENERAL_OBJECT_TYPES_IPSEC);
 
+	/* ASO context */
+	if (attrs->type == XFRM_DEV_OFFLOAD_FULL) {
+		MLX5_SET(ipsec_obj, obj, ipsec_aso_access_pd, pdn);
+		MLX5_SET(ipsec_obj, obj, full_offload, 1);
+		MLX5_SET(ipsec_aso, aso_ctx, valid, 1);
+		/* MLX5_IPSEC_ASO_REG_C_4_5 is type C register that is used
+		 * in flow steering to perform matching against. Please be
+		 * aware that this register was chosen arbitrary and can't
+		 * be used in other places as long as IPsec full offload
+		 * active.
+		 */
+		MLX5_SET(ipsec_obj, obj, aso_return_reg, MLX5_IPSEC_ASO_REG_C_4_5);
+		if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
+			MLX5_SET(ipsec_aso, aso_ctx, mode, MLX5_IPSEC_ASO_INC_SN);
+	}
+
 	err = mlx5_cmd_exec(mdev, in, sizeof(in), out, sizeof(out));
 	if (!err)
 		sa_entry->ipsec_obj_id =
-- 
2.37.2

