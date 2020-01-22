Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4AD14537D
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgAVLPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:15:16 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46771 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVLPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:15:15 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so2820956pll.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bityYlzGXinYLvMnE1fappYWoMHqk7N/eLNgbseuwb4=;
        b=ATTYYOhRAugnZOKrl3igX8iFv8ps0+vE5/cpPSEIVJ5bLJNKBZo8J0rBAAqhTNHKq4
         wzFBnXsns7ylQmxvDHeQt/IyJCL3AJ5cbDD9mw3ViAkXC4ah7mgiQe/fimnAQFB5aLim
         RbjmcYfIYAAYNhjDm+XPZSFyjyfkcJRM/9ks2Xn8BltgZvL/MGLvaURiUFwRQJtrV6b3
         iZhrUg7qaFcN4tP+o4oLruj2IWZVB2HBeC2HLKtUYRDzkV5egLLypuEFzpDAqVXGkBiN
         zB8emTrn6ZbZA0D0I7ZIlKxSTDR+3JsFS5d6l8xs4qQ/AGgiWBM31NCorTq+SbBd+fzh
         I8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bityYlzGXinYLvMnE1fappYWoMHqk7N/eLNgbseuwb4=;
        b=UWrdOkKNYfxXzraRFkMG3t0g4pyMfwvuep3yvMwdV3Ext+6N7rDJ1tpZh1wp3gE0+Z
         jwTW+2E6iEsym2r9C5mhKmn/kA+s14iawyu5LkZInbGmh72aO0CJIMlBRhv9i82oU5HR
         Yu/DQdhay/sqeMNl2I8xDM8b5FD3FZMAaESaKJuqkZ2DoEZLc5JFrVEM2esDCy4k4/Pr
         WXbAlOWzOLdsenaJXVTeH2fMe2xBkO+6KH6e9jkcJ65tHYXqodomX3JwJnw4ZXJ+K4zb
         yL+R0RyOc0/ZpCxWKejH4BdkWhTyz7duCnzgrZY8SHxjjlp24N8qcyDQVhUeSRi7tlB1
         2G/Q==
X-Gm-Message-State: APjAAAWuz5NUzEKEMiq26MIOlGAEdO/rL4nwmZrKIyEZxAoJ5M0Rl4h7
        KYS3Q/1YYUkXCKkqPjuiXzE=
X-Google-Smtp-Source: APXvYqxdKdapUqBjhNm3gQioYktrocK9Tx0+T3q57ILPwstRxnL9cQaWmkg0B3jN+D58dli6N5rKrA==
X-Received: by 2002:a17:90b:110d:: with SMTP id gi13mr2438880pjb.123.1579691715122;
        Wed, 22 Jan 2020 03:15:15 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id z26sm48393186pfa.90.2020.01.22.03.15.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jan 2020 03:15:14 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     gerlitz.or@gmail.com, roid@mellanox.com, saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH v3] net/mlx5e: Don't allow forwarding between uplink
Date:   Wed, 22 Jan 2020 19:15:03 +0800
Message-Id: <1579691703-56363-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We can install forwarding packets rule between uplink
in switchdev mode, as show below. But the hardware does
not do that as expected (mlnx_perf -i $PF1, we can't get
the counter of the PF1). By the way, if we add the uplink
PF0, PF1 to Open vSwitch and enable hw-offload, the rules
can be offloaded but not work fine too. This patch add a
check and if so return -EOPNOTSUPP.

$ tc filter add dev $PF0 protocol all parent ffff: prio 1 handle 1 \
    flower skip_sw action mirred egress redirect dev $PF1

$ tc -d -s filter show dev $PF0 ingress
    skip_sw
    in_hw in_hw_count 1
    action order 1: mirred (Egress Redirect to device enp130s0f1) stolen
    ...
    Sent hardware 408954 bytes 4173 pkt
    ...

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb2..ac2a035 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1434,6 +1434,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
 	.ndo_set_features        = mlx5e_set_features,
 };
 
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev)
+{
+	return netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep;
+}
+
 bool mlx5e_eswitch_rep(struct net_device *netdev)
 {
 	if (netdev->netdev_ops == &mlx5e_netdev_ops_rep ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 31f83c8..5211819 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -199,6 +199,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
 bool mlx5e_eswitch_rep(struct net_device *netdev);
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index db614bd..35f68e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3361,6 +3361,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 				struct net_device *uplink_upper;
+				struct mlx5e_rep_priv *rep_priv;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -3396,6 +3397,24 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
+				/* Don't allow forwarding between uplink.
+				 *
+				 * Input vport was stored esw_attr->in_rep.
+				 * In LAG case, *priv* is the private data of
+				 * uplink which may be not the input vport.
+				 */
+				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
+				if (mlx5e_eswitch_uplink_rep(rep_priv->netdev) &&
+				    mlx5e_eswitch_uplink_rep(out_dev)) {
+					NL_SET_ERR_MSG_MOD(extack,
+							   "devices are both uplink, "
+							   "can't offload forwarding");
+					pr_err("devices %s %s are both uplink, "
+					       "can't offload forwarding\n",
+					       priv->netdev->name, out_dev->name);
+					return -EOPNOTSUPP;
+				}
+
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-- 
1.8.3.1

