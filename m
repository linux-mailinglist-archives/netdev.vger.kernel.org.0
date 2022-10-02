Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A892E5F216B
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 07:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJBFOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 01:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiJBFOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 01:14:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC2751A28
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 22:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBE21B80CA0
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 05:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 526C4C433D7;
        Sun,  2 Oct 2022 05:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664687650;
        bh=dPy6vqSvkSEcZ6eRO+JfcTj0tEvskAJV2B3nWzeNz+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHerGJqB95yjsW2iNdbvB5saxEilCVJBm16+dupN55+hTy1Wdo/Jg0aGPXGpLd7W7
         ptsj0/nDeuIPQEMRVCO4YdJFMCtSi7K9pbotP3K4FoOo3BeNCpI6uFecgUO8KNAt8m
         jmdcynRS4zdi/h5fp7WCqtA7Won9yWzUkAnA6PVeEjefGpz36DR10vD+0YgYFzV2h1
         aEHGx5GJaXiw5+OBH74+h9AdgxQTeAQmcbV7t3VZWJ2+gjkm6awK/yyLwNw/36i+/c
         GdvkJs2aYynZBoj5e1ytdlMij8XsFECHFM7ly/Q8JImnpkOHoFgg1kX70OofRvm+VL
         QudNCcPNK6QjA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next 15/15] net/mlx5: E-Switch, Return EBUSY if can't get mode lock
Date:   Sat,  1 Oct 2022 21:56:32 -0700
Message-Id: <20221002045632.291612-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221002045632.291612-1-saeed@kernel.org>
References: <20221002045632.291612-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

It is to avoid tc retrying during device mode change.

Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0872a214d2a3..70a7a61f9708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4463,7 +4463,7 @@ int mlx5e_configure_flower(struct net_device *dev, struct mlx5e_priv *priv,
 	int err = 0;
 
 	if (!mlx5_esw_hold(priv->mdev))
-		return -EAGAIN;
+		return -EBUSY;
 
 	mlx5_esw_get(priv->mdev);
 
-- 
2.37.3

