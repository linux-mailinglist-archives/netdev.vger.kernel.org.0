Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242D146E5DC
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhLIJuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:50:01 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:51045 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbhLIJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639043187; x=1670579187;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2vibO2uoqZf56lePTqfmcuhq4j5ZDrTG5UA/9awhExc=;
  b=118ODLegpqQKtKRN7pTqTCe3f1jD5xdqb6NAz+Kxu81CA+8h40UV3Rj/
   /W2CZRT5zhR/zE+cs6HkSK9BVAwq4iCgBAV3KNF8ljSbEMMFLp/VU+NFP
   a3eAsrmC3Gmna66Cay2Ey4t26W/nTNhwKQcVonuxbmRXmoAf5bMyt8pd0
   Pt174F8VoKMQE+Sp1keD6cxj8ZLCdq60ZTaLcYS1AR0lZ57F1SRu8+FmD
   pBhxOk33zHemMozYpkyc2vZRVtDjzF30zn468Xvh3NoKOMQWv8qpq7itX
   g1N06miqvI5uuBcdHCE+kLAqFDUt+Opphb9FBuIU2APVg8pUEaG0+JoK5
   g==;
IronPort-SDR: lXDH/1imyOV3k485jOGPcMGB2RfHrR3BziRfUHpHtBF0n9+eGv04sj5ANfRZoaZU6bFWPEm3eD
 /1jxmtH+02cjA+BOgoi+aDkrqUvTUUpoEvvpiKKKUJ4MdaouPJ3ADg0U6NyUbsovwr8cnpwwRL
 L56+nyrCeiHinsNz8afDaUpCwDPhDAiD+mXodUBlDlMud274Lebt8HUa2K8OR/UQcXTfEtYgMT
 +488JL/65pvAB0G+VIB0hvdo8leE0nHaskRvJUj8liTg9DMyoEKEAO3x+xJjqddwJQ+MLDZvxm
 SCWrYSSF3dUEDf6b0/Repg2m
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="141832183"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2021 02:46:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 9 Dec 2021 02:46:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 9 Dec 2021 02:46:22 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 4/6] net: lan966x: More MAC table functionality
Date:   Thu, 9 Dec 2021 10:46:13 +0100
Message-ID: <20211209094615.329379-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211209094615.329379-1-horatiu.vultur@microchip.com>
References: <20211209094615.329379-1-horatiu.vultur@microchip.com>
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
index c01ab01bffbf..60c0d97c3a98 100644
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
@@ -137,6 +145,49 @@ static struct lan966x_mac_entry *lan966x_mac_alloc_entry(const unsigned char *ma
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
@@ -149,6 +200,63 @@ static void lan966x_fdb_call_notifiers(enum switchdev_notifier_type type,
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
+	mac_entry = lan966x_mac_alloc_entry(addr, vid, port->chip_port);
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
+			lan966x_mac_forget(lan966x, mac_entry->mac, mac_entry->vid,
+					   ENTRYTYPE_LOCKED);
+
+			list_del(&mac_entry->list);
+			kfree(mac_entry);
+		}
+	}
+	spin_unlock_irqrestore(&lan966x->mac_lock, flags);
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

