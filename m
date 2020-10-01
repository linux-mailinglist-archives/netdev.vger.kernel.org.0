Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137B027F7B6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 04:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbgJACF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 22:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730415AbgJACFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 22:05:32 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECDA821D80;
        Thu,  1 Oct 2020 02:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601517930;
        bh=jqZZAlz+GooEXSMANr50m6cxt6WDQ5l2qx+zaQKbcFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OPOejkld0yX7o4eWE4iquX+lHmh/mWdDzBsX6N9MlF1Akpbim0UCljhYu+/CFFcDu
         7mJCyMICXoXwYFUATgNLKnzo991iIOA5fKWQI4sfXG3YrrpImM1PS1SiIWO6RiEQxW
         oslz1ULQrLkMr2a+NePif9fXzFdE5PdJfG8KJaIk=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 14/15] net/mlx5e: Fix VLAN create flow
Date:   Wed, 30 Sep 2020 19:05:15 -0700
Message-Id: <20201001020516.41217-15-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001020516.41217-1-saeed@kernel.org>
References: <20201001020516.41217-1-saeed@kernel.org>
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

