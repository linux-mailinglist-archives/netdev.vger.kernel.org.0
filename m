Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DFC231FC7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgG2OCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgG2OCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:02:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FBBC0619D4;
        Wed, 29 Jul 2020 07:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=+/Tirmir55AdeagnQ62Gu9rCQgL6iLT5YK7e0Fyr+J8=; b=sLf7sCNVZnAYOEXZxKLMLf/MTn
        Bg6Hp+vDRoka4Zjto8qXGiheE76EhlFYInp/JRX1MwsJbeCp/5ZcxnpEDY1yFqnUYgXfHCLqlhCNt
        VMZNB0xR97VY6uu36vzWFzpGBHolbFSJD95sIHZnxUYGyb+mf+LT0AmuzFXRE2/cRNrSDpRaJZk/6
        DUWup5zpllSA3s4/rBFNWYx/zQfj0yNiZdE2WoF41B0wFIXuBLxvIDM1aMU1IhaV/0M9LUtgdTrOs
        Ypky0blsfF8K86RsJ+uP23bGRw+ERrUu+//ni7xOO0XsH0whPUfO1BrB0KaTJTjshoSU2lbyKo+CS
        2yXfWyNg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0mfB-00011G-Go; Wed, 29 Jul 2020 14:02:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3F6CC3056DE;
        Wed, 29 Jul 2020 16:02:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id EECF22C0EDC6E; Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Message-ID: <20200729140142.483528362@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Jul 2020 15:52:53 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     peterz@infradead.org, mingo@kernel.org, will@kernel.org,
        a.darwish@linutronix.de
Cc:     tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 4/5] seqcount: Compress SEQCNT_LOCKNAME_ZERO()
References: <20200729135249.567415950@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Less is more.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/seqlock.h |   63 +++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 45 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -138,51 +138,6 @@ static inline void seqcount_lockdep_read
 #define __SEQ_LOCK(expr)
 #endif
 
-#define SEQCOUNT_LOCKTYPE_ZERO(seq_name, assoc_lock) {			\
-	.seqcount		= SEQCNT_ZERO(seq_name.seqcount),	\
-	__SEQ_LOCK(.lock	= (assoc_lock))				\
-}
-
-/**
- * SEQCNT_SPINLOCK_ZERO - static initializer for seqcount_spinlock_t
- * @name:	Name of the seqcount_spinlock_t instance
- * @lock:	Pointer to the associated spinlock
- */
-#define SEQCNT_SPINLOCK_ZERO(name, lock)				\
-	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
-
-/**
- * SEQCNT_RAW_SPINLOCK_ZERO - static initializer for seqcount_raw_spinlock_t
- * @name:	Name of the seqcount_raw_spinlock_t instance
- * @lock:	Pointer to the associated raw_spinlock
- */
-#define SEQCNT_RAW_SPINLOCK_ZERO(name, lock)				\
-	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
-
-/**
- * SEQCNT_RWLOCK_ZERO - static initializer for seqcount_rwlock_t
- * @name:	Name of the seqcount_rwlock_t instance
- * @lock:	Pointer to the associated rwlock
- */
-#define SEQCNT_RWLOCK_ZERO(name, lock)					\
-	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
-
-/**
- * SEQCNT_MUTEX_ZERO - static initializer for seqcount_mutex_t
- * @name:	Name of the seqcount_mutex_t instance
- * @lock:	Pointer to the associated mutex
- */
-#define SEQCNT_MUTEX_ZERO(name, lock)					\
-	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
-
-/**
- * SEQCNT_WW_MUTEX_ZERO - static initializer for seqcount_ww_mutex_t
- * @name:	Name of the seqcount_ww_mutex_t instance
- * @lock:	Pointer to the associated ww_mutex
- */
-#define SEQCNT_WW_MUTEX_ZERO(name, lock)				\
-	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
-
 /**
  * typedef seqcount_LOCKNAME_t - sequence counter with LOCKTYPR associated
  * @seqcount:	The real sequence counter
@@ -263,6 +218,24 @@ SEQCOUNT_LOCKTYPE(rwlock_t,		rwlock,		fa
 SEQCOUNT_LOCKTYPE(struct mutex,		mutex,		true,	s->lock)
 SEQCOUNT_LOCKTYPE(struct ww_mutex,	ww_mutex,	true,	&s->lock->base)
 
+/**
+ * SEQCNT_LOCKNAME_ZERO - static initializer for seqcount_LOCKNAME_t
+ * @name:	Name of the seqcount_LOCKNAME_t instance
+ * @lock:	Pointer to the associated LOCKTYPE
+ */
+
+#define SEQCOUNT_LOCKTYPE_ZERO(seq_name, assoc_lock) {			\
+	.seqcount		= SEQCNT_ZERO(seq_name.seqcount),	\
+	__SEQ_LOCK(.lock	= (assoc_lock))				\
+}
+
+#define SEQCNT_SPINLOCK_ZERO(name, lock)	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+#define SEQCNT_RAW_SPINLOCK_ZERO(name, lock)	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+#define SEQCNT_RWLOCK_ZERO(name, lock)		SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+#define SEQCNT_MUTEX_ZERO(name, lock)		SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+#define SEQCNT_WW_MUTEX_ZERO(name, lock) 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+
+
 #define __seqprop_case(s, lockname, prop)				\
 	seqcount_##lockname##_t: __seqcount_##lockname##_##prop((void *)(s))
 


