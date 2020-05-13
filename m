Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE7D1D1B65
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389726AbgEMQmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:42:08 -0400
Received: from correo.us.es ([193.147.175.20]:54092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389651AbgEMQl4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:41:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0651A27F8B5
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E82BF4FA0B
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 18:41:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DD4EA1158E9; Wed, 13 May 2020 18:41:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFA2D1158F1;
        Wed, 13 May 2020 18:41:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 13 May 2020 18:41:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 53FEE42EF4E0;
        Wed, 13 May 2020 18:41:52 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com
Subject: [PATCH 5/8 net] mlx5: update indirect block support
Date:   Wed, 13 May 2020 18:41:37 +0200
Message-Id: <20200513164140.7956-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200513164140.7956-1-pablo@netfilter.org>
References: <20200513164140.7956-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register ndo callback via flow_indr_dev_register() and
flow_indr_dev_unregister().

No need for mlx5e_rep_indr_clean_block_privs() since flow_block_cb_free()
already releases the internal mapping via ->release callback, which in
this case is mlx5e_rep_indr_tc_block_unbind().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 83 +++----------------
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  5 --
 2 files changed, 10 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index f372e94948fd..b7aa0d976ba7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -65,9 +65,6 @@ struct mlx5e_rep_indr_block_priv {
 	struct list_head list;
 };
 
-static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
-					    struct net_device *netdev);
-
 static void mlx5e_rep_get_drvinfo(struct net_device *dev,
 				  struct ethtool_drvinfo *drvinfo)
 {
@@ -680,17 +677,6 @@ mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
 	return NULL;
 }
 
-static void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
-{
-	struct mlx5e_rep_indr_block_priv *cb_priv, *temp;
-	struct list_head *head = &rpriv->uplink_priv.tc_indr_block_priv_list;
-
-	list_for_each_entry_safe(cb_priv, temp, head, list) {
-		mlx5e_rep_indr_unregister_block(rpriv, cb_priv->netdev);
-		kfree(cb_priv);
-	}
-}
-
 static int
 mlx5e_rep_indr_offload(struct net_device *netdev,
 		       struct flow_cls_offload *flower,
@@ -794,9 +780,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
 			   struct flow_block_offload *f,
 			   flow_setup_cb_t *setup_cb)
 {
+	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
 	struct mlx5e_rep_indr_block_priv *indr_priv;
 	struct flow_block_cb *block_cb;
 
+	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
+	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
+		return -EOPNOTSUPP;
+
 	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
 
@@ -863,53 +854,6 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
 	}
 }
 
-static int mlx5e_rep_indr_register_block(struct mlx5e_rep_priv *rpriv,
-					 struct net_device *netdev)
-{
-	int err;
-
-	err = __flow_indr_block_cb_register(netdev, rpriv,
-					    mlx5e_rep_indr_setup_cb,
-					    rpriv);
-	if (err) {
-		struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
-
-		mlx5_core_err(priv->mdev, "Failed to register remote block notifier for %s err=%d\n",
-			      netdev_name(netdev), err);
-	}
-	return err;
-}
-
-static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
-					    struct net_device *netdev)
-{
-	__flow_indr_block_cb_unregister(netdev, mlx5e_rep_indr_setup_cb,
-					rpriv);
-}
-
-static int mlx5e_nic_rep_netdevice_event(struct notifier_block *nb,
-					 unsigned long event, void *ptr)
-{
-	struct mlx5e_rep_priv *rpriv = container_of(nb, struct mlx5e_rep_priv,
-						     uplink_priv.netdevice_nb);
-	struct mlx5e_priv *priv = netdev_priv(rpriv->netdev);
-	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
-
-	if (!mlx5e_tc_tun_device_to_offload(priv, netdev) &&
-	    !(is_vlan_dev(netdev) && vlan_dev_real_dev(netdev) == rpriv->netdev))
-		return NOTIFY_OK;
-
-	switch (event) {
-	case NETDEV_REGISTER:
-		mlx5e_rep_indr_register_block(rpriv, netdev);
-		break;
-	case NETDEV_UNREGISTER:
-		mlx5e_rep_indr_unregister_block(rpriv, netdev);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
 static void
 mlx5e_rep_queue_neigh_update_work(struct mlx5e_priv *priv,
 				  struct mlx5e_neigh_hash_entry *nhe,
@@ -1806,12 +1750,10 @@ static int mlx5e_init_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 
 	/* init indirect block notifications */
 	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
-	uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
-	err = register_netdevice_notifier_dev_net(rpriv->netdev,
-						  &uplink_priv->netdevice_nb,
-						  &uplink_priv->netdevice_nn);
+
+	err = flow_indr_dev_register(mlx5e_rep_indr_setup_cb, rpriv);
 	if (err) {
-		mlx5_core_err(priv->mdev, "Failed to register netdev notifier\n");
+		mlx5_core_err(priv->mdev, "Failed to register indirect block notifier\n");
 		goto tc_esw_cleanup;
 	}
 
@@ -1848,13 +1790,8 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 
 static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
-	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-
-	/* clean indirect TC block notifications */
-	unregister_netdevice_notifier_dev_net(rpriv->netdev,
-					      &uplink_priv->netdevice_nb,
-					      &uplink_priv->netdevice_nn);
-	mlx5e_rep_indr_clean_block_privs(rpriv);
+	flow_indr_dev_unregister(mlx5e_rep_indr_setup_cb, rpriv,
+				 mlx5e_rep_indr_setup_tc_cb);
 
 	/* delete shared tc flow table */
 	mlx5e_tc_esw_cleanup(&rpriv->uplink_priv.tc_ht);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 6a2337900420..3d6a4a9be482 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
@@ -68,13 +68,8 @@ struct mlx5_rep_uplink_priv {
 	 * tc_indr_block_cb_priv_list is used to lookup indirect callback
 	 * private data
 	 *
-	 * netdevice_nb is the netdev events notifier - used to register
-	 * tunnel devices for block events
-	 *
 	 */
 	struct list_head	    tc_indr_block_priv_list;
-	struct notifier_block	    netdevice_nb;
-	struct netdev_net_notifier  netdevice_nn;
 
 	struct mlx5_tun_entropy tun_entropy;
 
-- 
2.20.1

