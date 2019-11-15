Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07B4FE62A
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfKOUIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:08:44 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:50136 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOUIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:08:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tQnthZhZC8DJR7EqbS8iYqYVnqDOIRlvoIT1EhmMwek=; b=Ssmmd4RFSVJmLNI/NgWCuMdtcG
        Ek0Ff51CLMTVtWzUR5eu4l4NXGl0rtKTjsE0/vC/JU/fM69ft22dU9n4dyGwH9CrBl8nmlfxT8zwU
        MqEmtsSmiy6jJal/a/FXzryJ9D3HrG968sOHZbHY6eZUyvEgqTDPMUMGmNCefKkwoFPEy++QYxEo8
        gJQdrpIABuIIYU7/DIgwWZfG3sbCYhsxmo9dOE6kfc97xHdvKkdVaUekZPfTj2UvaZuKSbZcF6SsS
        T63nuTMAyB7Vx8Zte5BENPru0mBewzPHCG+nBgBosI+2eMNxCLe+R6r8sREuWIcE1ClhK/XueOIgI
        WHi97BSQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:55198 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhtW-0003Av-0M; Fri, 15 Nov 2019 20:08:38 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iVhtV-0007hp-Ew; Fri, 15 Nov 2019 20:08:37 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phy: avoid matching all-ones clause 45 PHY IDs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iVhtV-0007hp-Ew@rmk-PC.armlinux.org.uk>
Date:   Fri, 15 Nov 2019 20:08:37 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We currently match clause 45 PHYs using any ID read from a MMD marked
as present in the "Devices in package" registers 5 and 6.  However,
this is incorrect.  45.2 says:

  "The definition of the term package is vendor specific and could be
   a chip, module, or other similar entity."

so a package could be more or less than the whole PHY - a PHY could be
made up of several modules instantiated onto a single chip such as the
Marvell 88x3310, or some of the MMDs could be disabled according to
chip configuration, such as the Broadcom 84881.

In the case of Broadcom 84881, the "Devices in package" registers
contain 0xc000009b, meaning that there is a PHYXS present in the
package, but all registers in MMD 4 return 0xffff.  This leads to our
matching code incorrectly binding this PHY to one of our generic PHY
drivers.

This patch changes the way we determine whether to attempt to match a
MMD identifier, or use it to request a module - if the identifier is
all-ones, then we skip over it. When reading the identifiers, we
initialise phydev->c45_ids.device_ids to all-ones, only reading the
device ID if the "Devices in package" registers indicates we should.

This avoids the generic drivers incorrectly matching on a PHY ID of
0xffffffff.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ff47ec245100..7d5db8b42a4f 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -489,7 +489,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 
 	if (phydev->is_c45) {
 		for (i = 1; i < num_ids; i++) {
-			if (!(phydev->c45_ids.devices_in_package & (1 << i)))
+			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
 				continue;
 
 			if ((phydrv->phy_id & phydrv->phy_id_mask) ==
@@ -633,7 +633,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 		int i;
 
 		for (i = 1; i < num_ids; i++) {
-			if (!(c45_ids->devices_in_package & (1 << i)))
+			if (c45_ids->device_ids[i] == 0xffffffff)
 				continue;
 
 			ret = phy_request_driver_module(dev,
@@ -813,10 +813,13 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
  */
 struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 {
-	struct phy_c45_device_ids c45_ids = {0};
+	struct phy_c45_device_ids c45_ids;
 	u32 phy_id = 0;
 	int r;
 
+	c45_ids.devices_in_package = 0;
+	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
+
 	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
 	if (r)
 		return ERR_PTR(r);
-- 
2.20.1

