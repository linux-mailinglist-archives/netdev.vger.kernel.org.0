Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F8B573FDF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiGMW7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiGMW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C203D2A953
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A89361AAF
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560C1C34114;
        Wed, 13 Jul 2022 22:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753164;
        bh=gFNAaCMJad1mFFNxhmK5LC1rHrA2lVYwGpbSOtZwxCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0mCOeU9O4luVSBmjkFYShljof0nshbi25X0BMF5TmWPYDhcg+xe5s/dVfOn87JeH
         kKvjxp9yLEIZjJfEjitfG2MCG8NtG5x3U5yiK0TxwsqRINYch4npaUM6FGoKaZxUWp
         TBX+ANGDCTFYH10FZMThSkK5svhjdHZmjzFPI3AsqxYNhBdBPvdVsKqcneswjSVroq
         4qDlcwgLycu6U07silmj0ZFKHVsQTFD7EtgIyO8cdD8+75fIFvqNgMjUBYO9JXWcWD
         duvGcTftcyUJiz9K/ht4+GprPcEAX1bDzWDhOPsmjt5TwLFcgVA9kjaTeF2U3JnWPP
         BevH5TCur44bw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Remove the duplicating check for striding RQ when enabling LRO
Date:   Wed, 13 Jul 2022 15:58:59 -0700
Message-Id: <20220713225859.401241-16-saeed@kernel.org>
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

LRO requires striding RQ and checks that it's enabled at two places:
mlx5e_fix_features and set_feature_lro. This commit keeps only one check
at mlx5e_fix_features and removes the duplicating one in
set_feature_lro.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index be84f800e122..cac4022ba7f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3595,12 +3595,6 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	mutex_lock(&priv->state_lock);
 
 	cur_params = &priv->channels.params;
-	if (enable && !MLX5E_GET_PFLAG(cur_params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		netdev_warn(netdev, "can't set LRO with legacy RQ\n");
-		err = -EINVAL;
-		goto out;
-	}
-
 	new_params = *cur_params;
 
 	if (enable)
-- 
2.36.1

