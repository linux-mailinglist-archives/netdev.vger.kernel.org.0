Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF4311B4A
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 06:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhBFFFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 00:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230356AbhBFFDX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 00:03:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 217CC64FD1;
        Sat,  6 Feb 2021 05:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612587763;
        bh=KFfrXo1bFf+AqKfKQ4nDebK0MQPvta8m9egGvcCfhKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSUPo7+VbhY6J+nn7XNH7vrgiwQ+mE5OIHyDKenbZajbxBSXsayrjzaAn6URx1XAv
         Ae0E/+CL7smzOIp7AyxDxy0f89BsSUuvHkjwJ96PRqm8mZge0pHMiDsGftLJGXpXUz
         sxWOXlidyspUeYdevH2bNw6ChdpDWFa/AbAHYAazJIWGaSjc+LLo7x3Sj3GtWeK46Y
         NrG46mXp522CzY6MGcf1t3Arg36oWW6N/VhctCFubld5TSJ70bO0LJqcfYqAE9HghB
         UN11k50ozGWREpwQ28B4giVv+y/XEqo0mB0f0P08YyoAMc4ayPedckOaQWZVH+j6cJ
         2JKfnaKxQ3fCA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 03/17] net/mlx5e: Always set attr mdev pointer
Date:   Fri,  5 Feb 2021 21:02:26 -0800
Message-Id: <20210206050240.48410-4-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
References: <20210206050240.48410-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Eswitch offloads extensions in following patches in the series require
attr->esw_attr->in_mdev pointer to always be set. This is already the case
for all code paths except mlx5_tc_ct_entry_add_rule() function. Fix the
function to assign mdev pointer with priv->mdev value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 40aaa105b2fc..3fb75dcdc68d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -711,6 +711,8 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	attr->outer_match_level = MLX5_MATCH_L4;
 	attr->counter = entry->counter->counter;
 	attr->flags |= MLX5_ESW_ATTR_FLAG_NO_IN_PORT;
+	if (ct_priv->ns_type == MLX5_FLOW_NAMESPACE_FDB)
+		attr->esw_attr->in_mdev = priv->mdev;
 
 	mlx5_tc_ct_set_tuple_match(netdev_priv(ct_priv->netdev), spec, flow_rule);
 	mlx5e_tc_match_to_reg_match(spec, ZONE_TO_REG, entry->tuple.zone, MLX5_CT_ZONE_MASK);
-- 
2.29.2

