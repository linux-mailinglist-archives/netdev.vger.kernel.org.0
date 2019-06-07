Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD1138E35
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729591AbfFGPAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51674 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfFGPAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:00:18 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E544E307D98A;
        Fri,  7 Jun 2019 15:00:12 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2352282F59;
        Fri,  7 Jun 2019 15:00:12 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>, Joe Perches <joe@perches.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 4/7] bonding/main: convert to using slave printk macros
Date:   Fri,  7 Jun 2019 10:59:29 -0400
Message-Id: <20190607145933.37058-5-jarod@redhat.com>
In-Reply-To: <20190607145933.37058-1-jarod@redhat.com>
References: <20190607145933.37058-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 07 Jun 2019 15:00:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All of these printk instances benefit from having both master and slave
device information included, so convert to using a standardized macro
format and remove redundant information.

Suggested-by: Joe Perches <joe@perches.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 306 +++++++++++++++-----------------
 1 file changed, 139 insertions(+), 167 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5823070f07a6..cad371ae18bc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -613,8 +613,8 @@ static int bond_set_dev_addr(struct net_device *bond_dev,
 {
 	int err;
 
-	netdev_dbg(bond_dev, "bond_dev=%p slave_dev=%p slave_dev->name=%s slave_dev->addr_len=%d\n",
-		   bond_dev, slave_dev, slave_dev->name, slave_dev->addr_len);
+	slave_dbg(bond_dev, slave_dev, "bond_dev=%p slave_dev=%p slave_dev->addr_len=%d\n",
+		  bond_dev, slave_dev, slave_dev->addr_len);
 	err = dev_pre_changeaddr_notify(bond_dev, slave_dev->dev_addr, NULL);
 	if (err)
 		return err;
@@ -661,8 +661,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		if (new_active) {
 			rv = bond_set_dev_addr(bond->dev, new_active->dev);
 			if (rv)
-				netdev_err(bond->dev, "Error %d setting bond MAC from slave %s\n",
-					   -rv, new_active->dev->name);
+				slave_err(bond->dev, new_active->dev, "Error %d setting bond MAC from slave\n",
+					  -rv);
 		}
 		break;
 	case BOND_FOM_FOLLOW:
@@ -692,8 +692,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(new_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv) {
-			netdev_err(bond->dev, "Error %d setting MAC of new active slave %s\n",
-				   -rv, new_active->dev->name);
+			slave_err(bond->dev, new_active->dev, "Error %d setting MAC of new active slave\n",
+				  -rv);
 			goto out;
 		}
 
@@ -707,8 +707,8 @@ static void bond_do_fail_over_mac(struct bonding *bond,
 		rv = dev_set_mac_address(old_active->dev,
 					 (struct sockaddr *)&ss, NULL);
 		if (rv)
-			netdev_err(bond->dev, "Error %d setting MAC of old active slave %s\n",
-				   -rv, old_active->dev->name);
+			slave_err(bond->dev, old_active->dev, "Error %d setting MAC of old active slave\n",
+				  -rv);
 out:
 		break;
 	default:
@@ -834,9 +834,8 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 
 		if (new_active->link == BOND_LINK_BACK) {
 			if (bond_uses_primary(bond)) {
-				netdev_info(bond->dev, "making interface %s the new active one %d ms earlier\n",
-					    new_active->dev->name,
-					    (bond->params.updelay - new_active->delay) * bond->params.miimon);
+				slave_info(bond->dev, new_active->dev, "making interface the new active one %d ms earlier\n",
+					   (bond->params.updelay - new_active->delay) * bond->params.miimon);
 			}
 
 			new_active->delay = 0;
@@ -850,8 +849,7 @@ void bond_change_active_slave(struct bonding *bond, struct slave *new_active)
 				bond_alb_handle_link_change(bond, new_active, BOND_LINK_UP);
 		} else {
 			if (bond_uses_primary(bond)) {
-				netdev_info(bond->dev, "making interface %s the new active one\n",
-					    new_active->dev->name);
+				slave_info(bond->dev, new_active->dev, "making interface the new active one\n");
 			}
 		}
 	}
@@ -939,7 +937,7 @@ void bond_select_active_slave(struct bonding *bond)
 			return;
 
 		if (netif_carrier_ok(bond->dev))
-			netdev_info(bond->dev, "first active interface up!\n");
+			slave_info(bond->dev, best_slave->dev, "active interface up!\n");
 		else
 			netdev_info(bond->dev, "now running without any active interface!\n");
 	}
@@ -1369,15 +1367,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (!bond->params.use_carrier &&
 	    slave_dev->ethtool_ops->get_link == NULL &&
 	    slave_ops->ndo_do_ioctl == NULL) {
-		netdev_warn(bond_dev, "no link monitoring support for %s\n",
-			    slave_dev->name);
+		slave_warn(bond_dev, slave_dev, "no link monitoring support\n");
 	}
 
 	/* already in-use? */
 	if (netdev_is_rx_handler_busy(slave_dev)) {
 		NL_SET_ERR_MSG(extack, "Device is in use and cannot be enslaved");
-		netdev_err(bond_dev,
-			   "Error: Device is in use and cannot be enslaved\n");
+		slave_err(bond_dev, slave_dev,
+			  "Error: Device is in use and cannot be enslaved\n");
 		return -EBUSY;
 	}
 
@@ -1390,21 +1387,16 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	/* vlan challenged mutual exclusion */
 	/* no need to lock since we're protected by rtnl_lock */
 	if (slave_dev->features & NETIF_F_VLAN_CHALLENGED) {
-		netdev_dbg(bond_dev, "%s is NETIF_F_VLAN_CHALLENGED\n",
-			   slave_dev->name);
+		slave_dbg(bond_dev, slave_dev, "is NETIF_F_VLAN_CHALLENGED\n");
 		if (vlan_uses_dev(bond_dev)) {
 			NL_SET_ERR_MSG(extack, "Can not enslave VLAN challenged device to VLAN enabled bond");
-			netdev_err(bond_dev, "Error: cannot enslave VLAN challenged slave %s on VLAN enabled bond %s\n",
-				   slave_dev->name, bond_dev->name);
+			slave_err(bond_dev, slave_dev, "Error: cannot enslave VLAN challenged slave on VLAN enabled bond\n");
 			return -EPERM;
 		} else {
-			netdev_warn(bond_dev, "enslaved VLAN challenged slave %s. Adding VLANs will be blocked as long as %s is part of bond %s\n",
-				    slave_dev->name, slave_dev->name,
-				    bond_dev->name);
+			slave_warn(bond_dev, slave_dev, "enslaved VLAN challenged slave. Adding VLANs will be blocked as long as it is part of bond.\n");
 		}
 	} else {
-		netdev_dbg(bond_dev, "%s is !NETIF_F_VLAN_CHALLENGED\n",
-			   slave_dev->name);
+		slave_dbg(bond_dev, slave_dev, "is !NETIF_F_VLAN_CHALLENGED\n");
 	}
 
 	/* Old ifenslave binaries are no longer supported.  These can
@@ -1414,8 +1406,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	 */
 	if (slave_dev->flags & IFF_UP) {
 		NL_SET_ERR_MSG(extack, "Device can not be enslaved while up");
-		netdev_err(bond_dev, "%s is up - this may be due to an out of date ifenslave\n",
-			   slave_dev->name);
+		slave_err(bond_dev, slave_dev, "slave is up - this may be due to an out of date ifenslave\n");
 		return -EPERM;
 	}
 
@@ -1428,14 +1419,14 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	 */
 	if (!bond_has_slaves(bond)) {
 		if (bond_dev->type != slave_dev->type) {
-			netdev_dbg(bond_dev, "change device type from %d to %d\n",
-				   bond_dev->type, slave_dev->type);
+			slave_dbg(bond_dev, slave_dev, "change device type from %d to %d\n",
+				  bond_dev->type, slave_dev->type);
 
 			res = call_netdevice_notifiers(NETDEV_PRE_TYPE_CHANGE,
 						       bond_dev);
 			res = notifier_to_errno(res);
 			if (res) {
-				netdev_err(bond_dev, "refused to change device type\n");
+				slave_err(bond_dev, slave_dev, "refused to change device type\n");
 				return -EBUSY;
 			}
 
@@ -1455,31 +1446,31 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		}
 	} else if (bond_dev->type != slave_dev->type) {
 		NL_SET_ERR_MSG(extack, "Device type is different from other slaves");
-		netdev_err(bond_dev, "%s ether type (%d) is different from other slaves (%d), can not enslave it\n",
-			   slave_dev->name, slave_dev->type, bond_dev->type);
+		slave_err(bond_dev, slave_dev, "ether type (%d) is different from other slaves (%d), can not enslave it\n",
+			  slave_dev->type, bond_dev->type);
 		return -EINVAL;
 	}
 
 	if (slave_dev->type == ARPHRD_INFINIBAND &&
 	    BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP) {
 		NL_SET_ERR_MSG(extack, "Only active-backup mode is supported for infiniband slaves");
-		netdev_warn(bond_dev, "Type (%d) supports only active-backup mode\n",
-			    slave_dev->type);
+		slave_warn(bond_dev, slave_dev, "Type (%d) supports only active-backup mode\n",
+			   slave_dev->type);
 		res = -EOPNOTSUPP;
 		goto err_undo_flags;
 	}
 
 	if (!slave_ops->ndo_set_mac_address ||
 	    slave_dev->type == ARPHRD_INFINIBAND) {
-		netdev_warn(bond_dev, "The slave device specified does not support setting the MAC address\n");
+		slave_warn(bond_dev, slave_dev, "The slave device specified does not support setting the MAC address\n");
 		if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP &&
 		    bond->params.fail_over_mac != BOND_FOM_ACTIVE) {
 			if (!bond_has_slaves(bond)) {
 				bond->params.fail_over_mac = BOND_FOM_ACTIVE;
-				netdev_warn(bond_dev, "Setting fail_over_mac to active for active-backup mode\n");
+				slave_warn(bond_dev, slave_dev, "Setting fail_over_mac to active for active-backup mode\n");
 			} else {
 				NL_SET_ERR_MSG(extack, "Slave device does not support setting the MAC address, but fail_over_mac is not set to active");
-				netdev_err(bond_dev, "The slave device specified does not support setting the MAC address, but fail_over_mac is not set to active\n");
+				slave_err(bond_dev, slave_dev, "The slave device specified does not support setting the MAC address, but fail_over_mac is not set to active\n");
 				res = -EOPNOTSUPP;
 				goto err_undo_flags;
 			}
@@ -1515,7 +1506,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	new_slave->original_mtu = slave_dev->mtu;
 	res = dev_set_mtu(slave_dev, bond->dev->mtu);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu\n", res);
+		slave_err(bond_dev, slave_dev, "Error %d calling dev_set_mtu\n", res);
 		goto err_free;
 	}
 
@@ -1536,7 +1527,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		res = dev_set_mac_address(slave_dev, (struct sockaddr *)&ss,
 					  extack);
 		if (res) {
-			netdev_dbg(bond_dev, "Error %d calling set_mac_address\n", res);
+			slave_err(bond_dev, slave_dev, "Error %d calling set_mac_address\n", res);
 			goto err_restore_mtu;
 		}
 	}
@@ -1547,7 +1538,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	/* open the slave since the application closed it */
 	res = dev_open(slave_dev, extack);
 	if (res) {
-		netdev_dbg(bond_dev, "Opening slave %s failed\n", slave_dev->name);
+		slave_err(bond_dev, slave_dev, "Opening slave failed\n");
 		goto err_restore_mac;
 	}
 
@@ -1566,8 +1557,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	res = vlan_vids_add_by_dev(slave_dev, bond_dev);
 	if (res) {
-		netdev_err(bond_dev, "Couldn't add bond vlan ids to %s\n",
-			   slave_dev->name);
+		slave_err(bond_dev, slave_dev, "Couldn't add bond vlan ids\n");
 		goto err_close;
 	}
 
@@ -1597,12 +1587,10 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			 * supported); thus, we don't need to change
 			 * the messages for netif_carrier.
 			 */
-			netdev_warn(bond_dev, "MII and ETHTOOL support not available for interface %s, and arp_interval/arp_ip_target module parameters not specified, thus bonding will not detect link failures! see bonding.txt for details\n",
-				    slave_dev->name);
+			slave_warn(bond_dev, slave_dev, "MII and ETHTOOL support not available for slave, and arp_interval/arp_ip_target module parameters not specified, thus bonding will not detect link failures! see bonding.txt for details\n");
 		} else if (link_reporting == -1) {
 			/* unable get link status using mii/ethtool */
-			netdev_warn(bond_dev, "can't get link status from interface %s; the network driver associated with this interface does not support MII or ETHTOOL link status reporting, thus miimon has no effect on this interface\n",
-				    slave_dev->name);
+			slave_warn(bond_dev, slave_dev, "can't get link status from slave; the network driver associated with this interface does not support MII or ETHTOOL link status reporting, thus miimon has no effect on this interface\n");
 		}
 	}
 
@@ -1636,9 +1624,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (new_slave->link != BOND_LINK_DOWN)
 		new_slave->last_link_up = jiffies;
-	netdev_dbg(bond_dev, "Initial state of slave_dev is BOND_LINK_%s\n",
-		   new_slave->link == BOND_LINK_DOWN ? "DOWN" :
-		   (new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
+	slave_dbg(bond_dev, slave_dev, "Initial state of slave is BOND_LINK_%s\n",
+		  new_slave->link == BOND_LINK_DOWN ? "DOWN" :
+		  (new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
 	if (bond_uses_primary(bond) && bond->params.primary[0]) {
 		/* if there is a primary slave, remember it */
@@ -1679,7 +1667,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		bond_set_slave_inactive_flags(new_slave, BOND_SLAVE_NOTIFY_NOW);
 		break;
 	default:
-		netdev_dbg(bond_dev, "This slave is always active in trunk mode\n");
+		slave_dbg(bond_dev, slave_dev, "This slave is always active in trunk mode\n");
 
 		/* always active in trunk mode */
 		bond_set_active_slave(new_slave);
@@ -1698,7 +1686,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	if (bond->dev->npinfo) {
 		if (slave_enable_netpoll(new_slave)) {
-			netdev_info(bond_dev, "master_dev is using netpoll, but new slave device does not support netpoll\n");
+			slave_info(bond_dev, slave_dev, "master_dev is using netpoll, but new slave device does not support netpoll\n");
 			res = -EBUSY;
 			goto err_detach;
 		}
@@ -1711,19 +1699,19 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
 					 new_slave);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling netdev_rx_handler_register\n", res);
+		slave_dbg(bond_dev, slave_dev, "Error %d calling netdev_rx_handler_register\n", res);
 		goto err_detach;
 	}
 
 	res = bond_master_upper_dev_link(bond, new_slave, extack);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling bond_master_upper_dev_link\n", res);
+		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_master_upper_dev_link\n", res);
 		goto err_unregister;
 	}
 
 	res = bond_sysfs_slave_add(new_slave);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling bond_sysfs_slave_add\n", res);
+		slave_dbg(bond_dev, slave_dev, "Error %d calling bond_sysfs_slave_add\n", res);
 		goto err_upper_unlink;
 	}
 
@@ -1777,10 +1765,9 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		bond_update_slave_arr(bond, NULL);
 
 
-	netdev_info(bond_dev, "Enslaving %s as %s interface with %s link\n",
-		    slave_dev->name,
-		    bond_is_active_slave(new_slave) ? "an active" : "a backup",
-		    new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
+	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
+		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
+		   new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
 
 	/* enslave is successful */
 	bond_queue_slave_event(new_slave);
@@ -1875,8 +1862,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
 	    !netdev_has_upper_dev(slave_dev, bond_dev)) {
-		netdev_dbg(bond_dev, "cannot release %s\n",
-			   slave_dev->name);
+		slave_dbg(bond_dev, slave_dev, "cannot release slave\n");
 		return -EINVAL;
 	}
 
@@ -1885,8 +1871,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	slave = bond_get_slave_by_dev(bond, slave_dev);
 	if (!slave) {
 		/* not a slave of this bond */
-		netdev_info(bond_dev, "%s not enslaved\n",
-			    slave_dev->name);
+		slave_info(bond_dev, slave_dev, "interface not enslaved\n");
 		unblock_netpoll_tx();
 		return -EINVAL;
 	}
@@ -1910,9 +1895,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, slave);
 
-	netdev_info(bond_dev, "Releasing %s interface %s\n",
-		    bond_is_active_slave(slave) ? "active" : "backup",
-		    slave_dev->name);
+	slave_info(bond_dev, slave_dev, "Releasing %s interface\n",
+		    bond_is_active_slave(slave) ? "active" : "backup");
 
 	oldcurrent = rcu_access_pointer(bond->curr_active_slave);
 
@@ -1922,9 +1906,8 @@ static int __bond_release_one(struct net_device *bond_dev,
 		     BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)) {
 		if (ether_addr_equal_64bits(bond_dev->dev_addr, slave->perm_hwaddr) &&
 		    bond_has_slaves(bond))
-			netdev_warn(bond_dev, "the permanent HWaddr of %s - %pM - is still in use by %s - set the HWaddr of %s to a different address to avoid conflicts\n",
-				    slave_dev->name, slave->perm_hwaddr,
-				    bond_dev->name, slave_dev->name);
+			slave_warn(bond_dev, slave_dev, "the permanent HWaddr of slave - %pM - is still in use by bond - set the HWaddr of slave to a different address to avoid conflicts\n",
+				   slave->perm_hwaddr);
 	}
 
 	if (rtnl_dereference(bond->primary_slave) == slave)
@@ -1972,8 +1955,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	bond_compute_features(bond);
 	if (!(bond_dev->features & NETIF_F_VLAN_CHALLENGED) &&
 	    (old_features & NETIF_F_VLAN_CHALLENGED))
-		netdev_info(bond_dev, "last VLAN challenged slave %s left bond %s - VLAN blocking is removed\n",
-			    slave_dev->name, bond_dev->name);
+		slave_info(bond_dev, slave_dev, "last VLAN challenged slave left bond - VLAN blocking is removed\n");
 
 	vlan_vids_del_by_dev(slave_dev, bond_dev);
 
@@ -2033,8 +2015,8 @@ int bond_release(struct net_device *bond_dev, struct net_device *slave_dev)
 /* First release a slave and then destroy the bond if no more slaves are left.
  * Must be under rtnl_lock when this function is called.
  */
-static int  bond_release_and_destroy(struct net_device *bond_dev,
-				     struct net_device *slave_dev)
+static int bond_release_and_destroy(struct net_device *bond_dev,
+				    struct net_device *slave_dev)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	int ret;
@@ -2042,8 +2024,7 @@ static int  bond_release_and_destroy(struct net_device *bond_dev,
 	ret = __bond_release_one(bond_dev, slave_dev, false, true);
 	if (ret == 0 && !bond_has_slaves(bond)) {
 		bond_dev->priv_flags |= IFF_DISABLE_NETPOLL;
-		netdev_info(bond_dev, "Destroying bond %s\n",
-			    bond_dev->name);
+		netdev_info(bond_dev, "Destroying bond\n");
 		bond_remove_proc_entry(bond);
 		unregister_netdevice(bond_dev);
 	}
@@ -2101,13 +2082,12 @@ static int bond_miimon_inspect(struct bonding *bond)
 			commit++;
 			slave->delay = bond->params.downdelay;
 			if (slave->delay) {
-				netdev_info(bond->dev, "link status down for %sinterface %s, disabling it in %d ms\n",
-					    (BOND_MODE(bond) ==
-					     BOND_MODE_ACTIVEBACKUP) ?
-					     (bond_is_active_slave(slave) ?
-					      "active " : "backup ") : "",
-					    slave->dev->name,
-					    bond->params.downdelay * bond->params.miimon);
+				slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
+					   (BOND_MODE(bond) ==
+					    BOND_MODE_ACTIVEBACKUP) ?
+					    (bond_is_active_slave(slave) ?
+					     "active " : "backup ") : "",
+					   bond->params.downdelay * bond->params.miimon);
 			}
 			/*FALLTHRU*/
 		case BOND_LINK_FAIL:
@@ -2115,10 +2095,9 @@ static int bond_miimon_inspect(struct bonding *bond)
 				/* recovered before downdelay expired */
 				bond_propose_link_state(slave, BOND_LINK_UP);
 				slave->last_link_up = jiffies;
-				netdev_info(bond->dev, "link status up again after %d ms for interface %s\n",
-					    (bond->params.downdelay - slave->delay) *
-					    bond->params.miimon,
-					    slave->dev->name);
+				slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
+					   (bond->params.downdelay - slave->delay) *
+					   bond->params.miimon);
 				commit++;
 				continue;
 			}
@@ -2141,20 +2120,18 @@ static int bond_miimon_inspect(struct bonding *bond)
 			slave->delay = bond->params.updelay;
 
 			if (slave->delay) {
-				netdev_info(bond->dev, "link status up for interface %s, enabling it in %d ms\n",
-					    slave->dev->name,
-					    ignore_updelay ? 0 :
-					    bond->params.updelay *
-					    bond->params.miimon);
+				slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
+					   ignore_updelay ? 0 :
+					   bond->params.updelay *
+					   bond->params.miimon);
 			}
 			/*FALLTHRU*/
 		case BOND_LINK_BACK:
 			if (!link_state) {
 				bond_propose_link_state(slave, BOND_LINK_DOWN);
-				netdev_info(bond->dev, "link status down again after %d ms for interface %s\n",
-					    (bond->params.updelay - slave->delay) *
-					    bond->params.miimon,
-					    slave->dev->name);
+				slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
+					   (bond->params.updelay - slave->delay) *
+					   bond->params.miimon);
 				commit++;
 				continue;
 			}
@@ -2210,9 +2187,8 @@ static void bond_miimon_commit(struct bonding *bond)
 			    bond_needs_speed_duplex(bond)) {
 				slave->link = BOND_LINK_DOWN;
 				if (net_ratelimit())
-					netdev_warn(bond->dev,
-						    "failed to get link speed/duplex for %s\n",
-						    slave->dev->name);
+					slave_warn(bond->dev, slave->dev,
+						   "failed to get link speed/duplex\n");
 				continue;
 			}
 			bond_set_slave_link_state(slave, BOND_LINK_UP,
@@ -2231,10 +2207,9 @@ static void bond_miimon_commit(struct bonding *bond)
 				bond_set_backup_slave(slave);
 			}
 
-			netdev_info(bond->dev, "link status definitely up for interface %s, %u Mbps %s duplex\n",
-				    slave->dev->name,
-				    slave->speed == SPEED_UNKNOWN ? 0 : slave->speed,
-				    slave->duplex ? "full" : "half");
+			slave_info(bond->dev, slave->dev, "link status definitely up, %u Mbps %s duplex\n",
+				   slave->speed == SPEED_UNKNOWN ? 0 : slave->speed,
+				   slave->duplex ? "full" : "half");
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
@@ -2255,8 +2230,7 @@ static void bond_miimon_commit(struct bonding *bond)
 				bond_set_slave_inactive_flags(slave,
 							      BOND_SLAVE_NOTIFY_NOW);
 
-			netdev_info(bond->dev, "link status definitely down for interface %s, disabling it\n",
-				    slave->dev->name);
+			slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_DOWN);
 
@@ -2266,8 +2240,8 @@ static void bond_miimon_commit(struct bonding *bond)
 			continue;
 
 		default:
-			netdev_err(bond->dev, "invalid new link %d on slave %s\n",
-				   slave->new_link, slave->dev->name);
+			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
+				  slave->new_link);
 			slave->new_link = BOND_LINK_NOCHANGE;
 
 			continue;
@@ -2364,15 +2338,16 @@ static bool bond_has_this_ip(struct bonding *bond, __be32 ip)
  * switches in VLAN mode (especially if ports are configured as
  * "native" to a VLAN) might not pass non-tagged frames.
  */
-static void bond_arp_send(struct net_device *slave_dev, int arp_op,
-			  __be32 dest_ip, __be32 src_ip,
-			  struct bond_vlan_tag *tags)
+static void bond_arp_send(struct slave *slave, int arp_op, __be32 dest_ip,
+			  __be32 src_ip, struct bond_vlan_tag *tags)
 {
 	struct sk_buff *skb;
 	struct bond_vlan_tag *outer_tag = tags;
+	struct net_device *slave_dev = slave->dev;
+	struct net_device *bond_dev = slave->bond->dev;
 
-	netdev_dbg(slave_dev, "arp %d on slave %s: dst %pI4 src %pI4\n",
-		   arp_op, slave_dev->name, &dest_ip, &src_ip);
+	slave_dbg(bond_dev, slave_dev, "arp %d on slave: dst %pI4 src %pI4\n",
+		  arp_op, &dest_ip, &src_ip);
 
 	skb = arp_create(arp_op, ETH_P_ARP, dest_ip, slave_dev, src_ip,
 			 NULL, slave_dev->dev_addr, NULL);
@@ -2394,8 +2369,8 @@ static void bond_arp_send(struct net_device *slave_dev, int arp_op,
 			continue;
 		}
 
-		netdev_dbg(slave_dev, "inner tag: proto %X vid %X\n",
-			   ntohs(outer_tag->vlan_proto), tags->vlan_id);
+		slave_dbg(bond_dev, slave_dev, "inner tag: proto %X vid %X\n",
+			  ntohs(outer_tag->vlan_proto), tags->vlan_id);
 		skb = vlan_insert_tag_set_proto(skb, tags->vlan_proto,
 						tags->vlan_id);
 		if (!skb) {
@@ -2407,8 +2382,8 @@ static void bond_arp_send(struct net_device *slave_dev, int arp_op,
 	}
 	/* Set the outer tag */
 	if (outer_tag->vlan_id) {
-		netdev_dbg(slave_dev, "outer tag: proto %X vid %X\n",
-			   ntohs(outer_tag->vlan_proto), outer_tag->vlan_id);
+		slave_dbg(bond_dev, slave_dev, "outer tag: proto %X vid %X\n",
+			  ntohs(outer_tag->vlan_proto), outer_tag->vlan_id);
 		__vlan_hwaccel_put_tag(skb, outer_tag->vlan_proto,
 				       outer_tag->vlan_id);
 	}
@@ -2465,7 +2440,8 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 	int i;
 
 	for (i = 0; i < BOND_MAX_ARP_TARGETS && targets[i]; i++) {
-		netdev_dbg(bond->dev, "basa: target %pI4\n", &targets[i]);
+		slave_dbg(bond->dev, slave->dev, "%s: target %pI4\n",
+			  __func__, &targets[i]);
 		tags = NULL;
 
 		/* Find out through which dev should the packet go */
@@ -2479,7 +2455,7 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 				net_warn_ratelimited("%s: no route to arp_ip_target %pI4 and arp_validate is set\n",
 						     bond->dev->name,
 						     &targets[i]);
-			bond_arp_send(slave->dev, ARPOP_REQUEST, targets[i],
+			bond_arp_send(slave, ARPOP_REQUEST, targets[i],
 				      0, tags);
 			continue;
 		}
@@ -2496,7 +2472,7 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 			goto found;
 
 		/* Not our device - skip */
-		netdev_dbg(bond->dev, "no path to arp_ip_target %pI4 via rt.dev %s\n",
+		slave_dbg(bond->dev, slave->dev, "no path to arp_ip_target %pI4 via rt.dev %s\n",
 			   &targets[i], rt->dst.dev ? rt->dst.dev->name : "NULL");
 
 		ip_rt_put(rt);
@@ -2505,8 +2481,7 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
 found:
 		addr = bond_confirm_addr(rt->dst.dev, targets[i], 0);
 		ip_rt_put(rt);
-		bond_arp_send(slave->dev, ARPOP_REQUEST, targets[i],
-			      addr, tags);
+		bond_arp_send(slave, ARPOP_REQUEST, targets[i], addr, tags);
 		kfree(tags);
 	}
 }
@@ -2516,15 +2491,15 @@ static void bond_validate_arp(struct bonding *bond, struct slave *slave, __be32
 	int i;
 
 	if (!sip || !bond_has_this_ip(bond, tip)) {
-		netdev_dbg(bond->dev, "bva: sip %pI4 tip %pI4 not found\n",
-			   &sip, &tip);
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI4 tip %pI4 not found\n",
+			   __func__, &sip, &tip);
 		return;
 	}
 
 	i = bond_get_targets_ip(bond->params.arp_targets, sip);
 	if (i == -1) {
-		netdev_dbg(bond->dev, "bva: sip %pI4 not found in targets\n",
-			   &sip);
+		slave_dbg(bond->dev, slave->dev, "%s: sip %pI4 not found in targets\n",
+			   __func__, &sip);
 		return;
 	}
 	slave->last_rx = jiffies;
@@ -2552,8 +2527,8 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 
 	alen = arp_hdr_len(bond->dev);
 
-	netdev_dbg(bond->dev, "bond_arp_rcv: skb->dev %s\n",
-		   skb->dev->name);
+	slave_dbg(bond->dev, slave->dev, "%s: skb->dev %s\n",
+		   __func__, skb->dev->name);
 
 	if (alen > skb_headlen(skb)) {
 		arp = kmalloc(alen, GFP_ATOMIC);
@@ -2577,10 +2552,10 @@ int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond,
 	arp_ptr += 4 + bond->dev->addr_len;
 	memcpy(&tip, arp_ptr, 4);
 
-	netdev_dbg(bond->dev, "bond_arp_rcv: %s/%d av %d sv %d sip %pI4 tip %pI4\n",
-		   slave->dev->name, bond_slave_state(slave),
-		     bond->params.arp_validate, slave_do_arp_validate(bond, slave),
-		     &sip, &tip);
+	slave_dbg(bond->dev, slave->dev, "%s: %s/%d av %d sv %d sip %pI4 tip %pI4\n",
+		  __func__, slave->dev->name, bond_slave_state(slave),
+		  bond->params.arp_validate, slave_do_arp_validate(bond, slave),
+		  &sip, &tip);
 
 	curr_active_slave = rcu_dereference(bond->curr_active_slave);
 	curr_arp_slave = rcu_dereference(bond->current_arp_slave);
@@ -2683,12 +2658,10 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 				 * is closed.
 				 */
 				if (!oldcurrent) {
-					netdev_info(bond->dev, "link status definitely up for interface %s\n",
-						    slave->dev->name);
+					slave_info(bond->dev, slave->dev, "link status definitely up\n");
 					do_failover = 1;
 				} else {
-					netdev_info(bond->dev, "interface %s is now up\n",
-						    slave->dev->name);
+					slave_info(bond->dev, slave->dev, "interface is now up\n");
 				}
 			}
 		} else {
@@ -2707,8 +2680,7 @@ static void bond_loadbalance_arp_mon(struct bonding *bond)
 				if (slave->link_failure_count < UINT_MAX)
 					slave->link_failure_count++;
 
-				netdev_info(bond->dev, "interface %s is now down\n",
-					    slave->dev->name);
+				slave_info(bond->dev, slave->dev, "interface is now down\n");
 
 				if (slave == oldcurrent)
 					do_failover = 1;
@@ -2858,8 +2830,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 					RCU_INIT_POINTER(bond->current_arp_slave, NULL);
 				}
 
-				netdev_info(bond->dev, "link status definitely up for interface %s\n",
-					    slave->dev->name);
+				slave_info(bond->dev, slave->dev, "link status definitely up\n");
 
 				if (!rtnl_dereference(bond->curr_active_slave) ||
 				    slave == rtnl_dereference(bond->primary_slave))
@@ -2878,8 +2849,7 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			bond_set_slave_inactive_flags(slave,
 						      BOND_SLAVE_NOTIFY_NOW);
 
-			netdev_info(bond->dev, "link status definitely down for interface %s, disabling it\n",
-				    slave->dev->name);
+			slave_info(bond->dev, slave->dev, "link status definitely down, disabling slave\n");
 
 			if (slave == rtnl_dereference(bond->curr_active_slave)) {
 				RCU_INIT_POINTER(bond->current_arp_slave, NULL);
@@ -2889,8 +2859,8 @@ static void bond_ab_arp_commit(struct bonding *bond)
 			continue;
 
 		default:
-			netdev_err(bond->dev, "impossible: new_link %d on slave %s\n",
-				   slave->new_link, slave->dev->name);
+			slave_err(bond->dev, slave->dev, "impossible: new_link %d on slave\n",
+				  slave->new_link);
 			continue;
 		}
 
@@ -2961,8 +2931,7 @@ static bool bond_ab_arp_probe(struct bonding *bond)
 			bond_set_slave_inactive_flags(slave,
 						      BOND_SLAVE_NOTIFY_LATER);
 
-			netdev_info(bond->dev, "backup interface %s is now down\n",
-				    slave->dev->name);
+			slave_info(bond->dev, slave->dev, "backup interface is now down\n");
 		}
 		if (slave == curr_arp_slave)
 			found = true;
@@ -3074,6 +3043,8 @@ static int bond_master_netdev_event(unsigned long event,
 {
 	struct bonding *event_bond = netdev_priv(bond_dev);
 
+	netdev_dbg(bond_dev, "%s called\n", __func__);
+
 	switch (event) {
 	case NETDEV_CHANGENAME:
 		return bond_event_changename(event_bond);
@@ -3105,12 +3076,17 @@ static int bond_slave_netdev_event(unsigned long event,
 	 * before netdev_rx_handler_register is called in which case
 	 * slave will be NULL
 	 */
-	if (!slave)
+	if (!slave) {
+		netdev_dbg(slave_dev, "%s called on NULL slave\n", __func__);
 		return NOTIFY_DONE;
+	}
+
 	bond_dev = slave->bond->dev;
 	bond = slave->bond;
 	primary = rtnl_dereference(bond->primary_slave);
 
+	slave_dbg(bond_dev, slave_dev, "%s called\n", __func__);
+
 	switch (event) {
 	case NETDEV_UNREGISTER:
 		if (bond_dev->type != ARPHRD_ETHER)
@@ -3221,16 +3197,13 @@ static int bond_netdev_event(struct notifier_block *this,
 	if (event_dev->flags & IFF_MASTER) {
 		int ret;
 
-		netdev_dbg(event_dev, "IFF_MASTER\n");
 		ret = bond_master_netdev_event(event, event_dev);
 		if (ret != NOTIFY_DONE)
 			return ret;
 	}
 
-	if (event_dev->flags & IFF_SLAVE) {
-		netdev_dbg(event_dev, "IFF_SLAVE\n");
+	if (event_dev->flags & IFF_SLAVE)
 		return bond_slave_netdev_event(event, event_dev);
-	}
 
 	return NOTIFY_DONE;
 }
@@ -3547,12 +3520,11 @@ static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd
 
 	slave_dev = __dev_get_by_name(net, ifr->ifr_slave);
 
-	netdev_dbg(bond_dev, "slave_dev=%p:\n", slave_dev);
+	slave_dbg(bond_dev, slave_dev, "slave_dev=%p:\n", slave_dev);
 
 	if (!slave_dev)
 		return -ENODEV;
 
-	netdev_dbg(bond_dev, "slave_dev->name=%s:\n", slave_dev->name);
 	switch (cmd) {
 	case BOND_ENSLAVE_OLD:
 	case SIOCBONDENSLAVE:
@@ -3677,7 +3649,7 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 	netdev_dbg(bond_dev, "bond=%p, new_mtu=%d\n", bond, new_mtu);
 
 	bond_for_each_slave(bond, slave, iter) {
-		netdev_dbg(bond_dev, "s %p c_m %p\n",
+		slave_dbg(bond_dev, slave->dev, "s %p c_m %p\n",
 			   slave, slave->dev->netdev_ops->ndo_change_mtu);
 
 		res = dev_set_mtu(slave->dev, new_mtu);
@@ -3691,8 +3663,8 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 			 * means changing their mtu from timer context, which
 			 * is probably not a good idea.
 			 */
-			netdev_dbg(bond_dev, "err %d %s\n", res,
-				   slave->dev->name);
+			slave_dbg(bond_dev, slave->dev, "err %d setting mtu to %d\n",
+				  res, new_mtu);
 			goto unwind;
 		}
 	}
@@ -3710,10 +3682,9 @@ static int bond_change_mtu(struct net_device *bond_dev, int new_mtu)
 			break;
 
 		tmp_res = dev_set_mtu(rollback_slave->dev, bond_dev->mtu);
-		if (tmp_res) {
-			netdev_dbg(bond_dev, "unwind err %d dev %s\n",
-				   tmp_res, rollback_slave->dev->name);
-		}
+		if (tmp_res)
+			slave_dbg(bond_dev, rollback_slave->dev, "unwind err %d\n",
+				  tmp_res);
 	}
 
 	return res;
@@ -3737,7 +3708,7 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 		return bond_alb_set_mac_address(bond_dev, addr);
 
 
-	netdev_dbg(bond_dev, "bond=%p\n", bond);
+	netdev_dbg(bond_dev, "%s: bond=%p\n", __func__, bond);
 
 	/* If fail_over_mac is enabled, do nothing and return success.
 	 * Returning an error causes ifenslave to fail.
@@ -3750,7 +3721,8 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 		return -EADDRNOTAVAIL;
 
 	bond_for_each_slave(bond, slave, iter) {
-		netdev_dbg(bond_dev, "slave %p %s\n", slave, slave->dev->name);
+		slave_dbg(bond_dev, slave->dev, "%s: slave=%p\n",
+			  __func__, slave);
 		res = dev_set_mac_address(slave->dev, addr, NULL);
 		if (res) {
 			/* TODO: consider downing the slave
@@ -3759,7 +3731,8 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 			 * breakage anyway until ARP finish
 			 * updating, so...
 			 */
-			netdev_dbg(bond_dev, "err %d %s\n", res, slave->dev->name);
+			slave_dbg(bond_dev, slave->dev, "%s: err %d\n",
+				  __func__, res);
 			goto unwind;
 		}
 	}
@@ -3782,8 +3755,8 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 		tmp_res = dev_set_mac_address(rollback_slave->dev,
 					      (struct sockaddr *)&tmp_ss, NULL);
 		if (tmp_res) {
-			netdev_dbg(bond_dev, "unwind err %d dev %s\n",
-				   tmp_res, rollback_slave->dev->name);
+			slave_dbg(bond_dev, rollback_slave->dev, "%s: unwind err %d\n",
+				   __func__, tmp_res);
 		}
 	}
 
@@ -4004,9 +3977,8 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		if (skipslave == slave)
 			continue;
 
-		netdev_dbg(bond->dev,
-			   "Adding slave dev %s to tx hash array[%d]\n",
-			   slave->dev->name, new_arr->count);
+		slave_dbg(bond->dev, slave->dev, "Adding slave to tx hash array[%d]\n",
+			  new_arr->count);
 
 		new_arr->arr[new_arr->count++] = slave;
 	}
-- 
2.20.1

