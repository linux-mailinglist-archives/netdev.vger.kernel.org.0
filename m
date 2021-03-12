Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21E83391AA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbhCLPoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:44:11 -0500
Received: from outbound-smtp22.blacknight.com ([81.17.249.190]:48495 "EHLO
        outbound-smtp22.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhCLPng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:43:36 -0500
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp22.blacknight.com (Postfix) with ESMTPS id A34BEBAB87
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 15:43:32 +0000 (GMT)
Received: (qmail 19847 invoked from network); 12 Mar 2021 15:43:32 -0000
Received: from unknown (HELO stampy.112glenside.lan) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPA; 12 Mar 2021 15:43:32 -0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Mel Gorman <mgorman@techsingularity.net>
Subject: [PATCH 4/7] SUNRPC: Set rq_page_end differently
Date:   Fri, 12 Mar 2021 15:43:28 +0000
Message-Id: <20210312154331.32229-5-mgorman@techsingularity.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312154331.32229-1-mgorman@techsingularity.net>
References: <20210312154331.32229-1-mgorman@techsingularity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

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
 net/sunrpc/svc_xprt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index dcc50ae54550..cfa7e4776d0e 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -667,8 +667,8 @@ static int svc_alloc_arg(struct svc_rqst *rqstp)
 			}
 			rqstp->rq_pages[i] = p;
 		}
-	rqstp->rq_page_end = &rqstp->rq_pages[i];
-	rqstp->rq_pages[i++] = NULL; /* this might be seen in nfs_read_actor */
+	rqstp->rq_page_end = &rqstp->rq_pages[pages];
+	rqstp->rq_pages[pages] = NULL; /* this might be seen in nfsd_splice_actor() */
 
 	/* Make arg->head point to first page and arg->pages point to rest */
 	arg = &rqstp->rq_arg;
-- 
2.26.2

