Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91B636345A
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 10:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbhDRIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 04:40:25 -0400
Received: from smtprelay0049.hostedemail.com ([216.40.44.49]:42172 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229811AbhDRIkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 04:40:24 -0400
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 089F4181D337B;
        Sun, 18 Apr 2021 08:39:56 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 9FD9ED1513;
        Sun, 18 Apr 2021 08:39:54 +0000 (UTC)
Message-ID: <8b210b5f5972e39eded269b35a1297cf824c4181.camel@perches.com>
Subject: [PATCH] net/wireless/bcom: constify ieee80211_get_response_rate
 return
From:   Joe Perches <joe@perches.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Sun, 18 Apr 2021 01:39:53 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9FD9ED1513
X-Spam-Status: No, score=0.10
X-Stat-Signature: wxh44ewt85uwut8m4fac3o6ad4fbuo6w
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+G5UYbcY9U2RzhD4ADj2YOG2tye+AZKYQ=
X-HE-Tag: 1618735194-176317
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's not modified so make it const with the eventual goal of moving
data to text for various static struct ieee80211_rate arrays.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/broadcom/b43/main.c       | 2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c | 2 +-
 include/net/cfg80211.h                         | 2 +-
 net/wireless/util.c                            | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 150a366e8f62..17bcec5f3ff7 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -4053,7 +4053,7 @@ static void b43_update_basic_rates(struct b43_wldev *dev, u32 brates)
 {
 	struct ieee80211_supported_band *sband =
 		dev->wl->hw->wiphy->bands[b43_current_band(dev->wl)];
-	struct ieee80211_rate *rate;
+	const struct ieee80211_rate *rate;
 	int i;
 	u16 basic, direct, offset, basic_offset, rateptr;
 
diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 7692a2618c97..f64ebff68308 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -2762,7 +2762,7 @@ static void b43legacy_update_basic_rates(struct b43legacy_wldev *dev, u32 brates
 {
 	struct ieee80211_supported_band *sband =
 		dev->wl->hw->wiphy->bands[NL80211_BAND_2GHZ];
-	struct ieee80211_rate *rate;
+	const struct ieee80211_rate *rate;
 	int i;
 	u16 basic, direct, offset, basic_offset, rateptr;
 
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 911fae42b0c0..ed07590bc72d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5606,7 +5606,7 @@ static inline bool cfg80211_channel_is_psc(struct ieee80211_channel *chan)
  * which is, for this function, given as a bitmap of indices of
  * rates in the band's bitrate table.
  */
-struct ieee80211_rate *
+const struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 			    u32 basic_rates, int bitrate);
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 1bf0200f562a..382c5262d997 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -24,7 +24,7 @@
 #include "rdev-ops.h"
 
 
-struct ieee80211_rate *
+const struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
 			    u32 basic_rates, int bitrate)
 {

