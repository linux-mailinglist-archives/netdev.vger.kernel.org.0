Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7110B268E5C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgINOwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgINOvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 10:51:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2683AC061788;
        Mon, 14 Sep 2020 07:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yG7qWXKBUIxg7RQ3+cci8dpYxavPbFHR4ZLuySoica4=; b=IUgu2bMNuG9D3yRoXTao7ZJ8F0
        bi9cOkVyJbzYiWWHUCJVQtCjtfS1WOJDrcjH+8xfTxuF32oJH+t+iwKJxIfH9cQIx0ubhC0x6cBUH
        E7HyCBzJntz5qzVYF0OebK0LtgVouGMwPJoDrGil30HSYK3dlYRfK91E8XQSpnK7lIE1xiaTNBHi1
        HtcwbVTlCRvy8GbmbHX7caUYl1HISztizQBCIDJTEas1Bg5MzPM/lh98U53IW6e9mpEmHWEg+HM3B
        9zlDbT3UZzNeuyLd8r7YzrHdvg+/kFkPKOdOQ7URC8YirZWGUdedUJvmMj/yaNfps3p7zLv3CJ3EF
        2aJ0nDkg==;
Received: from 089144214092.atnat0023.highway.a1.net ([89.144.214.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHpp0-0001ag-7f; Mon, 14 Sep 2020 14:51:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 02/17] mm: turn alloc_pages into an inline function
Date:   Mon, 14 Sep 2020 16:44:18 +0200
Message-Id: <20200914144433.1622958-3-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914144433.1622958-1-hch@lst.de>
References: <20200914144433.1622958-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prevent a compiler error when a method call alloc_pages is
added (which I plan to for the dma_map_ops).

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/gfp.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 67a0774e080b98..dd2577c5407112 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -550,8 +550,10 @@ extern struct page *alloc_pages_vma(gfp_t gfp_mask, int order,
 #define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
 	alloc_pages_vma(gfp_mask, order, vma, addr, numa_node_id(), true)
 #else
-#define alloc_pages(gfp_mask, order) \
-		alloc_pages_node(numa_node_id(), gfp_mask, order)
+static inline struct page *alloc_pages(gfp_t gfp_mask, unsigned int order)
+{
+	return alloc_pages_node(numa_node_id(), gfp_mask, order);
+}
 #define alloc_pages_vma(gfp_mask, order, vma, addr, node, false)\
 	alloc_pages(gfp_mask, order)
 #define alloc_hugepage_vma(gfp_mask, vma, addr, order) \
-- 
2.28.0

