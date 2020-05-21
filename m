Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300DA1DD926
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgEUVLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730602AbgEUVLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 17:11:03 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B416CC08C5C0
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:02 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id h16so7726234eds.5
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 14:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GeNsWMw9QCbJxJekQNWDhdnyPJFizHZoxDKdXKPyLJg=;
        b=oIt2LPFSBWz91MxVqUdAKbX8Fxh4twQ7EnUh4mQtwEB8P/cJNfjef2/kTaaDy0H2cA
         I2A9E+w1wTIFKwYYVjeOq6PgVFA4VLhziQo/aEpOHaox3HJnQuN8x9eidmNZSJGS8o5N
         kwKYJcBf3FVLtt6+9NFBdhHd2O97j6XuP0ogkuO10MLHh/rlahKqTCKtPHw5YUSaeIwR
         QVYsTtTRBra1tV/pnM1XCiBUpJECQ1wY2T4vG97ngEHsRsHDZkiuK9f4OO6pTTCqyzMw
         8ybOMnaEZFvqm4szBVIgMP1dwSQSCYII60JduIwDtdfvkQiitb4eT+nj4S0GdKzzKwwv
         o48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GeNsWMw9QCbJxJekQNWDhdnyPJFizHZoxDKdXKPyLJg=;
        b=O3RY9Tqt+3YJIpGdRX+ZfHH5pjR1wwfA6RzncnJ3bOrWDHDQfjn6XIx2f9wVJe3epT
         UppYQVJIKZYPluFd+fBIst0HcJOv++mqcJ/CfVsvJ5QbQvfgLuTlxnI0YopMZdNrNf2S
         CkC4qrQVOySuByi1UjO5nx4A2qgmP3JYXKj0H43pP7bzGhma4HAQ/YG1t4vqHSvOVTuQ
         PHzJ9pIc6h/ZWc7tvJucHuMox/IISzB60c1gbcG7iYyhlSBAmDgK3uuYrDwDGdDZx+x/
         U/v0Q5OWAfB39RhtGfSX3KfITu0PQIZxBYUZ/CSkrmvBDnZEF2zGEvs7mw8/lBGtlbJZ
         ypcQ==
X-Gm-Message-State: AOAM532X3BuQz92lwiyxk2LdGulGTxsN+jqBpfqfuAa4V5yF/G32Da8/
        UE00edgXQdl8djkp0MYOxic=
X-Google-Smtp-Source: ABdhPJxxOnkgXB6Wa8AgVQ9zL5fg3O6ZXIdn562OfTYLesEZHDR5oE2hM63NMjsuHBpwrSc3gtKBiA==
X-Received: by 2002:a50:d50f:: with SMTP id u15mr573035edi.244.1590095461189;
        Thu, 21 May 2020 14:11:01 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id h8sm5797637edk.72.2020.05.21.14.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 14:11:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        ivecera@redhat.com, netdev@vger.kernel.org,
        horatiu.vultur@microchip.com, allan.nielsen@microchip.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH RFC net-next 08/13] net: dsa: add ability to program unicast and multicast filters for CPU port
Date:   Fri, 22 May 2020 00:10:31 +0300
Message-Id: <20200521211036.668624-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200521211036.668624-1-olteanv@gmail.com>
References: <20200521211036.668624-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

When the switch ports operate as individual network devices, the switch
driver might have configured the switch to flood multicast all the way
to the CPU port. This is really undesirable as it can lead to receiving
a lot of unwanted traffic that the network stack needs to filter in
software.

For each valid multicast address, program it into the switch's MDB only
when the host is interested in receiving such traffic, e.g: running a
multicast application.

For unicast filtering, consider that termination can only be done
through the primary MAC address of each net device virtually
corresponding to a switch port, as well as through upper interfaces
(VLAN, bridge) that add their MAC address to the list of secondary
unicast addresses of the switch net devices. For each such unicast
address, install a reference-counted FDB entry towards the CPU port.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h |   6 ++
 net/dsa/Kconfig   |   1 +
 net/dsa/dsa2.c    |   6 ++
 net/dsa/slave.c   | 182 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 50389772c597..7aa78884a5f2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -261,6 +261,12 @@ struct dsa_switch {
 	 */
 	const struct dsa_switch_ops	*ops;
 
+	/*
+	 * {MAC, VLAN} addresses that are copied to the CPU.
+	 */
+	struct netdev_hw_addr_list	uc;
+	struct netdev_hw_addr_list	mc;
+
 	/*
 	 * Slave mii_bus and devices for the individual ports.
 	 */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 739613070d07..d4644afdbdd7 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -9,6 +9,7 @@ menuconfig NET_DSA
 	tristate "Distributed Switch Architecture"
 	depends on HAVE_NET_DSA
 	depends on BRIDGE || BRIDGE=n
+	depends on VLAN_8021Q_IVDF || VLAN_8021Q_IVDF=n
 	select GRO_CELLS
 	select NET_SWITCHDEV
 	select PHYLINK
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 076908fdd29b..cd17554a912b 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -429,6 +429,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 			goto unregister_notifier;
 	}
 
+	__hw_addr_init(&ds->mc);
+	__hw_addr_init(&ds->uc);
+
 	ds->setup = true;
 
 	return 0;
@@ -449,6 +452,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
+	__hw_addr_flush(&ds->mc);
+	__hw_addr_flush(&ds->uc);
+
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d2072fbd22fe..2743d689f6b1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -62,6 +62,158 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
 	return dsa_slave_to_master(dev)->ifindex;
 }
 
+/* Add a static host MDB entry, corresponding to a slave multicast MAC address,
+ * to the CPU port. The MDB entry is reference-counted (4 slave ports listening
+ * on the same multicast MAC address will only call this function once).
+ */
+static int dsa_upstream_sync_mdb_addr(struct net_device *dev,
+				      const unsigned char *addr)
+{
+	struct switchdev_obj_port_mdb mdb;
+
+	memset(&mdb, 0, sizeof(mdb));
+	mdb.obj.id = SWITCHDEV_OBJ_ID_HOST_MDB;
+	mdb.obj.flags = SWITCHDEV_F_DEFER;
+	mdb.vid = vlan_dev_get_addr_vid(dev, addr);
+	ether_addr_copy(mdb.addr, addr);
+
+	return switchdev_port_obj_add(dev, &mdb.obj, NULL);
+}
+
+/* Delete a static host MDB entry, corresponding to a slave multicast MAC
+ * address, to the CPU port. The MDB entry is reference-counted (4 slave ports
+ * listening on the same multicast MAC address will only call this function
+ * once).
+ */
+static int dsa_upstream_unsync_mdb_addr(struct net_device *dev,
+				        const unsigned char *addr)
+{
+	struct switchdev_obj_port_mdb mdb;
+
+	memset(&mdb, 0, sizeof(mdb));
+	mdb.obj.id = SWITCHDEV_OBJ_ID_HOST_MDB;
+	mdb.obj.flags = SWITCHDEV_F_DEFER;
+	mdb.vid = vlan_dev_get_addr_vid(dev, addr);
+	ether_addr_copy(mdb.addr, addr);
+
+	return switchdev_port_obj_del(dev, &mdb.obj);
+}
+
+static int dsa_slave_sync_mdb_addr(struct net_device *dev,
+				   const unsigned char *addr)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	err = __hw_addr_add(&ds->mc, addr, dev->addr_len + dev->vid_len,
+			    NETDEV_HW_ADDR_T_MULTICAST);
+	if (err)
+		return err;
+
+	return __hw_addr_sync_dev(&ds->mc, dev, dsa_upstream_sync_mdb_addr,
+				  dsa_upstream_unsync_mdb_addr);
+}
+
+static int dsa_slave_unsync_mdb_addr(struct net_device *dev,
+				     const unsigned char *addr)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	err = __hw_addr_del(&ds->mc, addr, dev->addr_len + dev->vid_len,
+			    NETDEV_HW_ADDR_T_MULTICAST);
+	if (err)
+		return err;
+
+	return __hw_addr_sync_dev(&ds->mc, dev, dsa_upstream_sync_mdb_addr,
+				  dsa_upstream_unsync_mdb_addr);
+}
+
+static void dsa_slave_switchdev_event_work(struct work_struct *work);
+
+static int dsa_upstream_fdb_addr(struct net_device *slave_dev,
+				 const unsigned char *addr,
+				 unsigned long event)
+{
+	int addr_len = slave_dev->addr_len + slave_dev->vid_len;
+	struct dsa_port *dp = dsa_slave_to_port(slave_dev);
+	u16 vid = vlan_dev_get_addr_vid(slave_dev, addr);
+	struct dsa_switchdev_event_work *switchdev_work;
+
+	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+	if (!switchdev_work)
+		return -ENOMEM;
+
+	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
+	switchdev_work->ds = dp->ds;
+	switchdev_work->port = dsa_upstream_port(dp->ds, dp->index);
+	switchdev_work->event = event;
+
+	memcpy(switchdev_work->addr, addr, addr_len);
+	switchdev_work->vid = vid;
+
+	dev_hold(slave_dev);
+	dsa_schedule_work(&switchdev_work->work);
+
+	return 0;
+}
+
+/* Add a static FDB entry, corresponding to a slave unicast MAC address,
+ * to the CPU port. The FDB entry is reference-counted (4 slave ports having
+ * the same MAC address will only call this function once).
+ */
+static int dsa_upstream_sync_fdb_addr(struct net_device *slave_dev,
+				      const unsigned char *addr)
+{
+	return dsa_upstream_fdb_addr(slave_dev, addr,
+				     SWITCHDEV_FDB_ADD_TO_DEVICE);
+}
+
+/* Remove a static FDB entry, corresponding to a slave unicast MAC address,
+ * from the CPU port. The FDB entry is reference-counted (the MAC address is
+ * only removed when there is no remaining slave port that uses it).
+ */
+static int dsa_upstream_unsync_fdb_addr(struct net_device *slave_dev,
+					const unsigned char *addr)
+{
+	return dsa_upstream_fdb_addr(slave_dev, addr,
+				     SWITCHDEV_FDB_DEL_TO_DEVICE);
+}
+
+static int dsa_slave_sync_fdb_addr(struct net_device *dev,
+				   const unsigned char *addr)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	err = __hw_addr_add(&ds->uc, addr, dev->addr_len + dev->vid_len,
+			    NETDEV_HW_ADDR_T_UNICAST);
+	if (err)
+		return err;
+
+	return __hw_addr_sync_dev(&ds->uc, dev, dsa_upstream_sync_fdb_addr,
+				  dsa_upstream_unsync_fdb_addr);
+}
+
+static int dsa_slave_unsync_fdb_addr(struct net_device *dev,
+				     const unsigned char *addr)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+	int err;
+
+	err = __hw_addr_del(&ds->uc, addr, dev->addr_len + dev->vid_len,
+			    NETDEV_HW_ADDR_T_UNICAST);
+	if (err)
+		return err;
+
+	return __hw_addr_sync_dev(&ds->uc, dev, dsa_upstream_sync_fdb_addr,
+				  dsa_upstream_unsync_fdb_addr);
+}
+
 static int dsa_slave_open(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -76,6 +228,9 @@ static int dsa_slave_open(struct net_device *dev)
 		if (err < 0)
 			goto out;
 	}
+	err = dsa_slave_sync_fdb_addr(dev, dev->dev_addr);
+	if (err < 0)
+		goto out;
 
 	if (dev->flags & IFF_ALLMULTI) {
 		err = dev_set_allmulti(master, 1);
@@ -103,6 +258,7 @@ static int dsa_slave_open(struct net_device *dev)
 del_unicast:
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
+	dsa_slave_unsync_fdb_addr(dev, dev->dev_addr);
 out:
 	return err;
 }
@@ -116,6 +272,9 @@ static int dsa_slave_close(struct net_device *dev)
 
 	dev_mc_unsync(master, dev);
 	dev_uc_unsync(master, dev);
+	__dev_mc_unsync(dev, dsa_slave_unsync_mdb_addr);
+	__dev_uc_unsync(dev, dsa_slave_unsync_fdb_addr);
+
 	if (dev->flags & IFF_ALLMULTI)
 		dev_set_allmulti(master, -1);
 	if (dev->flags & IFF_PROMISC)
@@ -143,7 +302,17 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 static void dsa_slave_set_rx_mode(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+
+	/* If the port is bridged, the bridge takes care of sending
+	 * SWITCHDEV_OBJ_ID_HOST_MDB to program the host's MC filter
+	 */
+	if (netdev_mc_empty(dev) || dp->bridge_dev)
+		goto out;
 
+	__dev_mc_sync(dev, dsa_slave_sync_mdb_addr, dsa_slave_unsync_mdb_addr);
+out:
+	__dev_uc_sync(dev, dsa_slave_sync_fdb_addr, dsa_slave_unsync_fdb_addr);
 	dev_mc_sync(master, dev);
 	dev_uc_sync(master, dev);
 }
@@ -165,9 +334,15 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 		if (err < 0)
 			return err;
 	}
+	err = dsa_slave_sync_fdb_addr(dev, addr->sa_data);
+	if (err < 0)
+		goto out;
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr))
 		dev_uc_del(master, dev->dev_addr);
+	err = dsa_slave_unsync_fdb_addr(dev, dev->dev_addr);
+	if (err < 0)
+		goto out;
 
 out:
 	ether_addr_copy(dev->dev_addr, addr->sa_data);
@@ -1752,6 +1927,8 @@ int dsa_slave_create(struct dsa_port *port)
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
+	if (ds->ops->port_fdb_add && ds->ops->port_egress_floods)
+		slave_dev->priv_flags |= IFF_UNICAST_FLT;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	slave_dev->min_mtu = 0;
 	if (ds->ops->port_max_mtu)
@@ -1759,6 +1936,7 @@ int dsa_slave_create(struct dsa_port *port)
 	else
 		slave_dev->max_mtu = ETH_MAX_MTU;
 	SET_NETDEV_DEVTYPE(slave_dev, &dsa_type);
+	vlan_dev_ivdf_set(slave_dev, true);
 
 	netdev_for_each_tx_queue(slave_dev, dsa_slave_set_lockdep_class_one,
 				 NULL);
@@ -1854,6 +2032,10 @@ static int dsa_slave_changeupper(struct net_device *dev,
 
 	if (netif_is_bridge_master(info->upper_dev)) {
 		if (info->linking) {
+			/* Remove existing MC addresses that might have been
+			 * programmed
+			 */
+			__dev_mc_unsync(dev, dsa_slave_unsync_mdb_addr);
 			err = dsa_port_bridge_join(dp, info->upper_dev);
 			if (!err)
 				dsa_bridge_mtu_normalization(dp);
-- 
2.25.1

