Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CED41F6FC
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 23:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355756AbhJAVe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 17:34:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355158AbhJAVeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 17:34:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A654619EC;
        Fri,  1 Oct 2021 21:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633123955;
        bh=QvgcF/PAW3zIqRzyJcIoc7zbHtvhtmeYw6U02G+jv9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AZQnXkgsojNiDBXluoEZNmWp284WZE+ypVsgPPoSjZj4GZIbilWJgT8QGPbDIiDq6
         9wtPsRGN7EhZhoV2rZ4h/FATwZSRWABrhdcC11YF7kLMhYNP0r9r2qXtTMyfvlKzZ2
         oADCmqp2fuDX6zDstm9A+fjC7fdtbP1ys5fZd30N+H1FRpodNt3IQn9cOj0vqmxoE8
         mhh2nVrH845Dcj9jP7sRmfoOpPPDVLbtHLQgImGPxjXRIEcwDLWaHsL6v4QAo8PYQK
         ay1BJ8eivOI0aGBP6xjzC4amkSsBUBrmHEGHPQvcK3pTiWdj4icsTlg0iIlbBD7Y6T
         Ms6Jb2j/q5ZpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 05/11] net: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Fri,  1 Oct 2021 14:32:22 -0700
Message-Id: <20211001213228.1735079-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001213228.1735079-1-kuba@kernel.org>
References: <20211001213228.1735079-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert from ether_addr_copy() to eth_hw_addr_set():

  @@
  expression dev, np;
  @@
  - ether_addr_copy(dev->dev_addr, np)
  + eth_hw_addr_set(dev, np)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ipvlan/ipvlan_main.c | 2 +-
 drivers/net/macsec.c             | 2 +-
 drivers/net/macvlan.c            | 2 +-
 net/8021q/vlan_dev.c             | 6 +++---
 net/dsa/slave.c                  | 4 ++--
 net/hsr/hsr_device.c             | 2 +-
 net/hsr/hsr_main.c               | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index cca4a00f1c51..1d2f4e7d7324 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -787,7 +787,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_CHANGEADDR:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ether_addr_copy(ipvlan->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(ipvlan->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR, ipvlan->dev);
 		}
 		break;
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 93dc48b9b4f2..18b6dba9394e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3614,7 +3614,7 @@ static int macsec_set_mac_address(struct net_device *dev, void *p)
 	dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	macsec->secy.sci = dev_to_sci(dev, MACSEC_PORT_ES);
 
 	/* If h/w offloading is available, propagate to the device */
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 63563edfd4a6..6189acb33973 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -707,7 +707,7 @@ static int macvlan_sync_address(struct net_device *dev, unsigned char *addr)
 
 	if (!(dev->flags & IFF_UP)) {
 		/* Just copy in the new address */
-		ether_addr_copy(dev->dev_addr, addr);
+		eth_hw_addr_set(dev, addr);
 	} else {
 		/* Rehash and update the device filters */
 		if (macvlan_addr_busy(vlan->port, addr))
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 0c21d1fec852..90330b893134 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -250,7 +250,7 @@ bool vlan_dev_inherit_address(struct net_device *dev,
 	if (dev->addr_assign_type != NET_ADDR_STOLEN)
 		return false;
 
-	ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+	eth_hw_addr_set(dev, real_dev->dev_addr);
 	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
 	return true;
 }
@@ -349,7 +349,7 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 		dev_uc_del(real_dev, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 	return 0;
 }
 
@@ -586,7 +586,7 @@ static int vlan_dev_init(struct net_device *dev)
 	dev->dev_id = real_dev->dev_id;
 
 	if (is_zero_ether_addr(dev->dev_addr)) {
-		ether_addr_copy(dev->dev_addr, real_dev->dev_addr);
+		eth_hw_addr_set(dev, real_dev->dev_addr);
 		dev->addr_assign_type = NET_ADDR_STOLEN;
 	}
 	if (is_zero_ether_addr(dev->broadcast))
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a2bf2d8ac65b..11ec9e689589 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -174,7 +174,7 @@ static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
 		dev_uc_del(master, dev->dev_addr);
 
 out:
-	ether_addr_copy(dev->dev_addr, addr->sa_data);
+	eth_hw_addr_set(dev, addr->sa_data);
 
 	return 0;
 }
@@ -1954,7 +1954,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
 	if (!is_zero_ether_addr(port->mac))
-		ether_addr_copy(slave_dev->dev_addr, port->mac);
+		eth_hw_addr_set(slave_dev, port->mac);
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 26c32407f029..e00fbb16391f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -493,7 +493,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	INIT_LIST_HEAD(&hsr->self_node_db);
 	spin_lock_init(&hsr->list_lock);
 
-	ether_addr_copy(hsr_dev->dev_addr, slave[0]->dev_addr);
+	eth_hw_addr_set(hsr_dev, slave[0]->dev_addr);
 
 	/* initialize protocol specific functions */
 	if (protocol_version == PRP_V1) {
diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index f7e284f23b1f..b099c3150150 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -75,7 +75,7 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 
 		if (port->type == HSR_PT_SLAVE_A) {
-			ether_addr_copy(master->dev->dev_addr, dev->dev_addr);
+			eth_hw_addr_set(master->dev, dev->dev_addr);
 			call_netdevice_notifiers(NETDEV_CHANGEADDR,
 						 master->dev);
 		}
-- 
2.31.1

