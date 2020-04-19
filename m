Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7360E1AF661
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 05:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDSDRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 23:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725877AbgDSDRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 23:17:20 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32398C061A0C;
        Sat, 18 Apr 2020 20:17:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id x26so3290857pgc.10;
        Sat, 18 Apr 2020 20:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/9+2blz+ncKnafHP5mTK7T5wzerurH4rJmG0iq1jbM=;
        b=RzPeGc2uDHJyYc54hVb4zrjW/dtMrfhJtYsfQtby2LzFeLDRguQoOUEenfTO2pejMa
         dvGLSJfjGN8Rsh4kqr45VtqfOckh5rATcxZDTeJQxFB20STcYrMlchU9zQtEQmkrB4uO
         E6Jx4vMONwIQmyT0vUzMlzy1thj6vh016eWIArk4t5b9OeBqQ2Gr4h8pbhvdksoCYrZO
         JOaztvSg7afpp1DqHCH45qDQsUmOKyRWiKw4JZ/+JSlsGTrWFOIr0z/vDuE4D+H21zlY
         5cvlWIGE/vF9/1f1mXA2E4dyGWapsYXtFlUsu/ujHlSlhcqff5B/YJZ9e5KpCOFvQGQS
         oL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/9+2blz+ncKnafHP5mTK7T5wzerurH4rJmG0iq1jbM=;
        b=HsYbLnUphu2AcivYngoR9gcMebtq52Ln3Hfd4SsHXu2rH48YJXqu6Ycvy9L61XmKwF
         BDyrhG+z//+QNoaz0I37eqYVkpmIcxRnWyM9iMVV6RelEr9axzbQk7VXb6zxO3M7VdlA
         FR84RfK5d/lt4YNA+SvJ/BByLRMpM12zYRiLzBOKszyQSWe6nWTNIhwN/om0FtJKCA/p
         p4VJ74lWwrdXWsXUQumrQtL7NgqsSp74xMdZiJnEclELfnIpHGTupMA6PzI16y6EC1JQ
         5Nx4K9TPz+5m9SrisihGdEuWfsO0Wa+nyO/tq+gxtBGyQjqbDIN0rJfk0jLIEVv+OyiD
         UXgQ==
X-Gm-Message-State: AGi0Pua8BcUsDMye9RKjA6mrpwCOBXTbObVrjYxvPbN3sKU35x88Duxr
        /c5coL0lg0DE6qs7z1gFtjS3j42Y
X-Google-Smtp-Source: APiQypJsqkIKbDg1k4V/HocEOVPl2HjGe5ycVybOqgINQI/1mpMHdDKQGPOPUWyqHHDNZbUN77569w==
X-Received: by 2002:aa7:8d06:: with SMTP id j6mr10674378pfe.237.1587266238819;
        Sat, 18 Apr 2020 20:17:18 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c15sm21640294pgk.66.2020.04.18.20.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 20:17:18 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: Propagate error from bus->reset
Date:   Sat, 18 Apr 2020 20:17:13 -0700
Message-Id: <20200419031713.24423-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a bus->reset() call for the mii_bus structure returns an error (e.g.:
-EPROE_DEFER) we should propagate it accordingly.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb74..346e88435d29 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -627,8 +627,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		gpiod_set_value_cansleep(gpiod, 0);
 	}
 
-	if (bus->reset)
-		bus->reset(bus);
+	if (bus->reset) {
+		err = bus->reset(bus);
+		if (err)
+			goto error_reset_gpiod;
+	}
 
 	for (i = 0; i < PHY_MAX_ADDR; i++) {
 		if ((bus->phy_mask & (1 << i)) == 0) {
@@ -657,7 +660,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		mdiodev->device_remove(mdiodev);
 		mdiodev->device_free(mdiodev);
 	}
-
+error_reset_gpiod:
 	/* Put PHYs in RESET to save power */
 	if (bus->reset_gpiod)
 		gpiod_set_value_cansleep(bus->reset_gpiod, 1);
-- 
2.19.1

