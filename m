Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E408466ED8
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244872AbhLCA7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:52 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56236 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244265AbhLCA7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B5B4B823BC
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DBAC53FD1;
        Fri,  3 Dec 2021 00:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492985;
        bh=nuzoSvqabNnod4WruM+plVusIlhRKvW1WD5DujbPRlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iF/22mHhriT6wtj7LbdoWZYDqOzfEsBpJDo9kg1g+lUDNF/DB/WVA/Lar9kgf9bIy
         jsUKOY+5JWS7KjpfjXgqAowzEPvvMo0Jo7n3Uw5xduJ8abeUH6XlC9kkxHCHlBxG0F
         KjzRGyNR16gAqtwPUNRQAjJVd9VAPtHNDqfL5QDvdwNLgVTqycVAQSOotunIWJsbiP
         xWjv6RbGY89hLqpy8PwsmcGTl/vnSSk0KeeAVLRGJkRRsNPEGS9KHh9m6rpITE3vRe
         NPZZcBlQxcXO2FAQopIMUJqxQImSCvyp1tu94Ud3wkRoibct8eVcyMc87I98kRYj0n
         30a9vVkMOV5PA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 02/14] mlx5: fix mlx5i_grp_sw_update_stats() stack usage
Date:   Thu,  2 Dec 2021 16:56:10 -0800
Message-Id: <20211203005622.183325-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
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

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index ea1efdecc88c..051b20ec7bdb 100644
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
+			s.tx_dropped           += sq_stats->dropped;
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
2.31.1

