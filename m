Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0969F480D40
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbhL1VPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237399AbhL1VPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:25 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20E6C061401;
        Tue, 28 Dec 2021 13:15:24 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id v11so40542706wrw.10;
        Tue, 28 Dec 2021 13:15:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VjfR3K+5JgkYbWpldO+nZERSdwRbxL2f2Vl4DU5yMWU=;
        b=TRwvLLHPklunzn5JC6LZGhc+TFA19TdQQVKlUHf+XK6nAbNsVbP8QzjiFdNe+i7KEf
         bPjxow6OssknSfRlYEIjWZRFVACGbH2fS8i2ahK3OKp2qkcreZKTGHx1VStKBg7wY5So
         pF6Bkgu7H78giHQtXlohtr7L0+hNyOHdrLCjPbSDK6a1uBUh9PtNV/QcD/G6xrr0HMaw
         X2VyGgaeQUDOo7UpbYTImiUxXhzD5EotgTBl0e8T5YiQTkYbg1j0X3KyCJ0jKHOFJnQK
         WDP2fTgKv9Mu2SsVh40cnu20PrhBUYOMzsSLHXENTKeUb/l1niYQ+Kr/awTfFqw4oezu
         jeZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjfR3K+5JgkYbWpldO+nZERSdwRbxL2f2Vl4DU5yMWU=;
        b=3PjzRK2tsh0YRK1+ejmYHZjYBF1mIUUxrTLThly+CLghNMunv2BGtzFGrnEhRq8o1R
         H8vpyuIN3fFNsnDtlwbFsLR+pDbOzlpRj3Ub0/I7P2m09mV0AE1bFdfE4vnwaaGoTmLR
         LuN98iSTJwtkWqaYP/ixMlcik8ZqR4IMmcFUQNvL0cGNRZg1nCtEDrtUS+5Wlbn0KGLd
         A/cAHVbcbH6UFKtLhyg/j8uSihQrS41FOSQ+f+wc7WFFQiZWOpNnCf4kTIuZNHPWbxwt
         GfjqYK2FWg/eizqmeQ96crPrv5efIeCcMZXIbnhpIk9rzecUIVCwWNDjp8nGQDU1SS3N
         zAhA==
X-Gm-Message-State: AOAM531S6W4Pqh9lTSsj7m2det745ndHBpaGGG2OZUo9WE3pwu7E9lOw
        Zu9JckbV5esH+mukUCTdjlDAhWuEMSk=
X-Google-Smtp-Source: ABdhPJxKs8RDjTJ1dXlLgjC33N03DhitK6NDEyt/SVW1wP2mUy375FlX1tq/CNs/exJQSyCxsDsHfQ==
X-Received: by 2002:adf:80a1:: with SMTP id 30mr17486013wrl.557.1640726122908;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 5/9] rtw88: Use rtw_iterate_stas where the iterator reads or writes registers
Date:   Tue, 28 Dec 2021 22:14:57 +0100
Message-Id: <20211228211501.468981-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
all users of rtw_iterate_stas_atomic() which are either reading or
writing a register to rtw_iterate_stas().

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 2 +-
 drivers/net/wireless/realtek/rtw88/phy.c  | 4 ++--
 drivers/net/wireless/realtek/rtw88/util.h | 2 ++
 drivers/net/wireless/realtek/rtw88/wow.c  | 2 +-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index b0e2ca8ddbe9..4b28c81b3ca0 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -584,7 +584,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 	rcu_read_lock();
 	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rcu_read_unlock();
-	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
+	rtw_iterate_stas(rtwdev, rtw_reset_sta_iter, rtwdev);
 	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index e505d17f107e..d8442adc11b1 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -300,7 +300,7 @@ static void rtw_phy_stat_rssi(struct rtw_dev *rtwdev)
 
 	data.rtwdev = rtwdev;
 	data.min_rssi = U8_MAX;
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_stat_rssi_iter, &data);
+	rtw_iterate_stas(rtwdev, rtw_phy_stat_rssi_iter, &data);
 
 	dm_info->pre_min_rssi = dm_info->min_rssi;
 	dm_info->min_rssi = data.min_rssi;
@@ -544,7 +544,7 @@ static void rtw_phy_ra_info_update(struct rtw_dev *rtwdev)
 	if (rtwdev->watch_dog_cnt & 0x3)
 		return;
 
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_ra_info_update_iter, rtwdev);
+	rtw_iterate_stas(rtwdev, rtw_phy_ra_info_update_iter, rtwdev);
 }
 
 static u32 rtw_phy_get_rrsr_mask(struct rtw_dev *rtwdev, u8 rate_idx)
diff --git a/drivers/net/wireless/realtek/rtw88/util.h b/drivers/net/wireless/realtek/rtw88/util.h
index 0c23b5069be0..b0dfadf8b82a 100644
--- a/drivers/net/wireless/realtek/rtw88/util.h
+++ b/drivers/net/wireless/realtek/rtw88/util.h
@@ -13,6 +13,8 @@ struct rtw_dev;
 #define rtw_iterate_vifs_atomic(rtwdev, iterator, data)                        \
 	ieee80211_iterate_active_interfaces_atomic(rtwdev->hw,                 \
 			IEEE80211_IFACE_ITER_NORMAL, iterator, data)
+#define rtw_iterate_stas(rtwdev, iterator, data)                        \
+	ieee80211_iterate_stations(rtwdev->hw, iterator, data)
 #define rtw_iterate_stas_atomic(rtwdev, iterator, data)                        \
 	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
 #define rtw_iterate_keys(rtwdev, vif, iterator, data)			       \
diff --git a/drivers/net/wireless/realtek/rtw88/wow.c b/drivers/net/wireless/realtek/rtw88/wow.c
index 89dc595094d5..7ec0731c0346 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -468,7 +468,7 @@ static void rtw_wow_fw_media_status(struct rtw_dev *rtwdev, bool connect)
 	data.rtwdev = rtwdev;
 	data.connect = connect;
 
-	rtw_iterate_stas_atomic(rtwdev, rtw_wow_fw_media_status_iter, &data);
+	rtw_iterate_stas(rtwdev, rtw_wow_fw_media_status_iter, &data);
 }
 
 static int rtw_wow_config_wow_fw_rsvd_page(struct rtw_dev *rtwdev)
-- 
2.34.1

