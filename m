Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC81480D4E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbhL1VPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237367AbhL1VPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:24 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6908C061574;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id e5so40527217wrc.5;
        Tue, 28 Dec 2021 13:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RPdDDH0ZoLrX7SD+q/Kr9dA7YENi3S2V9HGa57eaoKA=;
        b=oOeYCXFZ+tMu+tR5R9YITWCDA2+VplpTi1FrIiiW/SrAOF0vwc5d1tQXUyQbCN7fOs
         JovjLjk/qpve+wyOnq76dd+ZC5mzi0E55pOPqr7HjxXWhDtPG28Jx5K4qhB/JUz4bqvW
         bk03VR5CXDGKcaXUC4UahDGIU++qU7kMPL3kzt6ogTEGW33e9c7SeN/1BTqTgl1Qkri3
         M9VvAlILnky72DHyKfpKm5AMJtu92KnGwRGC6nSzRfw03m9nYKiVYomSJGboc0InXUsE
         OElRebMDZv5xxQBhtppV3cQ4yYfLbuf87ygVdbZG2Fpxkh7cTea2EC0jKkdvxyP1UOX3
         AO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RPdDDH0ZoLrX7SD+q/Kr9dA7YENi3S2V9HGa57eaoKA=;
        b=1US1iXncGs6KCFIAZYwKHwAYFrgO/1hzb9Yrw5jNyjANl9CAw7C5FPZt+IkIuB2Qbg
         ARS7ENRgz8k6PUWxFn9sAhnqirYTW6FMKxDPKcRDmMJm9HEYt6Olnbnjj0ENknvpKMw1
         fZ8R0OaIsUmI83sEGBJZDO10cEtzB/1FmbybjRYfnS2rBz3NygYEEO8hb/rcITAwr8qC
         OScYJsd5w8q8tUKVH2nDsitGdoJ+t8Oqx0FQInQ7LGipWy9r4Lcqh7A+S/DdFDXdBT2e
         9IfrmMqU4GcshBcuL/SEtA7ZOX9aCWcpHakWhFq9+Dm/pTzbO7fDHg568wMaFUe0tdWm
         +U/g==
X-Gm-Message-State: AOAM531zII8S//2X9Vyp3F3x9+5TJdYNv4vUmpuQtFpCRyyUl4KGe0s6
        STfAVywoXTDMPFn1xTvWAuMfsW9Ljlw=
X-Google-Smtp-Source: ABdhPJw/Ly05NqdAUfexDEE4cR9abOLrzErk0Ft1rbt3KdVYN5tuOe5paFTUXnAYzwuAOgoSlBMHDA==
X-Received: by 2002:a5d:6d84:: with SMTP id l4mr18372539wrs.61.1640726121292;
        Tue, 28 Dec 2021 13:15:21 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:21 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 3/9] rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
Date:   Tue, 28 Dec 2021 22:14:55 +0100
Message-Id: <20211228211501.468981-4-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtw_update_sta_info() internally access some registers while being
called unter an atomic lock acquired by rtw_iterate_vifs_atomic(). Move
rtw_update_sta_info() call out of (rtw_ra_mask_info_update_iter) in
preparation for SDIO support where register access may sleep.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- this patch is new in v2
- keep rtw_iterate_vifs_atomic() to prevent deadlocks as Johannes
  suggested. Keep track of all relevant stations inside
  rtw_ra_mask_info_update_iter() and the iter-data and then call
  rtw_update_sta_info() while held under rtwdev->mutex instead

 drivers/net/wireless/realtek/rtw88/mac80211.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index ae7d97de5fdf..3bd12354a8a1 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -671,6 +671,8 @@ struct rtw_iter_bitrate_mask_data {
 	struct rtw_dev *rtwdev;
 	struct ieee80211_vif *vif;
 	const struct cfg80211_bitrate_mask *mask;
+	unsigned int num_si;
+	struct rtw_sta_info *si[RTW_MAX_MAC_ID_NUM];
 };
 
 static void rtw_ra_mask_info_update_iter(void *data, struct ieee80211_sta *sta)
@@ -691,7 +693,8 @@ static void rtw_ra_mask_info_update_iter(void *data, struct ieee80211_sta *sta)
 	}
 
 	si->use_cfg_mask = true;
-	rtw_update_sta_info(br_data->rtwdev, si);
+
+	br_data->si[br_data->num_si++] = si;
 }
 
 static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
@@ -699,11 +702,20 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
 				    const struct cfg80211_bitrate_mask *mask)
 {
 	struct rtw_iter_bitrate_mask_data br_data;
+	unsigned int i;
+
+	mutex_lock(&rtwdev->mutex);
 
 	br_data.rtwdev = rtwdev;
 	br_data.vif = vif;
 	br_data.mask = mask;
+	br_data.num_si = 0;
 	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
+
+	for (i = 0; i < br_data.num_si; i++)
+		rtw_update_sta_info(rtwdev, br_data.si[i]);
+
+	mutex_unlock(&rtwdev->mutex);
 }
 
 static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
-- 
2.34.1

