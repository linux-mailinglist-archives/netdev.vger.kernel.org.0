Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC941694F8
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBWCen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:51360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728130AbgBWCWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:22:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053F2208C3;
        Sun, 23 Feb 2020 02:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424542;
        bh=PtriBsXyW8kGTAqXSDy7UYBdHikaU5JTUnz/W1iCUdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X932TZecS8SDghWmK/+lVskKiKGwIihu8IgZkI6/x1Bt/xLH8PSDwmY9PKXCq/AoB
         D17uu74H7nx/pr/CvY9njxyOw8CC7Zi7D4vR8becgIZXn6RhhuKEgcuIvQzYqYwsLp
         0cC4BDJ0owhzrctgdVHHl1D+nJVWbphhI+qkmbHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Bar <shay.bar@celeno.com>,
        Aviad Brikman <aviad.brikman@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 52/58] mac80211: fix wrong 160/80+80 MHz setting
Date:   Sat, 22 Feb 2020 21:21:13 -0500
Message-Id: <20200223022119.707-52-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022119.707-1-sashal@kernel.org>
References: <20200223022119.707-1-sashal@kernel.org>
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

[ Upstream commit 33181ea7f5a62a17fbe55f0f73428ecb5e686be8 ]

Before this patch, STA's would set new width of 160/80+80 MHz based on AP capability only.
This is wrong because STA may not support > 80MHz BW.
Fix is to verify STA has 160/80+80 MHz capability before increasing its width to > 80MHz.

The "support_80_80" and "support_160" setting is based on:
"Table 9-272 — Setting of the Supported Channel Width Set subfield and Extended NSS BW
Support subfield at a STA transmitting the VHT Capabilities Information field"
From "Draft P802.11REVmd_D3.0.pdf"

Signed-off-by: Aviad Brikman <aviad.brikman@celeno.com>
Signed-off-by: Shay Bar <shay.bar@celeno.com>
Link: https://lore.kernel.org/r/20200210130728.23674-1-shay.bar@celeno.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 739e90555d8b9..decd46b383938 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2993,10 +2993,22 @@ bool ieee80211_chandef_vht_oper(struct ieee80211_hw *hw,
 	int cf0, cf1;
 	int ccfs0, ccfs1, ccfs2;
 	int ccf0, ccf1;
+	u32 vht_cap;
+	bool support_80_80 = false;
+	bool support_160 = false;
 
 	if (!oper || !htop)
 		return false;
 
+	vht_cap = hw->wiphy->bands[chandef->chan->band]->vht_cap.cap;
+	support_160 = (vht_cap & (IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK |
+				  IEEE80211_VHT_CAP_EXT_NSS_BW_MASK));
+	support_80_80 = ((vht_cap &
+			 IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ) ||
+			(vht_cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ &&
+			 vht_cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) ||
+			((vht_cap & IEEE80211_VHT_CAP_EXT_NSS_BW_MASK) >>
+				    IEEE80211_VHT_CAP_EXT_NSS_BW_SHIFT > 1));
 	ccfs0 = oper->center_freq_seg0_idx;
 	ccfs1 = oper->center_freq_seg1_idx;
 	ccfs2 = (le16_to_cpu(htop->operation_mode) &
@@ -3024,10 +3036,10 @@ bool ieee80211_chandef_vht_oper(struct ieee80211_hw *hw,
 			unsigned int diff;
 
 			diff = abs(ccf1 - ccf0);
-			if (diff == 8) {
+			if ((diff == 8) && support_160) {
 				new.width = NL80211_CHAN_WIDTH_160;
 				new.center_freq1 = cf1;
-			} else if (diff > 8) {
+			} else if ((diff > 8) && support_80_80) {
 				new.width = NL80211_CHAN_WIDTH_80P80;
 				new.center_freq2 = cf1;
 			}
-- 
2.20.1

