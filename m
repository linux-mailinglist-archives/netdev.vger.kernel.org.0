Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99213EBE5F
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhHMWos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:44:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbhHMWor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:44:47 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75435C061756;
        Fri, 13 Aug 2021 15:44:19 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id c12so4789709ljr.5;
        Fri, 13 Aug 2021 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UA6o2CCYezR/kHTPRnO3Z0sstg3TXd9hIrBv8hmRn7o=;
        b=udZHgeAR7SMTHzfd4w96JqJIMPnbpwc/0RAtjKZw8dUUjybQWMXzEjEp2l0XETE8Ra
         tbIXV/3KDrAQppyWAVPXtvAPu5R/NjKgX2QgJOlEkdiAEfFb4V8nRbUP6V/bWn+Dm1IW
         Ae7Op2TRQRZXbs1eKogPoOfzyUYRABYWAGcSHBg8GDHDhIQSkMWBQ8TbjqEssZBytmdL
         wyVjeJa/bvqmN+odBAsQr+nDLyQKcLlITiwkNgH16xqn7Br25Oi6MwA4Gxhoe2dcfYj1
         le++OYtIixK95VRQeLTJgFlt4+um2jKnx1Igx3ls28KU+nGbiNh60VEtNc3pDTcdGzJH
         W4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UA6o2CCYezR/kHTPRnO3Z0sstg3TXd9hIrBv8hmRn7o=;
        b=DzMPTK+nAjko1TNy5dTKBrmtQTrv9PrYifVkpBQi5oNIVcUVvgLFHNbKjZtt6Z1y9/
         WjRy8Su6DhGMPrRuu0gUEP1vZSmfVplW3I3RF4ipspMReEDi8GtqjAN6JkHoIdBYuZsN
         DwIRgI2O/FQnwBrrdEIgKrPU6ie2Tfh4jGNE3T2BdWLJeSpTcB1Q0cNthgpZyRJiJy36
         Rpb4ur+l43rT4FjAW8uNk5UaRSldw7+TFp4xOnQO5x6UJ7gN5Q9FqADK7+s5EPtGCDG6
         pvgjBm4FcJMyzwuTB1kWLmZWKdpFxiU/+k9j6n/wQk0+0M6EpI9gN4YLEwdOSg7E7tGu
         7g7w==
X-Gm-Message-State: AOAM530eF3DItG3oCOlPhx0b5suDPorkbqnXI3tGWhUxk7wemJwIWhzh
        zVOgcx3HpU/4Lm0q9k/6+JA=
X-Google-Smtp-Source: ABdhPJwD8QzbG+DTZt+H4DZGVFJ3VMOnRmXbhHvHhOeNASdABTbinl9c0w56b3KQG4CpKFc6+Bke2g==
X-Received: by 2002:a2e:9584:: with SMTP id w4mr3422787ljh.258.1628894657827;
        Fri, 13 Aug 2021 15:44:17 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id m2sm265538lfu.61.2021.08.13.15.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:44:17 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        himadrispandya@gmail.com, andrew@lunn.ch
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: [PATCH v2] net: asix: fix uninit value in asix_mdio_read
Date:   Sat, 14 Aug 2021 01:42:19 +0300
Message-Id: <20210813224219.11359-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YRbw1psAc8jQu4ob@lunn.ch>
References: <YRbw1psAc8jQu4ob@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported uninit-value in asix_mdio_read(). The problem was in
missing error handling. asix_read_cmd() should initialize passed stack
variable smsr, but it can fail in some cases. Then while condidition
checks possibly uninit smsr variable.

Since smsr is uninitialized stack variable, driver can misbehave,
because smsr will be random in case of asix_read_cmd() failure.
Fix it by adding error cheking and just continue the loop instead of
checking uninit value.

Fixes: 8a46f665833a ("net: asix: Avoid looping when the device is disconnected")
Reported-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	1. Fixed previous wrong approach and changed while loop to for loop
	2. Reported-and-tested-by: tag removed, since KMSAN tests can be
	   false positive. Used Reported-by instead.

---
 drivers/net/usb/asix_common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index ac92bc52a85e..7019c25e591c 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -468,18 +468,25 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
 	struct usbnet *dev = netdev_priv(netdev);
 	__le16 res;
 	u8 smsr;
-	int i = 0;
+	int i;
 	int ret;
 
 	mutex_lock(&dev->phy_mutex);
-	do {
+	for (i = 0; i < 30; ++i) {
 		ret = asix_set_sw_mii(dev, 0);
 		if (ret == -ENODEV || ret == -ETIMEDOUT)
 			break;
 		usleep_range(1000, 1100);
 		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
 				    0, 0, 1, &smsr, 0);
-	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
+		if (ret == -ENODEV)
+			break;
+		else if (ret < 0)
+			continue;
+		else if (smsr & AX_HOST_EN)
+			break;
+	}
+
 	if (ret == -ENODEV || ret == -ETIMEDOUT) {
 		mutex_unlock(&dev->phy_mutex);
 		return ret;
-- 
2.32.0

