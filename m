Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC06E14E049
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 18:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgA3RzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 12:55:06 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:59651 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbgA3RzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 12:55:05 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 75C55230E1;
        Thu, 30 Jan 2020 18:45:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1580406309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LF6qNmNw/trUkTft0hx/w7E1xf7S5EAwQ+Y50HCvyGI=;
        b=KcoCttbxXt8G4cunF+qBmWPmt7n0qVvZamvfTuRZlB4R9tNLzZ9hxfuISRIEWHifG1zbIg
        /UkkuuBBSnlX/V10G4MSUMONah4PdscSzaFBEv9QKV5OwypQpQykieHKqAu+BBjz7tzuPz
        sGjDI5K09Jf4f0DDGYmEpp8wk9wOKps=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/2] net: mii_timestamper: fix static allocation by PHY driver
Date:   Thu, 30 Jan 2020 18:44:51 +0100
Message-Id: <20200130174451.17951-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200130174451.17951-1-michael@walle.cc>
References: <20200130174451.17951-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 75C55230E1
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

If phydev->mii_ts is set by the PHY driver, it will always be
overwritten in of_mdiobus_register_phy(). Fix it. Also make sure, that
the unregister() doesn't do anything if the mii_timestamper was provided by
the PHY driver.

Fixes: 1dca22b18421 ("net: mdio: of: Register discovered MII time stampers.")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mii_timestamper.c | 7 +++++++
 drivers/of/of_mdio.c              | 8 +++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mii_timestamper.c b/drivers/net/phy/mii_timestamper.c
index 2f12c5d901df..b71b7456462d 100644
--- a/drivers/net/phy/mii_timestamper.c
+++ b/drivers/net/phy/mii_timestamper.c
@@ -111,6 +111,13 @@ void unregister_mii_timestamper(struct mii_timestamper *mii_ts)
 	struct mii_timestamping_desc *desc;
 	struct list_head *this;
 
+	/* mii_timestamper statically registered by the PHY driver won't use the
+	 * register_mii_timestamper() and thus don't have ->device set. Don't
+	 * try to unregister these.
+	 */
+	if (!mii_ts->device)
+		return;
+
 	mutex_lock(&tstamping_devices_lock);
 	list_for_each(this, &mii_timestamping_devices) {
 		desc = list_entry(this, struct mii_timestamping_desc, list);
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index db0ed5879803..8270bbf505fb 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -124,7 +124,13 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio,
 		of_node_put(child);
 		return rc;
 	}
-	phy->mii_ts = mii_ts;
+
+	/* phy->mii_ts may already be defined by the PHY driver. A
+	 * mii_timestamper probed via the device tree will still have
+	 * precedence.
+	 */
+	if (mii_ts)
+		phy->mii_ts = mii_ts;
 
 	dev_dbg(&mdio->dev, "registered phy %pOFn at address %i\n",
 		child, addr);
-- 
2.20.1

