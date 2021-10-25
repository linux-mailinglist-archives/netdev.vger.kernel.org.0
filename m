Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0394443A50D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhJYU46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232287AbhJYU45 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A833560EDF;
        Mon, 25 Oct 2021 20:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195274;
        bh=jCa+cmYCTAu8GyPMMbSQ3BCXoOdHA6e3s2G3EdXaSsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJiTlRPWgsJ8b3iYAuXtLH8nLi2ENZBwxGalIaTXNivPEaO0ZR4G0WPt6sL28epb6
         tDcog+SbsQQVumfdeTfBOtJ21bZC+tW33z5yIiMZcOkc8O50KsNxSQZpsKbZJVHa5L
         xQEpvzOuP1agauoJ3fiXMdONd9pFJGfIRNIKQTpj2LOCQa9ae/cmEmh9tjB6qakp4M
         2VZqFO7b6uxyBQayAgiEi93Qi9Vpv9YE4JlvtYXf5Soo2XvWB+EV82ZHCPEL0HuIsO
         5ZNGBVLlxj/dRuNJol1Wf0wo6kDqM1d45zBSt2y+MgNV4GycqEO6a+BDT349YFBP6I
         GRWhJJ/J7qw0A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/14] net/mlx5: Fix unused function warning of mlx5i_flow_type_mask
Date:   Mon, 25 Oct 2021 13:54:20 -0700
Message-Id: <20211025205431.365080-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

The cited commit is causing unused-function warning[1] when
CONFIG_MLX5_EN_RXNFC is not set.
Fix this by moving the function into the ifdef, where it's only used

[1]
warning: ‘mlx5i_flow_type_mask’ defined but not used [-Wunused-function]

Fixes: 9fbe1c25ecca ("net/mlx5i: Enable Rx steering for IPoIB via ethtool")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index ee0eb4a4b819..962d41418ce7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -33,11 +33,6 @@
 #include "en.h"
 #include "ipoib.h"
 
-static u32 mlx5i_flow_type_mask(u32 flow_type)
-{
-	return flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
-}
-
 static void mlx5i_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *drvinfo)
 {
@@ -223,6 +218,11 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 }
 
 #ifdef CONFIG_MLX5_EN_RXNFC
+static u32 mlx5i_flow_type_mask(u32 flow_type)
+{
+	return flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS);
+}
+
 static int mlx5i_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
-- 
2.31.1

