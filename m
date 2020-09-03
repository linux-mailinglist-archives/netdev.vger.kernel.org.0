Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD2B25B9D7
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 06:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgICEkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 00:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgICEj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 00:39:59 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68BEAC061244;
        Wed,  2 Sep 2020 21:39:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w7so1234732pfi.4;
        Wed, 02 Sep 2020 21:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2JGT+fgFiT9d44ntBl7YeWWyDayaJLeuOnriRJgCzxI=;
        b=bZeRSmx8xr8pwp7oWbUo6kXquGeT+av2X0cGEO0nt2ytVAIpyEZKgPcittlejrPX39
         PaI/LQPZR33BLkssVZRgthzov+pdhZHJBRScBxpzrJ8mcFZdSUXaaBDpJe5Tnhrn4CtO
         XACnhNak2A15C71v1/UKU2lnXKYI6ZjbnrG5bGSWYyWa0kJ3QOur/f1rrljYYcgQkpjo
         Ls8byIY4msPDi1IBXSbWeDotTblWndvvC6s9aqowOMslCnvszIiqyR7D/E3vYii2gIUT
         yEY83i6oXkGxxZHxIj9vl08kgtou7o67Te69dS36GuMxFk/H3GPrgaN3x4S9zTu0JHOv
         X2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2JGT+fgFiT9d44ntBl7YeWWyDayaJLeuOnriRJgCzxI=;
        b=LQVRYzxIBs0dzXwX5cQgaZ6GeLFCn/KCO+lswraQrMS49IuBCgTeJKXDxP6OiJxiA5
         JrZyvnZ45+5zcuwct3HUH2bLhaNJRrVkJlNdubBB35qX+ADWfGEXII8616utRoaRJOOU
         tsghSjp/bYqg2uThYbVok1Xf1gFNQDWmC9r9jng+aVuY8dsfeCVa0Rcc2dj/rD9nOf3t
         Z9cWBs5J/iJxAV+GrgvSNDg1JF/9Q1IBF8mLGFkd5wYpn4ZVoA5deR2vFEv5J46xtgnc
         ZsAcLaX+xyqU1157XKvi0JR8jl7bWoEz5UQpoZsS90WvTaNVO6otL7j3LL+u1SyVsQoj
         6BTg==
X-Gm-Message-State: AOAM530zjFKfD1PngMjOv+MgZpreCa2gspWq/ghg4s16WlwHEttIjMma
        evm0LqVwUwb2BSSi/2zCKvD8fPmKQsI=
X-Google-Smtp-Source: ABdhPJz4SFgFUA8VhCofERD5FHGk01Y18R7YvwK6ZqX3E9qAYh39P6uMiYCmwqjH1gKqJJPGKL8KzA==
X-Received: by 2002:a62:108:: with SMTP id 8mr1960153pfb.36.1599107996563;
        Wed, 02 Sep 2020 21:39:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u63sm1251805pfu.34.2020.09.02.21.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 21:39:55 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
Subject: [PATCH net-next 2/3] net: phy: mdio-bcm-unimac: Enable GPHY resources during bus reset
Date:   Wed,  2 Sep 2020 21:39:46 -0700
Message-Id: <20200903043947.3272453-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200903043947.3272453-1-f.fainelli@gmail.com>
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The UniMAC MDIO bus controller allows the interfacing with various
internal Broadcom STB Gigabit PHYs which do require two things:

- they require that a digital clock be enabled for their MDIO interface
  to work at all

- they require that at least one MDIO transaction goes through their
  interface to respond correctly to subsequent MDIO reads

Because of these constraints, we need to have the bus driver's reset
callback to call of_mdiobus_device_enable_resources() in order for
clocks to be enabled prior to doing the dummy BMSR read.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index fbd36891ee64..c8fed16c1f27 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -10,6 +10,7 @@
 #include <linux/platform_device.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/clk.h>
@@ -162,6 +163,7 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 	struct device_node *child;
 	u32 read_mask = 0;
 	int addr;
+	int rc;
 
 	if (!np) {
 		read_mask = ~bus->phy_mask;
@@ -172,6 +174,14 @@ static int unimac_mdio_reset(struct mii_bus *bus)
 				continue;
 
 			read_mask |= 1 << addr;
+
+			/* Enable resources such as clocks *right now* for the
+			 * workaround on the next line to be effective.
+			 */
+			rc = of_mdiobus_device_enable_resources(bus, child,
+								addr);
+			if (rc)
+				return rc;
 		}
 	}
 
-- 
2.25.1

