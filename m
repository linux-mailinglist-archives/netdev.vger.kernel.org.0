Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78A5454C0F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 18:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239460AbhKQRjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 12:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbhKQRjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 12:39:31 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333A0C061570;
        Wed, 17 Nov 2021 09:36:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id gt5so2925464pjb.1;
        Wed, 17 Nov 2021 09:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29Rmx8DNucNaV/O5h3+ze87UeXRGQizoKrqkXB/wnKs=;
        b=L+tXqFx6v3RMA5EJy5wqOYro16Hbwhddv3N6Fyq20UykDSytRd5B3kge8Dplrt5NpO
         qUK1GRsbG6euqPYMbCAFI0kRBjv9f5Rxv6OJWpXq60gmSWFqJ6catLnOz2u2sCVR/tkh
         OA22/6GlyrDinFzL/BW7a9J+O3ZHHvEOxfeS1bMowIlPdRgq21RO4I/AXCIJYwBbbPFf
         bq5GXavUHBq3MNhGzvZeSsBQKsbiD63dyG0Oq9Ml9vn1y3jWB5ob4hImZkwvurbR1GLg
         IvcOtvfE3Np2rUa6EUYTG6WmU1hf8eH0C5fPdoIttPV5Sr1UwSqW8SoqCgz3XBfSYjvD
         ygBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29Rmx8DNucNaV/O5h3+ze87UeXRGQizoKrqkXB/wnKs=;
        b=kZravSMOYYhZv3aQG3+pJuGxkCCqaf1sE54wvhtNgmyiBc3c08bkxvyhY6dd2bjmZf
         Od5vcGmXVRtHCR5/F3JRJ3Mbpp+VgN7kdL3gXD5rLp6rpLpyzJPefooPOiGxygJUh4mx
         bVKJHKxUavFnszrT2Fdfs/jRTWEJO4kwM46nJJMKIpONEp+utvwMcpmsUB7Li/jYd8W4
         +/E17Jtc8I0aahKiEHWtbjxssQGYGzpHRZnIzZlCaT4aua+O+oZJC10G42VKG9eSS238
         x2CzhaFZhVbk3ERxevuB3AlODiQ0ljnNxHjDORz9idi51BZwOXd/GiZMzOZvOps//aOH
         zJOQ==
X-Gm-Message-State: AOAM5331lxqftBuG8wbiRuJCR/p8tCVgBCo84sV/igOiAfrnmdXANaJ0
        sW4/RWclQuOL129VinkpLWf8yhe/NOg=
X-Google-Smtp-Source: ABdhPJyhYj3ig9G6O1tcNZk7fddyL2FNgrquaK7YmQ9OK18CO8mIQ0EA1mM/CgS0i1UMqyDwH2Le2A==
X-Received: by 2002:a17:90a:6e41:: with SMTP id s1mr1709580pjm.166.1637170592276;
        Wed, 17 Nov 2021 09:36:32 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g7sm263092pfv.159.2021.11.17.09.36.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 09:36:31 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: mdio: Replaced BUG_ON() with WARN()
Date:   Wed, 17 Nov 2021 09:36:29 -0800
Message-Id: <20211117173629.2734752-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Killing the kernel because a certain MDIO bus object is not in the
desired state at various points in the registration or unregistration
paths is excessive and is not helping in troubleshooting or fixing
issues. Replace the BUG_ON() with WARN() and print out the MDIO bus name
to facilitate debugging.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c204067f1890..9b6f2df07211 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -176,9 +176,11 @@ static void mdiobus_release(struct device *d)
 {
 	struct mii_bus *bus = to_mii_bus(d);
 
-	BUG_ON(bus->state != MDIOBUS_RELEASED &&
-	       /* for compatibility with error handling in drivers */
-	       bus->state != MDIOBUS_ALLOCATED);
+	WARN(bus->state != MDIOBUS_RELEASED &&
+	     /* for compatibility with error handling in drivers */
+	     bus->state != MDIOBUS_ALLOCATED,
+	     "%s: not in RELEASED or ALLOCATED state\n",
+	     bus->id);
 	kfree(bus);
 }
 
@@ -529,8 +531,9 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		bus->parent->of_node->fwnode.flags |=
 					FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD;
 
-	BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
-	       bus->state != MDIOBUS_UNREGISTERED);
+	WARN(bus->state != MDIOBUS_ALLOCATED &&
+	     bus->state != MDIOBUS_UNREGISTERED,
+	     "%s: not in ALLOCATED or UNREGISTERED state\n", bus->id);
 
 	bus->owner = owner;
 	bus->dev.parent = bus->parent;
@@ -658,7 +661,8 @@ void mdiobus_free(struct mii_bus *bus)
 		return;
 	}
 
-	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
+	WARN(bus->state != MDIOBUS_UNREGISTERED,
+	     "%s: not in UNREGISTERED state\n", bus->id);
 	bus->state = MDIOBUS_RELEASED;
 
 	put_device(&bus->dev);
-- 
2.25.1

