Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18820648ADD
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiLIWrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLIWrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:47:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533761C12A;
        Fri,  9 Dec 2022 14:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670626042; x=1702162042;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=l7YBKmMzDz1O5Koq1YvREF/7MqTU5nkmnxEBATNyr3s=;
  b=zXWENwvKe+AaZCmmgO5cFca27no0p2e9STU1IIYln6Y0esS1ttIZ8QtU
   SSJLTuKazA+I1/XmUKr2gTjHB3y5nAPL//yAgxujAiP8kKtTUvW8ivrWx
   PCoAnOSzmW1niG9mlCQ2ejNI0ODRy7QtZbeBucAHS4uEC55MuGqLw26FG
   3EQtQmye+YdTketwjv6qnyyee2u9Gdyk3PvOUr4zTUrpsihRd1eHY9peU
   PXqInpwBAYJn1/DgaZ4/B5MQpnxR25pmCKaCKis1H2N9Fz5FkVNZME3a2
   qsO8B1iwMvdirH+ZuuVcE37jg8nuMKqkkpqKmNA8vvvHszoO13unOj/ve
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="192458907"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 15:47:21 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 15:47:20 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 9 Dec 2022 15:47:19 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v5 5/6] dsa: lan9303: Determine CPU port based on dsa_switch ptr
Date:   Fri, 9 Dec 2022 16:47:12 -0600
Message-ID: <20221209224713.19980-6-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221209224713.19980-1-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
MIME-Version: 1.0
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

In preparing to move the adjust_link logic into the phylink_mac_link_up
api, change the macro used to check for the cpu port.

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
 drivers/net/dsa/lan9303-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 694249aa1f19..1d22e4b74308 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1064,7 +1064,11 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 	struct lan9303 *chip = ds->priv;
 	int ctl;
 
-	if (!phy_is_pseudo_fixed_link(phydev))
+	/* On this device, we are only interested in doing something here if
+	 * this is the CPU port. All other ports are 10/100 phys using MDIO
+	 * to control there link settings.
+	 */
+	if (!dsa_is_cpu_port(ds, port))
 		return;
 
 	ctl = lan9303_phy_read(ds, port, MII_BMCR);
-- 
2.17.1

