Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D1627901E
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729726AbgIYSNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYSNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:13:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2164C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:20 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u3so2129292pjr.3
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:13:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5y5k2iJW7etser7l+i+ZMrDbJ/plifZq1iRNQeUn82U=;
        b=BbLAE8I4CCaW5ep7otyk5rMBMKfwo/pLs9kGIbPWWufZv98qV6w7oSvDQuTebCzXNQ
         sJyuRpraNY5HFR2wD1Lb2+WJxiAEJpAHmpVXWOeN0wLjb2o+ePk15lbr+AWEZZ84Wtxp
         bJQW5VdrAzHuMToaIaXR2HuxhABmmEiqpaGuI1wq/hfXZcNBgMybjz/Y3WoHBM8VqAUk
         ustlkTcxepoCdxFvwG19TgQPPJh+QCZMrhg7qXf1Ncfys8SggWx2aj8Vv/Hqt+exAf6L
         4lchfBBZUXMcFbMpe2nDB4I91yecJeE8X/RUwrqxwo5jUIBuU9p6tGUZ67738bOn/Os0
         93Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5y5k2iJW7etser7l+i+ZMrDbJ/plifZq1iRNQeUn82U=;
        b=YeQlexpBjqs+n0H4kSCq5F5+0hTc2Yn5at7otBWpqp+yqEHyQh8wnwgAJMlEzIEB6W
         iwMWhz9Fipw8OQfhvc+078SlnDH0UhxgxMadRoGB40diIix9aetmJs6GF+nz27S/saij
         ZBQPJMQxVN7R9SUUks+prE1rHLLkD5JVm1+6qCR9gKsUyFDCWFhTV26jGOMx3TeFH8aA
         dvATL4jWN0CKsRwftKFJFir7tCq6qjKSJ+0mcv4NBtvVSq2wdleMLAe86KdQ3elxo5j7
         /IeSlTYnmi5EBdxZYCUjqHKo3Y4E+7ZEMu2WD5esJPojTBKJ2aj1StpF7bKc/sD/ZVGI
         IxLg==
X-Gm-Message-State: AOAM533BrUEWwKSucnCI4TaANBaPDHFeG94rYQKAm1LSGVSQ2J+8iAQx
        TkrTx77f9LoPk7Q9QIz6aFc=
X-Google-Smtp-Source: ABdhPJx/zJyb8y3f5FhqbDBTBheqtI3ffSh78RXA1vwgsYphpi8RM1hJSoYRtC2HMhvaFMhn74CxAg==
X-Received: by 2002:a17:90a:e609:: with SMTP id j9mr688000pjy.129.1601057600160;
        Fri, 25 Sep 2020 11:13:20 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id v128sm3079579pgv.72.2020.09.25.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:13:19 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xiyou.wangcong@gmail.com
Subject: [PATCH net 2/3] net: core: introduce struct netdev_nested_priv for nested interface infrastructure
Date:   Fri, 25 Sep 2020 18:13:12 +0000
Message-Id: <20200925181313.25201-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functions related to nested interface infrastructure such as
netdev_walk_all_{ upper | lower }_dev() pass both private functions
and "data" pointer to handle their own things.
At this point, the data pointer type is void *.
In order to make it easier to expand common variables and functions,
this new netdev_nested_priv structure is added.

In the following patch, a new member variable will be added into this
struct to fix the lockdep issue.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/infiniband/core/cache.c               | 10 +++-
 drivers/infiniband/core/cma.c                 |  9 ++-
 drivers/infiniband/core/roce_gid_mgmt.c       |  9 ++-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  9 ++-
 drivers/net/bonding/bond_alb.c                |  9 ++-
 drivers/net/bonding/bond_main.c               | 10 +++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 37 ++++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 24 ++++----
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 11 +++-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 10 +++-
 drivers/net/ethernet/rocker/rocker_main.c     |  9 ++-
 drivers/net/wireless/quantenna/qtnfmac/core.c | 10 +++-
 include/linux/netdevice.h                     | 16 +++--
 net/bridge/br_arp_nd_proxy.c                  | 26 +++++---
 net/bridge/br_vlan.c                          | 20 ++++---
 net/core/dev.c                                | 59 ++++++++++++-------
 16 files changed, 183 insertions(+), 95 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index ffad73bb40ff..5a76611e684a 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1320,9 +1320,10 @@ struct net_device *rdma_read_gid_attr_ndev_rcu(const struct ib_gid_attr *attr)
 }
 EXPORT_SYMBOL(rdma_read_gid_attr_ndev_rcu);
 
-static int get_lower_dev_vlan(struct net_device *lower_dev, void *data)
+static int get_lower_dev_vlan(struct net_device *lower_dev,
+			      struct netdev_nested_priv *priv)
 {
-	u16 *vlan_id = data;
+	u16 *vlan_id = (u16 *)priv->data;
 
 	if (is_vlan_dev(lower_dev))
 		*vlan_id = vlan_dev_vlan_id(lower_dev);
@@ -1348,6 +1349,9 @@ static int get_lower_dev_vlan(struct net_device *lower_dev, void *data)
 int rdma_read_gid_l2_fields(const struct ib_gid_attr *attr,
 			    u16 *vlan_id, u8 *smac)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)vlan_id,
+	};
 	struct net_device *ndev;
 
 	rcu_read_lock();
@@ -1368,7 +1372,7 @@ int rdma_read_gid_l2_fields(const struct ib_gid_attr *attr,
 			 * the lower vlan device for this gid entry.
 			 */
 			netdev_walk_all_lower_dev_rcu(attr->ndev,
-					get_lower_dev_vlan, vlan_id);
+					get_lower_dev_vlan, &priv);
 		}
 	}
 	rcu_read_unlock();
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7f0e91e92968..5888311b2119 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2865,9 +2865,10 @@ struct iboe_prio_tc_map {
 	bool found;
 };
 
-static int get_lower_vlan_dev_tc(struct net_device *dev, void *data)
+static int get_lower_vlan_dev_tc(struct net_device *dev,
+				 struct netdev_nested_priv *priv)
 {
-	struct iboe_prio_tc_map *map = data;
+	struct iboe_prio_tc_map *map = (struct iboe_prio_tc_map *)priv->data;
 
 	if (is_vlan_dev(dev))
 		map->output_tc = get_vlan_ndev_tc(dev, map->input_prio);
@@ -2886,16 +2887,18 @@ static int iboe_tos_to_sl(struct net_device *ndev, int tos)
 {
 	struct iboe_prio_tc_map prio_tc_map = {};
 	int prio = rt_tos2priority(tos);
+	struct netdev_nested_priv priv;
 
 	/* If VLAN device, get it directly from the VLAN netdev */
 	if (is_vlan_dev(ndev))
 		return get_vlan_ndev_tc(ndev, prio);
 
 	prio_tc_map.input_prio = prio;
+	priv.data = (void *)&prio_tc_map;
 	rcu_read_lock();
 	netdev_walk_all_lower_dev_rcu(ndev,
 				      get_lower_vlan_dev_tc,
-				      &prio_tc_map);
+				      &priv);
 	rcu_read_unlock();
 	/* If map is found from lower device, use it; Otherwise
 	 * continue with the current netdevice to get priority to tc map.
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index 2860def84f4d..6b8364bb032d 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -531,10 +531,11 @@ struct upper_list {
 	struct net_device *upper;
 };
 
-static int netdev_upper_walk(struct net_device *upper, void *data)
+static int netdev_upper_walk(struct net_device *upper,
+			     struct netdev_nested_priv *priv)
 {
 	struct upper_list *entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
-	struct list_head *upper_list = data;
+	struct list_head *upper_list = (struct list_head *)priv->data;
 
 	if (!entry)
 		return 0;
@@ -553,12 +554,14 @@ static void handle_netdev_upper(struct ib_device *ib_dev, u8 port,
 						      struct net_device *ndev))
 {
 	struct net_device *ndev = cookie;
+	struct netdev_nested_priv priv;
 	struct upper_list *upper_iter;
 	struct upper_list *upper_temp;
 	LIST_HEAD(upper_list);
 
+	priv.data = &upper_list;
 	rcu_read_lock();
-	netdev_walk_all_upper_dev_rcu(ndev, netdev_upper_walk, &upper_list);
+	netdev_walk_all_upper_dev_rcu(ndev, netdev_upper_walk, &priv);
 	rcu_read_unlock();
 
 	handle_netdev(ib_dev, port, ndev);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index ab75b7f745d4..f772fe8c5b66 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -342,9 +342,10 @@ struct ipoib_walk_data {
 	struct net_device *result;
 };
 
-static int ipoib_upper_walk(struct net_device *upper, void *_data)
+static int ipoib_upper_walk(struct net_device *upper,
+			    struct netdev_nested_priv *priv)
 {
-	struct ipoib_walk_data *data = _data;
+	struct ipoib_walk_data *data = (struct ipoib_walk_data *)priv->data;
 	int ret = 0;
 
 	if (ipoib_is_dev_match_addr_rcu(data->addr, upper)) {
@@ -368,10 +369,12 @@ static int ipoib_upper_walk(struct net_device *upper, void *_data)
 static struct net_device *ipoib_get_net_dev_match_addr(
 		const struct sockaddr *addr, struct net_device *dev)
 {
+	struct netdev_nested_priv priv;
 	struct ipoib_walk_data data = {
 		.addr = addr,
 	};
 
+	priv.data = (void *)&data;
 	rcu_read_lock();
 	if (ipoib_is_dev_match_addr_rcu(addr, dev)) {
 		dev_hold(dev);
@@ -379,7 +382,7 @@ static struct net_device *ipoib_get_net_dev_match_addr(
 		goto out;
 	}
 
-	netdev_walk_all_upper_dev_rcu(dev, ipoib_upper_walk, &data);
+	netdev_walk_all_upper_dev_rcu(dev, ipoib_upper_walk, &priv);
 out:
 	rcu_read_unlock();
 	return data.result;
diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 4e1b7deb724b..c3091e00dd5f 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -942,9 +942,10 @@ struct alb_walk_data {
 	bool strict_match;
 };
 
-static int alb_upper_dev_walk(struct net_device *upper, void *_data)
+static int alb_upper_dev_walk(struct net_device *upper,
+			      struct netdev_nested_priv *priv)
 {
-	struct alb_walk_data *data = _data;
+	struct alb_walk_data *data = (struct alb_walk_data *)priv->data;
 	bool strict_match = data->strict_match;
 	struct bonding *bond = data->bond;
 	struct slave *slave = data->slave;
@@ -983,6 +984,7 @@ static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 				      bool strict_match)
 {
 	struct bonding *bond = bond_get_bond_by_slave(slave);
+	struct netdev_nested_priv priv;
 	struct alb_walk_data data = {
 		.strict_match = strict_match,
 		.mac_addr = mac_addr,
@@ -990,6 +992,7 @@ static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 		.bond = bond,
 	};
 
+	priv.data = (void *)&data;
 	/* send untagged */
 	alb_send_lp_vid(slave, mac_addr, 0, 0);
 
@@ -997,7 +1000,7 @@ static void alb_send_learning_packets(struct slave *slave, u8 mac_addr[],
 	 * for that device.
 	 */
 	rcu_read_lock();
-	netdev_walk_all_upper_dev_rcu(bond->dev, alb_upper_dev_walk, &data);
+	netdev_walk_all_upper_dev_rcu(bond->dev, alb_upper_dev_walk, &priv);
 	rcu_read_unlock();
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 42ef25ec0af5..d1c94cdeb8d7 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2510,22 +2510,26 @@ static void bond_mii_monitor(struct work_struct *work)
 	}
 }
 
-static int bond_upper_dev_walk(struct net_device *upper, void *data)
+static int bond_upper_dev_walk(struct net_device *upper,
+			       struct netdev_nested_priv *priv)
 {
-	__be32 ip = *((__be32 *)data);
+	__be32 ip = *(__be32 *)priv->data;
 
 	return ip == bond_confirm_addr(upper, 0, ip);
 }
 
 static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)&ip,
+	};
 	bool ret = false;
 
 	if (ip == bond_confirm_addr(bond->dev, 0, ip))
 		return true;
 
 	rcu_read_lock();
-	if (netdev_walk_all_upper_dev_rcu(bond->dev, bond_upper_dev_walk, &ip))
+	if (netdev_walk_all_upper_dev_rcu(bond->dev, bond_upper_dev_walk, &priv))
 		ret = true;
 	rcu_read_unlock();
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cfc5fa1..86ca8b9ea1b8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5396,9 +5396,10 @@ static int ixgbe_fwd_ring_up(struct ixgbe_adapter *adapter,
 	return err;
 }
 
-static int ixgbe_macvlan_up(struct net_device *vdev, void *data)
+static int ixgbe_macvlan_up(struct net_device *vdev,
+			    struct netdev_nested_priv *priv)
 {
-	struct ixgbe_adapter *adapter = data;
+	struct ixgbe_adapter *adapter = (struct ixgbe_adapter *)priv->data;
 	struct ixgbe_fwd_adapter *accel;
 
 	if (!netif_is_macvlan(vdev))
@@ -5415,8 +5416,12 @@ static int ixgbe_macvlan_up(struct net_device *vdev, void *data)
 
 static void ixgbe_configure_dfwd(struct ixgbe_adapter *adapter)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)adapter,
+	};
+
 	netdev_walk_all_upper_dev_rcu(adapter->netdev,
-				      ixgbe_macvlan_up, adapter);
+				      ixgbe_macvlan_up, &priv);
 }
 
 static void ixgbe_configure(struct ixgbe_adapter *adapter)
@@ -9023,9 +9028,10 @@ static void ixgbe_set_prio_tc_map(struct ixgbe_adapter *adapter)
 }
 
 #endif /* CONFIG_IXGBE_DCB */
-static int ixgbe_reassign_macvlan_pool(struct net_device *vdev, void *data)
+static int ixgbe_reassign_macvlan_pool(struct net_device *vdev,
+				       struct netdev_nested_priv *priv)
 {
-	struct ixgbe_adapter *adapter = data;
+	struct ixgbe_adapter *adapter = (struct ixgbe_adapter *)priv->data;
 	struct ixgbe_fwd_adapter *accel;
 	int pool;
 
@@ -9062,13 +9068,16 @@ static int ixgbe_reassign_macvlan_pool(struct net_device *vdev, void *data)
 static void ixgbe_defrag_macvlan_pools(struct net_device *dev)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
+	struct netdev_nested_priv priv = {
+		.data = (void *)adapter,
+	};
 
 	/* flush any stale bits out of the fwd bitmask */
 	bitmap_clear(adapter->fwd_bitmask, 1, 63);
 
 	/* walk through upper devices reassigning pools */
 	netdev_walk_all_upper_dev_rcu(dev, ixgbe_reassign_macvlan_pool,
-				      adapter);
+				      &priv);
 }
 
 /**
@@ -9242,14 +9251,18 @@ struct upper_walk_data {
 	u8 queue;
 };
 
-static int get_macvlan_queue(struct net_device *upper, void *_data)
+static int get_macvlan_queue(struct net_device *upper,
+			     struct netdev_nested_priv *priv)
 {
 	if (netif_is_macvlan(upper)) {
 		struct ixgbe_fwd_adapter *vadapter = macvlan_accel_priv(upper);
-		struct upper_walk_data *data = _data;
-		struct ixgbe_adapter *adapter = data->adapter;
-		int ifindex = data->ifindex;
+		struct ixgbe_adapter *adapter;
+		struct upper_walk_data *data;
+		int ifindex;
 
+		data = (struct upper_walk_data *)priv->data;
+		ifindex = data->ifindex;
+		adapter = data->adapter;
 		if (vadapter && upper->ifindex == ifindex) {
 			data->queue = adapter->rx_ring[vadapter->rx_base_queue]->reg_idx;
 			data->action = data->queue;
@@ -9265,6 +9278,7 @@ static int handle_redirect_action(struct ixgbe_adapter *adapter, int ifindex,
 {
 	struct ixgbe_ring_feature *vmdq = &adapter->ring_feature[RING_F_VMDQ];
 	unsigned int num_vfs = adapter->num_vfs, vf;
+	struct netdev_nested_priv priv;
 	struct upper_walk_data data;
 	struct net_device *upper;
 
@@ -9284,8 +9298,9 @@ static int handle_redirect_action(struct ixgbe_adapter *adapter, int ifindex,
 	data.ifindex = ifindex;
 	data.action = 0;
 	data.queue = 0;
+	priv.data = (void *)&data;
 	if (netdev_walk_all_upper_dev_rcu(adapter->netdev,
-					  get_macvlan_queue, &data)) {
+					  get_macvlan_queue, &priv)) {
 		*action = data.action;
 		*queue = data.queue;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 4186e29119c2..f3c0e241e1b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3690,13 +3690,13 @@ bool mlxsw_sp_port_dev_check(const struct net_device *dev)
 	return dev->netdev_ops == &mlxsw_sp_port_netdev_ops;
 }
 
-static int mlxsw_sp_lower_dev_walk(struct net_device *lower_dev, void *data)
+static int mlxsw_sp_lower_dev_walk(struct net_device *lower_dev,
+				   struct netdev_nested_priv *priv)
 {
-	struct mlxsw_sp_port **p_mlxsw_sp_port = data;
 	int ret = 0;
 
 	if (mlxsw_sp_port_dev_check(lower_dev)) {
-		*p_mlxsw_sp_port = netdev_priv(lower_dev);
+		priv->data = (void *)netdev_priv(lower_dev);
 		ret = 1;
 	}
 
@@ -3705,15 +3705,16 @@ static int mlxsw_sp_lower_dev_walk(struct net_device *lower_dev, void *data)
 
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev)
 {
-	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct netdev_nested_priv priv = {
+		.data = NULL,
+	};
 
 	if (mlxsw_sp_port_dev_check(dev))
 		return netdev_priv(dev);
 
-	mlxsw_sp_port = NULL;
-	netdev_walk_all_lower_dev(dev, mlxsw_sp_lower_dev_walk, &mlxsw_sp_port);
+	netdev_walk_all_lower_dev(dev, mlxsw_sp_lower_dev_walk, &priv);
 
-	return mlxsw_sp_port;
+	return (struct mlxsw_sp_port *)priv.data;
 }
 
 struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev)
@@ -3726,16 +3727,17 @@ struct mlxsw_sp *mlxsw_sp_lower_get(struct net_device *dev)
 
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find_rcu(struct net_device *dev)
 {
-	struct mlxsw_sp_port *mlxsw_sp_port;
+	struct netdev_nested_priv priv = {
+		.data = NULL,
+	};
 
 	if (mlxsw_sp_port_dev_check(dev))
 		return netdev_priv(dev);
 
-	mlxsw_sp_port = NULL;
 	netdev_walk_all_lower_dev_rcu(dev, mlxsw_sp_lower_dev_walk,
-				      &mlxsw_sp_port);
+				      &priv);
 
-	return mlxsw_sp_port;
+	return (struct mlxsw_sp_port *)priv.data;
 }
 
 struct mlxsw_sp_port *mlxsw_sp_port_lower_dev_hold(struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 24f1fd1f8d56..460cb523312f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7351,9 +7351,10 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 	return err;
 }
 
-static int __mlxsw_sp_rif_macvlan_flush(struct net_device *dev, void *data)
+static int __mlxsw_sp_rif_macvlan_flush(struct net_device *dev,
+					struct netdev_nested_priv *priv)
 {
-	struct mlxsw_sp_rif *rif = data;
+	struct mlxsw_sp_rif *rif = (struct mlxsw_sp_rif *)priv->data;
 
 	if (!netif_is_macvlan(dev))
 		return 0;
@@ -7364,12 +7365,16 @@ static int __mlxsw_sp_rif_macvlan_flush(struct net_device *dev, void *data)
 
 static int mlxsw_sp_rif_macvlan_flush(struct mlxsw_sp_rif *rif)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)rif,
+	};
+
 	if (!netif_is_macvlan_port(rif->dev))
 		return 0;
 
 	netdev_warn(rif->dev, "Router interface is deleted. Upper macvlans will not work\n");
 	return netdev_walk_all_upper_dev_rcu(rif->dev,
-					     __mlxsw_sp_rif_macvlan_flush, rif);
+					     __mlxsw_sp_rif_macvlan_flush, &priv);
 }
 
 static void mlxsw_sp_rif_subport_setup(struct mlxsw_sp_rif *rif,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 72912afa6f72..6501ce94ace5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -136,9 +136,9 @@ bool mlxsw_sp_bridge_device_is_offloaded(const struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_bridge_device_upper_rif_destroy(struct net_device *dev,
-						    void *data)
+						    struct netdev_nested_priv *priv)
 {
-	struct mlxsw_sp *mlxsw_sp = data;
+	struct mlxsw_sp *mlxsw_sp = priv->data;
 
 	mlxsw_sp_rif_destroy_by_dev(mlxsw_sp, dev);
 	return 0;
@@ -147,10 +147,14 @@ static int mlxsw_sp_bridge_device_upper_rif_destroy(struct net_device *dev,
 static void mlxsw_sp_bridge_device_rifs_destroy(struct mlxsw_sp *mlxsw_sp,
 						struct net_device *dev)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)mlxsw_sp,
+	};
+
 	mlxsw_sp_rif_destroy_by_dev(mlxsw_sp, dev);
 	netdev_walk_all_upper_dev_rcu(dev,
 				      mlxsw_sp_bridge_device_upper_rif_destroy,
-				      mlxsw_sp);
+				      &priv);
 }
 
 static int mlxsw_sp_bridge_device_vxlan_init(struct mlxsw_sp_bridge *bridge,
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 42458a46ffaf..9cc31f7e0df1 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -3099,9 +3099,10 @@ struct rocker_walk_data {
 	struct rocker_port *port;
 };
 
-static int rocker_lower_dev_walk(struct net_device *lower_dev, void *_data)
+static int rocker_lower_dev_walk(struct net_device *lower_dev,
+				 struct netdev_nested_priv *priv)
 {
-	struct rocker_walk_data *data = _data;
+	struct rocker_walk_data *data = (struct rocker_walk_data *)priv->data;
 	int ret = 0;
 
 	if (rocker_port_dev_check_under(lower_dev, data->rocker)) {
@@ -3115,6 +3116,7 @@ static int rocker_lower_dev_walk(struct net_device *lower_dev, void *_data)
 struct rocker_port *rocker_port_dev_lower_find(struct net_device *dev,
 					       struct rocker *rocker)
 {
+	struct netdev_nested_priv priv;
 	struct rocker_walk_data data;
 
 	if (rocker_port_dev_check_under(dev, rocker))
@@ -3122,7 +3124,8 @@ struct rocker_port *rocker_port_dev_lower_find(struct net_device *dev,
 
 	data.rocker = rocker;
 	data.port = NULL;
-	netdev_walk_all_lower_dev(dev, rocker_lower_dev_walk, &data);
+	priv.data = (void *)&data;
+	netdev_walk_all_lower_dev(dev, rocker_lower_dev_walk, &priv);
 
 	return data.port;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 6aafff9d4231..e013ebe3079c 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -671,9 +671,10 @@ bool qtnf_netdev_is_qtn(const struct net_device *ndev)
 	return ndev->netdev_ops == &qtnf_netdev_ops;
 }
 
-static int qtnf_check_br_ports(struct net_device *dev, void *data)
+static int qtnf_check_br_ports(struct net_device *dev,
+			       struct netdev_nested_priv *priv)
 {
-	struct net_device *ndev = data;
+	struct net_device *ndev = (struct net_device *)priv->data;
 
 	if (dev != ndev && netdev_port_same_parent_id(dev, ndev))
 		return -ENOTSUPP;
@@ -686,6 +687,9 @@ static int qtnf_core_netdevice_event(struct notifier_block *nb,
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(ptr);
 	const struct netdev_notifier_changeupper_info *info;
+	struct netdev_nested_priv priv = {
+		.data = (void *)ndev,
+	};
 	struct net_device *brdev;
 	struct qtnf_vif *vif;
 	struct qtnf_bus *bus;
@@ -725,7 +729,7 @@ static int qtnf_core_netdevice_event(struct notifier_block *nb,
 		} else {
 			ret = netdev_walk_all_lower_dev(brdev,
 							qtnf_check_br_ports,
-							ndev);
+							&priv);
 		}
 
 		break;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7bd4fcdd0738..313803d6c781 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4455,6 +4455,10 @@ extern int		dev_rx_weight;
 extern int		dev_tx_weight;
 extern int		gro_normal_batch;
 
+struct netdev_nested_priv {
+	void *data;
+};
+
 bool netdev_has_upper_dev(struct net_device *dev, struct net_device *upper_dev);
 struct net_device *netdev_upper_get_next_dev_rcu(struct net_device *dev,
 						     struct list_head **iter);
@@ -4470,8 +4474,8 @@ struct net_device *netdev_all_upper_get_next_dev_rcu(struct net_device *dev,
 
 int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *upper_dev,
-					    void *data),
-				  void *data);
+					    struct netdev_nested_priv *priv),
+				  struct netdev_nested_priv *priv);
 
 bool netdev_has_upper_dev_all_rcu(struct net_device *dev,
 				  struct net_device *upper_dev);
@@ -4508,12 +4512,12 @@ struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 					     struct list_head **iter);
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
-					void *data),
-			      void *data);
+					struct netdev_nested_priv *priv),
+			      struct netdev_nested_priv *priv);
 int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *lower_dev,
-					    void *data),
-				  void *data);
+					    struct netdev_nested_priv *priv),
+				  struct netdev_nested_priv *priv);
 
 void *netdev_adjacent_get_private(struct list_head *adj_list);
 void *netdev_lower_get_first_private_rcu(struct net_device *dev);
diff --git a/net/bridge/br_arp_nd_proxy.c b/net/bridge/br_arp_nd_proxy.c
index b18cdf03edb3..dfec65eca8a6 100644
--- a/net/bridge/br_arp_nd_proxy.c
+++ b/net/bridge/br_arp_nd_proxy.c
@@ -88,9 +88,10 @@ static void br_arp_send(struct net_bridge *br, struct net_bridge_port *p,
 	}
 }
 
-static int br_chk_addr_ip(struct net_device *dev, void *data)
+static int br_chk_addr_ip(struct net_device *dev,
+			  struct netdev_nested_priv *priv)
 {
-	__be32 ip = *(__be32 *)data;
+	__be32 ip = *(__be32 *)priv->data;
 	struct in_device *in_dev;
 	__be32 addr = 0;
 
@@ -107,11 +108,15 @@ static int br_chk_addr_ip(struct net_device *dev, void *data)
 
 static bool br_is_local_ip(struct net_device *dev, __be32 ip)
 {
-	if (br_chk_addr_ip(dev, &ip))
+	struct netdev_nested_priv priv = {
+		.data = (void *)&ip,
+	};
+
+	if (br_chk_addr_ip(dev, &priv))
 		return true;
 
 	/* check if ip is configured on upper dev */
-	if (netdev_walk_all_upper_dev_rcu(dev, br_chk_addr_ip, &ip))
+	if (netdev_walk_all_upper_dev_rcu(dev, br_chk_addr_ip, &priv))
 		return true;
 
 	return false;
@@ -361,9 +366,10 @@ static void br_nd_send(struct net_bridge *br, struct net_bridge_port *p,
 	}
 }
 
-static int br_chk_addr_ip6(struct net_device *dev, void *data)
+static int br_chk_addr_ip6(struct net_device *dev,
+			   struct netdev_nested_priv *priv)
 {
-	struct in6_addr *addr = (struct in6_addr *)data;
+	struct in6_addr *addr = (struct in6_addr *)priv->data;
 
 	if (ipv6_chk_addr(dev_net(dev), addr, dev, 0))
 		return 1;
@@ -374,11 +380,15 @@ static int br_chk_addr_ip6(struct net_device *dev, void *data)
 static bool br_is_local_ip6(struct net_device *dev, struct in6_addr *addr)
 
 {
-	if (br_chk_addr_ip6(dev, addr))
+	struct netdev_nested_priv priv = {
+		.data = (void *)addr,
+	};
+
+	if (br_chk_addr_ip6(dev, &priv))
 		return true;
 
 	/* check if ip is configured on upper dev */
-	if (netdev_walk_all_upper_dev_rcu(dev, br_chk_addr_ip6, addr))
+	if (netdev_walk_all_upper_dev_rcu(dev, br_chk_addr_ip6, &priv))
 		return true;
 
 	return false;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 61c94cefa843..ee8780080be5 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1360,7 +1360,7 @@ static int br_vlan_is_bind_vlan_dev(const struct net_device *dev)
 }
 
 static int br_vlan_is_bind_vlan_dev_fn(struct net_device *dev,
-				       __always_unused void *data)
+			       __always_unused struct netdev_nested_priv *priv)
 {
 	return br_vlan_is_bind_vlan_dev(dev);
 }
@@ -1383,9 +1383,9 @@ struct br_vlan_bind_walk_data {
 };
 
 static int br_vlan_match_bind_vlan_dev_fn(struct net_device *dev,
-					  void *data_in)
+					  struct netdev_nested_priv *priv)
 {
-	struct br_vlan_bind_walk_data *data = data_in;
+	struct br_vlan_bind_walk_data *data = priv->data;
 	int found = 0;
 
 	if (br_vlan_is_bind_vlan_dev(dev) &&
@@ -1403,10 +1403,13 @@ br_vlan_get_upper_bind_vlan_dev(struct net_device *dev, u16 vid)
 	struct br_vlan_bind_walk_data data = {
 		.vid = vid,
 	};
+	struct netdev_nested_priv priv = {
+		.data = (void *)&data,
+	};
 
 	rcu_read_lock();
 	netdev_walk_all_upper_dev_rcu(dev, br_vlan_match_bind_vlan_dev_fn,
-				      &data);
+				      &priv);
 	rcu_read_unlock();
 
 	return data.result;
@@ -1487,9 +1490,9 @@ struct br_vlan_link_state_walk_data {
 };
 
 static int br_vlan_link_state_change_fn(struct net_device *vlan_dev,
-					void *data_in)
+					struct netdev_nested_priv *priv)
 {
-	struct br_vlan_link_state_walk_data *data = data_in;
+	struct br_vlan_link_state_walk_data *data = priv->data;
 
 	if (br_vlan_is_bind_vlan_dev(vlan_dev))
 		br_vlan_set_vlan_dev_state(data->br, vlan_dev);
@@ -1503,10 +1506,13 @@ static void br_vlan_link_state_change(struct net_device *dev,
 	struct br_vlan_link_state_walk_data data = {
 		.br = br
 	};
+	struct netdev_nested_priv priv = {
+		.data = (void *)&data,
+	};
 
 	rcu_read_lock();
 	netdev_walk_all_upper_dev_rcu(dev, br_vlan_link_state_change_fn,
-				      &data);
+				      &priv);
 	rcu_read_unlock();
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index b7b3d6e15cda..a4a1fa806c5c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6812,9 +6812,10 @@ static struct netdev_adjacent *__netdev_find_adj(struct net_device *adj_dev,
 	return NULL;
 }
 
-static int ____netdev_has_upper_dev(struct net_device *upper_dev, void *data)
+static int ____netdev_has_upper_dev(struct net_device *upper_dev,
+				    struct netdev_nested_priv *priv)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = (struct net_device *)priv->data;
 
 	return upper_dev == dev;
 }
@@ -6831,10 +6832,14 @@ static int ____netdev_has_upper_dev(struct net_device *upper_dev, void *data)
 bool netdev_has_upper_dev(struct net_device *dev,
 			  struct net_device *upper_dev)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)upper_dev,
+	};
+
 	ASSERT_RTNL();
 
 	return netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
-					     upper_dev);
+					     &priv);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev);
 
@@ -6851,8 +6856,12 @@ EXPORT_SYMBOL(netdev_has_upper_dev);
 bool netdev_has_upper_dev_all_rcu(struct net_device *dev,
 				  struct net_device *upper_dev)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)upper_dev,
+	};
+
 	return !!netdev_walk_all_upper_dev_rcu(dev, ____netdev_has_upper_dev,
-					       upper_dev);
+					       &priv);
 }
 EXPORT_SYMBOL(netdev_has_upper_dev_all_rcu);
 
@@ -6997,8 +7006,8 @@ static struct net_device *netdev_next_upper_dev_rcu(struct net_device *dev,
 
 static int __netdev_walk_all_upper_dev(struct net_device *dev,
 				       int (*fn)(struct net_device *dev,
-						 void *data),
-				       void *data)
+					 struct netdev_nested_priv *priv),
+				       struct netdev_nested_priv *priv)
 {
 	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
@@ -7010,7 +7019,7 @@ static int __netdev_walk_all_upper_dev(struct net_device *dev,
 
 	while (1) {
 		if (now != dev) {
-			ret = fn(now, data);
+			ret = fn(now, priv);
 			if (ret)
 				return ret;
 		}
@@ -7046,8 +7055,8 @@ static int __netdev_walk_all_upper_dev(struct net_device *dev,
 
 int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
-					    void *data),
-				  void *data)
+					    struct netdev_nested_priv *priv),
+				  struct netdev_nested_priv *priv)
 {
 	struct net_device *udev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
@@ -7058,7 +7067,7 @@ int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
 
 	while (1) {
 		if (now != dev) {
-			ret = fn(now, data);
+			ret = fn(now, priv);
 			if (ret)
 				return ret;
 		}
@@ -7094,10 +7103,14 @@ EXPORT_SYMBOL_GPL(netdev_walk_all_upper_dev_rcu);
 static bool __netdev_has_upper_dev(struct net_device *dev,
 				   struct net_device *upper_dev)
 {
+	struct netdev_nested_priv priv = {
+		.data = (void *)upper_dev,
+	};
+
 	ASSERT_RTNL();
 
 	return __netdev_walk_all_upper_dev(dev, ____netdev_has_upper_dev,
-					   upper_dev);
+					   &priv);
 }
 
 /**
@@ -7215,8 +7228,8 @@ static struct net_device *__netdev_next_lower_dev(struct net_device *dev,
 
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *dev,
-					void *data),
-			      void *data)
+					struct netdev_nested_priv *priv),
+			      struct netdev_nested_priv *priv)
 {
 	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
@@ -7227,7 +7240,7 @@ int netdev_walk_all_lower_dev(struct net_device *dev,
 
 	while (1) {
 		if (now != dev) {
-			ret = fn(now, data);
+			ret = fn(now, priv);
 			if (ret)
 				return ret;
 		}
@@ -7262,8 +7275,8 @@ EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev);
 
 static int __netdev_walk_all_lower_dev(struct net_device *dev,
 				       int (*fn)(struct net_device *dev,
-						 void *data),
-				       void *data)
+					 struct netdev_nested_priv *priv),
+				       struct netdev_nested_priv *priv)
 {
 	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
@@ -7275,7 +7288,7 @@ static int __netdev_walk_all_lower_dev(struct net_device *dev,
 
 	while (1) {
 		if (now != dev) {
-			ret = fn(now, data);
+			ret = fn(now, priv);
 			if (ret)
 				return ret;
 		}
@@ -7364,13 +7377,15 @@ static u8 __netdev_lower_depth(struct net_device *dev)
 	return max_depth;
 }
 
-static int __netdev_update_upper_level(struct net_device *dev, void *data)
+static int __netdev_update_upper_level(struct net_device *dev,
+				       struct netdev_nested_priv *__unused)
 {
 	dev->upper_level = __netdev_upper_depth(dev) + 1;
 	return 0;
 }
 
-static int __netdev_update_lower_level(struct net_device *dev, void *data)
+static int __netdev_update_lower_level(struct net_device *dev,
+				       struct netdev_nested_priv *__unused)
 {
 	dev->lower_level = __netdev_lower_depth(dev) + 1;
 	return 0;
@@ -7378,8 +7393,8 @@ static int __netdev_update_lower_level(struct net_device *dev, void *data)
 
 int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 				  int (*fn)(struct net_device *dev,
-					    void *data),
-				  void *data)
+					    struct netdev_nested_priv *priv),
+				  struct netdev_nested_priv *priv)
 {
 	struct net_device *ldev, *next, *now, *dev_stack[MAX_NEST_DEV + 1];
 	struct list_head *niter, *iter, *iter_stack[MAX_NEST_DEV + 1];
@@ -7390,7 +7405,7 @@ int netdev_walk_all_lower_dev_rcu(struct net_device *dev,
 
 	while (1) {
 		if (now != dev) {
-			ret = fn(now, data);
+			ret = fn(now, priv);
 			if (ret)
 				return ret;
 		}
-- 
2.17.1

