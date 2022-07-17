Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8174D577854
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 23:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiGQVfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 17:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiGQVfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 17:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1538C10554
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 14:35:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A39C860A20
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 21:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC11C341CA;
        Sun, 17 Jul 2022 21:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658093742;
        bh=4BddonNtfp1lTzRqDAbfxw3k9I8SUNKav3AmuThPjUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqxCocbCbzdzm7iJ5iltJiPFXkAI8ela2/VkxI7xU+C86M4Xd8Nr4KEdtsUf+z2Qn
         8IIVXm0hsBUAcfilBSvMIJ+3GJ/9KM0bI3dMg3/F+paqQpqBf9SYuvlddr+Zk7608l
         nau2Nv5KFRUZ/CQ01HxzYPAdgTsavYnm024L2e8nLJC/7/dtuxnGqIIy7Yl+e6U+f9
         MXa/FMJLlxywGsK2cfgk2uZteXcheMJ/hScvD/AStIdTluoZubh7DnVFZxwGtjNzKF
         Jkq4EVM845wF9qTQ0n8IM7Pgq728nYVvGrqfvQh2DxSFO0KGtsrQs2o49KnFVoYAvp
         8bz1BZ/RW7hIg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next 01/14] net/mlx5e: Report header-data split state through ethtool
Date:   Sun, 17 Jul 2022 14:33:39 -0700
Message-Id: <20220717213352.89838-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220717213352.89838-1-saeed@kernel.org>
References: <20220717213352.89838-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

HW-GRO (SHAMPO) packet merger scheme implies header-data split in the
driver, report it through the ethtool interface.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 12 ++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |  2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index b6c15efe92ad..da10061d0c03 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1181,7 +1181,8 @@ int mlx5e_ethtool_get_sset_count(struct mlx5e_priv *priv, int sset);
 void mlx5e_ethtool_get_ethtool_stats(struct mlx5e_priv *priv,
 				     struct ethtool_stats *stats, u64 *data);
 void mlx5e_ethtool_get_ringparam(struct mlx5e_priv *priv,
-				 struct ethtool_ringparam *param);
+				 struct ethtool_ringparam *param,
+				 struct kernel_ethtool_ringparam *kernel_param);
 int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
 				struct ethtool_ringparam *param);
 void mlx5e_ethtool_get_channels(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 6e80585d731f..820912eb7bcf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -30,6 +30,8 @@
  * SOFTWARE.
  */
 
+#include <linux/ethtool_netlink.h>
+
 #include "en.h"
 #include "en/port.h"
 #include "en/params.h"
@@ -305,12 +307,18 @@ static void mlx5e_get_ethtool_stats(struct net_device *dev,
 }
 
 void mlx5e_ethtool_get_ringparam(struct mlx5e_priv *priv,
-				 struct ethtool_ringparam *param)
+				 struct ethtool_ringparam *param,
+				 struct kernel_ethtool_ringparam *kernel_param)
 {
 	param->rx_max_pending = 1 << MLX5E_PARAMS_MAXIMUM_LOG_RQ_SIZE;
 	param->tx_max_pending = 1 << MLX5E_PARAMS_MAXIMUM_LOG_SQ_SIZE;
 	param->rx_pending     = 1 << priv->channels.params.log_rq_mtu_frames;
 	param->tx_pending     = 1 << priv->channels.params.log_sq_size;
+
+	kernel_param->tcp_data_split =
+		(priv->channels.params.packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO) ?
+		ETHTOOL_TCP_DATA_SPLIT_ENABLED :
+		ETHTOOL_TCP_DATA_SPLIT_DISABLED;
 }
 
 static void mlx5e_get_ringparam(struct net_device *dev,
@@ -320,7 +328,7 @@ static void mlx5e_get_ringparam(struct net_device *dev,
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	mlx5e_ethtool_get_ringparam(priv, param);
+	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
 }
 
 int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *priv,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f797fd97d305..ae90b06d21e2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -229,7 +229,7 @@ mlx5e_rep_get_ringparam(struct net_device *dev,
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	mlx5e_ethtool_get_ringparam(priv, param);
+	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
 }
 
 static int
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index 8da73ef5680f..ac3757beaea2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -83,7 +83,7 @@ static void mlx5i_get_ringparam(struct net_device *dev,
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
-	mlx5e_ethtool_get_ringparam(priv, param);
+	mlx5e_ethtool_get_ringparam(priv, param, kernel_param);
 }
 
 static int mlx5i_set_channels(struct net_device *dev,
-- 
2.36.1

