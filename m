Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEC1573FD8
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbiGMW7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiGMW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21B02A963
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DC3A61A78
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 778CCC3411E;
        Wed, 13 Jul 2022 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753163;
        bh=BbgLmT9wpjJim/nymRDDQf6o/OWYxRZaARtMNbo2vJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ianb3p/D2KrMXFubrVrpKQFf7pdMKNZq1w0K9miPTZGLL7QA7ErL1wdmrXikiDEIy
         FtfDWmjdSJeC+Kzu2N9BLH3OM3pFp9P0o9ME3/9/tzlusFe8L6U9sF/6mjzrFFucOY
         gKQbAjzf9aydw0c6nPLJwzbuYG2xdiQupdK4LBw4X3aIYXDShVszKjpDWP07QzqG32
         YqggimeMQQUJZq0wHqkKgyBG/E5mk+A3Ij5kZo/iQNovg4yCuSYQs0cvWhFRyjr6oh
         jNvCnutB+E+YOD/rfexfoI0TmTxIZrZV2w9UrHT6UxfiDbkQR6khpLan1eWmXMCA32
         XqvM+S8qAvo6A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next 14/15] net/mlx5e: Move the LRO-XSK check to mlx5e_fix_features
Date:   Wed, 13 Jul 2022 15:58:58 -0700
Message-Id: <20220713225859.401241-15-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

LRO is mutually exclusive with XSK. When LRO is enabled, it checks
whether XSK is active. This commit moves this check to a more correct
place at mlx5e_fix_features.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 087952b84ccb..be84f800e122 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3594,13 +3594,6 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 
 	mutex_lock(&priv->state_lock);
 
-	if (enable && priv->xsk.refcnt) {
-		netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
-			    priv->xsk.refcnt);
-		err = -EINVAL;
-		goto out;
-	}
-
 	cur_params = &priv->channels.params;
 	if (enable && !MLX5E_GET_PFLAG(cur_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		netdev_warn(netdev, "can't set LRO with legacy RQ\n");
@@ -3916,6 +3909,11 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	}
 
 	if (priv->xsk.refcnt) {
+		if (features & NETIF_F_LRO) {
+			netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
+				    priv->xsk.refcnt);
+			features &= ~NETIF_F_LRO;
+		}
 		if (features & NETIF_F_GRO_HW) {
 			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
-- 
2.36.1

