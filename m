Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8A73380AE
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhCKWhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhCKWhj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD3764F92;
        Thu, 11 Mar 2021 22:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502259;
        bh=QoAHrOJRcgRAv6QqCInM2hsQ80g6LO5uPtnTCOswUI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwjsKpOjwtcfsQ14gDLZJadDZQeo0vyKqlu/wE9iQaJ2kI4Bks3lEQqXPROizWzII
         6zWs9IHUNXGvP8pW/DrqiYc1bWMFaGh6pm1gJv4sCm25a0huFE5D6kdMwP7EP921wM
         k4CpnRxcPhL1VDuheg0d01SIjWi0dxN+r6o60FUNqGMQgTvMtBW4QRcN98S7H+d3LX
         aqfdW7MkccBeH2qPvou3/yz7HDQGC1LTRX3/aLDq8X75VCtoRNPaI3WBm16NCbc1Lt
         E4NiSiGgPdsXucumZ7D7mZir4u/NZj1cDVJ8kMH+BLlty2eB/C5IFnxMVNMVGg053P
         nDaXTiYn4i7Lw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next 11/15] net/mlx5e: mlx5_tc_ct_init does not fail
Date:   Thu, 11 Mar 2021 14:37:19 -0800
Message-Id: <20210311223723.361301-12-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

mlx5_tc_ct_init() either returns a valid pointer or a NULL, either way
the caller can continue, remove IS_ERR check from callers as it has no
effect.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0da69b98f38f..dc126389291d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4646,10 +4646,6 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 	tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
 				 MLX5_FLOW_NAMESPACE_KERNEL);
-	if (IS_ERR(tc->ct)) {
-		err = PTR_ERR(tc->ct);
-		goto err_ct;
-	}
 
 	tc->netdevice_nb.notifier_call = mlx5e_tc_netdev_event;
 	err = register_netdevice_notifier_dev_net(priv->netdev,
@@ -4665,7 +4661,6 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 
 err_reg:
 	mlx5_tc_ct_clean(tc->ct);
-err_ct:
 	mlx5_chains_destroy(tc->chains);
 err_chains:
 	rhashtable_destroy(&tc->ht);
@@ -4724,8 +4719,6 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 					       esw_chains(esw),
 					       &esw->offloads.mod_hdr,
 					       MLX5_FLOW_NAMESPACE_FDB);
-	if (IS_ERR(uplink_priv->ct_priv))
-		goto err_ct;
 
 	mapping = mapping_create(sizeof(struct tunnel_match_key),
 				 TUNNEL_INFO_BITS_MASK, true);
@@ -4765,7 +4758,6 @@ int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
 	mapping_destroy(uplink_priv->tunnel_mapping);
 err_tun_mapping:
 	mlx5_tc_ct_clean(uplink_priv->ct_priv);
-err_ct:
 	netdev_warn(priv->netdev,
 		    "Failed to initialize tc (eswitch), err: %d", err);
 	return err;
-- 
2.29.2

