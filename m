Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B71D480D38
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237397AbhL1VPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbhL1VPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:21 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF85C061574;
        Tue, 28 Dec 2021 13:15:21 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id b186-20020a1c1bc3000000b00345734afe78so10744336wmb.0;
        Tue, 28 Dec 2021 13:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SEMbs8uawFQ22g6pe5+yochD9fdd3KiYBmK2xcx9DT0=;
        b=OBJtompVYgj2tIy1ENvuYYRwZTT/I9of98emtNzcJE2Z0bc+u2dHTX7IwrD2Igxaq8
         ZhQPLEE3gE+7RRzbncDF6LKeuJFs2ZslxzQw75HgFpOGpLBpeXNBkrmKbpU7MSVRFcoR
         I9cSjlgIh0s2FTMn8gahEGjbkM8a99wEUmkk16Ic2eAgpmB05aiC5SZl3H7XhnfYM4qQ
         Xy2XZtEAYp/ElqECmDdPhAvVb/HoQifpxG3qV2y7tTldRqoG5tiGhhAm1TmAPCr2RpBk
         Ztjfqq+2bnshnB4DmN4vgMvwvwqZruu46KGTytfuKXJwCbXc5ORUYCC4iSgAHq5do8yG
         g1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SEMbs8uawFQ22g6pe5+yochD9fdd3KiYBmK2xcx9DT0=;
        b=xuhA6G64MvtiCgZKv15O0yccjBf7DK1rzyKTrUskxsUqByj7vsUsACRi50M84W7wRS
         nNA7bJaC+m/AO+zEz5YWZeasmaTDorphbJkgzMr5WQ7VIokfgN0wAr7ZA2ASzEMIItix
         OADfXmp1Lrt1LP8LKwrHwJTAw71NUNRhMJfRo3XdIQUkssqm4+wnqBNuRCYJBTUpZICM
         UedRWVfHh6zzN06/fHgLYRTVgNYRGXTWs0fx0iLEu04FRH9bf72HLyBc5jsb1gf7mC/0
         Em+n7NkkJ/tA9bX2v0aFW5mKiEx4VzdHHjH/a97HiwVTWPFwDSLbq7Irz+24BiHq481A
         WRWA==
X-Gm-Message-State: AOAM532q1aM7/OU8MIwGGxa5B/8bXvwpXdB1SQLNwCw3ovDE9XokiINI
        vGISlGamaJMqnH2Bq2Vn0kRg6ECd9pk=
X-Google-Smtp-Source: ABdhPJwtZrewBBGpSnxq9D2Flyk9gtz7au9JRe7U0I1v7bEqPXPOk9C14Uftz8XD8+zDe3Z1fip7Aw==
X-Received: by 2002:a7b:c00d:: with SMTP id c13mr6913816wmb.99.1640726119608;
        Tue, 28 Dec 2021 13:15:19 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:19 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/9] mac80211: Add stations iterator where the iterator function may sleep
Date:   Tue, 28 Dec 2021 22:14:53 +0100
Message-Id: <20211228211501.468981-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_iterate_active_interfaces() and
ieee80211_iterate_active_interfaces_atomic() already exist, where the
former allows the iterator function to sleep. Add
ieee80211_iterate_stations() which is similar to
ieee80211_iterate_stations_atomic() but allows the iterator to sleep.
This is needed for adding SDIO support to the rtw88 driver. Some
interators there are reading or writing registers. With the SDIO ops
(sdio_readb, sdio_writeb and friends) this means that the iterator
function may sleep.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- fixed kernel doc copy & paste (remove _atomic) as suggested by Ping-Ke
  and Johannes
- added paragraph about driver authors having to be careful where they
  use this new function as suggested by Johannes

 include/net/mac80211.h | 21 +++++++++++++++++++++
 net/mac80211/util.c    | 13 +++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8907338d52b5..c50221d7e82c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5614,6 +5614,9 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
  * This version can only be used while holding the wiphy mutex.
+ * The driver must not call this with a lock held that it can also take in
+ * response to callbacks from mac80211, and it must not call this within
+ * callbacks made by mac80211 - both would result in deadlocks.
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
  * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
@@ -5627,6 +5630,24 @@ void ieee80211_iterate_active_interfaces_mtx(struct ieee80211_hw *hw,
 						struct ieee80211_vif *vif),
 					     void *data);
 
+/**
+ * ieee80211_iterate_stations - iterate stations
+ *
+ * This function iterates over all stations associated with a given
+ * hardware that are currently uploaded to the driver and calls the callback
+ * function for them.
+ * This function allows the iterator function to sleep, when the iterator
+ * function is atomic @ieee80211_iterate_stations_atomic can be used.
+ *
+ * @hw: the hardware struct of which the interfaces should be iterated over
+ * @iterator: the iterator function to call, cannot sleep
+ * @data: first argument of the iterator function
+ */
+void ieee80211_iterate_stations(struct ieee80211_hw *hw,
+				void (*iterator)(void *data,
+						 struct ieee80211_sta *sta),
+				void *data);
+
 /**
  * ieee80211_iterate_stations_atomic - iterate stations
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0e4e1956bcea..f71b042a5c8b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -862,6 +862,19 @@ static void __iterate_stations(struct ieee80211_local *local,
 	}
 }
 
+void ieee80211_iterate_stations(struct ieee80211_hw *hw,
+				void (*iterator)(void *data,
+						 struct ieee80211_sta *sta),
+				void *data)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	mutex_lock(&local->sta_mtx);
+	__iterate_stations(local, iterator, data);
+	mutex_unlock(&local->sta_mtx);
+}
+EXPORT_SYMBOL_GPL(ieee80211_iterate_stations);
+
 void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
 			void (*iterator)(void *data,
 					 struct ieee80211_sta *sta),
-- 
2.34.1

