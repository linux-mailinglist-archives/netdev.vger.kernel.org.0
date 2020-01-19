Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116A5141B2B
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 03:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgASCZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 21:25:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46226 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727403AbgASCZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 21:25:19 -0500
Received: by mail-pf1-f195.google.com with SMTP id n9so13914834pff.13
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 18:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=W5iNTiM9hIxjQ/uS1sHAXW9mhHbH2vJ+laiNVlKvx4A=;
        b=ox8kYPhcYg8KWlwHvPOau+oG+0pGqfV9fL08Uqr5+6iSW85eJXNW3wvODl/i2Phvle
         8TXNHUpaTZkO03KR5bL4jW5vKtlD+62ei2qvgQePR1YLFvVH1xkyP9rjOAN8CCColPKd
         wyPRIn6Mm3oW498m9BsLz9JY8v/mCKF6ek8xT4rRRRe+RIJ+jeP6VI0C4KWLLEDPUTZx
         vm3ksDGgthBeRQVN8vuH9q3IGKZN9yr0v8j0df6CrEZkCCisWJHFRbGqecAStgHqfzpX
         bVIqdF86LTy1+gEmf3rdnt1XOHPmm+cwPioD200fueOCBAfBzJFH1S6kDHqj+HaGRY8U
         d0mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=W5iNTiM9hIxjQ/uS1sHAXW9mhHbH2vJ+laiNVlKvx4A=;
        b=NSCoEILMqW5/KK34AQRsWXs316jQ1QpvUiDcKJO2NrRgkx4uDi2N/9ex275UytSZIS
         19bQZAIi/6mttS+h7UgKu47HjrRCYR1L94JREsmBsxtNOzpIKCqDIeaBrjwV04oOhAkW
         kQOrepykBIMq6+tbkFjszWauh7l+1cdE64B1bzK+XAVcgmsXdGijcuH5EYmk1TwIwSwG
         zA3TgCw7zQlWqf5KuZ39vwsiFtWHjaEGC+1+0Dl+t512n2dcISS9iJVYMNN/EVgW0Fwz
         lPTiHJiazQJnDDtr3G6w1N0id5JP1Zb6S3EanpSIQTxeNSFfZH9QX7eHGIWthdBFKotO
         2qdw==
X-Gm-Message-State: APjAAAUrTipBF9xQQUiTlyouho7W00ZyuarVwEYuh+cs4K4G5p9wPEw7
        yi/XzRCMh9ERw4I3VPmxj/fpKXJu
X-Google-Smtp-Source: APXvYqySWGC59LHq4p4IsLXdbwQzK1vDhc6Zjm6MyXbdr9T3akUL0ml5N5/OoXG4w05kMWR12LVfzA==
X-Received: by 2002:a63:31cf:: with SMTP id x198mr52520319pgx.272.1579400718940;
        Sat, 18 Jan 2020 18:25:18 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d4sm11765514pjz.12.2020.01.18.18.25.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Jan 2020 18:25:17 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     gerlitz.or@gmail.com, roid@mellanox.com, saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2] net/mlx5e: Don't allow forwarding between uplink
Date:   Sun, 19 Jan 2020 10:25:05 +0800
Message-Id: <1579400705-22118-1-git-send-email-xiangxia.m.yue@gmail.com>
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
	Sent 408954 bytes 4173 pkt (dropped 0, overlimits 0 requeues 0)
	Sent hardware 408954 bytes 4173 pkt
	...

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2: don't break LAG case
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 23 ++++++++++++++++++++---
 3 files changed, 26 insertions(+), 3 deletions(-)

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
index db614bd..28f4522 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3242,6 +3242,10 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev)
 {
+	if (mlx5e_eswitch_uplink_rep(priv->netdev) &&
+	    mlx5e_eswitch_uplink_rep(out_dev))
+		return false;
+
 	if (is_merged_eswitch_dev(priv, out_dev))
 		return true;
 
@@ -3361,6 +3365,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 				struct net_device *uplink_upper;
+				struct mlx5e_rep_priv *rep_priv;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -3396,10 +3401,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 						return err;
 				}
 
-				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
+				/* Input vport was stored esw_attr->in_rep.
+				 * In LAG case, *priv* is the private data of
+				 * uplink which may be not the input vport.
+				 * Use the input vport to check forwarding
+				 * validity.
+				 */
+				rep_priv = mlx5e_rep_to_rep_priv(attr->in_rep);
+				if (!mlx5e_is_valid_eswitch_fwd_dev(netdev_priv(rep_priv->netdev),
+								    out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
-							   "devices are not on same switch HW, can't offload forwarding");
-					pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
+							   "devices are both uplink "
+							   "are not on same switch HW, "
+							   "can't offload forwarding");
+					pr_err("devices %s %s are both uplink "
+					       "not on same switch HW, "
+					       "can't offload forwarding\n",
 					       priv->netdev->name, out_dev->name);
 					return -EOPNOTSUPP;
 				}
-- 
1.8.3.1

