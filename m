Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FAE2AF9E2
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 21:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgKKUke convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Nov 2020 15:40:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36942 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgKKUke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 15:40:34 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kcwum-00042Q-T7; Wed, 11 Nov 2020 20:40:25 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 4B8715FEE8; Wed, 11 Nov 2020 12:40:23 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 44D1AA0409;
        Wed, 11 Nov 2020 12:40:23 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/5] bonding: replace use of the term master where possible
In-reply-to: <20201106200436.943795-3-jarod@redhat.com>
References: <20201106200436.943795-1-jarod@redhat.com> <20201106200436.943795-3-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 06 Nov 2020 15:04:33 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20660.1605127223.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 11 Nov 2020 12:40:23 -0800
Message-ID: <20661.1605127223@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Simply refer to what was the bonding "master" as the "bond" or bonding
>device, depending on context. However, do retain compat code for the
>bonding_masters sysfs interface to avoid breaking userspace.
>
>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/infiniband/core/cma.c                 |  2 +-
> drivers/infiniband/core/lag.c                 |  2 +-
> drivers/infiniband/core/roce_gid_mgmt.c       |  6 +-
> drivers/net/bonding/bond_3ad.c                |  2 +-
> drivers/net/bonding/bond_main.c               | 58 +++++++++----------
> drivers/net/bonding/bond_procfs.c             |  4 +-
> drivers/net/bonding/bond_sysfs.c              |  8 +--
> .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 ++--
> .../ethernet/netronome/nfp/flower/lag_conf.c  |  2 +-
> .../ethernet/qlogic/netxen/netxen_nic_main.c  |  8 +--
> include/linux/netdevice.h                     |  8 +--
> include/net/bonding.h                         |  4 +-
> 12 files changed, 58 insertions(+), 56 deletions(-)
>
>diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
>index a77750b8954d..3a1679d16e19 100644
>--- a/drivers/infiniband/core/cma.c
>+++ b/drivers/infiniband/core/cma.c
>@@ -4753,7 +4753,7 @@ static int cma_netdev_callback(struct notifier_block *self, unsigned long event,
> 	if (event != NETDEV_BONDING_FAILOVER)
> 		return NOTIFY_DONE;
> 
>-	if (!netif_is_bond_master(ndev))
>+	if (!netif_is_bond_dev(ndev))
> 		return NOTIFY_DONE;
> 
> 	mutex_lock(&lock);
>diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
>index 7063e41eaf26..2afaca2f9d0b 100644
>--- a/drivers/infiniband/core/lag.c
>+++ b/drivers/infiniband/core/lag.c
>@@ -128,7 +128,7 @@ struct net_device *rdma_lag_get_ah_roce_slave(struct ib_device *device,
> 	dev_hold(master);
> 	rcu_read_unlock();
> 
>-	if (!netif_is_bond_master(master))
>+	if (!netif_is_bond_dev(master))
> 		goto put;
> 
> 	slave = rdma_get_xmit_slave_udp(device, master, ah_attr, flags);
>diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniband/core/roce_gid_mgmt.c
>index 6b8364bb032d..e06cf51f1773 100644
>--- a/drivers/infiniband/core/roce_gid_mgmt.c
>+++ b/drivers/infiniband/core/roce_gid_mgmt.c
>@@ -129,7 +129,7 @@ enum bonding_slave_state {
> static enum bonding_slave_state is_eth_active_slave_of_bonding_rcu(struct net_device *dev,
> 								   struct net_device *upper)
> {
>-	if (upper && netif_is_bond_master(upper)) {
>+	if (upper && netif_is_bond_dev(upper)) {
> 		struct net_device *pdev =
> 			bond_option_active_slave_get_rcu(netdev_priv(upper));
> 
>@@ -216,7 +216,7 @@ is_ndev_for_default_gid_filter(struct ib_device *ib_dev, u8 port,
> 	 * make sure that it the upper netdevice of rdma netdevice.
> 	 */
> 	res = ((cookie_ndev == rdma_ndev && !netif_is_bond_slave(rdma_ndev)) ||
>-	       (netif_is_bond_master(cookie_ndev) &&
>+	       (netif_is_bond_dev(cookie_ndev) &&
> 		rdma_is_upper_dev_rcu(rdma_ndev, cookie_ndev)));
> 
> 	rcu_read_unlock();
>@@ -271,7 +271,7 @@ is_upper_ndev_bond_master_filter(struct ib_device *ib_dev, u8 port,
> 		return false;
> 
> 	rcu_read_lock();
>-	if (netif_is_bond_master(cookie_ndev) &&
>+	if (netif_is_bond_dev(cookie_ndev) &&
> 	    rdma_is_upper_dev_rcu(rdma_ndev, cookie_ndev))
> 		match = true;
> 	rcu_read_unlock();
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
>index 0eb717b0bfc6..852b9c4f6a47 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -2550,7 +2550,7 @@ void bond_3ad_handle_link_change(struct slave *slave, char link)
> }
> 
> /**
>- * bond_3ad_set_carrier - set link state for bonding master
>+ * bond_3ad_set_carrier - set link state for bonding device
>  * @bond: bonding structure
>  *
>  * if we have an active aggregator, we're up, if not, we're down.
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index d79643f6b01e..e9cc7d68f3b9 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -469,8 +469,8 @@ static const struct xfrmdev_ops bond_xfrmdev_ops = {
> 
> /*------------------------------- Link status -------------------------------*/
> 
>-/* Set the carrier state for the master according to the state of its
>- * slaves.  If any slaves are up, the master is up.  In 802.3ad mode,
>+/* Set the carrier state for the bond according to the state of its
>+ * slaves.  If any slaves are up, the bond is up.  In 802.3ad mode,
>  * do special 802.3ad magic.
>  *
>  * Returns zero if carrier state does not change, nonzero if it does.
>@@ -1372,7 +1372,7 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
> 	 * inactive slave links without being forced to bind to them
> 	 * explicitly.
> 	 *
>-	 * At the same time, packets that are passed to the bonding master
>+	 * At the same time, packets that are passed to the bonding bond
> 	 * (including link-local ones) can have their originating interface
> 	 * determined via PACKET_ORIGDEV socket option.
> 	 */

	The text "bonding bond" seems a bit awkward, and could be simply
"bond."

>@@ -1439,8 +1439,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
> 	}
> }
> 
>-static int bond_master_upper_dev_link(struct bonding *bond, struct slave *slave,
>-				      struct netlink_ext_ack *extack)
>+static int bond_upper_dev_link(struct bonding *bond, struct slave *slave,
>+			       struct netlink_ext_ack *extack)
> {
> 	struct netdev_lag_upper_info lag_upper_info;
> 	enum netdev_lag_tx_type type;
>@@ -1515,7 +1515,7 @@ static void bond_netdev_notify_work(struct work_struct *_work)
> 		struct netdev_bonding_info binfo;
> 
> 		bond_fill_ifslave(slave, &binfo.slave);
>-		bond_fill_ifbond(slave->bond, &binfo.master);
>+		bond_fill_ifbond(slave->bond, &binfo.bond);
> 		netdev_bonding_info_change(slave->dev, &binfo);
> 		rtnl_unlock();
> 	} else {
>@@ -1538,7 +1538,7 @@ void bond_lower_state_changed(struct slave *slave)
> 	netdev_lower_state_changed(slave->dev, &info);
> }
> 
>-/* enslave device <slave> to bond device <master> */
>+/* enslave device <slave> to bond device <bond> */
> int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 		 struct netlink_ext_ack *extack)
> {
>@@ -1667,7 +1667,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 
> 	call_netdevice_notifiers(NETDEV_JOIN, slave_dev);
> 
>-	/* If this is the first slave, then we need to set the master's hardware
>+	/* If this is the first slave, then we need to set the bond's hardware
> 	 * address to be the same as the slave's.
> 	 */
> 	if (!bond_has_slaves(bond) &&
>@@ -1700,15 +1700,15 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 
> 	/* Save slave's original ("permanent") mac address for modes
> 	 * that need it, and for restoring it upon release, and then
>-	 * set it to the master's address
>+	 * set it to the bond's address
> 	 */
> 	bond_hw_addr_copy(new_slave->perm_hwaddr, slave_dev->dev_addr,
> 			  slave_dev->addr_len);
> 
> 	if (!bond->params.fail_over_mac ||
> 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
>-		/* Set slave to master's mac address.  The application already
>-		 * set the master's mac address to that of the first slave
>+		/* Set slave to bond's mac address.  The application already
>+		 * set the bond's mac address to that of the first slave
> 		 */
> 		memcpy(ss.__data, bond_dev->dev_addr, bond_dev->addr_len);
> 		ss.ss_family = slave_dev->type;
>@@ -1874,7 +1874,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> #ifdef CONFIG_NET_POLL_CONTROLLER
> 	if (bond->dev->npinfo) {
> 		if (slave_enable_netpoll(new_slave)) {
>-			slave_info(bond_dev, slave_dev, "master_dev is using netpoll, but new slave device does not support netpoll\n");
>+			slave_info(bond_dev, slave_dev, "bond_dev is using netpoll, but new slave device does not support netpoll\n");
> 			res = -EBUSY;
> 			goto err_detach;
> 		}
>@@ -1891,9 +1891,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 		goto err_detach;
> 	}
> 
>-	res = bond_master_upper_dev_link(bond, new_slave, extack);
>+	res = bond_upper_dev_link(bond, new_slave, extack);
> 	if (res) {
>-		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_master_upper_dev_link\n", res);
>+		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_upper_dev_link\n", res);
> 		goto err_unregister;
> 	}
> 
>@@ -1984,7 +1984,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	slave_disable_netpoll(new_slave);
> 
> err_close:
>-	if (!netif_is_bond_master(slave_dev))
>+	if (!netif_is_bond_dev(slave_dev))
> 		slave_dev->priv_flags &= ~IFF_BONDING;
> 	dev_close(slave_dev);
> 
>@@ -1992,7 +1992,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	slave_dev->flags &= ~IFF_SLAVE;
> 	if (!bond->params.fail_over_mac ||
> 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
>-		/* XXX TODO - fom follow mode needs to change master's
>+		/* XXX TODO - fom follow mode needs to change bond's
> 		 * MAC if this slave's MAC is in use by the bond, or at
> 		 * least print a warning.
> 		 */
>@@ -2009,7 +2009,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	bond_free_slave(new_slave);
> 
> err_undo_flags:
>-	/* Enslave of first slave has failed and we need to fix master's mac */
>+	/* Enslave of first slave has failed and we need to fix bond's mac */
> 	if (!bond_has_slaves(bond)) {
> 		if (ether_addr_equal_64bits(bond_dev->dev_addr,
> 					    slave_dev->dev_addr))
>@@ -2025,7 +2025,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
> 	return res;
> }
> 
>-/* Try to release the slave device <slave> from the bond device <master>
>+/* Try to release the slave device <slave> from the bond device <bond>
>  * It is legal to access curr_active_slave without a lock because all the function
>  * is RTNL-locked. If "all" is true it means that the function is being called
>  * while destroying a bond interface and all slaves are being released.
>@@ -2046,7 +2046,7 @@ static int __bond_release_one(struct net_device *bond_dev,
> 	int old_flags = bond_dev->flags;
> 	netdev_features_t old_features = bond_dev->features;
> 
>-	/* slave is not a slave or master is not master of this slave */
>+	/* slave is not a slave or bond is not bond of this slave */
> 	if (!(slave_dev->flags & IFF_SLAVE) ||
> 	    !netdev_has_upper_dev(slave_dev, bond_dev)) {
> 		slave_dbg(bond_dev, slave_dev, "cannot release slave\n");
>@@ -2183,7 +2183,7 @@ static int __bond_release_one(struct net_device *bond_dev,
> 	else
> 		dev_set_mtu(slave_dev, slave->original_mtu);
> 
>-	if (!netif_is_bond_master(slave_dev))
>+	if (!netif_is_bond_dev(slave_dev))
> 		slave_dev->priv_flags &= ~IFF_BONDING;
> 
> 	bond_free_slave(slave);
>@@ -3255,8 +3255,8 @@ static int bond_event_changename(struct bonding *bond)
> 	return NOTIFY_DONE;
> }
> 
>-static int bond_master_netdev_event(unsigned long event,
>-				    struct net_device *bond_dev)
>+static int bond_dev_netdev_event(unsigned long event,
>+				 struct net_device *bond_dev)
> {
> 	struct bonding *event_bond = netdev_priv(bond_dev);
> 
>@@ -3379,7 +3379,7 @@ static int bond_slave_netdev_event(unsigned long event,
> 		bond_compute_features(bond);
> 		break;
> 	case NETDEV_RESEND_IGMP:
>-		/* Propagate to master device */
>+		/* Propagate to bond device */
> 		call_netdevice_notifiers(event, slave->bond->dev);
> 		break;
> 	default:
>@@ -3410,7 +3410,7 @@ static int bond_netdev_event(struct notifier_block *this,
> 	if (event_dev->flags & IFF_MASTER) {
> 		int ret;
> 
>-		ret = bond_master_netdev_event(event, event_dev);
>+		ret = bond_dev_netdev_event(event, event_dev);
> 		if (ret != NOTIFY_DONE)
> 			return ret;
> 	}
>@@ -3923,7 +3923,7 @@ static int bond_neigh_init(struct neighbour *n)
>  * slave exists. So we must declare proxy setup function which will
>  * be used at run time to resolve the actual slave neigh param setup.
>  *
>- * It's also called by master devices (such as vlans) to setup their
>+ * It's also called by upper-level devices (such as vlans) to setup their
>  * underlying devices. In that case - do nothing, we're already set up from
>  * our init.
>  */
>@@ -3937,7 +3937,7 @@ static int bond_neigh_setup(struct net_device *dev,
> 	return 0;
> }
> 
>-/* Change the MTU of all of a master's slaves to match the master */
>+/* Change the MTU of all of a bond's slaves to match the bond */
> static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
> {
> 	struct bonding *bond = netdev_priv(bond_dev);
>@@ -3992,7 +3992,7 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
> /* Change HW address
>  *
>  * Note that many devices must be down to change the HW address, and
>- * downing the master releases all slaves.  We can make bonds full of
>+ * downing the bond releases all slaves.  We can make bonds full of
>  * bonding devices to test this, however.
>  */
> static int bond_set_mac_address(struct net_device *bond_dev, void *addr)

	Terminology change aside, this comment is no longer factually
correct; setting the bond down has not released all slaves for quite a
while.

>@@ -4480,11 +4480,11 @@ static u16 bond_select_queue(struct net_device *dev, struct sk_buff *skb,
> 	return txq;
> }
> 
>-static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
>+static struct net_device *bond_xmit_get_slave(struct net_device *bond_dev,
> 					      struct sk_buff *skb,
> 					      bool all_slaves)
> {
>-	struct bonding *bond = netdev_priv(master_dev);
>+	struct bonding *bond = netdev_priv(bond_dev);
> 	struct bond_up_slave *slaves;
> 	struct slave *slave = NULL;
> 
>diff --git a/drivers/net/bonding/bond_procfs.c b/drivers/net/bonding/bond_procfs.c
>index 9017bc163088..2ac60cff9b3a 100644
>--- a/drivers/net/bonding/bond_procfs.c
>+++ b/drivers/net/bonding/bond_procfs.c
>@@ -54,7 +54,7 @@ static void bond_info_seq_stop(struct seq_file *seq, void *v)
> 	rcu_read_unlock();
> }
> 
>-static void bond_info_show_master(struct seq_file *seq)
>+static void bond_info_show_bond_dev(struct seq_file *seq)
> {
> 	struct bonding *bond = PDE_DATA(file_inode(seq->file));
> 	const struct bond_opt_value *optval;
>@@ -245,7 +245,7 @@ static int bond_info_seq_show(struct seq_file *seq, void *v)
> {
> 	if (v == SEQ_START_TOKEN) {
> 		seq_printf(seq, "%s\n", bond_version);
>-		bond_info_show_master(seq);
>+		bond_info_show_bond_dev(seq);
> 	} else
> 		bond_info_show_slave(seq, v);
> 
>diff --git a/drivers/net/bonding/bond_sysfs.c b/drivers/net/bonding/bond_sysfs.c
>index 2d615a93685e..f3b9db1a4a84 100644
>--- a/drivers/net/bonding/bond_sysfs.c
>+++ b/drivers/net/bonding/bond_sysfs.c
>@@ -28,7 +28,7 @@
> 
> #define to_bond(cd)	((struct bonding *)(netdev_priv(to_net_dev(cd))))
> 
>-/* "show" function for the bond_masters attribute.
>+/* "show" function for the bonding_masters attribute.
>  * The class parameter is ignored.
>  */
> static ssize_t bonding_show_bonds(struct class *cls,
>@@ -70,7 +70,7 @@ static struct net_device *bond_get_by_name(struct bond_net *bn, const char *ifna
> 	return NULL;
> }
> 
>-/* "store" function for the bond_masters attribute.  This is what
>+/* "store" function for the bonding_masters attribute.  This is what
>  * creates and deletes entire bonds.
>  *
>  * The class parameter is ignored.
>@@ -127,7 +127,7 @@ static ssize_t bonding_store_bonds(struct class *cls,
> 	return -EPERM;
> }
> 
>-/* class attribute for bond_masters file.  This ends up in /sys/class/net */
>+/* class attribute for bonding_masters file.  This ends up in /sys/class/net */
> static const struct class_attribute class_attr_bonding_masters = {
> 	.attr = {
> 		.name = "bonding_masters",
>@@ -788,7 +788,7 @@ int bond_create_sysfs(struct bond_net *bn)
> 	 * configure multiple bonding devices.
> 	 */
> 	if (ret == -EEXIST) {
>-		/* Is someone being kinky and naming a device bonding_master? */
>+		/* Is someone naming a device bonding_masters? */
> 		if (__dev_get_by_name(bn->net,
> 				      class_attr_bonding_masters.attr.name))
> 			pr_err("network device named %s already exists in sysfs\n",
>diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>index 106513f772c3..598aaf8ae7ae 100644
>--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
>@@ -2982,18 +2982,18 @@ int mlx4_en_netdev_event(struct notifier_block *this,
> 			&notifier_info->bonding_info;
> 
> 		/* required mode 1, 2 or 4 */
>-		if ((bonding_info->master.bond_mode != BOND_MODE_ACTIVEBACKUP) &&
>-		    (bonding_info->master.bond_mode != BOND_MODE_XOR) &&
>-		    (bonding_info->master.bond_mode != BOND_MODE_8023AD))
>+		if ((bonding_info->bond.bond_mode != BOND_MODE_ACTIVEBACKUP) &&
>+		    (bonding_info->bond.bond_mode != BOND_MODE_XOR) &&
>+		    (bonding_info->bond.bond_mode != BOND_MODE_8023AD))
> 			do_bond = false;
> 
> 		/* require exactly 2 slaves */
>-		if (bonding_info->master.num_slaves != 2)
>+		if (bonding_info->bond.num_slaves != 2)
> 			do_bond = false;
> 
> 		/* calc v2p */
> 		if (do_bond) {
>-			if (bonding_info->master.bond_mode ==
>+			if (bonding_info->bond.bond_mode ==
> 			    BOND_MODE_ACTIVEBACKUP) {
> 				/* in active-backup mode virtual ports are
> 				 * mapped to the physical port of the active
>diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
>index 63907aeb3884..431d696c9ac4 100644
>--- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
>+++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
>@@ -483,7 +483,7 @@ nfp_fl_lag_schedule_group_delete(struct nfp_fl_lag *lag,
> 
> 	priv = container_of(lag, struct nfp_flower_priv, nfp_lag);
> 
>-	if (!netif_is_bond_master(master))
>+	if (!netif_is_bond_dev(master))
> 		return;
> 
> 	mutex_lock(&lag->lock);
>diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
>index f21847739ef1..aa28a7d8e2ea 100644
>--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
>+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
>@@ -3216,7 +3216,7 @@ netxen_list_config_ip(struct netxen_adapter *adapter,
> 			goto out;
> 		if (is_vlan_dev(dev))
> 			dev = vlan_dev_real_dev(dev);
>-		cur->master = !!netif_is_bond_master(dev);
>+		cur->master = !!netif_is_bond_dev(dev);
> 		cur->ip_addr = ifa->ifa_address;
> 		list_add_tail(&cur->list, &adapter->ip_list);
> 		netxen_config_ipaddr(adapter, ifa->ifa_address, NX_IP_UP);
>@@ -3322,7 +3322,7 @@ static void netxen_config_master(struct net_device *dev, unsigned long event)
> 	 * Now we should program the bond's (and its vlans')
> 	 * addresses in the netxen NIC.
> 	 */
>-	if (master && netif_is_bond_master(master) &&
>+	if (master && netif_is_bond_dev(master) &&
> 	    !netif_is_bond_slave(dev)) {
> 		netxen_config_indev_addr(adapter, master, event);
> 		for_each_netdev_rcu(&init_net, slave)
>@@ -3358,7 +3358,7 @@ static int netxen_netdev_event(struct notifier_block *this,
> 	}
> 	if (event == NETDEV_UP || event == NETDEV_DOWN) {
> 		/* If this is a bonding device, look for netxen-based slaves*/
>-		if (netif_is_bond_master(dev)) {
>+		if (netif_is_bond_dev(dev)) {
> 			rcu_read_lock();
> 			for_each_netdev_in_bond_rcu(dev, slave) {
> 				if (!netxen_config_checkdev(slave))
>@@ -3403,7 +3403,7 @@ netxen_inetaddr_event(struct notifier_block *this,
> 	}
> 	if (event == NETDEV_UP || event == NETDEV_DOWN) {
> 		/* If this is a bonding device, look for netxen-based slaves*/
>-		if (netif_is_bond_master(dev)) {
>+		if (netif_is_bond_dev(dev)) {
> 			rcu_read_lock();
> 			for_each_netdev_in_bond_rcu(dev, slave) {
> 				if (!netxen_config_checkdev(slave))
>diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>index a53ed2d1ed1d..18db678ac85c 100644
>--- a/include/linux/netdevice.h
>+++ b/include/linux/netdevice.h
>@@ -1501,7 +1501,7 @@ struct net_device_ops {
>  *
>  * @IFF_802_1Q_VLAN: 802.1Q VLAN device
>  * @IFF_EBRIDGE: Ethernet bridging device
>- * @IFF_BONDING: bonding master or slave
>+ * @IFF_BONDING: bonding netdev or slave
>  * @IFF_ISATAP: ISATAP interface (RFC4214)
>  * @IFF_WAN_HDLC: WAN HDLC device
>  * @IFF_XMIT_DST_RELEASE: dev_hard_start_xmit() is allowed to
>@@ -4668,7 +4668,7 @@ struct sk_buff *skb_mac_gso_segment(struct sk_buff *skb,
> 
> struct netdev_bonding_info {
> 	ifslave	slave;
>-	ifbond	master;
>+	ifbond	bond;
> };
> 
> struct netdev_notifier_bonding_info {
>@@ -4892,7 +4892,7 @@ static inline bool netif_is_macvlan_port(const struct net_device *dev)
> 	return dev->priv_flags & IFF_MACVLAN_PORT;
> }
> 
>-static inline bool netif_is_bond_master(const struct net_device *dev)
>+static inline bool netif_is_bond_dev(const struct net_device *dev)
> {
> 	return dev->flags & IFF_MASTER && dev->priv_flags & IFF_BONDING;
> }
>@@ -4959,7 +4959,7 @@ static inline bool netif_is_team_port(const struct net_device *dev)
> 
> static inline bool netif_is_lag_master(const struct net_device *dev)
> {
>-	return netif_is_bond_master(dev) || netif_is_team_master(dev);
>+	return netif_is_bond_dev(dev) || netif_is_team_master(dev);
> }
> 
> static inline bool netif_is_lag_port(const struct net_device *dev)
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index 7d132cc1e584..bf4f0e1dc2bf 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -156,7 +156,7 @@ struct bond_parm_tbl {
> 
> struct slave {
> 	struct net_device *dev; /* first - useful for panic debug */
>-	struct bonding *bond; /* our master */
>+	struct bonding *bond; /* our bond link aggregator */

	Perhaps "bond we are a port of"?  The term "aggregator" implies
LACP in my mind.

> 	int    delay;
> 	/* all three in jiffies */
> 	unsigned long last_link_up;
>@@ -613,7 +613,9 @@ struct bond_net {
> #ifdef CONFIG_PROC_FS
> 	struct proc_dir_entry	*proc_dir;
> #endif
>+	/* _masters is a legacy interface identical to _devs */
> 	struct class_attribute	class_attr_bonding_masters;
>+	struct class_attribute	class_attr_bonding_devs;

	Is class_attr_bonding_devs used anywhere?  Is this perhaps left
over from a prior version of the patch set?

	-J

> };
> 
> int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
>-- 
>2.28.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
