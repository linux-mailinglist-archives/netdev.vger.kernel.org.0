Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485E74D6B8E
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 01:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiCLAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 19:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLAz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 19:55:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F662A7AFF
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:54:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A8FC6159F
        for <netdev@vger.kernel.org>; Sat, 12 Mar 2022 00:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480D4C340E9;
        Sat, 12 Mar 2022 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647046463;
        bh=fOABcNzJe5wmjlOwS/BBw7BbmQoDs2AMrBkF5qKjInY=;
        h=From:To:Cc:Subject:Date:From;
        b=OakY6F1ehSUnpSRBvyz4oWQDU1qvJkrkgSRozaWeywvHkv1YFCYnamM4bwaqFcvJS
         c6DURoCmrSnxlluvP2NTJS1sezwMvEHqt6fKVkWGFZmo4ZpdPhASh4qXNkPNNrJ5nv
         pf1jRW1JteCeoUvQmzeuIVhZC6wV0LeLg/ACcRBx4FtGh8A97FjEvLqa33uroHZo+2
         i+kP+NeFh1U2n8lP8KF1MeMagfX1kMykNnYO0v29/6rAGnPs7wK/P721J/BODVkkzt
         1cRMWQop0qtccABnQByqrqEvkJR8WiyvCuIC9hqcA6W1cmIzutybUKtylZ5863yZCX
         agVsaYrq25Flg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Joe Damato <jdamato@fastly.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next] net/mlx5e: Fix use-after-free in mlx5e_stats_grp_sw_update_stats
Date:   Fri, 11 Mar 2022 16:53:53 -0800
Message-Id: <20220312005353.786255-1-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

We need to sync page pool stats only for active channels. Reading ethtool
stats on a down netdev or a netdev with modified number of channels will
result in a user-after-free, trying to access page pools that are freed
already.

BUG: KASAN: use-after-free in mlx5e_stats_grp_sw_update_stats+0x465/0xf80
Read of size 8 at addr ffff888004835e40 by task ethtool/720

Fixes: cc10e84b2ec3 ("mlx5: add support for page_pool_get_stats")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 336e4d04c5f2..bdc870f9c2f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -521,14 +521,15 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(sw)
 
 	memset(s, 0, sizeof(*s));
 
+	for (i = 0; i < priv->channels.num; i++) /* for active channels only */
+		mlx5e_stats_update_stats_rq_page_pool(priv->channels.c[i]);
+
 	for (i = 0; i < priv->stats_nch; i++) {
 		struct mlx5e_channel_stats *channel_stats =
 			priv->channel_stats[i];
 
 		int j;
 
-		mlx5e_stats_update_stats_rq_page_pool(priv->channels.c[i]);
-
 		mlx5e_stats_grp_sw_update_stats_rq_stats(s, &channel_stats->rq);
 		mlx5e_stats_grp_sw_update_stats_xdpsq(s, &channel_stats->rq_xdpsq);
 		mlx5e_stats_grp_sw_update_stats_ch_stats(s, &channel_stats->ch);
-- 
2.35.1

