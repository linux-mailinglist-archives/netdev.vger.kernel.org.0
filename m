Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF6E480D43
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237465AbhL1VPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237409AbhL1VP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:26 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707D5C061747;
        Tue, 28 Dec 2021 13:15:25 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s1so40554779wra.6;
        Tue, 28 Dec 2021 13:15:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qYRAJooeejsLElKVR8lduV1KN6qXlfQTHsLzXUd3d6g=;
        b=De5Lu8bqh0J4nFPh1J69zRiHeEeBM2ppK6xezxClAjS6uLL4Y60F3uW64i1SnSazIJ
         aRxe3+1yiVtrHxsP+NEDWJrFME3yxqrblgn7cfBWLlb7mTwElERwknrpIs3LWn0FRiqE
         kndJDA3VzRwYZxTZoKDeX7LpE3LwGnUV8VQfl2O/DPN6tqqvr1qPsN1qtsnSxedtfKyw
         5kB1y3ZpXYm4l7wK5RSVQ9IOb+AzisBzsj57paOjSudnbCFH18T9WWBE3SSRHHzoiRE6
         v5a8xnX6wkjQOUKtg/4e/JRnDfYpUTM+aJwJ4NqlomIJhv+K0AvjdsSxHTE55TclpU+F
         OFsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qYRAJooeejsLElKVR8lduV1KN6qXlfQTHsLzXUd3d6g=;
        b=CHRtvOUu3eEYY3rslp2Y1oacnudrsPWgEWddUMARQTpYmHhLVXNRC6tOKHVyiBDa0Q
         nKg/7wuKrqW6zDm4N6lrnn2hSmqvqcX59lH8F3rJZIe1ld4ETyNmkyPB9XAIuyUY00tz
         8R9W8LADGUI8aEFkEH9Jbq2hQdPxUno5o1zaKaK+V9qlozrq8zRzuJMjGqV9DYocJj+v
         W2NitDB3Sc9hazDE3PQRLxN0x+E+g4rcNOotXfAlvj98BykpzL3IYqWEebTCadioYp6E
         XIjK79sphdqC3ejHwHXhN5wksQSG6CG6WocSoEovRACC2yAKr6I3DG3yxVqxWZ7cwwNR
         7eHw==
X-Gm-Message-State: AOAM533uZRZS2iv/J7S5UpPqDU1cttoyFpE0pOwsE9oErrhYa42uytj2
        kS7skUngBwd8wMdF3d+1R5shWY900D0=
X-Google-Smtp-Source: ABdhPJwoVqHyw+Vr0+/djiZypcuQw8B+dO5JU0Cud6lQWCXyu7oUiPSB1gjR2+g36JWYa/FefvvpBQ==
X-Received: by 2002:a5d:59a6:: with SMTP id p6mr17447028wrr.559.1640726123719;
        Tue, 28 Dec 2021 13:15:23 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:23 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 6/9] rtw88: Replace usage of rtw_iterate_keys_rcu() with rtw_iterate_keys()
Date:   Tue, 28 Dec 2021 22:14:58 +0100
Message-Id: <20211228211501.468981-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
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

