Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6535DACFC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiIUSLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 14:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiIUSLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 14:11:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DED96170D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 11:11:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A65B062F5B
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 18:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E65C433C1;
        Wed, 21 Sep 2022 18:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663783862;
        bh=/zh/UtdmODwOd1pFWhS3ZwZz/ZghW52qQEb29nr8uJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fPFRUzk8xyx+1EXPoHbdKV6+jYSF720JYUE7jHUGKLiXoXyBtiyAXd6ztUOkL0Ijw
         HZmBCbudDV0LKLGDqJCOMkDrUkqhatkSeJn6yOZvW/7PJ2Q0NAONVEpxkUmjXtVMuy
         nXcD9/F+mQEuNuFjNXovi8WG3vShh2thPJweuhr9d3b7Ovexi4Hhr526h5J7hboYn2
         iYTDJIDJ4MDS1vhHfKnveNFKQRwhxH0Y00dM+KdsssQNT85YXyKzVycaN7jAsZbPBr
         oUhwGfHE3xe3xaAI2LIBkFaI9+TofSFkbxrYO3SCBRaLeSYXzZpVYGMo7gA6jieofI
         SPTbMu9aUQfnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next V3 03/10] net/mlx5e: Fix MACsec initialization error path
Date:   Wed, 21 Sep 2022 11:10:47 -0700
Message-Id: <20220921181054.40249-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921181054.40249-1-saeed@kernel.org>
References: <20220921181054.40249-1-saeed@kernel.org>
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
index ea362072a984..0600c03ccc73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -1285,7 +1285,7 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	if (err) {
 		mlx5_core_err(mdev, "MACsec offload: Failed to init SCI hash table, err=%d\n",
 			      err);
-		goto err_out;
+		goto err_hash;
 	}
 
 	xa_init_flags(&macsec->sc_xarray, XA_FLAGS_ALLOC1);
@@ -1307,6 +1307,8 @@ int mlx5e_macsec_init(struct mlx5e_priv *priv)
 	return 0;
 
 err_out:
+	rhashtable_destroy(&macsec->sci_hash);
+err_hash:
 	mlx5_core_dealloc_pd(priv->mdev, macsec->aso_pdn);
 err_pd:
 	kfree(macsec);
-- 
2.37.3

