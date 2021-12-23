Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC247E446
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 14:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348721AbhLWN7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 08:59:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58427 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239681AbhLWN7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 08:59:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1640267953; x=1671803953;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EXB69/bWWg70XkQ6UZyKSNhZ7G2hQHP0uxwU+r44LAk=;
  b=qz0L2F0Tm/XgGk0KmxF/xpOFCNH45XzoBDKpzsSWYiFzrFnht24fHEEm
   B0+ZFXXIawOiLP9GX8CpTDCrVAPXHE99kAPj9YonuBOKNihC6gxy2kcMn
   6+SWM56govfBcjpE8y8crrhALlcPBaruBrXDQhxyvtmCSymx9U8crLhau
   13aa/ssRo2lzcWWVX+ZJY7/mjvxU8I5IT9JeYVA36y8LswaztcudRlemK
   Kp8S4dTMHmbC76fmLS9bxSgfUz4zshFCI8aJdFHl2/FHYQ0qav4A8qJ5P
   x7+i7eSV9YEfc/Vua9rBXLSNWYocX+HsFC4Nv2EXDSzEf570QP84QYH+M
   g==;
IronPort-SDR: wEO5UEw5N7pnqGV+rL5O4q6uhB5wHKPiPcIBloq2I0zw3OqR+EaOmklXewrxMG2CrLEYYUURMG
 Wsw2TbfgPEy+kXogyU4R3fnS5kkpHmMPiPTwiYozUZ887djrryfPvBi52bGXwYQCI6mD2IIqub
 Z9JeiGO0+R6P6J4IwOn7sZfE0o0DJHRLMHIioIc3lyXF0om3oPyRLFB45qJ8QrvSte6/uJRqfg
 h72ZrAP6tICE7wvslDkkcvZaVY78kIVvciR2UJJVHELWiygP+tBjWOBeVkeD0OnuxiT+wUAKpT
 CUum+l9QysfNpwKSGswz8qN4
X-IronPort-AV: E=Sophos;i="5.88,229,1635231600"; 
   d="scan'208";a="148180140"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2021 06:59:13 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 23 Dec 2021 06:59:13 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 23 Dec 2021 06:59:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Fix the vlan used by host ports
Date:   Thu, 23 Dec 2021 15:01:13 +0100
Message-ID: <20211223140113.1954778-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit changed the vlan used by the host ports to be 4095
instead of 0.
Because of this change the following issues are seen:
- when the port is probed first it was adding an entry in the MAC table
  with the wrong vlan (port->pvid which is default 0) and not HOST_PVID
- when the port is removed from a bridge, it was using the wrong vlan to
  add entries in the MAC table. It was using the old PVID and not the
  HOST_PVID

This patch fixes this two issues by using the HOST_PVID instead of
port->pvid.

Fixes: 6d2c186afa5d5d ("net: lan966x: Add vlan support.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 54097247c7a7..2cb70da63db3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -322,7 +322,7 @@ static int lan966x_mc_unsync(struct net_device *dev, const unsigned char *addr)
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
 
-	return lan966x_mac_forget(lan966x, addr, port->pvid, ENTRYTYPE_LOCKED);
+	return lan966x_mac_forget(lan966x, addr, HOST_PVID, ENTRYTYPE_LOCKED);
 }
 
 static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
@@ -330,7 +330,7 @@ static int lan966x_mc_sync(struct net_device *dev, const unsigned char *addr)
 	struct lan966x_port *port = netdev_priv(dev);
 	struct lan966x *lan966x = port->lan966x;
 
-	return lan966x_mac_cpu_learn(lan966x, addr, port->pvid);
+	return lan966x_mac_cpu_learn(lan966x, addr, HOST_PVID);
 }
 
 static void lan966x_port_set_rx_mode(struct net_device *dev)
@@ -594,7 +594,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
 
-	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, port->pvid,
+	lan966x_mac_learn(lan966x, PGID_CPU, dev->dev_addr, HOST_PVID,
 			  ENTRYTYPE_LOCKED);
 
 	port->phylink_config.dev = &port->dev->dev;
-- 
2.33.0

