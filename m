Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB910479D8E
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhLRVsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:48:25 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:45440 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhLRVsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 16:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639864102; x=1671400102;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xsrMov8Nc2zo7+8f7qZPWzWqduz/ggZeTzIZrGttFbg=;
  b=b16kW5sDWX7Dqw7vAYIkD35yBPg4+a9nSD336eI75qQqJ4G1sRQ90q5Y
   xkbttLspYr9Z4J4vv/3Unx32aAyowpCp+T7K4+ZChRxIB1wvvt+Z/EciO
   cIMgjWvpzn0ejgziOuj7/XwjCzI7DUIIVw8S+B8+DyHNFB17hJ8Ig+kUz
   sfbJ9WLUEtKm0zR8rqbbKRN9TAJawWyvyTjAQSf3L4RzoeUBEEm1uAS9r
   z0bZexdDRwS7ys1r5t0Ysux37SmK+hPk+hqpH76Lkp9LUHpkAAf0gvkB5
   HRk0PvF9CvmnTz5H3K9eVHP5+aK+yHymPkQ6V+RE1u9QeVpMmVH1WC/Lu
   g==;
IronPort-SDR: n+4kFPyR19mRCl8FmaA4vW1JlMIAZyIOZfVEWWdYoh2NSfKwhvY3O304ANoOUse+7ReKBBIh0K
 oZdmz6puHKSi0HexzEpaPyVWLSW2mVroT9isTaXHhC469aiwBDotf64XDGvcjaPuOrFyzXUDSz
 ZE8jvfH4dVG1sRjr9Ord89/1EymJgbtGoJbRpBrIjjUTVpHKG5VTv5jUuaAksGQH5EU3TIA4db
 ty+mrGHs60E+/fRx2rf6Isz3JGox9RGez/6ttq/d5XUQIpKYCTuwdo2Jwi2y4ZDX6Ptn/EhcTT
 9/2toeSI5K/CQp8CBqkrAVWE
X-IronPort-AV: E=Sophos;i="5.88,217,1635231600"; 
   d="scan'208";a="142863300"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 14:48:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 14:48:20 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 18 Dec 2021 14:48:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v8 4/9] net: lan966x: More MAC table functionality
Date:   Sat, 18 Dec 2021 22:49:41 +0100
Message-ID: <20211218214946.531940-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211218214946.531940-1-horatiu.vultur@microchip.com>
References: <20211218214946.531940-1-horatiu.vultur@microchip.com>
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
 .../ethernet/microchip/lan966x/lan966x_mac.c  | 105 ++++++++++++++++++
 .../ethernet/microchip/lan966x/lan966x_main.h |   9 ++
 2 files changed, 114 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 855ea514f438..efadb8d326cc 100644
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
@@ -137,6 +145,48 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
 	return mac_entry;
 }
 
+static struct lan966x_mac_entry *lan966x_mac_find_entry(struct lan966x *lan966x,
+							const unsigned char *mac,
+							u16 vid, u16 port_index)
+{
+	struct lan966x_mac_entry *res = NULL;
+	struct lan966x_mac_entry *mac_entry;
+
+	spin_lock(&lan966x->mac_lock);
+	list_for_each_entry(mac_entry, &lan966x->mac_entries, list) {
+		if (mac_entry->vid == vid &&
+		    ether_addr_equal(mac, mac_entry->mac) &&
+		    mac_entry->port_index == port_index) {
+			res = mac_entry;
+			break;
+		}
+	}
+	spin_unlock(&lan966x->mac_lock);
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
@@ -149,6 +199,61 @@ static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type,
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
 }
 
+int lan966x_mac_add_entry(struct lan966x *lan966x, struct lan966x_port *port,
+			  const unsigned char *addr, u16 vid)
+{
+	struct lan966x_mac_entry *mac_entry;
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
+	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
+	if (!mac_entry)
+		return -ENOMEM;
+
+	spin_lock(&lan966x->mac_lock);
+	list_add_tail(&mac_entry->list, &lan966x->mac_entries);
+	spin_unlock(&lan966x->mac_lock);
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
+
+	spin_lock(&lan966x->mac_lock);
+	list_for_each_entry_safe(mac_entry, tmp, &lan966x->mac_entries,
+				 list) {
+		if (mac_entry->vid == vid &&
+		    ether_addr_equal(addr, mac_entry->mac)) {
+			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
+					   ENTRYTYPE_LOCKED);
+
+			list_del(&mac_entry->list);
+			kfree(mac_entry);
+		}
+	}
+	spin_unlock(&lan966x->mac_lock);
+
+	return 0;
+}
+
 void lan966x_mac_purge_entries(struct lan966x *lan966x)
 {
 	struct lan966x_mac_entry *mac_entry, *tmp;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index ba548d65b58a..fcd5d09a070c 100644
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
 void lan966x_mac_purge_entries(struct lan966x *lan966x);
 irqreturn_t lan966x_mac_irq_handler(struct lan966x *lan966x);
 
-- 
2.33.0

