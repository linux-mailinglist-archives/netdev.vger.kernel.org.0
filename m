Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03EF6E0D6F
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjDMM3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDMM3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6F1869A
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C942663DD4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D6AC433EF;
        Thu, 13 Apr 2023 12:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681388982;
        bh=TvDKIMPfBH15v59jOZClDeUNeGkdqswWR16MwRu78E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oZk0nzgfJ7bYHI8yJztiO0DQ5nTAW7p5/KGBlsxOWL5f3c/jOjri6cUGFnWdT4dJh
         pMLGJQZIuRh7PQV9B3+m86KkTyGBVMbiPU7QPZOy+fAxTlE1WR3WTvtLrdTU041lrj
         oC8iUSi8OaBDT8qpp8W9yObCbaTDM8LP1hQXqMDtqKAstDaWWt7rXO/mkJA+q8Crin
         KCO0+GQJ1gy6BVUtLQuKClNvQFwJs9LZojBto2C6Y/weqkQwQBqv6d/V6PKPFsND01
         QLlmS/7hwGysoY0PG65+Do2bizC/99QoEAx6Z+kpQZEZ1w5t1Jch84ggpPSEAQeb9d
         tY1oekmQcst4w==
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
Subject: [PATCH net-next v1 01/10] net/mlx5e: Add IPsec packet offload tunnel bits
Date:   Thu, 13 Apr 2023 15:29:19 +0300
Message-Id: <0584b0ca47684aff235a9a4d82c06e2f2595d94a.1681388425.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681388425.git.leonro@nvidia.com>
References: <cover.1681388425.git.leonro@nvidia.com>
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

Extend packet reformat types and flow table capabilities with
IPsec packet offload tunnel bits.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e47d6c58da35..3e899844e84c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -456,9 +456,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_ft_level[0x8];
 
 	u8         reformat_add_esp_trasport[0x1];
-	u8         reserved_at_41[0x2];
+	u8         reformat_l2_to_l3_esp_tunnel[0x1];
+	u8         reserved_at_42[0x1];
 	u8         reformat_del_esp_trasport[0x1];
-	u8         reserved_at_44[0x2];
+	u8         reformat_l3_esp_tunnel_to_l2[0x1];
+	u8         reserved_at_45[0x1];
 	u8         execute_aso[0x1];
 	u8         reserved_at_47[0x19];
 
@@ -6599,7 +6601,9 @@ enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
 	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 = 0x5,
+	MLX5_REFORMAT_TYPE_L2_TO_L3_ESP_TUNNEL = 0x6,
 	MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT = 0x8,
+	MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2 = 0x9,
 	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6 = 0xb,
 	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
 	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
-- 
2.39.2

