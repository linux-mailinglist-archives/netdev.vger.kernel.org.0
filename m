Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 726C926B0C
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfEVTXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730920AbfEVTXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:23:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3187E21473;
        Wed, 22 May 2019 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553012;
        bh=9kA7/3NfFEuzmb1BGqSNJEJHToYnF5TiQxVFRt+cegs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7Hcjh1AOO9RclKxv9O30zyGewpf33YY5ebhaKXbwJykoqRTJCYuS9ESBGkTlGfoz
         OIttdH9CDrw8YPf3dXEJAnfjY7AibfR5e5tKOQpJQMUjdsWu9MKz/fg3eExvl833fA
         4KbPbYxZhfN6w/V8scE/LRCJVCUQZk1vh1/2Z3qM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 076/375] mac80211/cfg80211: update bss channel on channel switch
Date:   Wed, 22 May 2019 15:16:16 -0400
Message-Id: <20190522192115.22666-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 5dc8cdce1d722c733f8c7af14c5fb595cfedbfa8 ]

FullMAC STAs have no way to update bss channel after CSA channel switch
completion. As a result, user-space tools may provide inconsistent
channel info. For instance, consider the following two commands:
$ sudo iw dev wlan0 link
$ sudo iw dev wlan0 info
The latter command gets channel info from the hardware, so most probably
its output will be correct. However the former command gets channel info
from scan cache, so its output will contain outdated channel info.
In fact, current bss channel info will not be updated until the
next [re-]connect.

Note that mac80211 STAs have a workaround for this, but it requires
access to internal cfg80211 data, see ieee80211_chswitch_work:

	/* XXX: shouldn't really modify cfg80211-owned data! */
	ifmgd->associated->channel = sdata->csa_chandef.chan;

This patch suggests to convert mac80211 workaround into cfg80211 behavior
and to update current bss channel in cfg80211_ch_switch_notify.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c    | 3 ---
 net/wireless/nl80211.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2dbcf5d5512ef..b7a9fe3d5fcb7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1188,9 +1188,6 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		goto out;
 	}
 
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->csa_chandef.chan;
-
 	ifmgd->csa_waiting_bcn = true;
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 47e30a58566c2..d2a7459a5da43 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15727,6 +15727,11 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
 	wdev->chandef = *chandef;
 	wdev->preset_chandef = *chandef;
+
+	if (wdev->iftype == NL80211_IFTYPE_STATION &&
+	    !WARN_ON(!wdev->current_bss))
+		wdev->current_bss->pub.channel = chandef->chan;
+
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL,
 				 NL80211_CMD_CH_SWITCH_NOTIFY, 0);
 }
-- 
2.20.1

