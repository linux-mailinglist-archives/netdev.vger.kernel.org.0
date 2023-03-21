Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B496C37BA
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjCURGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCURGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:06:00 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E3F28D33
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:05:47 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id c19so18690411qtn.13
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 10:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679418346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Zhl7YUcca1NVbtlRSga+lU7bAqc7c76H70XXEPRnbU=;
        b=chwoNplY+Lr2ajiL3sTdBDyDX/Po6Ek6B1JQtyN7SqN09JLwLR2oDS4h9oBAtGSJvv
         RP+JB2v/1kD1FqAEafOwkUYPAwWaQ8z2YGhxyw1ZvRpQHairGvd/siC/UK3zNWxMaGB3
         Hr4rUl5lSipXDyEwbG/Md/9lrJpZgOEuQOxiE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679418346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Zhl7YUcca1NVbtlRSga+lU7bAqc7c76H70XXEPRnbU=;
        b=g60YwVNGrU8AFyLDoF8+Tvv5DhsNWYbl8Ikb7Kx9F1NYqtj13JmkqUSbkhevYvdORu
         JARdRwtRL21B99XIn/PotnhSi9fQ2AXZQsoNH/4o8ZeI+yXXQM8S/F40cQKq89wA978n
         /z3etej1iADK9qcAs0yLxxNtcAYJiSf1UIR5qDvO9l76uHS3PZICALG1U8jdj1f9yZH9
         r8WYLaVpHtR0zijrntNhfWZkSTjxnTNzWHmA8+NRbmAuuMrSqs35w9Jkb1EiaLbJCfoN
         xp5q8OkPyBAvWtZYdIcG9OVKcZsZJPnTyWAkyJOBH9vrddnRQHJXspNh9awmrepXDwwc
         n0og==
X-Gm-Message-State: AO0yUKVo5M/5t6QsuFrHxDodHgvJoE3ykR2L47s+uYGAmqeMIEiOj69s
        jQoTJZtuBqHkoJyDM7BgXw/tEg==
X-Google-Smtp-Source: AK7set9MzesAz4F9rjjs2B5q05pOEHkeCcO8Ep63SbsTh720zcLHcpOip9Nwio38dNtT+lgKNmg8JQ==
X-Received: by 2002:ac8:5d93:0:b0:3d6:d055:72af with SMTP id d19-20020ac85d93000000b003d6d05572afmr802928qtx.53.1679418345599;
        Tue, 21 Mar 2023 10:05:45 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id l18-20020ac84a92000000b003e3860f12f7sm824726qtq.56.2023.03.21.10.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:05:45 -0700 (PDT)
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
Subject: [PATCHv6 net] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Tue, 21 Mar 2023 10:05:39 -0700
Message-Id: <20230321170539.732147-1-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
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

Issue was originally reported by Anton Lundin on 2022-06-22 (link below).

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

Fixes: e532a096be0e5 ("net: usb: asix: ax88772: add phylib support")
Reported-by: Anton Lundin <glance@acc.umu.se>
Link: https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

V6: overlooked format-path "1/2" when generating this patch.

V5: remove ax88772_mdio_unregister() call from error path in ax88772_init_phy()
    Jakub pointed out ax88772_mdio_unregister() will get called twice.
    (note: putting mdio handling in one function helps avoid this kind of bug.)

V4: add mdio_unregister to ax88172_bind() error handling paths

V3: rebase against netdev/net.git
    remove "TEST" prefix in subject line
    added Link: tag for Reported-by tag

V2: moved mdiobus_get_phy() call back into ax88772_init_phy()
   (Lukas Wunner is entirely correct this patch is much easier
   to backport without this patch hunk.)
   Added "Fixes:" tag per request from Florian Fainelli


diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 743cbf5d662c..f7cff58fe044 100644
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
@@ -896,16 +910,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	ret = ax88772_init_mdio(dev);
 	if (ret)
-		return ret;
+		goto mdio_err;
 
 	ret = ax88772_phylink_setup(dev);
 	if (ret)
-		return ret;
+		goto phylink_err;
 
 	ret = ax88772_init_phy(dev);
 	if (ret)
-		phylink_destroy(priv->phylink);
+		goto initphy_err;
 
+	return 0;
+
+initphy_err:
+	phylink_destroy(priv->phylink);
+phylink_err:
+	ax88772_mdio_unregister(priv);
+mdio_err:
 	return ret;
 }
 
@@ -926,6 +947,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phylink_disconnect_phy(priv->phylink);
 	rtnl_unlock();
 	phylink_destroy(priv->phylink);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

