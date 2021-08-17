Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61B133EEC1E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhHQMGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 08:06:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:32569 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236933AbhHQMGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 08:06:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629201973; x=1660737973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d0YdxoDrvHVs1lNXuSmV62CWU56P5lJ/D3zPpVLGKDA=;
  b=Hvpwb0I41gYj95kzfe2hR7k2p+NinHPA391K/MRi2B0UePXSeUXsp3dB
   cjqQ23sMC3LBWyoHXRhUJdUv9adgiAa3RIiBn+HKaza+duqfjK3HeqwBI
   31/gl8nOsajXjl8eKV7zovwD5YJjRFUADCrPmsyPHNXNWYEMdpTRkYE5E
   9+cf8StlEFez9GkiIDzZLZUftX8mLygxACZrlibxHK+Hko5QeJJTgsiln
   0IQW0asxZFXwCwhoYxazj6QIdxclgxz3A9EutS78CfkCUdVNZzYT1ONwP
   /QP2KA9bJMTn2vBdFLUdi27iX0hONvYPgdRDGMfT4BJN6APmSSaTtdp/G
   w==;
IronPort-SDR: oKJO2zoMt4HoXCJf0DCWad569c/0unUIdapNcHUKCkXaJHQQK2iEVLHjPpcDoQqgkoW08XDMQB
 B5qT5LAilPZjjLwXP7BOrusMxKtN0iRwtNsM7fJbOjCo4uV86mmBZZkvOMoNwMM8FciCesK9jL
 TcPmTfCftm+LbcMyBWicIYkREGnYG70v88zpYZTbREGOsagJ3Pgw7WF85Enbbc7hK37nMqegCf
 1Lbs3z0FUoYv8kMdcI20001FagKP38rZy+oizsnoRfSeyeKDqBt32cXK2umVvNezY6pli/TMq+
 j+sVVUSp10ScbEGi4c9YryDW
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="133092090"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2021 05:06:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 17 Aug 2021 05:06:12 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 17 Aug 2021 05:06:10 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: mscc: ocelot: Fix probe for vsc7514
Date:   Tue, 17 Aug 2021 14:06:33 +0200
Message-ID: <20210817120633.404790-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for parsing the 'phy-handle' was removed in the blamed commit.
Therefor it would try to create phylinks for each port and connect to
the phys. But on ocelot_pcb123 and ocelot_pcb120 not all the ports have
a phy, so this will failed. So the probe of the network driver will
fail.

The fix consists in adding back the check for 'phy-handle' for vsc7514

Fixes: e6e12df625f2 ("net: mscc: ocelot: convert to phylink")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 18aed504f45d..96ac64f13382 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -954,6 +954,9 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		if (of_property_read_u32(portnp, "reg", &reg))
 			continue;
 
+		if (!of_parse_phandle(portnp, "phy-handle", 0))
+			continue;
+
 		port = reg;
 		if (port < 0 || port >= ocelot->num_phys_ports) {
 			dev_err(ocelot->dev,
-- 
2.31.1

