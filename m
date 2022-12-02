Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA24640EF3
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiLBUMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiLBULp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:11:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A01AF1CF3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:11:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C02C5B8228B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 20:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A08C433D7;
        Fri,  2 Dec 2022 20:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670011902;
        bh=QtFY35m9618kJ0o7FCPTdiwPdiqY8lS3UIQf30dKX8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBSNuDZwZHZiOJfqV3EuFDwwSg7crlfOwxJUoMCe32NLgCAdBR/+WJLSgN0BZEUlF
         BHRZ4HDUJD58EqfvyPcznzqGu49uiWqqklg0SYwUfbfwuEkgE4ubxK0RWR0OZj6Hq1
         /LzYfOwr4Z3kVscS7SWRBOBA4JSa2kJ2EVYCzE6SGRQpjCGSY7u4kzYB9Mrlkx/uNJ
         uV88Pmj/tvIZrWkeGxuI4UEcwR6XzYZdfe1e+R1suq/3Z8l4xW/mgn4TobtBd4MzCo
         2vu8D/mT73x1nTTTjVv5LlDOmQ9cLRJTj5ilrtVzXexYHIewAQEQJZooAMkGfgriow
         I9OaZ1oeIiiAQ==
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
Subject: [PATCH xfrm-next 15/16] net/mlx5e: Group IPsec miss handles into separate struct
Date:   Fri,  2 Dec 2022 22:10:36 +0200
Message-Id: <5d499e96b90812ad4d4168a11c480bb79d6e083f.1670011671.git.leonro@nvidia.com>
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

Move miss handles into dedicated struct, so we can reuse it in next
patch when creating IPsec policy flow table.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c     | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index b89001538abd..dfdda5ae2245 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -16,10 +16,14 @@ struct mlx5e_ipsec_ft {
 	u32 refcnt;
 };
 
+struct mlx5e_ipsec_miss {
+	struct mlx5_flow_group *group;
+	struct mlx5_flow_handle *rule;
+};
+
 struct mlx5e_ipsec_rx {
 	struct mlx5e_ipsec_ft ft;
-	struct mlx5_flow_group *miss_group;
-	struct mlx5_flow_handle *miss_rule;
+	struct mlx5e_ipsec_miss sa;
 	struct mlx5_flow_destination default_dest;
 	struct mlx5e_ipsec_rule status;
 };
@@ -135,18 +139,18 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 		mlx5_core_err(mdev, "fail to create ipsec rx miss_group err=%d\n", err);
 		goto out;
 	}
-	rx->miss_group = miss_group;
+	rx->sa.group = miss_group;
 
 	/* Create miss rule */
 	miss_rule =
 		mlx5_add_flow_rules(ft, spec, &flow_act, &rx->default_dest, 1);
 	if (IS_ERR(miss_rule)) {
-		mlx5_destroy_flow_group(rx->miss_group);
+		mlx5_destroy_flow_group(rx->sa.group);
 		err = PTR_ERR(miss_rule);
 		mlx5_core_err(mdev, "fail to create ipsec rx miss_rule err=%d\n", err);
 		goto out;
 	}
-	rx->miss_rule = miss_rule;
+	rx->sa.rule = miss_rule;
 out:
 	kvfree(flow_group_in);
 	kvfree(spec);
@@ -155,8 +159,8 @@ static int rx_fs_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec_rx *rx)
 {
-	mlx5_del_flow_rules(rx->miss_rule);
-	mlx5_destroy_flow_group(rx->miss_group);
+	mlx5_del_flow_rules(rx->sa.rule);
+	mlx5_destroy_flow_group(rx->sa.group);
 	mlx5_destroy_flow_table(rx->ft.sa);
 
 	mlx5_del_flow_rules(rx->status.rule);
-- 
2.38.1

