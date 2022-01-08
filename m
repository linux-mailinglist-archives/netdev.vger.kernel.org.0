Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23307488025
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbiAHAz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiAHAzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:54 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE664C061747;
        Fri,  7 Jan 2022 16:55:53 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id q8so14046332wra.12;
        Fri, 07 Jan 2022 16:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VjfR3K+5JgkYbWpldO+nZERSdwRbxL2f2Vl4DU5yMWU=;
        b=neBFGG+X9YesGNyfLHBpb2KYn79YN6bSuanrNB4rumB3UROf7cYPXUURMwpmTAMYC5
         ae/1WRuJDo0vNq5R5mSTF55AOJicQmNrUtFUzsHOba1aGlaOKmftPCCMEGJhScx4N+K9
         EBY90qr+zD3AorGqPZmRec0RyXQ25SHa1xvrKbduWwu4FIUWvsCjhMZWjQNSJBeXoBgF
         mz+Vmr85vX4Zul/yUW7hHQ+mP69Ac63nD92c4/xCOvVt/Pzg/GJ/NtUR/Ye2y0yyuTPq
         s4RBfe24wwmtoPxvKIuwCd7i9bs7YCHPZBpkvKzy/mjSyRf/+/29rQ/5aAFC0AqIsJMN
         zmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VjfR3K+5JgkYbWpldO+nZERSdwRbxL2f2Vl4DU5yMWU=;
        b=IfOU0uJJbpy/XyZ64LdC7nejUdDA7BvlJYqEBF8x3ZQhsVAurhj+YRAQfA6ReHeqr2
         rNcE0aiZVnMcfl2PNmY0z5o1hgqL6/4ZTatf6ev6kxG5bzNKh/qt8ZMA9kcrh6akbfLD
         YrN+E2LJIR5m/nnwCG0LcTlftRqWdCFa6bwg2TwDaFd1XM2aQVJ3aZQlmvbyY4f2LQGL
         KbjxjQs9F8gR5H/MyK3qvMfiB31vL30o99JZw6XQwfyv6r7XdchejQFSfk6ssSq75M33
         OIR3Bi+6v+mzFB1B6kxRV0eteLuMDp3xoiX5zaCKz+YkHpqNds7E0/yYIVqNwLOYqyp8
         +q+g==
X-Gm-Message-State: AOAM532i0umXENkKqbK7jBYAdbsxkUKuZ6kOBqQ0CIYR92YlydYTUMhf
        iYeVLB5DNo8+Zhbk2IZLnPPjZUhDo68=
X-Google-Smtp-Source: ABdhPJyXQOnSc9UKWlhOKczv6rtXjetQ8Xtch38MBm8uGq1edT1IOdp56d9sCGloQlSB/wOeyiJ3vg==
X-Received: by 2002:a5d:5909:: with SMTP id v9mr1647819wrd.680.1641603352255;
        Fri, 07 Jan 2022 16:55:52 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:52 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 4/8] rtw88: Use rtw_iterate_stas where the iterator reads or writes registers
Date:   Sat,  8 Jan 2022 01:55:29 +0100
Message-Id: <20220108005533.947787-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
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

