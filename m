Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50564485363
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240099AbiAENUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiAENUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:20:08 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643D8C061784;
        Wed,  5 Jan 2022 05:20:08 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id p13so52785455lfh.13;
        Wed, 05 Jan 2022 05:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7R+Hai4NceFGrOmjDpaXS0exsOExibtRqyXsTiYyoI=;
        b=DKXm5PRaTr+n7fVvlNKsJ18wfkMl/9N/bh49BxjTWE/UMLGZmU5DhmU8RMe+2xOvFh
         xgiizrXNmr0NDZH7FWg/Fw04JrliZehIoipYm3dUyuPX4U5UCjAalunB6mBsFwKG3kxP
         tOPDJCJsJ9UWDgBKEH+q1xFn8NUVApPws0GKyTG12+TZ2ZpaCyH9Om9cuhb9BK7NkgJY
         2V81hepedgbQwdunS1QZlOQLTQEvWXt6N0LN77Eok/WN9Ypt92vVY/2Mv7rdYjnIeXdN
         +X4z+MWRfu21l7skjqxWo4+12iMK7JJTK5susdjKUJfLnb4GBq+FH6phTnYNdGzmQBN/
         Cjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w7R+Hai4NceFGrOmjDpaXS0exsOExibtRqyXsTiYyoI=;
        b=FNwnyUeKYg4huW1Lov4IYjmY6CHzch+uFOlbbR9OyObYFtLj5wHstAKxcdvzOj8OCP
         PyZGEuEtgcQAX5Dxhyv6RgOs+i67FzNZHBI+wVNSRruf7+438iNe/jQ/0RftPmm3BsuR
         8qoCkCtwpTEebMfdrb5Snm7BqsLTxHGhDxohH4cPfA+mbUgcNaiY5cLIzgduZrfAqfCc
         2JSvm/VLmZrcnbDNLhJX7pQUjbNx7DhzpGyy9QP4QEaiBfvePaNJE9uW6oUOK0sL8Fj9
         UK0Vc3bRI6WoW/1+aYFqiqYH9ADEswSqWri13rR5ZNg1UD06E4/4FYdv8zkApTm1sd7i
         S2XQ==
X-Gm-Message-State: AOAM531uPHV78oezZNvZl7AQP2j9X9CHClDqiG4G051sHzw5MrZsnpKz
        Ybh/wWivvv9mV3h2mAfJ9Ac=
X-Google-Smtp-Source: ABdhPJxx3fEGps51NJujSWYQRLTv+DCrhaPmQDX+aXdSCzwtQQXN1ujKB3Z0+2h8i9JFEiuXDe85FA==
X-Received: by 2002:a05:6512:3486:: with SMTP id v6mr46974393lfr.483.1641388806620;
        Wed, 05 Jan 2022 05:20:06 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.38])
        by smtp.gmail.com with ESMTPSA id r11sm2188238ljp.18.2022.01.05.05.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 05:20:06 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com,
        freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Subject: [PATCH RFT] net: asix: add proper error handling of usb read errors
Date:   Wed,  5 Jan 2022 16:19:52 +0300
Message-Id: <20220105131952.15693-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot once again hit uninit value in asix driver. The problem still the
same -- asix_read_cmd() reads less bytes, than was requested by caller.

Since all read requests are performed via asix_read_cmd() let's catch
usb related error there and add __must_check notation to be sure all
callers actually check return value.

So, this patch adds sanity check inside asix_read_cmd(), that simply
checks if bytes read are not less, than was requested and adds missing
error handling of asix_read_cmd() all across the driver code.

Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-and-tested-by: syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/usb/asix.h         |  4 ++--
 drivers/net/usb/asix_common.c  | 19 +++++++++++++------
 drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2a1e31defe71..4334aafab59a 100644
--- a/drivers/net/usb/asix.h
+++ b/drivers/net/usb/asix.h
@@ -192,8 +192,8 @@ extern const struct driver_info ax88172a_info;
 /* ASIX specific flags */
 #define FLAG_EEPROM_MAC		(1UL << 0)  /* init device MAC from eeprom */
 
-int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-		  u16 size, void *data, int in_pm);
+int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
+			       u16 size, void *data, int in_pm);
 
 int asix_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		   u16 size, void *data, int in_pm);
diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 71682970be58..524805285019 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -11,8 +11,8 @@
 
 #define AX_HOST_EN_RETRIES	30
 
-int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-		  u16 size, void *data, int in_pm)
+int __must_check asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
+			       u16 size, void *data, int in_pm)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
@@ -27,9 +27,12 @@ int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 		 value, index, data, size);
 
-	if (unlikely(ret < 0))
+	if (unlikely(ret < size)) {
+		ret = ret < 0 ? ret : -ENODATA;
+
 		netdev_warn(dev->net, "Failed to read reg index 0x%04x: %d\n",
 			    index, ret);
+	}
 
 	return ret;
 }
@@ -79,7 +82,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 				    0, 0, 1, &smsr, in_pm);
 		if (ret == -ENODEV)
 			break;
-		else if (ret < sizeof(smsr))
+		else if (ret < 0)
 			continue;
 		else if (smsr & AX_HOST_EN)
 			break;
@@ -579,8 +582,12 @@ int asix_mdio_read_nopm(struct net_device *netdev, int phy_id, int loc)
 		return ret;
 	}
 
-	asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
-		      (__u16)loc, 2, &res, 1);
+	ret = asix_read_cmd(dev, AX_CMD_READ_MII_REG, phy_id,
+			    (__u16)loc, 2, &res, 1);
+	if (ret < 0) {
+		mutex_unlock(&dev->phy_mutex);
+		return ret;
+	}
 	asix_set_hw_mii(dev, 1);
 	mutex_unlock(&dev->phy_mutex);
 
diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 4514d35ef4c4..6b2fbdf4e0fd 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -755,7 +755,12 @@ static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 	priv->phy_addr = ret;
 	priv->embd_phy = ((priv->phy_addr & 0x1f) == 0x10);
 
-	asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
+	ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG, 0, 0, 1, &chipcode, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read STATMNGSTS_REG: %d\n", ret);
+		return ret;
+	}
+
 	chipcode &= AX_CHIPCODE_MASK;
 
 	ret = (chipcode == AX_AX88772_CHIPCODE) ? ax88772_hw_reset(dev, 0) :
@@ -920,11 +925,21 @@ static int ax88178_reset(struct usbnet *dev)
 	int gpio0 = 0;
 	u32 phyid;
 
-	asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
+	ret = asix_read_cmd(dev, AX_CMD_READ_GPIOS, 0, 0, 1, &status, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read GPIOS: %d\n", ret);
+		return ret;
+	}
+
 	netdev_dbg(dev->net, "GPIO Status: 0x%04x\n", status);
 
 	asix_write_cmd(dev, AX_CMD_WRITE_ENABLE, 0, 0, 0, NULL, 0);
-	asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
+	ret = asix_read_cmd(dev, AX_CMD_READ_EEPROM, 0x0017, 0, 2, &eeprom, 0);
+	if (ret < 0) {
+		netdev_dbg(dev->net, "Failed to read EEPROM: %d\n", ret);
+		return ret;
+	}
+
 	asix_write_cmd(dev, AX_CMD_WRITE_DISABLE, 0, 0, 0, NULL, 0);
 
 	netdev_dbg(dev->net, "EEPROM index 0x17 is 0x%04x\n", eeprom);
-- 
2.34.1

