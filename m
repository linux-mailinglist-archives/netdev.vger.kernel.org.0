Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21AA1A597B
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgDKXIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728828AbgDKXIH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 838B12173E;
        Sat, 11 Apr 2020 23:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646487;
        bh=Ddj9UahbyyEDMEsA4uD2XcrxDHuCCjCCosOi5TugEdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCIcPcMG9nQMka0S/5SoL8PNnibwbH8ozK4L3dCxeJgeHwq1EO34m61ll4gzMbt4J
         v6yCPiYfGbuKQ8h2YZFvTmQLsSkCleO7kD92Fws6905NUlj09VHMS+nAL4LCf30Rin
         nJzo1mMI34Tq/AiSC28lhb8HrK+uRMA0k+Uirpnk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzu-En Huang <tehuang@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Chris Chiu <chiu@endlessm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 051/121] rtw88: Fix incorrect beamformee role setting
Date:   Sat, 11 Apr 2020 19:05:56 -0400
Message-Id: <20200411230706.23855-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit aa7619a39acef91c5a6904f3ada7d0f20e2ad25e ]

In associating and configuring beamformee, bfee->role is not
correctly set before rtw_chip_ops::config_bfee().
Fix it by setting it correctly.

Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Reviewed-by: Chris Chiu <chiu@endlessm.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/bf.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
index fda771d23f712..b6d1d71f4d302 100644
--- a/drivers/net/wireless/realtek/rtw88/bf.c
+++ b/drivers/net/wireless/realtek/rtw88/bf.c
@@ -41,7 +41,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 	struct ieee80211_sta_vht_cap *ic_vht_cap;
 	const u8 *bssid = bss_conf->bssid;
 	u32 sound_dim;
-	u8 bfee_role = RTW_BFEE_NONE;
 	u8 i;
 
 	if (!(chip->band & RTW_BAND_5G))
@@ -67,7 +66,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		}
 
 		ether_addr_copy(bfee->mac_addr, bssid);
-		bfee_role = RTW_BFEE_MU;
+		bfee->role = RTW_BFEE_MU;
 		bfee->p_aid = (bssid[5] << 1) | (bssid[4] >> 7);
 		bfee->aid = bss_conf->aid;
 		bfinfo->bfer_mu_cnt++;
@@ -85,7 +84,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		sound_dim >>= IEEE80211_VHT_CAP_SOUNDING_DIMENSIONS_SHIFT;
 
 		ether_addr_copy(bfee->mac_addr, bssid);
-		bfee_role = RTW_BFEE_SU;
+		bfee->role = RTW_BFEE_SU;
 		bfee->sound_dim = (u8)sound_dim;
 		bfee->g_id = 0;
 		bfee->p_aid = (bssid[5] << 1) | (bssid[4] >> 7);
@@ -102,7 +101,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 	}
 
 out_unlock:
-	bfee->role = bfee_role;
 	rcu_read_unlock();
 }
 
-- 
2.20.1

