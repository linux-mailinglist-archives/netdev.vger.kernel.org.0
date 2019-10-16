Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0423DA1BE
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395034AbfJPWvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:51:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394402AbfJPWu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:58 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMopGd032591
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:57 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnfbc05yr-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:57 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:30 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id D10104A2BD5E; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 06/10 net-next] page_pool: Add page_pool_keep_page
Date:   Wed, 16 Oct 2019 15:50:24 -0700
Message-ID: <20191016225028.2100206-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_08:2019-10-16,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=2 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1034 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160188
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When releasing a page to the pool, only retain the
page if page_pool_keep_page() returns true.

Do not flush the page pool on node changes, but instead
lazily discard the pages as they are returned.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/page_pool.h |  2 --
 net/core/page_pool.c    | 39 +++++++++++++++++++++++----------------
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index fb13cf6055ff..89bc91294b53 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -227,12 +227,10 @@ static inline bool page_pool_put(struct page_pool *pool)
 }
 
 /* Only safe from napi context or when user guarantees it is thread safe */
-void __page_pool_flush(struct page_pool *pool);
 static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
 {
 	if (unlikely(pool->p.nid != new_nid)) {
 		/* TODO: Add statistics/trace */
-		__page_pool_flush(pool);
 		pool->p.nid = new_nid;
 	}
 }
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 678cf85f273a..ea56823236c5 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -258,6 +258,7 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
 				   struct page *page)
 {
 	int ret;
+
 	/* BH protection not needed if current is serving softirq */
 	if (in_serving_softirq())
 		ret = ptr_ring_produce(&pool->ring, page);
@@ -272,8 +273,8 @@ static bool __page_pool_recycle_into_ring(struct page_pool *pool,
  *
  * Caller must provide appropriate safe context.
  */
-static bool __page_pool_recycle_direct(struct page *page,
-				       struct page_pool *pool)
+static bool __page_pool_recycle_into_cache(struct page *page,
+					   struct page_pool *pool)
 {
 	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
 		return false;
@@ -283,27 +284,35 @@ static bool __page_pool_recycle_direct(struct page *page,
 	return true;
 }
 
+/* Determine whether this page should be kept or returned
+ *
+ * refcnt == 1 means page_pool owns page.
+ */
+static bool page_pool_keep_page(struct page_pool *pool, struct page *page)
+{
+	return page_ref_count(page) == 1 &&
+	       page_to_nid(page) == pool->p.nid &&
+	       !page_is_pfmemalloc(page);
+}
+
 void __page_pool_put_page(struct page_pool *pool,
 			  struct page *page, bool allow_direct)
 {
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
-	 *
-	 * refcnt == 1 means page_pool owns page, and can recycle it.
 	 */
-	if (likely(page_ref_count(page) == 1)) {
+	if (likely(page_pool_keep_page(pool, page))) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
 
 		if (allow_direct && in_serving_softirq())
-			if (__page_pool_recycle_direct(page, pool))
+			if (__page_pool_recycle_into_cache(page, pool))
 				return;
 
-		if (!__page_pool_recycle_into_ring(pool, page)) {
-			/* Cache full, fallback to free pages */
-			__page_pool_return_page(pool, page);
-		}
-		return;
+		if (__page_pool_recycle_into_ring(pool, page))
+			return;
+
+		/* Cache full, fallback to return pages */
 	}
 	/* Fallback/non-XDP mode: API user have elevated refcnt.
 	 *
@@ -318,8 +327,7 @@ void __page_pool_put_page(struct page_pool *pool,
 	 * doing refcnt based recycle tricks, meaning another process
 	 * will be invoking put_page.
 	 */
-	__page_pool_clean_page(pool, page);
-	put_page(page);
+	__page_pool_return_page(pool, page);
 }
 EXPORT_SYMBOL(__page_pool_put_page);
 
@@ -373,7 +381,7 @@ void __page_pool_free(struct page_pool *pool)
 }
 EXPORT_SYMBOL(__page_pool_free);
 
-void __page_pool_flush(struct page_pool *pool)
+static void page_pool_flush(struct page_pool *pool)
 {
 	struct page *page;
 
@@ -391,14 +399,13 @@ void __page_pool_flush(struct page_pool *pool)
 	 */
 	__page_pool_empty_ring(pool);
 }
-EXPORT_SYMBOL(__page_pool_flush);
 
 /* Request to shutdown: release pages cached by page_pool, and check
  * for in-flight pages
  */
 bool __page_pool_request_shutdown(struct page_pool *pool)
 {
-	__page_pool_flush(pool);
+	page_pool_flush(pool);
 
 	return __page_pool_safe_to_destroy(pool);
 }
-- 
2.17.1

