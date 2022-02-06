Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5304AB127
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 19:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiBFSF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 13:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiBFSF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 13:05:27 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA5FC06173B;
        Sun,  6 Feb 2022 10:05:26 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id i34so22874859lfv.2;
        Sun, 06 Feb 2022 10:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVLXdAwoia/uG4i6iYCt7vD4rrzfysYRtbhIPKSduwc=;
        b=MRk04SIii12Xd/32wsZ9l0EXld/OflwnHr3juzzS8W268O/OJuXrMIegCs0ebIHPhZ
         SEmmAsnXuGBk70nvnTBuUeN5lBBdqwZ5L77lNOzAsZyd6FnDlQ3LyJyYL1hM7EtTUjah
         jN4eYVyqOnNjdOMFycWNkAGv2HCAA1h5XL00apkEviHrxzBS6o/lSCVy6Uss9KZ+0LVE
         3qAhVl6zlPsHG9THPwK6X74td9TXHMnJh7FRg5Ov6DyHc2HtBe/e/SdHUCDnmveClzUI
         g0luzJ5elU5SfViU1bRQ+1rZ3hvTtsrliyj01f8VqaCKvqm80lHH2gRT+nchjzLhT1OV
         Gg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVLXdAwoia/uG4i6iYCt7vD4rrzfysYRtbhIPKSduwc=;
        b=kaIm+15Gm44Q7Jt1dl0lpVvu7iNWpkzcMnrdt91Jq96w3CsFo7W8tX24YxNqGTrBHP
         isa1Drw4iBjPuLoPb01N9J01MjhDlHr3ZWfyf/i6LprCLH+O976/8zNL+9MesKDTyt0a
         nDy+4yFMVSILgqwDG7qO2XYVcKQw9rDQRM5EP7ly7nexhBlS/u7s3ZIZApSM9yZZIn/T
         LYpbhWrQP3qoa8tUUFWbTeuPpzxi0JCWIPOQrVCJADBednyohRfgFa2ozNvg34IG1kMD
         D1UGPwUDT32vOZCe1QuMwNoAXXVBxXCPNkVi1yi6dGfG6M16BOD1zTX9ekrbaFg5eM+N
         Qh4Q==
X-Gm-Message-State: AOAM530KFJkHU9HzXFsxRYnVp2WqY26+Idi9PCtVOaQlRBuHuNNtTo1j
        NoqE6ZKc354pss1aZEbQNOw=
X-Google-Smtp-Source: ABdhPJyi4XUFhtj4XnNn7IucicTXWdV1tScDiza80PA/Ie2czqv5/uRgpbbsFo4/V12A3bhGOuG+Ig==
X-Received: by 2002:a05:6512:a95:: with SMTP id m21mr5989955lfu.546.1644170724245;
        Sun, 06 Feb 2022 10:05:24 -0800 (PST)
Received: from localhost.localdomain ([94.103.224.201])
        by smtp.gmail.com with ESMTPSA id d13sm1172712lfn.137.2022.02.06.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 10:05:23 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, oneukum@suse.com, robert.foss@collabora.com
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+6ca9f7867b77c2d316ac@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next] net: asix: add proper error handling of usb read errors
Date:   Sun,  6 Feb 2022 21:05:16 +0300
Message-Id: <20220206180516.28439-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <f676e339-5808-2163-2afd-ea254cfb2684@rempel-privat.de>
References: <f676e339-5808-2163-2afd-ea254cfb2684@rempel-privat.de>
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
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
---

Changes since RFT:
	- Added Tested-by: tag

---
 drivers/net/usb/asix.h         |  4 ++--
 drivers/net/usb/asix_common.c  | 19 +++++++++++++------
 drivers/net/usb/asix_devices.c | 21 ++++++++++++++++++---
 3 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/asix.h b/drivers/net/usb/asix.h
index 2a1e31def..4334aafab 100644
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
index 71682970b..524805285 100644
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
index 9b72334aa..6ea44e537 100644
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
@@ -919,11 +924,21 @@ static int ax88178_reset(struct usbnet *dev)
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

