Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987EB119410
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfLJVNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:13:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729203AbfLJVNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55B25206EC;
        Tue, 10 Dec 2019 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012387;
        bh=NH8QaUyEOomgIHHhrqcb10mfEPskQkrz6nBh+44/Mwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNRWYjPlCjvGa1bTvIKd6LLQ7d/mznuZ1VR0VbLlvAUWTM40IAAHNCMLy0atyPqKI
         mT1p+mtplOq2Di/jK/DT+d9Cdln9rmlmL/46LU7JjMUeCb+26WBefEOUh4hXJK9hrG
         bs12j+heY//zMJFYn8bQ7KjqUfpw1UcDonUlshmg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 309/350] net: phy: avoid matching all-ones clause 45 PHY IDs
Date:   Tue, 10 Dec 2019 16:06:54 -0500
Message-Id: <20191210210735.9077-270-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit b95e86d846b63b02ecdc94802ddbeaf9005fb6d9 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index adb66a2fae18b..14c6b7597b06e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -488,7 +488,7 @@ static int phy_bus_match(struct device *dev, struct device_driver *drv)
 
 	if (phydev->is_c45) {
 		for (i = 1; i < num_ids; i++) {
-			if (!(phydev->c45_ids.devices_in_package & (1 << i)))
+			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
 				continue;
 
 			if ((phydrv->phy_id & phydrv->phy_id_mask) ==
@@ -632,7 +632,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, int phy_id,
 		int i;
 
 		for (i = 1; i < num_ids; i++) {
-			if (!(c45_ids->devices_in_package & (1 << i)))
+			if (c45_ids->device_ids[i] == 0xffffffff)
 				continue;
 
 			ret = phy_request_driver_module(dev,
@@ -812,10 +812,13 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
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

