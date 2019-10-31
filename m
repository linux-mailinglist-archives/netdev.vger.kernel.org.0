Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54A56EAF3D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 12:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfJaLzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 07:55:12 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55330 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfJaLzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 07:55:11 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iQ92U-0002qR-OH; Thu, 31 Oct 2019 12:54:54 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 60C691C0482;
        Thu, 31 Oct 2019 12:54:54 +0100 (CET)
Date:   Thu, 31 Oct 2019 11:54:54 -0000
From:   "tip-bot2 for Paul E. McKenney" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: core/rcu] net/core: Replace rcu_swap_protected() with
 rcu_replace_pointer()
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <157252289414.29376.17980810515086127468.tip-bot2@tip-bot2>
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

Commit-ID:     e3f0d761fcaec5d445c9280d6e09087dc32828d2
Gitweb:        https://git.kernel.org/tip/e3f0d761fcaec5d445c9280d6e09087dc32828d2
Author:        Paul E. McKenney <paulmck@kernel.org>
AuthorDate:    Mon, 23 Sep 2019 15:42:28 -07:00
Committer:     Paul E. McKenney <paulmck@kernel.org>
CommitterDate: Wed, 30 Oct 2019 08:45:26 -07:00

net/core: Replace rcu_swap_protected() with rcu_replace_pointer()

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace_pointer() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
[ paulmck: From rcu_replace() to rcu_replace_pointer() per Ingo Molnar. ]
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jiri Pirko <jiri@mellanox.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ido Schimmel <idosch@mellanox.com>
Cc: Petr Machata <petrm@mellanox.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: <netdev@vger.kernel.org>
---
 net/core/dev.c            | 4 ++--
 net/core/sock_reuseport.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed41..c5d8882 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1288,8 +1288,8 @@ int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 	}
 
 	mutex_lock(&ifalias_mutex);
-	rcu_swap_protected(dev->ifalias, new_alias,
-			   mutex_is_locked(&ifalias_mutex));
+	new_alias = rcu_replace_pointer(dev->ifalias, new_alias,
+					mutex_is_locked(&ifalias_mutex));
 	mutex_unlock(&ifalias_mutex);
 
 	if (new_alias)
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index f3ceec9..f19f179 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -356,8 +356,8 @@ int reuseport_detach_prog(struct sock *sk)
 	spin_lock_bh(&reuseport_lock);
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
-	rcu_swap_protected(reuse->prog, old_prog,
-			   lockdep_is_held(&reuseport_lock));
+	old_prog = rcu_replace_pointer(reuse->prog, old_prog,
+				       lockdep_is_held(&reuseport_lock));
 	spin_unlock_bh(&reuseport_lock);
 
 	if (!old_prog)
