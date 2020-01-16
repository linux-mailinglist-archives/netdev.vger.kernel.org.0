Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C3113F831
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437530AbgAPTQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:16:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732911AbgAPQzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:45 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04FBE22464;
        Thu, 16 Jan 2020 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193744;
        bh=hUCMA1DGQK64tNMuIDmFJLb5pl45o3fY3EpLSObaZ9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tglqb4bJtEo97ASRsPLOIOJADIVEQVQcygimF+rZ0VqV5jnBTIVe3J07vX1CZ7b1q
         07xSydo8FwysKKMcT3zm07tEcUNSPM/MJdfZmTPkmCwZprBtyEribSWYyQ/d+tVgWx
         vpZPyNrokoX7FFEL1dEmb9IMEv4FxCNypmaImmM8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 035/671] rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version
Date:   Thu, 16 Jan 2020 11:44:26 -0500
Message-Id: <20200116165502.8838-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c894696188d5c2af1e636e458190e80c53fb893d ]

Function _rtl8821ae_mrate_idx_to_arfr_id is functionally identical to
the generic version rtl_mrate_idx_to_arfr_id, so remove
_rtl8821ae_mrate_idx_to_arfr_id and use the generic one instead.

This also fixes a missing break statement found by CoverityScan in
_rtl8821ae_mrate_idx_to_arfr_id, namely: CID#1167237 ("Missing break
in switch")

Thanks to Joe Perches for spotting this when I submitted an earlier patch.

Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
ACKed-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 71 +------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 317c1b3101da..ba258318ee9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3404,75 +3404,6 @@ static void rtl8821ae_update_hal_rate_table(struct ieee80211_hw *hw,
 		 "%x\n", rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
-static u8 _rtl8821ae_mrate_idx_to_arfr_id(
-	struct ieee80211_hw *hw, u8 rate_index,
-	enum wireless_mode wirelessmode)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u8 ret = 0;
-	switch (rate_index) {
-	case RATR_INX_WIRELESS_NGB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 1;
-		else
-			ret = 0;
-		; break;
-	case RATR_INX_WIRELESS_N:
-	case RATR_INX_WIRELESS_NG:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 5;
-		else
-			ret = 4;
-		; break;
-	case RATR_INX_WIRELESS_NB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 3;
-		else
-			ret = 2;
-		; break;
-	case RATR_INX_WIRELESS_GB:
-		ret = 6;
-		break;
-	case RATR_INX_WIRELESS_G:
-		ret = 7;
-		break;
-	case RATR_INX_WIRELESS_B:
-		ret = 8;
-		break;
-	case RATR_INX_WIRELESS_MC:
-		if ((wirelessmode == WIRELESS_MODE_B)
-			|| (wirelessmode == WIRELESS_MODE_G)
-			|| (wirelessmode == WIRELESS_MODE_N_24G)
-			|| (wirelessmode == WIRELESS_MODE_AC_24G))
-			ret = 6;
-		else
-			ret = 7;
-	case RATR_INX_WIRELESS_AC_5N:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 10;
-		else
-			ret = 9;
-		break;
-	case RATR_INX_WIRELESS_AC_24N:
-		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_80) {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 10;
-			else
-				ret = 9;
-		} else {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 11;
-			else
-				ret = 12;
-		}
-		break;
-	default:
-		ret = 0; break;
-	}
-	return ret;
-}
-
 static u32 _rtl8821ae_rate_to_bitmap_2ssvht(__le16 vht_rate)
 {
 	u8 i, j, tmp_rate;
@@ -3761,7 +3692,7 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ratr_index = _rtl8821ae_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
+	ratr_index = rtl_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
 	sta_entry->ratr_index = ratr_index;
 	ratr_bitmap = _rtl8821ae_set_ra_vht_ratr_bitmap(hw, wirelessmode,
 							ratr_bitmap);
-- 
2.20.1

