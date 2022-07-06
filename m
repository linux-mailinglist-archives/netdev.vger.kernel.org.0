Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022C55695AF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbiGFXNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbiGFXN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:13:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5945525DB
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93F9B81F3E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 23:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B5AC341D0;
        Wed,  6 Jul 2022 23:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657149205;
        bh=1QQtebDkcUOoHOGZYoGp0N73HUOLBjHkY14Qg/eEOyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2wxZBEOMwkk99DDbku55sOJ7ZN5VwkB0jsiR/bplBo1pLe/aNjaI7LIrzrmgoT6i
         pqTlwAAgzCtgOovRqD1nd1Z/nlzs0Knk2AtPuci9lzuBUIKqSk20UGsPIjCev8CFoP
         0U7CPyS/ywwX+5eVrkMWoWZ1W7aGhvdW+x4wttUr6h83kyK66QhdYVW9yZ4k7xP9OB
         FI/w+LILkL5CeNO4xq0mChA4ItyJ8Gux4p4ZrtIsHyy/ocrXHToha9BmQJr2pQwZIE
         QTxiVPFaJBI2jHxSWo186g6bL7B/EMgfZ4fcqdehtpLZ3umZe38Anx8MAX8BiW+EvG
         6r+1DKkhjrT9Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [net 8/9] net/mlx5e: Fix capability check for updating vnic env counters
Date:   Wed,  6 Jul 2022 16:13:08 -0700
Message-Id: <20220706231309.38579-9-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706231309.38579-1-saeed@kernel.org>
References: <20220706231309.38579-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

The existing capability check for vnic env counters only checks for
receive steering discards, although we need the counters update for the
exposed internal queue oob counter as well. This could result in the
latter counter not being updated correctly when the receive steering
discards counter is not supported.
Fix that by checking whether any counter is supported instead of only
the steering counter capability.

Fixes: 0cfafd4b4ddf ("net/mlx5e: Add device out of buffer counter")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 57fa0489eeb8..1e87bb2b7541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -688,7 +688,7 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vnic_env)
 	u32 in[MLX5_ST_SZ_DW(query_vnic_env_in)] = {};
 	struct mlx5_core_dev *mdev = priv->mdev;
 
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
+	if (!mlx5e_stats_grp_vnic_env_num_stats(priv))
 		return;
 
 	MLX5_SET(query_vnic_env_in, in, opcode, MLX5_CMD_OP_QUERY_VNIC_ENV);
-- 
2.36.1

