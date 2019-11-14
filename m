Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452A9FCAD5
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 17:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfKNQhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 11:37:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8434 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbfKNQhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 11:37:21 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAEGTeBN015002
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 08:37:20 -0800
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w8qbvvx5c-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 08:37:20 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 08:37:17 -0800
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id 90FBA6286EC5; Thu, 14 Nov 2019 08:37:15 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <kernel-team@fb.com>, <brouer@redhat.com>,
        <ilias.apalodimas@linaro.org>
Smtp-Origin-Cluster: vll1c12
Subject: [net-next PATCH v2 2/2] page_pool: remove hold/release count from tracepoints
Date:   Thu, 14 Nov 2019 08:37:15 -0800
Message-ID: <20191114163715.4184099-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191114163715.4184099-1-jonathan.lemon@gmail.com>
References: <20191114163715.4184099-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_05:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1034 adultscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911140149
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the last page is released from the page pool, it is possible
that the delayed removal thread sees inflight == 0, and frees the
pool.  While the freed pointer is only copied by the tracepoint
and not dereferenced, it really isn't correct.  Avoid this case by
reporting the page release before releasing the page.

This also removes a second atomic operation from the release path.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/trace/events/page_pool.h | 24 ++++++++++--------------
 net/core/page_pool.c             |  8 +++++---
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
index 47b5ee880aa9..0adf9aed9f5b 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -35,50 +35,46 @@ TRACE_EVENT(page_pool_inflight,
 	  __entry->pool, __entry->inflight, __entry->hold, __entry->release)
 );
 
-TRACE_EVENT(page_pool_state_release,
+TRACE_EVENT(page_pool_page_release,
 
 	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 release),
+		 const struct page *page)
 
-	TP_ARGS(pool, page, release),
+	TP_ARGS(pool, page),
 
 	TP_STRUCT__entry(
 		__field(const struct page_pool *,	pool)
 		__field(const struct page *,		page)
-		__field(u32,				release)
 	),
 
 	TP_fast_assign(
 		__entry->pool		= pool;
 		__entry->page		= page;
-		__entry->release	= release;
 	),
 
-	TP_printk("page_pool=%p page=%p release=%u",
-		  __entry->pool, __entry->page, __entry->release)
+	TP_printk("page_pool=%p page=%p",
+		  __entry->pool, __entry->page)
 );
 
-TRACE_EVENT(page_pool_state_hold,
+TRACE_EVENT(page_pool_page_hold,
 
 	TP_PROTO(const struct page_pool *pool,
-		 const struct page *page, u32 hold),
+		 const struct page *page),
 
-	TP_ARGS(pool, page, hold),
+	TP_ARGS(pool, page),
 
 	TP_STRUCT__entry(
 		__field(const struct page_pool *,	pool)
 		__field(const struct page *,		page)
-		__field(u32,				hold)
 	),
 
 	TP_fast_assign(
 		__entry->pool	= pool;
 		__entry->page	= page;
-		__entry->hold	= hold;
 	),
 
-	TP_printk("page_pool=%p page=%p hold=%u",
-		  __entry->pool, __entry->page, __entry->hold)
+	TP_printk("page_pool=%p page=%p",
+		  __entry->pool, __entry->page)
 );
 
 #endif /* _TRACE_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index bfe96326335d..1e66341fdac8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -163,7 +163,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 	/* Track how many pages are held 'in-flight' */
 	pool->pages_state_hold_cnt++;
 
-	trace_page_pool_state_hold(pool, page, pool->pages_state_hold_cnt);
+	trace_page_pool_page_hold(pool, page);
 
 	/* When page just alloc'ed is should/must have refcnt 1. */
 	return page;
@@ -222,9 +222,11 @@ static void __page_pool_clean_page(struct page_pool *pool,
 			     DMA_ATTR_SKIP_CPU_SYNC);
 	page->dma_addr = 0;
 skip_dma_unmap:
+	trace_page_pool_page_release(pool, page);
+	/* This may be the last page returned, releasing the pool, so
+	 * it is not safe to reference pool afterwards.
+	 */
 	atomic_inc(&pool->pages_state_release_cnt);
-	trace_page_pool_state_release(pool, page,
-			      atomic_read(&pool->pages_state_release_cnt));
 }
 
 /* unmap the page and clean our state */
-- 
2.17.1

