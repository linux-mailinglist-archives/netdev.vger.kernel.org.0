Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCAA485633
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241692AbiAEPvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:51:22 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:47864
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241661AbiAEPvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:51:19 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 5EB083FCC6;
        Wed,  5 Jan 2022 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1641397877;
        bh=tId8JYRxg2oP+VXE++C2q9o8HqxEgkuCA0qN7l8VohE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=lTc3OV4gjX9KbR41jGNoIM89Qpd099P0EXLs4dTh92f8cPcXpnZnGVOmJaQjOwRNC
         5jod4T8nPfUoXCuxdjSKySm3GsiJdiPrKr7tcwizs+x7J+FzV+9at/QBaOWdrRnxHQ
         eGDP0l4WTpeOuxSlLLhWJllxpRUSbPGhHoyks42MfSPs31Jcv+GkScSou4c6GaDGGC
         nWmcvx6TE0NnoW/Y1uG6rYaBCGeqCXONY14Xs6AINZRwuujOpm8HYTrw9rDZS9N/hZ
         zuA9R8Vmqx9BlcYsF0IiNRSqfLlfhGdCHXz60ShYfRLjBXeT1InGWh4osmvwPlQ+Td
         B6KXQwxIOiqzA==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     aaron.ma@canonical.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
Subject: [PATCH] Revert "net: usb: r8152: Add MAC passthrough support for more Lenovo Docks"
Date:   Wed,  5 Jan 2022 23:51:02 +0800
Message-Id: <20220105155102.8557-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit f77b83b5bbab53d2be339184838b19ed2c62c0a5.

This change breaks multiple usb to ethernet dongles attached on Lenovo
USB hub.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f9877a3e83ac..4a02f33f0643 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9603,9 +9603,12 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (udev->parent &&
-			le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
-		tp->lenovo_macpassthru = 1;
+	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
+			tp->lenovo_macpassthru = 1;
+		}
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.30.2

