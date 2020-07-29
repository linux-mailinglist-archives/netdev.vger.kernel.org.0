Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED40231FCD
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbgG2OCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgG2OCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:02:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7FAC0619D2;
        Wed, 29 Jul 2020 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=PJqTFgO9gD/1/lmgflw2X/3MEuONqoxCTULLG0fG5dI=; b=SAM91LYTCtYcuFGjQBAQWfvPrO
        QkqWh66l2uvqAzr+WWpQBFJWtrH6uzaEQ0P36BLO/2Ai2cdbj2H1NV5U1HqxM+pMm0jT0d69QrRl5
        CTo8MlJFSjIb67WSDD1w+3A3+mR3H4VW86roxyU1cCNZc2S/0K+8DD08BmBRvyPYBsWXIi3Ncz6r6
        PKdVgj8ZENrSkK711OfrkBu7RbdI5mvP2JeGEZGouzlGZAj0vfByrwS+pON8tJ6Vw7+l+cf0M0kNY
        v2WlVYbNwbiUHSKaG+4E8Zp1RCskYPqSILj2KgenwdfrWvRfZTKpngy0XeabsRmJ8CrqJfOqal6xm
        XEisfrxQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0mfC-00011P-NX; Wed, 29 Jul 2020 14:02:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 404633059DE;
        Wed, 29 Jul 2020 16:02:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E57D12C0EDC4A; Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Message-ID: <20200729140142.347671778@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Jul 2020 15:52:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     peterz@infradead.org, mingo@kernel.org, will@kernel.org,
        a.darwish@linutronix.de
Cc:     tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/5] seqlock: Fold seqcount_LOCKNAME_t definition
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
 include/linux/seqlock.h |  140 +++++++++++++-----------------------------------
 1 file changed, 38 insertions(+), 102 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -150,21 +150,6 @@ do {									\
 } while (0)
 
 /**
- * typedef seqcount_spinlock_t - sequence counter with spinlock associated
- * @seqcount:	The real sequence counter
- * @lock:	Pointer to the associated spinlock
- *
- * A plain sequence counter with external writer synchronization by a
- * spinlock. The spinlock is associated to the sequence count in the
- * static initializer or init function. This enables lockdep to validate
- * that the write side critical section is properly serialized.
- */
-typedef struct seqcount_spinlock {
-	seqcount_t	seqcount;
-	__SEQ_LOCK(spinlock_t	*lock);
-} seqcount_spinlock_t;
-
-/**
  * SEQCNT_SPINLOCK_ZERO - static initializer for seqcount_spinlock_t
  * @name:	Name of the seqcount_spinlock_t instance
  * @lock:	Pointer to the associated spinlock
@@ -181,21 +166,6 @@ typedef struct seqcount_spinlock {
 	seqcount_locktype_init(s, lock)
 
 /**
- * typedef seqcount_raw_spinlock_t - sequence count with raw spinlock associated
- * @seqcount:	The real sequence counter
- * @lock:	Pointer to the associated raw spinlock
- *
- * A plain sequence counter with external writer synchronization by a
- * raw spinlock. The raw spinlock is associated to the sequence count in
- * the static initializer or init function. This enables lockdep to
- * validate that the write side critical section is properly serialized.
- */
-typedef struct seqcount_raw_spinlock {
-	seqcount_t      seqcount;
-	__SEQ_LOCK(raw_spinlock_t	*lock);
-} seqcount_raw_spinlock_t;
-
-/**
  * SEQCNT_RAW_SPINLOCK_ZERO - static initializer for seqcount_raw_spinlock_t
  * @name:	Name of the seqcount_raw_spinlock_t instance
  * @lock:	Pointer to the associated raw_spinlock
@@ -212,21 +182,6 @@ typedef struct seqcount_raw_spinlock {
 	seqcount_locktype_init(s, lock)
 
 /**
- * typedef seqcount_rwlock_t - sequence count with rwlock associated
- * @seqcount:	The real sequence counter
- * @lock:	Pointer to the associated rwlock
- *
- * A plain sequence counter with external writer synchronization by a
- * rwlock. The rwlock is associated to the sequence count in the static
- * initializer or init function. This enables lockdep to validate that
- * the write side critical section is properly serialized.
- */
-typedef struct seqcount_rwlock {
-	seqcount_t      seqcount;
-	__SEQ_LOCK(rwlock_t		*lock);
-} seqcount_rwlock_t;
-
-/**
  * SEQCNT_RWLOCK_ZERO - static initializer for seqcount_rwlock_t
  * @name:	Name of the seqcount_rwlock_t instance
  * @lock:	Pointer to the associated rwlock
@@ -243,24 +198,6 @@ typedef struct seqcount_rwlock {
 	seqcount_locktype_init(s, lock)
 
 /**
- * typedef seqcount_mutex_t - sequence count with mutex associated
- * @seqcount:	The real sequence counter
- * @lock:	Pointer to the associated mutex
- *
- * A plain sequence counter with external writer synchronization by a
- * mutex. The mutex is associated to the sequence counter in the static
- * initializer or init function. This enables lockdep to validate that
- * the write side critical section is properly serialized.
- *
- * The write side API functions write_seqcount_begin()/end() automatically
- * disable and enable preemption when used with seqcount_mutex_t.
- */
-typedef struct seqcount_mutex {
-	seqcount_t      seqcount;
-	__SEQ_LOCK(struct mutex	*lock);
-} seqcount_mutex_t;
-
-/**
  * SEQCNT_MUTEX_ZERO - static initializer for seqcount_mutex_t
  * @name:	Name of the seqcount_mutex_t instance
  * @lock:	Pointer to the associated mutex
@@ -277,24 +214,6 @@ typedef struct seqcount_mutex {
 	seqcount_locktype_init(s, lock)
 
 /**
- * typedef seqcount_ww_mutex_t - sequence count with ww_mutex associated
- * @seqcount:	The real sequence counter
- * @lock:	Pointer to the associated ww_mutex
- *
- * A plain sequence counter with external writer synchronization by a
- * ww_mutex. The ww_mutex is associated to the sequence counter in the static
- * initializer or init function. This enables lockdep to validate that
- * the write side critical section is properly serialized.
- *
- * The write side API functions write_seqcount_begin()/end() automatically
- * disable and enable preemption when used with seqcount_ww_mutex_t.
- */
-typedef struct seqcount_ww_mutex {
-	seqcount_t      seqcount;
-	__SEQ_LOCK(struct ww_mutex	*lock);
-} seqcount_ww_mutex_t;
-
-/**
  * SEQCNT_WW_MUTEX_ZERO - static initializer for seqcount_ww_mutex_t
  * @name:	Name of the seqcount_ww_mutex_t instance
  * @lock:	Pointer to the associated ww_mutex
@@ -310,30 +229,50 @@ typedef struct seqcount_ww_mutex {
 #define seqcount_ww_mutex_init(s, lock)					\
 	seqcount_locktype_init(s, lock)
 
-/*
- * @preempt: Is the associated write serialization lock preemtpible?
+/**
+ * typedef seqcount_LOCKNAME_t - sequence counter with spinlock associated
+ * @seqcount:	The real sequence counter
+ * @lock:	Pointer to the associated spinlock
+ *
+ * A plain sequence counter with external writer synchronization by a
+ * spinlock. The spinlock is associated to the sequence count in the
+ * static initializer or init function. This enables lockdep to validate
+ * that the write side critical section is properly serialized.
  */
-#define SEQCOUNT_LOCKTYPE(locktype, preempt, lockmember)		\
-static inline seqcount_t *						\
-__seqcount_##locktype##_ptr(seqcount_##locktype##_t *s)			\
+
+/*
+ * SEQCOUNT_LOCKTYPE() - Instantiate seqcount_LOCKNAME_t and helpers
+ * @locktype:		actual typename
+ * @lockname:		name
+ * @preemptible:	preemptibility of above locktype
+ * @lockmember:		argument for lockdep_assert_held()
+ */
+#define SEQCOUNT_LOCKTYPE(locktype, lockname, preemptible, lockmember)	\
+typedef struct seqcount_##lockname {					\
+	seqcount_t		seqcount;				\
+	__SEQ_LOCK(locktype	*lock);					\
+} seqcount_##lockname##_t;						\
+									\
+static __always_inline seqcount_t *					\
+__seqcount_##lockname##_ptr(seqcount_##lockname##_t *s)			\
 {									\
 	return &s->seqcount;						\
 }									\
 									\
-static inline bool							\
-__seqcount_##locktype##_preemptible(seqcount_##locktype##_t *s)		\
+static __always_inline bool						\
+__seqcount_##lockname##_preemptible(seqcount_##lockname##_t *s)		\
 {									\
-	return preempt;							\
+	return preemptible;						\
 }									\
 									\
-static inline void							\
-__seqcount_##locktype##_assert(seqcount_##locktype##_t *s)		\
+static __always_inline void						\
+__seqcount_##lockname##_assert(seqcount_##lockname##_t *s)		\
 {									\
 	__SEQ_LOCK(lockdep_assert_held(lockmember));			\
 }
 
 /*
- * Similar hooks, but for plain seqcount_t
+ * __seqprop() for seqcount_t
  */
 
 static inline seqcount_t *__seqcount_ptr(seqcount_t *s)
@@ -351,17 +290,14 @@ static inline void __seqcount_assert(seq
 	lockdep_assert_preemption_disabled();
 }
 
-/*
- * @s: Pointer to seqcount_locktype_t, generated hooks first parameter.
- */
-SEQCOUNT_LOCKTYPE(raw_spinlock,	false,	s->lock)
-SEQCOUNT_LOCKTYPE(spinlock,	false,	s->lock)
-SEQCOUNT_LOCKTYPE(rwlock,	false,	s->lock)
-SEQCOUNT_LOCKTYPE(mutex,	true,	s->lock)
-SEQCOUNT_LOCKTYPE(ww_mutex,	true,	&s->lock->base)
+SEQCOUNT_LOCKTYPE(raw_spinlock_t,	raw_spinlock,	false,	s->lock)
+SEQCOUNT_LOCKTYPE(spinlock_t,		spinlock,	false,	s->lock)
+SEQCOUNT_LOCKTYPE(rwlock_t,		rwlock,		false,	s->lock)
+SEQCOUNT_LOCKTYPE(struct mutex,		mutex,		true,	s->lock)
+SEQCOUNT_LOCKTYPE(struct ww_mutex,	ww_mutex,	true,	&s->lock->base)
 
-#define __seqprop_case(s, locktype, prop)				\
-	seqcount_##locktype##_t: __seqcount_##locktype##_##prop((void *)(s))
+#define __seqprop_case(s, lockname, prop)				\
+	seqcount_##lockname##_t: __seqcount_##lockname##_##prop((void *)(s))
 
 #define __seqprop(s, prop) _Generic(*(s),				\
 	seqcount_t:		__seqcount_##prop((void *)(s)),		\


