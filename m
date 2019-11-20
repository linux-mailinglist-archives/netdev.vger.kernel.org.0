Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A481038FD
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbfKTLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:42:56 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39178 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728343AbfKTLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 06:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cGC+KzZyZnYDBTTbjC32N2W/N4BXEeNtb6QkXtjVzYc=; b=CVp6P4/wKX+l8IViCiy4gUEXYG
        9PX/mL9NfLYovrd2sl9n5SJJZio5bfli8sB/8XOhaib7FOP5NMn2zhslJgBJCtkL0+w1C0lsNdjAG
        QBaTWTAu9n1FajkLKkvlILZFa4iiI5qO6f4fzEDKZh9WE74+F9JyiCllJ1VH5GfPqNAlw4pPSdGSk
        yVwMPOk8fbXVTO2BNBH8bneYEefARHpgSu2mQI8WwkqoeeOyu5tI61FTTUPEwqermYzIRfuLDTlVw
        lzfz3G5AukXhluDlXbMosxerqfexbHZ+bfQ8/Il9/syif4IqYjHLgFJsJHKrFFjgoHj3e0JXRPzDZ
        xN4zeggg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46180 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXONk-00084S-SQ; Wed, 20 Nov 2019 11:42:48 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iXONj-0005ev-NC; Wed, 20 Nov 2019 11:42:47 +0000
In-Reply-To: <20191120113900.GP25745@shell.armlinux.org.uk>
References: <20191120113900.GP25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sfp: add some quirks for GPON modules
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iXONj-0005ev-NC@rmk-PC.armlinux.org.uk>
Date:   Wed, 20 Nov 2019 11:42:47 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc Micalizzi reports that Huawei MA5671A and Alcatel/Lucent G-010S-P
modules are capable of 2500base-X, but incorrectly report their
capabilities in the EEPROM.  It seems rather common that GPON modules
mis-report.

Let's fix these modules by adding some quirks.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index aebb6978e91a..97680414b5a9 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -38,7 +38,32 @@ struct sfp_bus {
 	bool started;
 };
 
+static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
+				unsigned long *modes)
+{
+	phylink_set(modes, 2500baseX_Full);
+}
+
 static const struct sfp_quirk sfp_quirks[] = {
+	{
+		// Alcatel Lucent G-010S-P can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "G010SP",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Alcatel Lucent G-010S-A can operate at 2500base-X, but
+		// report 3.2GBd NRZ in their EEPROM
+		.vendor = "ALCATELLUCENT",
+		.part = "3FE46541AA",
+		.modes = sfp_quirk_2500basex,
+	}, {
+		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
+		// NRZ in their EEPROM
+		.vendor = "HUAWEI",
+		.part = "MA5671A",
+		.modes = sfp_quirk_2500basex,
+	},
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
-- 
2.20.1

