Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5700D45E510
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 03:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357973AbhKZCjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 21:39:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:48184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343602AbhKZChO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 21:37:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1886611C7;
        Fri, 26 Nov 2021 02:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637893965;
        bh=NVYc831lTubR1pDQoit5Z7uxb0b0HMjCDCYurmDIRHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecdgmmTu5zav/G6zdY5WCd+5YF/6Z+f6l0hH9NWF0JUFSZ7k53kE6+6zHEyRfqESv
         UluCky84NMpZ1xLQSO2qdSUvdmNV1yB1rEj/A0W23zDF21MiQKF8MIh3jqAYwoCA8n
         9geqDEPLFrHubmRvb9RG8cw/7nOUvWLOouJ002O6CsEjQ/ItDYXzn68hLrtlb7i+Dg
         jHI6leXsJYMOEvtLU00s0GLU9Urmg4q3bPZyR2yP8nIJf0I5o1o9UdMP9m+OGrpQaK
         WKc6Ttqt0v1x0yH5gC76l24VSjRwWMm2hwa5grvOVpoYo1LeHoFwa0GRkExe8NUtXF
         DgDnkW+kvgJdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aaron Ma <aaron.ma@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, kuba@kernel.org,
        hayeswang@realtek.com, tiwai@suse.de, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 23/39] net: usb: r8152: Add MAC passthrough support for more Lenovo Docks
Date:   Thu, 25 Nov 2021 21:31:40 -0500
Message-Id: <20211126023156.441292-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023156.441292-1-sashal@kernel.org>
References: <20211126023156.441292-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit f77b83b5bbab53d2be339184838b19ed2c62c0a5 ]

Like ThinkaPad Thunderbolt 4 Dock, more Lenovo docks start to use the original
Realtek USB ethernet chip ID 0bda:8153.

Lenovo Docks always use their own IDs for usb hub, even for older Docks.
If parent hub is from Lenovo, then r8152 should try MAC passthrough.
Verified on Lenovo TBT3 dock too.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f329e39100a7d..d3da350777a4d 100644
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
2.33.0

