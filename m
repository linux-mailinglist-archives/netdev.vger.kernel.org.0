Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C15C231FCA
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgG2OCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgG2OCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:02:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC60C061794;
        Wed, 29 Jul 2020 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=PRJNqGw+XD18aBBB7xjlm3ya1PAPiCa2qKaMBnvxp0w=; b=q4EQyFW2Aha5NKerR/qh65fdQQ
        sSyjzGAF+g2qLRRih2snOLirivui8iVO2L3Azc1DUJzBT6ruyneGEHcTpAiF2GpUQRrNNvfWIZSUz
        pHfOGwIMnWEfAo+18h8L5NsKOFh+m/3ojXWAiPJronNjXVroWbdWlHI01mRaRyd6ksrQXcE/a3KUC
        vBzab4YQKxQ6M6+c0Sgb0i5GxkpUypXtyj5X3pb28UFsyg+ORorpiklHqIVvZLYK7X+7uYWrBiy/M
        bPNrxezaZITTjBtyR4VQOiS56Ell5QUnMrz/98TJ0uT/iIyiihmDZlNZKUIdlLU83L0B4yzLsBLJl
        /TgQj2dA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0mfB-00011H-Gn; Wed, 29 Jul 2020 14:02:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 37E64304D28;
        Wed, 29 Jul 2020 16:02:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id EB40D2C0EDC74; Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Message-ID: <20200729140142.415864830@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Jul 2020 15:52:52 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     peterz@infradead.org, mingo@kernel.org, will@kernel.org,
        a.darwish@linutronix.de
Cc:     tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/5] seqlock: Fold seqcount_LOCKNAME_init() definition
References: <20200729135249.567415950@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Manual repetition is boring and error prone.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/seqlock.h |   61 +++++++++++-------------------------------------
 1 file changed, 14 insertions(+), 47 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -143,12 +143,6 @@ static inline void seqcount_lockdep_read
 	__SEQ_LOCK(.lock	= (assoc_lock))				\
 }
 
-#define seqcount_locktype_init(s, assoc_lock)				\
-do {									\
-	seqcount_init(&(s)->seqcount);					\
-	__SEQ_LOCK((s)->lock = (assoc_lock));				\
-} while (0)
-
 /**
  * SEQCNT_SPINLOCK_ZERO - static initializer for seqcount_spinlock_t
  * @name:	Name of the seqcount_spinlock_t instance
@@ -158,14 +152,6 @@ do {									\
 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
 /**
- * seqcount_spinlock_init - runtime initializer for seqcount_spinlock_t
- * @s:		Pointer to the seqcount_spinlock_t instance
- * @lock:	Pointer to the associated spinlock
- */
-#define seqcount_spinlock_init(s, lock)					\
-	seqcount_locktype_init(s, lock)
-
-/**
  * SEQCNT_RAW_SPINLOCK_ZERO - static initializer for seqcount_raw_spinlock_t
  * @name:	Name of the seqcount_raw_spinlock_t instance
  * @lock:	Pointer to the associated raw_spinlock
@@ -174,14 +160,6 @@ do {									\
 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
 /**
- * seqcount_raw_spinlock_init - runtime initializer for seqcount_raw_spinlock_t
- * @s:		Pointer to the seqcount_raw_spinlock_t instance
- * @lock:	Pointer to the associated raw_spinlock
- */
-#define seqcount_raw_spinlock_init(s, lock)				\
-	seqcount_locktype_init(s, lock)
-
-/**
  * SEQCNT_RWLOCK_ZERO - static initializer for seqcount_rwlock_t
  * @name:	Name of the seqcount_rwlock_t instance
  * @lock:	Pointer to the associated rwlock
@@ -190,14 +168,6 @@ do {									\
 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
 /**
- * seqcount_rwlock_init - runtime initializer for seqcount_rwlock_t
- * @s:		Pointer to the seqcount_rwlock_t instance
- * @lock:	Pointer to the associated rwlock
- */
-#define seqcount_rwlock_init(s, lock)					\
-	seqcount_locktype_init(s, lock)
-
-/**
  * SEQCNT_MUTEX_ZERO - static initializer for seqcount_mutex_t
  * @name:	Name of the seqcount_mutex_t instance
  * @lock:	Pointer to the associated mutex
@@ -206,14 +176,6 @@ do {									\
 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
 /**
- * seqcount_mutex_init - runtime initializer for seqcount_mutex_t
- * @s:		Pointer to the seqcount_mutex_t instance
- * @lock:	Pointer to the associated mutex
- */
-#define seqcount_mutex_init(s, lock)					\
-	seqcount_locktype_init(s, lock)
-
-/**
  * SEQCNT_WW_MUTEX_ZERO - static initializer for seqcount_ww_mutex_t
  * @name:	Name of the seqcount_ww_mutex_t instance
  * @lock:	Pointer to the associated ww_mutex
@@ -222,15 +184,7 @@ do {									\
 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
 /**
- * seqcount_ww_mutex_init - runtime initializer for seqcount_ww_mutex_t
- * @s:		Pointer to the seqcount_ww_mutex_t instance
- * @lock:	Pointer to the associated ww_mutex
- */
-#define seqcount_ww_mutex_init(s, lock)					\
-	seqcount_locktype_init(s, lock)
-
-/**
- * typedef seqcount_LOCKNAME_t - sequence counter with spinlock associated
+ * typedef seqcount_LOCKNAME_t - sequence counter with LOCKTYPR associated
  * @seqcount:	The real sequence counter
  * @lock:	Pointer to the associated spinlock
  *
@@ -240,6 +194,12 @@ do {									\
  * that the write side critical section is properly serialized.
  */
 
+/**
+ * seqcount_LOCKNAME_init() - runtime initializer for seqcount_LOCKNAME_t
+ * @s:		Pointer to the seqcount_LOCKNAME_t instance
+ * @lock:	Pointer to the associated LOCKTYPE
+ */
+
 /*
  * SEQCOUNT_LOCKTYPE() - Instantiate seqcount_LOCKNAME_t and helpers
  * @locktype:		actual typename
@@ -253,6 +213,13 @@ typedef struct seqcount_##lockname {
 	__SEQ_LOCK(locktype	*lock);					\
 } seqcount_##lockname##_t;						\
 									\
+static __always_inline void						\
+seqcount_##lockname##_init(seqcount_##lockname##_t *s, locktype *lock)	\
+{									\
+	seqcount_init(&s->seqcount);					\
+	__SEQ_LOCK(s->lock = lock);					\
+}									\
+									\
 static __always_inline seqcount_t *					\
 __seqcount_##lockname##_ptr(seqcount_##lockname##_t *s)			\
 {									\


