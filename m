Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5722974E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 13:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGVLWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 07:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGVLWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 07:22:47 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9570EC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:22:47 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k1so1198349pjt.5
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 04:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:to:cc:subject:date:message-id;
        bh=ppbtRDdrW4HiukMtUI9VlTWqSkbmOUSXjZV3ncDjyPA=;
        b=RgCKZUnwX4ks3539D/BjL7LriOB9AqMQtHZdtTzBxFlQXmbIZIPdsKDpqRGLUd6mua
         403zFCS3J7PO3JExoRSzTYS+p9XSpRZ6XJ72O7/5VKiYsdCyic+ZOokZ0VF2H9AeFR19
         78RvwkocPo169bnh5msHdlUb6JxSQIJrppsqJAUXVrOopZCwefhFKFQrBlX6m5yD/YNk
         CyNKIFD5kmJ4bvB9Op4BP5LohTGhnkdpW1hSi3b50wtDyZHByaf9d98ZLiQiPaPBCLab
         mnR2QDxLCdRar3Uq93DxhqodmSHVsSW5J2jOymNwdaNb+andGA5laLO2TT0yldZpGiKK
         Ke7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=mime-version:x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ppbtRDdrW4HiukMtUI9VlTWqSkbmOUSXjZV3ncDjyPA=;
        b=gkxTeyN44/G13fu5DsDwJT8IeAi2HNpiXT8tLfMqLCAsVmujJAtJIALDGEyxr4PaCS
         JTVGO5gTcj1j5EQIF3kDx8UDmZcSKrtdVQUE7YGj4zgcDxIFwuEyV/zrzYAtnNdL0SF/
         vNH7xP12ZruQ51BzBh6mbDJJsrKb3MN+LPgB8AyzcxwYe1Ceu+M3ByBKR6K+AzMITuiS
         zFleVoIGuTKnMcJK9N/msSTttbbLhyyKpvNfLkGsxzFCD6KhXdwFl0rdrRJuqoaToFst
         7mToPklMRj8X0GbahiK897SGUeuVyhQLnfiGO8x52KIBXT4dDc9hPaVssALriykrqoua
         frKw==
MIME-Version: 1.0
X-Gm-Message-State: AOAM532K4pCjZlA9RbIqVYYafcw/uiRq5vrfUIfAe5Q/NLliSm1sElbj
        ZLblX3p1RKP4+FONB7Uox2qhkvW426xF/zvsM62W1aveAJfi9LwfW1UeThMYTt/LX3DZVDMq4X5
        UfZLiVT9+1iFO+JJZqw==
X-Google-Smtp-Source: ABdhPJxUhJM16tLO/uZ9DZZcfPuwgmQmNb/PNRg6NY7MNc+UQN2rXohmrXO9B7N6YRAUE7/HFcqzww==
X-Received: by 2002:a17:90b:1292:: with SMTP id fw18mr9402252pjb.3.1595416966919;
        Wed, 22 Jul 2020 04:22:46 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id bx18sm6462417pjb.49.2020.07.22.04.22.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 04:22:46 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     kuldip.dwivedi@puresoftware.com, calvin.johnson@oss.nxp.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH] net: Phy: Add PHY lookup support on MDIO bus in case of ACPI probe
Date:   Wed, 22 Jul 2020 16:52:14 +0530
Message-Id: <1595416934-18709-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset="US-ASCII"
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


-- 




*Disclaimer* -The information transmitted is intended solely for the 
individual
or entity to which it is addressed and may contain confidential 
and/or
privileged material. Any review, re-transmission, dissemination or 
other use of
or taking action in reliance upon this information by persons 
or entities other
than the intended recipient is prohibited. If you have 
received this email in
error please contact the sender and delete the 
material from any computer. In
such instances you are further prohibited 
from reproducing, disclosing,
distributing or taking any action in reliance 
on it.As a recipient of this email,
you are responsible for screening its 
contents and the contents of any
attachments for the presence of viruses. 
No liability is accepted for any
damages caused by any virus transmitted by 
this email.
