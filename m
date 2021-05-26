Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C600391754
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234452AbhEZMbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:31:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6716 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhEZMbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:31:14 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqqtN1Jxkzncdg;
        Wed, 26 May 2021 20:26:04 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 20:29:41 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 20:29:41 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <will@kernel.org>, <peterz@infradead.org>, <paulmck@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <mst@redhat.com>, <brouer@redhat.com>, <jasowang@redhat.com>
Subject: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more reliable
Date:   Wed, 26 May 2021 20:29:33 +0800
Message-ID: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
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

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/ptr_ring.h | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index 808f9d3..f32f052 100644
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
@@ -271,19 +270,28 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 	 */
 	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
 		     consumer_head >= r->size)) {
+		int tail = r->consumer_tail;
+		int head = consumer_head;
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
+		while (likely(--head >= tail))
+			r->queue[head] = NULL;
+
+		return;
 	}
+
 	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
 	WRITE_ONCE(r->consumer_head, consumer_head);
 }
-- 
2.7.4

