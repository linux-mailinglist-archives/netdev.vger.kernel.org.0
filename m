Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0578480D46
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237491AbhL1VPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbhL1VP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A941C061574;
        Tue, 28 Dec 2021 13:15:27 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id v11so40542842wrw.10;
        Tue, 28 Dec 2021 13:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oj4lreG5cZ3IFWojzIgNqoaNn8hukHMIHKIyr0AoqhQ=;
        b=e5QefRpQAY4BqOrnWdAEoUlf8ZKbEO/Bps3rEOzzlItT4AWG/Y/YvujfdLzhrH6Jev
         cuiolKaEQnX5LERTOaioIRhqJ6QSSypuPf+Vjy0lImBqmZAAdXQBN6buBOVRutDdYscc
         6k1eFuECEqpaHLkEIslbOBA3BlAYuJ692G30E819btH+A5XZB8EQYrqnyi5ZFxnx5OYm
         lVs6fCRNB56uK17cIbQtKQJmS9eqz0PQJfw1kjXDtSrg+bElIwofRTIo8JkEt4rpIBC/
         DOhsivNgmXGXgnta3rRMosIiyarNuFyE1pf/XKijuOkAqUvOu2lV8wNf0u4nTN7n69cL
         xA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oj4lreG5cZ3IFWojzIgNqoaNn8hukHMIHKIyr0AoqhQ=;
        b=cv4j/Mhkhtv00GERfaU1uyjvy6+ie3HWirxeGdL9CRTwPju8MJrGacdA6rTp19SUww
         tRO5UQGCkYhgde83L2vILCuG84NyMPrd+APM2DdTwM7IKq5ubCUqQGQ0wsecpi2nRbY3
         6JR2Swynlb9ZOMw+Y/vK4t8x2YPwGdZIxL4epZzOomOM2gAnu9UPH963eGG2vehGh6sZ
         BD934NkGo6yBOf7L31EsZDZuUayOq2nrRLz5hyBbavel0+8djWf7MY/bh0ZwGMb4e2SV
         Ey5ujyx3l48aGgzI/Sm/zHTKk8mh9+tC2WXrYwihiI4G4ce4Qiu82xJ20LZis8aObXRQ
         JZrQ==
X-Gm-Message-State: AOAM533jB/syV2VKcfGjQaStHrCaarKdXbYqlHIU/FjB5qqM2UnzV/KX
        673NqPWACooTeNsqI26LdTeSeVhDjr4=
X-Google-Smtp-Source: ABdhPJzrMZ5qfvZCeoeuuBanLzhRdDynQhiefOc7Y5L4pz7fkUjQZJpWHkkW1hvVdUz55rQOgWnoTg==
X-Received: by 2002:adf:f24e:: with SMTP id b14mr17711802wrp.612.1640726125677;
        Tue, 28 Dec 2021 13:15:25 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:25 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 8/9] rtw88: hci: Convert rf_lock from a spinlock to a mutex
Date:   Tue, 28 Dec 2021 22:15:00 +0100
Message-Id: <20211228211501.468981-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
rf_lock from a spinlock to a mutex to allow for this behavior.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/hci.h  | 11 ++++-------
 drivers/net/wireless/realtek/rtw88/main.c |  2 +-
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/hci.h b/drivers/net/wireless/realtek/rtw88/hci.h
index 4c6fc6fb3f83..3c730b7a94f7 100644
--- a/drivers/net/wireless/realtek/rtw88/hci.h
+++ b/drivers/net/wireless/realtek/rtw88/hci.h
@@ -166,12 +166,11 @@ static inline u32
 rtw_read_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	    u32 addr, u32 mask)
 {
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
+	mutex_lock(&rtwdev->rf_lock);
 	val = rtwdev->chip->ops->read_rf(rtwdev, rf_path, addr, mask);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
+	mutex_unlock(&rtwdev->rf_lock);
 
 	return val;
 }
@@ -180,11 +179,9 @@ static inline void
 rtw_write_rf(struct rtw_dev *rtwdev, enum rtw_rf_path rf_path,
 	     u32 addr, u32 mask, u32 data)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&rtwdev->rf_lock, flags);
+	mutex_lock(&rtwdev->rf_lock);
 	rtwdev->chip->ops->write_rf(rtwdev, rf_path, addr, mask, data);
-	spin_unlock_irqrestore(&rtwdev->rf_lock, flags);
+	mutex_unlock(&rtwdev->rf_lock);
 }
 
 static inline u32
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 3d4257e0367a..a94678effd77 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1920,12 +1920,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->rf_lock);
 	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
 
 	mutex_init(&rtwdev->mutex);
+	mutex_init(&rtwdev->rf_lock);
 	mutex_init(&rtwdev->coex.mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index dc1cd9bd4b8a..e7a60e6f8596 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1949,7 +1949,7 @@ struct rtw_dev {
 	struct mutex mutex;
 
 	/* read/write rf register */
-	spinlock_t rf_lock;
+	struct mutex rf_lock;
 
 	/* watch dog every 2 sec */
 	struct delayed_work watch_dog_work;
-- 
2.34.1

