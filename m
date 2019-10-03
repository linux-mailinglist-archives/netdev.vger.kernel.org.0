Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB88C9663
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 03:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbfJCBnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 21:43:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:46572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbfJCBnP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 21:43:15 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5F32245D;
        Thu,  3 Oct 2019 01:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570066994;
        bh=tR2Ftbl9i13HtX5M9bHcSCjGuAffBub91l5STBd040o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZGHP7VrCvyQQJJUIwd9i3qzG/fI/7dsvkeCIWw+P5a8kspjr/mUDHkOn1VhYJ2Aj
         2TLVK8aXsSLhceY5Cd5uHGckiHZQUtXOdQfgxGklTwuHTEtuM1aDmrPKgb9N3vsAH3
         xCZgOR+/imbnLaCY+jfIbWLXqFrbx6xWyRgVaonc=
From:   paulmck@kernel.org
To:     rcu@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        jiangshanlai@gmail.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        fweisbec@gmail.com, oleg@redhat.com, joel@joelfernandes.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH tip/core/rcu 7/9] net/core: Replace rcu_swap_protected() with rcu_replace()
Date:   Wed,  2 Oct 2019 18:43:08 -0700
Message-Id: <20191003014310.13262-7-paulmck@kernel.org>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20191003014153.GA13156@paulmck-ThinkPad-P72>
References: <20191003014153.GA13156@paulmck-ThinkPad-P72>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

This commit replaces the use of rcu_swap_protected() with the more
intuitively appealing rcu_replace() as a step towards removing
rcu_swap_protected().

Link: https://lore.kernel.org/lkml/CAHk-=wiAsJLw1egFEE=Z7-GGtM6wcvtyytXZA1+BHqta4gg6Hw@mail.gmail.com/
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
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
index bf3ed41..41f6936 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1288,8 +1288,8 @@ int dev_set_alias(struct net_device *dev, const char *alias, size_t len)
 	}
 
 	mutex_lock(&ifalias_mutex);
-	rcu_swap_protected(dev->ifalias, new_alias,
-			   mutex_is_locked(&ifalias_mutex));
+	new_alias = rcu_replace(dev->ifalias, new_alias,
+				mutex_is_locked(&ifalias_mutex));
 	mutex_unlock(&ifalias_mutex);
 
 	if (new_alias)
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index f3ceec9..805287b 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -356,8 +356,8 @@ int reuseport_detach_prog(struct sock *sk)
 	spin_lock_bh(&reuseport_lock);
 	reuse = rcu_dereference_protected(sk->sk_reuseport_cb,
 					  lockdep_is_held(&reuseport_lock));
-	rcu_swap_protected(reuse->prog, old_prog,
-			   lockdep_is_held(&reuseport_lock));
+	old_prog = rcu_replace(reuse->prog, old_prog,
+			       lockdep_is_held(&reuseport_lock));
 	spin_unlock_bh(&reuseport_lock);
 
 	if (!old_prog)
-- 
2.9.5

