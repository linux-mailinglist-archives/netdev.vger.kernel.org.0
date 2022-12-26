Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06536564C4
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 20:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbiLZTQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 14:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLZTQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 14:16:27 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9E0E1F;
        Mon, 26 Dec 2022 11:16:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id kw15so27506959ejc.10;
        Mon, 26 Dec 2022 11:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2ktegGSSkOxqIFuwhGHmtZ6WhTHs3PairIl7GArHTdQ=;
        b=WxBgfmx/IwkWtSjVIku2yMAWQ0NkWyJzPzt7iYPtmClzE8skyen0tBRFjGPBWydRSQ
         JUEwFhT0JgMT2lf2CkG35mVj9clPZPUlEDdyZAxZ2dvyRs6orYqjnfeRAjUK126mOetd
         H+EAQRkwHBQ+NZbJCIepOW1hF9ovSMe3h19JPcwklAEJklGb7NmzylVsHLJMdEIY0iU0
         LTPzFEWh6TY8Mkd5H1CvxyUabUqrmBG+E9Rr2UPfIhCroIfW1rvSroSk0dlDp34b0DYx
         bpAbNg8yy7bjAgjZAiEYdC7x/uqY0VZ5gTvc5fJEPQ8Pl94fe4PrbUdtR0jt6Gu2yifR
         goVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2ktegGSSkOxqIFuwhGHmtZ6WhTHs3PairIl7GArHTdQ=;
        b=fmd0PX5mvZjjSO6HKAUpqr4JJkFMuX2JOxWFfo0qV4cK97dIqLT3UoVvRK/5F4o6eC
         T56Ro6LnGnz4Fxbh+JUTdnvCgeJvTAOjZoyCtF4yRujXQXhD/xSbzUhbrkVKeTr3oI3Z
         7B9yajRBKQXGNmDw/eJWeAWrZWuCkp/2IaaFDDTgelwaSSjpUmPM2lFjlQQHnlQTViVK
         GB+DxLJ/cy+RWgN8vstXsqPIVjY3lC9uJQxX0m4eulEXZ8CCHnQC8tUM1B3vqNfkeLKC
         P1at0kjr0IbYjY3kLlvsc6WpG/nl3WQ4Pd+uuh34wFgeMe5WMUrjox3TE0xepNnQOruf
         Vjiw==
X-Gm-Message-State: AFqh2kqBW94BnBgoqrW/GKEL95ZhxUzSDLaOptWVKN/wilU4BrA5h9Yy
        RP2eKn3BoPoEcKSDR3wY5w8L2ajDUR8=
X-Google-Smtp-Source: AMrXdXusUJQ+D0KmgNnXGBKiQrL8JCdhgnRj0835vNO/Rgx/BscxViE5TiF0n0WYZysxT6n4E/9l1g==
X-Received: by 2002:a17:906:b053:b0:7ad:ca80:5669 with SMTP id bj19-20020a170906b05300b007adca805669mr20703141ejb.64.1672082184609;
        Mon, 26 Dec 2022 11:16:24 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c42e-1300-0000-0000-0000-0e63.c23.pool.telefonica.de. [2a01:c23:c42e:1300::e63])
        by smtp.googlemail.com with ESMTPSA id p18-20020a170906141200b007c08091ad7esm5079673ejc.208.2022.12.26.11.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Dec 2022 11:16:24 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] mac80211: Drop stations iterator where the iterator function may sleep
Date:   Mon, 26 Dec 2022 20:16:09 +0100
Message-Id: <20221226191609.2934234-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit acb99b9b2a08f ("mac80211: Add stations iterator
where the iterator function may sleep"). A different approach was found
for the rtw88 driver where most of the problematic locks were converted
to a driver-local mutex. Drop ieee80211_iterate_stations() because there
are no users of that function.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 include/net/mac80211.h | 21 ---------------------
 net/mac80211/util.c    | 13 -------------
 2 files changed, 34 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 689da327ce2e..b421a1bfc7c5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -5888,9 +5888,6 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
  * This function iterates over the interfaces associated with a given
  * hardware that are currently active and calls the callback for them.
  * This version can only be used while holding the wiphy mutex.
- * The driver must not call this with a lock held that it can also take in
- * response to callbacks from mac80211, and it must not call this within
- * callbacks made by mac80211 - both would result in deadlocks.
  *
  * @hw: the hardware struct of which the interfaces should be iterated over
  * @iter_flags: iteration flags, see &enum ieee80211_interface_iteration_flags
@@ -5904,24 +5901,6 @@ void ieee80211_iterate_active_interfaces_mtx(struct ieee80211_hw *hw,
 						struct ieee80211_vif *vif),
 					     void *data);
 
-/**
- * ieee80211_iterate_stations - iterate stations
- *
- * This function iterates over all stations associated with a given
- * hardware that are currently uploaded to the driver and calls the callback
- * function for them.
- * This function allows the iterator function to sleep, when the iterator
- * function is atomic @ieee80211_iterate_stations_atomic can be used.
- *
- * @hw: the hardware struct of which the interfaces should be iterated over
- * @iterator: the iterator function to call, cannot sleep
- * @data: first argument of the iterator function
- */
-void ieee80211_iterate_stations(struct ieee80211_hw *hw,
-				void (*iterator)(void *data,
-						 struct ieee80211_sta *sta),
-				void *data);
-
 /**
  * ieee80211_iterate_stations_atomic - iterate stations
  *
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6f5407038459..bc8c285355a1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -868,19 +868,6 @@ static void __iterate_stations(struct ieee80211_local *local,
 	}
 }
 
-void ieee80211_iterate_stations(struct ieee80211_hw *hw,
-				void (*iterator)(void *data,
-						 struct ieee80211_sta *sta),
-				void *data)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	mutex_lock(&local->sta_mtx);
-	__iterate_stations(local, iterator, data);
-	mutex_unlock(&local->sta_mtx);
-}
-EXPORT_SYMBOL_GPL(ieee80211_iterate_stations);
-
 void ieee80211_iterate_stations_atomic(struct ieee80211_hw *hw,
 			void (*iterator)(void *data,
 					 struct ieee80211_sta *sta),
-- 
2.39.0

