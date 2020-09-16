Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5773C26C85F
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgIPSrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:47:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728156AbgIPSqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:14 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E649221F0;
        Wed, 16 Sep 2020 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281969;
        bh=irzvRf7PhwsJvmwGcl2SYLLh2jImSgngjZEHOI6ZgHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3eSFrSAAuZloLBvrxMzAKZvqa5BEzcCYSHW/yAKM5NAlbmppVcwWz+ramz/Vmcpi
         SBrVlASyv5K/tfOF0Mu6Ereue0WGqS7KE/nUYhYVCiiZ0NMXOUUlTta2n+kfELejBh
         Zvof/qcaAIbwV0jGVv9ajqJzKT8KfecGf7N0URHw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>,
        mingo@redhat.com, will@kernel.org
Subject: [PATCH net-next 6/7] lockdep: provide dummy forward declaration of *_is_held() helpers
Date:   Wed, 16 Sep 2020 11:45:27 -0700
Message-Id: <20200916184528.498184-7-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_LOCKDEP is not set, lock_is_held() and lockdep_is_held()
are not declared or defined. This forces all callers to use ifdefs
around these checks.

Recent RCU changes added a lot of lockdep_is_held() calls inside
rcu_dereference_protected(). rcu_dereference_protected() hides
its argument on !LOCKDEP builds, but this may lead to unused variable
warnings.

Provide forward declarations of lock_is_held() and lockdep_is_held()
but never define them. This way callers can keep them visible to
the compiler on !LOCKDEP builds and instead depend on dead code
elimination to remove the references before the linker barfs.

We need lock_is_held() for RCU.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: peterz@infradead.org
CC: mingo@redhat.com
CC: will@kernel.org
---
 include/linux/lockdep.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 6a584b3e5c74..6b5bbc536bf6 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -371,6 +371,12 @@ static inline void lockdep_unregister_key(struct lock_class_key *key)
 
 #define lockdep_depth(tsk)	(0)
 
+/*
+ * Dummy forward declarations, allow users to write less ifdef-y code
+ * and depend on dead code elimination.
+ */
+int lock_is_held(const void *);
+int lockdep_is_held(const void *);
 #define lockdep_is_held_type(l, r)		(1)
 
 #define lockdep_assert_held(l)			do { (void)(l); } while (0)
-- 
2.26.2

