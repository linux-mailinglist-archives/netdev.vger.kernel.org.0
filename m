Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E231E3D4CB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406748AbfFKR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:58:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43668 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406663AbfFKR6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:58:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id cl9so5425425plb.10;
        Tue, 11 Jun 2019 10:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ee+9T0x4wcDDwKO1LZEEuvczfHl5FqsypJBcT1ds4Ic=;
        b=Z6unNcP5aYq3d39yrOQuNpDQ17oi+lwJzEA1K/Winz1glM+WkvG10oHgVYuOBWeKhl
         oExO615hYL6SpTuUhx6U62i9+nMWIStObqJ2sG867bPtkb7OSr9wMICWfS6wXfcGAxBw
         DvBdRAtjbK+cUqckmzOX9Hk94QArisHPq9gLMFotu0gVNlaPV0kjlEbGHN9a3wuCIoTD
         lMaDOgMzesqJuOGY3QyRzVGSYXC5mTtSaCwp7+vkQKrEz4tZ267eD8xQt7LFfxMsQ8ww
         HcOAM8kpTTfQ+Bdjd6Oll9vpaljc8JJe6NlebZWz5YCgCkXLQkAWO9/eii0YMhLRUJRr
         pBeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ee+9T0x4wcDDwKO1LZEEuvczfHl5FqsypJBcT1ds4Ic=;
        b=XL9nSUshLeXjAqxlHbqmUSuJmZca2163wwtiWXXVVeUUFqRz1o5jpdx6KuGT9ZB5ad
         7LkXwcJqSn+frOiPT/LigYP9BSdEMEQYcyC2d8nB4cY1qfeWKzkWM1WDUDsD8PwnCPYH
         QFWR24hKUI5fhVkRMrrw2ruHLPo//T2q2X24pWWqlV2KwREfA31V0dFJ80oPYs9tuJCA
         VQbNHOp9KV3DSpDd++YrqdfoL6vsVpczL45C7QTyT9kG4g0mAzvLLkgfcKmnXHlHO40+
         2rYa7pWDbUC4P3p/IBf+xWW7vJ7gFgt0FkdEBEiHlGn+oNB26XpolCdiMhZH24BrqxHC
         41RA==
X-Gm-Message-State: APjAAAUsECNrBEiL1MHMeosuwJLPdbqzZUjD/r918rojXcjrHZh2OZWt
        ZW32xL6EopEEbve1iUQ+vRktu86h
X-Google-Smtp-Source: APXvYqx+OdLlga9UNwg+AyI6BfMSL6bzF8jtXGIUFPMokSWdbqun97XxQeLW0Gk2Uqf+MGZCcSL4cg==
X-Received: by 2002:a17:902:f204:: with SMTP id gn4mr58920897plb.3.1560275926216;
        Tue, 11 Jun 2019 10:58:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s24sm15991182pfh.133.2019.06.11.10.58.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 10:58:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        iommu@lists.linux-foundation.org (open list:DMA MAPPING HELPERS),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 1/2] swiotlb: Group identical cleanup in swiotlb_cleanup()
Date:   Tue, 11 Jun 2019 10:58:24 -0700
Message-Id: <20190611175825.572-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611175825.572-1-f.fainelli@gmail.com>
References: <20190611175825.572-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid repeating the zeroing of global swiotlb variables in two locations
and introduce swiotlb_cleanup() to do that.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 kernel/dma/swiotlb.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 13f0cb080a4d..b2b5c5df273c 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -317,6 +317,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	return rc;
 }
 
+static void swiotlb_cleanup(void)
+{
+	io_tlb_end = 0;
+	io_tlb_start = 0;
+	io_tlb_nslabs = 0;
+	max_segment = 0;
+}
+
 int
 swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 {
@@ -367,10 +375,7 @@ swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 	                                                 sizeof(int)));
 	io_tlb_list = NULL;
 cleanup3:
-	io_tlb_end = 0;
-	io_tlb_start = 0;
-	io_tlb_nslabs = 0;
-	max_segment = 0;
+	swiotlb_cleanup();
 	return -ENOMEM;
 }
 
@@ -394,10 +399,7 @@ void __init swiotlb_exit(void)
 		memblock_free_late(io_tlb_start,
 				   PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
-	io_tlb_start = 0;
-	io_tlb_end = 0;
-	io_tlb_nslabs = 0;
-	max_segment = 0;
+	swiotlb_cleanup();
 }
 
 /*
-- 
2.17.1

