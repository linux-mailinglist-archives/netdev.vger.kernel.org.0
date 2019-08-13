Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD66C8BFD4
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfHMRpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:45:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfHMRpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:45:14 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DHibZE004179
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:45:13 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc13v87s8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:45:12 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 10:45:10 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id B183A1C5717D; Tue, 13 Aug 2019 10:45:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <ttoukan.linux@gmail.com>,
        <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH net-next] page_pool: fix logic in __page_pool_get_cached
Date:   Tue, 13 Aug 2019 10:45:09 -0700
Message-ID: <20190813174509.494723-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130166
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__page_pool_get_cached() will return NULL when the ring is
empty, even if there are pages present in the lookaside cache.

It is also possible to refill the cache, and then return a
NULL page.

Restructure the logic so eliminate both cases.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 net/core/page_pool.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 68510eb869ea..de09a74a39a4 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -82,12 +82,9 @@ EXPORT_SYMBOL(page_pool_create);
 static struct page *__page_pool_get_cached(struct page_pool *pool)
 {
 	struct ptr_ring *r = &pool->ring;
+	bool refill = false;
 	struct page *page;
 
-	/* Quicker fallback, avoid locks when ring is empty */
-	if (__ptr_ring_empty(r))
-		return NULL;
-
 	/* Test for safe-context, caller should provide this guarantee */
 	if (likely(in_serving_softirq())) {
 		if (likely(pool->alloc.count)) {
@@ -95,27 +92,23 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
 			page = pool->alloc.cache[--pool->alloc.count];
 			return page;
 		}
-		/* Slower-path: Alloc array empty, time to refill
-		 *
-		 * Open-coded bulk ptr_ring consumer.
-		 *
-		 * Discussion: the ring consumer lock is not really
-		 * needed due to the softirq/NAPI protection, but
-		 * later need the ability to reclaim pages on the
-		 * ring. Thus, keeping the locks.
-		 */
-		spin_lock(&r->consumer_lock);
-		while ((page = __ptr_ring_consume(r))) {
-			if (pool->alloc.count == PP_ALLOC_CACHE_REFILL)
-				break;
-			pool->alloc.cache[pool->alloc.count++] = page;
-		}
-		spin_unlock(&r->consumer_lock);
-		return page;
+		refill = true;
 	}
 
-	/* Slow-path: Get page from locked ring queue */
-	page = ptr_ring_consume(&pool->ring);
+	/* Quicker fallback, avoid locks when ring is empty */
+	if (__ptr_ring_empty(r))
+		return NULL;
+
+	/* Slow-path: Get page from locked ring queue,
+	 * refill alloc array if requested.
+	 */
+	spin_lock(&r->consumer_lock);
+	page = __ptr_ring_consume(r);
+	if (refill)
+		pool->alloc.count = __ptr_ring_consume_batched(r,
+							pool->alloc.cache,
+							PP_ALLOC_CACHE_REFILL);
+	spin_unlock(&r->consumer_lock);
 	return page;
 }
 
-- 
2.17.1

