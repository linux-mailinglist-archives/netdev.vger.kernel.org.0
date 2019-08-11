Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFBE88F30
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 05:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfHKDTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 23:19:00 -0400
Received: from mail.nic.cz ([217.31.204.67]:47012 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfHKDTA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Aug 2019 23:19:00 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id 917B5140BB0;
        Sun, 11 Aug 2019 05:18:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1565493538; bh=KEbbsOrU5MGqPS0ubDZnkRkVsMzCyFpjRXVGNp18xso=;
        h=From:To:Date;
        b=C5jegzS85mw3B0aifnrnCZIuwDorM+99oNCWASCWiV2J4t20ppaerisZIsB7Ck/SM
         xfprpx3532WUVKPEy0vy/umcmlmbEwkRuxKQf/YyV3dzOJbnWxIae5/1tbZxYaDGi0
         kJNyr1O1BXdHrLXpN6MladhA4ZbxLol1Ea061vwE=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next v2 1/1] net: dsa: fix fixed-link port registration
Date:   Sun, 11 Aug 2019 05:18:57 +0200
Message-Id: <20190811031857.2899-1-marek.behun@nic.cz>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 88d6272acaaa ("net: phy: avoid unneeded MDIO reads in
genphy_read_status") broke fixed link DSA port registration in
dsa_port_fixed_link_register_of: the genphy_read_status does not do what
it is supposed to and the following adjust_link is given wrong
parameters.

This causes a regression on Turris Omnia, where the mvneta driver for
the interface connected to the switch reports crc errors, for some
reason.

I realize this fix is not ideal, something else could change in genphy
functions which could cause DSA fixed-link port to break again.
Hopefully DSA fixed-link port functionality will be converted to phylink
API soon.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
---
 net/dsa/port.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 363eab6df51b..c424ebb373e1 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -485,6 +485,17 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	phydev->interface = mode;
 
 	genphy_config_init(phydev);
+
+	/*
+	 * Commit 88d6272acaaa caused genphy_read_status not to do it's work if
+	 * autonegotiation is enabled and link status did not change. This is
+	 * the case for fixed_phy. By setting phydev->link = 0 before the call
+	 * to genphy_read_status we force it to read and fill in the parameters.
+	 *
+	 * Hopefully this dirty hack will be removed soon by converting DSA
+	 * fixed link ports to phylink API.
+	 */
+	phydev->link = 0;
 	genphy_read_status(phydev);
 
 	if (ds->ops->adjust_link)
-- 
2.21.0

