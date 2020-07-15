Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B41221463
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgGOSl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgGOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:25 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280C8C08C5DD;
        Wed, 15 Jul 2020 11:41:24 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfJ8a016708
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838480; bh=rWusxHE8CMEShjnYmSriODmxyn+mcOq5n2CIK0RIsLw=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=TOgiaFOex+PWeMHlFM21gpO+g2DVMMcGmhEVDEStsKNyvTnyQdcOYGYgmlw2oaTo5
         1zZhs7VQfXDFsFZjUIuloj4bjeXHjpFLDS9cZT/2hWd4qjl+e+pseRQQcaHFMtibbF
         SKl9koeSWGXfti7yAJIAE7VP5ViZngSAi78DxuWQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLH-000SSZ-Cr; Wed, 15 Jul 2020 20:41:19 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 3/5] net: usbnet: export usbnet_set_rx_mode()
Date:   Wed, 15 Jul 2020 20:40:58 +0200
Message-Id: <20200715184100.109349-4-bjorn@mork.no>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715184100.109349-1-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function can be reused by other usbnet minidrivers.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/usbnet.c   | 3 ++-
 include/linux/usb/usbnet.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 5ec97def3513..e45935a5856a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1108,12 +1108,13 @@ static void __handle_link_change(struct usbnet *dev)
 	clear_bit(EVENT_LINK_CHANGE, &dev->flags);
 }
 
-static void usbnet_set_rx_mode(struct net_device *net)
+void usbnet_set_rx_mode(struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
 
 	usbnet_defer_kevent(dev, EVENT_SET_RX_MODE);
 }
+EXPORT_SYMBOL_GPL(usbnet_set_rx_mode);
 
 static void __handle_set_rx_mode(struct usbnet *dev)
 {
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 3a856963a363..2e4f7721fc4e 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -274,6 +274,7 @@ extern int usbnet_set_link_ksettings(struct net_device *net,
 extern u32 usbnet_get_link(struct net_device *net);
 extern u32 usbnet_get_msglevel(struct net_device *);
 extern void usbnet_set_msglevel(struct net_device *, u32);
+extern void usbnet_set_rx_mode(struct net_device *net);
 extern void usbnet_get_drvinfo(struct net_device *, struct ethtool_drvinfo *);
 extern int usbnet_nway_reset(struct net_device *net);
 
-- 
2.27.0

