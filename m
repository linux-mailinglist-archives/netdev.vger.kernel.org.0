Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3619345C23
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 11:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCWKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 06:44:36 -0400
Received: from outbound-smtp47.blacknight.com ([46.22.136.64]:42391 "EHLO
        outbound-smtp47.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230358AbhCWKo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 06:44:26 -0400
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp47.blacknight.com (Postfix) with ESMTPS id 8F22DFAC15
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 10:44:23 +0000 (GMT)
Received: (qmail 30040 invoked from network); 23 Mar 2021 10:44:23 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Mar 2021 10:44:23 -0000
Date:   Tue, 23 Mar 2021 10:44:21 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 0/3 v5] Introduce a bulk order-0 page allocator
Message-ID: <20210323104421.GK3697@techsingularity.net>
References: <20210322091845.16437-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210322091845.16437-1-mgorman@techsingularity.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:18:42AM +0000, Mel Gorman wrote:
> This series is based on top of Matthew Wilcox's series "Rationalise
> __alloc_pages wrapper" and does not apply to 5.12-rc2. If you want to
> test and are not using Andrew's tree as a baseline, I suggest using the
> following git tree
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9
> 

Jesper and Chuck, would you mind rebasing on top of the following branch
please? 

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r2

The interface is the same so the rebase should be trivial.

Jesper, I'm hoping you see no differences in performance but it's best
to check.

For Chuck, this version will check for holes and scan the remainder of
the array to see if nr_pages are allocated before returning. If the holes
in the array are always at the start (which it should be for sunrpc)
then it should still be a single IRQ disable/enable. Specifically, each
contiguous hole in the array will disable/enable IRQs once. I prototyped
NFS array support and it had a 100% success rate with no sleeps running
dbench over the network with no memory pressure but that's a basic test
on a 10G switch.

The basic patch I used to convert sunrpc from using lists to an array
for testing is as follows;

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 922118968986..0ce33c1742d9 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -642,12 +642,10 @@ static void svc_check_conn_limits(struct svc_serv *serv)
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
-	unsigned long needed;
 	struct xdr_buf *arg;
-	struct page *page;
 	LIST_HEAD(list);
 	int pages;
-	int i;
+	int i = 0;
 
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
@@ -657,29 +655,15 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 		pages = RPCSVC_MAXPAGES;
 	}
 
-	for (needed = 0, i = 0; i < pages ; i++) {
-		if (!rqstp->rq_pages[i])
-			needed++;
-	}
-	i = 0;
-	while (needed) {
-		needed -= alloc_pages_bulk(GFP_KERNEL, needed, &list);
-		for (; i < pages; i++) {
-			if (rqstp->rq_pages[i])
-				continue;
-			page = list_first_entry_or_null(&list, struct page, lru);
-			if (likely(page)) {
-				list_del(&page->lru);
-				rqstp->rq_pages[i] = page;
-				continue;
-			}
+	while (i < pages) {
+		i = alloc_pages_bulk_array(GFP_KERNEL, pages, &rqstp->rq_pages[0]);
+		if (i < pages) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (signalled() || kthread_should_stop()) {
 				set_current_state(TASK_RUNNING);
 				return -EINTR;
 			}
 			schedule_timeout(msecs_to_jiffies(500));
-			break;
 		}
 	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];

-- 
Mel Gorman
SUSE Labs
