Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2926AA14C9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 11:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfH2JYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 05:24:22 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:41005 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfH2JYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 05:24:20 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: dcw5HvdrWWW4kbMXgGxuMElWhsYPDEZ2r2ibGqZjytgKP860+4DfHv4CXfMD+ddtYGad9OBMgT
 38QTqQVbl2yzZ+ozBONDV5w410Xbb6vA2BfRsO/us879/sNPHi9jBAt6k1gCLn1wweLlZ5pP7l
 NUY5jztFbtc1yKOaHBgYFju0MQRk+A3MIT/Ym64A7PEYgxPqLc1jx0+BMfbu14byb8OEAVjLHH
 O2iC7jC4Stuup5FZl7lCyFZx2Vkd45pwVLTGEoeLzSD/E9Jyac3BplEO9ava/k3m8vjOrXTab5
 pq8=
X-IronPort-AV: E=Sophos;i="5.64,442,1559545200"; 
   d="scan'208";a="44136216"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2019 02:24:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 02:24:16 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Thu, 29 Aug 2019 02:24:17 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <andrew@lunn.ch>,
        <allan.nielsen@microchip.com>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v3 2/2] net: mscc: Implement promisc mode.
Date:   Thu, 29 Aug 2019 11:22:29 +0200
Message-ID: <1567070549-29255-3-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a port is added to the bridge, the port is added in promisc mode. But
the HW is capable of switching the frames therefore is not needed for the
port to be added in promisc mode. In case a user space application requires
for the port to enter promisc mode then is it needed to enter the promisc
mode.

Therefore listen in when the promiscuity on a dev is change and when the
port enters or leaves a bridge. Having this information it is possible to
know when to set the port in promisc mode and when not:
If the port is part of bridge and promiscuity > 1 or if the port is not
part of bridge and promiscuity is > 0 then add then add the port in promisc
mode otherwise don't.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 4d1bce4..292fcc1 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1294,6 +1294,37 @@ static void ocelot_port_attr_mc_set(struct ocelot_port *port, bool mc)
 	ocelot_write_gix(ocelot, val, ANA_PORT_CPU_FWD_CFG, port->chip_port);
 }
 
+static void ocelot_port_attr_promisc_set(struct ocelot_port *port,
+					 unsigned int promisc,
+					 bool is_bridge_port)
+{
+	struct ocelot *ocelot = port->ocelot;
+	u32 val;
+
+	val = ocelot_read_gix(ocelot, ANA_PORT_CPU_FWD_CFG, port->chip_port);
+
+	/* When a port is added to a bridge, the port is added in promisc mode,
+	 * by calling the function 'ndo_set_rx_mode'. But the HW is capable
+	 * of switching the frames therefore is not needed for the port to
+	 * enter in promisc mode.
+	 * But a port needs to be added in promisc mode if an application
+	 * requires it(pcap library). Therefore listen when the
+	 * dev->promiscuity is change and when the port is added or removed from
+	 * the bridge. Using this information, calculate if the promisc mode
+	 * is required in the following way:
+	 */
+	if (!is_bridge_port && promisc > 0) {
+		val |= ANA_PORT_CPU_FWD_CFG_CPU_SRC_COPY_ENA;
+	} else {
+		if (is_bridge_port && promisc > 1)
+			val |= ANA_PORT_CPU_FWD_CFG_CPU_SRC_COPY_ENA;
+		else
+			val &= ~(ANA_PORT_CPU_FWD_CFG_CPU_SRC_COPY_ENA);
+	}
+
+	ocelot_write_gix(ocelot, val, ANA_PORT_CPU_FWD_CFG, port->chip_port);
+}
+
 static int ocelot_port_attr_set(struct net_device *dev,
 				const struct switchdev_attr *attr,
 				struct switchdev_trans *trans)
@@ -1316,6 +1347,10 @@ static int ocelot_port_attr_set(struct net_device *dev,
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot_port, !attr->u.mc_disabled);
 		break;
+	case SWITCHDEV_ATTR_ID_PORT_PROMISCUITY:
+		ocelot_port_attr_promisc_set(ocelot_port, dev->promiscuity,
+					     netif_is_bridge_port(dev));
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -1688,6 +1723,18 @@ static int ocelot_netdevice_port_event(struct net_device *dev,
 
 			ocelot_vlan_port_apply(ocelot_port->ocelot,
 					       ocelot_port);
+
+			/* In case the port is added or removed from the bridge
+			 * is it needed to recaulculate the promiscuity. The
+			 * reason is that when a port leaves the bridge first
+			 * it decrease the promiscuity and then the flag
+			 * IFF_BRIDGE_PORT is removed from dev. Therefor the
+			 * function ocelot_port_attr_promisc is called with
+			 * the wrong arguments.
+			 */
+			ocelot_port_attr_promisc_set(ocelot_port,
+						     dev->promiscuity,
+						     info->linking);
 		}
 		if (netif_is_lag_master(info->upper_dev)) {
 			if (info->linking)
-- 
2.7.4

