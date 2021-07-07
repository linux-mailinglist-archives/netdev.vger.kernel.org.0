Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C966F3BEBFC
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhGGQVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 12:21:46 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55180 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhGGQVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 12:21:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 0F07162BC3;
        Wed,  7 Jul 2021 18:18:43 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 08/11] netfilter: conntrack: Mark access for KCSAN
Date:   Wed,  7 Jul 2021 18:18:41 +0200
Message-Id: <20210707161844.20827-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210707161844.20827-1-pablo@netfilter.org>
References: <20210707161844.20827-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manfred Spraul <manfred@colorfullife.com>

KCSAN detected an data race with ipc/sem.c that is intentional.

As nf_conntrack_lock() uses the same algorithm: Update
nf_conntrack_core as well:

nf_conntrack_lock() contains
  a1) spin_lock()
  a2) smp_load_acquire(nf_conntrack_locks_all).

a1) actually accesses one lock from an array of locks.

nf_conntrack_locks_all() contains
  b1) nf_conntrack_locks_all=true (normal write)
  b2) spin_lock()
  b3) spin_unlock()

b2 and b3 are done for every lock.

This guarantees that nf_conntrack_locks_all() prevents any
concurrent nf_conntrack_lock() owners:
If a thread past a1), then b2) will block until that thread releases
the lock.
If the threat is before a1, then b3)+a1) ensure the write b1) is
visible, thus a2) is guaranteed to see the updated value.

But: This is only the latest time when b1) becomes visible.
It may also happen that b1) is visible an undefined amount of time
before the b3). And thus KCSAN will notice a data race.

In addition, the compiler might be too clever.

Solution: Use WRITE_ONCE().

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 085a11f1eb43..83c52df85870 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -149,7 +149,15 @@ static void nf_conntrack_all_lock(void)
 
 	spin_lock(&nf_conntrack_locks_all_lock);
 
-	nf_conntrack_locks_all = true;
+	/* For nf_contrack_locks_all, only the latest time when another
+	 * CPU will see an update is controlled, by the "release" of the
+	 * spin_lock below.
+	 * The earliest time is not controlled, an thus KCSAN could detect
+	 * a race when nf_conntract_lock() reads the variable.
+	 * WRITE_ONCE() is used to ensure the compiler will not
+	 * optimize the write.
+	 */
+	WRITE_ONCE(nf_conntrack_locks_all, true);
 
 	for (i = 0; i < CONNTRACK_LOCKS; i++) {
 		spin_lock(&nf_conntrack_locks[i]);
-- 
2.20.1

