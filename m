Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FD53CC65A
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhGQUor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbhGQUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:18 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E7CC061766;
        Sat, 17 Jul 2021 13:41:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id f17so16189527wrt.6;
        Sat, 17 Jul 2021 13:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZvC5Ygzd6gbVP8NtAh30qzHzpl/bhx2z4pCtMRNmGCA=;
        b=CMNps2dWETudqhXFL3YQvTQxtOvEK1YLiyZvUF+210/zOMc9vee/5Ev4z1Whf3v/0P
         QKZ4pnTBoIpOaZ9rvsc2Ot4Nb+rBJ/egOvVEuW/13+73zIWyI6SSFNn3UfBYyIfrCuJw
         Yzmz/5dzfg8G16RdnQUi4U2bWhQN32Drp4gSsk1CX+1535n1Yvi8xpMeALeg3nPZhJEL
         r4rxjz3ZojkSJylPkdst5zHcQa8/bGCy8lR/+aeFCqzanntann3zpxuWC4PJugsdxYSf
         VyORN16rEWEFp39FjElWZPgTh5q8D08aSCyFsZgtaTk+M1hipN+E7nWl76IhxxdaHk/P
         K+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZvC5Ygzd6gbVP8NtAh30qzHzpl/bhx2z4pCtMRNmGCA=;
        b=mqBOTiebTSDE352AJXNrPTKpGumJoOTiptso5MASFSZQsAEFirKeCEzH8ihqE9MxRg
         lu08R2Is3NcyZrLJhiZJ5HXHQPkq4UAHPee3sCVKxzoQiO2txjFIxsF6Vr79jiSju5Ay
         jbRGWrNxhEcDslUcaOULODGOtQx1DL6AcuT6oRbsD64MEaXWM1QEFb4oIF4WBAgXC5YB
         w+SkqnXbfckzx/xK/E5WbGlvqfgpt1fR820vhhvw708JmaAnqAd8CGvgJopOosavOLR9
         hkBTjBntpXMxH1lIV2YXXqGfwdXqkp/z7+YJx1WxqwMBQ3qxZwOtrrm9ZJuM19EbRcfQ
         1fzA==
X-Gm-Message-State: AOAM530NLul5oaWYUJ/gykD4Zgu0H8nG17KJTe5RNRO6J/4CnOfMwgNu
        9ppAr9RnOnDoEI4xQRctiwZA4r9K4Ls=
X-Google-Smtp-Source: ABdhPJzkXbYkUOoXNPBxmgOc/tU5EZp/j/GUswIG+cPU+/iXe2bnZnWqX+NlnyCUEgzsuTN29A+lTg==
X-Received: by 2002:adf:ef03:: with SMTP id e3mr20546311wro.316.1626554476324;
        Sat, 17 Jul 2021 13:41:16 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:16 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 6/7] rtw88: hci: Convert rf_lock from a spinlock to a mutex
Date:   Sat, 17 Jul 2021 22:40:56 +0200
Message-Id: <20210717204057.67495-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
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
index e40432b1dcee..5ebc4c0b4ccc 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1834,12 +1834,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
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
index e5af375b3dd0..fd213252fbe2 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1842,7 +1842,7 @@ struct rtw_dev {
 	struct mutex mutex;
 
 	/* read/write rf register */
-	spinlock_t rf_lock;
+	struct mutex rf_lock;
 
 	/* watch dog every 2 sec */
 	struct delayed_work watch_dog_work;
-- 
2.32.0

