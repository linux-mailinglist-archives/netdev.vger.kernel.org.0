Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AEA57716
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfF0Am4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727549AbfF0Amx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:42:53 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EB97205ED;
        Thu, 27 Jun 2019 00:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561596172;
        bh=u/EUKbUPvQwB8bt5P8taYWLNgM9B/JNUx/XAZTXWSdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JeIuxIIZeohCQZAHRYGmeBMw2ot1ekakZANW8i4kLIkitYuedf5X7gsj0YGnorRHP
         Tq1I/lx38M98/EnaZB3sNs9pz/YgiZu/jO0bXMMw3GbOf8ykNF/Cb8/buiUzKs048T
         K90SQUGAf/awR84GUHyS37+eKWgK2xFSVSuNNVws=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, huangwen <huangwen@venustech.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 04/12] mwifiex: Fix possible buffer overflows at parsing bss descriptor
Date:   Wed, 26 Jun 2019 20:42:26 -0400
Message-Id: <20190627004236.21909-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627004236.21909-1-sashal@kernel.org>
References: <20190627004236.21909-1-sashal@kernel.org>
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
 drivers/net/wireless/mwifiex/scan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index fb98f42cb5e7..6f789899c888 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1219,6 +1219,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 		}
 		switch (element_id) {
 		case WLAN_EID_SSID:
+			if (element_len > IEEE80211_MAX_SSID_LEN)
+				return -EINVAL;
 			bss_entry->ssid.ssid_len = element_len;
 			memcpy(bss_entry->ssid.ssid, (current_ptr + 2),
 			       element_len);
@@ -1228,6 +1230,8 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			break;
 
 		case WLAN_EID_SUPP_RATES:
+			if (element_len > MWIFIEX_SUPPORTED_RATES)
+				return -EINVAL;
 			memcpy(bss_entry->data_rates, current_ptr + 2,
 			       element_len);
 			memcpy(bss_entry->supported_rates, current_ptr + 2,
-- 
2.20.1

