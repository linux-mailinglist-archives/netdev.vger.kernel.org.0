Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1072C47C80E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhLUUKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbhLUUKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 15:10:41 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D993C061574;
        Tue, 21 Dec 2021 12:10:40 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id x7so301012lfu.8;
        Tue, 21 Dec 2021 12:10:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0cKZHJkPtzwEhRTiRmUXANni1yKXuwEjVCb2Xms6TAU=;
        b=KJG6BJN0R8MJXdhvIn4MCmCuT8qmr6VgESkJb4wzLJFaNHl8EUsuCUMrQB2GpDkpan
         LOO/TBC0v0sdKJHsFzGTfSKnqtulqVKqhXzWfGIoBwCCs+bv39JfJYzQGGVYrOu616JS
         hKi4g0+/LHj6cuecUioGCCkFALLp6YUBR7XuGJxv2PbgA+ACpuaUD4kEGx6Abp/1aCVr
         t+AyM6JD711Bg87NjrbDvH5FhdvsjCGY+XvU1mBmzE12sfvEI6BPZqLpuAKQcGL1Vax+
         FIvABmgsiT2kgS8EYNi0nrxY6OQzyGwJMsctN2xcD7eyL6u2/QLVv7OLv877H5I/EKg0
         7jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0cKZHJkPtzwEhRTiRmUXANni1yKXuwEjVCb2Xms6TAU=;
        b=EUtZKc6Ze8cPBAtF3VWPDWvZnuSjQjzuoH9UmrEZAUYm5OdFYvjRUfN0vKB2g5+7n2
         yQK+xchIuEfko+6eKqF4vadfdWy+zI2rM/WR3xOvfVWf8n/lXFNdJtwyAAtb8N6gGa1X
         vA5+pUwcBg8/RsdMD3eHAlt+1CQ0dOfgQ4UceobwkHAyYwmEjLKaqcV8zYdB1NwSgio0
         3FblKoTFLsp5PPJjy/fHdkgFciu1YIs8MAYInqotXQxA9r/Y6xYCFG4C7xQphnfNe8e6
         6yX9sXdQ4Vn1uhuoMgougSQilEHJhi8wfEu390/0Vdm6dF7vEpeBUKr0ILLJktdVsc2r
         Calw==
X-Gm-Message-State: AOAM532ETJpgMkyIFgDeh9aJiZrwKr2mMq4cM5hLRhMq6vEKlmth6/X3
        rx8wS2azPsGGKOE3P7VqeF4=
X-Google-Smtp-Source: ABdhPJyhC0bELhI5zFh7JQNzua+yk9bIMHrmsuCIQQJf1Dc78/w+y1anvkekQvPWS4aqejWNl9RbdQ==
X-Received: by 2002:a05:6512:1312:: with SMTP id x18mr4406802lfu.587.1640117438793;
        Tue, 21 Dec 2021 12:10:38 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.97])
        by smtp.gmail.com with ESMTPSA id s13sm2804805lfg.126.2021.12.21.12.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 12:10:38 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        andrew@lunn.ch, robert.foss@collabora.com, freddy@asix.com.tw
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] asix: fix uninit-value in asix_mdio_read()
Date:   Tue, 21 Dec 2021 23:10:36 +0300
Message-Id: <8966e3b514edf39857dd93603fc79ec02e000a75.1640117288.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asix_read_cmd() may read less than sizeof(smsr) bytes and in this case
smsr will be uninitialized.

Fail log:
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
BUG: KMSAN: uninit-value in asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
BUG: KMSAN: uninit-value in asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline]
 asix_check_host_enable drivers/net/usb/asix_common.c:82 [inline] drivers/net/usb/asix_common.c:497
 asix_mdio_read+0x3c1/0xb00 drivers/net/usb/asix_common.c:497 drivers/net/usb/asix_common.c:497

Fixes: d9fe64e51114 ("net: asix: Add in_pm parameter")
Reported-and-tested-by: syzbot+f44badb06036334e867a@syzkaller.appspotmail.com
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v2:
	- Added Reviewed-by tag

---
 drivers/net/usb/asix_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index 42ba4af68090..06823d7141b6 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -77,7 +77,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
 				    0, 0, 1, &smsr, in_pm);
 		if (ret == -ENODEV)
 			break;
-		else if (ret < 0)
+		else if (ret < sizeof(smsr))
 			continue;
 		else if (smsr & AX_HOST_EN)
 			break;
-- 
2.34.1

