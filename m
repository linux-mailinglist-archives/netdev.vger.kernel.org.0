Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B4F2D11E8
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgLGN0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:26:51 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:35272 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgLGN0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347610; x=1638883610;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=ZgNA79r8oboVjgxvQ5hc/k4jl9iZmqF9kCrWvhttAso=;
  b=T+wdSdcLjqn3Dovn/2gfHPSv46v8GPzF/jc1xvAnHB40+A24MSgKEEaj
   n4QLHLZtglw/6wNxgC6d8AZP9bSgALP8uBwq6F9uFEuwbUusMvKMv17Ok
   m7WVARaj1ELCGfC5pp2Qz413hHXA+QqyVIxn68k0YSTL1FPpWUfKj60h+
   M=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="101016343"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 07 Dec 2020 13:26:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id A8983B3DD3;
        Mon,  7 Dec 2020 13:26:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:04 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:26:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Waiman Long <longman@redhat.com>
Subject: [PATCH v2 bpf-next 03/13] Revert "locking/spinlocks: Remove the unused spin_lock_bh_nested() API"
Date:   Mon, 7 Dec 2020 22:24:46 +0900
Message-ID: <20201207132456.65472-4-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207132456.65472-1-kuniyu@amazon.co.jp>
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 607904c357c61adf20b8fd18af765e501d61a385 to use
spin_lock_bh_nested() in the next commit.

Link: https://lore.kernel.org/netdev/9d290a57-49e1-04cd-2487-262b0d7c5844@gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
CC: Waiman Long <longman@redhat.com>
---
 include/linux/spinlock.h         | 8 ++++++++
 include/linux/spinlock_api_smp.h | 2 ++
 include/linux/spinlock_api_up.h  | 1 +
 kernel/locking/spinlock.c        | 8 ++++++++
 4 files changed, 19 insertions(+)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 79897841a2cc..c020b375a071 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -227,6 +227,8 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 # define raw_spin_lock_nested(lock, subclass) \
 	_raw_spin_lock_nested(lock, subclass)
+# define raw_spin_lock_bh_nested(lock, subclass) \
+	_raw_spin_lock_bh_nested(lock, subclass)
 
 # define raw_spin_lock_nest_lock(lock, nest_lock)			\
 	 do {								\
@@ -242,6 +244,7 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
 # define raw_spin_lock_nested(lock, subclass)		\
 	_raw_spin_lock(((void)(subclass), (lock)))
 # define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
+# define raw_spin_lock_bh_nested(lock, subclass)	_raw_spin_lock_bh(lock)
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -369,6 +372,11 @@ do {								\
 	raw_spin_lock_nested(spinlock_check(lock), subclass);	\
 } while (0)
 
+#define spin_lock_bh_nested(lock, subclass)			\
+do {								\
+	raw_spin_lock_bh_nested(spinlock_check(lock), subclass);\
+} while (0)
+
 #define spin_lock_nest_lock(lock, nest_lock)				\
 do {									\
 	raw_spin_lock_nest_lock(spinlock_check(lock), nest_lock);	\
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 19a9be9d97ee..d565fb6304f2 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -22,6 +22,8 @@ int in_lock_functions(unsigned long addr);
 void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)		__acquires(lock);
 void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 								__acquires(lock);
+void __lockfunc _raw_spin_lock_bh_nested(raw_spinlock_t *lock, int subclass)
+								__acquires(lock);
 void __lockfunc
 _raw_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
 								__acquires(lock);
diff --git a/include/linux/spinlock_api_up.h b/include/linux/spinlock_api_up.h
index d0d188861ad6..d3afef9d8dbe 100644
--- a/include/linux/spinlock_api_up.h
+++ b/include/linux/spinlock_api_up.h
@@ -57,6 +57,7 @@
 
 #define _raw_spin_lock(lock)			__LOCK(lock)
 #define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
+#define _raw_spin_lock_bh_nested(lock, subclass) __LOCK(lock)
 #define _raw_read_lock(lock)			__LOCK(lock)
 #define _raw_write_lock(lock)			__LOCK(lock)
 #define _raw_spin_lock_bh(lock)			__LOCK_BH(lock)
diff --git a/kernel/locking/spinlock.c b/kernel/locking/spinlock.c
index 0ff08380f531..48e99ed1bdd8 100644
--- a/kernel/locking/spinlock.c
+++ b/kernel/locking/spinlock.c
@@ -363,6 +363,14 @@ void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 }
 EXPORT_SYMBOL(_raw_spin_lock_nested);
 
+void __lockfunc _raw_spin_lock_bh_nested(raw_spinlock_t *lock, int subclass)
+{
+	__local_bh_disable_ip(_RET_IP_, SOFTIRQ_LOCK_OFFSET);
+	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
+}
+EXPORT_SYMBOL(_raw_spin_lock_bh_nested);
+
 unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
 						   int subclass)
 {
-- 
2.17.2 (Apple Git-113)

