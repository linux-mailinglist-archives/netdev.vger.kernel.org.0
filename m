Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055F214E04A
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbgA3RzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:55:06 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:50645 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgA3RzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 12:55:05 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2FB0B2305C;
        Thu, 30 Jan 2020 18:45:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1580406309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HHpCOJ8JX5SEm2UJ7ps+5qppNNw1zZGQMy85Ld7opXo=;
        b=JSrCSURsgccrSywbAtlO6PXcCqRobXYVZA90dLCH9+74fLJAuMEU+6E3b1hBRBmrgaZgs+
        madwBRx0XI/EJ61MizOe5iwpIuWF3CFvFt927r5+AkwT8XnjPnW5aMfup4jG/5QJxQiL11
        d5kg74ug9RbaH7IBqDQ3LIK/cpOhIqk=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/2] net: mdio: of: fix potential NULL pointer derefernce
Date:   Thu, 30 Jan 2020 18:44:50 +0100
Message-Id: <20200130174451.17951-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 2FB0B2305C
X-Spamd-Result: default: False [6.40 / 15.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[gmail.com,armlinux.org.uk,lunn.ch,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

of_find_mii_timestamper() returns NULL if no timestamper is found.
Therefore, guard the unregister_mii_timestamper() calls.

Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time stampers.")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/of/of_mdio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index f5c2a5487761..db0ed5879803 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -81,13 +81,15 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	else
 		phy = get_phy_device(mdio, addr, is_c45);
 	if (IS_ERR(phy)) {
-		unregister_mii_timestamper(mii_ts);
+		if (mii_ts)
+			unregister_mii_timestamper(mii_ts);
 		return PTR_ERR(phy);
 	}
 
 	rc = of_irq_get(child, 0);
 	if (rc == -EPROBE_DEFER) {
-		unregister_mii_timestamper(mii_ts);
+		if (mii_ts)
+			unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		return rc;
 	}
@@ -116,7 +118,8 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 	 * register it */
 	rc = phy_device_register(phy);
 	if (rc) {
-		unregister_mii_timestamper(mii_ts);
+		if (mii_ts)
+			unregister_mii_timestamper(mii_ts);
 		phy_device_free(phy);
 		of_node_put(child);
 		return rc;
-- 
2.20.1

