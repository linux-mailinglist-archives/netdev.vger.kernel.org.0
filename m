Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC8C434DE28
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhC3CSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhC3CSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:18:00 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3D6C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:59 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id v70so14525882qkb.8
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3M1YTP41PlXxTITYsE3syRY8KTDeYRoNyWTUH2CNJ8g=;
        b=SI8IPfpc+trSuuLH0HwHwpnxk00kelMK1CatSlBP2Jx7PhU0SCXGX5fYZsOV9kYmt7
         cvWcNHGLX2AhVBYO2BQX9LKEXVm06tYMZtbZzqGqUOCKwnuilUz5ibWUMs+7EcqZ5tZt
         2NaRnkDmejcbYD3n/4/HgZt4Mu6x2oW5+eIe8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3M1YTP41PlXxTITYsE3syRY8KTDeYRoNyWTUH2CNJ8g=;
        b=fpeyS3/dwott+YoK3kj84sdfT22iY5wyKppnxGT2twGdpRViITK/8PhNlt9p2DdI0f
         3ucCacUaRqkoMB25Btpewm+QwyWhzfsAhEx9d8giZxKNpgO/Y8I0GFVDty7bnZ2hVF7X
         +KICyYLL7ud8wx3DgZUsHGn17ggAGeO6F3/SmyWsswXq/cBqfn0cmQ+CiXmMt4wG9//n
         TeT2IU+N0Ymku+Aulunp/5ZYghhMm5Y0to2PLBzbWJ3VgecTZHIEdmXLvmHjyaVJtdr1
         6UERTIWwlVxUodlfE7JnxCQgrmxlUXQEx7SqeQdgRaxPxJeqeUxFAXXTpaEG+W8ExitZ
         R4mw==
X-Gm-Message-State: AOAM533SHNjsolrC7NSudjuNeIvFNxcfGGSHnaqrAM+OXnn/s6xuQ66y
        hGMO81hlE7ZoihXF5JjRJqfYmme/VXq8RA==
X-Google-Smtp-Source: ABdhPJyE29DX6J4YPT1wZp2+tnycZ6J7e1Lm9MsiDdgvl9QVdeNTSKQQeAL6xc/upCTWCTaDeQk3Yg==
X-Received: by 2002:a37:8743:: with SMTP id j64mr26950647qkd.299.1617070679140;
        Mon, 29 Mar 2021 19:17:59 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id j30sm12433067qtv.90.2021.03.29.19.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 19:17:58 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <GrantGrundlergrundler@chromium.org>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv4 4/4] net: cdc_ether: record speed in status method
Date:   Mon, 29 Mar 2021 19:16:51 -0700
Message-Id: <20210330021651.30906-5-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210330021651.30906-1-grundler@chromium.org>
References: <20210330021651.30906-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grant Grundler <Grant Grundler grundler@chromium.org>

Until very recently, the usbnet framework only had support functions
for devices which reported the link speed by explicitly querying the
PHY over a MDIO interface. However, the cdc_ether devices send
notifications when the link state or link speeds change and do not
expose the PHY (or modem) directly.

Support funtions (e.g. usbnet_get_link_ksettings_internal()) to directly
query state recorded by the cdc_ether driver were added in a previous patch.

Instead of cdc_ether spewing the link speed into the dmesg buffer,
record the link speed encoded in these notifications and tell the
usbnet framework to use the new functions to get link speed/state.

User space can now get the most recent link speed/state using ethtool.

v4: added to series since cdc_ether uses same notifications
    as cdc_ncm driver.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/cdc_ether.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a9b551028659..7eb0109e9baa 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -92,6 +92,18 @@ void usbnet_cdc_update_filter(struct usbnet *dev)
 }
 EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);
 
+/* We need to override usbnet_*_link_ksettings in bind() */
+static const struct ethtool_ops cdc_ether_ethtool_ops = {
+	.get_link		= usbnet_get_link,
+	.nway_reset		= usbnet_nway_reset,
+	.get_drvinfo		= usbnet_get_drvinfo,
+	.get_msglevel		= usbnet_get_msglevel,
+	.set_msglevel		= usbnet_set_msglevel,
+	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_link_ksettings	= usbnet_get_link_ksettings_internal,
+	.set_link_ksettings	= NULL,
+};
+
 /* probes control interface, claims data interface, collects the bulk
  * endpoints, activates data interface (if needed), maybe sets MTU.
  * all pure cdc, except for certain firmware workarounds, and knowing
@@ -310,6 +322,9 @@ int usbnet_generic_cdc_bind(struct usbnet *dev, struct usb_interface *intf)
 		return -ENODEV;
 	}
 
+	/* override ethtool_ops */
+	dev->net->ethtool_ops = &cdc_ether_ethtool_ops;
+
 	return 0;
 
 bad_desc:
@@ -379,12 +394,10 @@ EXPORT_SYMBOL_GPL(usbnet_cdc_unbind);
  * (by Brad Hards) talked with, with more functionality.
  */
 
-static void dumpspeed(struct usbnet *dev, __le32 *speeds)
+static void speed_change(struct usbnet *dev, __le32 *speeds)
 {
-	netif_info(dev, timer, dev->net,
-		   "link speeds: %u kbps up, %u kbps down\n",
-		   __le32_to_cpu(speeds[0]) / 1000,
-		   __le32_to_cpu(speeds[1]) / 1000);
+	dev->tx_speed = __le32_to_cpu(speeds[0]);
+	dev->rx_speed = __le32_to_cpu(speeds[1]);
 }
 
 void usbnet_cdc_status(struct usbnet *dev, struct urb *urb)
@@ -396,7 +409,7 @@ void usbnet_cdc_status(struct usbnet *dev, struct urb *urb)
 
 	/* SPEED_CHANGE can get split into two 8-byte packets */
 	if (test_and_clear_bit(EVENT_STS_SPLIT, &dev->flags)) {
-		dumpspeed(dev, (__le32 *) urb->transfer_buffer);
+		speed_change(dev, (__le32 *) urb->transfer_buffer);
 		return;
 	}
 
@@ -413,7 +426,7 @@ void usbnet_cdc_status(struct usbnet *dev, struct urb *urb)
 		if (urb->actual_length != (sizeof(*event) + 8))
 			set_bit(EVENT_STS_SPLIT, &dev->flags);
 		else
-			dumpspeed(dev, (__le32 *) &event[1]);
+			speed_change(dev, (__le32 *) &event[1]);
 		break;
 	/* USB_CDC_NOTIFY_RESPONSE_AVAILABLE can happen too (e.g. RNDIS),
 	 * but there are no standard formats for the response data.
-- 
2.30.1

