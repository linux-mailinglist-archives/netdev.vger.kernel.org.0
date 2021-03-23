Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEE734695D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbhCWT4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:56:13 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:56541 "EHLO
        outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhCWT4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 15:56:05 -0400
Received: from mail.blacknight.com (pemlinmail02.blacknight.ie [81.17.254.11])
        by outbound-smtp02.blacknight.com (Postfix) with ESMTPS id 3BADBBACBE
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 19:56:04 +0000 (GMT)
Received: (qmail 1909 invoked from network); 23 Mar 2021 19:56:04 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Mar 2021 19:56:03 -0000
Date:   Tue, 23 Mar 2021 19:56:02 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     brouer@redhat.com, vbabka@suse.cz, akpm@linux-foundation.org,
        hch@infradead.org, alexander.duyck@gmail.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 2/2] SUNRPC: Refresh rq_pages using a bulk page allocator
Message-ID: <20210323195602.GO3697@techsingularity.net>
References: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
 <161651220579.3977.8959177746864957646.stgit@klimt.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <161651220579.3977.8959177746864957646.stgit@klimt.1015granger.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 11:10:05AM -0400, Chuck Lever wrote:
> Reduce the rate at which nfsd threads hammer on the page allocator.
> This improves throughput scalability by enabling the threads to run
> more independently of each other.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

I've picked up the series and merged the leader with the first patch
because I think the array vs list data is interesting but I did change
the patch.

> +	for (;;) {
> +		filled = alloc_pages_bulk_array(GFP_KERNEL, pages,
> +						rqstp->rq_pages);
> +		/* We assume that if the next array element is populated,
> +		 * all the following elements are as well, thus we're done. */
> +		if (filled == pages || rqstp->rq_pages[filled])
> +			break;
> +

I altered this check because the implementation now returns a useful
index. I know I had concerns about this but while the implementation
cost is higher, the caller needs less knowledge of alloc_bulk_pages
implementation. It might be unfortunate if new users all had to have
their own optimisations around hole management so lets keep it simpler
to start with.

Version current in my tree is below but also available in 

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v6r5

---8<---
SUNRPC: Refresh rq_pages using a bulk page allocator

From: Chuck Lever <chuck.lever@oracle.com>

Reduce the rate at which nfsd threads hammer on the page allocator.
This improves throughput scalability by enabling the threads to run
more independently of each other.

[mgorman: Update interpretation of alloc_pages_bulk return value]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/sunrpc/svc_xprt.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 609bda97d4ae..0c27c3291ca1 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -643,30 +643,29 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
 	struct xdr_buf *arg = &rqstp->rq_arg;
-	int pages;
-	int i;
+	unsigned long pages, filled;
 
-	/* now allocate needed pages.  If we get a failure, sleep briefly */
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
-		pr_warn_once("svc: warning: pages=%u > RPCSVC_MAXPAGES=%lu\n",
+		pr_warn_once("svc: warning: pages=%lu > RPCSVC_MAXPAGES=%lu\n",
 			     pages, RPCSVC_MAXPAGES);
 		/* use as many pages as possible */
 		pages = RPCSVC_MAXPAGES;
 	}
-	for (i = 0; i < pages ; i++)
-		while (rqstp->rq_pages[i] == NULL) {
-			struct page *p = alloc_page(GFP_KERNEL);
-			if (!p) {
-				set_current_state(TASK_INTERRUPTIBLE);
-				if (signalled() || kthread_should_stop()) {
-					set_current_state(TASK_RUNNING);
-					return -EINTR;
-				}
-				schedule_timeout(msecs_to_jiffies(500));
-			}
-			rqstp->rq_pages[i] = p;
+
+	for (;;) {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, pages,
+						rqstp->rq_pages);
+		if (filled == pages)
+			break;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (signalled() || kthread_should_stop()) {
+			set_current_state(TASK_RUNNING);
+			return -EINTR;
 		}
+		schedule_timeout(msecs_to_jiffies(500));
+	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
