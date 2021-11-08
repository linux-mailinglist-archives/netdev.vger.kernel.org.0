Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BFD447E89
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 12:11:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhKHLNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 06:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239005AbhKHLNi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 06:13:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBB0C60ED7;
        Mon,  8 Nov 2021 11:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636369854;
        bh=k1zNPqLta1tMAF9o2DEKZ+o6/DRChMDQml6YqtYykf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVDhBEdWR9Q4N4IrEqvMEzFkY0xugsPbuNWD3UwvJCQVnobw35LGcCPuQ0sJQVy/a
         D/wykxoqpeP2FQhqihqafx28sBRshpnY4E+fDeanpbE4LpVyJLt6NVJwPhVipkN+1q
         XE38e1jXAGbVvpQyUTpKHeIRLoteKfNyq8bXrRjJno6uyofA3gYKpTE0t96hPmzD0H
         sfykCTES1m6SGBf3Aa7BcZG/DGH5CBmZuk0tzFVoN8Glr6FmEFIfRSzXyIbHc5/woK
         mPLnUSCkthL0+RWk4A+mSiVnHA/pzZu/RMBRGCNSE/2lGJreNMpQfMWisR6fM7/Fdx
         tryDRGs4OQ4BQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Khalid Manaa <khalidm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mlx5: fix mlx5i_grp_sw_update_stats() stack usage
Date:   Mon,  8 Nov 2021 12:10:33 +0100
Message-Id: <20211108111040.3748899-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211108111040.3748899-1-arnd@kernel.org>
References: <20211108111040.3748899-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The mlx5e_sw_stats structure has grown to the point of triggering
a warning when put on the stack of a function:

mlx5/core/ipoib/ipoib.c: In function 'mlx5i_grp_sw_update_stats':
mlx5/core/ipoib/ipoib.c:136:1: error: the frame size of 1028 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

In this case, only five of the structure members are actually set,
so it's sufficient to have those as separate local variables.
As en_rep.c uses 'struct rtnl_link_stats64' for this, just use
the same one here for consistency.

Fixes: def09e7bbc3d ("net/mlx5e: Add HW_GRO statistics")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index ea1efdecc88c..158958a49743 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -110,7 +110,7 @@ void mlx5i_cleanup(struct mlx5e_priv *priv)
 
 static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 {
-	struct mlx5e_sw_stats s = { 0 };
+	struct rtnl_link_stats64 s = {};
 	int i, j;
 
 	for (i = 0; i < priv->stats_nch; i++) {
@@ -128,11 +128,17 @@ static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 
 			s.tx_packets           += sq_stats->packets;
 			s.tx_bytes             += sq_stats->bytes;
-			s.tx_queue_dropped     += sq_stats->dropped;
+			s.tx_dropped 	       += sq_stats->dropped;
 		}
 	}
 
-	memcpy(&priv->stats.sw, &s, sizeof(s));
+	memset(&priv->stats.sw, 0, sizeof(s));
+
+	priv->stats.sw.rx_packets = s.rx_packets;
+	priv->stats.sw.rx_bytes = s.rx_bytes;
+	priv->stats.sw.tx_packets = s.tx_packets;
+	priv->stats.sw.tx_bytes = s.tx_bytes;
+	priv->stats.sw.tx_queue_dropped = s.tx_dropped;
 }
 
 void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
-- 
2.29.2

