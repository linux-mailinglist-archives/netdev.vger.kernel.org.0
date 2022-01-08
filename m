Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4400C488031
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbiAHA4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:56:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiAHAz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:57 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D2BC061574;
        Fri,  7 Jan 2022 16:55:52 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id q141-20020a1ca793000000b00347b48dfb53so1710421wme.0;
        Fri, 07 Jan 2022 16:55:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2BBiJK+vS1/gHZOpEVh75sXuwr7uHfwhlz6gLC5Y4fk=;
        b=ov+SeYoFKF7GwX1DMo3u9dM0K519aaRLK0MPLkLsOP6HC8qdyOT94GtSm9wvTLaxGi
         RaEgNPDZ8zJ3HIzmSeN7cNu4JsqInONvLlBIpo2kcjYXBg1eX/4/MOhdHDPZgYw7fYSm
         KfdzIqheiw7t2dqIABxaBgUbWZ9FC3SfVub0u/69jbTBvVWdz3rUvYHX1PBt5dGZRufP
         BSy8cMOwHbRH8MzEQXd+wYn28v+CP5asL4Pfr1XdVzDuzPyDF2dWYmKOJwMTDoWBibhx
         H1eTf9Pq8vRah6XcKvJCS/OV/uPvUiGIeezbTBKxsknxhic7wsg4x9GBDOy5f3ifwIZt
         9U9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2BBiJK+vS1/gHZOpEVh75sXuwr7uHfwhlz6gLC5Y4fk=;
        b=u7RHQSYTApeXPNmkS9tBdgzKTxDklBHlKyDkzquDa9IuoGoMQaHiHXNC7hZHNQfsPE
         yloAEs2fsly9R8CcCT8oUZnmM4oIRIZEjQ5XridKIHmDafF0G4zZhRt830wNy2jGMmfX
         2qKVjHqkBt9ljlwuzCBvaxrlx8Ejk5Nwf2YULD1prIIehj5BHqYptEsUEMl6SNoZZzf3
         I/DJfDKjCvWBKhB/KKna1XMe7T6NCezoyikGo/mXU9Ukk9Q3e62rT1VXtY5FLoa8j4Fj
         y9QCQNVoUkMwj5HXij50E2TCbH5pt/NZKlWSbKERxEyVGKueBQR6yHh3Dp0n0/KvO9EQ
         QvSA==
X-Gm-Message-State: AOAM533KKVg66trcCWOkK3pwtD0JgBIUTMOt7+KzVQVI6mWtVBg1Xv3q
        wsNQVESNFGUWzG0nIFJshuD1Ua5R8Ac=
X-Google-Smtp-Source: ABdhPJwZIJbOvGYLDaw04cBW+JDKkDZP2mOlxOSAn94bntIYLled0zZxYhthLsGzzm6H0tq7syM8NQ==
X-Received: by 2002:a7b:c101:: with SMTP id w1mr12550166wmi.149.1641603349939;
        Fri, 07 Jan 2022 16:55:49 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:49 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 1/8] rtw88: Move rtw_chip_cfg_csi_rate() out of rtw_vif_watch_dog_iter()
Date:   Sat,  8 Jan 2022 01:55:26 +0100
Message-Id: <20220108005533.947787-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtw_bf_cfg_csi_rate() internally access some registers while being
called unter an atomic lock acquired by rtw_iterate_vifs_atomic(). Move
the rtw_bf_cfg_csi_rate() call out of rtw_vif_watch_dog_iter() in
preparation for SDIO support where register access may sleep.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v2 -> v3:
- no changes

v1 -> v2:
- keep rtw_iterate_vifs_atomic() to not undo the fix from commit
  5b0efb4d670c8 ("rtw88: avoid circular locking between
  local->iflist_mtx and rtwdev->mutex") and instead call
  rtw_bf_cfg_csi_rate() from rtw_watch_dog_work() (outside the atomic
  section) as suggested by Ping-Ke.

 drivers/net/wireless/realtek/rtw88/main.c | 35 +++++++++++------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 38252113c4a8..fd02c0b0025a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -144,26 +144,9 @@ static struct ieee80211_supported_band rtw_band_5ghz = {
 struct rtw_watch_dog_iter_data {
 	struct rtw_dev *rtwdev;
 	struct rtw_vif *rtwvif;
+	bool cfg_csi_rate;
 };
 
-static void rtw_dynamic_csi_rate(struct rtw_dev *rtwdev, struct rtw_vif *rtwvif)
-{
-	struct rtw_bf_info *bf_info = &rtwdev->bf_info;
-	u8 fix_rate_enable = 0;
-	u8 new_csi_rate_idx;
-
-	if (rtwvif->bfee.role != RTW_BFEE_SU &&
-	    rtwvif->bfee.role != RTW_BFEE_MU)
-		return;
-
-	rtw_chip_cfg_csi_rate(rtwdev, rtwdev->dm_info.min_rssi,
-			      bf_info->cur_csi_rpt_rate,
-			      fix_rate_enable, &new_csi_rate_idx);
-
-	if (new_csi_rate_idx != bf_info->cur_csi_rpt_rate)
-		bf_info->cur_csi_rpt_rate = new_csi_rate_idx;
-}
-
 static void rtw_vif_watch_dog_iter(void *data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
@@ -174,7 +157,8 @@ static void rtw_vif_watch_dog_iter(void *data, u8 *mac,
 		if (vif->bss_conf.assoc)
 			iter_data->rtwvif = rtwvif;
 
-	rtw_dynamic_csi_rate(iter_data->rtwdev, rtwvif);
+	iter_data->cfg_csi_rate = rtwvif->bfee.role == RTW_BFEE_SU ||
+				  rtwvif->bfee.role == RTW_BFEE_MU;
 
 	rtwvif->stats.tx_unicast = 0;
 	rtwvif->stats.rx_unicast = 0;
@@ -241,6 +225,19 @@ static void rtw_watch_dog_work(struct work_struct *work)
 	/* use atomic version to avoid taking local->iflist_mtx mutex */
 	rtw_iterate_vifs_atomic(rtwdev, rtw_vif_watch_dog_iter, &data);
 
+	if (data.cfg_csi_rate) {
+		struct rtw_bf_info *bf_info = &rtwdev->bf_info;
+		u8 fix_rate_enable = 0;
+		u8 new_csi_rate_idx;
+
+		rtw_chip_cfg_csi_rate(rtwdev, rtwdev->dm_info.min_rssi,
+				      bf_info->cur_csi_rpt_rate,
+				      fix_rate_enable, &new_csi_rate_idx);
+
+		if (new_csi_rate_idx != bf_info->cur_csi_rpt_rate)
+			bf_info->cur_csi_rpt_rate = new_csi_rate_idx;
+	}
+
 	/* fw supports only one station associated to enter lps, if there are
 	 * more than two stations associated to the AP, then we can not enter
 	 * lps, because fw does not handle the overlapped beacon interval
-- 
2.34.1

