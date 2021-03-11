Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF43371B7
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhCKLuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:50:03 -0500
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:40765 "EHLO
        outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232821AbhCKLt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 06:49:58 -0500
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp01.blacknight.com (Postfix) with ESMTPS id 2F7A5C4ABA
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 11:49:36 +0000 (GMT)
Received: (qmail 21560 invoked from network); 11 Mar 2021 11:49:36 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 11 Mar 2021 11:49:36 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 3/5] SUNRPC: Refresh rq_pages using a bulk page allocator
Date:   Thu, 11 Mar 2021 11:49:33 +0000
Message-Id: <20210311114935.11379-4-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311114935.11379-1-mgorman@techsingularity.net>
References: <20210311114935.11379-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

Reduce the rate at which nfsd threads hammer on the page allocator.
This improve throughput scalability by enabling the threads to run
more independently of each other.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/sunrpc/svc_xprt.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index cfa7e4776d0e..38a8d6283801 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -642,11 +642,12 @@ static void svc_check_conn_limits(struct svc_serv *serv)
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
+	unsigned long needed;
 	struct xdr_buf *arg;
+	struct page *page;
 	int pages;
 	int i;
 
-	/* now allocate needed pages.  If we get a failure, sleep briefly */
 	pages = (serv->sv_max_mesg + 2 * PAGE_SIZE) >> PAGE_SHIFT;
 	if (pages > RPCSVC_MAXPAGES) {
 		pr_warn_once("svc: warning: pages=%u > RPCSVC_MAXPAGES=%lu\n",
@@ -654,19 +655,28 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
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
+	for (needed = 0, i = 0; i < pages ; i++)
+		if (!rqstp->rq_pages[i])
+			needed++;
+	if (needed) {
+		LIST_HEAD(list);
+
+retry:
+		alloc_pages_bulk(GFP_KERNEL, needed, &list);
+		for (i = 0; i < pages; i++) {
+			if (!rqstp->rq_pages[i]) {
+				page = list_first_entry_or_null(&list,
+								struct page,
+								lru);
+				if (unlikely(!page))
+					goto empty_list;
+				list_del(&page->lru);
+				rqstp->rq_pages[i] = page;
+				needed--;
 			}
-			rqstp->rq_pages[i] = p;
 		}
+	}
 	rqstp->rq_page_end = &rqstp->rq_pages[pages];
 	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
@@ -681,6 +691,15 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 	arg->len = (pages-1)*PAGE_SIZE;
 	arg->tail[0].iov_len = 0;
 	return 0;
+
+empty_list:
+	set_current_state(TASK_INTERRUPTIBLE);
+	if (signalled() || kthread_should_stop()) {
+		set_current_state(TASK_RUNNING);
+		return -EINTR;
+	}
+	schedule_timeout(msecs_to_jiffies(500));
+	goto retry;
 }
 
 static bool
-- 
2.26.2

