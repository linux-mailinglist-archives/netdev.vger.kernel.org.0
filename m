Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D0280822
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733073AbgJATx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733026AbgJATxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:17 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC21208A9;
        Thu,  1 Oct 2020 19:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581996;
        bh=u7ZwC47uolB5RAe2RdrA3nnXH4+/eV1tmsqC0Wsg1lM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A0sIB1anYaC8Epln0VPZLU9qOC5UxmLOISLgisejsE2BVU6MrOfSqoMgIH1s3kO+w
         79hp2LrnlF51gD+8sppM6jw6yyXOJnoW94Ssld10YiYv4r3ObFQELtxfOXJ8dya4Jf
         bow4MHZBfxdV0LeNfY4hE2QFydu1Um1L2XeT4UKU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 11/15] net/mlx5e: Fix driver's declaration to support GRE offload
Date:   Thu,  1 Oct 2020 12:52:43 -0700
Message-Id: <20201001195247.66636-12-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Declare GRE offload support with respect to the inner protocol. Add a
list of supported inner protocols on which the driver can offload
checksum and GSO. For other protocols, inform the stack to do the needed
operations. There is no noticeable impact on GRE performance.

Fixes: 2729984149e6 ("net/mlx5e: Support TSO and TX checksum offloads for GRE tunnels")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b1a16fb9667e..42ec28e29834 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4226,6 +4226,21 @@ int mlx5e_get_vf_stats(struct net_device *dev,
 }
 #endif
 
+static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev *mdev,
+							   struct sk_buff *skb)
+{
+	switch (skb->inner_protocol) {
+	case htons(ETH_P_IP):
+	case htons(ETH_P_IPV6):
+	case htons(ETH_P_TEB):
+		return true;
+	case htons(ETH_P_MPLS_UC):
+	case htons(ETH_P_MPLS_MC):
+		return MLX5_CAP_ETH(mdev, tunnel_stateless_mpls_over_gre);
+	}
+	return false;
+}
+
 static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 						     struct sk_buff *skb,
 						     netdev_features_t features)
@@ -4248,7 +4263,9 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 	switch (proto) {
 	case IPPROTO_GRE:
-		return features;
+		if (mlx5e_gre_tunnel_inner_proto_offload_supported(priv->mdev, skb))
+			return features;
+		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
 		if (mlx5e_tunnel_proto_supported(priv->mdev, IPPROTO_IPIP))
-- 
2.26.2

