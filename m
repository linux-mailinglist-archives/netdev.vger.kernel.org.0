Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B9F3CC656
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbhGQUol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235646AbhGQUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:18 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F49C061767;
        Sat, 17 Jul 2021 13:41:18 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d12so16136396wre.13;
        Sat, 17 Jul 2021 13:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mj2H3msC6oyhKz7UwATyKp0y5VOYMGrKZ8Me0MwbHlo=;
        b=RRfAQgvDxFkq9BTwC4WA0SaA78PX1voZJS9zeepKtWYEbDR7nr9+rou4xCBIF8M6GZ
         8YT9n90qbhBNfZtQOLcri2UJPCLvJClXTYirrgpEldvIw8WpJT9lTZRWZuokpQ/P3JAG
         6gttyHWXP+AQD86M64TZnJhuDXcihS4GrpvpJ/su4a8Ylq9ZGbt6orqtgwu1DFEYcQSc
         qlPjPxa4JPihb4jfmEOHhXgFJDVT1yfX8OITd++TIw6lhN5yOpjHywNnjeLr95p47kfY
         zRVl8w9eCaxZFOm//QViM7+Mro0o0vA5KPLiKhWu0xv81AWzjZkSCNbDwHf7C7pxCgwQ
         +RrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mj2H3msC6oyhKz7UwATyKp0y5VOYMGrKZ8Me0MwbHlo=;
        b=biTY/PeHTrM9uodFMeDeSyn0B10qFYcyGNlnmifvD5IDgMiyZuubW39YgdDrFTGlol
         ovKwai0Be0cg19FCkcNori2eIOtypxfKqMjCw25WabRk+MR/65gaGZ+UQiZ5xMMVBywG
         gCVL77n6zBAyb9u6tTNnN1X32NG02bHbQX9mC0yIAHSo03f26epbMblSYkRhw0U2zvVT
         uTZz8Im5TJy9gQNta3HWNT79ayIXw/WSHYjz4qb4Bxh3TypwGDXImclVqC5AXN5kK4uC
         y2D70yJNhPm/iXuJw9LwdYWH/OFioc1zng3U/Ylzm5CeaGh3w2FOUryl+58S9Cd9ZCd6
         gVyA==
X-Gm-Message-State: AOAM531BHylmLXq+WR0724K5+KaEb695Ty30iKEGbkczy5dnsS0s4Muc
        AMDEU+3P7JobUXqXMvqDUY40KPUWwoc=
X-Google-Smtp-Source: ABdhPJx0xizcRHPfUYgxXxQWN7LnGYOrn+BzTXtExqnxUqjICf37qSmxBsOHt8Cihcae+Jh+qsuysA==
X-Received: by 2002:adf:edd1:: with SMTP id v17mr19892978wro.276.1626554477229;
        Sat, 17 Jul 2021 13:41:17 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:16 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 7/7] rtw88: fw: Convert h2c.lock from a spinlock to a mutex
Date:   Sat, 17 Jul 2021 22:40:57 +0200
Message-Id: <20210717204057.67495-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Switch
the h2c.lock from a spinlock to a mutex to allow for this behavior.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c   | 14 +++++++-------
 drivers/net/wireless/realtek/rtw88/main.c |  2 +-
 drivers/net/wireless/realtek/rtw88/main.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 3bfa5ecc0053..5acc798299e5 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -285,7 +285,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		h2c[3], h2c[2], h2c[1], h2c[0],
 		h2c[7], h2c[6], h2c[5], h2c[4]);
 
-	spin_lock(&rtwdev->h2c.lock);
+	mutex_lock(&rtwdev->h2c.lock);
 
 	box = rtwdev->h2c.last_box_num;
 	switch (box) {
@@ -310,9 +310,9 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		goto out;
 	}
 
-	ret = read_poll_timeout_atomic(rtw_read8, box_state,
-				       !((box_state >> box) & 0x1), 100, 3000,
-				       false, rtwdev, REG_HMETFR);
+	ret = read_poll_timeout(rtw_read8, box_state,
+				!((box_state >> box) & 0x1), 100, 3000, false,
+				rtwdev, REG_HMETFR);
 
 	if (ret) {
 		rtw_err(rtwdev, "failed to send h2c command\n");
@@ -328,7 +328,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		rtwdev->h2c.last_box_num = 0;
 
 out:
-	spin_unlock(&rtwdev->h2c.lock);
+	mutex_unlock(&rtwdev->h2c.lock);
 }
 
 void rtw_fw_h2c_cmd_dbg(struct rtw_dev *rtwdev, u8 *h2c)
@@ -340,7 +340,7 @@ static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
 {
 	int ret;
 
-	spin_lock(&rtwdev->h2c.lock);
+	mutex_lock(&rtwdev->h2c.lock);
 
 	FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, rtwdev->h2c.seq);
 	ret = rtw_hci_write_data_h2c(rtwdev, h2c_pkt, H2C_PKT_SIZE);
@@ -348,7 +348,7 @@ static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
 		rtw_err(rtwdev, "failed to send h2c packet\n");
 	rtwdev->h2c.seq++;
 
-	spin_unlock(&rtwdev->h2c.lock);
+	mutex_unlock(&rtwdev->h2c.lock);
 }
 
 void
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 5ebc4c0b4ccc..34e5bc97d9f4 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1834,12 +1834,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
 	skb_queue_head_init(&rtwdev->coex.queue);
 	skb_queue_head_init(&rtwdev->tx_report.queue);
 
-	spin_lock_init(&rtwdev->h2c.lock);
 	spin_lock_init(&rtwdev->txq_lock);
 	spin_lock_init(&rtwdev->tx_report.q_lock);
 
 	mutex_init(&rtwdev->mutex);
 	mutex_init(&rtwdev->rf_lock);
+	mutex_init(&rtwdev->h2c.lock);
 	mutex_init(&rtwdev->coex.mutex);
 	mutex_init(&rtwdev->hal.tx_power_mutex);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index fd213252fbe2..1788fc339afb 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1868,7 +1868,7 @@ struct rtw_dev {
 		/* incicate the mail box to use with fw */
 		u8 last_box_num;
 		/* protect to send h2c to fw */
-		spinlock_t lock;
+		struct mutex lock;
 		u32 seq;
 	} h2c;
 
-- 
2.32.0

