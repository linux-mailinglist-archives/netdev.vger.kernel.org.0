Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7D3A2A764C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgKEEVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 23:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727923AbgKEEVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:21:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79488C0613CF;
        Wed,  4 Nov 2020 20:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=9ie5em9LXiMFXgTgzhppNmSXBdOqoNkKv8pDhuYEZHw=; b=C5cSq7gYnujcAB6HxXPvl/9R/s
        4JQLaO07G1uAQ/rDCGm+CWGy5w7Zrey4c6FAidhR16KqE2uXmWLZtgfv5HpzjZE9mkaJfWjEErAjh
        DprLKAqRijFyWewLIhB5Q741ZdPjRtrAkLLehal4n6V3CpLu5eT/Rd0qNbH7gZKbwAqzp2Sy6PgeP
        TE5Rk3wnLE5D5TNDdFn4hSifYGswqJrCcF8XNqT7FKzhbMs0aAhM8sgkiN67T23QY9FpW4MBBrXHH
        BDrVbyKyUSHWuTtiHtFCcyMuXWwEWOK6Q3LRIdzHHX315ty5zOgObkllVxhu8e4tXuMHDpwuD40h2
        tbfUlj3w==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kaWmW-0001Od-60; Thu, 05 Nov 2020 04:21:52 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] page_frag: Recover from memory pressure
Date:   Thu,  5 Nov 2020 04:21:40 +0000
Message-Id: <20201105042140.5253-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the machine is under extreme memory pressure, the page_frag allocator
signals this to the networking stack by marking allocations with the
'pfmemalloc' flag, which causes non-essential packets to be dropped.
Unfortunately, even after the machine recovers from the low memory
condition, the page continues to be used by the page_frag allocator,
so all allocations from this page will continue to be dropped.

Fix this by freeing and re-allocating the page instead of recycling it.

Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Cc: Bert Barbe <bert.barbe@oracle.com>
Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>
Cc: SRINIVAS <srinivas.eeda@oracle.com>
Cc: stable@vger.kernel.org
Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/page_alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 778e815130a6..631546ae1c53 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5139,6 +5139,10 @@ void *page_frag_alloc(struct page_frag_cache *nc,
 
 		if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
 			goto refill;
+		if (nc->pfmemalloc) {
+			free_the_page(page, compound_order(page));
+			goto refill;
+		}
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
 		/* if size can vary use size else just use PAGE_SIZE */
-- 
2.28.0

