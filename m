Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A781E421716
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235683AbhJDTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:16:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238301AbhJDTQq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:16:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0990B61425;
        Mon,  4 Oct 2021 19:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633374897;
        bh=L/wFrSazO00uU+JhJAObzJpd5wWLhQEDkve4QE3PxhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVK5km35XszVclLXue8H/QQnp7rAxSK45ptRlJMg2Ck3sxm6jY511mHZcixAOsres
         5qus8QIL8jimcfEB/CGdSGTeAFtgmVVzFg+AQ1mOU5aizeod2E2FWeb4yl67lBUlhE
         x/poyh3FmGDEJgAJYzTBPw0eCeEo1syuAiAH39wgendgoZh4QxjTllvYBISNwhgOVx
         t0kH4g2Vz9CjTtX5lCdRYKxF+Kzsg3vjyUJYz2pAdrp4GzAVSjvEudU2mEfFH/P7c0
         wucZdwhOJFvPYarEYRrS3yO9g1wCiq3NoUOSOYTF9evOq1Fx9luBiEchZUUiBfMLP0
         WuvKtfWVdjamA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, tariqt@nvidia.com, yishaih@nvidia.com,
        linux-rdma@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/4] mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
Date:   Mon,  4 Oct 2021 12:14:43 -0700
Message-Id: <20211004191446.2127522-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211004191446.2127522-1-kuba@kernel.org>
References: <20211004191446.2127522-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx4_mac_to_u64() predates and opencodes ether_addr_to_u64().
It doesn't make the argument constant so it'll be problematic
when dev->dev_addr becomes a const. Convert to the generic helper.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/infiniband/hw/mlx4/main.c              |  2 +-
 drivers/infiniband/hw/mlx4/qp.c                |  2 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c       |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c | 16 ++++++++--------
 drivers/net/ethernet/mellanox/mlx4/fw.c        |  2 +-
 include/linux/mlx4/driver.h                    | 12 ------------
 6 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f367f4a4abff..f3fa2fe6a88a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2275,7 +2275,7 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	u64 release_mac = MLX4_IB_INVALID_MAC;
 	struct mlx4_ib_qp *qp;
 
-	new_smac = mlx4_mac_to_u64(dev->dev_addr);
+	new_smac = ether_addr_to_u64(dev->dev_addr);
 	atomic64_set(&ibdev->iboe.mac[port - 1], new_smac);
 
 	/* no need for update QP1 and mac registration in non-SRIOV */
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 8662f462e2a5..aea4182f33a4 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1853,7 +1853,7 @@ static int mlx4_set_path(struct mlx4_ib_dev *dev, const struct ib_qp_attr *qp,
 			 u16 vlan_id, u8 *smac)
 {
 	return _mlx4_set_path(dev, &qp->ah_attr,
-			      mlx4_mac_to_u64(smac),
+			      ether_addr_to_u64(smac),
 			      vlan_id,
 			      path, &mqp->pri, port);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 8d751383530b..9fadedfca41c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -3009,7 +3009,7 @@ int mlx4_set_vf_mac(struct mlx4_dev *dev, int port, int vf, u8 *mac)
 		return -EPERM;
 	}
 
-	s_info->mac = mlx4_mac_to_u64(mac);
+	s_info->mac = ether_addr_to_u64(mac);
 	mlx4_info(dev, "default mac on vf %d port %d to %llX will take effect only after vf restart\n",
 		  vf, port, s_info->mac);
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ac480dc79bc1..76c8fe8e0125 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -644,7 +644,7 @@ static int mlx4_en_get_qp(struct mlx4_en_priv *priv)
 	int index = 0;
 	int err = 0;
 	int *qpn = &priv->base_qpn;
-	u64 mac = mlx4_mac_to_u64(priv->dev->dev_addr);
+	u64 mac = ether_addr_to_u64(priv->dev->dev_addr);
 
 	en_dbg(DRV, priv, "Registering MAC: %pM for adding\n",
 	       priv->dev->dev_addr);
@@ -683,7 +683,7 @@ static void mlx4_en_put_qp(struct mlx4_en_priv *priv)
 	int qpn = priv->base_qpn;
 
 	if (dev->caps.steering_mode == MLX4_STEERING_MODE_A0) {
-		u64 mac = mlx4_mac_to_u64(priv->dev->dev_addr);
+		u64 mac = ether_addr_to_u64(priv->dev->dev_addr);
 		en_dbg(DRV, priv, "Registering MAC: %pM for deleting\n",
 		       priv->dev->dev_addr);
 		mlx4_unregister_mac(dev, priv->port, mac);
@@ -701,14 +701,14 @@ static int mlx4_en_replace_mac(struct mlx4_en_priv *priv, int qpn,
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct mlx4_dev *dev = mdev->dev;
 	int err = 0;
-	u64 new_mac_u64 = mlx4_mac_to_u64(new_mac);
+	u64 new_mac_u64 = ether_addr_to_u64(new_mac);
 
 	if (dev->caps.steering_mode != MLX4_STEERING_MODE_A0) {
 		struct hlist_head *bucket;
 		unsigned int mac_hash;
 		struct mlx4_mac_entry *entry;
 		struct hlist_node *tmp;
-		u64 prev_mac_u64 = mlx4_mac_to_u64(prev_mac);
+		u64 prev_mac_u64 = ether_addr_to_u64(prev_mac);
 
 		bucket = &priv->mac_hash[prev_mac[MLX4_EN_MAC_HASH_IDX]];
 		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
@@ -1076,7 +1076,7 @@ static void mlx4_en_do_multicast(struct mlx4_en_priv *priv,
 		mlx4_en_cache_mclist(dev);
 		netif_addr_unlock_bh(dev);
 		list_for_each_entry(mclist, &priv->mc_list, list) {
-			mcast_addr = mlx4_mac_to_u64(mclist->addr);
+			mcast_addr = ether_addr_to_u64(mclist->addr);
 			mlx4_SET_MCAST_FLTR(mdev->dev, priv->port,
 					    mcast_addr, 0, MLX4_MCAST_CONFIG);
 		}
@@ -1169,7 +1169,7 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
 				found = true;
 
 			if (!found) {
-				mac = mlx4_mac_to_u64(entry->mac);
+				mac = ether_addr_to_u64(entry->mac);
 				mlx4_en_uc_steer_release(priv, entry->mac,
 							 priv->base_qpn,
 							 entry->reg_id);
@@ -1212,7 +1212,7 @@ static void mlx4_en_do_uc_filter(struct mlx4_en_priv *priv,
 				priv->flags |= MLX4_EN_FLAG_FORCE_PROMISC;
 				break;
 			}
-			mac = mlx4_mac_to_u64(ha->addr);
+			mac = ether_addr_to_u64(ha->addr);
 			memcpy(entry->mac, ha->addr, ETH_ALEN);
 			err = mlx4_register_mac(mdev->dev, priv->port, mac);
 			if (err < 0) {
@@ -1348,7 +1348,7 @@ static void mlx4_en_delete_rss_steer_rules(struct mlx4_en_priv *priv)
 	for (i = 0; i < MLX4_EN_MAC_HASH_SIZE; ++i) {
 		bucket = &priv->mac_hash[i];
 		hlist_for_each_entry_safe(entry, tmp, bucket, hlist) {
-			mac = mlx4_mac_to_u64(entry->mac);
+			mac = ether_addr_to_u64(entry->mac);
 			en_dbg(DRV, priv, "Registering MAC:%pM for deleting\n",
 			       entry->mac);
 			mlx4_en_uc_steer_release(priv, entry->mac,
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index dc4ac1a2b6b6..42c96c9d7fb1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -3105,7 +3105,7 @@ void mlx4_replace_zero_macs(struct mlx4_dev *dev)
 		    dev->caps.port_type[i] == MLX4_PORT_TYPE_ETH) {
 			eth_random_addr(mac_addr);
 			dev->port_random_macs |= 1 << i;
-			dev->caps.def_mac[i] = mlx4_mac_to_u64(mac_addr);
+			dev->caps.def_mac[i] = ether_addr_to_u64(mac_addr);
 		}
 }
 EXPORT_SYMBOL_GPL(mlx4_replace_zero_macs);
diff --git a/include/linux/mlx4/driver.h b/include/linux/mlx4/driver.h
index a858bcb6220b..b26b71f62fb4 100644
--- a/include/linux/mlx4/driver.h
+++ b/include/linux/mlx4/driver.h
@@ -92,18 +92,6 @@ void *mlx4_get_protocol_dev(struct mlx4_dev *dev, enum mlx4_protocol proto, int
 
 struct devlink_port *mlx4_get_devlink_port(struct mlx4_dev *dev, int port);
 
-static inline u64 mlx4_mac_to_u64(u8 *addr)
-{
-	u64 mac = 0;
-	int i;
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		mac <<= 8;
-		mac |= addr[i];
-	}
-	return mac;
-}
-
 static inline void mlx4_u64_to_mac(u8 *addr, u64 mac)
 {
 	int i;
-- 
2.31.1

