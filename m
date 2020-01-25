Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B011494AF
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 11:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgAYKnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 05:43:16 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:44303 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729638AbgAYKnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 05:43:15 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ivIu1-0008VZ-RP; Sat, 25 Jan 2020 11:42:58 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id B3F4D1C1A74;
        Sat, 25 Jan 2020 11:42:48 +0100 (CET)
Date:   Sat, 25 Jan 2020 10:42:48 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] net/tipc: Replace rcu_swap_protected() with
 rcu_replace_pointer()
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        kbuild test robot <lkp@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <157994896855.396.463583645581287836.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the core/rcu branch of tip:

Commit-ID:     1a271ebbfe33a44f61e02d35a2950ab00b32850b
Gitweb:        https://git.kernel.org/tip/1a271ebbfe33a44f61e02d35a2950ab00b32850b
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Mon, 09 Dec 2019 19:13:45 -08:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Thu, 12 Dec 2019 10:19:40 -08:00

net/tipc: Replace rcu_swap_protected() with rcu_replace_pointer()

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
[ paulmck: Updated based on Ying Xue and Tuong Lien Tong feedback. ]
Cc: Jon Maloy <jon.maloy@ericsson.com>
Cc: Ying Xue <ying.xue@windriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <netdev@vger.kernel.org>
Cc: <tipc-discussion@lists.sourceforge.net>
---
 net/tipc/crypto.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 990a872..c8c47fc 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -257,9 +257,6 @@ static char *tipc_key_change_dump(struct tipc_key old, struct tipc_key new,
 #define tipc_aead_rcu_ptr(rcu_ptr, lock)				\
 	rcu_dereference_protected((rcu_ptr), lockdep_is_held(lock))
 
-#define tipc_aead_rcu_swap(rcu_ptr, ptr, lock)				\
-	rcu_swap_protected((rcu_ptr), (ptr), lockdep_is_held(lock))
-
 #define tipc_aead_rcu_replace(rcu_ptr, ptr, lock)			\
 do {									\
 	typeof(rcu_ptr) __tmp = rcu_dereference_protected((rcu_ptr),	\
@@ -1189,7 +1186,7 @@ static bool tipc_crypto_key_try_align(struct tipc_crypto *rx, u8 new_pending)
 
 	/* Move passive key if any */
 	if (key.passive) {
-		tipc_aead_rcu_swap(rx->aead[key.passive], tmp2, &rx->lock);
+		tmp2 = rcu_replace_pointer(rx->aead[key.passive], tmp2, lockdep_is_held(&rx->lock));
 		x = (key.passive - key.pending + new_pending) % KEY_MAX;
 		new_passive = (x <= 0) ? x + KEY_MAX : x;
 	}
