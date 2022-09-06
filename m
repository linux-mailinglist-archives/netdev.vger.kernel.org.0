Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E635ADEDF
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 07:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiIFFVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 01:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiIFFVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 01:21:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015316D544
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 22:21:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26AA8612D3
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 05:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B557C433C1;
        Tue,  6 Sep 2022 05:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662441703;
        bh=VlsfeIEfhvJDqzBimIumPwZCde87bS/OgZR9eX26ryw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdIAiLkIrn5+2M3iQAEn2xd9y3WMYTKMheMN1gW2BKBwr+YiCJRJvrksTGL5f3872
         JOfHHCNnbYI7RLNSQunrlsB/ZIkuxfJldj5nJPoEvw48Cg6Vda7hhiffffwNxGn0vP
         Zq6QRv5kQfbHo7LrcTJ3k8uQevZXpGlaYOZGwCzj8Ao5xvhZK9TOY+AtNA6dSxlXae
         ZKYDwqa+eG4a1+z8n0iNRN4aHB5XRCj9jRs8zazrMJqYIoWOIH7Kke7gS7Hhdk5iXV
         t/w54+TGXCxFaAEg7B3XJDtnCmM3yE0V14SevhpnTykpEwO93Tim9xsi6CnI944xwd
         Ymj0PacV3xuYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next V2 05/17] net/mlx5: Generalize Flow Context for new crypto fields
Date:   Mon,  5 Sep 2022 22:21:17 -0700
Message-Id: <20220906052129.104507-6-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220906052129.104507-1-saeed@kernel.org>
References: <20220906052129.104507-1-saeed@kernel.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

In order to support MACsec offload (and maybe some other crypto features
in the future), generalize flow action parameters / defines to be used by
crypto offlaods other than IPsec.
The following changes made:
ipsec_obj_id field at flow action context was changed to crypto_obj_id,
intreduced a new crypto_type field where IPsec is the default zero type
for backward compatibility.
Action ipsec_decrypt was changed to crypto_decrypt.
Action ipsec_encrypt was changed to crypto_encrypt.

IPsec offload code was updated accordingly for backward compatibility.

Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c  |  7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c     |  5 ++++-
 include/linux/mlx5/fs.h                              |  7 ++++---
 include/linux/mlx5/mlx5_ifc.h                        | 12 ++++++++----
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index e776b9f2da06..976f5669b6e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -388,7 +388,8 @@ static void setup_fte_common(struct mlx5_accel_esp_xfrm_attrs *attrs,
 		       0xff, 16);
 	}
 
-	flow_act->ipsec_obj_id = ipsec_obj_id;
+	flow_act->crypto.type = MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC;
+	flow_act->crypto.obj_id = ipsec_obj_id;
 	flow_act->flags |= FLOW_ACT_NO_APPEND;
 }
 
@@ -444,7 +445,7 @@ static int rx_add_rule(struct mlx5e_priv *priv,
 	}
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
-			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT |
+			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT |
 			  MLX5_FLOW_CONTEXT_ACTION_MOD_HDR;
 	dest.type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	flow_act.modify_hdr = modify_hdr;
@@ -500,7 +501,7 @@ static int tx_add_rule(struct mlx5e_priv *priv,
 		 MLX5_ETH_WQE_FT_META_IPSEC);
 
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW |
-			  MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT;
+			  MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT;
 	rule = mlx5_add_flow_rules(priv->ipsec->tx_fs->ft, spec, &flow_act, NULL, 0);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
index e735e19461ba..ff5d23f0e4b1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -577,7 +577,10 @@ static int mlx5_cmd_set_fte(struct mlx5_core_dev *dev,
 		MLX5_SET(flow_context, in_flow_context, modify_header_id,
 			 fte->action.modify_hdr->id);
 
-	MLX5_SET(flow_context, in_flow_context, ipsec_obj_id, fte->action.ipsec_obj_id);
+	MLX5_SET(flow_context, in_flow_context, encrypt_decrypt_type,
+		 fte->action.crypto.type);
+	MLX5_SET(flow_context, in_flow_context, encrypt_decrypt_obj_id,
+		 fte->action.crypto.obj_id);
 
 	vlan = MLX5_ADDR_OF(flow_context, in_flow_context, push_vlan);
 
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index 920cbc9524ad..e62d50acb6bd 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -243,9 +243,10 @@ struct mlx5_flow_act {
 	u32 action;
 	struct mlx5_modify_hdr  *modify_hdr;
 	struct mlx5_pkt_reformat *pkt_reformat;
-	union {
-		u32 ipsec_obj_id;
-	};
+	struct mlx5_flow_act_crypto_params {
+		u8 type;
+		u32 obj_id;
+	} crypto;
 	u32 flags;
 	struct mlx5_fs_vlan vlan[MLX5_FS_VLAN_DEPTH];
 	struct ib_counters *counters;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..5758218cb3fa 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3310,8 +3310,8 @@ enum {
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH = 0x100,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_POP_2  = 0x400,
 	MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 = 0x800,
-	MLX5_FLOW_CONTEXT_ACTION_IPSEC_DECRYPT = 0x1000,
-	MLX5_FLOW_CONTEXT_ACTION_IPSEC_ENCRYPT = 0x2000,
+	MLX5_FLOW_CONTEXT_ACTION_CRYPTO_DECRYPT = 0x1000,
+	MLX5_FLOW_CONTEXT_ACTION_CRYPTO_ENCRYPT = 0x2000,
 	MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO = 0x4000,
 };
 
@@ -3321,6 +3321,10 @@ enum {
 	MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT       = 0x2,
 };
 
+enum {
+	MLX5_FLOW_CONTEXT_ENCRYPT_DECRYPT_TYPE_IPSEC   = 0x0,
+};
+
 struct mlx5_ifc_vlan_bits {
 	u8         ethtype[0x10];
 	u8         prio[0x3];
@@ -3374,7 +3378,7 @@ struct mlx5_ifc_flow_context_bits {
 	u8         extended_destination[0x1];
 	u8         reserved_at_81[0x1];
 	u8         flow_source[0x2];
-	u8         reserved_at_84[0x4];
+	u8         encrypt_decrypt_type[0x4];
 	u8         destination_list_size[0x18];
 
 	u8         reserved_at_a0[0x8];
@@ -3386,7 +3390,7 @@ struct mlx5_ifc_flow_context_bits {
 
 	struct mlx5_ifc_vlan_bits push_vlan_2;
 
-	u8         ipsec_obj_id[0x20];
+	u8         encrypt_decrypt_obj_id[0x20];
 	u8         reserved_at_140[0xc0];
 
 	struct mlx5_ifc_fte_match_param_bits match_value;
-- 
2.37.2

