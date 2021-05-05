Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A359374234
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbhEEQqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235682AbhEEQos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE96A616ED;
        Wed,  5 May 2021 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232525;
        bh=KTYIwlgGJ7+OucXk3Y6qENTaagaQ8ZIYiAfbuehrkXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDCcQ2JoJR2MA3PS/HaWJCi09/hJTAcjhap5VYiJFwGAfe9FopcP3JaEV4NWHFoXU
         hctuT0ulk2UQCZ2d+UZot997yowze+QTxhwiDQv+34atQgHU8qd6bqHpUj6BhX+7/o
         RzQTKmVpc4tOI9qt5PuRpZKLHX2w4XTsK/WD3ZA5QpwictqRPfbonfUrhmerEGH1Y6
         sr7EfgkJmI968tG9ypCGDFFfceW8gKufw4YJ8+54tVRnaPRV6UrfJVeGWI31tfoxya
         6TN1+zpWEAqKpAs8pK5YJ5qAy8vuG9BaR+KMyL/TZU5A0NW4by9/7olq5OP6oyoOa0
         J4YcCBMg0muDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 050/104] rtw88: 8822c: add LC calibration for RTL8822C
Date:   Wed,  5 May 2021 12:33:19 -0400
Message-Id: <20210505163413.3461611-50-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 7ae7784ec2a812c07d2ca91a6538ef2470154fb6 ]

Fix power tracking issue by replacing unnecessary IQ calibration
with LC calibration.
When thermal difference exceeds limitation, let RF circuit adjsut
its characteristic to fit in current environment.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210319054218.3319-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.h     |  2 ++
 drivers/net/wireless/realtek/rtw88/phy.c      | 14 ++++++++++
 drivers/net/wireless/realtek/rtw88/phy.h      |  1 +
 drivers/net/wireless/realtek/rtw88/reg.h      |  5 ++++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 27 +++++++++++++++++--
 5 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 9a318dfd04f9..3d51394edb4a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1157,6 +1157,7 @@ struct rtw_chip_info {
 	bool en_dis_dpd;
 	u16 dpd_ratemask;
 	u8 iqk_threshold;
+	u8 lck_threshold;
 	const struct rtw_pwr_track_tbl *pwr_track_tbl;
 
 	u8 bfer_su_max_num;
@@ -1520,6 +1521,7 @@ struct rtw_dm_info {
 	u8 tx_rate;
 	u8 thermal_avg[RTW_RF_PATH_MAX];
 	u8 thermal_meter_k;
+	u8 thermal_meter_lck;
 	s8 delta_power_index[RTW_RF_PATH_MAX];
 	s8 delta_power_index_last[RTW_RF_PATH_MAX];
 	u8 default_ofdm_index;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index d44960cd940c..0793f08b4fea 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -2159,6 +2159,20 @@ s8 rtw_phy_pwrtrack_get_pwridx(struct rtw_dev *rtwdev,
 }
 EXPORT_SYMBOL(rtw_phy_pwrtrack_get_pwridx);
 
+bool rtw_phy_pwrtrack_need_lck(struct rtw_dev *rtwdev)
+{
+	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
+	u8 delta_lck;
+
+	delta_lck = abs(dm_info->thermal_avg[0] - dm_info->thermal_meter_lck);
+	if (delta_lck >= rtwdev->chip->lck_threshold) {
+		dm_info->thermal_meter_lck = dm_info->thermal_avg[0];
+		return true;
+	}
+	return false;
+}
+EXPORT_SYMBOL(rtw_phy_pwrtrack_need_lck);
+
 bool rtw_phy_pwrtrack_need_iqk(struct rtw_dev *rtwdev)
 {
 	struct rtw_dm_info *dm_info = &rtwdev->dm_info;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.h b/drivers/net/wireless/realtek/rtw88/phy.h
index b924ed07630a..9623248c9466 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.h
+++ b/drivers/net/wireless/realtek/rtw88/phy.h
@@ -55,6 +55,7 @@ u8 rtw_phy_pwrtrack_get_delta(struct rtw_dev *rtwdev, u8 path);
 s8 rtw_phy_pwrtrack_get_pwridx(struct rtw_dev *rtwdev,
 			       struct rtw_swing_table *swing_table,
 			       u8 tbl_path, u8 therm_path, u8 delta);
+bool rtw_phy_pwrtrack_need_lck(struct rtw_dev *rtwdev);
 bool rtw_phy_pwrtrack_need_iqk(struct rtw_dev *rtwdev);
 void rtw_phy_config_swing_table(struct rtw_dev *rtwdev,
 				struct rtw_swing_table *swing_table);
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index cf9a3b674d30..767f7777d409 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -650,8 +650,13 @@
 #define RF_TXATANK	0x64
 #define RF_TRXIQ	0x66
 #define RF_RXIQGEN	0x8d
+#define RF_SYN_PFD	0xb0
 #define RF_XTALX2	0xb8
+#define RF_SYN_CTRL	0xbb
 #define RF_MALSEL	0xbe
+#define RF_SYN_AAC	0xc9
+#define RF_AAC_CTRL	0xca
+#define RF_FAST_LCK	0xcc
 #define RF_RCKD		0xde
 #define RF_TXADBG	0xde
 #define RF_LUTDBG	0xdf
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index dd560c28abb2..448922cb2e63 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -1126,6 +1126,7 @@ static void rtw8822c_pwrtrack_init(struct rtw_dev *rtwdev)
 
 	dm_info->pwr_trk_triggered = false;
 	dm_info->thermal_meter_k = rtwdev->efuse.thermal_meter_k;
+	dm_info->thermal_meter_lck = rtwdev->efuse.thermal_meter_k;
 }
 
 static void rtw8822c_phy_set_param(struct rtw_dev *rtwdev)
@@ -2108,6 +2109,26 @@ static void rtw8822c_false_alarm_statistics(struct rtw_dev *rtwdev)
 	rtw_write32_set(rtwdev, REG_RX_BREAK, BIT_COM_RX_GCK_EN);
 }
 
+static void rtw8822c_do_lck(struct rtw_dev *rtwdev)
+{
+	u32 val;
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_SYN_CTRL, RFREG_MASK, 0x80010);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_SYN_PFD, RFREG_MASK, 0x1F0FA);
+	fsleep(1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_AAC_CTRL, RFREG_MASK, 0x80000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_SYN_AAC, RFREG_MASK, 0x80001);
+	read_poll_timeout(rtw_read_rf, val, val != 0x1, 1000, 100000,
+			  true, rtwdev, RF_PATH_A, RF_AAC_CTRL, 0x1000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_SYN_PFD, RFREG_MASK, 0x1F0F8);
+	rtw_write_rf(rtwdev, RF_PATH_B, RF_SYN_CTRL, RFREG_MASK, 0x80010);
+
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_FAST_LCK, RFREG_MASK, 0x0f000);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_FAST_LCK, RFREG_MASK, 0x4f000);
+	fsleep(1);
+	rtw_write_rf(rtwdev, RF_PATH_A, RF_FAST_LCK, RFREG_MASK, 0x0f000);
+}
+
 static void rtw8822c_do_iqk(struct rtw_dev *rtwdev)
 {
 	struct rtw_iqk_para para = {0};
@@ -3538,11 +3559,12 @@ static void __rtw8822c_pwr_track(struct rtw_dev *rtwdev)
 
 	rtw_phy_config_swing_table(rtwdev, &swing_table);
 
+	if (rtw_phy_pwrtrack_need_lck(rtwdev))
+		rtw8822c_do_lck(rtwdev);
+
 	for (i = 0; i < rtwdev->hal.rf_path_num; i++)
 		rtw8822c_pwr_track_path(rtwdev, &swing_table, i);
 
-	if (rtw_phy_pwrtrack_need_iqk(rtwdev))
-		rtw8822c_do_iqk(rtwdev);
 }
 
 static void rtw8822c_pwr_track(struct rtw_dev *rtwdev)
@@ -4351,6 +4373,7 @@ struct rtw_chip_info rtw8822c_hw_spec = {
 	.dpd_ratemask = DIS_DPD_RATEALL,
 	.pwr_track_tbl = &rtw8822c_rtw_pwr_track_tbl,
 	.iqk_threshold = 8,
+	.lck_threshold = 8,
 	.bfer_su_max_num = 2,
 	.bfer_mu_max_num = 1,
 	.rx_ldpc = true,
-- 
2.30.2

