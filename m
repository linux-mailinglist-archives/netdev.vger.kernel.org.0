Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321F615F402
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405097AbgBNSRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730720AbgBNPvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29EC424685;
        Fri, 14 Feb 2020 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695476;
        bh=j5FNwqbiDd3zQGbUoiAPV81bz+Jo7tUnvf567ZMQT54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETAf4PFWiyWjXzXBnKuRk+fpe6213TB0r+ArtLgTz/2H8yHGrERDiU1zusvI46aBG
         iQb6iXMW+5hmRj20lBr+xKogVphqx6YEdPChERGENRq8LM00gKtTSuNg1KWiWFHTHv
         q6y2DpB/JenkMgo9Q3SFVxNkMjvLUGFXB3WEeE94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 109/542] rtw88: fix rate mask for 1SS chip
Date:   Fri, 14 Feb 2020 10:41:41 -0500
Message-Id: <20200214154854.6746-109-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 35a68fa5f96a80797e11b6952a47c5a84939a7bf ]

The rate mask is used to tell firmware the supported rate depends on
negotiation. We loop 2 times for all VHT/HT 2SS rate mask first, and then
only keep the part according to chip's NSS.

This commit fixes the logic error of '&' operations for VHT/HT rate, and
we should run this logic before adding legacy rate.

To access HT MCS map, index 0/1 represent MCS 0-7/8-15 respectively. Use
NL80211_BAND_xxx is incorrect, so fix it as well.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index ae61415e16654..f369ddca953af 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -706,8 +706,8 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_80)
 			is_support_sgi = true;
 	} else if (sta->ht_cap.ht_supported) {
-		ra_mask |= (sta->ht_cap.mcs.rx_mask[NL80211_BAND_5GHZ] << 20) |
-			   (sta->ht_cap.mcs.rx_mask[NL80211_BAND_2GHZ] << 12);
+		ra_mask |= (sta->ht_cap.mcs.rx_mask[1] << 20) |
+			   (sta->ht_cap.mcs.rx_mask[0] << 12);
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_RX_STBC)
 			stbc_en = HT_STBC_EN;
 		if (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING)
@@ -717,6 +717,9 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 			is_support_sgi = true;
 	}
 
+	if (efuse->hw_cap.nss == 1)
+		ra_mask &= RA_MASK_VHT_RATES_1SS | RA_MASK_HT_RATES_1SS;
+
 	if (hal->current_band_type == RTW_BAND_5G) {
 		ra_mask |= (u64)sta->supp_rates[NL80211_BAND_5GHZ] << 4;
 		if (sta->vht_cap.vht_supported) {
@@ -750,11 +753,6 @@ void rtw_update_sta_info(struct rtw_dev *rtwdev, struct rtw_sta_info *si)
 		wireless_set = 0;
 	}
 
-	if (efuse->hw_cap.nss == 1) {
-		ra_mask &= RA_MASK_VHT_RATES_1SS;
-		ra_mask &= RA_MASK_HT_RATES_1SS;
-	}
-
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_80:
 		bw_mode = RTW_CHANNEL_WIDTH_80;
-- 
2.20.1

