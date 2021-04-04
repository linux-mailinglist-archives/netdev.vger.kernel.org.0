Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324B5353675
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhDDEUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236800AbhDDEUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585E06137A;
        Sun,  4 Apr 2021 04:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510012;
        bh=W1Has7rqXQ3Cl2TPSuTt4EagZcKG26nJ79lh3BAym44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNxomCg9yrap7h3Mnl8UWc6gcUr6If1hJ0FGUeX8ZxJuRvlhs80PKPBUUCwiIig5c
         vX7qnNy1LB5DBXJZ5CuxbmWK0guISf2UuJFg0hxzMEtDnZD42QuM1jEeHn7u8afiJd
         6pNua6VakDFr7OoNgd9tY25fTTw2mz0+F+tausMZNpbeC63o6mcWcHK1iPExoh0khR
         2n8Ly7+CbK7t0HLIPYgD+iWfCBo2U4MjdryD5qXPdeQAf3uOvMVSqcO7yiDt1kZyAb
         sDJVpRUEkP9xrHx2wfmG5Bg4g8T7PLORCcne0IkKx4ucbjtILamEMfwKsHFSxMsYIn
         iYPQpXO6BPCQw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/16] net/mlx5e: Reject tc rules which redirect from a VF to itself
Date:   Sat,  3 Apr 2021 21:19:52 -0700
Message-Id: <20210404041954.146958-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

Since there are self loopback prevention mechanisms at the
VF level, offloading such rules which redirect from a VF
to itself in the eswitch will break the datapath since the
packets will be dropped once they go back to the vport they
came from.

Therefore, offloading such rules will be rejected and left to
be handled by SW.

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dbc06c71c170..a4a4cdecbdea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3111,6 +3111,13 @@ static bool same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	return (fsystem_guid == psystem_guid);
 }
 
+static bool same_vf_reps(struct mlx5e_priv *priv,
+			 struct net_device *out_dev)
+{
+	return mlx5e_eswitch_vf_rep(priv->netdev) &&
+	       priv->netdev == out_dev;
+}
+
 static int add_vlan_rewrite_action(struct mlx5e_priv *priv, int namespace,
 				   const struct flow_action_entry *act,
 				   struct mlx5e_tc_flow_parse_attr *parse_attr,
@@ -3796,6 +3803,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 					return -EOPNOTSUPP;
 				}
 
+				if (same_vf_reps(priv, out_dev)) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "can't forward from a VF to itself");
+					return -EOPNOTSUPP;
+				}
+
 				out_priv = netdev_priv(out_dev);
 				rpriv = out_priv->ppriv;
 				esw_attr->dests[esw_attr->out_count].rep = rpriv->rep;
-- 
2.30.2

