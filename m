Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2973E161431
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgBQOI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:08:57 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32926 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728817AbgBQOI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:08:57 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so9245881pgk.0
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 06:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFMUFzEmDIkBA0Pfibz4eQc5zQ2VQF/xXd1GJXK9Czw=;
        b=bMaZeBMPdbSLKqtMoLC+0OYsFp77TM7hMoQ21k7gEbmUfxnCE3Wf0Emcjysr90s9L8
         Zh0NyiXyxVK22EEr1ehOQ0m5kZzEDUhX21l/VJiFdP3aKRW3Ap+eSFbThSyZuGIX8h0r
         JljBEdDD4AK/iA8FNxJ2k4IQpKxw4o/LW87C7CMjveF6bR4cPH1WnjLWrmOBfdQ3NhkO
         u1EVP2HW/zaiTGv7jwbPeeEvxaKLC0fjtX6ErG3c2HkDDreNmTwt9RGhMfyIxjGJ1ClI
         Wv07q+xmFSuK1Oh+9QJlqZgMuq1m/y+GFFNbvd8H0iec4ZzW2LusSIPJ9j0erTDK5ZmK
         /vMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PFMUFzEmDIkBA0Pfibz4eQc5zQ2VQF/xXd1GJXK9Czw=;
        b=t3wX/ZiVsQ/sAnayfd+7eovy6X/JdGW+tdYe77p+b9K5YtZqDAJoleMsPXSTYg4DO5
         qUutcS/7lERp+293o4pDHGW0xRYNwg26d9Ho2D1GFKHQ4JA9LT/Wh3smlMBm5EXRWc3C
         BUfBKwEr7BGoL897U36k8e6D2j4fJ8J5Tuu0vVTwTEZ72UTgZy9jEFJyPn9Wy9Sd7bag
         3VDINlr+58vcZ4EP+JWTSY40u32S7IZZYGF3z0D4PNoxW7KkCzUFZ2cwS+sl/goHQ5db
         ZmI/7RsB/mnkdplFGGvTbJQ47XcIR2Bx3pgtPwEq/MBH+mS/nZU5DkqCtTdg1cVY1slJ
         iKmA==
X-Gm-Message-State: APjAAAU6n9BA+Ep2e5cjJUlTp9FoiO5xFwzC2F8AuPSPiJVnxCNsH0C1
        YY2X/K1xHNaVMnfSic8oNq0=
X-Google-Smtp-Source: APXvYqyOGWZazEEUBz2Eo164YTKRKNUEX2pMe3Ffl3jEMwESajKQyFIFib1yzL93LZmAyJMbS82jag==
X-Received: by 2002:a17:90b:4382:: with SMTP id in2mr20339129pjb.29.1581948536380;
        Mon, 17 Feb 2020 06:08:56 -0800 (PST)
Received: from openvirtualnetworks.com.com ([219.142.145.21])
        by smtp.gmail.com with ESMTPSA id v25sm615318pfe.147.2020.02.17.06.08.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 06:08:55 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     gerlitz.or@gmail.com, roid@mellanox.com, saeedm@dev.mellanox.co.il
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4] net/mlx5e: Don't allow forwarding between uplink
Date:   Mon, 17 Feb 2020 22:08:50 +0800
Message-Id: <20200217140850.4509-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 17 +++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 7b48cca..18d3dcd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1464,6 +1464,11 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
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
index 3f756d5..8336301 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -200,6 +200,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
 bool mlx5e_eswitch_rep(struct net_device *netdev);
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 
 #else /* CONFIG_MLX5_ESWITCH */
 static inline bool mlx5e_is_uplink_rep(struct mlx5e_priv *priv) { return false; }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74091f7..290cdf3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3405,6 +3405,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 				struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev = mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
 				struct net_device *uplink_upper;
+				struct mlx5e_rep_priv *rep_priv;
 
 				if (is_duplicated_output_device(priv->netdev,
 								out_dev,
@@ -3440,6 +3441,22 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
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
+							   "devices are both uplink, can't offload forwarding");
+					pr_err("devices %s %s are both uplink, can't offload forwarding\n",
+					       priv->netdev->name, out_dev->name);
+					return -EOPNOTSUPP;
+				}
+
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
 							   "devices are not on same switch HW, can't offload forwarding");
-- 
1.8.3.1

