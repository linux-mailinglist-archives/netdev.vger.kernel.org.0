Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A089F78AD
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 17:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKKQZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 11:25:00 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:52362 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKQY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 11:24:59 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: TYtC1rAmPclYrH1GZp/AMdIoQjyR9E0gqok6N5hPBk10tcmMsaUS0JvvMtsKN9dc0f3BrDuDs3
 zeO1pe0efHX/BnCM5Niz52/ku3pkqlJC5zQAiyhSLPLhc3RUYgFMyWftbghuIik+xch/8UPjv0
 DPWhe7jhxLtVGNJzGYev6cy4Vz1iyAqJnW2ftA862s1J9dDPS6Hba8J6S45Lj7h7LpSM+h49VI
 gx6f+bkF2WmHGQbrxx+hdzQgUIE4AMuyGhHlChzKbVxmt8mYOz9A7tXSxQwfccFCULo5e4Woyl
 GRQ=
X-IronPort-AV: E=Sophos;i="5.68,293,1569308400"; 
   d="scan'208";a="56519402"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Nov 2019 09:24:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 11 Nov 2019 09:24:43 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 11 Nov 2019 09:24:41 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH] net: mscc: ocelot: reinterpret the return value of of_get_phy_mode
Date:   Mon, 11 Nov 2019 17:21:27 +0100
Message-ID: <20191111162127.18684-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 0c65b2b90d13c ("net: of_get_phy_mode: Change API to solve
int/unit warnings") updated the function of_get_phy_mode declaration.
Now it returns an error code and in case the node doesn't contain the
property 'phy-mode' or 'phy-connection-type' it returns -EINVAL.

In Ocelot the return code of the function was checked against -ENODEV
which is not true so it would failed to probe the port and then
eventually failed to probe the driver.

The fix consists in just checking if the function of_get_phy_mode returns
an error and in that case just fall back and use the interface
PHY_INTERFACE_MODE_NA.

This patch is based on the patch series:
https://patchwork.ozlabs.org/project/netdev/list/?series=141849

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 811599f32910..677701355da2 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -378,6 +378,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		struct phy *serdes;
 		void __iomem *regs;
 		char res_name[8];
+		int phy_err;
 		u32 port;
 
 		if (of_property_read_u32(portnp, "reg", &port))
@@ -410,9 +411,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 
-		err = of_get_phy_mode(portnp, &phy_mode);
-		if (err && err != -ENODEV)
-			goto out_put_ports;
+		phy_err = of_get_phy_mode(portnp, &phy_mode);
+		if (phy_err)
+			phy_mode = PHY_INTERFACE_MODE_NA;
 
 		priv->phy_mode = phy_mode;
 
-- 
2.17.1

