Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65668E24
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387645AbfGOOD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733047AbfGOODy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:03:54 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E73052081C;
        Mon, 15 Jul 2019 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199433;
        bh=26J0cNgRs2gDrMoGxYgt4ejtXtTwNyGDi1cQ8KooqFk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud0oh1dPAH2EIIKnXkRnmLxfKY4UzTvr5kwlZoRq76y6kHwURVBosnuGEphzN2djd
         8undRiWtESheiHwm30O0EzQZYmt3naxV2pUAg1ooLP6+sdre8HZKYOc3uODVfHFJ6m
         hPemGh3+rTtGLKKxK94k9zSR9DiiCCKV8QqlRZZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pradeep kumar Chitrapu <pradeepc@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>,
        Sven Eckelmann <sven@narfation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 003/219] ath10k: fix incorrect multicast/broadcast rate setting
Date:   Mon, 15 Jul 2019 10:00:04 -0400
Message-Id: <20190715140341.6443-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pradeep kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit 93ee3d108fc77e19efeac3ec5aa7d5886711bfef ]

Invalid rate code is sent to firmware when multicast rate value of 0 is
sent to driver indicating disabled case, causing broken mesh path.
so fix that.

Tested on QCA9984 with firmware 10.4-3.6.1-00827

Sven tested on IPQ4019 with 10.4-3.5.3-00057 and QCA9888 with 10.4-3.5.3-00053
(ath10k-firmware) and 10.4-3.6-00140 (linux-firmware 2018-12-16-211de167).

Fixes: cd93b83ad92 ("ath10k: support for multicast rate control")
Co-developed-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Tested-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9c703d287333..e8997e22ceec 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5588,8 +5588,8 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	struct cfg80211_chan_def def;
 	u32 vdev_param, pdev_param, slottime, preamble;
 	u16 bitrate, hw_value;
-	u8 rate, basic_rate_idx;
-	int rateidx, ret = 0, hw_rate_code;
+	u8 rate, basic_rate_idx, rateidx;
+	int ret = 0, hw_rate_code, mcast_rate;
 	enum nl80211_band band;
 	const struct ieee80211_supported_band *sband;
 
@@ -5776,7 +5776,11 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_MCAST_RATE &&
 	    !ath10k_mac_vif_chan(arvif->vif, &def)) {
 		band = def.chan->band;
-		rateidx = vif->bss_conf.mcast_rate[band] - 1;
+		mcast_rate = vif->bss_conf.mcast_rate[band];
+		if (mcast_rate > 0)
+			rateidx = mcast_rate - 1;
+		else
+			rateidx = ffs(vif->bss_conf.basic_rates) - 1;
 
 		if (ar->phy_capability & WHAL_WLAN_11A_CAPABILITY)
 			rateidx += ATH10K_MAC_FIRST_OFDM_RATE_IDX;
-- 
2.20.1

