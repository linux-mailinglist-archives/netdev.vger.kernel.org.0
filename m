Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A7E26BE0
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732561AbfEVTaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387399AbfEVTav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:30:51 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21A4021473;
        Wed, 22 May 2019 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553450;
        bh=/z4pvG5BMzSHX+Zzf6J8UySYZ46trHLr3FMeC7wZZok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e+3V0dKP4pZJE1SPuH3zX7fG3Hv3kXAaBUDKchEYSVZooOWKvSphxq5JVCWDktzKj
         WtXVz/hlTivx6yEBZGpTAHRmmd1k5PrE68z9LH0zx32Kv7tf5KL0DTZeit0x/eoC7/
         OOtfrecT76Bx0dsSsVLMarDN7P0C0i6w0Hu/t7SU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 020/114] mac80211/cfg80211: update bss channel on channel switch
Date:   Wed, 22 May 2019 15:28:43 -0400
Message-Id: <20190522193017.26567-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
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
index 6e0aa296f1346..d787717140e54 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1072,9 +1072,6 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 		goto out;
 	}
 
-	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->csa_chandef.chan;
-
 	ifmgd->csa_waiting_bcn = true;
 
 	ieee80211_sta_reset_beacon_monitor(sdata);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 09a353c6373a8..d6e6293157717 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14014,6 +14014,11 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 
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

