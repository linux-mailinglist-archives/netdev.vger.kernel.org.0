Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 079FA4CE709
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 21:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbiCEUsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 15:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiCEUsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 15:48:33 -0500
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C1A4B79;
        Sat,  5 Mar 2022 12:47:43 -0800 (PST)
Received: by mail-oo1-xc36.google.com with SMTP id r41-20020a4a966c000000b0031bf85a4124so13346781ooi.0;
        Sat, 05 Mar 2022 12:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmWDiULXXO9OKPemg3Ml8ZSJeDcKg7K/jO+d7Rng05w=;
        b=qvkCaMKMmlQBqATzsJ1wEDTpaDLQi82esav8qCM311jyoq/gtYy+z9UnRyV94JEBQz
         2YyB43a07pzV5W2IQ/6J/jjN4hgdn5MGAbVcreSqlvTtmUCCb0OVTTe6QrbuEriuAmhC
         mt5uDEUCPfDQEuWHY6GM7FAIQGTFxjCqfEgmzJVkNgFF36OPSdHcbI1cg+ps6zXZ3Aat
         7Laj1GNzcGLyZ+GYPOo1mypYtKSqY/zAE3R2skDxhOl58KAqO7fWAn9RwmsQJUzSVDn2
         Z1REG52U16v34qSZJOa7XfwWXiuFXJmDZqzxLYr0d6NEpjuz/kBiImI4Rsct3aLA7YBc
         uEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmWDiULXXO9OKPemg3Ml8ZSJeDcKg7K/jO+d7Rng05w=;
        b=RjCq44gdYsURE20oTRipZrDKJ7lGfNxzM0TDkw8mufiPZTBmGTbbZGNPwsKFY2Jcg+
         1xzI+TxJ6C0XmGIFNrCyEHrkGH+yfPyLIACFXwuc08VF26AvjHej5RMsRV0y0XxN1okD
         eeUbSB2ui0OUNM8G6e0cOH9Cb8raPamHH1lx2wjPkuaiqr6o+WXpUC1rgJazmfNuFbbk
         iplvoZJ15cZa9vQvvjUSHKeGUtQg5tkk8S1vGmQLmsoZQ4awwjHjIushxpUnV/SIJlzr
         UGZ0qwHwn6aKU+0Mq3X44NLEewjoiDguAx0TSjVZnHKwhd+MyoBTihn9ssnXXz6pFr6i
         PLLA==
X-Gm-Message-State: AOAM5333r/OCO1GJZnJMj9ErWG5+oX7d3mHP07FL5dU8q7au5H2iDAdq
        bR9NkuY608X5LEySYpyycCSvWFqKPPQ=
X-Google-Smtp-Source: ABdhPJxE3VofzXpO4ITeice0F/vndo21KKm+TNoNpmWqKijv1rxYR8vLH/qaAhEd/FvmzfL6/YJEtA==
X-Received: by 2002:a05:6870:3816:b0:d2:c31e:cb8c with SMTP id y22-20020a056870381600b000d2c31ecb8cmr2063124oal.172.1646513262448;
        Sat, 05 Mar 2022 12:47:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:4b69:1c78:cdf6:7845:f566])
        by smtp.gmail.com with ESMTPSA id p22-20020a056870831600b000ccfbea4f23sm4198117oae.33.2022.03.05.12.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:47:41 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        fntoth@gmail.com, martyn.welch@collabora.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org, marex@denx.de,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH v2 net] smsc95xx: Ignore -ENODEV errors when device is unplugged
Date:   Sat,  5 Mar 2022 17:47:20 -0300
Message-Id: <20220305204720.2978554-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

According to Documentation/driver-api/usb/URB.rst when a device
is unplugged usb_submit_urb() returns -ENODEV.

This error code propagates all the way up to usbnet_read_cmd() and
usbnet_write_cmd() calls inside the smsc95xx.c driver during
Ethernet cable unplug, unbind or reboot.

This causes the following errors to be shown on reboot, for example:

ci_hdrc ci_hdrc.1: remove, state 1
usb usb2: USB disconnect, device number 1
usb 2-1: USB disconnect, device number 2
usb 2-1.1: USB disconnect, device number 3
smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx' usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
usb 2-1.4: USB disconnect, device number 4
ci_hdrc ci_hdrc.1: USB bus 2 deregistered
ci_hdrc ci_hdrc.0: remove, state 4
usb usb1: USB disconnect, device number 1
ci_hdrc ci_hdrc.0: USB bus 1 deregistered
imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
reboot: Restarting system

Ignore the -ENODEV errors inside __smsc95xx_mdio_read() and
__smsc95xx_phy_wait_not_busy() and do not print error messages
when -ENODEV is returned.

Fixes: a049a30fc27c ("net: usb: Correct PHY handling of smsc95xx")
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- Added 'net' annotation - Andrew
- Added Fixes tag - Andrew
- Avoided undefined 'buf' behaviour in __smsc95xx_read_reg() - Andrew

 drivers/net/usb/smsc95xx.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index b17bff6a1015..e5b744851146 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -84,9 +84,10 @@ static int __must_check __smsc95xx_read_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_READ_REGISTER, USB_DIR_IN
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0)) {
-		netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
-			    index, ret);
+	if (ret < 0) {
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Failed to read reg index 0x%08x: %d\n",
+				    index, ret);
 		return ret;
 	}
 
@@ -116,7 +117,7 @@ static int __must_check __smsc95xx_write_reg(struct usbnet *dev, u32 index,
 	ret = fn(dev, USB_VENDOR_REQUEST_WRITE_REGISTER, USB_DIR_OUT
 		 | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 0, index, &buf, 4);
-	if (unlikely(ret < 0))
+	if (ret < 0 && ret != -ENODEV)
 		netdev_warn(dev->net, "Failed to write reg index 0x%08x: %d\n",
 			    index, ret);
 
@@ -159,6 +160,9 @@ static int __must_check __smsc95xx_phy_wait_not_busy(struct usbnet *dev,
 	do {
 		ret = __smsc95xx_read_reg(dev, MII_ADDR, &val, in_pm);
 		if (ret < 0) {
+			/* Ignore -ENODEV error during disconnect() */
+			if (ret == -ENODEV)
+				return 0;
 			netdev_warn(dev->net, "Error reading MII_ACCESS\n");
 			return ret;
 		}
@@ -194,7 +198,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 	addr = mii_address_cmd(phy_id, idx, MII_READ_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
@@ -206,7 +211,8 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 	ret = __smsc95xx_read_reg(dev, MII_DATA, &val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error reading MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error reading MII_DATA\n");
 		goto done;
 	}
 
@@ -214,6 +220,10 @@ static int __smsc95xx_mdio_read(struct usbnet *dev, int phy_id, int idx,
 
 done:
 	mutex_unlock(&dev->phy_mutex);
+
+	/* Ignore -ENODEV error during disconnect() */
+	if (ret == -ENODEV)
+		return 0;
 	return ret;
 }
 
@@ -235,7 +245,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	val = regval;
 	ret = __smsc95xx_write_reg(dev, MII_DATA, val, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_DATA\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_DATA\n");
 		goto done;
 	}
 
@@ -243,7 +254,8 @@ static void __smsc95xx_mdio_write(struct usbnet *dev, int phy_id,
 	addr = mii_address_cmd(phy_id, idx, MII_WRITE_ | MII_BUSY_);
 	ret = __smsc95xx_write_reg(dev, MII_ADDR, addr, in_pm);
 	if (ret < 0) {
-		netdev_warn(dev->net, "Error writing MII_ADDR\n");
+		if (ret != -ENODEV)
+			netdev_warn(dev->net, "Error writing MII_ADDR\n");
 		goto done;
 	}
 
-- 
2.25.1

