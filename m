Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42D6912B8F5
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfL0RlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:41:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbfL0RlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8470E21775;
        Fri, 27 Dec 2019 17:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468466;
        bh=eSBIlZaB+1Zf9Pp3QrfkfLpJAZHv8lJk20E9gHCjWwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2A+IpCXKvBUrQknVgf9BMGu5246cGCoERKEMHItp7WaD+zlRjyEskmvqx16aG/NTI
         CzGFxhaIAMUn3NWhSqRZTs0/+pAACqZHuFqkCBbcH6TrW3Zjt+YJjeUkIrz5U8zQp8
         Vs/JzWsIoppS+n0kIJGBcc6n8VUXlcJPUDZAgObg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ganapathi Bhat <gbhat@marvell.com>,
        huangwen <huangwenabc@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 008/187] mwifiex: fix possible heap overflow in mwifiex_process_country_ie()
Date:   Fri, 27 Dec 2019 12:37:56 -0500
Message-Id: <20191227174055.4923-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ganapathi Bhat <gbhat@marvell.com>

[ Upstream commit 3d94a4a8373bf5f45cf5f939e88b8354dbf2311b ]

mwifiex_process_country_ie() function parse elements of bss
descriptor in beacon packet. When processing WLAN_EID_COUNTRY
element, there is no upper limit check for country_ie_len before
calling memcpy. The destination buffer domain_info->triplet is an
array of length MWIFIEX_MAX_TRIPLET_802_11D(83). The remote
attacker can build a fake AP with the same ssid as real AP, and
send malicous beacon packet with long WLAN_EID_COUNTRY elemen
(country_ie_len > 83). Attacker can  force STA connect to fake AP
on a different channel. When the victim STA connects to fake AP,
will trigger the heap buffer overflow. Fix this by checking for
length and if found invalid, don not connect to the AP.

This fix addresses CVE-2019-14895.

Reported-by: huangwen <huangwenabc@gmail.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 74e50566db1f..6dd835f1efc2 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -229,6 +229,14 @@ static int mwifiex_process_country_ie(struct mwifiex_private *priv,
 			    "11D: skip setting domain info in FW\n");
 		return 0;
 	}
+
+	if (country_ie_len >
+	    (IEEE80211_COUNTRY_STRING_LEN + MWIFIEX_MAX_TRIPLET_802_11D)) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "11D: country_ie_len overflow!, deauth AP\n");
+		return -EINVAL;
+	}
+
 	memcpy(priv->adapter->country_code, &country_ie[2], 2);
 
 	domain_info->country_code[0] = country_ie[2];
@@ -272,8 +280,9 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 	priv->scan_block = false;
 
 	if (bss) {
-		if (adapter->region_code == 0x00)
-			mwifiex_process_country_ie(priv, bss);
+		if (adapter->region_code == 0x00 &&
+		    mwifiex_process_country_ie(priv, bss))
+			return -EINVAL;
 
 		/* Allocate and fill new bss descriptor */
 		bss_desc = kzalloc(sizeof(struct mwifiex_bssdescriptor),
-- 
2.20.1

