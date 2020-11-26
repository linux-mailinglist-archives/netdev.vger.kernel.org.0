Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314592C585A
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbgKZPfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731552AbgKZPfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:35:03 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D6DC0613D4;
        Thu, 26 Nov 2020 07:35:03 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w202so1916759pff.10;
        Thu, 26 Nov 2020 07:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=f18jjpAb3a6wwaCwAQVq0XjGDSvE4J1ZBEOKED5Wevo=;
        b=on+EDg2Z1e4uBbPphYAsXBdymQ1mDw1L7F4O+cc3NuYhxJmsVg1q4l0KdjogSr0UmM
         5zX3C570Udeih/3brql3WxCCiAIZw+1Lf1952jtEqG2jsSOX3xqxQk7Xuf0OIbWUz0br
         hiShsEQNM0vzINR6dKHYML6X7wfzmY7aAH11ekUPkl3PhnFVS9VnHKRIM0ULwfuJqZBD
         L2LyRWHFu6IQAuWmsWK/+7aQqqhBPc6eOEbUKFF1229In9jIuG9TxcJyEnYunJ7WrJhg
         cyhHUZK9vAJ6KnDbTzZtc0aUb67mksJOUh8/HT9iAelnsyCsL6I8CPW1KJNqEUMEBeEz
         co4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=f18jjpAb3a6wwaCwAQVq0XjGDSvE4J1ZBEOKED5Wevo=;
        b=rbo/h5MuMpi7UqZGu6YGW4kHYoTuu4oc6kLv582Gnh9tnFHvi4rSqcCHOb8O2w2kwl
         z4E9ACVlaiaX4DKfGPNxCTiJ/4RRCaHy3ADb26TiB0fjzT6iIj4CLGULbp5vFFWkD5xi
         O/rEwuUmjC5scMP7FuJx8mBidIkESIbllqvO45awVCZ+sxCPwBnCaawuBU0xj0VD6OKp
         ZW2XSiGhPeGQewcPMH7dK4X5/Bm9beez2d8QD1zD2J/iBmeoWTmqBoPKGyU4hl3Wy0oJ
         9O2FYe/YPQoNLkqZKjm+3/DFzVVRSkMaolrxOGPiS9+f77CgZyhm4ZpGG3UQNXSEQBol
         2Xbw==
X-Gm-Message-State: AOAM531ki4ShbP1NQTb5X2IoQjtRlE0NebGfAhwFoiKXTP/3krshzdBW
        yCD3KynVnE4X2vfhgIlaAjQ=
X-Google-Smtp-Source: ABdhPJwN8JxU7ItTaAdq7ulGQESO+3r0lT2l5ej+ZQV1Afo2Y+5tToywpDHctLNXQGDL7+pqnZjdsg==
X-Received: by 2002:a17:90a:a81:: with SMTP id 1mr4229453pjw.165.1606404903469;
        Thu, 26 Nov 2020 07:35:03 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id g6sm6506481pjd.3.2020.11.26.07.35.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Nov 2020 07:35:02 -0800 (PST)
From:   bongsu.jeon2@gmail.com
X-Google-Original-From: bongsu.jeon@samsung.com
To:     krzk@kernel.org, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH net-next 1/3] nfc: s3fwrn5: use signed integer for parsing GPIO numbers
Date:   Fri, 27 Nov 2020 00:33:37 +0900
Message-Id: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

GPIOs - as returned by of_get_named_gpio() and used by the gpiolib - are
signed integers, where negative number indicates error.  The return
value of of_get_named_gpio() should not be assigned to an unsigned int
because in case of !CONFIG_GPIOLIB such number would be a valid GPIO.

Fixes: c04c674fadeb ("nfc: s3fwrn5: Add driver for Samsung S3FWRN5 NFC Chip")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/nfc/s3fwrn5/i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index 0ffa389..ae26594 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -25,8 +25,8 @@ struct s3fwrn5_i2c_phy {
 	struct i2c_client *i2c_dev;
 	struct nci_dev *ndev;
 
-	unsigned int gpio_en;
-	unsigned int gpio_fw_wake;
+	int gpio_en;
+	int gpio_fw_wake;
 
 	struct mutex mutex;
 
-- 
1.9.1

