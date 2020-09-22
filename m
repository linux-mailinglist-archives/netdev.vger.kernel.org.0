Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BC127434A
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIVNii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:38:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbgIVNiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:38:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600781902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1NIupOt1ImWZcWR7ORLYqEncx18w90TXz5Hyf7HvbJg=;
        b=bM7D2P0vHMIg7H8b0AXtRb04g7yn3jz67rbRM0AfQqKZ334A+l+EGnXCnSOzD32N2iFnC/
        ujSjIklqnGh44Fo05vFXL6pzi+Adj6RiyNO68k+Nb0Tn8B1X/oAAC7mvvf9qvCYyuW2RBY
        sk6fkdetk+8U3peO/mGWTutPCd3rvYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-f7nfy2JKNPONRPHdUTQg5Q-1; Tue, 22 Sep 2020 09:38:20 -0400
X-MC-Unique: f7nfy2JKNPONRPHdUTQg5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 303B589BBBF;
        Tue, 22 Sep 2020 13:38:08 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E9FD78808;
        Tue, 22 Sep 2020 13:38:07 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/5] bonding: rename master to aggregator where possible
Date:   Tue, 22 Sep 2020 09:37:29 -0400
Message-Id: <20200922133731.33478-4-jarod@redhat.com>
In-Reply-To: <20200922133731.33478-1-jarod@redhat.com>
References: <20200922133731.33478-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Getting rid of as much usage of "master" as we can here, without breaking
any user-facing API.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/infiniband/core/cma.c                 |   2 +-
 drivers/infiniband/core/lag.c                 |   2 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |   6 +-
 drivers/net/bonding/bond_3ad.c                |   2 +-
 drivers/net/bonding/bond_main.c               |  57 +++----
 drivers/net/bonding/bond_procfs.c             |   4 +-
 drivers/net/bonding/bond_sysfs.c              | 140 +++++++++++++-----
 .../ethernet/netronome/nfp/flower/lag_conf.c  |   2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |   8 +-
 include/linux/netdevice.h                     |   4 +-
 include/net/bonding.h                         |   1 +
 11 files changed, 153 insertions(+), 75 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7f0e91e92968..9141a8402456 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4687,7 +4687,7 @@ static int cma_netdev_callback(struct notifier_block *self, unsigned long event,
 	if (event != NETDEV_BONDING_FAILOVER)
 		return NOTIFY_DONE;
 
-	if (!netif_is_bond_master(ndev))
+	if (!netif_is_bond_aggregator(ndev))
 		return NOTIFY_DONE;
 
 	mutex_lock(&lock);
diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 7063e41eaf26..df20107aba88 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -128,7 +128,7 @@ struct net_device *rdma_lag_get_ah_roce_slave(struct ib_device *device,
 	dev_hold(master);
 	rcu_read_unlock();
 
-	if (!netif_is_bond_master(master))
+	if (!netif_is_bond_aggregator(master))
 		goto put;
 
 	slave = rdma_get_xmit_slave_udp(device, master, ah_attr, flags);
diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
index d0ada1756564..a748d85fbfa1 100644
--- a/drivers/infiniband/core/roce_gid_mgmt.c
+++ b/drivers/infiniband/core/roce_gid_mgmt.c
@@ -129,7 +129,7 @@ enum bonding_slave_state {
 static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_device *dev,
 								   struct net_device *upper)
 {
-	if (upper && netif_is_bond_master(upper)) {
+	if (upper && netif_is_bond_aggregator(upper)) {
 		struct net_device *pdev =
 			bond_option_active_link_get_rcu(netdev_priv(upper));
 
@@ -216,7 +216,7 @@ is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u8 port,
 	 * make sure that it the upper netdevice of rdma netdevice.
 	 */
 	res = ((cookie_ndev == rdma_ndev && !netif_is_bond_link(rdma_ndev)) ||
-	       (netif_is_bond_master(cookie_ndev) &&
+	       (netif_is_bond_aggregator(cookie_ndev) &&
 		rdma_is_upper_dev_rcu(rdma_ndev, cookie_ndev)));
 
 	rcu_read_unlock();
@@ -271,7 +271,7 @@ is_upper_ndev_bond_master_filter(struct ib_device *ib_dev, u8 port,
 		return false;
 
 	rcu_read_lock();
-	if (netif_is_bond_master(cookie_ndev) &&
+	if (netif_is_bond_aggregator(cookie_ndev) &&
 	    rdma_is_upper_dev_rcu(rdma_ndev, cookie_ndev))
 		match = true;
 	rcu_read_unlock();
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index aec4cd6918b9..6a7c285ae969 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -2551,7 +2551,7 @@ void bond_3ad_handle_link_change(struct link *link, char link_state)
 }
 
 /**
- * bond_3ad_set_carrier - set link state for bonding master
+ * bond_3ad_set_carrier - set link state for bonding aggregator device
  * @bond: bonding structure
  *
  * if we have an active aggregator, we're up, if not, we're down.
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 8e2edebeb61a..f895f0c70017 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -469,8 +469,8 @@ static const struct xfrmdev_ops bond_xfrmdev_ops = {
 
 /*------------------------------- Link status -------------------------------*/
 
-/* Set the carrier state for the master according to the state of its
- * links.  If any links are up, the master is up.  In 802.3ad mode,
+/* Set the carrier state for the aggregator according to the state of its
+ * links.  If any links are up, the aggregator is up.  In 802.3ad mode,
  * do special 802.3ad magic.
  *
  * Returns zero if carrier state does not change, nonzero if it does.
@@ -1372,7 +1372,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
 	 * inactive link links without being forced to bind to them
 	 * explicitly.
 	 *
-	 * At the same time, packets that are passed to the bonding master
+	 * At the same time, packets that are passed to the bonding aggregator
 	 * (including link-local ones) can have their originating interface
 	 * determined via PACKET_ORIGDEV socket option.
 	 */
@@ -1439,8 +1439,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
 	}
 }
 
-static int bond_master_upper_dev_link(struct bonding *bond, struct link *link,
-				      struct netlink_ext_ack *extack)
+static int bond_agg_upper_dev_link(struct bonding *bond, struct link *link,
+				   struct netlink_ext_ack *extack)
 {
 	struct netdev_lag_upper_info lag_upper_info;
 	enum netdev_lag_tx_type type;
@@ -1538,7 +1538,7 @@ void bond_lower_state_changed(struct link *link)
 	netdev_lower_state_changed(link->dev, &info);
 }
 
-/* connect device <link> to bond device <master> */
+/* connect device <link> to bond device <aggregator> */
 int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 		 struct netlink_ext_ack *extack)
 {
@@ -1667,8 +1667,8 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 
 	call_netdevice_notifiers(NETDEV_JOIN, link_dev);
 
-	/* If this is the first link, then we need to set the master's hardware
-	 * address to be the same as the link's.
+	/* If this is the first link, then we need to set the aggregator's
+	 * hardware address to be the same as the link's.
 	 */
 	if (!bond_has_links(bond) &&
 	    bond->dev->addr_assign_type == NET_ADDR_RANDOM) {
@@ -1700,15 +1700,16 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 
 	/* Save link's original ("permanent") mac address for modes
 	 * that need it, and for restoring it upon release, and then
-	 * set it to the master's address
+	 * set it to the aggregator's address
 	 */
 	bond_hw_addr_copy(new_link->perm_hwaddr, link_dev->dev_addr,
 			  link_dev->addr_len);
 
 	if (!bond->params.fail_over_mac ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		/* Set link to master's mac address.  The application already
-		 * set the master's mac address to that of the first link
+		/* Set link to aggregator's mac address.  The application
+		 * already set the aggregator's mac address to that of the first
+		 * link
 		 */
 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
 		ss.ss_family = link_dev->type;
@@ -1871,7 +1872,7 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	if (bond->dev->npinfo) {
 		if (link_enable_netpoll(new_link)) {
-			link_info(bond_dev, link_dev, "master_dev is using netpoll, but new link device does not support netpoll\n");
+			link_info(bond_dev, link_dev, "aggregator dev is using netpoll, but new link device does not support netpoll\n");
 			res = -EBUSY;
 			goto err_detach;
 		}
@@ -1888,9 +1889,9 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 		goto err_detach;
 	}
 
-	res = bond_master_upper_dev_link(bond, new_link, extack);
+	res = bond_agg_upper_dev_link(bond, new_link, extack);
 	if (res) {
-		link_dbg(bond_dev, link_dev, "Error %d calling bond_master_upper_dev_link\n", res);
+		link_dbg(bond_dev, link_dev, "Error %d calling bond_agg_upper_dev_link\n", res);
 		goto err_unregister;
 	}
 
@@ -1981,7 +1982,7 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 	link_disable_netpoll(new_link);
 
 err_close:
-	if (!netif_is_bond_master(link_dev))
+	if (!netif_is_bond_aggregator(link_dev))
 		link_dev->priv_flags &= ~IFF_BONDING;
 	dev_close(link_dev);
 
@@ -1989,7 +1990,7 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 	link_dev->flags &= ~IFF_SLAVE;
 	if (!bond->params.fail_over_mac ||
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
-		/* XXX TODO - fom follow mode needs to change master's
+		/* XXX TODO - fom follow mode needs to change aggregator's
 		 * MAC if this link's MAC is in use by the bond, or at
 		 * least print a warning.
 		 */
@@ -2006,7 +2007,9 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 	bond_free_link(new_link);
 
 err_undo_flags:
-	/* Bringing up first link has failed and we need to fix master's mac */
+	/* Bringing up first link has failed and we need to fix aggregator's
+	 * mac
+	 */
 	if (!bond_has_links(bond)) {
 		if (ether_addr_equal_64bits(bond_dev->dev_addr,
 					    link_dev->dev_addr))
@@ -2022,7 +2025,7 @@ int bond_connect(struct net_device *bond_dev, struct net_device *link_dev,
 	return res;
 }
 
-/* Try to release the link device <link> from the bond device <master>
+/* Try to release the link device <link> from the bond device <aggregator>
  * It is legal to access curr_active_link without a lock because all the function
  * is RTNL-locked. If "all" is true it means that the function is being called
  * while destroying a bond interface and all links are being released.
@@ -2043,7 +2046,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
 
-	/* link is not a link or master is not master of this link */
+	/* link is not a link or aggregator is not aggregator of this link */
 	if (!(link_dev->flags & IFF_SLAVE) ||
 	    !netdev_has_upper_dev(link_dev, bond_dev)) {
 		link_dbg(bond_dev, link_dev, "cannot release link\n");
@@ -2180,7 +2183,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	else
 		dev_set_mtu(link_dev, link->original_mtu);
 
-	if (!netif_is_bond_master(link_dev))
+	if (!netif_is_bond_aggregator(link_dev))
 		link_dev->priv_flags &= ~IFF_BONDING;
 
 	bond_free_link(link);
@@ -3248,8 +3251,8 @@ static int bond_event_changename(struct bonding *bond)
 	return NOTIFY_DONE;
 }
 
-static int bond_master_netdev_event(unsigned long event,
-				    struct net_device *bond_dev)
+static int bond_agg_netdev_event(unsigned long event,
+				 struct net_device *bond_dev)
 {
 	struct bonding *event_bond = netdev_priv(bond_dev);
 
@@ -3372,7 +3375,7 @@ static int bond_link_netdev_event(unsigned long event,
 		bond_compute_features(bond);
 		break;
 	case NETDEV_RESEND_IGMP:
-		/* Propagate to master device */
+		/* Propagate to aggregator device */
 		call_netdevice_notifiers(event, link->bond->dev);
 		break;
 	default:
@@ -3403,7 +3406,7 @@ static int bond_netdev_event(struct notifier_block *this,
 	if (event_dev->flags & IFF_MASTER) {
 		int ret;
 
-		ret = bond_master_netdev_event(event, event_dev);
+		ret = bond_agg_netdev_event(event, event_dev);
 		if (ret != NOTIFY_DONE)
 			return ret;
 	}
@@ -3930,7 +3933,7 @@ static int bond_neigh_setup(struct net_device *dev,
 	return 0;
 }
 
-/* Change the MTU of all of a master's links to match the master */
+/* Change the MTU of all of an aggregator's links to match the aggregator */
 static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
@@ -3985,7 +3988,7 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 /* Change HW address
  *
  * Note that many devices must be down to change the HW address, and
- * downing the master releases all links.  We can make bonds full of
+ * downing the aggregator releases all links.  We can make bonds full of
  * bonding devices to test this, however.
  */
 static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
@@ -4479,7 +4482,7 @@ static struct net_device *bond_xmit_get_link(struct net_device *agg_dev,
 					     struct sk_buff *skb,
 					     bool all_links)
 {
-	struct bonding *bond = netdev_priv(master_dev);
+	struct bonding *bond = netdev_priv(agg_dev);
 	struct bond_up_link *links;
 	struct link *link = NULL;
 
diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
index 413b942c170c..abd265d6e975 100644
--- a/drivers/net/bonding/bond_procfs.c
+++ b/drivers/net/bonding/bond_procfs.c
@@ -54,7 +54,7 @@ static void bond_info_seq_stop(struct seq_file *seq, void *v)
 	rcu_read_unlock();
 }
 
-static void bond_info_show_master(struct seq_file *seq)
+static void bond_info_show_aggregator(struct seq_file *seq)
 {
 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
 	const struct bond_opt_value *optval;
@@ -246,7 +246,7 @@ static int bond_info_seq_show(struct seq_file *seq, void *v)
 {
 	if (v == SEQ_START_TOKEN) {
 		seq_printf(seq, "%s\n", bond_version);
-		bond_info_show_master(seq);
+		bond_info_show_aggregator(seq);
 	} else
 		bond_info_show_link(seq, v);
 
diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
index 2b0715c6a7a4..0a4d095b8c3d 100644
--- a/drivers/net/bonding/bond_sysfs.c
+++ b/drivers/net/bonding/bond_sysfs.c
@@ -28,15 +28,8 @@
 
 #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))
 
-/* "show" function for the bond_masters attribute.
- * The class parameter is ignored.
- */
-static ssize_t bonding_show_bonds(struct class *cls,
-				  struct class_attribute *attr,
-				  char *buf)
+static ssize_t __bonding_show_bonds(struct bond_net *bn, char *buf)
 {
-	struct bond_net *bn =
-		container_of(attr, struct bond_net, class_attr_bonding_masters);
 	int res = 0;
 	struct bonding *bond;
 
@@ -59,6 +52,19 @@ static ssize_t bonding_show_bonds(struct class *cls,
 	return res;
 }
 
+/* "show" function for the bond_aggregators attribute.
+ * The class parameter is ignored.
+ */
+static ssize_t bonding_show_bonds(struct class *cls,
+				  struct class_attribute *attr,
+				  char *buf)
+{
+	struct bond_net *bn = container_of(attr, struct bond_net,
+					   class_attr_bonding_aggregators);
+
+	return __bonding_show_bonds(bn, buf);
+}
+
 static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifname)
 {
 	struct bonding *bond;
@@ -70,17 +76,9 @@ static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifna
 	return NULL;
 }
 
-/* "store" function for the bond_masters attribute.  This is what
- * creates and deletes entire bonds.
- *
- * The class parameter is ignored.
- */
-static ssize_t bonding_store_bonds(struct class *cls,
-				   struct class_attribute *attr,
-				   const char *buffer, size_t count)
+static ssize_t __bonding_store_bonds(struct bond_net *bn, const char *buffer,
+				     size_t count)
 {
-	struct bond_net *bn =
-		container_of(attr, struct bond_net, class_attr_bonding_masters);
 	char command[IFNAMSIZ + 1] = {0, };
 	char *ifname;
 	int rv, res = count;
@@ -123,20 +121,73 @@ static ssize_t bonding_store_bonds(struct class *cls,
 	return res;
 
 err_no_cmd:
-	pr_err("no command found in bonding_masters - use +ifname or -ifname\n");
+	pr_err("no command found - use +ifname or -ifname\n");
 	return -EPERM;
 }
 
-/* class attribute for bond_masters file.  This ends up in /sys/class/net */
-static const struct class_attribute class_attr_bonding_masters = {
+/* "store" function for the bond_aggregators attribute.  This is what
+ * creates and deletes entire bonds.
+ *
+ * The class parameter is ignored.
+ */
+static ssize_t bonding_store_bonds(struct class *cls,
+				   struct class_attribute *attr,
+				   const char *buffer, size_t count)
+{
+	struct bond_net *bn = container_of(attr, struct bond_net,
+					   class_attr_bonding_aggregators);
+
+	return __bonding_store_bonds(bn, buffer, count);
+}
+
+/* class attribute for bond_aggregators file.  This ends up in /sys/class/net */
+static const struct class_attribute class_attr_bonding_aggregators = {
 	.attr = {
-		.name = "bonding_masters",
+		.name = "bonding_aggregators",
 		.mode = 0644,
 	},
 	.show = bonding_show_bonds,
 	.store = bonding_store_bonds,
 };
 
+/* "show" function for the bond_masters attribute.
+ * The class parameter is ignored.
+ */
+static ssize_t bonding_show_bonds_legacy(struct class *cls,
+					 struct class_attribute *attr,
+					 char *buf)
+{
+	struct bond_net *bn = container_of(attr, struct bond_net,
+					   class_attr_bonding_masters);
+
+	return __bonding_show_bonds(bn, buf);
+}
+
+/* "store" function for the bond_masters attribute.  This is what
+ * creates and deletes entire bonds.
+ *
+ * The class parameter is ignored.
+ */
+static ssize_t bonding_store_bonds_legacy(struct class *cls,
+					  struct class_attribute *attr,
+					  const char *buffer, size_t count)
+{
+	struct bond_net *bn = container_of(attr, struct bond_net,
+					   class_attr_bonding_masters);
+
+	return __bonding_store_bonds(bn, buffer, count);
+}
+
+/* legacy sysfs interface name */
+static const struct class_attribute class_attr_bonding_masters = {
+	.attr = {
+		.name = "bonding_masters",
+		.mode = 0644,
+	},
+	.show = bonding_show_bonds_legacy,
+	.store = bonding_store_bonds_legacy,
+};
+
 /* Generic "store" method for bonding sysfs option setting */
 static ssize_t bonding_sysfs_store_option(struct device *d,
 					  struct device_attribute *attr,
@@ -785,22 +836,23 @@ static const struct attribute_group bonding_group = {
 	.attrs = per_bond_attrs,
 };
 
-/* Initialize sysfs.  This sets up the bonding_masters file in
- * /sys/class/net.
+/* Initialize sysfs.  This sets up the bonding_aggregators file in
+ * /sys/class/net and legacy compat bonding_masters, if enabled.
  */
 int bond_create_sysfs(struct bond_net *bn)
 {
 	int ret;
 
-	bn->class_attr_bonding_masters = class_attr_bonding_masters;
-	sysfs_attr_init(&bn->class_attr_bonding_masters.attr);
+	bn->class_attr_bonding_aggregators = class_attr_bonding_aggregators;
+	sysfs_attr_init(&bn->class_attr_bonding_aggregators.attr);
 
-	ret = netdev_class_create_file_ns(&bn->class_attr_bonding_masters,
+	ret = netdev_class_create_file_ns(&bn->class_attr_bonding_aggregators,
 					  bn->net);
+
 	/* Permit multiple loads of the module by ignoring failures to
-	 * create the bonding_masters sysfs file.  Bonding devices
+	 * create the bonding_aggregators sysfs file.  Bonding devices
 	 * created by second or subsequent loads of the module will
-	 * not be listed in, or controllable by, bonding_masters, but
+	 * not be listed in, or controllable by, bonding_aggregators, but
 	 * will have the usual "bonding" sysfs directory.
 	 *
 	 * This is done to preserve backwards compatibility for
@@ -808,7 +860,27 @@ int bond_create_sysfs(struct bond_net *bn)
 	 * configure multiple bonding devices.
 	 */
 	if (ret == -EEXIST) {
-		/* Is someone being kinky and naming a device bonding_master? */
+		/* Is someone naming a device bonding_aggregators? */
+		if (__dev_get_by_name(bn->net,
+				      class_attr_bonding_aggregators.attr.name))
+			pr_err("network device named %s already exists in sysfs\n",
+			       class_attr_bonding_aggregators.attr.name);
+		ret = 0;
+	}
+
+	if (ret) {
+		pr_err("%s: failure creating %s\n", __func__,
+		       class_attr_bonding_aggregators.attr.name);
+		return ret;
+	}
+
+	bn->class_attr_bonding_masters = class_attr_bonding_masters;
+	sysfs_attr_init(&bn->class_attr_bonding_masters.attr);
+
+	ret = netdev_class_create_file_ns(&bn->class_attr_bonding_masters,
+					  bn->net);
+	if (ret == -EEXIST) {
+		/* Is someone naming a device bonding_masters? */
 		if (__dev_get_by_name(bn->net,
 				      class_attr_bonding_masters.attr.name))
 			pr_err("network device named %s already exists in sysfs\n",
@@ -817,13 +889,15 @@ int bond_create_sysfs(struct bond_net *bn)
 	}
 
 	return ret;
-
 }
 
-/* Remove /sys/class/net/bonding_masters. */
+/* Remove /sys/class/net/bonding_aggregators and _masters. */
 void bond_destroy_sysfs(struct bond_net *bn)
 {
-	netdev_class_remove_file_ns(&bn->class_attr_bonding_masters, bn->net);
+	netdev_class_remove_file_ns(&bn->class_attr_bonding_masters,
+				    bn->net);
+	netdev_class_remove_file_ns(&bn->class_attr_bonding_aggregators,
+				    bn->net);
 }
 
 /* Initialize sysfs for each bond.  This sets up and registers
diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
index 63907aeb3884..98001b31d0dd 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
@@ -483,7 +483,7 @@ nfp_fl_lag_schedule_group_delete(struct nfp_fl_lag *lag,
 
 	priv = container_of(lag, struct nfp_flower_priv, nfp_lag);
 
-	if (!netif_is_bond_master(master))
+	if (!netif_is_bond_aggregator(master))
 		return;
 
 	mutex_lock(&lag->lock);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 8b7fc71dc9c7..346214c34a75 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -3216,7 +3216,7 @@ netxen_list_config_ip(struct netxen_adapter *adapter,
 			goto out;
 		if (is_vlan_dev(dev))
 			dev = vlan_dev_real_dev(dev);
-		cur->master = !!netif_is_bond_master(dev);
+		cur->master = !!netif_is_bond_aggregator(dev);
 		cur->ip_addr = ifa->ifa_address;
 		list_add_tail(&cur->list, &adapter->ip_list);
 		netxen_config_ipaddr(adapter, ifa->ifa_address, NX_IP_UP);
@@ -3322,7 +3322,7 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
 	 * Now we should program the bond's (and its vlans')
 	 * addresses in the netxen NIC.
 	 */
-	if (master && netif_is_bond_master(master) &&
+	if (master && netif_is_bond_aggregator(master) &&
 	    !netif_is_bond_link(dev)) {
 		netxen_config_indev_addr(adapter, master, event);
 		for_each_netdev_rcu(&init_net, slave)
@@ -3358,7 +3358,7 @@ static int netxen_netdev_event(struct notifier_block *this,
 	}
 	if (event == NETDEV_UP || event == NETDEV_DOWN) {
 		/* If this is a bonding device, look for netxen-based slaves*/
-		if (netif_is_bond_master(dev)) {
+		if (netif_is_bond_aggregator(dev)) {
 			rcu_read_lock();
 			for_each_netdev_in_bond_rcu(dev, slave) {
 				if (!netxen_config_checkdev(slave))
@@ -3403,7 +3403,7 @@ netxen_inetaddr_event(struct notifier_block *this,
 	}
 	if (event == NETDEV_UP || event == NETDEV_DOWN) {
 		/* If this is a bonding device, look for netxen-based slaves*/
-		if (netif_is_bond_master(dev)) {
+		if (netif_is_bond_aggregator(dev)) {
 			rcu_read_lock();
 			for_each_netdev_in_bond_rcu(dev, slave) {
 				if (!netxen_config_checkdev(slave))
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c55dc38709f6..beea679e3bdd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4802,7 +4802,7 @@ static inline bool netif_is_macvlan_port(const struct net_device *dev)
 	return dev->priv_flags & IFF_MACVLAN_PORT;
 }
 
-static inline bool netif_is_bond_master(const struct net_device *dev)
+static inline bool netif_is_bond_aggregator(const struct net_device *dev)
 {
 	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_BONDING;
 }
@@ -4869,7 +4869,7 @@ static inline bool netif_is_team_port(const struct net_device *dev)
 
 static inline bool netif_is_lag_master(const struct net_device *dev)
 {
-	return netif_is_bond_master(dev) || netif_is_team_master(dev);
+	return netif_is_bond_aggregator(dev) || netif_is_team_master(dev);
 }
 
 static inline bool netif_is_lag_port(const struct net_device *dev)
diff --git a/include/net/bonding.h b/include/net/bonding.h
index a23f6e5a6d87..af3fecc27a19 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -613,6 +613,7 @@ struct bond_net {
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry	*proc_dir;
 #endif
+	struct class_attribute	class_attr_bonding_aggregators;
 	struct class_attribute	class_attr_bonding_masters;
 };
 
-- 
2.27.0

