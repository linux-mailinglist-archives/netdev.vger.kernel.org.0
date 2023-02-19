Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA4769C045
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjBSNAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjBSNAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:00:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D6F743;
        Sun, 19 Feb 2023 05:00:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D82AB80979;
        Sun, 19 Feb 2023 13:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813DAC433EF;
        Sun, 19 Feb 2023 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676811603;
        bh=acHzQHTFaQFutstsuvlTVtHKCQBpg08G6aWqngqHziE=;
        h=From:To:Cc:Subject:Date:From;
        b=G48twqPoCLByRAXXCMCtZiV4ab4EM9WMfon9lpmn5KTXr2VI249QJEq94BOuAwrE3
         xprPhtNxJ/xZSKy7miC4Viu4yH5iwifvdD7LybmVTSMF7H/sdIYE2uTKr0yLjKqzgR
         szm81fO9l3VWBwIcIbLdlevkS+1aLnEOJInioQbHwEhNziy/ZxmFJaa+tfOfHL71E1
         MrGo/seXLIDlSmEXvtbHXGO/Ba8xzPm3WqzhrHyumx7BiPEGXOFUtDAgHwjsnadl/k
         3cT4SOVVI2MBcFLA0GPE55tnkhjecZcxd/Vjqq7jnJEmoLHi5eKrsNgYzRyCJ1Yw6K
         ay4Ej8Bz1skuQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Eric Dumazet <edumazet@google.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markzhang@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] net/mlx5: Fix memory leak in IPsec RoCE creation
Date:   Sun, 19 Feb 2023 14:59:57 +0200
Message-Id: <1b414ea3a92aa0d07b6261cf641445f27bc619d8.1676811549.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
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

From: Patrisious Haddad <phaddad@nvidia.com>

During IPsec RoCE TX creation a struct for the flow group creation is
allocated, but never freed. Free that struct once it is no longer in use.

Fixes: 22551e77e550 ("net/mlx5: Configure IPsec steering for egress RoCEv2 traffic")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
index 2c53589b765d..edc6798b359e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
@@ -162,7 +162,7 @@ int mlx5_ipsec_fs_roce_tx_create(struct mlx5_core_dev *mdev,
 	if (IS_ERR(ft)) {
 		err = PTR_ERR(ft);
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx ft err=%d\n", err);
-		return err;
+		goto fail_table;
 	}
 
 	roce->ft = ft;
@@ -174,22 +174,25 @@ int mlx5_ipsec_fs_roce_tx_create(struct mlx5_core_dev *mdev,
 	if (IS_ERR(g)) {
 		err = PTR_ERR(g);
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx group err=%d\n", err);
-		goto fail;
+		goto fail_group;
 	}
 	roce->g = g;
 
 	err = ipsec_fs_roce_tx_rule_setup(mdev, roce, pol_ft);
 	if (err) {
 		mlx5_core_err(mdev, "Fail to create RoCE IPsec tx rules err=%d\n", err);
-		goto rule_fail;
+		goto fail_rule;
 	}
 
+	kvfree(in);
 	return 0;
 
-rule_fail:
+fail_rule:
 	mlx5_destroy_flow_group(roce->g);
-fail:
+fail_group:
 	mlx5_destroy_flow_table(ft);
+fail_table:
+	kvfree(in);
 	return err;
 }
 
-- 
2.39.2

