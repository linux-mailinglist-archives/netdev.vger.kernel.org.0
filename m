Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5F44A95D1
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 10:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349469AbiBDJOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 04:14:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24429 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbiBDJOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 04:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643966052; x=1675502052;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e0t0u3AWSc+NQl09DBkRn6jdqub/hd1kTK+/m2Sohzs=;
  b=12oFErgRWYnaLWXrQO0Cys8AXgwrM70BoOCLyTKbdD9kXYFtqKdgvzVn
   9ME1xV1lyJ4cDlG9LQI6/foxNgJTvykTI7Cl8/mEhXHWK57i3BjPT/8i7
   3uVUmgAQUM4fcLC1K41WrXQ+M1tW7zp4f19IjbPLTQbw7TTdmkHBWbk1j
   AXESPO8HZZLXLedFhWzvhnooiRteOoHFXPHBL+piZaqJ3DVhAV1cqFANF
   IouoQ63wX5nVU6qtje8Qhh6fWh4BRFtdAPUkgf8ba0/HcCnGyadLZBIAC
   IZdowqoLOX5V3NPkXCWefPklBh62bC56M14r0SUp8VETguJFQ6jPP2X02
   Q==;
IronPort-SDR: WUJOrylVvoRyECYaYUd8rApT3mKMkFlP7yUlBJjclZnV8E2Md/5N/B4ASzYZO2el8ybP9X3oJe
 2uFe0ZOc645MHxPvZhGUSsrDssW5Mk6QoBA0Evg2MDyHaezuB7j0yfG+6MJY7AQZ8tFwvEzYFf
 KkZUXF0N69/ZsryHpb4oYWqMwoXNZsC+/AvPK/CK9yDD9TjIvDxXg4Hevcm1iugfVplRWPq9Yt
 PRWNTYJgglX8yjwPofHXBiXJqliGchgSh9Xv6EfvaCPMIFwpr+01RtCejLBvoFMn3mT1Di5y0S
 RRZ+VZwujjbP29zmkp9IBMBu
X-IronPort-AV: E=Sophos;i="5.88,342,1635231600"; 
   d="scan'208";a="151947626"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Feb 2022 02:14:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Feb 2022 02:14:09 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Feb 2022 02:14:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/3] net: lan966x: Update mdb when enabling/disabling mcast_snooping
Date:   Fri, 4 Feb 2022 10:14:52 +0100
Message-ID: <20220204091452.403706-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220204091452.403706-1-horatiu.vultur@microchip.com>
References: <20220204091452.403706-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the multicast snooping is disabled, the mdb entries should be
removed from the HW, but they still need to be kept in memory for when
the mcast_snooping will be enabled again.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.h |  2 +
 .../ethernet/microchip/lan966x/lan966x_mdb.c  | 45 +++++++++++++++++++
 .../microchip/lan966x/lan966x_switchdev.c     |  4 ++
 3 files changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 31fc54214041..058e43531818 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -267,6 +267,8 @@ int lan966x_handle_port_mdb_del(struct lan966x_port *port,
 				const struct switchdev_obj *obj);
 void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid);
 void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid);
+void lan966x_mdb_clear_entries(struct lan966x *lan966x);
+void lan966x_mdb_restore_entries(struct lan966x *lan966x);
 
 int lan966x_ptp_init(struct lan966x *lan966x);
 void lan966x_ptp_deinit(struct lan966x *lan966x);
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
index c68d0a99d292..2af55268bf4d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
@@ -504,3 +504,48 @@ void lan966x_mdb_erase_entries(struct lan966x *lan966x, u16 vid)
 			lan966x_mdb_l2_cpu_remove(lan966x, mdb_entry, type);
 	}
 }
+
+void lan966x_mdb_clear_entries(struct lan966x *lan966x)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+	enum macaccess_entry_type type;
+	unsigned char mac[ETH_ALEN];
+
+	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
+		type = lan966x_mdb_classify(mdb_entry->mac);
+
+		lan966x_mdb_encode_mac(mac, mdb_entry, type);
+		/* Remove just the MAC entry, still keep the PGID in case of L2
+		 * entries because this can be restored at later point
+		 */
+		lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
+	}
+}
+
+void lan966x_mdb_restore_entries(struct lan966x *lan966x)
+{
+	struct lan966x_mdb_entry *mdb_entry;
+	enum macaccess_entry_type type;
+	unsigned char mac[ETH_ALEN];
+	bool cpu_copy = false;
+
+	list_for_each_entry(mdb_entry, &lan966x->mdb_entries, list) {
+		type = lan966x_mdb_classify(mdb_entry->mac);
+
+		lan966x_mdb_encode_mac(mac, mdb_entry, type);
+		if (type == ENTRYTYPE_MACV4 || type == ENTRYTYPE_MACV6) {
+			/* Copy the frame to CPU only if the CPU is in the VLAN */
+			if (lan966x_vlan_cpu_member_cpu_vlan_mask(lan966x,
+								  mdb_entry->vid) &&
+			    mdb_entry->cpu_copy)
+				cpu_copy = true;
+
+			lan966x_mac_ip_learn(lan966x, cpu_copy, mac,
+					     mdb_entry->vid, type);
+		} else {
+			lan966x_mac_learn(lan966x, mdb_entry->pgid->index,
+					  mdb_entry->mac,
+					  mdb_entry->vid, type);
+		}
+	}
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index cf2535c18df8..9fce865287e7 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -185,6 +185,10 @@ static void lan966x_port_mc_set(struct lan966x_port *port, bool mcast_ena)
 	struct lan966x *lan966x = port->lan966x;
 
 	port->mcast_ena = mcast_ena;
+	if (mcast_ena)
+		lan966x_mdb_restore_entries(lan966x);
+	else
+		lan966x_mdb_clear_entries(lan966x);
 
 	lan_rmw(ANA_CPU_FWD_CFG_IGMP_REDIR_ENA_SET(mcast_ena) |
 		ANA_CPU_FWD_CFG_MLD_REDIR_ENA_SET(mcast_ena) |
-- 
2.33.0

