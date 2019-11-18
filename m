Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651B7100F7B
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 00:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfKRXms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 18:42:48 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:53166 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfKRXms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 18:42:48 -0500
Received: by mail-vk1-f201.google.com with SMTP id x1so9039029vkc.19
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 15:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZyVo0bdAINzGRyi63ByPVDdo5LlzUKIDQNTPQgSmYDA=;
        b=o+JBsJ5dhweFRyw/P6WXcHYM21Ueo41D8Yc5LfAH7h9vT/FQ+tHsjblJkEEKdWLbYa
         XcgY8czWQyi2XBvCsVISeEr494lD231w7r3UzNfkMRqiLQeS8Vv/nOsrtnkozwc1eRh1
         VMqroCikudSP5uI6VWpbI+dz+FWd/SbJbpsVES8SRJ0ni4KWZW/S19TDkI22C0cjJSEU
         u7d2oJBhfxMEhAQYQkH7ye6my6ULYLH95+LRDHj0b9Pd6rZf998Y+smc51hdKI6cV8SS
         HUPgr8enQPz7eE9pypYGCV/hrpDajoJasrlgeFTpS5dDtrtLXFic9RGKTqQ0yFib4TV1
         BzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZyVo0bdAINzGRyi63ByPVDdo5LlzUKIDQNTPQgSmYDA=;
        b=SEQjioMeS+KgS18JGPdES2C4vwBDgZ/glMHQoHn+FMe2JhWGmQOHWrUJKLwi060yEQ
         iSlBXIVwQohCBGuPk5GnvhGd7Vq7f2ZvwgA25bbRPMgweVWWJLiPGWKN3CNurBaiwH8N
         BssywifVqDVo2uY+wCY1SHiV5aNli9NbonnIUPNOJqP/LQVIFC8QzCTu/XcCBgpdXTtl
         S8Z/KczJlXjquilwM8lzldc3v8Fqi7VC8HybCMSt4AWKBbL2gh8rWWr9w8pHq+rMwQYP
         5OHJYJWfZdmO7Arz+9H80Vi1btizEdA0Yq2PdLbJVKM+endUIHSltEv/eHFGfiCKfjpQ
         psmA==
X-Gm-Message-State: APjAAAVUdnQ3Zfd2McBzkyS2AX0g8VoNOZVo1oZCbhSPtf9bM1dt9opl
        cYqOCpBFZAMOXviodpX857Xp3XDgedE48EEriuj99XzfllgjuFpVgOHk7FxpYXbRunDau18pGDM
        shT0nAcnc7Gr+3tIoeYMMvBKmB9kwK2EVs2M6dSo4XD60PFNjOjJEDXLcXVjq/LoYdthz/w==
X-Google-Smtp-Source: APXvYqwnI6UJYWdUkYHztdlPYQna58RuF9BQUxXi954HNQmfEaER3NlNmXicTh0jFtzbADkcgs4vpb82sEysS6g=
X-Received: by 2002:ab0:4a14:: with SMTP id q20mr20018970uae.14.1574120565533;
 Mon, 18 Nov 2019 15:42:45 -0800 (PST)
Date:   Mon, 18 Nov 2019 15:42:40 -0800
Message-Id: <20191118234240.191075-1-adisuresh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net v2] gve: fix dma sync bug where not all pages synced
From:   Adi Suresh <adisuresh@google.com>
To:     netdev@vger.kernel.org
Cc:     Adi Suresh <adisuresh@google.com>,
        Catherine Sullivan <csully@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit had a bug where the last page in the memory range
could not be synced. This change fixes the behavior so that all the
required pages are synced.

Fixes: 9cfeeb5 ("gve: Fixes DMA synchronization")
Signed-off-by: Adi Suresh <adisuresh@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
---
 Changes in v2:
 - Added Fixes tag and reference commit hash of previous commit
 - Moved variable declaration to top of method

 drivers/net/ethernet/google/gve/gve_tx.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 0a9a7ee2a866..f4889431f9b7 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -393,12 +393,13 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
 static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
 				    u64 iov_offset, u64 iov_len)
 {
+	u64 last_page = (iov_offset + iov_len - 1) / PAGE_SIZE;
+	u64 first_page = iov_offset / PAGE_SIZE;
 	dma_addr_t dma;
-	u64 addr;
+	u64 page;
 
-	for (addr = iov_offset; addr < iov_offset + iov_len;
-	     addr += PAGE_SIZE) {
-		dma = page_buses[addr / PAGE_SIZE];
+	for (page = first_page; page <= last_page; page++) {
+		dma = page_buses[page];
 		dma_sync_single_for_device(dev, dma, PAGE_SIZE, DMA_TO_DEVICE);
 	}
 }
-- 
2.24.0.432.g9d3f5f5b63-goog

