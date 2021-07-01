Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1FF83B919D
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhGAM3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:29:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9442 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236332AbhGAM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:29:52 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GFy7W35R8zZpSZ;
        Thu,  1 Jul 2021 20:24:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v3 2/3] ptr_ring: move r->queue[] clearing after r->consumer_head updating
Date:   Thu, 1 Jul 2021 20:26:41 +0800
Message-ID: <1625142402-64945-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently r->queue[] clearing is done before r->consumer_head
updating, which makes the __ptr_ring_empty() returning false
positive result(the ring is non-empty, but __ptr_ring_empty()
suggest that it is empty) if the checking is done after the
r->queue clearing and before the consumer_head moving forward.

Move the r->queue[] clearing after consumer_head moving forward
to avoid the above case.

As a side effect of above change, a consumer_head checking is
avoided for the likely case, and it has noticeable performance
improvement when it is tested using the ptr_ring_test selftest
added in the previous patch.

Tested using the "perf stat -r 1000 ./ptr_ring_test -s 1000 -m 1
-N 100000000", comparing the elapsed time:

 arch     unpatched           patched       improvement
arm64    2.087205 sec       1.888224 sec      +9.5%
 X86      2.6538 sec         2.5422 sec       +4.2%

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V3: adjust the title and comment log according to disscusion in
    V2, and update performance data using "perf stat -r".
V2: Add performance data.
---
 include/linux/ptr_ring.h | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 808f9d3..db9c282 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
 	 * to work correctly.
 	 */
-	int consumer_head = r->consumer_head;
-	int head = consumer_head++;
+	int consumer_head = r->consumer_head + 1;
 
 	/* Once we have processed enough entries invalidate them in
 	 * the ring all at once so producer can reuse their space in the ring.
@@ -271,19 +270,27 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 	 */
 	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
 		     consumer_head >= r->size)) {
+		int tail = r->consumer_tail;
+
+		if (unlikely(consumer_head >= r->size)) {
+			r->consumer_tail = 0;
+			WRITE_ONCE(r->consumer_head, 0);
+		} else {
+			r->consumer_tail = consumer_head;
+			WRITE_ONCE(r->consumer_head, consumer_head);
+		}
+
 		/* Zero out entries in the reverse order: this way we touch the
 		 * cache line that producer might currently be reading the last;
 		 * producer won't make progress and touch other cache lines
 		 * besides the first one until we write out all entries.
 		 */
-		while (likely(head >= r->consumer_tail))
-			r->queue[head--] = NULL;
-		r->consumer_tail = consumer_head;
-	}
-	if (unlikely(consumer_head >= r->size)) {
-		consumer_head = 0;
-		r->consumer_tail = 0;
+		while (likely(--consumer_head >= tail))
+			r->queue[consumer_head] = NULL;
+
+		return;
 	}
+
 	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
 	WRITE_ONCE(r->consumer_head, consumer_head);
 }
-- 
2.7.4

