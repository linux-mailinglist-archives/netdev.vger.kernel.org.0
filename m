Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE013A2157
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFJAYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230084AbhFJAYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E504613F3;
        Thu, 10 Jun 2021 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284540;
        bh=mVZWk7Ii+qwsFBJd0deSKhKi8a6OVG1/FAHkuMpMnyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oN6I3SDvId/zXkLUK6YYlFDYk71B8Fh+YeiKBACPrKwzqfdry7krXjcmd8liA59IQ
         WjXrf13ttfwU9MgAaQcQgLQZz/M9M7uXhN+BW7zRAyA7PpNt9LWiMDVQ5A93wiHTEI
         hHesDp6/i0jEoJf7w0pri+zf7N/sXFn1NEXZUtVQpKErtZLRR58EtWTkWO+ELmjbA8
         UT4aZpTRdjxBu5pl3rEayUBQebvsdWlMXrYBlPGxrMwjFHMdOej1Iluh8cTy0fJCaW
         i6BJXXV09rqbrxtb7eaK7qgp60QFbFJJ6yxQOBvC4OMHA8thommFB6derUsa8l5MdE
         faC564lVP8mCw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/12] net/mlx5e: Don't update netdev RQs with PTP-RQ
Date:   Wed,  9 Jun 2021 17:21:51 -0700
Message-Id: <20210610002155.196735-9-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Since the driver opens the PTP-RQ under channel 0, it appears to the
stack as if the SKB was received on rxq0. So from thew stack POV there
are still the same number of RX queues.

Fixes: 960fbfe222a4 ("net/mlx5e: Allow coexistence of CQE compression and HW TS PTP")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec6bafe7a2e5..263adc82b4e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2705,8 +2705,6 @@ static int mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;
 	num_rxqs = nch * priv->profile->rq_groups;
-	if (priv->channels.params.ptp_rx)
-		num_rxqs++;
 
 	mlx5e_netdev_set_tcs(netdev, nch, ntc);
 
-- 
2.31.1

