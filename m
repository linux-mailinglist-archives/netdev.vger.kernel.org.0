Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C87FC69F0EF
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjBVJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBVJGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:06:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8022CC73;
        Wed, 22 Feb 2023 01:06:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA3F1B811FF;
        Wed, 22 Feb 2023 09:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFD9C4339C;
        Wed, 22 Feb 2023 09:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677056806;
        bh=AHjFVAg/zxb1iHWHFMT2wbTZTPXx6iQykS7u7C5ESD4=;
        h=From:To:Cc:Subject:Date:From;
        b=KiySZCqOqEU9wWtJNrkWYoTj1JZtGlkkvg14iJ8VGipx+y0uKHPxXv/Tqr5FYzjNm
         +v2ReHq2ci95US0xtgYwbdppmLpolBvBrgpmOv891SXxnD1/sx/WgKWjRAXtUJKimC
         gz6ATm7oLpTEjbXgrH3slkwYbdu9yqRCuNFHNTQt8eXyyDZkrFY1bD/FFdTV2WA+lJ
         F0tIblABy0zzvh7LvWocrap+Xg0fsPem0QnZWKCkN/WoQBm/cYx/fzEmAb0jTOgX4F
         FqqFSNqUrdayZxT6LdO5xOb3JyN9BJ2yBMBx6hk0YPdzBRO9i05/N2kpLqNsVDmofa
         SUC/4gl/ZOuNg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net v1] net/mlx5: Fix memory leak in IPsec RoCE creation
Date:   Wed, 22 Feb 2023 11:06:40 +0200
Message-Id: <a69739482cca7176d3a466f87bbf5af1250b09bb.1677056384.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
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

From: Patrisious Haddad <phaddad@nvidia.com>

During IPsec RoCE TX creation a struct for the flow group creation is
allocated, but never freed. Free that struct once it is no longer in use.

Fixes: 22551e77e550 ("net/mlx5: Configure IPsec steering for egress RoCEv2 traffic")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog:
v1:
 * Changed target from net-next to net.
 * Replaced goto labels to mark what they do.
v0: https://lore.kernel.org/all/1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org
---
 .../ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
index 2c53589b765d..6e3f178d6f84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -162,7 +162,7 @@ int mlx5_ipsec_fs_roce_tx_create(struct mlx5_core_dev *mdev,
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx ft err=%d\n", err);
-		return err;
+		goto free_in;
 	}
 
 	roce->ft = ft;
@@ -174,22 +174,25 @@ int mlx5_ipsec_fs_roce_tx_create(struct mlx5_core_dev *mdev,
 	if (IS_ERR(g)) {
 		err = PTR_ERR(g);
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx group err=%d\n", err);
-		goto fail;
+		goto destroy_table;
 	}
 	roce->g = g;
 
 	err = ipsec_fs_roce_tx_rule_setup(mdev, roce, pol_ft);
 	if (err) {
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx rules err=%d\n", err);
-		goto rule_fail;
+		goto destroy_group;
 	}
 
+	kvfree(in);
 	return 0;
 
-rule_fail:
+destroy_group:
 	mlx5_destroy_flow_group(roce->g);
-fail:
+destroy_table:
 	mlx5_destroy_flow_table(ft);
+free_in:
+	kvfree(in);
 	return err;
 }
 
-- 
2.39.2

