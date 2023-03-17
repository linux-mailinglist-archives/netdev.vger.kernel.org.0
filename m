Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED06BF079
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjCQSNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCQSNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:13:31 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D176252BF
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:13:29 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id op8so3980223qvb.11
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679076809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jMTnlOD473qpHj0Xj3NBgseLLdEcTM5BXiXOjT7tjoQ=;
        b=fHZWEP2Hp4f4wUrGhKM9FHX3Iw23nCpfV0D6bjhRldHgcgIstj+bkU6Y91O1h1mDBa
         IkUlsbosaXmLGjbdhW3F4eONb2YpV2N8sXL+iuUtBbanBMnPN+I8SuATKUTL7qR4WJI0
         mDexiJ2LEPEA5BEyq75s9ZroLaFhTx7IHTn/U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679076809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jMTnlOD473qpHj0Xj3NBgseLLdEcTM5BXiXOjT7tjoQ=;
        b=oQWpd2c93BKemRJgvWVNBwqpMpwhGLw4krkscHGlJ4J8FeLv5TlPa5thQe/vQd1oSi
         eRyEmy6t9TRbnr5aHWSKtWBMmSBdQY63lzbG5i23CKF1xojoe3vYcoJpUvu9osWHS61E
         qpvuPhPNmBtQLkLZGjChDkRnSeLcrVcIrfQJpGaKbFMHKePRCXw93hpoSOuOybbI262L
         MSlhsALjq/kVbkVkTsHv7ulbRR8VUx5FmB6InkXgI13gfaUURGIdOWm7hoth8GHXBpVQ
         YLf0vsXIRpr6dwR5DEjvmF+McWKU0gT9C7krnmXCpszDcI0RlOBjFWl9ejIbVwnYbJwV
         VqBA==
X-Gm-Message-State: AO0yUKVRmmBs9SzcVWQtR4+wo/KiLg0fe1ORIMANc+OiJ50CKx+D+hpq
        2LYQkE0eWwxY3eW5hQp7908XHA==
X-Google-Smtp-Source: AK7set9ki8ECt78rsrF8MX14FC7zBmd34T31gvUKG8YMJ05F1s+5IoU4i3gFBH1VUwF2DYcnj30DGg==
X-Received: by 2002:a05:6214:ca8:b0:5a9:4820:6466 with SMTP id s8-20020a0562140ca800b005a948206466mr35876977qvs.29.1679076808197;
        Fri, 17 Mar 2023 11:13:28 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id p16-20020a05620a057000b00746476405bbsm2069266qkp.122.2023.03.17.11.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 11:13:27 -0700 (PDT)
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
Subject: [PATCHv5 net 1/2] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Fri, 17 Mar 2023 11:13:21 -0700
Message-Id: <20230317181321.3867173-1-grundler@chromium.org>
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

