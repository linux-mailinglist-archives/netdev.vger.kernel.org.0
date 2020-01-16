Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A33B13E17B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgAPQtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:49:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729252AbgAPQtj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:49:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B34620663;
        Thu, 16 Jan 2020 16:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193374;
        bh=C96a+mA26VHuB+oQECQ6m+cAwSTLG2QesUhivJbn6yM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRrPDKyx98Buj2Tbd/xhZkfzg77FKbJlUz/nHFyFzVyQGMAhlYc9LsrQbP5YGzRtn
         Uqic8oY8M5G+qT0OUDF49hFj6t/7y3AI1LWEAi7/JoHT0B9zVxVyt+6+YWiD9NbgNt
         f9aQl+9orEDcwjm78s1+hrs/Tds6vmrChVo1rm64=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tzu-En Huang <tehuang@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 084/205] rtw88: fix potential read outside array boundary
Date:   Thu, 16 Jan 2020 11:40:59 -0500
Message-Id: <20200116164300.6705-84-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tzu-En Huang <tehuang@realtek.com>

[ Upstream commit 18a0696e85fde169e0109aa61d0505b2b935b59d ]

The level of cckpd is from 0 to 4, and it is the index of
array pd_lvl[] and cs_lvl[]. However, the length of both arrays
are 4, which is smaller than the possible maximum input index.
Enumerate cck level to make sure the max level will not be wrong
if new level is added in future.

Fixes: 479c4ee931a6 ("rtw88: add dynamic cck pd mechanism")
Signed-off-by: Tzu-En Huang <tehuang@realtek.com>
Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/phy.c      | 17 ++++++++---------
 drivers/net/wireless/realtek/rtw88/phy.h      |  9 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |  4 ++--
 3 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index d3d3f40de75e..47d199d2e7dc 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -118,7 +118,7 @@ static void rtw_phy_cck_pd_init(struct rtw_dev *rtwdev)
 
 	for (i = 0; i <= RTW_CHANNEL_WIDTH_40; i++) {
 		for (j = 0; j < RTW_RF_PATH_MAX; j++)
-			dm_info->cck_pd_lv[i][j] = 0;
+			dm_info->cck_pd_lv[i][j] = CCK_PD_LV0;
 	}
 
 	dm_info->cck_fa_avg = CCK_FA_AVG_RESET;
@@ -461,7 +461,6 @@ static void rtw_phy_dpk_track(struct rtw_dev *rtwdev)
 		chip->ops->dpk_track(rtwdev);
 }
 
-#define CCK_PD_LV_MAX		5
 #define CCK_PD_FA_LV1_MIN	1000
 #define CCK_PD_FA_LV0_MAX	500
 
@@ -471,10 +470,10 @@ static u8 rtw_phy_cck_pd_lv_unlink(struct rtw_dev *rtwdev)
 	u32 cck_fa_avg = dm_info->cck_fa_avg;
 
 	if (cck_fa_avg > CCK_PD_FA_LV1_MIN)
-		return 1;
+		return CCK_PD_LV1;
 
 	if (cck_fa_avg < CCK_PD_FA_LV0_MAX)
-		return 0;
+		return CCK_PD_LV0;
 
 	return CCK_PD_LV_MAX;
 }
@@ -494,15 +493,15 @@ static u8 rtw_phy_cck_pd_lv_link(struct rtw_dev *rtwdev)
 	u32 cck_fa_avg = dm_info->cck_fa_avg;
 
 	if (igi > CCK_PD_IGI_LV4_VAL && rssi > CCK_PD_RSSI_LV4_VAL)
-		return 4;
+		return CCK_PD_LV4;
 	if (igi > CCK_PD_IGI_LV3_VAL && rssi > CCK_PD_RSSI_LV3_VAL)
-		return 3;
+		return CCK_PD_LV3;
 	if (igi > CCK_PD_IGI_LV2_VAL || rssi > CCK_PD_RSSI_LV2_VAL)
-		return 2;
+		return CCK_PD_LV2;
 	if (cck_fa_avg > CCK_PD_FA_LV1_MIN)
-		return 1;
+		return CCK_PD_LV1;
 	if (cck_fa_avg < CCK_PD_FA_LV0_MAX)
-		return 0;
+		return CCK_PD_LV0;
 
 	return CCK_PD_LV_MAX;
 }
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index e79b084628e7..33a5eb9637c0 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -125,6 +125,15 @@ rtw_get_tx_power_params(struct rtw_dev *rtwdev, u8 path,
 			u8 rate, u8 bw, u8 ch, u8 regd,
 			struct rtw_power_params *pwr_param);
 
+enum rtw_phy_cck_pd_lv {
+	CCK_PD_LV0,
+	CCK_PD_LV1,
+	CCK_PD_LV2,
+	CCK_PD_LV3,
+	CCK_PD_LV4,
+	CCK_PD_LV_MAX,
+};
+
 #define	MASKBYTE0		0xff
 #define	MASKBYTE1		0xff00
 #define	MASKBYTE2		0xff0000
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index c2f6cd76a658..de0505a6a365 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -3168,8 +3168,8 @@ rtw8822c_phy_cck_pd_set_reg(struct rtw_dev *rtwdev,
 static void rtw8822c_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
 {
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
-	s8 pd_lvl[4] = {2, 4, 6, 8};
-	s8 cs_lvl[4] = {2, 2, 2, 4};
+	s8 pd_lvl[CCK_PD_LV_MAX] = {0, 2, 4, 6, 8};
+	s8 cs_lvl[CCK_PD_LV_MAX] = {0, 2, 2, 2, 4};
 	u8 cur_lvl;
 	u8 nrx, bw;
 
-- 
2.20.1

