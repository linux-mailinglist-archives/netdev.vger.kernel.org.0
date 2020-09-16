Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EF026C854
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgIPSqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:46:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728154AbgIPSqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:14 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A478221EF;
        Wed, 16 Sep 2020 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281969;
        bh=jPXAjpQCZ862tVOBiMIHndV4XBLyC44PoH4AOVqApsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfYutagyCDKhwiv/fmpQgLz/EQNVGj5JbRF/wF2xF/EkczxIDcDUYXgyqJIRRXKHJ
         Xf9riCS2eLkWCfBZNsAfbBojDPloJuaqOW/vCrM8XMeThsOoIsTJI8hUNzx5O6JCLy
         DNzji6bBqiaB1iOWKtCZ0q0fkUAhiOu2vW8KE8dg=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>,
        jiangshanlai@gmail.com, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com
Subject: [PATCH net-next 5/7] srcu: use a more appropriate lockdep helper
Date:   Wed, 16 Sep 2020 11:45:26 -0700
Message-Id: <20200916184528.498184-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lockdep_is_held() is defined as:

 #define lockdep_is_held(lock)		lock_is_held(&(lock)->dep_map)

it hides away the dereference, so that builds with !LOCKDEP
don't break. We should use it instead of using lock_is_held()
directly.

This didn't use to be a problem, because RCU_LOCKDEP_WARN()
cuts the condition out with the preprocessor if !LOCKDEP.
This will soon change.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: jiangshanlai@gmail.com
CC: paulmck@kernel.org
CC: josh@joshtriplett.org
CC: rostedt@goodmis.org
CC: mathieu.desnoyers@efficios.com
---
 kernel/rcu/srcutree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/srcutree.c b/kernel/rcu/srcutree.c
index c100acf332ed..8123ef15a159 100644
--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -919,7 +919,7 @@ static void __synchronize_srcu(struct srcu_struct *ssp, bool do_norm)
 {
 	struct rcu_synchronize rcu;
 
-	RCU_LOCKDEP_WARN(lock_is_held(&ssp->dep_map) ||
+	RCU_LOCKDEP_WARN(lockdep_is_held(ssp) ||
 			 lock_is_held(&rcu_bh_lock_map) ||
 			 lock_is_held(&rcu_lock_map) ||
 			 lock_is_held(&rcu_sched_lock_map),
-- 
2.26.2

