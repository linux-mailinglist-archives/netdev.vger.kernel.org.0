Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF49597683
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbiHQTbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241499AbiHQTb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:31:27 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCBCA286E;
        Wed, 17 Aug 2022 12:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1660764669; x=1692300669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gWfzgwCtIPzOaEO/WMt8rvxoj5RVZzfnHt33edYS4hA=;
  b=X77KUhazHPSLPle+2kUhfZWsJBtvbWwGpZiCAHOzJeX7fwIaAuqaeOFR
   OFqbfUVbOzrMY3qwNGQ9gBHi1EAsMhsXv1+IJtHE0e2MRuLbTF4/ga+mQ
   cY6E+93g+h6AylMwMGi4UTfrCsFwHsxe5N2tkQMIXWTY9xHF9KRBdMxW7
   K971fJ9yjLxUSWli25cTvXXBe9p0B+3jAbGouiDZjthx4spE2kN+/Cssk
   ER8av5FzwtJ0zKMYYRN2ZXIR05ibAwmhh3wccjYnaHZc9dE3A6ew7DKIo
   BvR+Ja6aXHoquU/7sEAe030n9H7zB+4ybc2eNH16zhintmzYWPVWX8FQI
   A==;
X-IronPort-AV: E=Sophos;i="5.93,244,1654585200"; 
   d="scan'208";a="176816625"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2022 12:31:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 17 Aug 2022 12:31:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 17 Aug 2022 12:31:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <vladimir.oltean@nxp.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 8/8] net: lan966x: Extend MAC to support also lag interfaces.
Date:   Wed, 17 Aug 2022 21:34:49 +0200
Message-ID: <20220817193449.1673002-9-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
References: <20220817193449.1673002-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
 .../ethernet/microchip/lan966x/lan966x_lag.c  |  26 +++++
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 104 +++++++++++++++---
 .../ethernet/microchip/lan966x/lan966x_main.h |   5 +
 3 files changed, 119 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
index e214e8e50723..41fa2523d91d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
@@ -123,8 +123,14 @@ int lan966x_lag_port_join(struct lan966x_port *port,
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct net_device *dev = port->dev;
+	u32 lag_id = -1;
+	u32 bond_mask;
 	int err;
 
+	bond_mask = lan966x_lag_get_mask(lan966x, bond);
+	if (bond_mask)
+		lag_id = __ffs(bond_mask);
+
 	port->bond = bond;
 	lan966x_lag_update_ids(lan966x);
 
@@ -137,6 +143,12 @@ int lan966x_lag_port_join(struct lan966x_port *port,
 
 	lan966x_port_stp_state_set(port, br_port_get_stp_state(brport_dev));
 
+	if (lan966x_lag_first_port(port->bond, port->dev) &&
+	    lag_id != -1)
+		lan966x_mac_lag_replace_port_entry(lan966x,
+						   lan966x->ports[lag_id],
+						   port);
+
 	return 0;
 
 out:
@@ -149,6 +161,20 @@ int lan966x_lag_port_join(struct lan966x_port *port,
 void lan966x_lag_port_leave(struct lan966x_port *port, struct net_device *bond)
 {
 	struct lan966x *lan966x = port->lan966x;
+	u32 bond_mask;
+	u32 lag_id;
+
+	if (lan966x_lag_first_port(port->bond, port->dev)) {
+		bond_mask = lan966x_lag_get_mask(lan966x, port->bond);
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
 	lan966x_lag_update_ids(lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 5893770bfd94..baa3a30c039f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -22,6 +22,7 @@ struct lan966x_mac_entry {
 	u16 vid;
 	u16 port_index;
 	int row;
+	bool lag;
 };
 
 struct lan966x_mac_raw_entry {
@@ -69,15 +70,14 @@ static void lan966x_mac_select(struct lan966x *lan966x,
 	lan_wr(mach, lan966x, ANA_MACHDATA);
 }
 
-static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
-			       bool cpu_copy,
-			       const unsigned char mac[ETH_ALEN],
-			       unsigned int vid,
-			       enum macaccess_entry_type type)
+static int __lan966x_mac_learn_locked(struct lan966x *lan966x, int pgid,
+				      bool cpu_copy,
+				      const unsigned char mac[ETH_ALEN],
+				      unsigned int vid,
+				      enum macaccess_entry_type type)
 {
-	int ret;
+	lockdep_assert_held(&lan966x->mac_lock);
 
-	spin_lock(&lan966x->mac_lock);
 	lan966x_mac_select(lan966x, mac, vid);
 
 	/* Issue a write command */
@@ -89,7 +89,19 @@ static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
 	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_LEARN),
 	       lan966x, ANA_MACACCESS);
 
-	ret = lan966x_mac_wait_for_completion(lan966x);
+	return lan966x_mac_wait_for_completion(lan966x);
+}
+
+static int __lan966x_mac_learn(struct lan966x *lan966x, int pgid,
+			       bool cpu_copy,
+			       const unsigned char mac[ETH_ALEN],
+			       unsigned int vid,
+			       enum macaccess_entry_type type)
+{
+	int ret;
+
+	spin_lock(&lan966x->mac_lock);
+	ret = __lan966x_mac_learn_locked(lan966x, pgid, cpu_copy, mac, vid, type);
 	spin_unlock(&lan966x->mac_lock);
 
 	return ret;
@@ -119,6 +131,16 @@ int lan966x_mac_learn(struct lan966x *lan966x, int port,
 	return __lan966x_mac_learn(lan966x, port, false, mac, vid, type);
 }
 
+static int lan966x_mac_learn_locked(struct lan966x *lan966x, int port,
+				    const unsigned char mac[ETH_ALEN],
+				    unsigned int vid,
+				    enum macaccess_entry_type type)
+{
+	WARN_ON(type != ENTRYTYPE_NORMAL && type != ENTRYTYPE_LOCKED);
+
+	return __lan966x_mac_learn_locked(lan966x, port, false, mac, vid, type);
+}
+
 static int lan966x_mac_forget_locked(struct lan966x *lan966x,
 				     const unsigned char mac[ETH_ALEN],
 				     unsigned int vid,
@@ -178,8 +200,9 @@ void lan966x_mac_init(struct lan966x *lan966x)
 	INIT_LIST_HEAD(&lan966x->mac_entries);
 }
 
-static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *mac,
-							 u16 vid, u16 port_index)
+static struct lan966x_mac_entry *lan966x_mac_alloc_entry(struct lan966x_port *port,
+							 const unsigned char *mac,
+							 u16 vid)
 {
 	struct lan966x_mac_entry *mac_entry;
 
@@ -189,8 +212,9 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
 
 	memcpy(mac_entry->mac, mac, ETH_ALEN);
 	mac_entry->vid = vid;
-	mac_entry->port_index = port_index;
+	mac_entry->port_index = port->chip_port;
 	mac_entry->row = LAN966X_MAC_INVALID_ROW;
+	mac_entry->lag = port->bond ? true : false;
 	return mac_entry;
 }
 
@@ -269,7 +293,7 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 		goto mac_learn;
 	}
 
-	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
+	mac_entry = lan966x_mac_alloc_entry(port, addr, vid);
 	if (!mac_entry) {
 		spin_unlock(&lan966x->mac_lock);
 		return -ENOMEM;
@@ -278,7 +302,8 @@ int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
 	list_add_tail(&mac_entry->list, &lan966x->mac_entries);
 	spin_unlock(&lan966x->mac_lock);
 
-	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid, port->dev);
+	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid,
+				   port->bond ?: port->dev);
 
 mac_learn:
 	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
@@ -309,6 +334,50 @@ int lan966x_mac_del_entry(struct lan966x *lan966x, const unsigned char *addr,
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
+			lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+						  mac_entry->vid,
+						  ENTRYTYPE_LOCKED);
+
+			lan966x_mac_learn_locked(lan966x, dst->chip_port,
+						 mac_entry->mac, mac_entry->vid,
+						 ENTRYTYPE_LOCKED);
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
+			lan966x_mac_forget_locked(lan966x, mac_entry->mac,
+						  mac_entry->vid,
+						  ENTRYTYPE_LOCKED);
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
@@ -354,6 +423,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 	struct lan966x_mac_entry *mac_entry, *tmp;
 	unsigned char mac[ETH_ALEN] __aligned(2);
 	struct list_head mac_deleted_entries;
+	struct lan966x_port *port;
 	u32 dest_idx;
 	u32 column;
 	u16 vid;
@@ -406,9 +476,10 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		/* Notify the bridge that the entry doesn't exist
 		 * anymore in the HW
 		 */
+		port = lan966x->ports[mac_entry->port_index];
 		lan966x_mac_notifiers(SWITCHDEV_FDB_DEL_TO_BRIDGE,
 				      mac_entry->mac, mac_entry->vid,
-				      lan966x->ports[mac_entry->port_index]->dev);
+				      port->bond ?: port->dev);
 		list_del(&mac_entry->list);
 		kfree(mac_entry);
 	}
@@ -440,7 +511,8 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 			continue;
 		}
 
-		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
+		port = lan966x->ports[dest_idx];
+		mac_entry = lan966x_mac_alloc_entry(port, mac, vid);
 		if (!mac_entry) {
 			spin_unlock(&lan966x->mac_lock);
 			return;
@@ -451,7 +523,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 		spin_unlock(&lan966x->mac_lock);
 
 		lan966x_mac_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE,
-				      mac, vid, lan966x->ports[dest_idx]->dev);
+				      mac, vid, port->bond ?: port->dev);
 	}
 }
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 96182ae0df3e..6135d311c407 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -351,6 +351,11 @@ int lan966x_mac_add_entry(struct lan966x *lan966x,
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

