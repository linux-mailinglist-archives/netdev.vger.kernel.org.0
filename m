Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933A7437212
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 08:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhJVGte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 02:49:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhJVGtd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 02:49:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8E0160FE7;
        Fri, 22 Oct 2021 06:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634885236;
        bh=dZfeTaEbXXLP/qmwnJNpC77V3RzRnTM4fFBelnrubhA=;
        h=From:To:Cc:Subject:Date:From;
        b=cYaquShgz7lL/mis13ATVxEMijlZLt0EVc9QeVdt8mmTyrIgx542AldvpfVypusI6
         u5za2WY0uV3NtuRYZiuZMU2HOBlM3KH7tvmmZqOFp7jFQFFnUWB+6qeZpII31N5GKd
         Vbrz1aQ2hoccw08icgRI2DoHfor4uJfBENKsNwVk5iJQRB5fr2uD00QLD6m9ugREoO
         uts6u3un/gcfyDjQz2pm1nOjgeLT1AaB5VI8UoTLYQ4ffyFd1qpy3VLEYV+MPLVzqs
         BXhIndch1n8X2lizXIZuCj/FxmbZZ742XYNr9LAvWL5oMrjGDYTTrYXqSku98KUpg7
         HpculnfupWmpg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Moosa Baransi <moosab@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Meir Lichtinger <meirl@nvidia.com>,
        Yufeng Mo <moyufeng@huawei.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net/mlx5i: avoid unused function warning for mlx5i_flow_type_mask
Date:   Fri, 22 Oct 2021 08:47:03 +0200
Message-Id: <20211022064710.4158669-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without CONFIG_MLX5_EN_RXNFC, the function is unused, breaking the
build with CONFIG_WERROR:

mlx5/core/ipoib/ethtool.c:36:12: error: unused function 'mlx5i_flow_type_mask' [-Werror,-Wunused-function]
static u32 mlx5i_flow_type_mask(u32 flow_type)

We could add another #ifdef or mark this function inline, but
replacing the existing #ifdef with a __maybe_unused seems best
because that improves build coverage and avoids introducing
similar problems the next time this code changes.

Fixes: 9fbe1c25ecca ("net/mlx5i: Enable Rx steering for IPoIB via ethtool")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 .../net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c    | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
index ee0eb4a4b819..ae95677a01f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ethtool.c
@@ -222,8 +222,8 @@ static int mlx5i_get_link_ksettings(struct net_device *netdev,
 	return 0;
 }
 
-#ifdef CONFIG_MLX5_EN_RXNFC
-static int mlx5i_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+static __maybe_unused int mlx5i_set_rxnfc(struct net_device *dev,
+					  struct ethtool_rxnfc *cmd)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 	struct ethtool_rx_flow_spec *fs = &cmd->fs;
@@ -234,14 +234,14 @@ static int mlx5i_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return mlx5e_ethtool_set_rxnfc(priv, cmd);
 }
 
-static int mlx5i_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
-			   u32 *rule_locs)
+static __maybe_unused int mlx5i_get_rxnfc(struct net_device *dev,
+					  struct ethtool_rxnfc *info,
+					  u32 *rule_locs)
 {
 	struct mlx5e_priv *priv = mlx5i_epriv(dev);
 
 	return mlx5e_ethtool_get_rxnfc(priv, info, rule_locs);
 }
-#endif
 
 const struct ethtool_ops mlx5i_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-- 
2.29.2

