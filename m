Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC6488021
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiAHAzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiAHAzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:53 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6516BC06173E;
        Fri,  7 Jan 2022 16:55:52 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id e9so12619586wra.2;
        Fri, 07 Jan 2022 16:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGJ0LXsLLIKTbaK4tkiGLW7mPutZPDSZiPZw3eeKEBA=;
        b=XhxtoMa9eoBNh2JbJROXS4VuNzgPE7niSRI7qx8GgInFKNT5OoEzkGseVuBJBv4Ozh
         4X04jXh/ozTnZwjGESu1L3VxEySH0tn8tCRgErME2BfISuleBpyotF+LXOA3N2UmaPAf
         JGg0JBhlMrqwo9vvon1o0QygqhB4K32VkXUKvpOQPGQvp7cAbk/fQiL7Nf9eKTufjaaV
         2GL8z39NKmeqPM5mXhiKc/FDgQNBQFXTyoAPDbcwgIFcSjhYwN1gEVWl30Gny1lKxEat
         kNGZaglXd2e/sdUAeVflQsmWe7VBZx0LMZEqzN5gOix3g5JFPEWFRrlZSXUq6KB8JPlP
         CwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGJ0LXsLLIKTbaK4tkiGLW7mPutZPDSZiPZw3eeKEBA=;
        b=bItS3vrULtFiRn15F6FaaT3oEw/jHlVthy1Y8GPhJTypDpu112kLOPgEtoIfjaeuvd
         Ja+JkjZkzs+CXXBNsI8xAOAjIBqkVViczz1g8748mwnZrtI/ml2+RyCoAdWI4ItLlL3t
         WM9KR548m1ad05gaiBfol7Q3iNsZm6SQVzaTYbgXNYPdR/pI+UT9kNWNZ0ttu0Sdc/nQ
         yc5mnuOPN7K/HWpaSmli3cpTAbuRVUwAzMP5vOkPLqjMBF9umqk4jRnEyh3GezjfedLD
         /KBhaJmiHmCsrO5pCokVF0Zxeb4BVA8BapbcDy8rfY3BIsppvDBFpy4ddkDY7aZmYvLO
         2TwQ==
X-Gm-Message-State: AOAM5306o0GCJLzmNJK86ZC1ULxJbj6GE2lWmPMbRUSfaJBoTNDarCK+
        1WkN430yXgosggN7gBZj3Ls7BpAZW/E=
X-Google-Smtp-Source: ABdhPJzsIN8WaB1582oTDhjA6IretFkFj1KAvY3dnbLbHJoWCMXAj7Gr08X8ccnlJwpEuWmPMUW/2w==
X-Received: by 2002:a5d:5090:: with SMTP id a16mr9493872wrt.259.1641603350697;
        Fri, 07 Jan 2022 16:55:50 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:50 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 2/8] rtw88: Move rtw_update_sta_info() out of rtw_ra_mask_info_update_iter()
Date:   Sat,  8 Jan 2022 01:55:27 +0100
Message-Id: <20220108005533.947787-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
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
v2 -> v3:
- Move the mutex lock (to protect the dta inside br_data.si[i]) to
  rtw_ops_set_bitrate_mask() for consistency with other functions in
  the whole driver (and especially in the same file) as suggested by
  Ping-Ke (thank you!)

v1 -> v2:
- keep rtw_iterate_vifs_atomic() to prevent deadlocks as Johannes
  suggested. Keep track of all relevant stations inside
  rtw_ra_mask_info_update_iter() and the iter-data and then call
  rtw_update_sta_info() while held under rtwdev->mutex instead

 drivers/net/wireless/realtek/rtw88/mac80211.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index ae7d97de5fdf..78e963fcc6e1 100644
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
@@ -699,11 +702,16 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
 				    const struct cfg80211_bitrate_mask *mask)
 {
 	struct rtw_iter_bitrate_mask_data br_data;
+	unsigned int i;
 
 	br_data.rtwdev = rtwdev;
 	br_data.vif = vif;
 	br_data.mask = mask;
+	br_data.num_si = 0;
 	rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
+
+	for (i = 0; i < br_data.num_si; i++)
+		rtw_update_sta_info(rtwdev, br_data.si[i]);
 }
 
 static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
@@ -712,7 +720,9 @@ static int rtw_ops_set_bitrate_mask(struct ieee80211_hw *hw,
 {
 	struct rtw_dev *rtwdev = hw->priv;
 
+	mutex_lock(&rtwdev->mutex);
 	rtw_ra_mask_info_update(rtwdev, vif, mask);
+	mutex_unlock(&rtwdev->mutex);
 
 	return 0;
 }
-- 
2.34.1

