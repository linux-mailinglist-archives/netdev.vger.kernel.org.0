Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDD4E136901
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 09:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgAJI3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 03:29:43 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41807 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgAJI3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 03:29:43 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so799983lfp.8
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 00:29:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aOXdA3Cjuv3cEdllJ4Us7BJBe0usD3J7CREcnQKOEpo=;
        b=L7tPklH0ycJwMT8kngbXsfpxtGdyRutnNBL3sKoNqRIEC9LQIhAg+jcovfb2BipWQi
         kWpRC+Dp0s4+78zV8Qo9lho5EXVmntKyvOO4GFBakFMnzSQMFvastwvsZCYjfB4BevTL
         Ecsh++iHHnUW1cM1eFdrdrTikpBpg04Jg+xAjCMJEEdgb+h2J0GlDz0+QgP9K4+xdg3c
         nYK59lZ0BYFLzFEQJ2tY0ffqy6/hvv5Xm34Qgx7bKaF9Q3QedGlE8nAPaL1mLWj5XZl8
         cpck0M+QfOVYUZTWnO4twQGq5l2lNZ3YqWOrfQWVcWCvsNEKU1X0MIQJTd8RbvS1z8RH
         3VJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aOXdA3Cjuv3cEdllJ4Us7BJBe0usD3J7CREcnQKOEpo=;
        b=oSjVest5XrCeKA/dA6EWxers5PEJrPFZKB3Ny+dYXwRUBk8g2b3N1zaPgu4x3H+V3z
         4zjeZy8LftlbT74j3Xgkxau3XOyVgVTILgV/rQTBC8Gia20xHHUVgkvh0Epb1cQKRsSm
         17v3v9CFBDvZuCxytDNFNteczWA6F13+7vnORWQBLx2ndAJ7Mz9YpArJhznUitHAjK1K
         dJ6hHQzwqeXPvVlLLwCJ+OtNMaqaPVLC7p+asCKovlvVOd0s+JyLa6vQilw2CqOl8onc
         cVGrdTsDEkjk+fhk6DG0/DMiM0orPfaT0UZjMWWxVBgXhpfubN1BiwYb96SzttICzC/9
         R4pQ==
X-Gm-Message-State: APjAAAVnic8j+QWrYJDqrtJfTbe1PS+AceGtjeBHELDtRI7RTzTIuo6s
        5iRzKH//P1MxfDixOQh2rDkEqrIFccUYww==
X-Google-Smtp-Source: APXvYqznB2IT+w819jpdUOOmzn2mp6+PGxr1KaoA0BjBUjprMMsNvtw4+9mAeptD4j/qpgvtKIPI0A==
X-Received: by 2002:a19:f716:: with SMTP id z22mr1559207lfe.14.1578644980877;
        Fri, 10 Jan 2020 00:29:40 -0800 (PST)
Received: from linux.local (c-5ac9225c.014-348-6c756e10.bbcust.telenor.se. [92.34.201.90])
        by smtp.gmail.com with ESMTPSA id g24sm606464lfb.85.2020.01.10.00.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 00:29:40 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH net-next 9/9 v4] net: ethernet: ixp4xx: Use parent dev for DMA pool
Date:   Fri, 10 Jan 2020 09:28:37 +0100
Message-Id: <20200110082837.11473-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200110082837.11473-1-linus.walleij@linaro.org>
References: <20200110082837.11473-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the netdevice struct device .parent field when calling
dma_pool_create(): the .dma_coherent_mask and .dma_mask
pertains to the bus device on the hardware (platform)
bus in this case, not the struct device inside the network
device. This makes the pool allocation work.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Drop a stable tag and rebubmit.
ChangeLog v2->v3:
- Rebased on v5.5-rc1
ChangeLog v1->v2:
- Rebase with the rest of the series.
- Tag for stable, this is pretty serious.
- I have no real idea when this stopped working.
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ee45215c4ba4..269596c15133 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1086,7 +1086,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
+		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
-- 
2.21.0

