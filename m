Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F6F2C234F
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 11:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732284AbgKXKxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 05:53:15 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7977 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731944AbgKXKxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 05:53:14 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgLTN6W6Wzhd5x;
        Tue, 24 Nov 2020 18:52:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 18:53:02 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <peterz@infradead.org>, <mingo@redhat.com>, <will@kernel.org>,
        <viro@zeniv.linux.org.uk>, <kyk.segfault@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
Subject: [PATCH net-next v3 1/2] lockdep: Introduce in_softirq lockdep assert
Date:   Tue, 24 Nov 2020 18:49:28 +0800
Message-ID: <1606214969-97849-2-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1606214969-97849-1-git-send-email-linyunsheng@huawei.com>
References: <1606214969-97849-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current semantic for napi_consume_skb() is that caller need
to provide non-zero budget when calling from NAPI context, and
breaking this semantic will cause hard to debug problem, because
_kfree_skb_defer() need to run in atomic context in order to push
the skb to the particular cpu' napi_alloc_cache atomically.

So add the lockdep_assert_in_softirq() to assert when the running
context is not in_softirq, in_softirq means softirq is serving or
BH is disabled, which has a ambiguous semantics due to the BH
disabled confusion, so add a comment to emphasize that.

And the softirq context can be interrupted by hard IRQ or NMI
context, lockdep_assert_in_softirq() need to assert about hard
IRQ or NMI context too.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
---
V3: add comment to emphasize the ambiguous semantics.
---
 include/linux/lockdep.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index f559487..8d60f46 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -594,6 +594,13 @@ do {									\
 		      this_cpu_read(hardirqs_enabled)));		\
 } while (0)
 
+/* Much like in_softirq() - semantics are ambiguous, use carefully. */
+#define lockdep_assert_in_softirq()					\
+do {									\
+	WARN_ON_ONCE(__lockdep_enabled			&&		\
+		     (!in_softirq() || in_irq() || in_nmi()));		\
+} while (0)
+
 #else
 # define might_lock(lock) do { } while (0)
 # define might_lock_read(lock) do { } while (0)
@@ -605,6 +612,7 @@ do {									\
 
 # define lockdep_assert_preemption_enabled() do { } while (0)
 # define lockdep_assert_preemption_disabled() do { } while (0)
+# define lockdep_assert_in_softirq() do { } while (0)
 #endif
 
 #ifdef CONFIG_PROVE_RAW_LOCK_NESTING
-- 
2.8.1

