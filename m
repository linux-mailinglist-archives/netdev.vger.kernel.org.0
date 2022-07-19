Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8015657A847
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234750AbiGSUfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGSUfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABAC41D09
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4472B6196F
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AD2C341CA;
        Tue, 19 Jul 2022 20:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262935;
        bh=4BddonNtfp1lTzRqDAbfxw3k9I8SUNKav3AmuThPjUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rpjj9DLGOwt/uBwBQpNhOXP+08FvdlXHwYKBiqMr5u5xwOPS24jobYfykSEBz9ugr
         8DkJXHz7H2+mDc3yFPjPbzgGDOM1XRCVNAEpfELd9Kx52ocWKokuGjFy5KSyjiX94f
         9qSHV12bSAxYZOHjA/MHhUv4OxDdIthl7jXPofOEyvwrsPMBZaQAMTg2VcvXQJxWcy
         gAtYdS5dQMJy2eQYaPx8idK1yhFPHRGsMoO/AkNa9Tr3i1D5GooeAqXlH69+dE3RLB
         RrKRXq6WsCU2Kh1qX98MFIEQ/2ruvy840E/jSeBbMc14fpxk0K3Cv7tVCPALaFfVCN
         kqK+wVFF9xPlQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>
Subject: [net-next V2 01/13] net/mlx5e: Report header-data split state through ethtool
Date:   Tue, 19 Jul 2022 13:35:17 -0700
Message-Id: <20220719203529.51151-2-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

