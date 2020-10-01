Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C934628081C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733088AbgJATx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730073AbgJATxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:18 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E28B21D46;
        Thu,  1 Oct 2020 19:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581997;
        bh=jqZZAlz+GooEXSMANr50m6cxt6WDQ5l2qx+zaQKbcFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9Bdq7OEeNd0bb3wUreHNz76B2Bk7tnJoo7IOYRO3QpJaCttvu4HJW/O68ukfx3IB
         3LC3nXwuFFo0xL2tMbETnoftrhTFAWCJ6JiIEc2/l/PVr4ooDS06ENqTzOlPJFFMTI
         4saFVi+InbD0Gpnld7mnQHeyuevsR9+2OQ+6toSM=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 14/15] net/mlx5e: Fix VLAN create flow
Date:   Thu,  1 Oct 2020 12:52:46 -0700
Message-Id: <20201001195247.66636-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When interface is attached while in promiscuous mode and with VLAN
filtering turned off, both configurations are not respected and VLAN
filtering is performed.
There are 2 flows which add the any-vid rules during interface attach:
VLAN creation table and set rx mode. Each is relaying on the other to
add any-vid rules, eventually non of them does.

Fix this by adding any-vid rules on VLAN creation regardless of
promiscuous mode.

Fixes: 9df30601c843 ("net/mlx5e: Restore vlan filter after seamless reset")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 55a4c3adaa05..1f48f99c0997 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -217,6 +217,9 @@ static int __mlx5e_add_vlan_rule(struct mlx5e_priv *priv,
 		break;
 	}
 
+	if (WARN_ONCE(*rule_p, "VLAN rule already exists type %d", rule_type))
+		return 0;
+
 	*rule_p = mlx5_add_flow_rules(ft, spec, &flow_act, &dest, 1);
 
 	if (IS_ERR(*rule_p)) {
@@ -397,8 +400,7 @@ static void mlx5e_add_vlan_rules(struct mlx5e_priv *priv)
 	for_each_set_bit(i, priv->fs.vlan.active_svlans, VLAN_N_VID)
 		mlx5e_add_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_STAG_VID, i);
 
-	if (priv->fs.vlan.cvlan_filter_disabled &&
-	    !(priv->netdev->flags & IFF_PROMISC))
+	if (priv->fs.vlan.cvlan_filter_disabled)
 		mlx5e_add_any_vid_rules(priv);
 }
 
-- 
2.26.2

