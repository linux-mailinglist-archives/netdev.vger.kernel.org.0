Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB36B3518B4
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236729AbhDARrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235953AbhDARn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:43:29 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20E7C08EA6F;
        Thu,  1 Apr 2021 06:28:11 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id w28so2848385lfn.2;
        Thu, 01 Apr 2021 06:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pPTQXH4q4Y3+As2WDfnWN7LhkfWGagXjj+j3XYslqSs=;
        b=edQu655dnVXxAwsXxZFBvnZHT5VQ8axoKWqSrmsoe6+v7obF4uTVtqcvoynBxne0bW
         6yEiGCUhrAfwBETdN0RKj4INLGCF1sqoDWlmGq/Yijcf+UUDqylByj/wOoXcGXDrBKSn
         dVZtMm7RY21vNCv4Y4LCFUmrxHQ8fow5ayf7/82pA1YCqqC1JEHgvBeFUieyVB8OSJYx
         YjdtqNqA1BetdZm6Fa+l39bqscqzTJvgeYvXmbYeVg9iN9Zhcs/nDWSBFaRJcOpg9QS9
         /UW4rRhsPgC0Dk55t2FvE3ztWPSUAq3uDYdHYLigtaIxKxOg4ex5+Lmmj447ZDwb1+Wz
         z5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pPTQXH4q4Y3+As2WDfnWN7LhkfWGagXjj+j3XYslqSs=;
        b=uHVyDrtayRvJT6Wr8/6L2Ilu0HVU1vvA6k0pYD0OO0miARgvbitSRvaey1EBj2WAP/
         fes/vM5RVea5LRCZTRWVSPc4xWJmO46LCB+sdNSB2lgFT8naQ6WbcCWn76JCWKWze4Wu
         0EkzYNnUhpJWphEpT8XNTSKYTA+U6Wz4Ugi39tBWurlKzr92/OC/OfyCgpqekYu/btDR
         JT+j1v5bmvG1KZPAO79lnjgFyyKIw7SJGYdmdovJBkHd5dD2sZFuBZEzjrOJuMn4Y+IT
         slKPvi/ZqBd98WDQold5h2jem5H10EfVkmRmluyJJpk2N/7uGbx3vTnkVe6ip2EuFuOs
         nQtA==
X-Gm-Message-State: AOAM533xcPWoRTAAwiCQq0VNOW9rMxT75gJXEFIM5LJQdoiWlimqsXTH
        AjpZcK0lZSm2JuKbmuCm13U=
X-Google-Smtp-Source: ABdhPJzUqIGbIxM3wfJ/lIRhRzchR48PEJ5arWl6KT6NLjy5Bj8IrHZIGN5GVLuwSve2gxdWJXvBSw==
X-Received: by 2002:a05:6512:49a:: with SMTP id v26mr5404651lfq.211.1617283689681;
        Thu, 01 Apr 2021 06:28:09 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id t13sm617533ljk.47.2021.04.01.06.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 06:28:09 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        kuba@kernel.org, mailhol.vincent@wanadoo.fr
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com
Subject: [PATCH] drivers: net: fix memory leak in peak_usb_create_dev
Date:   Thu,  1 Apr 2021 16:27:52 +0300
Message-Id: <20210401132752.25358-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported memory leak in peak_usb.
The problem was in case of failure after calling
->dev_init()[2] in peak_usb_create_dev()[1]. The data
allocated int dev_init() wasn't freed, so simple
->dev_free() call fix this problem.

backtrace:
    [<0000000079d6542a>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000079d6542a>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000079d6542a>] pcan_usb_fd_init+0x156/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:868   [2]
    [<00000000c09f9057>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:851 [inline] [1]
    [<00000000c09f9057>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:949

Reported-by: syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 573b11559d73..28e916a04047 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -857,7 +857,7 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 	if (dev->adapter->dev_set_bus) {
 		err = dev->adapter->dev_set_bus(dev, 0);
 		if (err)
-			goto lbl_unregister_candev;
+			goto adap_dev_free;
 	}
 
 	/* get device number early */
@@ -869,6 +869,10 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 
 	return 0;
 
+adap_dev_free:
+	if (dev->adapter->dev_free)
+		dev->adapter->dev_free(dev);
+
 lbl_unregister_candev:
 	unregister_candev(netdev);
 
-- 
2.30.2

