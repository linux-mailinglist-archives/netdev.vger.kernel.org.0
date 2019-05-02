Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2231811C70
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfEBPQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:16:01 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44412 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfEBPQA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:16:00 -0400
Received: by mail-ed1-f68.google.com with SMTP id b8so2428494edm.11;
        Thu, 02 May 2019 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wivJL1rkpM7slySGZ/F3xuQIVRjZl4VWpt9K/lHjl3s=;
        b=vEAb4lsw2Zy6LV1UmT6BeR9ktShWQu48zOwThJb2af6LrW/SRu5nEe85wzugg87+kF
         qOMk+5XxQ0LojsJExB7FOy0OL3d2/UxNveJWSlerBwaLVpdNwXXoaLaBlVUtDPQmCB/v
         Mpr7WJcappZHZtNOded/TO6zPJHDjRXEwPMUzy13ROyWinJ1ajxjip41No0Z8zGTThiW
         6lySU6jxfgHD/nxGTpvyEUTGYRZ3yZcofNSnqGYTOVc/9XRbuEQmFjlQvbRww48AZRAV
         FelAvbeZJ82Zq1roKgoXp+lvcTnDhtOTGHnur1vB8sqOshCuY/s6hq2Y5XHjljzq/GPH
         rFIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wivJL1rkpM7slySGZ/F3xuQIVRjZl4VWpt9K/lHjl3s=;
        b=R8zwNuAPO7QTttBknCsnmAaz+5SP0b36g1Pyqu0kppqIMMNoqGnZbNTTf1AGz4Odmq
         4R1GdwSllnggxviH5kzpcLId3F6uomfgVdmmbcAwdu06slOg7MDZy0ld2d3Cr7Jh79d5
         JEDKDvSlr8926wpa/U8g6TwToqQPgyEAqNWI/GcVnc2xR1bQbdnzOMJW69G90BywP+eC
         LKcfBmIRXlcIUDmRfIk9fB3DHBMxR5kIMmbEbwEonpsXMFlqVy1bmiwYy01lXsEN2MlO
         q2tIwqCwWjHTIF7GMXlXniBirsD4AjOlP5gFJUZ5z4pfg3gnHT9RQyTWeY5uLYXBfBkq
         c50A==
X-Gm-Message-State: APjAAAUBuzCwC/XEjxIuF+tvJaqmkBxgk7J1l1IEfje4hUODrkTgZu+I
        T5nzhQhXq21rJo3wEhaRRWo=
X-Google-Smtp-Source: APXvYqxZXoeKPatbx+XXa0uFSBDQGJxmAGJrXiCgA1sYCr/FpHhhX1JGBnAuwMGnaClnP4tmYIWaQQ==
X-Received: by 2002:a50:ec87:: with SMTP id e7mr1713710edr.126.1556810158392;
        Thu, 02 May 2019 08:15:58 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2b:2b84::2])
        by smtp.gmail.com with ESMTPSA id f7sm11900433edj.10.2019.05.02.08.15.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 08:15:57 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] rsi: Properly initialize data in rsi_sdio_ta_reset
Date:   Thu,  2 May 2019 08:15:48 -0700
Message-Id: <20190502151548.11143-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with -Wuninitialized, Clang warns:

drivers/net/wireless/rsi/rsi_91x_sdio.c:940:43: warning: variable 'data'
is uninitialized when used here [-Wuninitialized]
        put_unaligned_le32(TA_HOLD_THREAD_VALUE, data);
                                                 ^~~~
drivers/net/wireless/rsi/rsi_91x_sdio.c:930:10: note: initialize the
variable 'data' to silence this warning
        u8 *data;
                ^
                 = NULL
1 warning generated.

Using Clang's suggestion of initializing data to NULL wouldn't work out
because data will be dereferenced by put_unaligned_le32. Use kzalloc to
properly initialize data, which matches a couple of other places in this
driver.

Fixes: e5a1ecc97e5f ("rsi: add firmware loading for 9116 device")
Link: https://github.com/ClangBuiltLinux/linux/issues/464
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index f9c67ed473d1..b35728564c7b 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -929,11 +929,15 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 	u32 addr;
 	u8 *data;
 
+	data = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	status = rsi_sdio_master_access_msword(adapter, TA_BASE_ADDR);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
 			"Unable to set ms word to common reg\n");
-		return status;
+		goto err;
 	}
 
 	rsi_dbg(INIT_ZONE, "%s: Bring TA out of reset\n", __func__);
@@ -944,7 +948,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to hold TA threads\n");
-		return status;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_SOFT_RST_CLR, data);
@@ -954,7 +958,7 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to get TA out of reset\n");
-		return status;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_PC_ZERO, data);
@@ -964,7 +968,8 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to Reset TA PC value\n");
-		return -EINVAL;
+		status = -EINVAL;
+		goto err;
 	}
 
 	put_unaligned_le32(TA_RELEASE_THREAD_VALUE, data);
@@ -974,17 +979,19 @@ static int rsi_sdio_ta_reset(struct rsi_hw *adapter)
 						  RSI_9116_REG_SIZE);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to release TA threads\n");
-		return status;
+		goto err;
 	}
 
 	status = rsi_sdio_master_access_msword(adapter, MISC_CFG_BASE_ADDR);
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE, "Unable to set ms word to common reg\n");
-		return status;
+		goto err;
 	}
 	rsi_dbg(INIT_ZONE, "***** TA Reset done *****\n");
 
-	return 0;
+err:
+	kfree(data);
+	return status;
 }
 
 static struct rsi_host_intf_ops sdio_host_intf_ops = {
-- 
2.21.0

