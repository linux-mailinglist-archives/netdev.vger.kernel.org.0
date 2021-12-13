Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A4E472942
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbhLMKTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:19:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:34207 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244058AbhLMKPN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:15:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639390513; x=1670926513;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1E5hEl0H/Es1Xfn+OtXl9Unn2exeg6OIRZOBRAEd+Ds=;
  b=Hm+TZ+y+85M+ZPuiP/uOuUGTunhR9Wf1tO0IedUU7q02ezM4AnUGZzCs
   90gTkcVyjgVG3rAkwaqQ7WBoxnyJ8nc8U0txZJJ6YxW9j5G7p6h7TCvLE
   LbPG/4vnwooxG/sFSsBB0vNAWixA3Ey9poleXTN+7GbDEHDn9VN2Nf5Dd
   yShahFcnmpk1okleC3UFE1i/BMjBaRHx4siXA/aMn8TXqLqBs9bfgdx5S
   Y6kyDo8eDCZlV9VgyUOxrjXrmHDdUvKc5Py1B5whynImL+nsYoTArKoFr
   o6+zQtfYAkXiqmcOWLYnFUSZ5DUOn/SmdJ5rJFP439spWVoMh3MrtcVAA
   Q==;
IronPort-SDR: qeGGFY7r0k+UWk8I9LEjKIl5bZUT2WiaTy/SDd24ZuYTbJ5hoASpcqcV5n7lKsnYMfBtjbJkS3
 pNwCdNm5o+yluUR0k5i/KkiOES59DjX8OCEjsV0ITGPcbRZ06V4gzE86NmCSTHoMktNFunQPCz
 hiAMcon6frnOi4rC1scj5EaBBXiCFes5zZELzf2Az+pnyELlBy5vM6uy2AeXoRNKXa7Rg81uNH
 Ir5MAJxDyVclUbe8UlD67DI9kEaNvr8sv1cDmD0l++w4P9OUVh3KnOefdfZ5uYR6i8m6+8vKDl
 A5KzgTKchvPZnWKFs9nnLJG1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="142171770"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Dec 2021 03:15:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 13 Dec 2021 03:15:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 13 Dec 2021 03:15:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <vladimir.oltean@nxp.com>, <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v4 06/10] net: lan966x: Remove .ndo_change_rx_flags
Date:   Mon, 13 Dec 2021 11:14:28 +0100
Message-ID: <20211213101432.2668820-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
References: <20211213101432.2668820-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function lan966x_port_change_rx_flags() was used only when
IFF_PROMISC flag was set. In that case it was setting to copy all the
frames to the CPU instead of removing any RX filters. Therefore remove
it.

Fixes: d28d6d2e37d10d ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 23 -------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 512c3d52bf4b..22bb2e4dfdb2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -306,28 +306,6 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	return lan966x_port_ifh_xmit(skb, ifh, dev);
 }
 
-static void lan966x_set_promisc(struct lan966x_port *port, bool enable)
-{
-	struct lan966x *lan966x = port->lan966x;
-
-	lan_rmw(ANA_CPU_FWD_CFG_SRC_COPY_ENA_SET(enable),
-		ANA_CPU_FWD_CFG_SRC_COPY_ENA,
-		lan966x, ANA_CPU_FWD_CFG(port->chip_port));
-}
-
-static void lan966x_port_change_rx_flags(struct net_device *dev, int flags)
-{
-	struct lan966x_port *port = netdev_priv(dev);
-
-	if (!(flags & IFF_PROMISC))
-		return;
-
-	if (dev->flags & IFF_PROMISC)
-		lan966x_set_promisc(port, true);
-	else
-		lan966x_set_promisc(port, false);
-}
-
 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct lan966x_port *port = netdev_priv(dev);
@@ -389,7 +367,6 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_open			= lan966x_port_open,
 	.ndo_stop			= lan966x_port_stop,
 	.ndo_start_xmit			= lan966x_port_xmit,
-	.ndo_change_rx_flags		= lan966x_port_change_rx_flags,
 	.ndo_change_mtu			= lan966x_port_change_mtu,
 	.ndo_set_rx_mode		= lan966x_port_set_rx_mode,
 	.ndo_get_phys_port_name		= lan966x_port_get_phys_port_name,
-- 
2.33.0

