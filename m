Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919553D4BD
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 19:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406761AbfFKR6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 13:58:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35190 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406750AbfFKR6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 13:58:50 -0400
Received: by mail-pl1-f195.google.com with SMTP id p1so5448313plo.2;
        Tue, 11 Jun 2019 10:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7O7Ru3+l0O74nsHSw3FBczx/b+MRdjv8EnNhf40gnd0=;
        b=UMYNlL1JStLpTHwOS2NiKeg51hIerdo4Zd3UgAz+ypA5DvTYyj8rTf1XCvbQAi4k2c
         /lMNDLF4CoFMIRkzKdfalIJm1fKrPhLsHu183fANxaqoHyb8pzP47DOJl++biJWHIEU5
         h3VWtbexf1/ldnGwAbF5UnMFXm4gPPZ8L+9MDMi1l7jJx5einN1e70s0xGEB+D8JLsfT
         jysbQ5FsIgolc/Ke8vsEYlNZwtFn3VzzWg5IVntUHZZ6ATjjXPt6v4w5vzjixEyzSg3j
         jQt5BC32PWnOjw1O/xXO4932ZBf23eNWWUMHCuQBalBUsOJ9pr3+reTbPcbBlYJOCp7W
         rXjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7O7Ru3+l0O74nsHSw3FBczx/b+MRdjv8EnNhf40gnd0=;
        b=ud+ukIhiZfCHrhEumGhEA10CPZBBFznPCPbImdqh6bBiGgpjxme/sETrDfKk+/2pa2
         L/klVX84YNRFKqe828rl/V5KpSHIzhVTT0KEl1rDqbzqe3/oqwfejlkZqI4bzyGxQzYC
         6SSQ6HhcjcXgClP42USG3SNkL3/Tjxdfe+shtZ5r3kjZgYPXUe8WtG9hbtZU2kdMtM/q
         Z4+xv0on1lk8jGMU8C43Jw4HZEvULsM86FqM7S8SPt7W2/+2e5pJGfIycBsGF+gMsePf
         oZf30XbLy9vh8ib66XKeJI0A8vRiwo96myeBPOzlt7tOcVwGnjyTx8aKA7ejJCjMaiEZ
         mItw==
X-Gm-Message-State: APjAAAW/aLT7pyKaZSwPMGIPsfxGbS+jyMRJr+Bp/SxyzU9oWkEyWrcY
        8kW1qDFmkYtaj+Et+J1sKsASy/hy
X-Google-Smtp-Source: APXvYqyiQwe71OfRqbIpE0WEbsjZnhVJzlFBUwrbKVsHtWtIyzZS9x7MotQhzQpxZuCnEGiRlw4yyA==
X-Received: by 2002:a17:902:106:: with SMTP id 6mr13857570plb.64.1560275928967;
        Tue, 11 Jun 2019 10:58:48 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s24sm15991182pfh.133.2019.06.11.10.58.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 11 Jun 2019 10:58:46 -0700 (PDT)
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
Subject: [PATCH 2/2] swiotlb: Return consistent SWIOTLB segments/nr_tbl
Date:   Tue, 11 Jun 2019 10:58:25 -0700
Message-Id: <20190611175825.572-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190611175825.572-1-f.fainelli@gmail.com>
References: <20190611175825.572-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a specifically contrived memory layout where there is no physical
memory available to the kernel below the 4GB boundary, we will fail to
perform the initial swiotlb_init() call and set no_iotlb_memory to true.

There are drivers out there that call into swiotlb_nr_tbl() to determine
whether they can use the SWIOTLB. With the right DMA_BIT_MASK() value
for these drivers (say 64-bit), they won't ever need to hit
swiotlb_tbl_map_single() so this can go unoticed and we would be
possibly lying about those drivers.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 kernel/dma/swiotlb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index b2b5c5df273c..e906ef2e6315 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -129,15 +129,17 @@ setup_io_tlb_npages(char *str)
 }
 early_param("swiotlb", setup_io_tlb_npages);
 
+static bool no_iotlb_memory;
+
 unsigned long swiotlb_nr_tbl(void)
 {
-	return io_tlb_nslabs;
+	return unlikely(no_iotlb_memory) ? 0 : io_tlb_nslabs;
 }
 EXPORT_SYMBOL_GPL(swiotlb_nr_tbl);
 
 unsigned int swiotlb_max_segment(void)
 {
-	return max_segment;
+	return unlikely(no_iotlb_memory) ? 0 : max_segment;
 }
 EXPORT_SYMBOL_GPL(swiotlb_max_segment);
 
@@ -160,8 +162,6 @@ unsigned long swiotlb_size_or_default(void)
 	return size ? size : (IO_TLB_DEFAULT_SIZE);
 }
 
-static bool no_iotlb_memory;
-
 void swiotlb_print_info(void)
 {
 	unsigned long bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-- 
2.17.1

