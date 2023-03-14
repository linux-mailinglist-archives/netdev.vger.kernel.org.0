Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEAE6B8AD5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjCNFy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjCNFy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:54:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72AD8C822
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:54:22 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id c19so15627523qtn.13
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678773262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cZUrcOEwApRsFF25slrbmDsKbhdNNu2L1mi9TI+ryy4=;
        b=F37hpRYBwdfYrlsTtUAUMX2Zy2J+8I1jy2liucRyNHGHvGvpXQujLUWrPdvwOixeKj
         n8//XY94bBsm1R052ih5K9lLmB9ypIXKS+CUJVvrbPXgBX+wL/LuhJMFcMKRE+yzZrXG
         B95elN27gPHUf6+7Clk0PUfaeWkUOY9USrO0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678773262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZUrcOEwApRsFF25slrbmDsKbhdNNu2L1mi9TI+ryy4=;
        b=FabDnJjwrn2pAiRCQP3sbOr4sZVxtSvritWozI8phwUebuvNnMJGKwdOpLxmoLT3iv
         b9aMrwwbuOqGlEuhXQSf2Kj3ZmMnexWIWQn8UZMXPhTEze8YIWf5yXEjDNt7B/Ln+zu+
         2q6jy7qeIGoyufqh/7ThBsE6JhVNtbybLtv4GxR+xjRdy3SjbhgLfQ+ZJo8AllHDRoi6
         8DOby7gJQy+gB6pF/rdk+X9Fwtaq/UeIEDA0OMnEkVU+envz3O+GCJ1mExRP3vLM9Vrh
         a+321QegQSZzOdebBSLLzp15OSfGCJxfOaGitDUs9Uz8XS5XHi/5WdgPkHWV7QjfW2wD
         jMlQ==
X-Gm-Message-State: AO0yUKXaHNW1Cguqhma8pwDM5G+tQuAtMAyXJIO+nc7gAzzkgbemVdYv
        TnvU0383UO0SKJBqStduML4VVg==
X-Google-Smtp-Source: AK7set+VW1LaqfbGQnmsAVb8xqkicmPSmc61vsG1pDwfj1w6d9w3InZKLxPAzpvXf0uzNCgNP9/9sw==
X-Received: by 2002:a05:622a:46:b0:3b8:6a20:675e with SMTP id y6-20020a05622a004600b003b86a20675emr33906851qtw.29.1678773261970;
        Mon, 13 Mar 2023 22:54:21 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id z9-20020ac86b89000000b003b9bb59543fsm1195290qts.61.2023.03.13.22.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 22:54:21 -0700 (PDT)
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
Subject: [PATCHv4 net] net: asix: fix modprobe "sysfs: cannot create duplicate filename"
Date:   Mon, 13 Mar 2023 22:54:10 -0700
Message-Id: <20230314055410.3329480-1-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
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
 drivers/net/usb/asix_devices.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

V4: add mdio_unregister to ax88172_bind() error handling paths

V3: rebase against netdev/net.git
    remove "TEST" prefix in subject line
    added Link: tag for Reported-by tag

V2: moved mdiobus_get_phy() call back into ax88772_init_phy()
   (Lukas Wunner is entirely correct this patch is much easier
   to backport without this patch hunk.)
   Added "Fixes:" tag per request from Florian Fainelli

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 743cbf5d662c..b758010bab36 100644
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
 
@@ -896,16 +911,23 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 
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
 
@@ -926,6 +948,7 @@ static void ax88772_unbind(struct usbnet *dev, struct usb_interface *intf)
 	phylink_disconnect_phy(priv->phylink);
 	rtnl_unlock();
 	phylink_destroy(priv->phylink);
+	ax88772_mdio_unregister(priv);
 	asix_rx_fixup_common_free(dev->driver_priv);
 }
 
-- 
2.40.0.rc1.284.g88254d51c5-goog

