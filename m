Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849C71AF8BF
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSI2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:28:17 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:34769 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgDSI2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:28:17 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E81AA2305A;
        Sun, 19 Apr 2020 10:28:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1587284893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=N4f/9VBPhLcDkVM1aNxaUNDPUksCBDZa/OfflSf7YKw=;
        b=ZoaByf8Jmeub8ToPvGK6RF6T7dRIyRys/a+ZNgoxwfbvWrXDGtWc+QuqZ8EIWN3kCAEQPA
        Sd4KjusP9+fqIvJlPN+aK0RXugJmtPgHJ71QjAa26aP3sA1eKldGO/V9/WTz/YQ5ELbE/G
        9yfbYlcRxyyLIGU2ImYcNFR+dN08gdg=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: phy: mscc: use mdiobus_get_phy()
Date:   Sun, 19 Apr 2020 10:27:57 +0200
Message-Id: <20200419082757.5650-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: E81AA2305A
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         NEURAL_SPAM(0.00)[0.864];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[9];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,nxp.com,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't use internal knowledge of the mdio bus core, instead use
mdiobus_get_phy() which does the same thing.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mscc/mscc_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index acddef79f4e8..5391acdece05 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1292,7 +1292,7 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
  */
 static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 {
-	struct mdio_device **map = phydev->mdio.bus->mdio_map;
+	struct mii_bus *bus = phydev->mdio.bus;
 	struct vsc8531_private *vsc8531;
 	struct phy_device *phy;
 	int i, addr;
@@ -1306,11 +1306,10 @@ static bool vsc8584_is_pkg_init(struct phy_device *phydev, bool reversed)
 		else
 			addr = vsc8531->base_addr + i;
 
-		if (!map[addr])
+		phy = mdiobus_get_phy(bus, addr);
+		if (!phy)
 			continue;
 
-		phy = container_of(map[addr], struct phy_device, mdio);
-
 		if ((phy->phy_id & phydev->drv->phy_id_mask) !=
 		    (phydev->drv->phy_id & phydev->drv->phy_id_mask))
 			continue;
-- 
2.20.1

