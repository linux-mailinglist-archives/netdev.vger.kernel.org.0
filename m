Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329792601A7
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgIGRK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgIGQcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B6B2177B;
        Mon,  7 Sep 2020 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496364;
        bh=0Szs6Xbj6uEv6yMuq/ROsBND+F0HzpKX80tnhTB6vNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNtWZDZny9+93MIRQSnqfurOQAW/qjwyEGsELOoB5lXq3zBu1/pjKrG0oOXFUuu0K
         kZrbgbp1mEnvNFVmO/3G8fhMaiSzWFB5mY/+KX6ZF5QJkul3J9JOZi7/yW5MGF1HbK
         li9OwwGSPrRxywmwuRgVds1TWlv34C5CgCKmZTbE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Bar <shay.bar@celeno.com>,
        Aviad Brikman <aviad.brikman@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 18/53] wireless: fix wrong 160/80+80 MHz setting
Date:   Mon,  7 Sep 2020 12:31:44 -0400
Message-Id: <20200907163220.1280412-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Bar <shay.bar@celeno.com>

[ Upstream commit 3579994476b65cb5e272ff0f720a1fd31322e53f ]

Fix cfg80211_chandef_usable():
consider IEEE80211_VHT_CAP_EXT_NSS_BW when verifying 160/80+80 MHz.

Based on:
"Table 9-272 — Setting of the Supported Channel Width Set subfield and Extended NSS BW
Support subfield at a STA transmitting the VHT Capabilities Information field"
From "Draft P802.11REVmd_D3.0.pdf"

Signed-off-by: Aviad Brikman <aviad.brikman@celeno.com>
Signed-off-by: Shay Bar <shay.bar@celeno.com>
Link: https://lore.kernel.org/r/20200826143139.25976-1-shay.bar@celeno.com
[reformat the code a bit and use u32_get_bits()]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/chan.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index cddf92c5d09ef..7a7cc4ade2b36 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/export.h>
+#include <linux/bitfield.h>
 #include <net/cfg80211.h>
 #include "core.h"
 #include "rdev-ops.h"
@@ -892,6 +893,7 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 	struct ieee80211_sta_vht_cap *vht_cap;
 	struct ieee80211_edmg *edmg_cap;
 	u32 width, control_freq, cap;
+	bool support_80_80 = false;
 
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return false;
@@ -944,9 +946,13 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80P80:
-		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
-		if (chandef->chan->band != NL80211_BAND_6GHZ &&
-		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		cap = vht_cap->cap;
+		support_80_80 =
+			(cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ) ||
+			(cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
+			 cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) ||
+			u32_get_bits(cap, IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) > 1;
+		if (chandef->chan->band != NL80211_BAND_6GHZ && !support_80_80)
 			return false;
 		/* fall through */
 	case NL80211_CHAN_WIDTH_80:
@@ -966,7 +972,8 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			return false;
 		cap = vht_cap->cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK;
 		if (cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
-		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ)
+		    cap != IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ &&
+		    !(vht_cap->cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK))
 			return false;
 		break;
 	default:
-- 
2.25.1

