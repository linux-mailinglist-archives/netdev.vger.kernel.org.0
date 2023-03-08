Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C08E6B12F3
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjCHUWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbjCHUWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:22:31 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB58D13ED
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:22:08 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id r16so17870386qtx.9
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1678306928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlftmzmwWD7xg6TuqYacrBL3Kv3aUcQLEUBIXLbdl4E=;
        b=fmuvGwpEqK2wrmTN7oEvW8EuzjJ7BfXV3y1geVWOsvnUBWXduth9kbw2lG/XfhxEVg
         +I0XKF3FGdElkW5blAjff/xs1E+BNkJ5ze91E8b6QnsAl/XctXC1L28rQUJYg6Y8ivwQ
         WSvUm2JVbze41RCJwhbodmkxkvMQnM51jEFFY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306928;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlftmzmwWD7xg6TuqYacrBL3Kv3aUcQLEUBIXLbdl4E=;
        b=4JacINfysRcTmDgVkq394H0/f17hXcJcao+ZA+rbSLAogbBOfeeqy5D/RWElZ1UYAI
         dZALUhJIIO2NI08JNRu8qNcLyvXp/9AP/BJay1ORy+F/Kd9qcz8OCrQ6W5zc2OKtL5jO
         Ex7mCaUJzYZoJA5IvcuFpMm6y/m+uWGjiOH4KhRdrWUl1sIMwCtgErfgh+ajqfSAWWUH
         gWT7iDadxulpTn63xd19fobvWw0s4jqE+IojmEFuAJROUzQIMxaaQAbQFFnAoNCHFOJf
         qptVc9xprtPg/dXaDyRxKDn2i0shx6AWwf4QwDqhvwXzwN2YgiWXHDP84zxnybw/vCXN
         x49Q==
X-Gm-Message-State: AO0yUKWCjuWozI+oEGLgU3kJHR3oST8WWLbOAhHIdF/gX3edWaTGC50O
        9lY3qs0PkdoWJr26oSp/aUc4jw==
X-Google-Smtp-Source: AK7set/HekkajRV6sKRUXEb32/ZQ6DPiE7DtaHCsLB5sc85jlj9/9XZYIN8SD55u/0yz9IxOFWQnzA==
X-Received: by 2002:a05:622a:144c:b0:3bf:c458:3b0c with SMTP id v12-20020a05622a144c00b003bfc4583b0cmr32457997qtx.30.1678306928057;
        Wed, 08 Mar 2023 12:22:08 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id e16-20020ac84150000000b003b84b92052asm12180969qtm.57.2023.03.08.12.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:22:07 -0800 (PST)
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
Subject: [PATCHv3 net 2/2] net: asix: init mdiobus from one function
Date:   Wed,  8 Mar 2023 12:21:59 -0800
Message-Id: <20230308202159.2419227-2-grundler@chromium.org>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
In-Reply-To: <20230308202159.2419227-1-grundler@chromium.org>
References: <20230308202159.2419227-1-grundler@chromium.org>
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

Make asix driver consistent with other drivers (e.g. tg3 and r8169) which
use mdiobus calls: setup and tear down be handled in one function each.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/asix_devices.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

V3: rebase against netdev/net.git
    add missing whitespace around "="

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 538c84909913..9a1e54ef4ff0 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -663,7 +663,7 @@ static int asix_resume(struct usb_interface *intf)
 	return usbnet_resume(intf);
 }
 
-static int ax88772_init_mdio(struct usbnet *dev)
+static int ax88772_mdio_register(struct usbnet *dev)
 {
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
@@ -683,10 +683,22 @@ static int ax88772_init_mdio(struct usbnet *dev)
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
+		ret = -ENODEV;
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
 
@@ -701,13 +713,6 @@ static int ax88772_init_phy(struct usbnet *dev)
 	struct asix_common_private *priv = dev->driver_priv;
 	int ret;
 
-	priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
-	if (!priv->phydev) {
-		netdev_err(dev->net, "Could not find PHY\n");
-		ax88772_mdio_unregister(priv);
-		return -ENODEV;
-	}
-
 	ret = phylink_connect_phy(priv->phylink, priv->phydev);
 	if (ret) {
 		netdev_err(dev->net, "Could not connect PHY\n");
@@ -909,7 +914,7 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	priv->presvd_phy_bmcr = 0;
 	priv->presvd_phy_advertise = 0;
 
-	ret = ax88772_init_mdio(dev);
+	ret = ax88772_mdio_register(dev);
 	if (ret)
 		return ret;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

