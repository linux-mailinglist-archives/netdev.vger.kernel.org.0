Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29E6EFDADF
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 11:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfKOKNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 05:13:18 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:13802 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbfKOKNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 05:13:17 -0500
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
IronPort-SDR: 8EBBUfrGQD2b2Z1SJjYPxN469Rsz2UulpDa1/FmDuwh73qqXX9R83LiFhKHQnjcNWk48jDpKBz
 5WWJT/6Cihf2jnnYz0iMdeD9+JKZVVWMoRxx68LNl1RD/qQK8KMA3/4h7n6uXs1UN6DrE3vaf7
 lGxR1Ynt+xN0K6ZWy7v2AoNF9Cb5DXo4QKcJi7/IQiEWIMGcWOinvJtzxD0G1Y9TCC1L+zGL26
 27At1rxFEzrtnbElaJ1sbSCnrAFxjScMCZ/mPvlU5V2SfTiGgRpUC0ybrf1c/7VSxmm5mrBALF
 Dfc=
X-IronPort-AV: E=Sophos;i="5.68,308,1569308400"; 
   d="scan'208";a="54473512"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Nov 2019 03:13:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 15 Nov 2019 03:13:14 -0700
Received: from soft-dev3.microsemi.net (10.10.85.251) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 15 Nov 2019 03:13:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v2 net-next] net: mscc: ocelot: omit error check from of_get_phy_mode
Date:   Fri, 15 Nov 2019 11:11:15 +0100
Message-ID: <20191115101115.31392-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 0c65b2b90d13c ("net: of_get_phy_mode: Change API to solve
int/unit warnings") updated the function of_get_phy_mode declaration.
Now it returns an error code and in case the node doesn't contain the
property 'phy-mode' or 'phy-connection-type' it returns -EINVAL and would
set the phy_interface_t to PHY_INTERFACE_MODE_NA.

Ocelot VSC7514 has 4 internal phys which have the phy interface
PHY_INTERFACE_MODE_NA. So because of_get_phy_mode would assign
PHY_INTERFACE_MODE_NA to phy_mode when there is an error, there is no need
to add the error check.

Updates for v2:
 - drop error check because of_get_phy_mode already assigns phy_interface
   to PHY_INTERFACE_MODE in case of error.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_board.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 811599f32910..7fe25cadc171 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -410,9 +410,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		priv = container_of(ocelot_port, struct ocelot_port_private,
 				    port);
 
-		err = of_get_phy_mode(portnp, &phy_mode);
-		if (err && err != -ENODEV)
-			goto out_put_ports;
+		of_get_phy_mode(portnp, &phy_mode);
 
 		priv->phy_mode = phy_mode;
 
-- 
2.17.1

