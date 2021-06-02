Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00FF3397E1F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhFBBjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230048AbhFBBjP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57CF3613DB;
        Wed,  2 Jun 2021 01:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597853;
        bh=6bmO7LHIC+cZwYKQBUkNYONcriDeDP8aC85YzyP9rY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMOR2WX9EnTPMFydZP0lRCDoknh+i2cJYV7IoUJU4H/U6jP2hPL5oUsc5lArmRDV4
         DUBk8LidBzk3sQFZvMwg4jRneHFS/469c+34s1B6WHulUlwcC2LAEp2ZIgpMv9wwvd
         tYt3GOcfZw0tOoFJZ4CbodVC6vJb7L3eACq8YGEGhqFrHfsKKVg9nq6avGXhKv8gQU
         ZjYmqfB/IRW9EQwuux1RvbcO9xzJu0ATJcMS/mZEnscYVhzdeLZLHcVovC5Y1Equ8E
         z0WcCze6UEJ2hNt30A+BK+iLqxXcJv8biXNc43I7mfQzBjvjLxfZj8WYqxaMF8D4Nm
         0PSgX0htVyrrQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/8] net/mlx5e: Check for needed capability for cvlan matching
Date:   Tue,  1 Jun 2021 18:37:19 -0700
Message-Id: <20210602013723.1142650-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

If not supported show an error and return instead of trying to offload
to the hardware and fail.

Fixes: 699e96ddf47f ("net/mlx5e: Support offloading tc double vlan headers match")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 2c776e7a7692..dd64878e5b38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2015,11 +2015,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 				    misc_parameters_3);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
+	enum fs_flow_table_type fs_type;
 	u16 addr_type = 0;
 	u8 ip_proto = 0;
 	u8 *match_level;
 	int err;
 
+	fs_type = mlx5e_is_eswitch_flow(flow) ? FS_FT_FDB : FS_FT_NIC_RX;
 	match_level = outer_match_level;
 
 	if (dissector->used_keys &
@@ -2145,6 +2147,13 @@ static int __parse_cls_flower(struct mlx5e_priv *priv,
 		if (match.mask->vlan_id ||
 		    match.mask->vlan_priority ||
 		    match.mask->vlan_tpid) {
+			if (!MLX5_CAP_FLOWTABLE_TYPE(priv->mdev, ft_field_support.outer_second_vid,
+						     fs_type)) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Matching on CVLAN is not supported");
+				return -EOPNOTSUPP;
+			}
+
 			if (match.key->vlan_tpid == htons(ETH_P_8021AD)) {
 				MLX5_SET(fte_match_set_misc, misc_c,
 					 outer_second_svlan_tag, 1);
-- 
2.31.1

