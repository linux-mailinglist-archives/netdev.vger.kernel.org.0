Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C6E4533FC
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhKPOXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:23:08 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:43614
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237209AbhKPOW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 09:22:57 -0500
Received: from localhost.localdomain (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 008B840E55;
        Tue, 16 Nov 2021 14:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637072397;
        bh=76lmTcetxuj5kin5ezotvVXKr2ca+rjAtfZHxybS+GA=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=qH08VZPMRv9YrCIjOScQ4VZ9JKiNdb11yGAMSFF5vZD9nbXia2hpoYkxUVbPfw7TR
         ZroMBl730Uxgu9gV/nkR/+oOZDqH7wOFxb6SPEspWSPQvx+shKMTKvPtz2DVlqBvBV
         u4JzEzv7qnZHxw9JOPGlLx/DrtBqS3n99ja4sV5Dsx6CXriMiQkDfEx3Fx2qo3Kqio
         lzuUNhxWv8qFk4Q/EdrqBnRAL+Lm+4fiNpssKTC3LSHH1J2YxPrZMToDsa90AyQnjh
         cKbOslXCcghoLe/bcOs12gpZiJBtQCoMPk8rB/Yh+GbsMkQ0DBqzCJGYafwKt7u7vs
         wm68pL2ebKUfw==
From:   Aaron Ma <aaron.ma@canonical.com>
To:     davem@davemloft.net, kuba@kernel.org, hayeswang@realtek.com,
        tiwai@suse.de, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, aaron.ma@canonical.com
Subject: [PATCH] net: usb: r8152: Add MAC passthrough support for more Lenovo Docks
Date:   Tue, 16 Nov 2021 22:19:17 +0800
Message-Id: <20211116141917.31661-1-aaron.ma@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the original
Realtek USB ethernet chip ID 0bda:8153.

Lenovo Docks always use their own IDs for usb hub, even for older Docks.
If parent hub is from Lenovo, then r8152 should try MAC passthrough.
Verified on Lenovo TBT3 dock too.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 drivers/net/usb/r8152.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4a02f33f0643..f9877a3e83ac 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9603,12 +9603,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
 	}
 
-	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
-		switch (le16_to_cpu(udev->descriptor.idProduct)) {
-		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
-		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
-			tp->lenovo_macpassthru = 1;
-		}
+	if (udev->parent &&
+			le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		tp->lenovo_macpassthru = 1;
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.25.1

