Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB231BD065
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgD1XHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:07:21 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:41331 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgD1XHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 19:07:19 -0400
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A27DF22802;
        Wed, 29 Apr 2020 01:07:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588115236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mz5eS6TC885v+pJlTmwBKnJ4KfddmXZzoEFMZTkEoUs=;
        b=qsc9vL5wx9lDOsUCqeeCA8NK/Z1ghMULbvr8z1fbwhC+YZCi9PksnnkNEZeVm8/EQUgMl/
        IfC+vDbjhQye81xKk0/F5WHFzM2sdjzHFSdp14hfnbKpgkLP63iDn2S+covJyE1H9KTUMI
        zX0UD6v7SrUS1Me/CajXM3GAx2ovhg0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 4/4] net: phy: bcm54140: add second PHY ID
Date:   Wed, 29 Apr 2020 01:06:59 +0200
Message-Id: <20200428230659.7754-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428230659.7754-1-michael@walle.cc>
References: <20200428230659.7754-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: A27DF22802
X-Spamd-Result: default: False [6.40 / 15.00];
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
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This PHY has two PHY IDs depending on its mode. Adjust the mask so that
it includes both IDs.

Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - leave the PHY ID in brcmphy.h but clear the masked bit
 - fixed typo in commit message

 drivers/net/phy/bcm54140.c | 11 +++++++++--
 include/linux/brcmphy.h    |  2 +-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index d73cbddbc69b..b5325157206a 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -115,6 +115,13 @@
 #define BCM54140_HWMON_IN_ALARM_BIT(ch) ((ch) ? BCM54140_RDB_MON_ISR_3V3 \
 					      : BCM54140_RDB_MON_ISR_1V0)
 
+/* This PHY has two different PHY IDs depening on its MODE_SEL pin. This
+ * pin choses between 4x SGMII and QSGMII mode:
+ *   AE02_5009 4x SGMII
+ *   AE02_5019 QSGMII
+ */
+#define BCM54140_PHY_ID_MASK	0xffffffe8
+
 #define BCM54140_PHY_ID_REV(phy_id)	((phy_id) & 0x7)
 #define BCM54140_REV_B0			1
 
@@ -857,7 +864,7 @@ static int bcm54140_set_tunable(struct phy_device *phydev,
 static struct phy_driver bcm54140_drivers[] = {
 	{
 		.phy_id         = PHY_ID_BCM54140,
-		.phy_id_mask    = 0xfffffff8,
+		.phy_id_mask    = BCM54140_PHY_ID_MASK,
 		.name           = "Broadcom BCM54140",
 		.features       = PHY_GBIT_FEATURES,
 		.config_init    = bcm54140_config_init,
@@ -875,7 +882,7 @@ static struct phy_driver bcm54140_drivers[] = {
 module_phy_driver(bcm54140_drivers);
 
 static struct mdio_device_id __maybe_unused bcm54140_tbl[] = {
-	{ PHY_ID_BCM54140, 0xfffffff8 },
+	{ PHY_ID_BCM54140, BCM54140_PHY_ID_MASK },
 	{ }
 };
 
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 8be150e69c7c..58d0150acc3e 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -25,7 +25,7 @@
 #define PHY_ID_BCM5461			0x002060c0
 #define PHY_ID_BCM54612E		0x03625e60
 #define PHY_ID_BCM54616S		0x03625d10
-#define PHY_ID_BCM54140			0xae025019
+#define PHY_ID_BCM54140			0xae025009
 #define PHY_ID_BCM57780			0x03625d90
 #define PHY_ID_BCM89610			0x03625cd0
 
-- 
2.20.1

