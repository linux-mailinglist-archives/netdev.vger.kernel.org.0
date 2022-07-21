Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4707557C196
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbiGUA2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUA2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:30 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609965A88B;
        Wed, 20 Jul 2022 17:28:29 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l14-20020a17090a72ce00b001f20ed3c55dso3792014pjk.5;
        Wed, 20 Jul 2022 17:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8H9ysJYrnrWkyl8HVfuoBPlJRCyj5PxyA79wuhjjui8=;
        b=n2R+rVdULpdrk+CQ5xOS2lc2elRYHRgbY7kQe+t/DfTvfaFM2s+/tj7p5CUnb49w2I
         Km/1dRrZAuECCJRYFm8do5inqCqJADaOl9FlehwjAOOCK7/zaEeHtpICHjXhqJpSwk+S
         eMcfmGOQtDZxNroLJM/JTODP6DaOgZkoQ+wles8BJL3aCZBlz/BVrELk9v5qPjqwYPDq
         5qF7LR0wXAr55mk+5qyBRt75Gsvp8IF5dpN2s9IhTGbnFIX58fmHjFY4OISWjbOyPmnU
         MCaNvJRu41v8iJcC4zNUSYm8R6lY0f5fftLICf3A2Yswu7kQkq41rlhKUzqMp+S0QlNq
         ILhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8H9ysJYrnrWkyl8HVfuoBPlJRCyj5PxyA79wuhjjui8=;
        b=qCZKXh8cD2mxCE0KOHqikhPMGiZs9HyO2N5tAowtbjWbKrPovPoByIi7lf/jS2R36W
         yHBsxCjy1orGHRswD3RjPdnBNQTTudpe6SRLFHjtsIN8ho19mCyX4yD0SPspzLq3CTK0
         ws9LiRF1JWYy6uP59BiCan0oeHYvkKFyINMgPI35GXdR6w6Ckno+FRoJZBcUBsEWDAjS
         0AOFMwTiOgVYSOSv1g6e5bySHE1X2ZV1DpRGv7Tk/OxyLkNXOxBvAwvURqZAS/7VlQat
         qovy0CrWUIXX/TLFRer/x506edPkv+Q3oLDKskWdiRxMDMEfhTZcbW24Sy+DXRaoN6hx
         0z2g==
X-Gm-Message-State: AJIora+smNgMH3BAZYG7EMEpqTxWPAJz9IhrjkgkbHpQhoSSPmbQeVdJ
        xKNM3HLgioWNpkZBIKH1yeY=
X-Google-Smtp-Source: AGRyM1vGGlvuYS+BI01TfP8dEcG/bXsRdc1DfPZ9lsSHsbNRA27OTeMzCPVuZlBmBFBZKRb0sinvQw==
X-Received: by 2002:a17:90a:ea04:b0:1f2:242d:e2af with SMTP id w4-20020a17090aea0400b001f2242de2afmr4531929pjy.45.1658363308716;
        Wed, 20 Jul 2022 17:28:28 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:28 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 2/5] net: usb: ax88179_178a: clean up pm calls
Date:   Wed, 20 Jul 2022 17:28:13 -0700
Message-Id: <1658363296-15734-3-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
References: <1658363296-15734-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin Chen <justinpopo6@gmail.com>

Instead of passing in_pm flags all over the place, use the private
struct to handle in_pm mode.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 147 +++++++++++++++++------------------------
 1 file changed, 59 insertions(+), 88 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index b7098688..c641fd4 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -171,6 +171,7 @@ struct ax88179_data {
 	u8  eee_active;
 	u16 rxctl;
 	u16 reserved;
+	u8 in_pm;
 };
 
 struct ax88179_int_data {
@@ -187,15 +188,29 @@ static const struct {
 	{7, 0xcc, 0x4c, 0x18, 8},
 };
 
+static void ax88179_set_pm_mode(struct usbnet *dev, bool pm_mode)
+{
+	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+
+	ax179_data->in_pm = pm_mode;
+}
+
+static int ax88179_in_pm(struct usbnet *dev)
+{
+	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+
+	return ax179_data->in_pm;
+}
+
 static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			      u16 size, void *data, int in_pm)
+			      u16 size, void *data)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (!ax88179_in_pm(dev))
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -211,14 +226,14 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 }
 
 static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			       u16 size, const void *data, int in_pm)
+			       u16 size, const void *data)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (!ax88179_in_pm(dev))
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -251,47 +266,6 @@ static void ax88179_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value,
 	}
 }
 
-static int ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				 u16 index, u16 size, void *data)
-{
-	int ret;
-
-	if (2 == size) {
-		u16 buf;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
-		le16_to_cpus(&buf);
-		*((u16 *)data) = buf;
-	} else if (4 == size) {
-		u32 buf;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
-		le32_to_cpus(&buf);
-		*((u32 *)data) = buf;
-	} else {
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 1);
-	}
-
-	return ret;
-}
-
-static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				  u16 index, u16 size, const void *data)
-{
-	int ret;
-
-	if (2 == size) {
-		u16 buf;
-		buf = *((u16 *)data);
-		cpu_to_le16s(&buf);
-		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, &buf, 1);
-	} else {
-		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, data, 1);
-	}
-
-	return ret;
-}
-
 static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			    u16 size, void *data)
 {
@@ -299,16 +273,16 @@ static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 
 	if (2 == size) {
 		u16 buf = 0;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf);
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf = 0;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf);
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data);
 	}
 
 	return ret;
@@ -324,10 +298,10 @@ static int ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		buf = *((u16 *)data);
 		cpu_to_le16s(&buf);
 		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, &buf, 0);
+					  size, &buf);
 	} else {
 		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, data, 0);
+					  size, data);
 	}
 
 	return ret;
@@ -430,52 +404,46 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 	u16 tmp16;
 	u8 tmp8;
 
+	ax88179_set_pm_mode(dev, true);
+
 	usbnet_suspend(intf, message);
 
 	/* Disable RX path */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			      2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			 2, 2, &tmp16);
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			  2, 2, &tmp16);
 
 	/* Force bulk-in zero length */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			      2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			 2, 2, &tmp16);
 
 	tmp16 |= AX_PHYPWR_RSTCTL_BZ | AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 
 	/* change clock */
 	tmp8 = 0;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
 	/* Configure RX control register => stop operation */
 	tmp16 = AX_RX_CTL_STOP;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+
+	ax88179_set_pm_mode(dev, false);
 
 	return 0;
 }
 
 /* This function is used to enable the autodetach function. */
 /* This function is determined by offset 0x43 of EEPROM */
-static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
+static int ax88179_auto_detach(struct usbnet *dev)
 {
 	u16 tmp16;
 	u8 tmp8;
-	int (*fnr)(struct usbnet *, u8, u16, u16, u16, void *);
-	int (*fnw)(struct usbnet *, u8, u16, u16, u16, const void *);
-
-	if (!in_pm) {
-		fnr = ax88179_read_cmd;
-		fnw = ax88179_write_cmd;
-	} else {
-		fnr = ax88179_read_cmd_nopm;
-		fnw = ax88179_write_cmd_nopm;
-	}
 
-	if (fnr(dev, AX_ACCESS_EEPROM, 0x43, 1, 2, &tmp16) < 0)
+	if (ax88179_read_cmd(dev, AX_ACCESS_EEPROM, 0x43, 1, 2, &tmp16) < 0)
 		return 0;
 
 	if ((tmp16 == 0xFFFF) || (!(tmp16 & 0x0100)))
@@ -483,13 +451,13 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 
 	/* Enable Auto Detach bit */
 	tmp8 = 0;
-	fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	tmp8 |= AX_CLK_SELECT_ULR;
-	fnw(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
-	fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 	tmp16 |= AX_PHYPWR_RSTCTL_AT;
-	fnw(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 
 	return 0;
 }
@@ -500,32 +468,36 @@ static int ax88179_resume(struct usb_interface *intf)
 	u16 tmp16;
 	u8 tmp8;
 
+	ax88179_set_pm_mode(dev, true);
+
 	usbnet_link_change(dev, 0, 0);
 
 	/* Power up ethernet PHY */
 	tmp16 = 0;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 	udelay(1000);
 
 	tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 	msleep(200);
 
 	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev, 1);
+	ax88179_auto_detach(dev);
 
 	/* Enable clock */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
 	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	msleep(100);
 
 	/* Configure RX control register => start operation */
 	tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
 		AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+
+	ax88179_set_pm_mode(dev, false);
 
 	return usbnet_resume(intf);
 }
@@ -601,8 +573,7 @@ ax88179_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom,
 	/* ax88179/178A returns 2 bytes from eeprom on read */
 	for (i = first_word; i <= last_word; i++) {
 		ret = __ax88179_read_cmd(dev, AX_ACCESS_EEPROM, i, 1, 2,
-					 &eeprom_buff[i - first_word],
-					 0);
+					 &eeprom_buff[i - first_word]);
 		if (ret < 0) {
 			kfree(eeprom_buff);
 			return -EIO;
@@ -1071,7 +1042,7 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 		} while (buf & EEP_BUSY);
 
 		__ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				   2, 2, &eeprom[i * 2], 0);
+				   2, 2, &eeprom[i * 2]);
 
 		if ((i == 0) && (eeprom[0] == 0xFF))
 			return -EINVAL;
@@ -1640,7 +1611,7 @@ static int ax88179_reset(struct usbnet *dev)
 	msleep(100);
 
 	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev, 0);
+	ax88179_auto_detach(dev);
 
 	/* Read MAC address from DTB or asix chip */
 	ax88179_get_mac_addr(dev);
-- 
2.7.4

