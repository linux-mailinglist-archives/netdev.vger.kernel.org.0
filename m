Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A5A6AF65A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjCGUFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbjCGUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:05:15 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E43C38B53
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 12:05:14 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id c19so15723252qtn.13
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 12:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678219513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lleS4LGwxzhnZ1C+1osdQPnYcQbqHxuWA/mdvIracQ=;
        b=Qm21SdwronVXhihM3Y9UYgYSgpdkOE6i8Y4epRmOjjzPEqN+1JYtV3eVUpneAvRAL7
         j4ufpRX6VXYTrQaeTD0/vLIlECRKjf0P4o5ZJL097xlLteLM2gaHq309YlRtqaN0bcEG
         6iQGhu55T2xkbmg7CH18KPH4nn56+yHCLL86I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678219513;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lleS4LGwxzhnZ1C+1osdQPnYcQbqHxuWA/mdvIracQ=;
        b=5R1LoHdy2J6n+Sx4wf+Fuk9Ee0FClXnxYbQdPCrLJbjux1MrOHsiu02SCyG3QNZbyo
         BvA5gv3GZrI8G7gDXdGq/hEy9kJPbgkv8V2KCisSKYTmIXNBvW8wA3w+a3/DKWwmT5Bs
         LC3RaPLGSuiMugmYSFmlWWcFQ4uSSr1XPZK5OQIrTEcJXm03KqS/wDIee89RftO8hRgh
         icK73v3sO9rrow/zqYCSrwyhUasjGxdzp1S9jiNLoeN7WcxAYhL8NWPy1teQH3mFhxdZ
         z10gdaEx2STij+8VtvS3yt+AZ2AFCvaQ7D4BwOd2V1WkDjKj/X2QVMGWid2AWC24iiK/
         v9WA==
X-Gm-Message-State: AO0yUKU81An3ieEieDBpXsu/BoMrZhaE5ZXbd7ZKWFzvCPeLK2Tyzl+y
        z+t0S6GkOqu8UxFbrlSCUJpBcQ==
X-Google-Smtp-Source: AK7set/6BEEXgmYfSuBx26vYRX30XJoFC5h6wSJls9a4TP7CtMtQu2cBpLvwjuvajkEE0Haj4Xo/Rw==
X-Received: by 2002:a05:622a:4c8:b0:3bf:e05a:f2f2 with SMTP id q8-20020a05622a04c800b003bfe05af2f2mr3622293qtx.31.1678219513431;
        Tue, 07 Mar 2023 12:05:13 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id b3-20020ac85bc3000000b003bfb820f17csm10451542qtb.63.2023.03.07.12.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 12:05:13 -0800 (PST)
From:   Grant Grundler <grundler@chromium.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Lukas Wunner <lukas@wunner.de>
Cc:     Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv2 2/2] net: asix: init mdiobus from one function
Date:   Tue,  7 Mar 2023 12:05:02 -0800
Message-Id: <20230307200502.2263655-2-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230307200502.2263655-1-grundler@chromium.org>
References: <20230307200502.2263655-1-grundler@chromium.org>
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

Make asix driver consistent with other drivers (e.g. tg3 and r8169) which
use mdiobus calls: setup and tear down be handled in one function each.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 21845b88a64b9..d7caab4493d15 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -637,7 +637,7 @@ static int asix_resume(struct usb_interface *intf)
 	return usbnet_resume(intf);
 }
 
-static int ax88772_init_mdio(struct usbnet *dev)
+static int ax88772_mdio_register(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
@@ -657,10 +657,22 @@ static int ax88772_init_mdio(struct usbnet *dev)
 	ret = mdiobus_register(priv->mdio);
 	if (ret) {
 		netdev_err(dev->net, "Could not register MDIO bus (err %d)\n", ret);
-		mdiobus_free(priv->mdio);
-		priv->mdio = NULL;
+		goto mdio_register_err;
 	}
 
+	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
+	if (!priv->phydev) {
+		netdev_err(dev->net, "Could not find PHY\n");
+		ret=-ENODEV;
+		goto mdio_phy_err;
+	}
+
+	return 0;
+
+mdio_phy_err:
+	mdiobus_unregister(priv->mdio);
+mdio_register_err:
+	mdiobus_free(priv->mdio);
 	return ret;
 }
 
@@ -675,13 +687,6 @@ static int ax88772_init_phy(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
-	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
-	if (!priv->phydev) {
-		netdev_err(dev->net, "Could not find PHY\n");
-		ax88772_mdio_unregister(priv);
-		return -ENODEV;
-	}
-
 	ret = phy_connect_direct(dev->net, priv->phydev, &asix_adjust_link,
 				 PHY_INTERFACE_MODE_INTERNAL);
 	if (ret) {
@@ -799,7 +804,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	priv->presvd_phy_bmcr = 0;
 	priv->presvd_phy_advertise = 0;
 
-	ret = ax88772_init_mdio(dev);
+	ret = ax88772_mdio_register(dev);
 	if (ret)
 		return ret;
 
-- 
2.39.2

