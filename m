Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09FF6DA1BB
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 00:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393539AbfJPWuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 18:50:55 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393485AbfJPWuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 18:50:55 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9GMopGW032591
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:54 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnfbc05yr-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 15:50:54 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 16 Oct 2019 15:50:29 -0700
Received: by devvm1828.vll1.facebook.com (Postfix, from userid 172786)
        id C878D4A2BD5A; Wed, 16 Oct 2019 15:50:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
Smtp-Origin-Hostname: devvm1828.vll1.facebook.com
To:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: vll1c12
Subject: [PATCH 04/10 net-next] page_pool: Add API to update numa node and flush page caches
Date:   Wed, 16 Oct 2019 15:50:22 -0700
Message-ID: <20191016225028.2100206-5-jonathan.lemon@gmail.com>
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

From: Saeed Mahameed <saeedm@mellanox.com>

Add page_pool_update_nid() to be called from drivers when they detect
numa node changes.

It will do:
1) Flush the pool's page cache and ptr_ring.
2) Update page pool nid value to start allocating from the new numa
node.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 include/net/page_pool.h | 10 ++++++++++
 net/core/page_pool.c    | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index 2cbcdbdec254..fb13cf6055ff 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -226,4 +226,14 @@ static inline bool page_pool_put(struct page_pool *pool)
 	return refcount_dec_and_test(&pool->user_cnt);
 }
 
+/* Only safe from napi context or when user guarantees it is thread safe */
+void __page_pool_flush(struct page_pool *pool);
+static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
+{
+	if (unlikely(pool->p.nid != new_nid)) {
+		/* TODO: Add statistics/trace */
+		__page_pool_flush(pool);
+		pool->p.nid = new_nid;
+	}
+}
 #endif /* _NET_PAGE_POOL_H */
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 5bc65587f1c4..678cf85f273a 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -373,16 +373,13 @@ void __page_pool_free(struct page_pool *pool)
 }
 EXPORT_SYMBOL(__page_pool_free);
 
-/* Request to shutdown: release pages cached by page_pool, and check
- * for in-flight pages
- */
-bool __page_pool_request_shutdown(struct page_pool *pool)
+void __page_pool_flush(struct page_pool *pool)
 {
 	struct page *page;
 
 	/* Empty alloc cache, assume caller made sure this is
 	 * no-longer in use, and page_pool_alloc_pages() cannot be
-	 * call concurrently.
+	 * called concurrently.
 	 */
 	while (pool->alloc.count) {
 		page = pool->alloc.cache[--pool->alloc.count];
@@ -393,6 +390,15 @@ bool __page_pool_request_shutdown(struct page_pool *pool)
 	 * be in-flight.
 	 */
 	__page_pool_empty_ring(pool);
+}
+EXPORT_SYMBOL(__page_pool_flush);
+
+/* Request to shutdown: release pages cached by page_pool, and check
+ * for in-flight pages
+ */
+bool __page_pool_request_shutdown(struct page_pool *pool)
+{
+	__page_pool_flush(pool);
 
 	return __page_pool_safe_to_destroy(pool);
 }
-- 
2.17.1

