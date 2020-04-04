Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A392919E7BC
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 23:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDDVf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 17:35:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37516 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDDVf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 17:35:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id j19so11744557wmi.2;
        Sat, 04 Apr 2020 14:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=U/fdAWib9uvfMhjdQ8dR7Ha7hvvoVTtYuarTgINT4Oo=;
        b=lg2HXQHW+52dOosQI4mBoJYzeXxFXai5axcdyrcyNCS9mAmMPwDCbJ2qhn7auxvUBL
         /Ieb5jGKMxTaCLEkJAX2toSK4VZGYhIsz3TYzc/skrQDldYlwP3yLq6mghWRtPbYgqNV
         FMb4WCjUHW48pY6tPsb4czRAI11XAE5Pf1npn1s//VBVNc5Qideu0h6QRW1RgfeMPEu9
         lsrnXuEOdnp1LFUEYef/osk7kGrBmrcAyoEDcbSH5tLLy4bx6LVaHqlq0Z6YBEgPkrEt
         mjO5TWdq/uBzDXYLETCEbEXfTks+cBAMlCiv4P8mfJx1FM+DpSNhdnKWU7GKcK08lqL7
         5bng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=U/fdAWib9uvfMhjdQ8dR7Ha7hvvoVTtYuarTgINT4Oo=;
        b=XOursfWENeGHowmvPv/Fg7UoUQVJSdN4KJKS22Vl7QElyvXnUXX61KJTNnCNWS2QLo
         UPD4uukHscwl12oV69ys8YFp5q+Awa+PY/aYLK88YTeJ8fZhfxAQ/4p8xD8ReGVf+bKP
         IuYgVfsYIAckTgxytDEH4EQ69Zb8dLVDnFOSYwhuquryjht5DOhDNRurj5tdpzEA0Nng
         1wSX1Q5SbfOzJWpkTi3pTPezuIpgwmA3DhOUPV+9MIp7BdA1FNJJQ0rxeUbsh/czWlKD
         qJsMnYq22xs3MINwCpBQuOD3+vD/R74Yt/aAK5OO8V+ay5t77SU8j78TsfpiJzMoqhB0
         wt/Q==
X-Gm-Message-State: AGi0PubEXnIyiGsNOSRRL+dignah0ZJfxO5L2njtvMIiStGgGk2EYMLd
        xHxHy2dox2xy9uTCQ+EeVfeQDfF0
X-Google-Smtp-Source: APiQypI8gFx9bj1h8ypmohaW4GcmVOfnR7XuoWQUNiHEbAogynCktbyDozjwb05SA4SGrnDxvyiYkQ==
X-Received: by 2002:a1c:4c0f:: with SMTP id z15mr15097456wmf.95.1586036122532;
        Sat, 04 Apr 2020 14:35:22 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u5sm20147834wrp.81.2020.04.04.14.35.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 14:35:21 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
Date:   Sat,  4 Apr 2020 14:35:17 -0700
Message-Id: <20200404213517.12783-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were registering our slave MDIO bus with OF and doing so with
assigning the newly created slave_mii_bus of_node to the master MDIO bus
controller node. This is a bad thing to do for a number of reasons:

- we are completely lying about the slave MII bus is arranged and yet we
  still want to control which MDIO devices it probes. It was attempted
  before to play tricks with the bus_mask to perform that:
  https://www.spinics.net/lists/netdev/msg429420.html but the approach
  was rightfully rejected

- the device_node reference counting is messed up and we are effectively
  doing a double probe on the devices we already probed using the
  master, this messes up all resources reference counts (such as clocks)

The proper fix for this as indicated by David in his reply to the
thread above is to use a platform data style registration so as to
control exactly which devices we probe:
https://www.spinics.net/lists/netdev/msg430083.html

By using mdiobus_register(), our slave_mii_bus->phy_mask value is used
as intended, and all the PHY addresses that must be redirected towards
our slave MDIO bus is happening while other addresses get redirected
towards the master MDIO bus.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index affa5c6e135c..cc95adc5ab4b 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -480,7 +480,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	priv->slave_mii_bus->parent = ds->dev->parent;
 	priv->slave_mii_bus->phy_mask = ~priv->indir_phy_mask;
 
-	err = of_mdiobus_register(priv->slave_mii_bus, dn);
+	err = mdiobus_register(priv->slave_mii_bus);
 	if (err && dn)
 		of_node_put(dn);
 
-- 
2.17.1

