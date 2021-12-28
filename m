Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12094480D49
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhL1VPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237423AbhL1VP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:28 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334FAC06173E;
        Tue, 28 Dec 2021 13:15:28 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id v11so40542892wrw.10;
        Tue, 28 Dec 2021 13:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RaQ9bvcWekXUuYk7Fwo10dE04Y9Sl54Vm+TM6HP1ZNg=;
        b=CXQvj0OPLuHE68Xk9fZ9itvAzS4vubdYUgpYgfgBKUBy+mWlxfRZYLDd4I+EOtiGmC
         xmLWNWYrSAA0Y1p3iwCQRpsdW589SWf5LzO0XdoPMFH4LoanaOE9aemiLChMtkSHniCY
         SVSavDt3dHzc9iGNbazs+8JntsIt6QXCgJCBXR8SL8PUvMf64+mXfJCW4gNV8Iw7Y5Vk
         Bqrv8SHQgr9T3dIa3r+/j+Qt5C0Oh3JrrlQFezvv9DqrcYurilwxje1UgxDdQ+kIC/68
         oxn3cc+NObS8P8pzY1WL4EkAqAiE19ggVs1GsOZe7bA0eDCrV2MSG0z/Nu3tMVOpcvdR
         O40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RaQ9bvcWekXUuYk7Fwo10dE04Y9Sl54Vm+TM6HP1ZNg=;
        b=vE+isQ1Y5PvjtXn8cGHabJPURN/HjSD7MOAESB7f/mYSml0ZnKgWrhpkWBgSF0X7ax
         U/90BgYSiLqAHqvbtP4b5OSb7cIeCQrJaMWnmGFgF42OmggtNYaZl0YoaJT1MJzGy83O
         73bLGtlFyrXP4Ob/AGLJ6dIvCPfTat66f1JlCRaBU5sfcjtnZF2bZMAN2l0vVbPGZQ9x
         JFfjZdZ6xeetqZqBtY5cqLEa2Yj6z2U6dGnA8WulgxESfE3yiiZgZTY7+c6PQmCRN4CM
         NxeYumpdoNrxh+uIIc10IA6LFCE6VlafBp0Zyxxf1FVC2GqbxgPDGEqC395sAhsm1ABD
         P1/A==
X-Gm-Message-State: AOAM531lNv7X26SPuCnMQCGc2z/zWkcZOHGkhm/FVBOGvzq5AEq4+kFr
        bY33WJhRZsAEw9TBhiB+Kl2fyB45zfA=
X-Google-Smtp-Source: ABdhPJxUkbn0/rXXvV4KL76p4YHj6BFPA6aTpn7t8ZKgSDewZ1C41tkCAOthuPTT+3H84FXszV6Ulg==
X-Received: by 2002:adf:bb11:: with SMTP id r17mr18266752wrg.463.1640726126562;
        Tue, 28 Dec 2021 13:15:26 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:26 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 9/9] rtw88: fw: Convert h2c.lock from a spinlock to a mutex
Date:   Tue, 28 Dec 2021 22:15:01 +0100
Message-Id: <20211228211501.468981-10-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
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
index 2f7c036f9022..1bff43c14a05 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -317,7 +317,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		h2c[3], h2c[2], h2c[1], h2c[0],
 		h2c[7], h2c[6], h2c[5], h2c[4]);
 
-	spin_lock(&rtwdev->h2c.lock);
+	mutex_lock(&rtwdev->h2c.lock);
 
 	box = rtwdev->h2c.last_box_num;
 	switch (box) {
@@ -342,9 +342,9 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
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
@@ -360,7 +360,7 @@ static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
 		rtwdev->h2c.last_box_num = 0;
 
 out:
-	spin_unlock(&rtwdev->h2c.lock);
+	mutex_unlock(&rtwdev->h2c.lock);
 }
 
 void rtw_fw_h2c_cmd_dbg(struct rtw_dev *rtwdev, u8 *h2c)
@@ -372,7 +372,7 @@ static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
 {
 	int ret;
 
-	spin_lock(&rtwdev->h2c.lock);
+	mutex_lock(&rtwdev->h2c.lock);
 
 	FW_OFFLOAD_H2C_SET_SEQ_NUM(h2c_pkt, rtwdev->h2c.seq);
 	ret = rtw_hci_write_data_h2c(rtwdev, h2c_pkt, H2C_PKT_SIZE);
@@ -380,7 +380,7 @@ static void rtw_fw_send_h2c_packet(struct rtw_dev *rtwdev, u8 *h2c_pkt)
 		rtw_err(rtwdev, "failed to send h2c packet\n");
 	rtwdev->h2c.seq++;
 
-	spin_unlock(&rtwdev->h2c.lock);
+	mutex_unlock(&rtwdev->h2c.lock);
 }
 
 void
diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index a94678effd77..e883f5ecf307 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1920,12 +1920,12 @@ int rtw_core_init(struct rtw_dev *rtwdev)
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
index e7a60e6f8596..495a28028ac0 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1975,7 +1975,7 @@ struct rtw_dev {
 		/* incicate the mail box to use with fw */
 		u8 last_box_num;
 		/* protect to send h2c to fw */
-		spinlock_t lock;
+		struct mutex lock;
 		u32 seq;
 	} h2c;
 
-- 
2.34.1

