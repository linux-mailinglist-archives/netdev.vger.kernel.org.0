Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2B81DF133
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731233AbgEVVbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:31:33 -0400
Received: from foss.arm.com ([217.140.110.172]:42338 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731167AbgEVVbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 17:31:14 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CACD51435;
        Fri, 22 May 2020 14:31:13 -0700 (PDT)
Received: from mammon-tx2.austin.arm.com (mammon-tx2.austin.arm.com [10.118.28.62])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C39033F68F;
        Fri, 22 May 2020 14:31:13 -0700 (PDT)
From:   Jeremy Linton <jeremy.linton@arm.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [RFC 08/11] net: phy: Allow mdio buses to auto-probe c45 devices
Date:   Fri, 22 May 2020 16:30:56 -0500
Message-Id: <20200522213059.1535892-9-jeremy.linton@arm.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200522213059.1535892-1-jeremy.linton@arm.com>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mdiobus_scan logic is currently hardcoded to only
work with c22 devices. This works fairly well in most
cases, but its possible a c45 device doesn't respond
despite being a standard phy. If the parent hardware
is capable, it makes sense to scan for c45 devices before
falling back to c22.

As we want this to reflect the capabilities of the STA,
lets add a field to the mii_bus structure to represent
the capability. That way devices can opt into the extended
scanning. Existing users should continue to default to c22
only scanning as long as they are zero'ing the structure
before use.

At the moment its a yes/no option, but in the future
it may be useful to extend this to c45 only policy, or
add additional classes and policies.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
---
 drivers/net/phy/mdio_bus.c | 9 +++++++--
 include/linux/phy.h        | 5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb74..3ab618e15f2c 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -732,10 +732,15 @@ EXPORT_SYMBOL(mdiobus_free);
  */
 struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
 {
-	struct phy_device *phydev;
+	struct phy_device *phydev = ERR_PTR(-ENODEV);
 	int err;
 
-	phydev = get_phy_device(bus, addr, false);
+	if (bus->probe_capabilities == MDIOBUS_C45_FIRST)
+		phydev = get_phy_device(bus, addr, true);
+
+	if (IS_ERR(phydev))
+		phydev = get_phy_device(bus, addr, false);
+
 	if (IS_ERR(phydev))
 		return phydev;
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 480a6b153227..d68e1ebab484 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -275,6 +275,11 @@ struct mii_bus {
 	int reset_delay_us;
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
+	/* bus capabilities, used for probing */
+	enum {
+		MDIOBUS_C22_ONLY = 0,
+		MDIOBUS_C45_FIRST,
+	} probe_capabilities;
 };
 #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
 
-- 
2.26.2

