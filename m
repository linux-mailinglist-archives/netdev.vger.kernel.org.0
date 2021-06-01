Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474F0396E84
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhFAIHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhFAIH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 04:07:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B318C061760;
        Tue,  1 Jun 2021 01:05:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lnzPE-000V6C-JK; Tue, 01 Jun 2021 10:05:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 4/4] iosm: convert to generic wwan ops
Date:   Tue,  1 Jun 2021 10:05:38 +0200
Message-Id: <20210601100320.8bbd87f9ca38.I7a6cdc107f55e4d872552a58888424bd5896589a@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210601080538.71036-1-johannes@sipsolutions.net>
References: <20210601080538.71036-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |   1 -
 drivers/net/wwan/iosm/iosm_ipc_pcie.c     |   7 -
 drivers/net/wwan/iosm/iosm_ipc_pcie.h     |   2 -
 drivers/net/wwan/iosm/iosm_ipc_wwan.c     | 310 +++++++---------------
 include/uapi/linux/if_link.h              |  10 -
 tools/include/uapi/linux/if_link.h        |  10 -
 6 files changed, 103 insertions(+), 237 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index 6677a82be77b..84087cf33329 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -29,7 +29,6 @@
 /* IP MUX channel range */
 #define IP_MUX_SESSION_START 1
 #define IP_MUX_SESSION_END 8
-#define MAX_IP_MUX_SESSION IP_MUX_SESSION_END
 
 /**
  * ipc_imem_sys_port_open - Open a port link to CP.
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 0c26047ebc1c..ac6baddfde61 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -567,18 +567,11 @@ static int __init iosm_ipc_driver_init(void)
 		return -1;
 	}
 
-	if (rtnl_link_register(&iosm_netlink)) {
-		pr_err("IOSM RTNL register failed");
-		pci_unregister_driver(&iosm_ipc_driver);
-		return -1;
-	}
-
 	return 0;
 }
 
 static void __exit iosm_ipc_driver_exit(void)
 {
-	rtnl_link_unregister(&iosm_netlink);
 	pci_unregister_driver(&iosm_ipc_driver);
 }
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.h b/drivers/net/wwan/iosm/iosm_ipc_pcie.h
index 839809fee3dd..7d1f0cd7364c 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.h
@@ -12,8 +12,6 @@
 
 #include "iosm_ipc_irq.h"
 
-extern struct rtnl_link_ops iosm_netlink;
-
 /* Device ID */
 #define INTEL_CP_DEVICE_7560_ID 0x7560
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index 719c88d9b2e9..daf3d36edc4e 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -6,8 +6,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/if_link.h>
-#include <net/rtnetlink.h>
-
+#include <linux/wwan.h>
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_imem_ops.h"
 #include "iosm_ipc_wwan.h"
@@ -18,65 +17,52 @@
 
 #define IOSM_IF_ID_PAYLOAD 2
 
-static struct device_type wwan_type = { .name = "wwan" };
-
-static const struct nla_policy ipc_wwan_policy[IFLA_IOSM_MAX + 1] = {
-	[IFLA_IOSM_IF_ID]	= { .type = NLA_U16 },
-};
-
 /**
- * struct iosm_net_link - This structure includes information about interface
- *			  dev.
+ * struct iosm_netdev_priv - netdev private data
  * @if_id:	Interface id for device.
  * @ch_id:	IPC channel number for which interface device is created.
- * @netdev:	Pointer to network interface device structure
  * @ipc_wwan:	Pointer to iosm_wwan struct
  */
-
-struct iosm_net_link {
+struct iosm_netdev_priv {
+	struct iosm_wwan *ipc_wwan;
+	struct net_device *netdev;
 	int if_id;
 	int ch_id;
-	struct net_device *netdev;
-	struct iosm_wwan *ipc_wwan;
 };
 
 /**
  * struct iosm_wwan - This structure contains information about WWAN root device
- *		     and interface to the IPC layer.
- * @netdev:		Pointer to network interface device structure.
- * @sub_netlist:	List of netlink interfaces
+ *		      and interface to the IPC layer.
  * @ipc_imem:		Pointer to imem data-struct
+ * @sub_netlist:	List of active netdevs
  * @dev:		Pointer device structure
  * @if_mutex:		Mutex used for add and remove interface id
- * @is_registered:	Registration status with netdev
  */
 struct iosm_wwan {
-	struct net_device *netdev;
-	struct iosm_net_link __rcu *sub_netlist[MAX_IP_MUX_SESSION];
 	struct iosm_imem *ipc_imem;
+	struct iosm_netdev_priv __rcu *sub_netlist[IP_MUX_SESSION_END + 1];
 	struct device *dev;
 	struct mutex if_mutex; /* Mutex used for add and remove interface id */
-	u8 is_registered:1;
 };
 
 /* Bring-up the wwan net link */
 static int ipc_wwan_link_open(struct net_device *netdev)
 {
-	struct iosm_net_link *netlink = netdev_priv(netdev);
-	struct iosm_wwan *ipc_wwan = netlink->ipc_wwan;
-	int if_id = netlink->if_id;
-	int ret = -EINVAL;
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
+	int if_id = priv->if_id;
+	int ret;
 
-	if (if_id < IP_MUX_SESSION_START || if_id > IP_MUX_SESSION_END)
-		return ret;
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
 
 	mutex_lock(&ipc_wwan->if_mutex);
 
 	/* get channel id */
-	netlink->ch_id =
-		ipc_imem_sys_wwan_open(ipc_wwan->ipc_imem, if_id);
+	priv->ch_id = ipc_imem_sys_wwan_open(ipc_wwan->ipc_imem, if_id);
 
-	if (netlink->ch_id < 0) {
+	if (priv->ch_id < 0) {
 		dev_err(ipc_wwan->dev,
 			"cannot connect wwan0 & id %d to the IPC mem layer",
 			if_id);
@@ -88,7 +74,7 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 	netif_start_queue(netdev);
 
 	dev_dbg(ipc_wwan->dev, "Channel id %d allocated to if_id %d",
-		netlink->ch_id, netlink->if_id);
+		priv->ch_id, priv->if_id);
 
 	ret = 0;
 out:
@@ -99,14 +85,15 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 /* Bring-down the wwan net link */
 static int ipc_wwan_link_stop(struct net_device *netdev)
 {
-	struct iosm_net_link *netlink = netdev_priv(netdev);
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
 
 	netif_stop_queue(netdev);
 
-	mutex_lock(&netlink->ipc_wwan->if_mutex);
-	ipc_imem_sys_wwan_close(netlink->ipc_wwan->ipc_imem, netlink->if_id,
-				netlink->ch_id);
-	mutex_unlock(&netlink->ipc_wwan->if_mutex);
+	mutex_lock(&priv->ipc_wwan->if_mutex);
+	ipc_imem_sys_wwan_close(priv->ipc_wwan->ipc_imem, priv->if_id,
+				priv->ch_id);
+	priv->ch_id = -1;
+	mutex_unlock(&priv->ipc_wwan->if_mutex);
 
 	return 0;
 }
@@ -115,20 +102,21 @@ static int ipc_wwan_link_stop(struct net_device *netdev)
 static int ipc_wwan_link_transmit(struct sk_buff *skb,
 				  struct net_device *netdev)
 {
-	struct iosm_net_link *netlink = netdev_priv(netdev);
-	struct iosm_wwan *ipc_wwan = netlink->ipc_wwan;
-	int if_id = netlink->if_id;
-	int ret = -EINVAL;
+	struct iosm_netdev_priv *priv = netdev_priv(netdev);
+	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
+	int if_id = priv->if_id;
+	int ret;
 
 	/* Interface IDs from 1 to 8 are for IP data
 	 * & from 257 to 261 are for non-IP data
 	 */
-	if (if_id < IP_MUX_SESSION_START || if_id > IP_MUX_SESSION_END)
-		goto exit;
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
 
 	/* Send the SKB to device for transmission */
 	ret = ipc_imem_sys_wwan_transmit(ipc_wwan->ipc_imem,
-					 if_id, netlink->ch_id, skb);
+					 if_id, priv->ch_id, skb);
 
 	/* Return code of zero is success */
 	if (ret == 0) {
@@ -175,137 +163,72 @@ static void ipc_wwan_setup(struct net_device *iosm_dev)
 	iosm_dev->netdev_ops = &ipc_inm_ops;
 }
 
-static struct device_type inm_type = { .name = "iosmdev" };
-
 /* Create new wwan net link */
-static int ipc_wwan_newlink(struct net *src_net, struct net_device *dev,
-			    struct nlattr *tb[], struct nlattr *data[],
-			    struct netlink_ext_ack *extack)
+static int ipc_wwan_newlink(void *ctxt, struct net_device *dev,
+			    u32 if_id, struct netlink_ext_ack *extack)
 {
-	struct iosm_net_link *netlink = netdev_priv(dev);
-	struct iosm_wwan *ipc_wwan;
-	struct net_device *netdev;
-	int err = -EINVAL;
-	int index;
-
-	if (!data[IFLA_IOSM_IF_ID]) {
-		pr_err("Interface ID not specified");
-		goto out;
-	}
-
-	if (!tb[IFLA_LINK]) {
-		pr_err("Link not specified");
-		goto out;
-	}
-
-	netlink->netdev = dev;
-
-	netdev = __dev_get_by_index(src_net, nla_get_u32(tb[IFLA_LINK]));
-
-	netlink->ipc_wwan = netdev_priv(netdev);
-
-	ipc_wwan = netlink->ipc_wwan;
+	struct iosm_wwan *ipc_wwan = ctxt;
+	struct iosm_netdev_priv *priv;
+	int err;
 
-	if (ipc_wwan->netdev != netdev)
-		goto out;
-
-	netlink->if_id = nla_get_u16(data[IFLA_IOSM_IF_ID]);
-	index = netlink->if_id;
-
-	/* Complete all memory stores before this point */
-	smp_mb();
-	if (index < IP_MUX_SESSION_START || index > IP_MUX_SESSION_END)
-		goto out;
+	if (if_id < IP_MUX_SESSION_START ||
+	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
+		return -EINVAL;
 
-	rcu_read_lock();
+	priv = netdev_priv(dev);
+	priv->if_id = if_id;
 
-	if (rcu_access_pointer(ipc_wwan->sub_netlist[index - 1])) {
-		pr_err("IOSM interface ID already in use");
-		goto out_free_lock;
+	mutex_lock(&ipc_wwan->if_mutex);
+	if (rcu_access_pointer(ipc_wwan->sub_netlist[if_id])) {
+		err = -EBUSY;
+		goto out_unlock;
 	}
 
-	SET_NETDEV_DEVTYPE(dev, &inm_type);
-
-	eth_hw_addr_random(dev);
 	err = register_netdevice(dev);
-	if (err) {
-		dev_err(ipc_wwan->dev, "register netlink failed.\n");
-		goto out_free_lock;
-	}
-
-	err = netdev_upper_dev_link(ipc_wwan->netdev, dev, extack);
+	if (err)
+		goto out_unlock;
 
-	if (err) {
-		dev_err(ipc_wwan->dev, "netdev linking with parent failed.\n");
-		goto netlink_err;
-	}
+	rcu_assign_pointer(ipc_wwan->sub_netlist[if_id], priv);
+	mutex_unlock(&ipc_wwan->if_mutex);
 
-	rcu_assign_pointer(ipc_wwan->sub_netlist[index - 1], netlink);
 	netif_device_attach(dev);
-	rcu_read_unlock();
 
 	return 0;
 
-netlink_err:
-	unregister_netdevice(dev);
-out_free_lock:
-	rcu_read_unlock();
-out:
+out_unlock:
+	mutex_unlock(&ipc_wwan->if_mutex);
 	return err;
 }
 
-/* Delete new wwan net link */
-static void ipc_wwan_dellink(struct net_device *dev, struct list_head *head)
+static void ipc_wwan_dellink(void *ctxt, struct net_device *dev,
+			     struct list_head *head)
 {
-	struct iosm_net_link *netlink = netdev_priv(dev);
-	u16 index = netlink->if_id;
-
-	netdev_upper_dev_unlink(netlink->ipc_wwan->netdev, dev);
-	unregister_netdevice(dev);
+	struct iosm_wwan *ipc_wwan = ctxt;
+	struct iosm_netdev_priv *priv = netdev_priv(dev);
+	int if_id = priv->if_id;
 
-	mutex_lock(&netlink->ipc_wwan->if_mutex);
-	rcu_assign_pointer(netlink->ipc_wwan->sub_netlist[index - 1], NULL);
-	mutex_unlock(&netlink->ipc_wwan->if_mutex);
-}
+	if (WARN_ON(if_id < IP_MUX_SESSION_START ||
+		    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist)))
+		return;
 
-/* Get size for iosm net link payload*/
-static size_t ipc_wwan_get_size(const struct net_device *dev)
-{
-	return nla_total_size(IOSM_IF_ID_PAYLOAD);
-}
-
-/* Validate the input parameters for wwan net link */
-static int ipc_wwan_validate(struct nlattr *tb[], struct nlattr *data[],
-			     struct netlink_ext_ack *extack)
-{
-	u16 if_id;
-
-	if (!data || !data[IFLA_IOSM_IF_ID]) {
-		NL_SET_ERR_MSG_MOD(extack, "IF ID not specified");
-		return -EINVAL;
-	}
+	mutex_lock(&ipc_wwan->if_mutex);
 
-	if_id = nla_get_u16(data[IFLA_IOSM_IF_ID]);
+	if (WARN_ON(rcu_access_pointer(ipc_wwan->sub_netlist[if_id]) != priv))
+		goto unlock;
 
-	if (if_id < IP_MUX_SESSION_START || if_id > IP_MUX_SESSION_END) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid Interface");
-		return -ERANGE;
-	}
+	RCU_INIT_POINTER(ipc_wwan->sub_netlist[if_id], NULL);
+	/* unregistering includes synchronize_net() */
+	unregister_netdevice(dev);
 
-	return 0;
+unlock:
+	mutex_unlock(&ipc_wwan->if_mutex);
 }
 
-/* RT Net link ops structure for new wwan net link */
-struct rtnl_link_ops iosm_netlink __read_mostly = {
-	.kind           = "iosm",
-	.maxtype        = __IFLA_IOSM_MAX,
-	.priv_size      = sizeof(struct iosm_net_link),
-	.setup          = ipc_wwan_setup,
-	.validate       = ipc_wwan_validate,
-	.newlink        = ipc_wwan_newlink,
-	.dellink        = ipc_wwan_dellink,
-	.get_size       = ipc_wwan_get_size,
-	.policy         = ipc_wwan_policy,
+static const struct wwan_ops iosm_wwan_ops = {
+	.priv_size = sizeof(struct iosm_netdev_priv),
+	.setup = ipc_wwan_setup,
+	.newlink = ipc_wwan_newlink,
+	.dellink = ipc_wwan_dellink,
 };
 
 int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
@@ -313,7 +236,7 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
 {
 	struct sk_buff *skb = skb_arg;
 	struct net_device_stats *stats;
-	struct iosm_net_link *priv;
+	struct iosm_netdev_priv *priv;
 	int ret;
 
 	if ((skb->data[0] & IOSM_IP_TYPE_MASK) == IOSM_IP_TYPE_IPV4)
@@ -353,10 +276,17 @@ int ipc_wwan_receive(struct iosm_wwan *ipc_wwan, struct sk_buff *skb_arg,
 void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int if_id, bool on)
 {
 	struct net_device *netdev;
+	struct iosm_netdev_priv *priv;
 	bool is_tx_blk;
 
 	rcu_read_lock();
-	netdev = rcu_dereference(ipc_wwan->sub_netlist[if_id])->netdev;
+	priv = rcu_dereference(ipc_wwan->sub_netlist[if_id]);
+	if (!priv) {
+		rcu_read_unlock();
+		return;
+	}
+
+	netdev = priv->netdev;
 
 	is_tx_blk = netif_queue_stopped(netdev);
 
@@ -371,78 +301,44 @@ void ipc_wwan_tx_flowctrl(struct iosm_wwan *ipc_wwan, int if_id, bool on)
 	rcu_read_unlock();
 }
 
-static void ipc_netdev_setup(struct net_device *dev) {}
-
 struct iosm_wwan *ipc_wwan_init(struct iosm_imem *ipc_imem, struct device *dev)
 {
-	static const struct net_device_ops iosm_wwandev_ops = {};
 	struct iosm_wwan *ipc_wwan;
-	struct net_device *netdev;
 
-	netdev = alloc_netdev(sizeof(*ipc_wwan), "wwan%d", NET_NAME_ENUM,
-			      ipc_netdev_setup);
-
-	if (!netdev)
+	ipc_wwan = kzalloc(sizeof(*ipc_wwan), GFP_KERNEL);
+	if (!ipc_wwan)
 		return NULL;
 
-	ipc_wwan = netdev_priv(netdev);
-
 	ipc_wwan->dev = dev;
-	ipc_wwan->netdev = netdev;
-	ipc_wwan->is_registered = false;
-
 	ipc_wwan->ipc_imem = ipc_imem;
 
-	mutex_init(&ipc_wwan->if_mutex);
-
-	/* allocate random ethernet address */
-	eth_random_addr(netdev->dev_addr);
-	netdev->addr_assign_type = NET_ADDR_RANDOM;
-
-	netdev->netdev_ops = &iosm_wwandev_ops;
-	netdev->flags |= IFF_NOARP;
-
-	SET_NETDEV_DEVTYPE(netdev, &wwan_type);
-
-	if (register_netdev(netdev)) {
-		dev_err(ipc_wwan->dev, "register_netdev failed");
-		goto reg_fail;
+	if (wwan_register_ops(ipc_wwan->dev, &iosm_wwan_ops, ipc_wwan)) {
+		kfree(ipc_wwan);
+		return NULL;
 	}
 
-	ipc_wwan->is_registered = true;
-
-	netif_device_attach(netdev);
+	mutex_init(&ipc_wwan->if_mutex);
 
 	return ipc_wwan;
-
-reg_fail:
-	free_netdev(netdev);
-	return NULL;
 }
 
 void ipc_wwan_deinit(struct iosm_wwan *ipc_wwan)
 {
-	struct iosm_net_link *netlink;
-	int i;
-
-	if (ipc_wwan->is_registered) {
-		rcu_read_lock();
-		for (i = IP_MUX_SESSION_START; i <= IP_MUX_SESSION_END; i++) {
-			if (rcu_access_pointer(ipc_wwan->sub_netlist[i - 1])) {
-				netlink =
-				rcu_dereference(ipc_wwan->sub_netlist[i - 1]);
-				rtnl_lock();
-				netdev_upper_dev_unlink(ipc_wwan->netdev,
-							netlink->netdev);
-				unregister_netdevice(netlink->netdev);
-				rtnl_unlock();
-				rcu_assign_pointer(ipc_wwan->sub_netlist[i - 1],
-						   NULL);
-			}
-		}
-		rcu_read_unlock();
+	int if_id;
 
-		unregister_netdev(ipc_wwan->netdev);
-		free_netdev(ipc_wwan->netdev);
+	wwan_unregister_ops(ipc_wwan->dev);
+
+	for (if_id = 0; if_id < ARRAY_SIZE(ipc_wwan->sub_netlist); if_id++) {
+		struct iosm_netdev_priv *priv;
+
+		priv = rcu_access_pointer(ipc_wwan->sub_netlist[if_id]);
+		if (!priv)
+			continue;
+
+		ipc_wwan_dellink(ipc_wwan, priv->netdev, NULL);
 	}
+
+	mutex_destroy(&ipc_wwan->if_mutex);
+
+	kfree(ipc_wwan);
 }
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index f7c3beebb074..cd5b382a4138 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1251,14 +1251,4 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
-/* IOSM Section */
-
-enum {
-	IFLA_IOSM_UNSPEC,
-	IFLA_IOSM_IF_ID,
-	__IFLA_IOSM_MAX,
-};
-
-#define IFLA_IOSM_MAX  (__IFLA_IOSM_MAX - 1)
-
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index cb496d0de39e..d208b2af697f 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -1046,14 +1046,4 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
-/* IOSM Section */
-
-enum {
-	IFLA_IOSM_UNSPEC,
-	IFLA_IOSM_IF_ID,
-	__IFLA_IOSM_MAX,
-};
-
-#define IFLA_IOSM_MAX  (__IFLA_IOSM_MAX - 1)
-
 #endif /* _UAPI_LINUX_IF_LINK_H */
-- 
2.31.1

