Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C9A5B51FE
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIKXlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 19:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiIKXlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 19:41:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3B8275C2
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 16:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 968176113E
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 23:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A859BC433C1;
        Sun, 11 Sep 2022 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662939689;
        bh=thg1EQKgEKB5vvFJy+hOWYba3oQMf3932WX9jAMnQy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EfdzuD8ejdL1y3g6kYn/CDkc8c9xU5RqWb1jCIK9yP57euh6C471dYBao+sK7jfJz
         ZnEJ+dA4PZK2jXUKuwMcgLZNgNJmfWk0FnLLKG784LT5ZZxUK+UXI5aZPBXkobes+F
         Fbpu+aauPtQXs2IoHEGZ1Wp4JOwQEmL6an9VxKpehkrV4u7wpf9uC/eIZETXRhPLTx
         8+idhYQxTwwvNxvtp8ysuJbo0stqrFufmfgCP/IzDqAv1RnZ054DsgbR/rglvK0zLs
         1QmF4NBkTGYRPTy2+hbzFifVV6ebItGDf/wBT35rcR/s8iBTMiqK+ivL8KKn8R6izE
         2fK5JP7V08N/g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 03/10] net/mlx5e: Fix MACsec initialization error path
Date:   Mon, 12 Sep 2022 00:40:52 +0100
Message-Id: <20220911234059.98624-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220911234059.98624-1-saeed@kernel.org>
References: <20220911234059.98624-1-saeed@kernel.org>
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

From: Emeel Hakim <ehakim@nvidia.com>

Currently MACsec initialization error path does not
destroy sci hash table in case of failure.
Fix by destroying hash table in case of failure.

Fixes: 9515978eee0b ("net/mlx5e: Implement MACsec Tx data path using MACsec skb_metadata_dst")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index d9d18b039d8c..7cbccc76798c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1284,7 +1284,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	if (err) {
 		mlx5_core_err(mdev, "MACsec offload: Failed to init SCI hash table, err=%d\n",
 			      err);
-		goto err_out;
+		goto err_hash;
 	}
 
 	xa_init_flags(&macsec->sc_xarray, XA_FLAGS_ALLOC1);
@@ -1304,6 +1304,8 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	return 0;
 
 err_out:
+	rhashtable_destroy(&macsec->sci_hash);
+err_hash:
 	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
 err_pd:
 	kfree(macsec);
-- 
2.37.3

