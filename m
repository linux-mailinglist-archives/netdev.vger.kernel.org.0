Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0CF3508B4
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236577AbhCaURJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 16:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236469AbhCaUQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 16:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51CA9610A8;
        Wed, 31 Mar 2021 20:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617221798;
        bh=kXz7SXIDb/+Y1M+LQ1eRsURIkrh16KQ0z1fFV1t8Qfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QkoNAEpkDrXjo6BdQ3S6Mgu3AvuMdBj6K522ev6oQqTQ4g+EzGExyzsMBa0rh+yJq
         68ETq5i00rpe10tKW4smvfoUZrqQW2TZw14X5Yd5UcAUe8neLJkTkHaEkuWP4YkPOI
         i2qowlKuhPZYtZ4iw1bNjyEJBaKBUXKCW00fdhgnxNNE2KjOEDZ2ljYYV8pE9NMCMv
         tZgN+VCIcNWKSWSP5+4IapgfQoIJwHeKWdcF7wW6yniw2UqsGyopWaubnW6OTAq0Yx
         SSjXdzLnrWsCRU92j/AWdD5PEIDq/m29qhliSxguWSLywYYuLyJHNvIG5UVgA1f/4U
         FdYIJz9WMyS1w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/9] net/mlx5e: Fix ethtool indication of connector type
Date:   Wed, 31 Mar 2021 13:14:18 -0700
Message-Id: <20210331201424.331095-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210331201424.331095-1-saeed@kernel.org>
References: <20210331201424.331095-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Use connector_type read from PTYS register when it's valid, based on
corresponding capability bit.

Fixes: 5b4793f81745 ("net/mlx5e: Add support for reading connector type from PTYS")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f5f2a8fd0046..53802e18af90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -758,11 +758,11 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-static void ptys2ethtool_supported_advertised_port(struct ethtool_link_ksettings *link_ksettings,
-						   u32 eth_proto_cap,
-						   u8 connector_type, bool ext)
+static void ptys2ethtool_supported_advertised_port(struct mlx5_core_dev *mdev,
+						   struct ethtool_link_ksettings *link_ksettings,
+						   u32 eth_proto_cap, u8 connector_type)
 {
-	if ((!connector_type && !ext) || connector_type >= MLX5E_CONNECTOR_TYPE_NUMBER) {
+	if (!MLX5_CAP_PCAM_FEATURE(mdev, ptys_connector_type)) {
 		if (eth_proto_cap & (MLX5E_PROT_MASK(MLX5E_10GBASE_CR)
 				   | MLX5E_PROT_MASK(MLX5E_10GBASE_SR)
 				   | MLX5E_PROT_MASK(MLX5E_40GBASE_CR4)
@@ -898,9 +898,9 @@ static int ptys2connector_type[MLX5E_CONNECTOR_TYPE_NUMBER] = {
 		[MLX5E_PORT_OTHER]              = PORT_OTHER,
 	};
 
-static u8 get_connector_port(u32 eth_proto, u8 connector_type, bool ext)
+static u8 get_connector_port(struct mlx5_core_dev *mdev, u32 eth_proto, u8 connector_type)
 {
-	if ((connector_type || ext) && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
+	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_connector_type))
 		return ptys2connector_type[connector_type];
 
 	if (eth_proto &
@@ -1001,11 +1001,11 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 			 data_rate_oper, link_ksettings);
 
 	eth_proto_oper = eth_proto_oper ? eth_proto_oper : eth_proto_cap;
-
-	link_ksettings->base.port = get_connector_port(eth_proto_oper,
-						       connector_type, ext);
-	ptys2ethtool_supported_advertised_port(link_ksettings, eth_proto_admin,
-					       connector_type, ext);
+	connector_type = connector_type < MLX5E_CONNECTOR_TYPE_NUMBER ?
+			 connector_type : MLX5E_PORT_UNKNOWN;
+	link_ksettings->base.port = get_connector_port(mdev, eth_proto_oper, connector_type);
+	ptys2ethtool_supported_advertised_port(mdev, link_ksettings, eth_proto_admin,
+					       connector_type);
 	get_lp_advertising(mdev, eth_proto_lp, link_ksettings);
 
 	if (an_status == MLX5_AN_COMPLETE)
-- 
2.30.2

