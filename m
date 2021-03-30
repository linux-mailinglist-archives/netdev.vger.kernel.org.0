Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34BC34DE25
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhC3CSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhC3CR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:17:58 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81244C061764
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:58 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id l6so2681486qtq.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hfYowgsr4uNI8/wsCDuMmBZBG9pfXasTMUWU2D2WnMU=;
        b=Fpok5B3efPngrcb9OB7UF0W2xEmhgvC1P3AEJN1pNP1LqctR8Hm4HB4H6pUn77LQtk
         YhSnGJWFsOq+/3NHja875Fd5kxS8iYNdYzhW8j3XyBxDuwIqG0eVuoKs4WGNcAXWdvih
         2LCiSuQVAp2jUpYuak19luHf3um9jnLXEGmsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfYowgsr4uNI8/wsCDuMmBZBG9pfXasTMUWU2D2WnMU=;
        b=ENNCIqbsgWGET9HDoGngdbMaqS7scySh5lNKLWG1KJ12hBDIovuzrCUeLpTp3n32ZD
         ZQvPSGyL5EHLKEemHN1ciwRFYH6OjN9ciknBHADAPl2zLMl38eTsE7ZyDyIMcIyBLWat
         C52jrfIY34TdxvdHp/PEUjxAUX5TRtzcu9+jn4lH3nVKpzgOaHnte+7L34aIJ11WbQLa
         zcK4JUBT53kf8t2FquK8Eqsmg7QHTxuvmGc1ucwyFVGAc+oyrPfCjHNyVzsZRaCbi+zG
         ZGNN+W/8wzAHUper0m6gkM3ArXGt2hMRNJvH73fDz/GE+vWv4hbFonGxmO8SCaPU6pZy
         +w7g==
X-Gm-Message-State: AOAM531wIJI2JQkmd1YWKF858ARkZwTBixZrCjRklHGAlncFD4nvkpZ4
        voM57RoFbXxqtQVhzf6GCA/hpA==
X-Google-Smtp-Source: ABdhPJyQxenxvd0BMvAs3kNjM9RRmdwlDKs2dpfBBBxKxZitdCS+cmSPv4O+ezdi+SA+nt1+q2qPow==
X-Received: by 2002:aed:33a4:: with SMTP id v33mr25218790qtd.324.1617070677761;
        Mon, 29 Mar 2021 19:17:57 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id j30sm12433067qtv.90.2021.03.29.19.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 19:17:57 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv4 3/4] net: cdc_ncm: record speed in status method
Date:   Mon, 29 Mar 2021 19:16:50 -0700
Message-Id: <20210330021651.30906-4-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210330021651.30906-1-grundler@chromium.org>
References: <20210330021651.30906-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

Until very recently, the usbnet framework only had support functions
for devices which reported the link speed by explicitly querying the
PHY over a MDIO interface. However, the cdc_ncm devices send
notifications when the link state or link speeds change and do not
expose the PHY (or modem) directly.

Support funtions (e.g. usbnet_get_link_ksettings_internal()) to directly
query state recorded by the cdc_ncm driver were added in a previous patch.

So instead of cdc_ncm spewing the link speed into the dmesg buffer,
record the link speed encoded in these notifications and tell the
usbnet framework to use the new functions to get link speed/state.
Link speed/state is now available via ethtool.

This is especially useful given all current RTL8156 devices emit
a connection/speed status notification every 32ms and this would
fill the dmesg buffer. This implementation replaces the one
recently submitted in de658a195ee23ca6aaffe197d1d2ea040beea0a2 :
   "net: usb: cdc_ncm: don't spew notifications"

v2: rebased on upstream
v3: changed variable names
v4: rewrote commit message

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/cdc_ncm.c | 55 ++++++++++++---------------------------
 1 file changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 2644234d4c4d..6f330c7dcad2 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -133,17 +133,17 @@ static void cdc_ncm_get_strings(struct net_device __always_unused *netdev, u32 s
 static void cdc_ncm_update_rxtx_max(struct usbnet *dev, u32 new_rx, u32 new_tx);
 
 static const struct ethtool_ops cdc_ncm_ethtool_ops = {
-	.get_link          = usbnet_get_link,
-	.nway_reset        = usbnet_nway_reset,
-	.get_drvinfo       = usbnet_get_drvinfo,
-	.get_msglevel      = usbnet_get_msglevel,
-	.set_msglevel      = usbnet_set_msglevel,
-	.get_ts_info       = ethtool_op_get_ts_info,
-	.get_sset_count    = cdc_ncm_get_sset_count,
-	.get_strings       = cdc_ncm_get_strings,
-	.get_ethtool_stats = cdc_ncm_get_ethtool_stats,
-	.get_link_ksettings      = usbnet_get_link_ksettings_mii,
-	.set_link_ksettings      = usbnet_set_link_ksettings_mii,
+	.get_link		= usbnet_get_link,
+	.nway_reset		= usbnet_nway_reset,
+	.get_drvinfo		= usbnet_get_drvinfo,
+	.get_msglevel		= usbnet_get_msglevel,
+	.set_msglevel		= usbnet_set_msglevel,
+	.get_ts_info		= ethtool_op_get_ts_info,
+	.get_sset_count		= cdc_ncm_get_sset_count,
+	.get_strings		= cdc_ncm_get_strings,
+	.get_ethtool_stats	= cdc_ncm_get_ethtool_stats,
+	.get_link_ksettings	= usbnet_get_link_ksettings_internal,
+	.set_link_ksettings	= NULL,
 };
 
 static u32 cdc_ncm_check_rx_max(struct usbnet *dev, u32 new_rx)
@@ -1826,33 +1826,9 @@ static void
 cdc_ncm_speed_change(struct usbnet *dev,
 		     struct usb_cdc_speed_change *data)
 {
-	uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
-	uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
-
-	/* if the speed hasn't changed, don't report it.
-	 * RTL8156 shipped before 2021 sends notification about every 32ms.
-	 */
-	if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
-		return;
-
-	dev->rx_speed = rx_speed;
-	dev->tx_speed = tx_speed;
-
-	/*
-	 * Currently the USB-NET API does not support reporting the actual
-	 * device speed. Do print it instead.
-	 */
-	if ((tx_speed > 1000000) && (rx_speed > 1000000)) {
-		netif_info(dev, link, dev->net,
-			   "%u mbit/s downlink %u mbit/s uplink\n",
-			   (unsigned int)(rx_speed / 1000000U),
-			   (unsigned int)(tx_speed / 1000000U));
-	} else {
-		netif_info(dev, link, dev->net,
-			   "%u kbit/s downlink %u kbit/s uplink\n",
-			   (unsigned int)(rx_speed / 1000U),
-			   (unsigned int)(tx_speed / 1000U));
-	}
+	/* RTL8156 shipped before 2021 sends notification about every 32ms. */
+	dev->rx_speed = le32_to_cpu(data->DLBitRRate);
+	dev->tx_speed = le32_to_cpu(data->ULBitRate);
 }
 
 static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
@@ -1878,6 +1854,9 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
+		/* RTL8156 shipped before 2021 sends notification about
+		 * every 32ms. Don't forward notification if state is same.
+		 */
 		if (netif_carrier_ok(dev->net) != !!event->wValue)
 			usbnet_link_change(dev, !!event->wValue, 0);
 		break;
-- 
2.30.1

