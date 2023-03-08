Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4387D6B12EF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjCHUWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCHUW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:22:29 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9562D13DF
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:22:07 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id w23so19484068qtn.6
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678306927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PD91JLCU8nqhNp2BNb4dzqOxQAgF3Zc/WPy6GVFE0p0=;
        b=ZOcl3fp7ndGiAiVoqBqBEmksP9xAYBVNjnDgRyYHemNyWdrJ4o1shbVm0pJfPfG8y5
         K9gaB9riGyqD6CxPY3XIHu9oDvETbLFpfQs6oS/9UhpddEewjAMI0M8HQiLtacWGXb7L
         fCKyJ9J1iHWJr3uLPIQ6CZ3ZWQiZIcApgEIhY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PD91JLCU8nqhNp2BNb4dzqOxQAgF3Zc/WPy6GVFE0p0=;
        b=43/AIfX4R9xPVHoxluhdveq4wZRg6EXoblye9e7zY93i+N73gFr6lIJ63p1IiNZs5O
         j7WIcuhASeq96FETbDLQZfxMSebXsu6Z5677CvtDUtq5Y/zlOEYi1ThOIjYGzuV1XYPy
         U332e+7Uze8GenMQCy6pIJfknUdgsYJlLMhkDvgoQEHzEaDs2KYLd/DWFlbvKgmsap56
         rfKIhL5CWJBvNlitLnGW9CaLvAf+2mz8jiBGjdLBOc0/n1w2rtwcx4f/Ia6nZ2nklSq4
         qMS3LAcr6EbbHwbYBdXOHQdlj8ByWb62YfjztSTy09bNuWhW23npEIcr1F4bDL7iOvuu
         j8Jg==
X-Gm-Message-State: AO0yUKWrsuMbzghvJgGAvvM9aZ57N2qKSIAtJ/49N+GzE9p/6saOjeqR
        J9zKjk71+lw+PVPJ7LW9xfmZyA==
X-Google-Smtp-Source: AK7set/J04Z3urjRtlSVHyLUqlUlW1sElNNZmJ6T58htHxHtalEHFtjeEici3dJzhwjTpzZZQWdRTA==
X-Received: by 2002:ac8:4e86:0:b0:3bf:c961:9309 with SMTP id 6-20020ac84e86000000b003bfc9619309mr32554949qtp.37.1678306926826;
        Wed, 08 Mar 2023 12:22:06 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id e16-20020ac84150000000b003b84b92052asm12180969qtm.57.2023.03.08.12.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:22:06 -0800 (PST)
From:   Grant Grundler <grundler@chromium.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>,
        Anton Lundin <glance@acc.umu.se>
Subject: [PATCHv3 net 1/2] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Wed,  8 Mar 2023 12:21:58 -0800
Message-Id: <20230308202159.2419227-1-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"modprobe asix ; rmmod asix ; modprobe asix" fails with:
   sysfs: cannot create duplicate filename \
   	'/devices/virtual/mdio_bus/usb-003:004'

Issue was originally reported by Anton Lundin on 2022-06-22 14:16 UTC:

Chrome OS team hit the same issue in Feb, 2023 when trying to find
work arounds for other issues with AX88172 devices.

The use of devm_mdiobus_register() with usbnet devices results in the
MDIO data being associated with the USB device. When the asix driver
is unloaded, the USB device continues to exist and the corresponding
"mdiobus_unregister()" is NOT called until the USB device is unplugged
or unauthorized. So the next "modprobe asix" will fail because the MDIO
phy sysfs attributes still exist.

The 'easy' (from a design PoV) fix is to use the non-devm variants of
mdiobus_* functions and explicitly manage this use in the asix_bind
and asix_unbind function calls. I've not explored trying to fix usbnet
initialization so devm_* stuff will work.

Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

V3: rebase against netdev/net.git
    remove "TEST" prefix in subject line
    added Link: tag for Reported-by tag

V2: moved mdiobus_get_phy() call back into ax88772_init_phy()
   (Lukas Wunner is entirely correct this patch is much easier
   to backport without this patch hunk.)
   Added "Fixes:" tag per request from Florian Fainelli

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 743cbf5d662c..538c84909913 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -666,8 +666,9 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_init_mdio(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
+	int ret;
 
-	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
+	priv->mdio = mdiobus_alloc();
 	if (!priv->mdio)
 		return -ENOMEM;
 
@@ -679,7 +680,20 @@ static int ax88772_init_mdio(struct usbnet *dev)
 	snprintf(priv->mdio->id, MII_BUS_ID_SIZE, "usb-%03d:%03d",
 		 dev->udev->bus->busnum, dev->udev->devnum);
 
-	return devm_mdiobus_register(&dev->udev->dev, priv->mdio);
+	ret = mdiobus_register(priv->mdio);
+	if (ret) {
+		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
+		mdiobus_free(priv->mdio);
+		priv->mdio = NULL;
+	}
+
+	return ret;
+}
+
+static void ax88772_mdio_unregister(struct asix_common_private *priv)
+{
+	mdiobus_unregister(priv->mdio);
+	mdiobus_free(priv->mdio);
 }
 
 static int ax88772_init_phy(struct usbnet *dev)
@@ -690,6 +704,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
 	if (!priv->phydev) {
 		netdev_err(dev->net, "Could not find PHY\n");
+		ax88772_mdio_unregister(priv);
 		return -ENODEV;
 	}
 
@@ -926,6 +941,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phylink_disconnect_phy(priv->phylink);
 	rtnl_unlock();
 	phylink_destroy(priv->phylink);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

