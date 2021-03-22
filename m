Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FCB3450B2
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbhCVU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230520AbhCVUZd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:25:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 551F061998;
        Mon, 22 Mar 2021 20:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444733;
        bh=D6kU/bXdanr7vPIp3scHPdlB37G5TMijaUE2ssBPKKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKCmVbKccsfkk/3bFz+NZuDQptTQs0eF045z310JJgGjTQtrchC4ESf4Bw1cH4v8T
         M2Sc/S/fB2OXY3mXcitNgEil6Lp/GqlMIZ2W3SIqVohPeCQxukU0kxnkpuoJeEfthy
         6bHqUJRCxHS0h3kOVda9te081FSZR/DzRM2osMAneNFKhQSUz/I3wydsKaPeOtWKDB
         Wt7v5PROkqS5pvRFdKbzYfBYAOoZZw0hBuu7IG9kFlaHocSMMp5ikaeaGzioqvqAE7
         Km9Hf1IBCKrwbm07wWHFlEGEFP1lr/Sa9QH3siuRNOzeSDR4te3JYZu4tZzw4lg6zf
         LbjhGcKO3Egyw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Huy Nguyen <huyn@nvidia.com>,
        Daniel Jurgens <danielj@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 1/6] net/mlx5: Add back multicast stats for uplink representor
Date:   Mon, 22 Mar 2021 13:25:19 -0700
Message-Id: <20210322202524.68886-2-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322202524.68886-1-saeed@kernel.org>
References: <20210322202524.68886-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

The multicast counter got removed from uplink representor due to the
cited patch.

Fixes: 47c97e6b10a1 ("net/mlx5e: Fix multicast counter not up-to-date in "ip -s"")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 33b418796e43..c8b8249846a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3846,10 +3846,17 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	}
 
 	if (mlx5e_is_uplink_rep(priv)) {
+		struct mlx5e_vport_stats *vstats = &priv->stats.vport;
+
 		stats->rx_packets = PPORT_802_3_GET(pstats, a_frames_received_ok);
 		stats->rx_bytes   = PPORT_802_3_GET(pstats, a_octets_received_ok);
 		stats->tx_packets = PPORT_802_3_GET(pstats, a_frames_transmitted_ok);
 		stats->tx_bytes   = PPORT_802_3_GET(pstats, a_octets_transmitted_ok);
+
+		/* vport multicast also counts packets that are dropped due to steering
+		 * or rx out of buffer
+		 */
+		stats->multicast = VPORT_COUNTER_GET(vstats, received_eth_multicast.packets);
 	} else {
 		mlx5e_fold_sw_stats64(priv, stats);
 	}
-- 
2.30.2

