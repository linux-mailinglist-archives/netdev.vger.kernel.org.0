Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623242997F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403918AbfEXN4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 09:56:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34720 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403843AbfEXN4d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 09:56:33 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56B193087BD2;
        Fri, 24 May 2019 13:56:29 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4DE482CFD6;
        Fri, 24 May 2019 13:56:25 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net] bonding: make debugging output more succinct
Date:   Fri, 24 May 2019 09:56:23 -0400
Message-Id: <20190524135623.17326-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 24 May 2019 13:56:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Seeing bonding debug log data along the lines of "event: 5" is a bit spartan,
and often requires a lookup table if you don't remember what every event is.
Make use of netdev_cmd_to_name for an improved debugging experience, so for
the prior example, you'll see: "bond_netdev_event received NETDEV_REGISTER"
instead (both are prefixed with the device for which the event pertains).

There are also quite a few places that the netdev_dbg output could stand to
mention exactly which slave the message pertains to (gets messy if you have
multiple slaves all spewing at once to know which one they pertain to).

CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 407f4095a37a..4acc352b316b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1515,7 +1515,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	new_slave->original_mtu = slave_dev->mtu;
 	res = dev_set_mtu(slave_dev, bond->dev->mtu);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu\n", res);
+		netdev_dbg(bond_dev, "Error %d calling dev_set_mtu for slave %s\n",
+			   res, slave_dev->name);
 		goto err_free;
 	}
 
@@ -1536,7 +1537,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		res = dev_set_mac_address(slave_dev, (struct sockaddr *)&ss,
 					  extack);
 		if (res) {
-			netdev_dbg(bond_dev, "Error %d calling set_mac_address\n", res);
+			netdev_dbg(bond_dev, "Error %d calling set_mac_address for slave %s\n",
+				   res, slave_dev->name);
 			goto err_restore_mtu;
 		}
 	}
@@ -1636,7 +1638,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 
 	if (new_slave->link != BOND_LINK_DOWN)
 		new_slave->last_link_up = jiffies;
-	netdev_dbg(bond_dev, "Initial state of slave_dev is BOND_LINK_%s\n",
+	netdev_dbg(bond_dev, "%s: Initial state of slave_dev %s is BOND_LINK_%s\n",
+		   __func__, slave_dev->name,
 		   new_slave->link == BOND_LINK_DOWN ? "DOWN" :
 		   (new_slave->link == BOND_LINK_UP ? "UP" : "BACK"));
 
@@ -1679,7 +1682,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		bond_set_slave_inactive_flags(new_slave, BOND_SLAVE_NOTIFY_NOW);
 		break;
 	default:
-		netdev_dbg(bond_dev, "This slave is always active in trunk mode\n");
+		netdev_dbg(bond_dev, "This slave (%s) is always active in trunk mode\n",
+			   slave_dev->name);
 
 		/* always active in trunk mode */
 		bond_set_active_slave(new_slave);
@@ -1698,7 +1702,8 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	if (bond->dev->npinfo) {
 		if (slave_enable_netpoll(new_slave)) {
-			netdev_info(bond_dev, "master_dev is using netpoll, but new slave device does not support netpoll\n");
+			netdev_info(bond_dev, "master_dev is using netpoll, but new slave device %s does not support netpoll\n",
+				    slave_dev->name);
 			res = -EBUSY;
 			goto err_detach;
 		}
@@ -1711,19 +1716,22 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	res = netdev_rx_handler_register(slave_dev, bond_handle_frame,
 					 new_slave);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling netdev_rx_handler_register\n", res);
+		netdev_dbg(bond_dev, "Error %d calling netdev_rx_handler_register for slave %s\n",
+			   res, slave_dev->name);
 		goto err_detach;
 	}
 
 	res = bond_master_upper_dev_link(bond, new_slave, extack);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling bond_master_upper_dev_link\n", res);
+		netdev_dbg(bond_dev, "Error %d calling bond_master_upper_dev_link for slave %s\n",
+			   res, slave_dev->name);
 		goto err_unregister;
 	}
 
 	res = bond_sysfs_slave_add(new_slave);
 	if (res) {
-		netdev_dbg(bond_dev, "Error %d calling bond_sysfs_slave_add\n", res);
+		netdev_dbg(bond_dev, "Error %d calling bond_sysfs_slave_add for slave %s\n",
+			   res, slave_dev->name);
 		goto err_upper_unlink;
 	}
 
@@ -3212,7 +3220,8 @@ static int bond_netdev_event(struct notifier_block *this,
 {
 	struct net_device *event_dev = netdev_notifier_info_to_dev(ptr);
 
-	netdev_dbg(event_dev, "event: %lx\n", event);
+	netdev_dbg(event_dev, "%s received %s\n",
+		   __func__, netdev_cmd_to_name(event));
 
 	if (!(event_dev->priv_flags & IFF_BONDING))
 		return NOTIFY_DONE;
-- 
2.20.1

