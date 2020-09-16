Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D269A26C85C
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgIPSrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:47:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:44358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgIPSqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:16 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FCEE22208;
        Wed, 16 Sep 2020 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281970;
        bh=TidjB1CLdcHX17GrkijsFnb24uaNGbCHwZRDDig+Y9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2h1IaLXpkde6U5QpHfMM0BRR77jj/AELrC+lj88srCPwLmXW+wzgJA08rPiwPbux3
         2qKyU+fnNTuAGlAv6O3X9UBYTrAaSwa7qyi1DUwDz2P93eXDV4Iz84mrp0u9aBwqT6
         TF6rg7ltPV+zZIbreI1xFlhUVv2eRUIVwCD8bdeU=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        jiangshanlai@gmail.com
Subject: [PATCH net-next 7/7] rcu: prevent RCU_LOCKDEP_WARN() from swallowing the condition
Date:   Wed, 16 Sep 2020 11:45:28 -0700
Message-Id: <20200916184528.498184-8-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We run into a unused variable warning in bridge code when
variable is only used inside the condition of
rcu_dereference_protected().

 #define mlock_dereference(X, br) \
	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))

Since on builds with CONFIG_PROVE_RCU=n rcu_dereference_protected()
compiles to nothing the compiler doesn't see the variable use.

Prevent the warning by adding the condition as dead code.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: paulmck@kernel.org
CC: josh@joshtriplett.org
CC: rostedt@goodmis.org
CC: mathieu.desnoyers@efficios.com
CC: joel@joelfernandes.org
CC: jiangshanlai@gmail.com
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 53f9648cb982..50d45781fa99 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -321,7 +321,7 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 #else /* #ifdef CONFIG_PROVE_RCU */
 
-#define RCU_LOCKDEP_WARN(c, s) do { } while (0)
+#define RCU_LOCKDEP_WARN(c, s) do { } while (0 && (c))
 #define rcu_sleep_check() do { } while (0)
 
 #endif /* #else #ifdef CONFIG_PROVE_RCU */
-- 
2.26.2

