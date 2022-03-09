Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F764D3AE2
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238061AbiCIUQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiCIUQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:16:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA45A76CF
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:15:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F77CB81FE1
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B918DC340F6;
        Wed,  9 Mar 2022 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646856927;
        bh=B8gXPz5FRlreJlgBWtBMuR1ZsAfKLg0Allw/e1+DrrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEP+HIW1+xfveIe1u6gBwnkFX4BEHOBg+C7jFyBjHOA8hdBkhtxMMGxpg8t3tlzDi
         oqPHWc99HtwIwoQTLG0KmViSnpvkuavrc0p/5Q5pnWNlnbrTPnxNv9Ev5Hd7c3MxJk
         FXywnsp/5N6/Kad2j7vmVnw4YvGvlUHppHI/zGWXgZLK0uF+sPbf0yTBcs6Z790ZIp
         YdzxOPL1jK58zTeiQ81HpseIJSNtsoHE+5MAqoOsArQMzGi8b9wDOZBjcoRKzwlay3
         ZX/4ZuoXDQoqaJTq10iO8OQKISyAyd7cMQAIl1bawUz3TGAyiIeKiOv8yf4EFeTE8g
         zSrn20hukhPjg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/5] net/mlx5e: SHAMPO, reduce TIR indication
Date:   Wed,  9 Mar 2022 12:15:17 -0800
Message-Id: <20220309201517.589132-6-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309201517.589132-1-saeed@kernel.org>
References: <20220309201517.589132-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-Ishay <benishay@nvidia.com>

SHAMPO is an RQ / WQ feature, an indication was added to the TIR in the
first place to enforce suitability between connected TIR and RQ, this
enforcement does not exist in current the Firmware implementation and was
redundant in the first place.

Fixes: 83439f3c37aa ("net/mlx5e: Add HW-GRO offload")
Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c  | 3 ---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +--
 include/linux/mlx5/mlx5_ifc.h                     | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
index da169b816665..d4239e3b3c88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tir.c
@@ -88,9 +88,6 @@ void mlx5e_tir_builder_build_packet_merge(struct mlx5e_tir_builder *builder,
 			 (MLX5E_PARAMS_DEFAULT_LRO_WQE_SZ - rough_max_l2_l3_hdr_sz) >> 8);
 		MLX5_SET(tirc, tirc, lro_timeout_period_usecs, pkt_merge_param->timeout);
 		break;
-	case MLX5E_PACKET_MERGE_SHAMPO:
-		MLX5_SET(tirc, tirc, packet_merge_mask, MLX5_TIRC_PACKET_MERGE_MASK_SHAMPO);
-		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bf80fb612449..3667f5ef5990 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3616,8 +3616,7 @@ static int set_feature_hw_gro(struct net_device *netdev, bool enable)
 		goto out;
 	}
 
-	err = mlx5e_safe_switch_params(priv, &new_params,
-				       mlx5e_modify_tirs_packet_merge_ctx, NULL, reset);
+	err = mlx5e_safe_switch_params(priv, &new_params, NULL, NULL, reset);
 out:
 	mutex_unlock(&priv->state_lock);
 	return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 5743f5b3414b..49a48d7709ac 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3434,7 +3434,6 @@ enum {
 enum {
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV4_LRO  = BIT(0),
 	MLX5_TIRC_PACKET_MERGE_MASK_IPV6_LRO  = BIT(1),
-	MLX5_TIRC_PACKET_MERGE_MASK_SHAMPO    = BIT(2),
 };
 
 enum {
-- 
2.35.1

