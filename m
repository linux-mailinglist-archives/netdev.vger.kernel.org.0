Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17133BCFC2
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbhGFLbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235349AbhGFL34 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1591661CD0;
        Tue,  6 Jul 2021 11:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570457;
        bh=QbvqrwZ8Q+2vTBa77tk8Y5TR2OyEQmbz1WcUaRkJ+aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQsH9JbWGxN0vrFsd7SN9sTAqNV4kyZIfyQtxMQYXjuSUv2nx7HW+cKHyZpKO0Xrf
         xzbFOBPEu1U4BhHGPdmoOfEZ9RYTYAvV6jNH0K2jTj0XObyAD0j45zDuipe9oWmuKc
         MDCnFHheT12TX1unIAn7CbJepf1Gd/FYIOh0wAHOJ9wvMv8gmhB7zPPDhLbTXSYbb8
         U9E0SOGV87SXuY03TMqKswAHy9Yh1zSYaKN1wAZqYNRxdOb5QkI551v52mWE9NCkPt
         c54fpViL0VhLw2kdLV86IEaL16XkZRHZFxtHDldBwhnJppqma7r0WdbEA6Gbv2TzHj
         RfaIWQLt9pjZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pascal Terjan <pterjan@google.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 112/160] rtl8xxxu: Fix device info for RTL8192EU devices
Date:   Tue,  6 Jul 2021 07:17:38 -0400
Message-Id: <20210706111827.2060499-112-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pascal Terjan <pterjan@google.com>

[ Upstream commit c240b044edefa3c3af4014a4030e017dd95b59a1 ]

Based on 2001:3319 and 2357:0109 which I used to test the fix and
0bda:818b and 2357:0108 for which I found efuse dumps online.

== 2357:0109 ==
=== Before ===
Vendor: Realtek
Product: \x03802.11n NI
Serial:
=== After ===
Vendor: Realtek
Product: 802.11n NIC
Serial not available.

== 2001:3319 ==
=== Before ===
Vendor: Realtek
Product: Wireless N
Serial: no USB Adap
=== After ===
Vendor: Realtek
Product: Wireless N Nano USB Adapter
Serial not available.

Signed-off-by: Pascal Terjan <pterjan@google.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210424172959.1559890-1-pterjan@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  | 11 +---
 .../realtek/rtl8xxxu/rtl8xxxu_8192e.c         | 59 +++++++++++++++++--
 2 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index d6d1be4169e5..acb6b0cd3667 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -853,15 +853,10 @@ struct rtl8192eu_efuse {
 	u8 usb_optional_function;
 	u8 res9[2];
 	u8 mac_addr[ETH_ALEN];		/* 0xd7 */
-	u8 res10[2];
-	u8 vendor_name[7];
-	u8 res11[2];
-	u8 device_name[0x0b];		/* 0xe8 */
-	u8 res12[2];
-	u8 serial[0x0b];		/* 0xf5 */
-	u8 res13[0x30];
+	u8 device_info[80];
+	u8 res11[3];
 	u8 unknown[0x0d];		/* 0x130 */
-	u8 res14[0xc3];
+	u8 res12[0xc3];
 };
 
 struct rtl8xxxu_reg8val {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index cfe2dfdae928..b06508d0cdf8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -554,9 +554,43 @@ rtl8192e_set_tx_power(struct rtl8xxxu_priv *priv, int channel, bool ht40)
 	}
 }
 
+static void rtl8192eu_log_next_device_info(struct rtl8xxxu_priv *priv,
+					   char *record_name,
+					   char *device_info,
+					   unsigned int *record_offset)
+{
+	char *record = device_info + *record_offset;
+
+	/* A record is [ total length | 0x03 | value ] */
+	unsigned char l = record[0];
+
+	/*
+	 * The whole device info section seems to be 80 characters, make sure
+	 * we don't read further.
+	 */
+	if (*record_offset + l > 80) {
+		dev_warn(&priv->udev->dev,
+			 "invalid record length %d while parsing \"%s\" at offset %u.\n",
+			 l, record_name, *record_offset);
+		return;
+	}
+
+	if (l >= 2) {
+		char value[80];
+
+		memcpy(value, &record[2], l - 2);
+		value[l - 2] = '\0';
+		dev_info(&priv->udev->dev, "%s: %s\n", record_name, value);
+		*record_offset = *record_offset + l;
+	} else {
+		dev_info(&priv->udev->dev, "%s not available.\n", record_name);
+	}
+}
+
 static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 {
 	struct rtl8192eu_efuse *efuse = &priv->efuse_wifi.efuse8192eu;
+	unsigned int record_offset;
 	int i;
 
 	if (efuse->rtl_id != cpu_to_le16(0x8129))
@@ -604,12 +638,25 @@ static int rtl8192eu_parse_efuse(struct rtl8xxxu_priv *priv)
 	priv->has_xtalk = 1;
 	priv->xtalk = priv->efuse_wifi.efuse8192eu.xtal_k & 0x3f;
 
-	dev_info(&priv->udev->dev, "Vendor: %.7s\n", efuse->vendor_name);
-	dev_info(&priv->udev->dev, "Product: %.11s\n", efuse->device_name);
-	if (memchr_inv(efuse->serial, 0xff, 11))
-		dev_info(&priv->udev->dev, "Serial: %.11s\n", efuse->serial);
-	else
-		dev_info(&priv->udev->dev, "Serial not available.\n");
+	/*
+	 * device_info section seems to be laid out as records
+	 * [ total length | 0x03 | value ] so:
+	 * - vendor length + 2
+	 * - 0x03
+	 * - vendor string (not null terminated)
+	 * - product length + 2
+	 * - 0x03
+	 * - product string (not null terminated)
+	 * Then there is one or 2 0x00 on all the 4 devices I own or found
+	 * dumped online.
+	 * As previous version of the code handled an optional serial
+	 * string, I now assume there may be a third record if the
+	 * length is not 0.
+	 */
+	record_offset = 0;
+	rtl8192eu_log_next_device_info(priv, "Vendor", efuse->device_info, &record_offset);
+	rtl8192eu_log_next_device_info(priv, "Product", efuse->device_info, &record_offset);
+	rtl8192eu_log_next_device_info(priv, "Serial", efuse->device_info, &record_offset);
 
 	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_EFUSE) {
 		unsigned char *raw = priv->efuse_wifi.raw;
-- 
2.30.2

