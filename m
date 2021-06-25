Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18EE3B3B20
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhFYDVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:21:50 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:8322 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbhFYDVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:21:49 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GB2F01nZfz7202;
        Fri, 25 Jun 2021 11:15:16 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:24 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:19:24 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty() checking more reliable
Date:   Fri, 25 Jun 2021 11:18:56 +0800
Message-ID: <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently r->queue[] is cleared after r->consumer_head is moved
forward, which makes the __ptr_ring_empty() checking called in
page_pool_refill_alloc_cache() unreliable if the checking is done
after the r->queue clearing and before the consumer_head moving
forward.

Move the r->queue[] clearing after consumer_head moving forward
to make __ptr_ring_empty() checking more reliable.

As a side effect of above change, a consumer_head checking is
avoided for the likely case, and it has noticeable performance
improvement when it is tested using the ptr_ring_test selftest
added in the previous patch.

Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
to test the case of single thread doing both the enqueuing and
dequeuing:

 arch     unpatched           patched       delta
arm64      4648 ms            4464 ms       +3.9%
 X86       2562 ms            2401 ms       +6.2%

Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
to test the case of one thread doing enqueuing and another thread
doing dequeuing concurrently, also known as single-producer/single-
consumer:

 arch      unpatched             patched         delta
arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
 x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
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

