Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F83D33995E
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbhCLV5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:57:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235424AbhCLV5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 16:57:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 906DF64DAF;
        Fri, 12 Mar 2021 21:57:12 +0000 (UTC)
Subject: [PATCH] SUNRPC: Refresh rq_pages using a bulk page allocator
From:   Chuck Lever <chuck.lever@oracle.com>
To:     mgorman@techsingularity.net
Cc:     akpm@linux-foundation.org, brouer@redhat.com, hch@infradead.org,
        alexander.duyck@gmail.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org
Date:   Fri, 12 Mar 2021 16:57:11 -0500
Message-ID: <161558613209.1366.1492710238067504151.stgit@klimt.1015granger.net>
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
Hi Mel-

This patch replaces patch 5/7 in v4 of your alloc_pages_bulk()
series. It implements code clean-ups suggested by Alexander Duyck.
It builds and has seen some light testing.


 net/sunrpc/svc_xprt.c |   39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 4d58424db009..791ea24159b1 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -661,11 +661,13 @@ static void svc_check_conn_limits(struct svc_serv *serv)
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
+	unsigned long needed;
 	struct xdr_buf *arg;
+	struct page *page;
+	LIST_HEAD(list);
 	int pages;
 	int i;
 
-	/* now allocate needed pages.  If we get a failure, sleep briefly */
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
 		pr_warn_once("svc: warning: pages=%u > RPCSVC_MAXPAGES=%lu\n",
@@ -673,19 +675,32 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
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
+
+	for (needed = 0, i = 0; i < pages ; i++) {
+		if (!rqstp->rq_pages[i])
+			needed++;
+	}
+	i = 0;
+	while (needed) {
+		needed -= alloc_pages_bulk(GFP_KERNEL, 0, needed, &list);
+		for (; i < pages; i++) {
+			if (rqstp->rq_pages[i])
+				continue;
+			page = list_first_entry_or_null(&list, struct page, lru);
+			if (likely(page)) {
+				list_del(&page->lru);
+				rqstp->rq_pages[i] = page;
+				continue;
 			}
-			rqstp->rq_pages[i] = p;
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (signalled() || kthread_should_stop()) {
+				set_current_state(TASK_RUNNING);
+				return -EINTR;
+			}
+			schedule_timeout(msecs_to_jiffies(500));
+			break;
 		}
+	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 


