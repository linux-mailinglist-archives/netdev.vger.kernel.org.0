Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52353346275
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhCWPKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232717AbhCWPKH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 11:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84136619C4;
        Tue, 23 Mar 2021 15:10:06 +0000 (UTC)
Subject: [PATCH 2/2] SUNRPC: Refresh rq_pages using a bulk page allocator
From:   Chuck Lever <chuck.lever@oracle.com>
To:     mgorman@techsingularity.net
Cc:     brouer@redhat.com, vbabka@suse.cz, akpm@linux-foundation.org,
        hch@infradead.org, alexander.duyck@gmail.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org
Date:   Tue, 23 Mar 2021 11:10:05 -0400
Message-ID: <161651220579.3977.8959177746864957646.stgit@klimt.1015granger.net>
In-Reply-To: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
References: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
User-Agent: StGit/1.0-5-g755c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce the rate at which nfsd threads hammer on the page allocator.
This improves throughput scalability by enabling the threads to run
more independently of each other.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/svc_xprt.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 609bda97d4ae..d2792b2bf006 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -643,30 +643,31 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
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
+		/* We assume that if the next array element is populated,
+		 * all the following elements are as well, thus we're done. */
+		if (filled == pages || rqstp->rq_pages[filled])
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
 


