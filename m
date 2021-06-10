Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCC83A2159
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhFJAYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230153AbhFJAYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A230B613F9;
        Thu, 10 Jun 2021 00:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284541;
        bh=Dn04M6pKVRqi410TOg6b9Boj7mzjs+oROLgZV5Rg3GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NAaDVsih45GOcW2ZSAumFAxCAKUHp38Br+q/l7tlmv7T8U6PL1Ftz8owTn+zdEoFc
         ytAu7kLqpRO6OKOgu5OGLGxPqIozRpK/4ih8BECNoxTGUZ2+y8tME7VGaXpZd8qrOZ
         dwrRxs3ql0SYUvQH6hE+0YXrmk34ZFiNRYakdSLIWVd6/T9piwOZpiE/saoyThIeBU
         VzVC/oltAkZHZIlfEI0BPooRy6ta9PlFf4bkZ5d3WKJWP7CBUbao+0XI0sXqcOcg5U
         o/s7kBzRklMliBXWL04lKE2BZFsBnyWHqz1mBZAdX2l8z4l8mGpNEcwFCAN+aj6gzO
         RvpHGd7BEdz/Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 09/12] net/mlx5e: Fix select queue to consider SKBTX_HW_TSTAMP
Date:   Wed,  9 Jun 2021 17:21:52 -0700
Message-Id: <20210610002155.196735-10-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Steering packets to PTP-SQ should be done only if the SKB has
SKBTX_HW_TSTAMP set in the tx_flags. While here, take the function into
a header and inline it.
Set the whole condition to select the PTP-SQ to unlikely.

Fixes: 24c22dd0918b ("net/mlx5e: Add states to PTP channel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  | 22 ++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 25 +++----------------
 3 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index d907c1acd4d5..778e229310a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2020 Mellanox Technologies
 
-#include <linux/ptp_classify.h>
 #include "en/ptp.h"
 #include "en/txrx.h"
 #include "en/params.h"
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index ab935cce952b..c96668bd701c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -6,6 +6,7 @@
 
 #include "en.h"
 #include "en_stats.h"
+#include <linux/ptp_classify.h>
 
 struct mlx5e_ptpsq {
 	struct mlx5e_txqsq       txqsq;
@@ -43,6 +44,27 @@ struct mlx5e_ptp {
 	DECLARE_BITMAP(state, MLX5E_PTP_STATE_NUM_STATES);
 };
 
+static inline bool mlx5e_use_ptpsq(struct sk_buff *skb)
+{
+	struct flow_keys fk;
+
+	if (!(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+		return false;
+
+	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
+		return false;
+
+	if (fk.basic.n_proto == htons(ETH_P_1588))
+		return true;
+
+	if (fk.basic.n_proto != htons(ETH_P_IP) &&
+	    fk.basic.n_proto != htons(ETH_P_IPV6))
+		return false;
+
+	return (fk.basic.ip_proto == IPPROTO_UDP &&
+		fk.ports.dst == htons(PTP_EV_PORT));
+}
+
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp);
 void mlx5e_ptp_close(struct mlx5e_ptp *c);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 8ba62671f5f1..320fe0cda917 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -32,7 +32,6 @@
 
 #include <linux/tcp.h>
 #include <linux/if_vlan.h>
-#include <linux/ptp_classify.h>
 #include <net/geneve.h>
 #include <net/dsfield.h>
 #include "en.h"
@@ -67,24 +66,6 @@ static inline int mlx5e_get_dscp_up(struct mlx5e_priv *priv, struct sk_buff *skb
 }
 #endif
 
-static bool mlx5e_use_ptpsq(struct sk_buff *skb)
-{
-	struct flow_keys fk;
-
-	if (!skb_flow_dissect_flow_keys(skb, &fk, 0))
-		return false;
-
-	if (fk.basic.n_proto == htons(ETH_P_1588))
-		return true;
-
-	if (fk.basic.n_proto != htons(ETH_P_IP) &&
-	    fk.basic.n_proto != htons(ETH_P_IPV6))
-		return false;
-
-	return (fk.basic.ip_proto == IPPROTO_UDP &&
-		fk.ports.dst == htons(PTP_EV_PORT));
-}
-
 static u16 mlx5e_select_ptpsq(struct net_device *dev, struct sk_buff *skb)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -145,9 +126,9 @@ u16 mlx5e_select_queue(struct net_device *dev, struct sk_buff *skb,
 		}
 
 		ptp_channel = READ_ONCE(priv->channels.ptp);
-		if (unlikely(ptp_channel) &&
-		    test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
-		    mlx5e_use_ptpsq(skb))
+		if (unlikely(ptp_channel &&
+			     test_bit(MLX5E_PTP_STATE_TX, ptp_channel->state) &&
+			     mlx5e_use_ptpsq(skb)))
 			return mlx5e_select_ptpsq(dev, skb);
 
 		txq_ix = netdev_pick_tx(dev, skb, NULL);
-- 
2.31.1

