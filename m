Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A8D4C98E1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiCAXLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 18:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236771AbiCAXLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 18:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF284FC74;
        Tue,  1 Mar 2022 15:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 136126100E;
        Tue,  1 Mar 2022 23:10:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899EEC340EE;
        Tue,  1 Mar 2022 23:10:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BPHvCsKI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1646176250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=itu+dbhCmW5v2okOGmfaDt4jw9Rzl9SYTqaDbaiyW18=;
        b=BPHvCsKI1VH+Xru9bqad/KcyNp3hGjS4iY72LwZFC8FIKEbyQx1t134YHwTWJGKRf+m6kO
        XHNkhgh0SxNTuLS+lJey0YdSpCtge01JQpGM7gV06HzqbJpVLnlfiEfrRC727Xv/IOiBMC
        3Mi9tevomgyyikUqGkoZ0mXmTi8mRGU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 998be249 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 1 Mar 2022 23:10:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, Alexander Graf <graf@amazon.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] random: replace custom notifier chain with standard one
Date:   Wed,  2 Mar 2022 00:10:36 +0100
Message-Id: <20220301231038.530897-2-Jason@zx2c4.com>
In-Reply-To: <20220301231038.530897-1-Jason@zx2c4.com>
References: <20220301231038.530897-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We previously rolled our own randomness readiness notifier, which only
has two users in the whole kernel. Replace this with a more standard
atomic notifier block that serves the same purpose with less code. Also
unexport the symbols, because no modules use it, only unconditional
builtins. The only drawback is that it's possible for a notification
handler returning the "stop" code to prevent further processing, but
given that there are only two users, and that we're unexporting this
anyway, that doesn't seem like a significant drawback for the
simplification we receive here.

Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/char/random.c  | 67 ++++++++++++------------------------------
 include/linux/random.h | 11 ++-----
 lib/random32.c         | 12 ++++----
 lib/vsprintf.c         | 10 ++++---
 4 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index fe477a12c1ad..6bd1bbab7392 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -83,8 +83,8 @@ static int crng_init = 0;
 /* Various types of waiters for crng_init->2 transition. */
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 static struct fasync_struct *fasync;
-static DEFINE_SPINLOCK(random_ready_list_lock);
-static LIST_HEAD(random_ready_list);
+static DEFINE_SPINLOCK(random_ready_chain_lock);
+static RAW_NOTIFIER_HEAD(random_ready_chain);
 
 /* Control how we warn userspace. */
 static struct ratelimit_state unseeded_warning =
@@ -145,72 +145,43 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  *
  * returns: 0 if callback is successfully added
  *	    -EALREADY if pool is already initialised (callback not called)
- *	    -ENOENT if module for callback is not alive
  */
-int add_random_ready_callback(struct random_ready_callback *rdy)
+int register_random_ready_notifier(struct notifier_block *nb)
 {
-	struct module *owner;
 	unsigned long flags;
-	int err = -EALREADY;
+	int ret = -EALREADY;
 
 	if (crng_ready())
-		return err;
-
-	owner = rdy->owner;
-	if (!try_module_get(owner))
-		return -ENOENT;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (crng_ready())
-		goto out;
-
-	owner = NULL;
-
-	list_add(&rdy->list, &random_ready_list);
-	err = 0;
-
-out:
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
-
-	module_put(owner);
+		return ret;
 
-	return err;
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	if (!crng_ready())
+		ret = raw_notifier_chain_register(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL(add_random_ready_callback);
 
 /*
  * Delete a previously registered readiness callback function.
  */
-void del_random_ready_callback(struct random_ready_callback *rdy)
+int unregister_random_ready_notifier(struct notifier_block *nb)
 {
 	unsigned long flags;
-	struct module *owner = NULL;
-
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	if (!list_empty(&rdy->list)) {
-		list_del_init(&rdy->list);
-		owner = rdy->owner;
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	int ret;
 
-	module_put(owner);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	ret = raw_notifier_chain_unregister(&random_ready_chain, nb);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
+	return ret;
 }
-EXPORT_SYMBOL(del_random_ready_callback);
 
 static void process_random_ready_list(void)
 {
 	unsigned long flags;
-	struct random_ready_callback *rdy, *tmp;
 
-	spin_lock_irqsave(&random_ready_list_lock, flags);
-	list_for_each_entry_safe(rdy, tmp, &random_ready_list, list) {
-		struct module *owner = rdy->owner;
-
-		list_del_init(&rdy->list);
-		rdy->func(rdy);
-		module_put(owner);
-	}
-	spin_unlock_irqrestore(&random_ready_list_lock, flags);
+	spin_lock_irqsave(&random_ready_chain_lock, flags);
+	raw_notifier_call_chain(&random_ready_chain, 0, NULL);
+	spin_unlock_irqrestore(&random_ready_chain_lock, flags);
 }
 
 #define warn_unseeded_randomness(previous) \
diff --git a/include/linux/random.h b/include/linux/random.h
index f209f1a78899..e84b6fa27435 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,15 +7,10 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/once.h>
+#include <linux/notifier.h>
 
 #include <uapi/linux/random.h>
 
-struct random_ready_callback {
-	struct list_head list;
-	void (*func)(struct random_ready_callback *rdy);
-	struct module *owner;
-};
-
 extern void add_device_randomness(const void *, size_t);
 extern void add_bootloader_randomness(const void *, size_t);
 
@@ -42,8 +37,8 @@ extern void get_random_bytes(void *buf, size_t nbytes);
 extern int wait_for_random_bytes(void);
 extern int __init rand_initialize(void);
 extern bool rng_is_initialized(void);
-extern int add_random_ready_callback(struct random_ready_callback *rdy);
-extern void del_random_ready_callback(struct random_ready_callback *rdy);
+extern int register_random_ready_notifier(struct notifier_block *nb);
+extern int unregister_random_ready_notifier(struct notifier_block *nb);
 extern size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
 
 #ifndef MODULE
diff --git a/lib/random32.c b/lib/random32.c
index 3c19820796d0..976632003ec6 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -551,9 +551,11 @@ static void prandom_reseed(struct timer_list *unused)
  * To avoid worrying about whether it's safe to delay that interrupt
  * long enough to seed all CPUs, just schedule an immediate timer event.
  */
-static void prandom_timer_start(struct random_ready_callback *unused)
+static int prandom_timer_start(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	mod_timer(&seed_timer, jiffies);
+	return 0;
 }
 
 #ifdef CONFIG_RANDOM32_SELFTEST
@@ -617,13 +619,13 @@ core_initcall(prandom32_state_selftest);
  */
 static int __init prandom_init_late(void)
 {
-	static struct random_ready_callback random_ready = {
-		.func = prandom_timer_start
+	static struct notifier_block random_ready = {
+		.notifier_call = prandom_timer_start
 	};
-	int ret = add_random_ready_callback(&random_ready);
+	int ret = register_random_ready_notifier(&random_ready);
 
 	if (ret == -EALREADY) {
-		prandom_timer_start(&random_ready);
+		prandom_timer_start(&random_ready, 0, NULL);
 		ret = 0;
 	}
 	return ret;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 3b8129dd374c..36574a806a81 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -757,14 +757,16 @@ static void enable_ptr_key_workfn(struct work_struct *work)
 
 static DECLARE_WORK(enable_ptr_key_work, enable_ptr_key_workfn);
 
-static void fill_random_ptr_key(struct random_ready_callback *unused)
+static int fill_random_ptr_key(struct notifier_block *nb,
+			       unsigned long action, void *data)
 {
 	/* This may be in an interrupt handler. */
 	queue_work(system_unbound_wq, &enable_ptr_key_work);
+	return 0;
 }
 
-static struct random_ready_callback random_ready = {
-	.func = fill_random_ptr_key
+static struct notifier_block random_ready = {
+	.notifier_call = fill_random_ptr_key
 };
 
 static int __init initialize_ptr_random(void)
@@ -778,7 +780,7 @@ static int __init initialize_ptr_random(void)
 		return 0;
 	}
 
-	ret = add_random_ready_callback(&random_ready);
+	ret = register_random_ready_notifier(&random_ready);
 	if (!ret) {
 		return 0;
 	} else if (ret == -EALREADY) {
-- 
2.35.1

