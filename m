Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23476632BA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbjAIVUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbjAIVT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:19:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E67EF01D;
        Mon,  9 Jan 2023 13:19:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673299152; x=1704835152;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version;
  bh=J1yPTJ30ftyyvOnC2+2vUGnUMmEFmadFpDvwb82hEIM=;
  b=ULHb+XzkpAZU1iMyNq8LWdweTltsPOzE8qfHkTQV9VN+AyqN5DdpoeK7
   9t0GcIv4G2LDODqvi0ITX2ZN0vMxHU8+6/e39YYVAffbhXYlp0ostjTTK
   5TCZXv73oEJHkz7Nb7ASUBZYisvVEORCO4g7e3rBgIkg08/EWM6Ss2cUM
   LzWM0j+N/0f+1aPaYyMUczRpm5+pIMs2kjsqV9T99C8ol36CM/rpKGB4A
   IPsW/29hcGtmY82Qf0hgyOo+DQtrxu4B/8XQx9CDWrlWsv+IXIQ6+PVZs
   7FizB767DuzqkXmjtOkp2QQ0m//zwl2jdvNth59qRF9P0UyEiNKpAFPB4
   A==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665471600"; 
   d="scan'208";a="131543916"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2023 14:19:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 9 Jan 2023 14:19:07 -0700
Received: from AUS-LT-C33025.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 9 Jan 2023 14:19:04 -0700
From:   Jerry Ray <jerry.ray@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jerry Ray <jerry.ray@microchip.com>
Subject: [PATCH net-next v6 5/6] dsa: lan9303: Port 0 is xMII port
Date:   Mon, 9 Jan 2023 15:18:48 -0600
Message-ID: <20230109211849.32530-6-jerry.ray@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230109211849.32530-1-jerry.ray@microchip.com>
References: <20230109211849.32530-1-jerry.ray@microchip.com>
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
api, change the macro used to check for the cpu port. In
phylink_mac_link_up, the phydev pointer passed in for the CPU port is
NULL, so we can't keep using phy_is_pseudo_fixed_link(phydev).

Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
---
v5->v6:
  Using port 0 to identify the xMII port on the LAN9303.
---
 drivers/net/dsa/lan9303-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 792ce6a26a6a..7be4c491e5d9 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1063,7 +1063,11 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 {
 	int ctl;
 
-	if (!phy_is_pseudo_fixed_link(phydev))
+	/* On this device, we are only interested in doing something here if
+	 * this is an xMII port. All other ports are 10/100 phys using MDIO
+	 * to control there link settings.
+	 */
+	if (port != 0)
 		return;
 
 	ctl = lan9303_phy_read(ds, port, MII_BMCR);
-- 
2.17.1

