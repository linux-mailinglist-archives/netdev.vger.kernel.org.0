Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCE93CC653
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbhGQUoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235614AbhGQUoO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:14 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1E1C061764;
        Sat, 17 Jul 2021 13:41:16 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b14-20020a1c1b0e0000b02901fc3a62af78so10258895wmb.3;
        Sat, 17 Jul 2021 13:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dhCvrW6VDzVeJLnbwvW9u01I7iypqs1UknLeEWPJNXk=;
        b=l3WLbYi8AwPUrAcxJ2L8LNl5UV1hhGlfUCqZVZk5ip+NgRprX8CPtkvcgifEQrnTnW
         eHpfnEa2cDBuU3zb912a40lJtK+sHb4ARAsAZnao+f74m+zXgob5DG3ZHyAoqt9UJglW
         c5FfsdcHtk80AI/oY0+nKZXEYDlFSnJ/AXnyDi/nmYelRNP1/ta7n3D7ra8oZAwmCtJ2
         ZozAS1OGoYkKLSkM5sXgSXY6GsjCfbqxyaxd+CGSIIk5ZdckUy3JMk1gZQx/wPPSnsfM
         npZc0Ocv728nkuLlwpeT4C1f873Op6mCswBC8CADkp2FvEwALJTj7OcWl5II2q8ztCTb
         3HOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dhCvrW6VDzVeJLnbwvW9u01I7iypqs1UknLeEWPJNXk=;
        b=elnY5SrvWbP6hMlczo6mgt0UxZE02k7kxY6U7fwXI1WA9VSO8eapuyh5A93KfngyvF
         lm+8Ms81mK2QdTjTrMNTwqr7tfcjeHfQOxCL8TyLAaa6UnrzWkkrS2KDKTm7vbt96Hwz
         r3YEb8biSVwRIRnhJqzDnvzWVZxa+lP4oUwKcNbH1xGpRpv20tfxB0Z248zJiTHEMren
         Iu/SVBzgLB3bOGiPp+pPkMjUqN+++cFNFYNHntvqtRlPjEZY6AZb78uWNGJboiHDKvqY
         SZnKWNOr9aUI8G83z7B+xO8pKIzTihwUBEofiHYDQVYiJmplbdRjroTHlV90BY7eYJrF
         oNKQ==
X-Gm-Message-State: AOAM533N2QcYpu28ZUhEkrhdxW2FuEMsVmVwQuw1QkVt5LyEjcFYHMGU
        mScPpydp7Wnab/eNll0x41Ezd1QIW7g=
X-Google-Smtp-Source: ABdhPJy/zCdnIuXOe4369cvTIvSEMaWbZhSmnQh2PShVOcxnWt6mIedkTVfQOwrhYwZF7fYulRCTww==
X-Received: by 2002:a1c:a9c6:: with SMTP id s189mr13090699wme.143.1626554474426;
        Sat, 17 Jul 2021 13:41:14 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:13 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 4/7] rtw88: Replace usage of rtw_iterate_keys_rcu() with rtw_iterate_keys()
Date:   Sat, 17 Jul 2021 22:40:54 +0200
Message-Id: <20210717204057.67495-5-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
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
index 6e0d25f0afe3..e40432b1dcee 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -574,9 +574,7 @@ static void __fw_recovery_work(struct rtw_dev *rtwdev)
 
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
2.32.0

