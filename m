Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A3E362815
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbhDPSzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236263AbhDPSzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FD5F613CE;
        Fri, 16 Apr 2021 18:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599282;
        bh=Y8GesS5IHycGhygZrfGpVHdrb103K9NkcdHMIEcyIp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h2Er6/aJljRJoUWRB60VP/Li3f1dFOqaDe0buPeKs52cqiwDSpf+BMWNc/iLwRdcL
         MxLadUN6Fc1gAUptdlCOyrKN6RIFdPvKQxtnT06tqioesw1BBIUyqGlHpQRPP4SF5Q
         YfTyrp8AQvAsfk6UbY68iyGrMr0EiuYjdZCLSIk47c1M6nCPpdEPfDK0Ql+G9sHfCI
         7wQPPz4iOXrlE5vseP9sKr3jPhX2DQefWBBM9trevhZDT4E6VDbMQaNVt5h9/xROQl
         rBYKPnnXz4Cf39TlV6svjZz6gvqHSXX+j15xFnlkwg+MnQB5g8maZbOX6glfxSWJra
         U3g/xBkeJJULA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/14] net/mlx5e: Allow mlx5e_safe_switch_channels to work with channels closed
Date:   Fri, 16 Apr 2021 11:54:22 -0700
Message-Id: <20210416185430.62584-7-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

mlx5e_safe_switch_channels is used to modify channel parameters and/or
hardware configuration in a safe way, so that if anything goes wrong,
everything reverts to the old configuration and remains in a consistent
state.

However, this function only works when the channels are open. When the
caller needs to modify some parameters, first it has to check that the
channels are open, otherwise it has to assign parameters directly, and
such boilerplate repeats in many different places.

This commit prepares for the refactoring of such places by allowing
mlx5e_safe_switch_channels to work when the channels are closed. In this
case it will assign the new parameters and run the preactivate hook.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 40 +++++++++++++------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index df4959e46f27..cb88d7239db6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2852,12 +2852,16 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 	struct net_device *netdev = priv->netdev;
 	struct mlx5e_channels old_chs;
 	int carrier_ok;
+	bool opened;
 	int err = 0;
 
-	carrier_ok = netif_carrier_ok(netdev);
-	netif_carrier_off(netdev);
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
+	if (opened) {
+		carrier_ok = netif_carrier_ok(netdev);
+		netif_carrier_off(netdev);
 
-	mlx5e_deactivate_priv_channels(priv);
+		mlx5e_deactivate_priv_channels(priv);
+	}
 
 	old_chs = priv->channels;
 	priv->channels = *new_chs;
@@ -2873,15 +2877,19 @@ static int mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 		}
 	}
 
-	mlx5e_close_channels(&old_chs);
-	priv->profile->update_rx(priv);
+	if (opened) {
+		mlx5e_close_channels(&old_chs);
+		priv->profile->update_rx(priv);
+	}
 
 out:
-	mlx5e_activate_priv_channels(priv);
+	if (opened) {
+		mlx5e_activate_priv_channels(priv);
 
-	/* return carrier back if needed */
-	if (carrier_ok)
-		netif_carrier_on(netdev);
+		/* return carrier back if needed */
+		if (carrier_ok)
+			netif_carrier_on(netdev);
+	}
 
 	return err;
 }
@@ -2891,11 +2899,16 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       mlx5e_fp_preactivate preactivate,
 			       void *context)
 {
+	bool opened;
 	int err;
 
-	err = mlx5e_open_channels(priv, new_chs);
-	if (err)
-		return err;
+	opened = test_bit(MLX5E_STATE_OPENED, &priv->state);
+
+	if (opened) {
+		err = mlx5e_open_channels(priv, new_chs);
+		if (err)
+			return err;
+	}
 
 	err = mlx5e_switch_priv_channels(priv, new_chs, preactivate, context);
 	if (err)
@@ -2904,7 +2917,8 @@ int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 	return 0;
 
 err_close:
-	mlx5e_close_channels(new_chs);
+	if (opened)
+		mlx5e_close_channels(new_chs);
 
 	return err;
 }
-- 
2.30.2

