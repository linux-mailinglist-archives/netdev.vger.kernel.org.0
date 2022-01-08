Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C63948803A
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiAHA4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiAHAz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:57 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38FFC06173E;
        Fri,  7 Jan 2022 16:55:56 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a5so10158070wrh.5;
        Fri, 07 Jan 2022 16:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RaQ9bvcWekXUuYk7Fwo10dE04Y9Sl54Vm+TM6HP1ZNg=;
        b=LsbHBuuZq8WZqkWVuh0uWnPQ5KGTbX/mhUycXNMmzDi271huaM+h/+7AbcSftIf3kt
         Gyh0rNgM2P8kG0brHAaof1WrszcBOPix7wYBYtRM/fLfkgnbbyprPIpRycTo/q1dmp1d
         7xvwi7MrR3rvjjgkP5GOAoQvRLFnzoZ4XhWdRu3F5iueXMLGB8CPf7FIifMm1BTkJU9W
         Rt33OOYruxWKuIcj1S4ZHIUiXtvaxy0zGSOWyR1Y1IwNt6PGEtNB+rWNv3XT2sHC4B0P
         zdNEIPayFyuo1p0z5wIRqlMmTZ3hvZk72yKNYOdVh2zY6v4raXn8nakCIzPlVujb+KNP
         7+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RaQ9bvcWekXUuYk7Fwo10dE04Y9Sl54Vm+TM6HP1ZNg=;
        b=FfDP7byZlrB2lS8cskeAdg0t7DiCWiWMxtlaWmTA2O9V+PrpNKtRLXBxygx72CEKWy
         6iJEFJul17Z76b5G9yes6a4yp0sDlmpJRlAXYrTU6GUoeQChTdD3LF/MtPWl/C+/3z6k
         psjSbMMU+o/HdBt3MbGgtlM2NlM68oGRiYHlElY/vkCH+WBaPS0HM/TxER/dO7rj/D6L
         5gfgEtBM3zT/v3iadMsYzhwhWgaN+P7hzQ6zZLEkjmvIBJHhJcQigStjPtUOjEL9gO2Z
         qG6nhWDX1RwcTExUDjOYKl4y0LU+ZugUyyIujZhXxSGo9Rk2BTd3HW+7i4nJ9Tn3ayoE
         aDdg==
X-Gm-Message-State: AOAM532NVF4kHW2b+cM01uoAVaWF1McK2CbLZHJIaeBXwZQhGYS6LNK5
        LdCQQztqqAwF+H+PLubFciEMOUDtqGI=
X-Google-Smtp-Source: ABdhPJy/++KBPtHjbaOYSC2W+1uPCMcbl2BG5y7ZLjdFBcd6ylYlj9n8DNtyRJyxIgWWDovD6NhDOg==
X-Received: by 2002:a05:6000:22a:: with SMTP id l10mr56092336wrz.534.1641603355296;
        Fri, 07 Jan 2022 16:55:55 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:55 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 8/8] rtw88: fw: Convert h2c.lock from a spinlock to a mutex
Date:   Sat,  8 Jan 2022 01:55:33 +0100
Message-Id: <20220108005533.947787-9-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
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

