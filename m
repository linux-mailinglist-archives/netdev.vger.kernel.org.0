Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2656135CC79
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbhDLQ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:57016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244562AbhDLQ0c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:26:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F80A6137F;
        Mon, 12 Apr 2021 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244699;
        bh=gauwxOII5IhILsHkyZ5M5yDxGcZpvTc8saNGZFsgaoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDASX2d+iJ830NbSSN0wPOgJD7CLHT2iyq3wWUfzT99SDHOPI/iFdrLR9GE/J/Ly7
         yGr3SHxHw9UtLju9ttcRlT1RhggdZS8z68sLvxupwQ+FFRTkYIM0c0VAV4/OnonMEb
         NnUMdPs4k/mZLK7yDzuoEIDNDFjJJ6vrIoDOoWpdMkOCHfAAXCojf54UGoYNO5TIIf
         fvZ/umkfbY9PEknfXBwJV+Z3fihPAxiECSUYjE7VlEFH7UHv98y3HylH7YN+xyfnli
         G+SnqnCUUhpBNcHmnU/I8NfR1H/TeacNzTCIL1s3Plet7LVuvYicN0aWVuJCABMt4h
         wY0Tgq/eao71A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "A. Cody Schuffelen" <schuffelen@google.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 45/46] virt_wifi: Return micros for BSS TSF values
Date:   Mon, 12 Apr 2021 12:24:00 -0400
Message-Id: <20210412162401.314035-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "A. Cody Schuffelen" <schuffelen@google.com>

[ Upstream commit b57aa17f07c9270e576ef7df09f142978b5a75f0 ]

cfg80211_inform_bss expects to receive a TSF value, but is given the
time since boot in nanoseconds. TSF values are expected to be at
microsecond scale rather than nanosecond scale.

Signed-off-by: A. Cody Schuffelen <schuffelen@google.com>
Link: https://lore.kernel.org/r/20210318200419.1421034-1-schuffelen@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index c878097f0dda..1df959532c7d 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -12,6 +12,7 @@
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include <linux/etherdevice.h>
+#include <linux/math64.h>
 #include <linux/module.h>
 
 static struct wiphy *common_wiphy;
@@ -168,11 +169,11 @@ static void virt_wifi_scan_result(struct work_struct *work)
 			     scan_result.work);
 	struct wiphy *wiphy = priv_to_wiphy(priv);
 	struct cfg80211_scan_info scan_info = { .aborted = false };
+	u64 tsf = div_u64(ktime_get_boottime_ns(), 1000);
 
 	informed_bss = cfg80211_inform_bss(wiphy, &channel_5ghz,
 					   CFG80211_BSS_FTYPE_PRESP,
-					   fake_router_bssid,
-					   ktime_get_boottime_ns(),
+					   fake_router_bssid, tsf,
 					   WLAN_CAPABILITY_ESS, 0,
 					   (void *)&ssid, sizeof(ssid),
 					   DBM_TO_MBM(-50), GFP_KERNEL);
-- 
2.30.2

