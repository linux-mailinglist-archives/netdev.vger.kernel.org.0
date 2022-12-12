Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44824649D87
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 12:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbiLLLYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 06:24:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231768AbiLLLYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 06:24:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D6DCC;
        Mon, 12 Dec 2022 03:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670844218; x=1702380218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gDWgZWt68B2FUuPmIEy3AshiMsSgCuxMFYszX/kL4qo=;
  b=nxGyc62mBqB4PLBG3IqkKK2SAXy6UroVDVzUMEPXSY2rqPG+N7YCmznu
   B1Ct03zDWln6QC9znslXSMSzJbKofWdldWewHC9HgVOq7T0Foh1hfqrXY
   +FV1s5R0v+ldNcrd4VAcns8SMNxnVlfJfUSQKda3D9ab5Cas7CikNsvTU
   IlMA1Z4HE36DRaEGOq5XJfSUIZlU0YaO5XAxplZHsi1exXGI+2RR3AjVI
   GJoux6N77hsWnjZAkUlZV36qf2ulkD+e7hacYUXYOUIVnSVoCcm5MGej/
   YvYUFui72X992QC6eJJmAGcpUFdgvSmCTzxUxyMWpSqt5IoAmCKb7dbBv
   w==;
X-IronPort-AV: E=Sophos;i="5.96,238,1665471600"; 
   d="scan'208";a="127662351"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Dec 2022 04:23:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 04:23:35 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 04:23:32 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>, <hkallweit1@gmail.com>
CC:     <sergiu.moga@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH v2 1/2] net: phylink: init phydev on phylink_resume()
Date:   Mon, 12 Dec 2022 13:28:44 +0200
Message-ID: <20221212112845.73290-2-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20221212112845.73290-1-claudiu.beznea@microchip.com>
References: <20221212112845.73290-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are scenarios where PHY power is cut off on system suspend.
There are also MAC drivers which handles themselves the PHY on
suspend/resume path. For such drivers the
struct phy_device::mac_managed_phy is set to true and thus the
mdio_bus_phy_suspend()/mdio_bus_phy_resume() wouldn't do the
proper PHY suspend/resume. For such scenarios call phy_init_hw()
from phylink_resume().

Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---

Hi, Russel,

I let phy_init_hw() to execute for all devices. I can restrict it only
for PHYs that has struct phy_device::mac_managed_phy = true.

Please let me know what you think.

Thank you,
Claudiu Beznea


 drivers/net/phy/phylink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 09cc65c0da93..6003c329638e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -2031,6 +2031,12 @@ void phylink_resume(struct phylink *pl)
 {
 	ASSERT_RTNL();
 
+	if (pl->phydev) {
+		int ret = phy_init_hw(pl->phydev);
+		if (ret)
+			return;
+	}
+
 	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
 		/* Wake-on-Lan enabled, MAC handling */
 
-- 
2.34.1

