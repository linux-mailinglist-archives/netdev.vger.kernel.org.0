Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181AD6AF659
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjCGUFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233003AbjCGUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:05:15 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171B7302B7
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 12:05:13 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id r5so15795627qtp.4
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 12:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678219512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4ZfEA88sr4Yu5DcAlEC64/VwnZCJ3mjOQU7Q9Ivctb0=;
        b=BSwqMzItvlqe/iVQBBtJ9RwZ4sy2LK/I1frRYtG6DXTUp6y1zwZphye+mtqLC2DHnl
         BEFiKhK4/Qau6K2hl9exI17mQr3kyO1Sc+Zky/Kjd6NcN64fhM78HLnKg7cOv1si4sIf
         1sefZw8zp+rbmwE2wLAgqzJ3YnTRYk/Z2O+XY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678219512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZfEA88sr4Yu5DcAlEC64/VwnZCJ3mjOQU7Q9Ivctb0=;
        b=mI5TMykQ74gT+gpWlOmNFUnQkfJS54gyffq2uvJaGahf93rzx9zJgvc42NvUFLHVcF
         Gucuhn+Th4xmqIK/2WAWDahXpkqVfgpQHNNAF0LEC+5IpXJ3+3S0tJttFTnV4GW/qrUC
         QX8Q+XF8WWFFGfB3kmVAZOWWIrmdH4Y6D0IZxMJAf9mslNr9qhZHEI8YlQVyF4GWTD4s
         /LSRfKx7d5mDpqCsXe6AuV/5gW0EHQo7SilPDyYnWHOovZ3GDFOSFM9cUGTz4nnmvRpv
         b0wNF5qARr/eyn1uYsvskX3QclT4FSVnV/NHsMpEnYZB4EZAV5mQTVzP5wgiiCT0lSOz
         y6rA==
X-Gm-Message-State: AO0yUKWTW41D0stNHd85C6+b95+neOkQCCBvh4VnBCBp8jgkdEgcT9qe
        CvZUYgbiCyHX0G3VF1ELVuyNsQ==
X-Google-Smtp-Source: AK7set/LzltnJwkKk2I5YL0RjDxBPPpKoKlkTH6bmZiO9KVRgPUTVxI0lcbYew+xriKuDHwcVId4GQ==
X-Received: by 2002:a05:622a:1992:b0:3bf:e408:6c91 with SMTP id u18-20020a05622a199200b003bfe4086c91mr27739627qtc.51.1678219512180;
        Tue, 07 Mar 2023 12:05:12 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id b3-20020ac85bc3000000b003bfb820f17csm10451542qtb.63.2023.03.07.12.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 12:05:11 -0800 (PST)
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
Subject: [PATCHv2 1/2] TEST:net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Tue,  7 Mar 2023 12:05:01 -0800
Message-Id: <20230307200502.2263655-1-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"modprobe asix ; rmmod asix ; modprobe asix" fails with:
   sysfs: cannot create duplicate filename \
   	'/devices/virtual/mdio_bus/usb-003:004'

Issue was originally reported by Anton Lundin on 2022-06-22 14:16 UTC:
   https://lore.kernel.org/netdev/20220623063649.GD23685@pengutronix.de/T/

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
Tested-by: Eizan Miyamoto <eizan@chromium.org>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

V2: moved mdiobus_get_phy() call back into ax88772_init_phy()
   Lukas Wunner is entirely correct this patch is much easier
   to backport without this patch hunk.
   Added "Fixes:" tag per request from Florian Fainelli

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 30e87389aefa1..21845b88a64b9 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -640,8 +640,9 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_init_mdio(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
+	int ret;
 
-	priv->mdio = devm_mdiobus_alloc(&dev->udev->dev);
+	priv->mdio = mdiobus_alloc();
 	if (!priv->mdio)
 		return -ENOMEM;
 
@@ -653,7 +654,20 @@ static int ax88772_init_mdio(struct usbnet *dev)
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
@@ -664,6 +678,7 @@ static int ax88772_init_phy(struct usbnet *dev)
 	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
 	if (!priv->phydev) {
 		netdev_err(dev->net, "Could not find PHY\n");
+		ax88772_mdio_unregister(priv);
 		return -ENODEV;
 	}
 
@@ -805,6 +820,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	struct asix_common_private *priv = dev->driver_priv;
 
 	phy_disconnect(priv->phydev);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.39.2

