Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122B93CC647
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhGQUoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbhGQUoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:10 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2803C061764;
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m11-20020a05600c3b0bb0290228f19cb433so10284515wms.0;
        Sat, 17 Jul 2021 13:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ub1HsGiuNnybNJs5WdbxXtwzsH2TKD1etrBmG16trf8=;
        b=CiZLuaEdJVvFa3WM66L6CR/35+LZUZSrfCevHyRoEkFnH4KdzSFrXdeZME8n1yc+hV
         RWZOVc4gC05SyYNN2QbkyjWayfDHAs5wSEeoiq+GFrXEz/RvNyTqtSoLC92y5m77nmcA
         7nxU2jrSov5688YJpZN82LlneC+NJZT59kD5dQs5mHMeV2abb2WGsPEm1cCAdhUzKqKA
         Tee1TBflos3ZLu5nZ4NBrYLHkxyAWtVUfJgqTSNmD3/EeDB3o6pCQoPaYs21udFGpqYF
         vshwB300xpelsyW+Cd3Ovusvt7YsE51YJd3HC71a8L1IaqncV/X0PUNr/nH3rxYBaiY/
         U43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ub1HsGiuNnybNJs5WdbxXtwzsH2TKD1etrBmG16trf8=;
        b=cSlShcee4xS7M/O7m/thg9WyfjOPsuogCfaMxxGpuRKhssBibNBBojoIQN7tUGoz0D
         s05POUaBmmYWqJzLiw3AMIn1P5Aq/FP6kpdmRfKQkZ9K2aFn3G7G+rlhM+A3lBgplTNt
         QCubH8HfOFWLFQu9GO0t9wgfmWWc3OUfGDhEtG3OWrKXaHGxZi1lbdWtByVCnGyptF4H
         QyZ3vRACAO9L6LRxV4nO8s12EKaxR7Ru2jJOZdvu9DrIRM1a5lOKNsUxHMqbzsrK6SrH
         vs36gQG7N+5XZSK7fztLtK4MCtgmrlq7RWjQvFYZCDcBq9iv5tGN+7jxFwZIZsqMNFV3
         tDCA==
X-Gm-Message-State: AOAM532Y33T4Ly657F2/hxSC5Emm1WxjbB//HbN+CKdz9n7d9r7J3lY2
        kZTFKRAZcUrPmX4MuGNPhon/LheKydw=
X-Google-Smtp-Source: ABdhPJwuLk7/VOAal/tp1Jo2xRjrL13P75si/BZkcu4Ws2qee0BmuGxZO349GBQxWxVvwWo1HMC66A==
X-Received: by 2002:a05:600c:246:: with SMTP id 6mr21335374wmj.143.1626554471334;
        Sat, 17 Jul 2021 13:41:11 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:10 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 1/7] mac80211: Add stations iterator where the iterator function may sleep
Date:   Sat, 17 Jul 2021 22:40:51 +0200
Message-Id: <20210717204057.67495-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
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
 include/net/mac80211.h | 18 ++++++++++++++++++
 net/mac80211/util.c    | 13 +++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d8a1d09a2141..77de89690008 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5575,6 +5575,24 @@ void ieee80211_iterate_active_interfaces_mtx(struct ieee80211_hw *hw,
 						struct ieee80211_vif *vif),
 					     void *data);
 
+/**
+ * ieee80211_iterate_stations_atomic - iterate stations
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
index 05e96212b104..c6984d0464f2 100644
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
2.32.0

