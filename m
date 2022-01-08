Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36242488037
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbiAHA4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiAHAzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:55 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F805C06173E;
        Fri,  7 Jan 2022 16:55:54 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id w20so14097544wra.9;
        Fri, 07 Jan 2022 16:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qYRAJooeejsLElKVR8lduV1KN6qXlfQTHsLzXUd3d6g=;
        b=ouxrwHpNjIGM+LMQA2WDKhHbWEPuw92qkfHyFDK3qYXt2dB3mKCsqTwbt9l9nNNmtu
         XCLZDlW0yzOYAapvXNBgS3d0fvZLLiPkEP2t+CvNv43PRrWFEePtraVKqOaA193YazrZ
         JBiVwsADnRVi31c4aeBpmkW0XDRv346tN1g0tX8fzpXssrO3kmLDB2mkzO1VR7FeKUae
         pxI/mRrLl7FjN1b9va9guxgMjMW/sUf5KlJlhffPFlI8B/bTD2rOM5dlerImS3/OD+P3
         L+vg4a0PjBEF2MbanOPRzsrcYA6lnzPWI2IIEfjsSjX7d433SBQfxSc2kKZdI7N7WFic
         gxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYRAJooeejsLElKVR8lduV1KN6qXlfQTHsLzXUd3d6g=;
        b=pW6ucCA839am10YcJL7zgTVmKvfTfWdiJ45c7zwHA5VC0vK9Q3Eacbzcx7m2qhNo0y
         8dB6WO3onbfJTs3oGu9UsQVkA049L1J3CPHbMMyDWAN8wZuy1ubvrrma5IPa0UEQt8Bl
         tYkbC3DXJTWKuAve42599xIk2PUTelHEJUarMbKgZEV6geetV4bjbpcVKhLWRYkDEyaU
         Vwam++S/rCJcF/ski59mJM48IHfDcui25noZ07nLgjH0iCHKQErwMcA+E05vn++DmXXr
         qR0//iflozBsiwvq/eQ4wc3PesdYBr6Ona8dSW7SaDDtJ4CntgJcTCVqomE08hErYGsU
         IRbw==
X-Gm-Message-State: AOAM533MtsZYWUkOiBQKKhhzE2CzkQn8IWjef8EEfSz/iRE0LBwl24rV
        5LbQzdkqoZlGFYy1T4sQiBdOnUhyZc4=
X-Google-Smtp-Source: ABdhPJwJJ13t6pOnsUqETHnSbhHtqaSiPpIlTgAEf9at9sLUTTzkciB0CMZyZf5hOYHbRZMkwlFV4w==
X-Received: by 2002:a5d:64a7:: with SMTP id m7mr55004041wrp.687.1641603353047;
        Fri, 07 Jan 2022 16:55:53 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.52
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
Subject: [PATCH v3 5/8] rtw88: Replace usage of rtw_iterate_keys_rcu() with rtw_iterate_keys()
Date:   Sat,  8 Jan 2022 01:55:30 +0100
Message-Id: <20220108005533.947787-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. The only
occurrence of rtw_iterate_keys_rcu() reads and writes registers from
it's iterator function. Replace it with rtw_iterate_keys() (the non-RCU
version). This will prevent an "scheduling while atomic" issue when
using an SDIO device.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 +---
 drivers/net/wireless/realtek/rtw88/util.h | 2 --
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 4b28c81b3ca0..3d4257e0367a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -581,9 +581,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 
 	WARN(1, "firmware crash, start reset and recover\n");
 
-	rcu_read_lock();
-	rtw_iterate_keys_rcu(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
-	rcu_read_unlock();
+	rtw_iterate_keys(rtwdev, NULL, rtw_reset_key_iter, rtwdev);
 	rtw_iterate_stas(rtwdev, rtw_reset_sta_iter, rtwdev);
 	rtw_iterate_vifs(rtwdev, rtw_reset_vif_iter, rtwdev);
 	rtw_enter_ips(rtwdev);
diff --git a/drivers/net/wireless/realtek/rtw88/util.h b/drivers/net/wireless/realtek/rtw88/util.h
index b0dfadf8b82a..06a5b4c4111c 100644
--- a/drivers/net/wireless/realtek/rtw88/util.h
+++ b/drivers/net/wireless/realtek/rtw88/util.h
@@ -19,8 +19,6 @@ struct rtw_dev;
 	ieee80211_iterate_stations_atomic(rtwdev->hw, iterator, data)
 #define rtw_iterate_keys(rtwdev, vif, iterator, data)			       \
 	ieee80211_iter_keys(rtwdev->hw, vif, iterator, data)
-#define rtw_iterate_keys_rcu(rtwdev, vif, iterator, data)		       \
-	ieee80211_iter_keys_rcu((rtwdev)->hw, vif, iterator, data)
 
 static inline u8 *get_hdr_bssid(struct ieee80211_hdr *hdr)
 {
-- 
2.34.1

