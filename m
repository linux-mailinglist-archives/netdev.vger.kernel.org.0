Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0A531322F6
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 10:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgAGJw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 04:52:29 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38860 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgAGJw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 04:52:29 -0500
Received: by mail-pl1-f196.google.com with SMTP id f20so23009256plj.5
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 01:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m3PgK4HKQOddbe5g+ftaKu4YlbgUCXu3snD/ue+T49Q=;
        b=C4sb0qN/AwUCy9soTmwWR5/hjLLy9+j0XvSeVgfZQZjp8d9OrYQ1lITM2Ya2uL49yl
         3lTLz+sq6/qHwCixcfs/HoSgQ0Z/P+kYu/N2r4xReq2p/chRjzOuPRyh/1xPOpH3RU2t
         mWNsgeM6EDRNsPWBdSGVuaVH6MuKV7SW5+/h54ZwK5QK2+RcV0n+KZBFs/R3AmBwDXjs
         vodhYRd4fGv5j0UFEBgucHb95RvhwVMl4AJVmOPiEoI4tmKtqasxrxl34Wlkij2IQki0
         cF9VO8vn11W4KN6GqucZDn/OL+trbs13jifL+oP1fq8YzsIH/SZeOSWz7lFTKGzq9RMF
         hvBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m3PgK4HKQOddbe5g+ftaKu4YlbgUCXu3snD/ue+T49Q=;
        b=cJklcpQsaLNGQwiAYRUMWQS5V5SspqCWaFjandJd4flgiJPJ7CAQBXFHDwrm4kXMQX
         RerhmT8Sgb7qqOJIUxQaMeY+kYBKwAHwDf0SfxQzG8A20R/oRddWJsIbnsYuITpZlDEf
         ptzAnhcFH+jw/135qTjlBHbNUOMEDf1GYJeHHLMyrYW2gxgtmRF4L1fthHVOYxTZgSmh
         iLWW5xGBJvyvr6T7VkZ+IB9cqB0T+F9CONupMrnB29JGdWz6MePlIZxO8fq3tj4ItYMt
         CvbJMYhYucAONk+fQwa+yz5MlcvHxvWeDHlPyvuFmnAWXy2vvbMpA9bDYbXpomY0u53h
         a6Kg==
X-Gm-Message-State: APjAAAWGBp/evYU6V0wG0IJFiQrr7BmUOF/GbWaJuBm1FH79dSrYqb/j
        ZgdwCDn0g3Sx2d56Wel9MMiQZS9z
X-Google-Smtp-Source: APXvYqyk82req1Z12kwiFgxStvn3nmaPnYBCHTF4eD436mdItPwxYnSeE+YRu4oJ9yynwqQONzw3Bg==
X-Received: by 2002:a17:902:5995:: with SMTP id p21mr70212133pli.33.1578390748280;
        Tue, 07 Jan 2020 01:52:28 -0800 (PST)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id y20sm16648893pfe.107.2020.01.07.01.52.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jan 2020 01:52:27 -0800 (PST)
From:   xiangxia.m.yue@gmail.com
To:     gerlitz.or@gmail.com, saeedm@dev.mellanox.co.il, roid@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] net/mlx5e: Don't allow forwarding between uplink
Date:   Tue,  7 Jan 2020 17:52:18 +0800
Message-Id: <1578390738-30712-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

We can install forwarding packets rule between uplink
in eswitchdev mode, as show below. But the hardware does
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
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h |  1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c  | 16 +++++++++++++---
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb2..63fad66 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1434,10 +1434,15 @@ static struct devlink_port *mlx5e_get_devlink_port(struct net_device *dev)
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
-	    netdev->netdev_ops == &mlx5e_netdev_ops_uplink_rep)
+	    mlx5e_eswitch_uplink_rep(netdev))
 		return true;
 
 	return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 31f83c8..282c64b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -198,6 +198,7 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 
 void mlx5e_rep_queue_neigh_stats_work(struct mlx5e_priv *priv);
 
+bool mlx5e_eswitch_uplink_rep(struct net_device *netdev);
 bool mlx5e_eswitch_rep(struct net_device *netdev);
 
 #else /* CONFIG_MLX5_ESWITCH */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f91e057e..b2c18fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3214,6 +3214,10 @@ static int add_vlan_pop_action(struct mlx5e_priv *priv,
 bool mlx5e_is_valid_eswitch_fwd_dev(struct mlx5e_priv *priv,
 				    struct net_device *out_dev)
 {
+	if (mlx5e_eswitch_uplink_rep(priv->netdev) &&
+	    mlx5e_eswitch_uplink_rep(out_dev))
+		return false;
+
 	if (is_merged_eswitch_dev(priv, out_dev))
 		return true;
 
@@ -3339,9 +3343,15 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 
 				if (!mlx5e_is_valid_eswitch_fwd_dev(priv, out_dev)) {
 					NL_SET_ERR_MSG_MOD(extack,
-							   "devices are not on same switch HW, can't offload forwarding");
-					pr_err("devices %s %s not on same switch HW, can't offload forwarding\n",
-					       priv->netdev->name, out_dev->name);
+							   "devices are both uplink "
+							   "or not on same switch HW, "
+							   "can't offload forwarding");
+					pr_err("devices %s %s are both uplink "
+					       "or not on same switch HW, "
+					       "can't offload forwarding\n",
+					       priv->netdev->name,
+					       out_dev->name);
+
 					return -EOPNOTSUPP;
 				}
 
-- 
1.8.3.1

