Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309DB57C19F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 02:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiGUA2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiGUA2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 20:28:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3286249D;
        Wed, 20 Jul 2022 17:28:36 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d7so306510plr.9;
        Wed, 20 Jul 2022 17:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qHyW/zQGeHxiV8yKl6wtD5EU59PXEqMR+w3eh+TCFyE=;
        b=SsuaZEcuN5do3+2MU1oonViR5MxpkAeiLETraeHDU+jUrOSJAu6J9p3xgNiIvqmDT+
         ei/82Wrx/LydCV6FW9oOzc0Sq+Grkd2f0UUTm8kOTfKjPaCeaA8T0Budlm8Ox0c1AEdD
         SWCU6W5hUo48z1rnXDDrar+YJdt8Mpr+ZDst6Lhym/YPpZB1lflP+KZeoNKEwtnHC8zq
         USJsHDigua9pVKcCD03+0W1/Q84tK6B9zdcog+qRIXvJK/Viag4Dl4SyiNS1N/LhPEBz
         pXz9RGfTgr9K7puvvGOjPpgmIChyqy3s4cbt7cdPmlmjrqFxQwf5IAmlQhi5JuwWLOQK
         cfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qHyW/zQGeHxiV8yKl6wtD5EU59PXEqMR+w3eh+TCFyE=;
        b=Fs6lvrjGwahaCII5Xz2yel+ZKQ1ZXc68sfsjG+icOBUc6rruYBjtbEwz7uxSuW4HhB
         r+eyAqJzKhyV6Tr6ilY5XpNXpGqmKwPEvoz6T/hInNva8Gjt6yCk97HRAuajmemc2bne
         9si9qRQcaTFqDFe0m9VJTCb4yV15Dwxz4l6Yl85HDqb2KVzyssHMYkR2ol3UNmFJpq7E
         8tf0yJNMAhPx/+0zUpGJSCysRVyI5LdpcHN06fSJBi8B8ZsuK4X+V5FXL2r6y4a3OBhG
         jbHRTTh1oPi5D1fYsblc7qTfp5T4odS9T8uJiK0VbpP1MH/iTEmLokPpQkksxGNIpk5S
         8t3A==
X-Gm-Message-State: AJIora+NG7WV/PBV80F+yCFmHxkpvjmJdGOzciuohx7VpeSCtreDtuQ2
        eQE72qleGMgfYwea6cf1nEI=
X-Google-Smtp-Source: AGRyM1tQVpAMPxmkuQ++lKXbIMF1xWaC4zknVeGb01qhRv1EyhtY+pCvWVk+DkpuQji1WGd3qXg5FA==
X-Received: by 2002:a17:902:c945:b0:16c:49c9:7932 with SMTP id i5-20020a170902c94500b0016c49c97932mr41447676pla.80.1658363315963;
        Wed, 20 Jul 2022 17:28:35 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db0500b0016bc4a6ce28sm163226plx.98.2022.07.20.17.28.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jul 2022 17:28:35 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, joalonsof@gmail.com, jesionowskigreg@gmail.com,
        jackychou@asix.com.tw, jannh@google.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     f.fainelli@gmail.com, justin.chen@broadcom.com,
        Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH v2 5/5] net: usb: ax88179_178a: wol optimizations
Date:   Wed, 20 Jul 2022 17:28:16 -0700
Message-Id: <1658363296-15734-6-git-send-email-justinpopo6@gmail.com>
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

- Check if wol is supported on reset instead of everytime get_wol
is called.
- Save wolopts in private data instead of relying on the HW to save it.
- Defer enabling WoL until suspend instead of enabling it everytime
set_wol is called.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 drivers/net/usb/ax88179_178a.c | 52 +++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index d0cd986..3b0e8f9 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -171,6 +171,8 @@ struct ax88179_data {
 	u8  eee_active;
 	u16 rxctl;
 	u8 in_pm;
+	u32 wol_supported;
+	u32 wolopts;
 };
 
 struct ax88179_int_data {
@@ -400,6 +402,7 @@ ax88179_phy_write_mmd_indirect(struct usbnet *dev, u16 prtad, u16 devad,
 static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
+	struct ax88179_data *priv = dev->driver_priv;
 	u16 tmp16;
 	u8 tmp8;
 
@@ -407,6 +410,19 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 
 	usbnet_suspend(intf, message);
 
+	/* Enable WoL */
+	if (priv->wolopts) {
+		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+				 1, 1, &tmp8);
+		if (priv->wolopts & WAKE_PHY)
+			tmp8 |= AX_MONITOR_MODE_RWLC;
+		if (priv->wolopts & WAKE_MAGIC)
+			tmp8 |= AX_MONITOR_MODE_RWMP;
+
+		ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+				  1, 1, &tmp8);
+	}
+
 	/* Disable RX path */
 	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			 2, 2, &tmp16);
@@ -480,40 +496,22 @@ static void
 ax88179_get_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	u8 opt;
-
-	if (ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
-			     1, 1, &opt) < 0) {
-		wolinfo->supported = 0;
-		wolinfo->wolopts = 0;
-		return;
-	}
+	struct ax88179_data *priv = dev->driver_priv;
 
-	wolinfo->supported = WAKE_PHY | WAKE_MAGIC;
-	wolinfo->wolopts = 0;
-	if (opt & AX_MONITOR_MODE_RWLC)
-		wolinfo->wolopts |= WAKE_PHY;
-	if (opt & AX_MONITOR_MODE_RWMP)
-		wolinfo->wolopts |= WAKE_MAGIC;
+	wolinfo->supported = priv->wol_supported;
+	wolinfo->wolopts = priv->wolopts;
 }
 
 static int
 ax88179_set_wol(struct net_device *net, struct ethtool_wolinfo *wolinfo)
 {
 	struct usbnet *dev = netdev_priv(net);
-	u8 opt = 0;
+	struct ax88179_data *priv = dev->driver_priv;
 
-	if (wolinfo->wolopts & ~(WAKE_PHY | WAKE_MAGIC))
+	if (wolinfo->wolopts & ~(priv->wol_supported))
 		return -EINVAL;
 
-	if (wolinfo->wolopts & WAKE_PHY)
-		opt |= AX_MONITOR_MODE_RWLC;
-	if (wolinfo->wolopts & WAKE_MAGIC)
-		opt |= AX_MONITOR_MODE_RWMP;
-
-	if (ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
-			      1, 1, &opt) < 0)
-		return -EINVAL;
+	priv->wolopts = wolinfo->wolopts;
 
 	return 0;
 }
@@ -1636,6 +1634,12 @@ static int ax88179_reset(struct usbnet *dev)
 	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
 			  2, 2, tmp16);
 
+	/* Check if WoL is supported */
+	ax179_data->wol_supported = 0;
+	if (ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MONITOR_MOD,
+			     1, 1, &tmp) > 0)
+		ax179_data->wol_supported = WAKE_MAGIC | WAKE_PHY;
+
 	ax88179_led_setting(dev);
 
 	ax179_data->eee_enabled = 0;
-- 
2.7.4

