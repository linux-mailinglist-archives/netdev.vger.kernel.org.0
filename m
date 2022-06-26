Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8977D55B216
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 15:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiFZNB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 09:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiFZNBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 09:01:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8018711A30;
        Sun, 26 Jun 2022 06:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656248509; x=1687784509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AvH5AJy6TY1om+MgW8+LLbs1GcEnVrTgi+NpxcY0iFw=;
  b=I5y/C2O4rLCfWgBA/5CQUm3/pIkFgMIN9fi9pljXg9Zi5g8rH0gcQYhk
   TPa/u5kRhn3qLKngIfzGXttEvGYvTZjcFNMWrlfz7crcfey1xzIfk3aC4
   Sji7p2XNcez0oeTQ9v2rJ4S1iSsVf9+/CrjWbU8uwJAn5RD+eD5ARl+ao
   Ru5kAcctoFHautPxT4Bi98LjGlou55dVqX1NHjka43ONXk3bx2nouzSk0
   5EvFUoCck+1n1n3wBI2iRJrXU7nEbYBcQkmq/3xXZgLZduzDLRFndMMbW
   ILgGkNTNAL4FrVsq6JdfNQeFehT44QbBgjX3t33R2veVvWsI9G/aIUSUX
   w==;
X-IronPort-AV: E=Sophos;i="5.92,224,1650956400"; 
   d="scan'208";a="169642316"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jun 2022 06:01:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 26 Jun 2022 06:01:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 26 Jun 2022 06:01:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 7/8] net: lan966x: Extend MAC to support also lag interfaces.
Date:   Sun, 26 Jun 2022 15:04:50 +0200
Message-ID: <20220626130451.1079933-8-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
References: <20220626130451.1079933-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend MAC support to support also lag interfaces:
1. In case an entry is learned on a port that is part of lag interface,
   then notify the upper layers that the entry is learned on the bond
   interface
2. If a port leaves the bond and the port is the first port in the lag
   group, then it is required to update all MAC entries to change the
   destination port.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_lag.c  | 14 ++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 66 ++++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++
 3 files changed, 77 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
index db21bd358e4e..4ce41a55737c 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -130,6 +130,20 @@ int lan966x_lag_port_join(struct lan966x_port *port,
 void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond)
 {
 	struct lan966x *lan966x = port->lan966x;
+	u32 bond_mask;
+	u32 lag_id;
+
+	if (lan966x_lag_first_port(port->bond, port->dev)) {
+		bond_mask = lan966x_lag_get_mask(lan966x, port->bond, false);
+		bond_mask &= ~BIT(port->chip_port);
+		if (bond_mask) {
+			lag_id = __ffs(bond_mask);
+			lan966x_mac_lag_replace_port_entry(lan966x, port,
+							   lan966x->ports[lag_id]);
+		} else {
+			lan966x_mac_lag_remove_port_entry(lan966x, port);
+		}
+	}
 
 	port->bond = NULL;
 	lan966x_lag_set_port_ids(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 005e56ea5da1..3348453d89df 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -22,6 +22,7 @@ struct lan966x_mac_entry {
 	u16 vid;
 	u16 port_index;
 	int row;
+	bool lag;
 };
 
 struct lan966x_mac_raw_entry {
@@ -156,8 +157,9 @@ void lan966x_mac_init(struct lan966x *lan966x)
 	INIT_LIST_HEAD(&lan966x->mac_entries);
 }
 
-static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *mac,
-							 u16 vid, u16 port_index)
+static struct lan966x_mac_entry *lan966x_mac_alloc_entry(struct lan966x_port *port,
+							 const unsigned char *mac,
+							 u16 vid)
 {
 	struct lan966x_mac_entry *mac_entry;
 
@@ -167,8 +169,9 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
 
 	memcpy(mac_entry->mac, mac, ETH_ALEN);
 	mac_entry->vid = vid;
-	mac_entry->port_index = port_index;
+	mac_entry->port_index = port->chip_port;
 	mac_entry->row = LAN966X_MAC_INVALID_ROW;
+	mac_entry->lag = port->bond ? true : false;
 	return mac_entry;
 }
 
@@ -245,7 +248,7 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 		return lan966x_mac_learn(lan966x, port->chip_port,
 					 addr, vid, ENTRYTYPE_LOCKED);
 
-	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
+	mac_entry = lan966x_mac_alloc_entry(port, addr, vid);
 	if (!mac_entry)
 		return -ENOMEM;
 
@@ -254,7 +257,8 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 	spin_unlock(&lan966x->mac_lock);
 
 	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
-	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid, port->dev);
+	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid,
+				   port->bond ?: port->dev);
 
 	return 0;
 }
@@ -281,6 +285,48 @@ int lan966x_mac_del_entry(struct lan966x *lan966x, const unsigned char *addr,
 	return 0;
 }
 
+void lan966x_mac_lag_replace_port_entry(struct lan966x *lan966x,
+					struct lan966x_port *src,
+					struct lan966x_port *dst)
+{
+	struct lan966x_mac_entry *mac_entry;
+
+	spin_lock(&lan966x->mac_lock);
+	list_for_each_entry(mac_entry, &lan966x->mac_entries, list) {
+		if (mac_entry->port_index == src->chip_port &&
+		    mac_entry->lag) {
+			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
+					   ENTRYTYPE_LOCKED);
+
+			lan966x_mac_learn(lan966x, dst->chip_port,
+					  mac_entry->mac, mac_entry->vid,
+					  ENTRYTYPE_LOCKED);
+			mac_entry->port_index = dst->chip_port;
+		}
+	}
+	spin_unlock(&lan966x->mac_lock);
+}
+
+void lan966x_mac_lag_remove_port_entry(struct lan966x *lan966x,
+				       struct lan966x_port *src)
+{
+	struct lan966x_mac_entry *mac_entry, *tmp;
+
+	spin_lock(&lan966x->mac_lock);
+	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
+				 list) {
+		if (mac_entry->port_index == src->chip_port &&
+		    mac_entry->lag) {
+			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
+					   ENTRYTYPE_LOCKED);
+
+			list_del(&mac_entry->list);
+			kfree(mac_entry);
+		}
+	}
+	spin_unlock(&lan966x->mac_lock);
+}
+
 void lan966x_mac_purge_entries(struct lan966x *lan966x)
 {
 	struct lan966x_mac_entry *mac_entry, *tmp;
@@ -325,6 +371,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 {
 	struct lan966x_mac_entry *mac_entry, *tmp;
 	unsigned char mac[ETH_ALEN] __aligned(2);
+	struct lan966x_port *port;
 	u32 dest_idx;
 	u32 column;
 	u16 vid;
@@ -366,9 +413,10 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 			 * anymore in the HW and remove the entry from the SW
 			 * list
 			 */
+			port = lan966x->ports[mac_entry->port_index];
 			lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
 					      mac_entry->mac, mac_entry->vid,
-					      lan966x->ports[mac_entry->port_index]->dev);
+					      port->bond ?: port->dev);
 
 			list_del(&mac_entry->list);
 			kfree(mac_entry);
@@ -396,7 +444,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 			continue;
 
-		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
+		port = lan966x->ports[dest_idx];
+		mac_entry = lan966x_mac_alloc_entry(port, mac, vid);
 		if (!mac_entry)
 			return;
 
@@ -407,7 +456,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		spin_unlock(&lan966x->mac_lock);
 
 		lan966x_mac_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
-				      mac, vid, lan966x->ports[dest_idx]->dev);
+				      mac, vid,
+				      port->bond ?: port->dev);
 	}
 }
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 7b4805813549..c1f5ca5d91a4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -349,6 +349,11 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
 			  struct lan966x_port *port,
 			  const unsigned char *addr,
 			  u16 vid);
+void lan966x_mac_lag_replace_port_entry(struct lan966x *lan966x,
+					struct lan966x_port *src,
+					struct lan966x_port *dst);
+void lan966x_mac_lag_remove_port_entry(struct lan966x *lan966x,
+				       struct lan966x_port *src);
 void lan966x_mac_purge_entries(struct lan966x *lan966x);
 irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
 
-- 
2.33.0

