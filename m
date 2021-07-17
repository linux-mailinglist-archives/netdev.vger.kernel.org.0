Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BE53CC650
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbhGQUoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbhGQUoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:13 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AEEFC061762;
        Sat, 17 Jul 2021 13:41:15 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id v5so16221236wrt.3;
        Sat, 17 Jul 2021 13:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uk0gQtyHe+7seTs9c47Ts/miKfxRiB6TKSQHr8dMLFs=;
        b=PaSgDAONVjZRZ8egE8bl4q9kszRYtLcpEPCaq4ebtf++SsgdHXQjZ0TdwifKjku80s
         NUeqYMPyG9bFm/2mE4NFZdM/BGqN7MrTGUe5C2HVHg4hmfscZkMcCxjv/O/9bteWaSQG
         2CmJ4qyKJJm9x0L5/xlZIrL1vKMzxLQO0AIadd5NSScqybX/0G6W0tD1rorJlw5Dm43f
         NVrFaZS8uCqXd+8UG0v82CwtuTaUbQxXg0jiTqQr+1XB1iDAV/bEvbcI4u+5Be8trKLK
         GD1umNt81Cr1q3WdVnlcnyv40eL8PW9x/WkBe0jTvZjQv6YBmXAXbXpMa2Pu1Vj72Vma
         5+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uk0gQtyHe+7seTs9c47Ts/miKfxRiB6TKSQHr8dMLFs=;
        b=mSt5meGbfaopN+wr9frGsxJ5zVaVTJLpqdd23040rOXRzNrIQ73a3wtfJBVUahlIrN
         s6k4Obl6U2ORAtQ78OR7VCKiKK1D1CvEsojGSu4OqK15+irGyWSsf6cvH1oBkYNqEyyu
         8ojxCk7OWElKs64cwbwgMi3b3c8JN7XtNgINz462XP42j9VVYm68MhXVGx8cAdutNGag
         wtqXIKpbwYII9jlcfr4agE+c9EiAZOVyt/3F33oY398A1rlcTc0ZfSFPFyl7XwEs/+o9
         F6+rwT8eQ1wswo0iMm0XPClHtYAu0um+95LRBleDb9Rt3ruo2v+3gfSFj0p37pk5Sr+e
         3oCA==
X-Gm-Message-State: AOAM5337gsWNws9ltObdicxNjvOURDj++wWWw1GQrIsvhucUZ743rHur
        7q1b20q5HooU6jhzGpDTuVPUdl+yHYY=
X-Google-Smtp-Source: ABdhPJzuO8mojLgo0pHNtVhw4KS7FjmYW13zBLHNuoWZiI56hqh709Rw4RKei+w3Qr8wmUc0WdbHhQ==
X-Received: by 2002:a05:6000:231:: with SMTP id l17mr21054508wrz.40.1626554473554;
        Sat, 17 Jul 2021 13:41:13 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the iterator reads or writes registers
Date:   Sat, 17 Jul 2021 22:40:53 +0200
Message-Id: <20210717204057.67495-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
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
 drivers/net/wireless/realtek/rtw88/mac80211.c | 2 +-
 drivers/net/wireless/realtek/rtw88/main.c     | 2 +-
 drivers/net/wireless/realtek/rtw88/phy.c      | 4 ++--
 drivers/net/wireless/realtek/rtw88/util.h     | 2 ++
 drivers/net/wireless/realtek/rtw88/wow.c      | 2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 6f5629852416..7650a1ca0e9e 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -721,7 +721,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
 	br_data.rtwdev = rtwdev;
 	br_data.vif = vif;
 	br_data.mask = mask;
-	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
+	rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
 }
 
 static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 207161a8f5bd..6e0d25f0afe3 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -577,7 +577,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 	rcu_read_lock();
 	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rcu_read_unlock();
-	rtw_iterate_stas_atomic(rtwdev, rtw_reset_sta_iter, rtwdev);
+	rtw_iterate_stas(rtwdev, rtw_reset_sta_iter, rtwdev);
 	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
 }
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 569dd3cfde35..8f2827ecb514 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -240,7 +240,7 @@ static void rtw_phy_stat_rssi(struct rtw_dev *rtwdev)
 
 	data.rtwdev = rtwdev;
 	data.min_rssi = U8_MAX;
-	rtw_iterate_stas_atomic(rtwdev, rtw_phy_stat_rssi_iter, &data);
+	rtw_iterate_stas(rtwdev, rtw_phy_stat_rssi_iter, &data);
 
 	dm_info->pre_min_rssi = dm_info->min_rssi;
 	dm_info->min_rssi = data.min_rssi;
@@ -484,7 +484,7 @@ static void rtw_phy_ra_info_update(struct rtw_dev *rtwdev)
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
index fc9544f4e5e4..9c4050d4c6e2 100644
--- a/drivers/net/wireless/realtek/rtw88/wow.c
+++ b/drivers/net/wireless/realtek/rtw88/wow.c
@@ -429,7 +429,7 @@ static void rtw_wow_fw_media_status(struct rtw_dev *rtwdev, bool connect)
 	data.rtwdev = rtwdev;
 	data.connect = connect;
 
-	rtw_iterate_stas_atomic(rtwdev, rtw_wow_fw_media_status_iter, &data);
+	rtw_iterate_stas(rtwdev, rtw_wow_fw_media_status_iter, &data);
 }
 
 static void rtw_wow_config_pno_rsvd_page(struct rtw_dev *rtwdev,
-- 
2.32.0

