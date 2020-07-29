Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F2231FC4
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgG2OCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgG2OCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:02:47 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD625C0619D5;
        Wed, 29 Jul 2020 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=bn3PTm0Vm+Yp3fAFaIy0i1fx6Q8yyX38/osPy+x74Sg=; b=i4040fEMXoJUqp2l/FBJJd6GLb
        oA0AaQIY1gmQl/rFKxBaEPaSzEbweARMkn8yTPes/XwEFaQyKTudlYEiFqPhwkqxLasNU60GaIA0O
        Dh0BHBOx53R7n3dfhF+sD5I/ZsLlAAM1DrYm6H+uhnWKWC1VC/hfpqyIB/zbycz+7FT2zywWEvG9W
        t3PTxyytSDYf1kx7p5m2j/kwfxKjSYaFhBdNWEfgB6VZj0+MuumCx9Jh25gdLZ+pLu2tiSAHx4+5Y
        6JR0ZCT2E3WgOao/HdaEg0oGMJUoyjFVgWG44+WpQGqUKl8MxV+PpBHskjLEmUT/Aq9RvrOKUYdJF
        9ocL1gMA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0mfD-0001Dr-Go; Wed, 29 Jul 2020 14:02:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3702F304B6D;
        Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E338F200D4153; Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Message-ID: <20200729140142.277485074@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Jul 2020 15:52:50 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     peterz@infradead.org, mingo@kernel.org, will@kernel.org,
        a.darwish@linutronix.de
Cc:     tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/5] seqlock: s/__SEQ_LOCKDEP/__SEQ_LOCK/g
References: <20200729135249.567415950@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__SEQ_LOCKDEP() is an expression gate for the
seqcount_LOCKNAME_t::lock member. Rename it to be about the member,
not the gate condition.

Later (PREEMPT_RT) patches will make the member available for !LOCKDEP
configs.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/seqlock.h |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -133,20 +133,20 @@ static inline void seqcount_lockdep_read
  */
 
 #ifdef CONFIG_LOCKDEP
-#define __SEQ_LOCKDEP(expr)	expr
+#define __SEQ_LOCK(expr)	expr
 #else
-#define __SEQ_LOCKDEP(expr)
+#define __SEQ_LOCK(expr)
 #endif
 
 #define SEQCOUNT_LOCKTYPE_ZERO(seq_name, assoc_lock) {			\
 	.seqcount		= SEQCNT_ZERO(seq_name.seqcount),	\
-	__SEQ_LOCKDEP(.lock	= (assoc_lock))				\
+	__SEQ_LOCK(.lock	= (assoc_lock))				\
 }
 
 #define seqcount_locktype_init(s, assoc_lock)				\
 do {									\
 	seqcount_init(&(s)->seqcount);					\
-	__SEQ_LOCKDEP((s)->lock = (assoc_lock));			\
+	__SEQ_LOCK((s)->lock = (assoc_lock));				\
 } while (0)
 
 /**
@@ -161,7 +161,7 @@ do {									\
  */
 typedef struct seqcount_spinlock {
 	seqcount_t	seqcount;
-	__SEQ_LOCKDEP(spinlock_t	*lock);
+	__SEQ_LOCK(spinlock_t	*lock);
 } seqcount_spinlock_t;
 
 /**
@@ -192,7 +192,7 @@ typedef struct seqcount_spinlock {
  */
 typedef struct seqcount_raw_spinlock {
 	seqcount_t      seqcount;
-	__SEQ_LOCKDEP(raw_spinlock_t	*lock);
+	__SEQ_LOCK(raw_spinlock_t	*lock);
 } seqcount_raw_spinlock_t;
 
 /**
@@ -223,7 +223,7 @@ typedef struct seqcount_raw_spinlock {
  */
 typedef struct seqcount_rwlock {
 	seqcount_t      seqcount;
-	__SEQ_LOCKDEP(rwlock_t		*lock);
+	__SEQ_LOCK(rwlock_t		*lock);
 } seqcount_rwlock_t;
 
 /**
@@ -257,7 +257,7 @@ typedef struct seqcount_rwlock {
  */
 typedef struct seqcount_mutex {
 	seqcount_t      seqcount;
-	__SEQ_LOCKDEP(struct mutex	*lock);
+	__SEQ_LOCK(struct mutex	*lock);
 } seqcount_mutex_t;
 
 /**
@@ -291,7 +291,7 @@ typedef struct seqcount_mutex {
  */
 typedef struct seqcount_ww_mutex {
 	seqcount_t      seqcount;
-	__SEQ_LOCKDEP(struct ww_mutex	*lock);
+	__SEQ_LOCK(struct ww_mutex	*lock);
 } seqcount_ww_mutex_t;
 
 /**
@@ -329,7 +329,7 @@ __seqcount_##locktype##_preemptible(seqc
 static inline void							\
 __seqcount_##locktype##_assert(seqcount_##locktype##_t *s)		\
 {									\
-	__SEQ_LOCKDEP(lockdep_assert_held(lockmember));			\
+	__SEQ_LOCK(lockdep_assert_held(lockmember));			\
 }
 
 /*


