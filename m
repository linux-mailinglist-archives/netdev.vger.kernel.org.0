Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60380397E1D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhFBBjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230004AbhFBBjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A5AC613D3;
        Wed,  2 Jun 2021 01:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597852;
        bh=kz/hCEY0NLEfNfyZ9ZjUBiXVJqw/daE9lGHoJXwMlkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7EiJH7AW4gwbuF+t6wSeiCYlSnSL7XwCv9Vbpv+1uYiRjw8iicuYf+jYquhaJPfC
         F+fSV3Sbt3auVhwwVoLw6NOvO3JFi50Fa5RhjZ2+/wybHW2Oz3kXqhVtQLIPUtJQr1
         zD6vfS3dXZa0P4bd+P5aYUFgUnK9ZPjHbgAjGCZe36LxAdubFSYGIdd2ccP0eUHCrj
         8crirrt9iGV9pkOOcG/sbSqHGLMGY7fU2OeaMrBkW8WP3z/JkcTiggv0nzT3oJu14Z
         SngKmZidLEsgvBDgedNdswG7f42CDPpWhXrpeaCVgdiEUqhIRU90KLAv3cqq+gXVbP
         e/FdRaew2yezQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 2/8] net/mlx5e: Disable TLS offload for uplink representor
Date:   Tue,  1 Jun 2021 18:37:17 -0700
Message-Id: <20210602013723.1142650-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

TLS offload is not supported in switchdev mode.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ad0f69480b9c..8eed2dcc8898 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3858,6 +3858,16 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 	}
 
+	if (mlx5e_is_uplink_rep(priv)) {
+		features &= ~NETIF_F_HW_TLS_RX;
+		if (netdev->features & NETIF_F_HW_TLS_RX)
+			netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
+
+		features &= ~NETIF_F_HW_TLS_TX;
+		if (netdev->features & NETIF_F_HW_TLS_TX)
+			netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
+	}
+
 	mutex_unlock(&priv->state_lock);
 
 	return features;
-- 
2.31.1

