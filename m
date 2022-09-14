Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF845B8D01
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 18:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiINQ26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 12:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiINQ2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 12:28:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F271857EF
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 09:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DACC6B81729
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 16:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF1C433C1;
        Wed, 14 Sep 2022 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663172856;
        bh=thg1EQKgEKB5vvFJy+hOWYba3oQMf3932WX9jAMnQy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZB/j4xj0QkYY4hoj9HhhGz9EDRCaRzx4b1gD7bFbitHg6EQ7jGR4mk0P0AttqsG4
         H2M/lsdwgwNlw9BoDVHks0UUiF84vcy59GDro62VpkONZnq5OkmLav0zieF2Y/GWMZ
         WdirYFHbY3cY1+cWWIsW+GvYZaXA8EF6kIua31fORjRpz/9BCUM1PvCjGLKnYdZcZw
         S1xPkHLBc7ElTLsfIR0Ty+HrbVLNxQL4OH5VKmSYGRd3WTmCSr1FFoUVpFTI+RRrpL
         P/F99pM+jqZEVxth9M/Go097QR/sQGsSZ5vmydDShJGrNeXXdw95G/ydUoK4mPXPR3
         IVtao3LWJcvNA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next V2 03/10] net/mlx5e: Fix MACsec initialization error path
Date:   Wed, 14 Sep 2022 17:27:06 +0100
Message-Id: <20220914162713.203571-4-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220914162713.203571-1-saeed@kernel.org>
References: <20220914162713.203571-1-saeed@kernel.org>
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

