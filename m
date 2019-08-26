Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 203A59CB59
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 10:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbfHZIOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 04:14:52 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:42666 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730464AbfHZIOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 04:14:51 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: eVFsUDN/amRnlSQCZVMV4sao5p1i7DtXi/dOajpmjsNmo2fkLe9peQNFYHmxtrtpTVUdzwlfrE
 8koAe2D671vvjrafAfT0DmaXXr1RDHStmBVi6qogYWYZNwpYTTJqVPT4W5FMGV+u9mts2WnS4I
 vOHlWX1NGNBZCXkspSlDIJacL9xf5zF3J8uftWvaoKpIS2+obDiUpoQec9tvEPT/oaA8Nv+n56
 37A9y9fMCw6a+Vz7GKLHr/NKVAXGVKXfTmnh5L8+5lKU4MR1lNuwcCECo5tRvUx4SuUZPmwl+B
 M9w=
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="45573032"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2019 01:14:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 01:14:49 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 26 Aug 2019 01:14:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <allan.nielsen@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 3/3] net: mscc: Implement promisc mode.
Date:   Mon, 26 Aug 2019 10:11:15 +0200
Message-ID: <1566807075-775-4-git-send-email-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
References: <1566807075-775-1-git-send-email-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before when a port was added to a bridge then the port was added in
promisc mode. But because of the patches:
commit e6300374f3be6 ("net: Add NETIF_HW_BR_CAP feature")
commit 764866d46cc81 ("net: mscc: Use NETIF_F_HW_BR_CAP")'

The port is not needed to be in promisc mode to be part of the bridge.
So it is possible to togle the promisc mode of the port even if it is or
not part of the bridge.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7d7c94b..8a18eef 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -691,6 +691,25 @@ static void ocelot_set_rx_mode(struct net_device *dev)
 	__dev_mc_sync(dev, ocelot_mc_sync, ocelot_mc_unsync);
 }
 
+static void ocelot_change_rx_flags(struct net_device *dev, int flags)
+{
+	struct ocelot_port *port = netdev_priv(dev);
+	struct ocelot *ocelot = port->ocelot;
+	u32 val;
+
+	if (!(flags & IFF_PROMISC))
+		return;
+
+	val = ocelot_read_gix(ocelot, ANA_PORT_CPU_FWD_CFG,
+			      port->chip_port);
+	if (dev->flags & IFF_PROMISC)
+		val |= ANA_PORT_CPU_FWD_CFG_CPU_SRC_COPY_ENA;
+	else
+		val &= ~(ANA_PORT_CPU_FWD_CFG_CPU_SRC_COPY_ENA);
+
+	ocelot_write_gix(ocelot, val, ANA_PORT_CPU_FWD_CFG, port->chip_port);
+}
+
 static int ocelot_port_get_phys_port_name(struct net_device *dev,
 					  char *buf, size_t len)
 {
@@ -1070,6 +1089,7 @@ static const struct net_device_ops ocelot_port_netdev_ops = {
 	.ndo_stop			= ocelot_port_stop,
 	.ndo_start_xmit			= ocelot_port_xmit,
 	.ndo_set_rx_mode		= ocelot_set_rx_mode,
+	.ndo_change_rx_flags		= ocelot_change_rx_flags,
 	.ndo_get_phys_port_name		= ocelot_port_get_phys_port_name,
 	.ndo_set_mac_address		= ocelot_port_set_mac_address,
 	.ndo_get_stats64		= ocelot_get_stats64,
-- 
2.7.4

