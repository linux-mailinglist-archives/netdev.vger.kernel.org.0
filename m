Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEFB346266
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhCWPIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52490 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232688AbhCWPI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 11:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616512108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7Dk+kTaXIBxkfJmBKu6XikBMXUgoktdgDa5FmOR121g=;
        b=DCNnizOGr1mD3hmIQ2ADe1YeF5+vIzvH8jwPoLCMwmeMr6ZvzVesjeVKWk1NGZcQ9BWOG/
        OqzlrGDlFvR+WGQcnnvIg9MvNvxTuUJLODjA1qNAg7XwzU3zb4u3tv1WQJZlUc3VvPc8c4
        wZ8BAES5PqAF3M7HxQXFwSegxPWlGWI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-d0GLNY50MHKwkdaeWWEmNA-1; Tue, 23 Mar 2021 11:08:23 -0400
X-MC-Unique: d0GLNY50MHKwkdaeWWEmNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD5B4612A1;
        Tue, 23 Mar 2021 15:08:21 +0000 (UTC)
Received: from carbon (unknown [10.36.110.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 69805196E3;
        Tue, 23 Mar 2021 15:08:15 +0000 (UTC)
Date:   Tue, 23 Mar 2021 16:08:14 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>, brouer@redhat.com
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323160814.62a248fb@carbon>
In-Reply-To: <20210323104421.GK3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
        <20210323104421.GK3697@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Mar 2021 10:44:21 +0000
Mel Gorman <mgorman@techsingularity.net> wrote:

> On Mon, Mar 22, 2021 at 09:18:42AM +0000, Mel Gorman wrote:
> > This series is based on top of Matthew Wilcox's series "Rationalise
> > __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> > test and are not using Andrew's tree as a baseline, I suggest using the
> > following git tree
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> >   
> 
> Jesper and Chuck, would you mind rebasing on top of the following branch
> please? 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r2
> 
> The interface is the same so the rebase should be trivial.
> 
> Jesper, I'm hoping you see no differences in performance but it's best
> to check.

I will rebase and check again.

The current performance tests that I'm running, I observe that the
compiler layout the code in unfortunate ways, which cause I-cache
performance issues.  I wonder if you could integrate below patch with
your patchset? (just squash it)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

[PATCH] mm: optimize code layout for __alloc_pages_bulk

From: Jesper Dangaard Brouer <brouer@redhat.com>

Looking at perf-report and ASM-code for __alloc_pages_bulk() then the code
activated is suboptimal. The compiler guess wrong and place unlikely code in
the beginning. Due to the use of WARN_ON_ONCE() macro the UD2 asm
instruction is added to the code, which confuse the I-cache prefetcher in
the CPU

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 mm/page_alloc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f60f51a97a7b..88a5c1ce5b87 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5003,10 +5003,10 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	unsigned int alloc_flags;
 	int nr_populated = 0, prep_index = 0;
 
-	if (WARN_ON_ONCE(nr_pages <= 0))
+	if (unlikely(nr_pages <= 0))
 		return 0;
 
-	if (WARN_ON_ONCE(page_list && !list_empty(page_list)))
+	if (unlikely(page_list && !list_empty(page_list)))
 		return 0;
 
 	/* Skip populated array elements. */
@@ -5018,7 +5018,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 		prep_index = nr_populated;
 	}
 
-	if (nr_pages == 1)
+	if (unlikely(nr_pages == 1))
 		goto failed;
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
@@ -5054,7 +5054,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 	 * If there are no allowed local zones that meets the watermarks then
 	 * try to allocate a single page and reclaim if necessary.
 	 */
-	if (!zone)
+	if (unlikely(!zone))
 		goto failed;
 
 	/* Attempt the batch allocation */
@@ -5075,7 +5075,7 @@ int __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
 
 		page = __rmqueue_pcplist(zone, ac.migratetype, alloc_flags,
 								pcp, pcp_list);
-		if (!page) {
+		if (unlikely(!page)) {
 			/* Try and get at least one page */
 			if (!nr_populated)
 				goto failed_irq;

