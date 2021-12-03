Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A69B467588
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 11:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380136AbhLCKt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 05:49:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32101 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380046AbhLCKt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 05:49:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638528362; x=1670064362;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xFlASKMngTTnllXQZsqjB2ZZqCq5bKfX7HHw+erEgPE=;
  b=JTWALRVKrbQzLtN2VJIiPHnMYBV3BT8P+J5i4DmKdoOAniIygt+QaC4/
   emHaXX8yMTpFvby56AS5MT1+Ew0CDybGVn3o0v8E2gFmIEaLcJnCCq58b
   +SQxRcixZWasmWdKJGPruy6Pvam1irOuDO3eFUbaLFrOqY6YCGXpnLkII
   prjDezvxxiEKbX9j/GhG4hHUg4fTEt1ADtmmCoDC+z8Nxg0gJFtcuXxb/
   HxuzF3qWk9T3xeYoOUU/RJMwHExLgEss2flI8ckwxqfpAyLCDIJh3IloB
   qkru+/AV7upV+vO8wyE9odMcoEVr4lQZBim/9RPFeTuUNg/UEMZSz8260
   g==;
IronPort-SDR: 2OyqNuQOsL6a5e2BxVZ7pNLxUQsEPC5klywpRvdsh30nDaZXCjiLY4hltglY6ku1DLjfTOQdYG
 73r6LEkul7H/YJYvW69BPDognY256oh+urzjKgqX7LDyU8oyach+YwVSjsNo9J8KPbJ9GHUxKc
 fYkJc7xOTk1rFa6/HJmEIjohnuhjfMTlPMbgR2m/DdGlJHtkeNkeeZLfiJRYUxJ0ZcNv4qcynl
 Qs9yx+WGSZO/A5V2SKCn4koq6cnwSJiE/k5VnMBwB6e+uc6sPWV90XGG3vvBeEepanb86WnOXR
 GcAi1luGShMYpgRFIqIDnITS
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="145985164"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Dec 2021 03:46:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 3 Dec 2021 03:46:00 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 3 Dec 2021 03:45:58 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/6] net: lan966x: More MAC table functionality
Date:   Fri, 3 Dec 2021 11:46:43 +0100
Message-ID: <20211203104645.1476704-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
References: <20211203104645.1476704-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for adding/removing mac entries in the SW list
of entries and in the HW table. This is used by the bridge
functionality.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 108 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |   9 ++
 2 files changed, 117 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index d5bb974f49fe..690184eba81b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -111,6 +111,14 @@ int lan966x_mac_cpu_forget(struct lan966x *lan966x, const char *addr, u16 vid)
 	return lan966x_mac_forget(lan966x, addr, vid, ENTRYTYPE_LOCKED);
 }
 
+void lan966x_mac_set_ageing(struct lan966x *lan966x,
+			    u32 ageing)
+{
+	lan_rmw(ANA_AUTOAGE_AGE_PERIOD_SET(ageing / 2),
+		ANA_AUTOAGE_AGE_PERIOD,
+		lan966x, ANA_AUTOAGE);
+}
+
 void lan966x_mac_init(struct lan966x *lan966x)
 {
 	/* Clear the MAC table */
@@ -139,6 +147,49 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(struct lan966x *lan966x
 	return mac_entry;
 }
 
+static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
+							const unsigned char *mac,
+							u16 vid, u16 port_index)
+{
+	struct lan966x_mac_entry *res = NULL;
+	struct lan966x_mac_entry *mac_entry;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lan966x->mac_lock, flags);
+	list_for_each_entry(mac_entry, &lan966x->mac_entries, list) {
+		if (mac_entry->vid == vid &&
+		    ether_addr_equal(mac, mac_entry->mac) &&
+		    mac_entry->port_index == port_index) {
+			res = mac_entry;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
+
+	return res;
+}
+
+static int lan966x_mac_lookup(struct lan966x *lan966x,
+			      const unsigned char mac[ETH_ALEN],
+			      unsigned int vid, enum macaccess_entry_type type)
+{
+	int ret;
+
+	lan966x_mac_select(lan966x, mac, vid);
+
+	/* Issue a read command */
+	lan_wr(ANA_MACACCESS_ENTRYTYPE_SET(type) |
+	       ANA_MACACCESS_VALID_SET(1) |
+	       ANA_MACACCESS_MAC_TABLE_CMD_SET(MACACCESS_CMD_READ),
+	       lan966x, ANA_MACACCESS);
+
+	ret = lan966x_mac_wait_for_completion(lan966x);
+	if (ret)
+		return ret;
+
+	return ANA_MACACCESS_VALID_GET(lan_rd(lan966x, ANA_MACACCESS));
+}
+
 static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type,
 				       const char *mac, u16 vid,
 				       struct net_device *dev)
@@ -151,6 +202,63 @@ static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type,
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
 }
 
+int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
+			  const unsigned char *addr, u16 vid)
+{
+	struct lan966x_mac_entry *mac_entry;
+	unsigned long flags;
+
+	if (lan966x_mac_lookup(lan966x, addr, vid, ENTRYTYPE_NORMAL))
+		return 0;
+
+	/* In case the entry already exists, don't add it again to SW,
+	 * just update HW, but we need to look in the actual HW because
+	 * it is possible for an entry to be learn by HW and before we
+	 * get the interrupt the frame will reach CPU and the CPU will
+	 * add the entry but without the extern_learn flag.
+	 */
+	mac_entry = lan966x_mac_find_entry(lan966x, addr, vid, port->chip_port);
+	if (mac_entry)
+		return lan966x_mac_learn(lan966x, port->chip_port,
+					 addr, vid, ENTRYTYPE_LOCKED);
+
+	mac_entry = lan966x_mac_alloc_entry(lan966x, addr, vid, port->chip_port);
+	if (!mac_entry)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&lan966x->mac_lock, flags);
+	list_add_tail(&mac_entry->list, &lan966x->mac_entries);
+	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
+
+	lan966x_mac_learn(lan966x, port->chip_port, addr, vid, ENTRYTYPE_LOCKED);
+	lan966x_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED, addr, vid, port->dev);
+
+	return 0;
+}
+
+int lan966x_mac_del_entry(struct lan966x *lan966x, const unsigned char *addr,
+			  u16 vid)
+{
+	struct lan966x_mac_entry *mac_entry, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lan966x->mac_lock, flags);
+	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
+				 list) {
+		if ((vid == 0 || mac_entry->vid == vid) &&
+		    ether_addr_equal(addr, mac_entry->mac)) {
+			list_del(&mac_entry->list);
+			devm_kfree(lan966x->dev, mac_entry);
+
+			lan966x_mac_forget(lan966x, addr, mac_entry->vid,
+					   ENTRYTYPE_LOCKED);
+		}
+	}
+	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
+
+	return 0;
+}
+
 static void lan966x_mac_notifiers(struct lan966x *lan966x,
 				  enum switchdev_notifier_type type,
 				  unsigned char *mac, u32 vid,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 7ee622251019..c6749ef0418a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -145,6 +145,15 @@ int lan966x_mac_forget(struct lan966x *lan966x,
 int lan966x_mac_cpu_learn(struct lan966x *lan966x, const char *addr, u16 vid);
 int lan966x_mac_cpu_forget(struct lan966x *lan966x, const char *addr, u16 vid);
 void lan966x_mac_init(struct lan966x *lan966x);
+void lan966x_mac_set_ageing(struct lan966x *lan966x,
+			    u32 ageing);
+int lan966x_mac_del_entry(struct lan966x *lan966x,
+			  const unsigned char *addr,
+			  u16 vid);
+int lan966x_mac_add_entry(struct lan966x *lan966x,
+			  struct lan966x_port *port,
+			  const unsigned char *addr,
+			  u16 vid);
 irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
 
 static inline void __iomem *lan_addr(void __iomem *base[],
-- 
2.33.0

