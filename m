Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67E6647C811
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhLUUKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhLUUKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:10:48 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E48DC061574;
        Tue, 21 Dec 2021 12:10:48 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id z8so110839ljz.9;
        Tue, 21 Dec 2021 12:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUTD85DTqFh8A4kGTDuc3IZA1YdriBEGBR1o80m5qXg=;
        b=QJbP+m5ENMCLb32+58udXRwmKFtpZR/Jn5kpWoDjgSQeJK8Ny8xiL2FLgLE1FY5xj3
         rjhkeuKdGZL1w6IJkbfVjJZ4QPJowh2VhVqXDNKQhcDnUcbv9CEacUv+5tCbJ7FzfFsY
         lFNXwdqT3L3MNm2KSy3EwRfRqwgIsuI9uVHAvUbPhm9fhSTLci9HaOY0aecyUwW3RJFt
         L093Uk1e0Zrfhx3nCpMA+OLtadEnWc22K2Bt53kxBL+9JoXq/aVXXLJsOBfVIp5v8esG
         /hCO18IVZNB7x6RKsggRMdZB1tqzz16oYbILW996ErppsuWe5LsNTTjOYF1FhPFXTPc2
         wK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUTD85DTqFh8A4kGTDuc3IZA1YdriBEGBR1o80m5qXg=;
        b=7/OCQ0y5UpE/m4oZj2bwk2nY+z5s+8LTw6Ht221TLpBHM+fb/rjqsS03K+Ge+ot8ZV
         TdPDKUHfPr7CIsXW0yOsdQzmMNirmVg4mVrDkud6LGa+E8D0gQGd5wq/mW8Hnu1V5pu/
         sbY0hmDOVvnZFXeQCWThQzi0EPYMSTsZwBZHtR61OQKwOF7F/vb854WeaDER/VDmIGg+
         y83rDKVMzEBEXcOvS5J25cHYj5st6w/POiDFE9PqJkeRwu3+FAHFrn4G5Z4sXTUaP0Kr
         m6hXBKkWJzFa308eivvk5Zv+Q3zhAzuzJVCjqUe1DYSAjLCUcc7lRr2jS2n/6qWS1owS
         DwaA==
X-Gm-Message-State: AOAM532Nxum8glx8bQBKjgRRnyLx98rWjcf6+Xq547oTbs884SS9iqRa
        dbZD+Ri0n6oWvjpKPKeJIXk=
X-Google-Smtp-Source: ABdhPJwSBbfWRMMbV6dSe98Hu6LuthQ0RfohJQzy6Z3HBsE+XDP3K2cL7FIK7/TsdodtGglA/WbZ5g==
X-Received: by 2002:a2e:84c4:: with SMTP id q4mr9911ljh.266.1640117446444;
        Tue, 21 Dec 2021 12:10:46 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id m2sm1656560lfu.254.2021.12.21.12.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:10:46 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, robert.foss@collabora.com, freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v2 2/2] asix: fix wrong return value in asix_check_host_enable()
Date:   Tue, 21 Dec 2021 23:10:43 +0300
Message-Id: <ecd3470ce6c2d5697ac635d0d3b14a47defb4acb.1640117288.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
References: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If asix_read_cmd() returns 0 on 30th interation, 0 will be returned from
asix_check_host_enable(), which is logically wrong. Fix it by returning
-ETIMEDOUT explicitly if we have exceeded 30 iterations

Also, replaced 30 with #define as suggested by Andrew

Fixes: a786e3195d6a ("net: asix: fix uninit value bugs")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	- Fixed coding style issues
	- Replaced 30 with #define

---
 drivers/net/usb/asix_common.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 06823d7141b6..71682970be58 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -9,6 +9,8 @@
 
 #include "asix.h"
 
+#define AX_HOST_EN_RETRIES	30
+
 int asix_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		  u16 size, void *data, int in_pm)
 {
@@ -68,7 +70,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 	int i, ret;
 	u8 smsr;
 
-	for (i = 0; i < 30; ++i) {
+	for (i = 0; i < AX_HOST_EN_RETRIES; ++i) {
 		ret = asix_set_sw_mii(dev, in_pm);
 		if (ret == -ENODEV || ret == -ETIMEDOUT)
 			break;
@@ -83,7 +85,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 			break;
 	}
 
-	return ret;
+	return i >= AX_HOST_EN_RETRIES ? -ETIMEDOUT : ret;
 }
 
 static void reset_asix_rx_fixup_info(struct asix_rx_fixup_info *rx)
-- 
2.34.1

