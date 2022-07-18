Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2264A578E92
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 01:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbiGRX7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 19:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbiGRX6o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 19:58:44 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDFF33E2B;
        Mon, 18 Jul 2022 16:58:37 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u7-20020a17090a3fc700b001f1efc76be2so977889pjm.1;
        Mon, 18 Jul 2022 16:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kEb4hoOhi8CD/XwbMaUD4a9U4Omjx9rjALTJdXy2eYk=;
        b=T5W7pqEHmAyucMxobeaee1znTp86VUbOMIWRgD3+x5jIjgppq/RlguxsrqF5uxSRYT
         VpPjM5hBxcY4wY0D/EeghBLfW1K9svmx/jZAyqtD+AmLPn2Y5TwgdltU+lQ9v1Zio+BL
         xgTIj7SxZcub+VXqtLHFWGU2hXe0TX+5KCVbi0gqNng4CY6prFj83aWEzO+gGTk365No
         tiWYAMftoA0MPP9bQqemXQKBl2T9rXcTDoyPbFWc9+e+b2rNJe27iz19BXnBWuZWIwtj
         jxR52oXRL9e0Fb57yvPOKvDnunU0yS2UeXb/VsR6gX/tOUDqYgJjrn7cEDN9jELjuSyP
         ARFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kEb4hoOhi8CD/XwbMaUD4a9U4Omjx9rjALTJdXy2eYk=;
        b=wMD3pDR8+hPcACC5IfpMSn0sWBmklSKyYnFQSkl5M0p7K9hJnrbWXci5Qwhz4sWIa7
         X5rHfTngXKJOLS3bMDMKo4Awvztr4wNlaAEcHf9AlzlbWikQPy71yHIgK4QwVXs1EF+o
         IAAlV2VoLn3kAC6uh4e6nlFvi/wpZe6429HDBqM6fx14vgnCO77ra7Xiar/M6Gk2I74y
         eMjO/RQlFV2YE4oTFAhTIyDab2wmxtXJ9+NSQfGhcqv3pDhjhQa8j1aLYiQ69AgMtOY8
         p6rwoptrc3zEO7oMArH7AO4hq5leazXFD2hDEoii9HoSSK1UQ5jA8Ui4/NZWHyDvBgCh
         cUBA==
X-Gm-Message-State: AJIora/PGyzhyoglRULCuwRFehYDGE661WPd7Fzy5c7v/HSD40zMk759
        gg+nq5kXnVISOs50d2+ukNqiKQhIaUk=
X-Google-Smtp-Source: AGRyM1t21sRhvd9eziBz44wABhsJy/t2Ze2/Aos/o9F+2g3bhjFZ+hN2v2iPqyTPzN/7Hs4me5/UTw==
X-Received: by 2002:a17:902:d54b:b0:16b:f246:e32e with SMTP id z11-20020a170902d54b00b0016bf246e32emr30177743plf.4.1658188716191;
        Mon, 18 Jul 2022 16:58:36 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j20-20020a170902759400b00161ccdc172dsm10027067pll.300.2022.07.18.16.58.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Jul 2022 16:58:35 -0700 (PDT)
From:   justinpopo6@gmail.com
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, jannh@google.com, jackychou@asix.com.tw,
        jesionowskigreg@gmail.com, joalonsof@gmail.com,
        justinpopo6@gmail.com, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com
Cc:     justin.chen@broadcom.com
Subject: [PATCH 5/5] net: usb: ax88179_178a: wol optimizations
Date:   Mon, 18 Jul 2022 16:58:09 -0700
Message-Id: <1658188689-30846-6-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
References: <1658188689-30846-1-git-send-email-justinpopo6@gmail.com>
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
index cb7b89f..757c1d9b 100644
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
@@ -1643,6 +1641,12 @@ static int ax88179_reset(struct usbnet *dev)
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

