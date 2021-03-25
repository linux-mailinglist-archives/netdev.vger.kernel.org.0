Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE95349111
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 12:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhCYLoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 07:44:10 -0400
Received: from outbound-smtp13.blacknight.com ([46.22.139.230]:49475 "EHLO
        outbound-smtp13.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230220AbhCYLnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 07:43:43 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp13.blacknight.com (Postfix) with ESMTPS id 0D9E41C35BC
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:43:41 +0000 (GMT)
Received: (qmail 18382 invoked from network); 25 Mar 2021 11:43:40 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 25 Mar 2021 11:43:40 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 6/9] SUNRPC: Set rq_page_end differently
Date:   Thu, 25 Mar 2021 11:42:25 +0000
Message-Id: <20210325114228.27719-7-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325114228.27719-1-mgorman@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

Patch series "SUNRPC consumer for the bulk page allocator"

This patch set and the measurements below are based on yesterday's
bulk allocator series:

git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux.git mm-bulk-rebase-v5r9

The patches change SUNRPC to invoke the array-based bulk allocator
instead of alloc_page().

The micro-benchmark results are promising. I ran a mixture of 256KB
reads and writes over NFSv3. The server's kernel is built with KASAN
enabled, so the comparison is exaggerated but I believe it is still
valid.

I instrumented svc_recv() to measure the latency of each call to
svc_alloc_arg() and report it via a trace point. The following
results are averages across the trace events.

Single page: 25.007 us per call over 532,571 calls
Bulk list:    6.258 us per call over 517,034 calls
Bulk array:   4.590 us per call over 517,442 calls

This patch (of 2)

Refactor:

I'm about to use the loop variable @i for something else.

As far as the "i++" is concerned, that is a post-increment. The
value of @i is not used subsequently, so the increment operator
is unnecessary and can be removed.

Also note that nfsd_read_actor() was renamed nfsd_splice_actor()
by commit cf8208d0eabd ("sendfile: convert nfsd to
splice_direct_to_actor()").

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 net/sunrpc/svc_xprt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 3cdd71a8df1e..609bda97d4ae 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -642,7 +642,7 @@ static void svc_check_conn_limits(struct svc_serv *serv)
 static int svc_alloc_arg(struct svc_rqst *rqstp)
 {
 	struct svc_serv *serv = rqstp->rq_server;
-	struct xdr_buf *arg;
+	struct xdr_buf *arg = &rqstp->rq_arg;
 	int pages;
 	int i;
 
@@ -667,11 +667,10 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 			}
 			rqstp->rq_pages[i] = p;
 		}
-	rqstp->rq_page_end = &rqstp->rq_pages[i];
-	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	rqstp->rq_page_end = &rqstp->rq_pages[pages];
+	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
 	/* Make arg->head point to first page and arg->pages point to rest */
-	arg = &rqstp->rq_arg;
 	arg->head[0].iov_base = page_address(rqstp->rq_pages[0]);
 	arg->head[0].iov_len = PAGE_SIZE;
 	arg->pages = rqstp->rq_pages + 1;
-- 
2.26.2

