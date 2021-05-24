Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A775E38E7CC
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhEXNk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhEXNk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:40:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80962C061574;
        Mon, 24 May 2021 06:38:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ml1-20020a17090b3601b029015f9b1ebce0so1938972pjb.5;
        Mon, 24 May 2021 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24xHs/c9+Vn16SJ80N4lzJM1aJdYpt55ltlqUdwqHiM=;
        b=scqmS67QUgt1Fyf/4fpwGS4WutaGVaj/jxJ1L4w5FuFY7hJKD5d7EZkBeNXeRt8TNR
         /OsZH4Ysney0WPC+TzEY9OBZaICZleyn/+cVjoI4q5tEn6qrTObNva62hgyt+C54ciOg
         jYS1wF1OpPS5JpTaKv2oFGZ9KDXsXkJgISQWVVA2XxMWHO++HNQ9gMLv3oj1nPOisjFo
         +Qcd8dvIt+cpo/ENgeXWjBIhLB2u0CvQKVb8W4tVqxShH7I90TGWq+8ARd1GmqIVvkOq
         hHzDasNcOicrESHXuzbThmIY3sOZFM+4oqBMjGGtRkaCj+0XJqY8vCixHnEte6cB+mTg
         ko6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=24xHs/c9+Vn16SJ80N4lzJM1aJdYpt55ltlqUdwqHiM=;
        b=dBre84uIXDoOVVb9y8As/O0jGZ2lnxMU7bg+4IC61wJuwfit5TSwiPVUrFrXu/qDDG
         8Q9tukqFeTp/UnlWbnepbDAn1bldiDKzT/M5Tuq6+JftnDoMI+wnRiY0utgXsGMAMA7t
         B4FYmCgKE/G2hrbnDxgUnQ8u+L83IoOedvCeA5T5IehyPFmfdIfYdH1jJ1i7GMlbEQG2
         cFu+2qB4vO7+qmOom59cDXyyUDMcF69KPAI9syn1ojfQqsX93r0P5We+R2nuZbP5U1Dw
         vGxcJTQooy7QPVGJ8m5Po5dYuXvmkHqdEwzsi9IfSFWXmZHJZTm2lL9HaRsotUjloYQv
         3/1Q==
X-Gm-Message-State: AOAM530jMgUeYtyuuX4q+NaZUz6sE4ivSch2uZjK6Vie82cMx27cknWV
        wDAIr39fX7h/+o2NMdSlMlq/4nzhSz9Zd5pG
X-Google-Smtp-Source: ABdhPJydfIwNrfnLYpzRXfkHv1vSE7Dm7d9+TjuXhyGEKX4kxaKS44Tuor1padPABacZRVuMCVduYg==
X-Received: by 2002:a17:90a:e291:: with SMTP id d17mr25040930pjz.42.1621863536924;
        Mon, 24 May 2021 06:38:56 -0700 (PDT)
Received: from vessel.. ([103.242.196.149])
        by smtp.gmail.com with ESMTPSA id n69sm4876274pfd.132.2021.05.24.06.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:38:56 -0700 (PDT)
From:   Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        wanghai38@huawei.com
Cc:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] net: appletalk: cops: Fix data race in cops_probe1
Date:   Mon, 24 May 2021 19:07:12 +0530
Message-Id: <20210524133712.15720-1-saubhik.mukherjee@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In cops_probe1(), there is a write to dev->base_addr after requesting an
interrupt line and registering the interrupt handler cops_interrupt().
The handler might be called in parallel to handle an interrupt.
cops_interrupt() tries to read dev->base_addr leading to a potential
data race. So write to dev->base_addr before calling request_irq().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
---
 drivers/net/appletalk/cops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index ba8e70a8e312..6b12ce822e51 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -327,6 +327,8 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			break;
 	}
 
+	dev->base_addr = ioaddr;
+
 	/* Reserve any actual interrupt. */
 	if (dev->irq) {
 		retval = request_irq(dev->irq, cops_interrupt, 0, dev->name, dev);
@@ -334,8 +336,6 @@ static int __init cops_probe1(struct net_device *dev, int ioaddr)
 			goto err_out;
 	}
 
-	dev->base_addr = ioaddr;
-
         lp = netdev_priv(dev);
         spin_lock_init(&lp->lock);
 
-- 
2.30.2

