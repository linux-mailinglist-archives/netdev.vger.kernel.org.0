Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D73B919F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbhGAM34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:29:56 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9334 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbhGAM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:29:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GFy6F2RBTz74M0;
        Thu,  1 Jul 2021 20:23:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
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
Subject: [PATCH net-next v3 3/3] ptr_ring: add barrier to ensure the visiblity of r->queue[]
Date:   Thu, 1 Jul 2021 20:26:42 +0800
Message-ID: <1625142402-64945-4-git-send-email-linyunsheng@huawei.com>
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

After r->consumer_head is updated in __ptr_ring_discard_one(),
r->queue[r->consumer_head] is already cleared in the previous
round of __ptr_ring_discard_one(). But there is no guarantee
other thread will see the r->queue[r->consumer_head] being
NULL because there is no explicit barrier between r->queue[]
clearing and r->consumer_head updating.

So add two explicit barrier to make sure r->queue[] cleared in
__ptr_ring_discard_one() to be visible to other cpu, mainly to
make sure the cpu calling the __ptr_ring_empty() will see the
correct r->queue[r->consumer_head].

Hopefully the previous and this patch have ensured the correct
visibility of r->queue[], so update the comment accordingly
about __ptr_ring_empty().

Tested using the "perf stat -r 1000 ./ptr_ring_test -s 1000 -m 1
-N 100000000", comparing the elapsed time:

 arch     unpatched           patched       improvement
arm64    1.888224 sec      1.893673 sec      -0.2%
 X86      2.5422  sec       2.5587 sec       -0.6%

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 include/linux/ptr_ring.h | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
index db9c282..d78aab8 100644
--- a/include/linux/ptr_ring.h
+++ b/include/linux/ptr_ring.h
@@ -178,15 +178,11 @@ static inline void *__ptr_ring_peek(struct ptr_ring *r)
  *
  * NB: This is only safe to call if ring is never resized.
  *
- * However, if some other CPU consumes ring entries at the same time, the value
- * returned is not guaranteed to be correct.
- *
- * In this case - to avoid incorrectly detecting the ring
- * as empty - the CPU consuming the ring entries is responsible
- * for either consuming all ring entries until the ring is empty,
- * or synchronizing with some other CPU and causing it to
- * re-test __ptr_ring_empty and/or consume the ring enteries
- * after the synchronization point.
+ * caller might need to use the smp_rmb() to pair with smp_wmb()
+ * or smp_store_release() in __ptr_ring_discard_one() and smp_wmb()
+ * in __ptr_ring_produce() to ensure correct ordering between
+ * __ptr_ring_empty() checking and subsequent operation after
+ * __ptr_ring_empty() checking.
  *
  * Note: callers invoking this in a loop must use a compiler barrier,
  * for example cpu_relax().
@@ -274,7 +270,12 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 
 		if (unlikely(consumer_head >= r->size)) {
 			r->consumer_tail = 0;
-			WRITE_ONCE(r->consumer_head, 0);
+
+			/* Make sure r->queue[0] ~ r->queue[r->consumer_tail]
+			 * cleared in previous __ptr_ring_discard_one() is
+			 * visible to other cpu.
+			 */
+			smp_store_release(&r->consumer_head, 0);
 		} else {
 			r->consumer_tail = consumer_head;
 			WRITE_ONCE(r->consumer_head, consumer_head);
@@ -288,6 +289,14 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
 		while (likely(--consumer_head >= tail))
 			r->queue[consumer_head] = NULL;
 
+		if (unlikely(!r->consumer_head)) {
+			/* Make sure r->queue[r->consumer_tail] ~
+			 * r->queue[r->size - 1] cleared above is visible to
+			 * other cpu.
+			 */
+			smp_wmb();
+		}
+
 		return;
 	}
 
-- 
2.7.4

