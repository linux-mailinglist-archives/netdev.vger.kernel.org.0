Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A2E7C718
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfGaPnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:43:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:56231 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaPnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:43:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so61329510wmj.5;
        Wed, 31 Jul 2019 08:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EUajwmMRGVsVrWk0eieYypSiwY+eZYJiiSFARY9Eh0U=;
        b=J5kH6xrcC0auX3oQGQvlTUsxd4krZZWFwF2U0ThyTr3bFJ+yoJUaVJm/l5KxDmv25H
         zz+YhFWJJQqbPmpthnTFx2P0H9SHFhmyYrX6asTGnOgLn4h/3PcmyHubpnqGGepcgCFQ
         5uC4gR7tZxA9U6QZkbGcQI5xLk2pX/HEJYBs0HzAdSs2t1F03oD0foYTqE5YJ4hO7nS4
         w0+xqLQaOYqWfbaH0M5C9T/3igTh/GoLExaLbPUAR3jv+vaKd7EdnO6VR8CictDf6rP0
         IHxUe2w75iDG3WRIcm7Fyse3S//D36xaFZHQ/WuJ2mjibBBNiVRPblwNrcoFAKr4QlyF
         h0VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EUajwmMRGVsVrWk0eieYypSiwY+eZYJiiSFARY9Eh0U=;
        b=Qd/2rcPcNKfuUDl2W5RfgecLsEtFkXXlpueXlxnucUk88wfJlG3vpxCLblgM2a1XzV
         qm1zsQ/8V8hgCR5CWFDIhD4VLGuzTXJYhlUy4Ov3L9UoqHmxdFQMHyR71Tuqj9CZlFje
         TZZMn9do89bLt4IFpdkvk9F/rvGRA66rTd6j8+0opQ9G8jdhdWYTFczVlqlKw7HFlNGV
         Kf1hGBq43yI7It9vPd4T84DLMfl0Cpj6ObRM6/Lt1YUddTe89QLOaTZ/a1Bir7AwuT6Q
         u8Q7veER50NClyd7Jz9H8Jpn7BOCFy54cxyJa/SfMcBfQBsN952K19XN74pvNj4Oh1ge
         msVQ==
X-Gm-Message-State: APjAAAVi1KIV5SC1z3/QhU677TTmB0tXRz5X/CgCIdUupktRLp8R2hck
        98Ec0YjXFYNCPe2UWv3+e9S6Ez9v
X-Google-Smtp-Source: APXvYqyMKfQd8cL8O1b5lX3gtIORrQMZrBXR7f7n6eIF2+qpf/sVd5kG49qLxWrL8b15IBud6DOFjw==
X-Received: by 2002:a1c:a503:: with SMTP id o3mr106451221wme.37.1564587797144;
        Wed, 31 Jul 2019 08:43:17 -0700 (PDT)
Received: from vd-lxpc-hfe.ad.vahle.at ([80.110.31.209])
        by smtp.gmail.com with ESMTPSA id b5sm58738042wru.69.2019.07.31.08.43.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 08:43:16 -0700 (PDT)
From:   Hubert Feurstein <h.feurstein@gmail.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Hubert Feurstein <h.feurstein@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] net: dsa: mv88e6xxx: drop adjust_link to enabled phylink
Date:   Wed, 31 Jul 2019 17:42:39 +0200
Message-Id: <20190731154239.19270-1-h.feurstein@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have to drop the adjust_link callback in order to finally migrate to
phylink.

Otherwise we get the following warning during startup:
  "mv88e6xxx 2188000.ethernet-1:10: Using legacy PHYLIB callbacks. Please
   migrate to PHYLINK!"

The warning is generated in the function dsa_port_link_register_of in
dsa/port.c:

  int dsa_port_link_register_of(struct dsa_port *dp)
  {
  	struct dsa_switch *ds = dp->ds;

  	if (!ds->ops->adjust_link)
  		return dsa_port_phylink_register(dp);

  	dev_warn(ds->dev,
  		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
  	[...]
  }

Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 366f70bfe055..37e8babd035f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -27,7 +27,6 @@
 #include <linux/platform_data/mv88e6xxx.h>
 #include <linux/netdevice.h>
 #include <linux/gpio/consumer.h>
-#include <linux/phy.h>
 #include <linux/phylink.h>
 #include <net/dsa.h>
 
@@ -482,30 +481,6 @@ static int mv88e6xxx_phy_is_internal(struct dsa_switch *ds, int port)
 	return port < chip->info->num_internal_phys;
 }
 
-/* We expect the switch to perform auto negotiation if there is a real
- * phy. However, in the case of a fixed link phy, we force the port
- * settings from the fixed link settings.
- */
-static void mv88e6xxx_adjust_link(struct dsa_switch *ds, int port,
-				  struct phy_device *phydev)
-{
-	struct mv88e6xxx_chip *chip = ds->priv;
-	int err;
-
-	if (!phy_is_pseudo_fixed_link(phydev) &&
-	    mv88e6xxx_phy_is_internal(ds, port))
-		return;
-
-	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_setup_mac(chip, port, phydev->link, phydev->speed,
-				       phydev->duplex, phydev->pause,
-				       phydev->interface);
-	mv88e6xxx_reg_unlock(chip);
-
-	if (err && err != -EOPNOTSUPP)
-		dev_err(ds->dev, "p%d: failed to configure MAC\n", port);
-}
-
 static void mv88e6065_phylink_validate(struct mv88e6xxx_chip *chip, int port,
 				       unsigned long *mask,
 				       struct phylink_link_state *state)
@@ -4755,7 +4730,6 @@ static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
-	.adjust_link		= mv88e6xxx_adjust_link,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_link_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
-- 
2.22.0

