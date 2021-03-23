Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927CE346272
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 16:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232613AbhCWPKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 11:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232675AbhCWPKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 11:10:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1634619C2;
        Tue, 23 Mar 2021 15:09:59 +0000 (UTC)
Subject: [PATCH 1/2] SUNRPC: Set rq_page_end differently
From:   Chuck Lever <chuck.lever@oracle.com>
To:     mgorman@techsingularity.net
Cc:     brouer@redhat.com, vbabka@suse.cz, akpm@linux-foundation.org,
        hch@infradead.org, alexander.duyck@gmail.com, willy@infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-nfs@vger.kernel.org
Date:   Tue, 23 Mar 2021 11:09:59 -0400
Message-ID: <161651219896.3977.8207251440172510810.stgit@klimt.1015granger.net>
In-Reply-To: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
References: <161650953543.3977.9991115610287676892.stgit@klimt.1015granger.net>
User-Agent: StGit/1.0-5-g755c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor:

I'm about to use the loop variable @i for something else.

As far as the "i++" is concerned, that is a post-increment. The
value of @i is not used subsequently, so the increment operator
is unnecessary and can be removed.

Also note that nfsd_read_actor() was renamed nfsd_splice_actor()
by commit cf8208d0eabd ("sendfile: convert nfsd to
splice_direct_to_actor()").

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/sunrpc/svc_xprt.c |    7 +++----
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


