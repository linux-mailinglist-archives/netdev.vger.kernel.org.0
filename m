Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6558E1E716B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 02:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438139AbgE2A02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 20:26:28 -0400
Received: from correo.us.es ([193.147.175.20]:44358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438103AbgE2AZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 20:25:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0EF6CE609
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91DF7DA722
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 02:25:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 82EEADA718; Fri, 29 May 2020 02:25:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 295AFDA715;
        Fri, 29 May 2020 02:25:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 29 May 2020 02:25:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B14D1426CCB9;
        Fri, 29 May 2020 02:25:53 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, paulb@mellanox.com,
        ozsh@mellanox.com, vladbu@mellanox.com, jiri@resnulli.us,
        kuba@kernel.org, saeedm@mellanox.com, michael.chan@broadcom.com,
        sriharsha.basavapatna@broadcom.com
Subject: [PATCH net-next 5/8] mlx5: update indirect block support
Date:   Fri, 29 May 2020 02:25:38 +0200
Message-Id: <20200529002541.19743-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200529002541.19743-1-pablo@netfilter.org>
References: <20200529002541.19743-1-pablo@netfilter.org>
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
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 81 ++-----------------
 .../ethernet/mellanox/mlx5/core/en/rep/tc.h   |  4 -
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  1 -
 .../net/ethernet/mellanox/mlx5/core/en_rep.h  |  5 --
 4 files changed, 8 insertions(+), 83 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index c609a5e50ebc..80713123de5c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -306,20 +306,6 @@ mlx5e_rep_indr_block_priv_lookup(struct mlx5e_rep_priv *rpriv,
 	return NULL;
 }
 
-static void mlx5e_rep_indr_unregister_block(struct mlx5e_rep_priv *rpriv,
-					    struct net_device *netdev);
-
-void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv)
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
@@ -423,9 +409,14 @@ mlx5e_rep_indr_setup_block(struct net_device *netdev,
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
 
@@ -492,76 +483,20 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, void *cb_priv,
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
 int mlx5e_rep_tc_netdevice_event_register(struct mlx5e_rep_priv *rpriv)
 {
 	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-	int err;
 
 	/* init indirect block notifications */
 	INIT_LIST_HEAD(&uplink_priv->tc_indr_block_priv_list);
 
-	uplink_priv->netdevice_nb.notifier_call = mlx5e_nic_rep_netdevice_event;
-	err = register_netdevice_notifier_dev_net(rpriv->netdev,
-						  &uplink_priv->netdevice_nb,
-						  &uplink_priv->netdevice_nn);
-	return err;
+	return flow_indr_dev_register(mlx5e_rep_indr_setup_cb, rpriv);
 }
 
 void mlx5e_rep_tc_netdevice_event_unregister(struct mlx5e_rep_priv *rpriv)
 {
-	struct mlx5_rep_uplink_priv *uplink_priv = &rpriv->uplink_priv;
-
-	/* clean indirect TC block notifications */
-	unregister_netdevice_notifier_dev_net(rpriv->netdev,
-					      &uplink_priv->netdevice_nb,
-					      &uplink_priv->netdevice_nn);
+	flow_indr_dev_unregister(mlx5e_rep_indr_setup_cb, rpriv,
+				 mlx5e_rep_indr_setup_tc_cb);
 }
 
 #if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
index 86f92abf2fdd..fdf9702c2d7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
@@ -33,7 +33,6 @@ void mlx5e_rep_encap_entry_detach(struct mlx5e_priv *priv,
 
 int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		       void *type_data);
-void mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv);
 
 bool mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
 			     struct sk_buff *skb,
@@ -65,9 +64,6 @@ static inline int
 mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 		   void *type_data) { return -EOPNOTSUPP; }
 
-static inline void
-mlx5e_rep_indr_clean_block_privs(struct mlx5e_rep_priv *rpriv) {}
-
 struct mlx5e_tc_update_priv;
 static inline bool
 mlx5e_rep_tc_update_skb(struct mlx5_cqe64 *cqe,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4e13e37a9ecd..fd8d198797ae 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1000,7 +1000,6 @@ static int mlx5e_init_rep_tx(struct mlx5e_priv *priv)
 static void mlx5e_cleanup_uplink_rep_tx(struct mlx5e_rep_priv *rpriv)
 {
 	mlx5e_rep_tc_netdevice_event_unregister(rpriv);
-	mlx5e_rep_indr_clean_block_privs(rpriv);
 
 	mlx5e_rep_tc_cleanup(rpriv);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.h
index 1c4af8522467..64a19eebe5e6 100644
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

