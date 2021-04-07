Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943473562C3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348602AbhDGEzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348555AbhDGEyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A488613DE;
        Wed,  7 Apr 2021 04:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771280;
        bh=HjHnOtvMw3mTQefvmh/YsTIDbdWkPnsztnD6DwHfjBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bO9PNB9VeqTwaQC1iK6F4a08uLrAU8jGD4LciwsFBNseyc6nf0iaxCR/pGuI85Kx1
         LD9M3qSNe201hDKFXT843ugB6WoJ7iQA//yt5nait2xvEOwdbBoWeexVfLgqIb6Ubu
         DVnJZltYTkLuFhutb5dn436yoHzmLXu2fteU7nCbtp7xEhIRqD3Z2sp53Uugavf9C0
         CSi6uAhlLlP2kMo8wKcNwi5BzZI18T699X7D5JnZ3Ic74BYVKJ+IE4xpFInuwz8QtE
         a8wXi4QiSURnaEQWJMu5+IeutENePbA5E6UetLhR8EhUjGVUYx5DiSkgDJJ5ov7ZB1
         8GtEPqQYLm8jA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/13] net/mlx5e: TC, Handle sampled packets
Date:   Tue,  6 Apr 2021 21:54:20 -0700
Message-Id: <20210407045421.148987-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Mark the sampled packets with a sample restore object. Send sampled
packets using the psample api.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c   | 14 +++++++++++---
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c  | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/esw/sample.h  |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h |  6 ++++++
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index a25ec309d298..6cdc52d50a48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -17,6 +17,7 @@
 #include "en/mapping.h"
 #include "en/tc_tun.h"
 #include "lib/port_tun.h"
+#include "esw/sample.h"
 
 struct mlx5e_rep_indr_block_priv {
 	struct net_device *netdev;
@@ -675,13 +676,20 @@ bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 	}
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN) {
+	if (mapped_obj.type == MLX5_MAPPED_OBJ_CHAIN)
 		return mlx5e_restore_skb(skb, mapped_obj.chain, reg_c1, tc_priv);
-	} else {
+#endif /* CONFIG_NET_TC_SKB_EXT */
+#if IS_ENABLED(CONFIG_MLX5_TC_SAMPLE)
+	if (mapped_obj.type == MLX5_MAPPED_OBJ_SAMPLE) {
+		mlx5_esw_sample_skb(skb, &mapped_obj);
+		return false;
+	}
+#endif /* CONFIG_MLX5_TC_SAMPLE */
+	if (mapped_obj.type != MLX5_MAPPED_OBJ_SAMPLE &&
+	    mapped_obj.type != MLX5_MAPPED_OBJ_CHAIN) {
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
index 79a0e49b2799..629a0a28a7ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
@@ -298,6 +298,21 @@ sample_restore_put(struct mlx5_esw_psample *esw_psample, struct mlx5_sample_rest
 	}
 }
 
+void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj)
+{
+	u32 trunc_size = mapped_obj->sample.trunc_size;
+	struct psample_group psample_group = {};
+	struct psample_metadata md = {};
+
+	md.trunc_size = trunc_size ? min(trunc_size, skb->len) : skb->len;
+	md.in_ifindex = skb->dev->ifindex;
+	psample_group.group_num = mapped_obj->sample.group_id;
+	psample_group.net = &init_net;
+	skb_push(skb, skb->mac_len);
+
+	psample_sample_packet(&psample_group, skb, mapped_obj->sample.rate, &md);
+}
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
index e42e3cb01c8c..82bff97bd9b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
@@ -5,6 +5,7 @@
 #define __MLX5_EN_TC_SAMPLE_H__
 
 #include "en.h"
+#include "eswitch.h"
 
 struct mlx5_sample_attr {
 	u32 group_num;
@@ -12,6 +13,8 @@ struct mlx5_sample_attr {
 	u32 trunc_size;
 };
 
+void mlx5_esw_sample_skb(struct sk_buff *skb, struct mlx5_mapped_obj *mapped_obj);
+
 struct mlx5_esw_psample *
 mlx5_esw_sample_init(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 9b26bd67e2b8..ed4d7f8f798f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -50,12 +50,18 @@
 
 enum mlx5_mapped_obj_type {
 	MLX5_MAPPED_OBJ_CHAIN,
+	MLX5_MAPPED_OBJ_SAMPLE,
 };
 
 struct mlx5_mapped_obj {
 	enum mlx5_mapped_obj_type type;
 	union {
 		u32 chain;
+		struct {
+			u32 group_id;
+			u32 rate;
+			u32 trunc_size;
+		} sample;
 	};
 };
 
-- 
2.30.2

