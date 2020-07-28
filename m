Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E845E2309AD
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbgG1ML7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgG1ML5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:11:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BEDC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:11:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id il6so5747343pjb.0
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=BoIRcYkpwaoeMXf95EOiVvAtXUKM9nng5eKahbFHxk0=;
        b=W0IjsaxbBt2K1dsunf6F5CFyMXnYjNoLHVDT+f2rVqW2cqTVYlgyeTraf9KildRgD/
         gOorHStMc7SIyDZCWPkfy0VFogClmf1zzQnsKFD5XsVJdyTIW3S14XIgwgENqLUFToXx
         ZLbgmC7QhnZ/vpQuRHSr6DQjaPm/9AnPTA9fmOhDhzLonXtjmb/zlNZkbLwkRa1/25Gg
         EQRCO5ajRE3I6IvyqmQe4fnc46u2QMYkdqUCC2iEMRNPgaptx+zf8fmJ+JMGLJy4Eh7X
         6qRTPPdBfVVJv18gT17/04fWNf2Wg0IfPsd4Yw8DfpGpIHN4qIRW2VRKiwZKzWbW0gIp
         WYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BoIRcYkpwaoeMXf95EOiVvAtXUKM9nng5eKahbFHxk0=;
        b=gQ4wuFRtzv6kNUFUEjz7/rXV+kKwsDJhK6EGB5ewP0vr/0jPLDnyLuI43q2l4/nqoW
         2fumOoUPSS6ovzP1+zct57rfv3sAXSBKTTb6DnuHiFTWH40BmZoItz+1spj5xHg5X8x0
         mg68lXMcepvb8pp2csQvs0UQ5H9ecvrnYgn8Dq5lJ6agJjw0aNPNzmmWAAH2P+NIr//c
         tTEXtyUlWUShhtlPA7xuHugkLODDBLHwf0bx9hym0AaQWrf7SvYpauX5RDxGwdOP2LzR
         yraGdGbbBX7CaPqGmeH1KChaDHJXAIvglOSZm6ypRNtKpWXMyAxdy3xgqPQBdGxX1okd
         PTxg==
X-Gm-Message-State: AOAM531bQGOu2lBq48LtYw6tzvDnSTO17z4+FCGSzzhiCOR5HaD76TrV
        NIARn9cJdfrQxIjm9VV/dX68XQ==
X-Google-Smtp-Source: ABdhPJx8wLizm7bleiU52BbMj/W6kpAawOb6yTCHUH8J8ewtPKe7ZMK1OTyUyrp0X7fFOaozruDi7w==
X-Received: by 2002:a17:90a:ce0f:: with SMTP id f15mr4143769pju.96.1595938317075;
        Tue, 28 Jul 2020 05:11:57 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id 17sm18741182pfv.16.2020.07.28.05.11.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 05:11:56 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of ACPI probe
Date:   Tue, 28 Jul 2020 17:41:38 +0530
Message-Id: <1595938298-13190-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Auto-probe of c45 devices with extended scanning in xgmac_mdio works
well but fails to update device "fwnode" while registering PHYs on
MDIO bus.
This patch is based on https://www.spinics.net/lists/netdev/msg662173.html

This change will update the "fwnode" while PHYs get registered and allow
lookup for registered PHYs on MDIO bus from other drivers while probing.

Signed-off-by: Vikas Singh <vikas.singh@puresoftware.com>
---
 drivers/net/phy/mdio_bus.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46b3370..7275eff 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -447,8 +447,25 @@ static void of_mdiobus_link_mdiodev(struct mii_bus *bus,
 	struct device *dev = &mdiodev->dev;
 	struct device_node *child;
 
-	if (dev->of_node || !bus->dev.of_node)
+	if (dev->of_node || !bus->dev.of_node) {
+		/* Checking for acpi node, before returning */
+		struct fwnode_handle *fwnode;
+
+		/* Set the device firmware node to look for child nodes */
+		bus->dev.fwnode = bus->parent->fwnode;
+
+		device_for_each_child_node(&bus->dev, fwnode) {
+			int addr;
+
+			if (fwnode_property_read_u32(fwnode, "reg", &addr))
+				continue;
+			if (addr == mdiodev->addr) {
+				dev->fwnode = fwnode;
+				break;
+			}
+		}
 		return;
+	}
 
 	for_each_available_child_of_node(bus->dev.of_node, child) {
 		int addr;
-- 
2.7.4

