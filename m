Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979435779D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfF0Ajw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729154AbfF0Ajv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:39:51 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F76221871;
        Thu, 27 Jun 2019 00:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595990;
        bh=ocExHtCWWhoXM4eKdTlrTAcILeSBjOfZJFpcQNKc0ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUVDc6zQhob3VNFrfYa5G5wMYt0HR4PUQgEYtn5d43TA+zmIMw7Hqk9vrO1qOqMZs
         GD6GAksBZzobjypntQsgNlT1NTtLSk11XEI64I9/2mpQlAm0YbR6P440Vu2jUNqZc8
         qfO72p8TDqVT01F9mQ9iuBkXQPKJ6LI+rskEXUew=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, huangwen <huangwen@venustech.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 07/35] mwifiex: Fix possible buffer overflows at parsing bss descriptor
Date:   Wed, 26 Jun 2019 20:38:55 -0400
Message-Id: <20190627003925.21330-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003925.21330-1-sashal@kernel.org>
References: <20190627003925.21330-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 13ec7f10b87f5fc04c4ccbd491c94c7980236a74 ]

mwifiex_update_bss_desc_with_ie() calls memcpy() unconditionally in
a couple places without checking the destination size.  Since the
source is given from user-space, this may trigger a heap buffer
overflow.

Fix it by putting the length check before performing memcpy().

This fix addresses CVE-2019-3846.

Reported-by: huangwen <huangwen@venustech.com.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index c9d41ed77fc7..c08a4574c396 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -1244,6 +1244,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:
+			if (element_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
@@ -1253,6 +1255,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_SUPP_RATES:
+			if (element_len > MWIFIEX_SUPPORTED_RATES)
+				return -EINVAL;
 			memcpy(bss_entry->data_rates, current_ptr + 2,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
-- 
2.20.1

