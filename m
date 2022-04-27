Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC22512698
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239644AbiD0W6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiD0W5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:57:45 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8258CCF2;
        Wed, 27 Apr 2022 15:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TyVeNhVW0Rnl3U7SFjjiF4VJ6tQ4RncKJG9ElTcHS+U=; b=hvE2Pj35pHuqn6KDgSKo02+iOD
        gaZNRqkVbFn9vQ1y4MBHDanrICwEYbseYlrZHBUEFfY68VDZIQ086YHf/rCSUp+hPGKR8FYY9OK9v
        nYOOhcV6bCO8xGO+p+XNcPdbjxcGSaZZe5jlsSnm9qDCOj58ux/NyJ6hacLVBQ9lf2Np1cQmzz6Ne
        TKKibQQEw+thoGU6lpUAnc5gpYGmm9vwgSbtaH7Vh06JStgGFCN2k8m/ySu3R2fY0mjZnaQFnJp9F
        5MYFwY+RbtGzq1Awmj6tWKuAJuhkis/a6p5VVxSla36X0DRApqZ71nyvJTNmXiYqTaGH5nkcLaKsD
        z1NFv2eQ==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqWy-0002D9-Gr; Thu, 28 Apr 2022 00:53:09 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, gpiccoli@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 13/30] s390/consoles: Improve panic notifiers reliability
Date:   Wed, 27 Apr 2022 19:49:07 -0300
Message-Id: <20220427224924.592546-14-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220427224924.592546-1-gpiccoli@igalia.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently many console drivers for s390 rely on panic/reboot notifiers
to invoke callbacks on these events. The panic() function disables local
IRQs, secondary CPUs and preemption, so callbacks invoked on panic are
effectively running in atomic context.

Happens that most of these console callbacks from s390 doesn't take the
proper care with regards to atomic context, like taking spinlocks that
might be taken in other function/CPU and hence will cause a lockup
situation.

The goal for this patch is to improve the notifiers reliability, acting
on 4 console drivers, as detailed below:

(1) con3215: changed a regular spinlock to the trylock alternative.

(2) con3270: also changed a regular spinlock to its trylock counterpart,
but here we also have another problem: raw3270_activate_view() takes a
different spinlock. So, we worked a helper to validate if this other lock
is safe to acquire, and if so, raw3270_activate_view() should be safe.

Notice though that there is a functional change here: it's now possible
to continue the notifier code [reaching con3270_wait_write() and
con3270_rebuild_update()] without executing raw3270_activate_view().

(3) sclp: a global lock is used heavily in the functions called from
the notifier, so we added a check here - if the lock is taken already,
we just bail-out, preventing the lockup.

(4) sclp_vt220: same as (3), a lock validation was added to prevent the
potential lockup problem.

Besides (1)-(4), we also removed useless void functions, adding the
code called from the notifier inside its own body, and changed the
priority of such notifiers to execute late, since they are "heavyweight"
for the panic environment, so we aim to reduce risks here.
Changed return values to NOTIFY_DONE as well, the standard one.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---

As a design choice, the option used here to verify a given spinlock is taken
was the function "spin_is_locked()" - but we noticed that it is not often used.
An alternative would to take the lock with a spin_trylock() and if it succeeds,
just release the spinlock and continue the code. But that seemed weird...

Also, we'd like to ask a good validation of case (2) potential functionality
change from the s390 console experts - far from expert here, and in our naive
code observation, that seems fine, but that analysis might be missing some
corner case.

Thanks in advance!

 drivers/s390/char/con3215.c    | 36 +++++++++++++++--------------
 drivers/s390/char/con3270.c    | 34 +++++++++++++++------------
 drivers/s390/char/raw3270.c    | 18 +++++++++++++++
 drivers/s390/char/raw3270.h    |  1 +
 drivers/s390/char/sclp_con.c   | 28 +++++++++++++----------
 drivers/s390/char/sclp_vt220.c | 42 +++++++++++++++++++---------------
 6 files changed, 96 insertions(+), 63 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index f356607835d8..192198bd3dc4 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -771,35 +771,37 @@ static struct tty_driver *con3215_device(struct console *c, int *index)
 }
 
 /*
- * panic() calls con3215_flush through a panic_notifier
- * before the system enters a disabled, endless loop.
+ * The below function is called as a panic/reboot notifier before the
+ * system enters a disabled, endless loop.
+ *
+ * Notice we must use the spin_trylock() alternative, to prevent lockups
+ * in atomic context (panic routine runs with secondary CPUs, local IRQs
+ * and preemption disabled).
  */
-static void con3215_flush(void)
-{
-	struct raw3215_info *raw;
-	unsigned long flags;
-
-	raw = raw3215[0];  /* console 3215 is the first one */
-	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
-	raw3215_make_room(raw, RAW3215_BUFFER_SIZE);
-	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
-}
-
 static int con3215_notify(struct notifier_block *self,
 			  unsigned long event, void *data)
 {
-	con3215_flush();
-	return NOTIFY_OK;
+	struct raw3215_info *raw;
+	unsigned long flags;
+
+	raw = raw3215[0];  /* console 3215 is the first one */
+	if (!spin_trylock_irqsave(get_ccwdev_lock(raw->cdev), flags))
+		return NOTIFY_DONE;
+
+	raw3215_make_room(raw, RAW3215_BUFFER_SIZE);
+	spin_unlock_irqrestore(get_ccwdev_lock(raw->cdev), flags);
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block on_panic_nb = {
 	.notifier_call = con3215_notify,
-	.priority = 0,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 static struct notifier_block on_reboot_nb = {
 	.notifier_call = con3215_notify,
-	.priority = 0,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 /*
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index e4592890f20a..476202f3d8a0 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -535,20 +535,29 @@ con3270_wait_write(struct con3270 *cp)
 }
 
 /*
- * panic() calls con3270_flush through a panic_notifier
- * before the system enters a disabled, endless loop.
+ * The below function is called as a panic/reboot notifier before the
+ * system enters a disabled, endless loop.
+ *
+ * Notice we must use the spin_trylock() alternative, to prevent lockups
+ * in atomic context (panic routine runs with secondary CPUs, local IRQs
+ * and preemption disabled).
  */
-static void
-con3270_flush(void)
+static int con3270_notify(struct notifier_block *self,
+			  unsigned long event, void *data)
 {
 	struct con3270 *cp;
 	unsigned long flags;
 
 	cp = condev;
 	if (!cp->view.dev)
-		return;
-	raw3270_activate_view(&cp->view);
-	spin_lock_irqsave(&cp->view.lock, flags);
+		return NOTIFY_DONE;
+
+	if (!raw3270_view_lock_unavailable(&cp->view))
+		raw3270_activate_view(&cp->view);
+
+	if (!spin_trylock_irqsave(&cp->view.lock, flags))
+		return NOTIFY_DONE;
+
 	con3270_wait_write(cp);
 	cp->nr_up = 0;
 	con3270_rebuild_update(cp);
@@ -560,23 +569,18 @@ con3270_flush(void)
 		con3270_wait_write(cp);
 	}
 	spin_unlock_irqrestore(&cp->view.lock, flags);
-}
 
-static int con3270_notify(struct notifier_block *self,
-			  unsigned long event, void *data)
-{
-	con3270_flush();
-	return NOTIFY_OK;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block on_panic_nb = {
 	.notifier_call = con3270_notify,
-	.priority = 0,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 static struct notifier_block on_reboot_nb = {
 	.notifier_call = con3270_notify,
-	.priority = 0,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 /*
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index dfde0d941c3c..7b87f9451508 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -830,6 +830,24 @@ raw3270_create_device(struct ccw_device *cdev)
 	return rp;
 }
 
+/*
+ * This helper just validates that it is safe to activate a
+ * view in the panic() context, due to locking restrictions.
+ */
+int
+raw3270_view_lock_unavailable(struct raw3270_view *view)
+{
+	struct raw3270 *rp = view->dev;
+
+	if (!rp)
+		return -ENODEV;
+
+	if (spin_is_locked(get_ccwdev_lock(rp->cdev)))
+		return -EBUSY;
+
+	return 0;
+}
+
 /*
  * Activate a view.
  */
diff --git a/drivers/s390/char/raw3270.h b/drivers/s390/char/raw3270.h
index c6645167cd2b..4cb6b5ee44ca 100644
--- a/drivers/s390/char/raw3270.h
+++ b/drivers/s390/char/raw3270.h
@@ -160,6 +160,7 @@ struct raw3270_view {
 };
 
 int raw3270_add_view(struct raw3270_view *, struct raw3270_fn *, int, int);
+int raw3270_view_lock_unavailable(struct raw3270_view *view);
 int raw3270_activate_view(struct raw3270_view *);
 void raw3270_del_view(struct raw3270_view *);
 void raw3270_deactivate_view(struct raw3270_view *);
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index fe5ee2646fcf..e5d947c763ea 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -220,30 +220,34 @@ sclp_console_device(struct console *c, int *index)
 }
 
 /*
- * Make sure that all buffers will be flushed to the SCLP.
+ * This panic/reboot notifier makes sure that all buffers
+ * will be flushed to the SCLP.
  */
-static void
-sclp_console_flush(void)
-{
-	sclp_conbuf_emit();
-	sclp_console_sync_queue();
-}
-
 static int sclp_console_notify(struct notifier_block *self,
 			       unsigned long event, void *data)
 {
-	sclp_console_flush();
-	return NOTIFY_OK;
+	/*
+	 * Perform the lock check before effectively getting the
+	 * lock on sclp_conbuf_emit() / sclp_console_sync_queue()
+	 * to prevent potential lockups in atomic context.
+	 */
+	if (spin_is_locked(&sclp_con_lock))
+		return NOTIFY_DONE;
+
+	sclp_conbuf_emit();
+	sclp_console_sync_queue();
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block on_panic_nb = {
 	.notifier_call = sclp_console_notify,
-	.priority = 1,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 static struct notifier_block on_reboot_nb = {
 	.notifier_call = sclp_console_notify,
-	.priority = 1,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 /*
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 3b4e7e5d9b71..a32f34a1c6d2 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -769,21 +769,6 @@ __initcall(sclp_vt220_tty_init);
 
 #ifdef CONFIG_SCLP_VT220_CONSOLE
 
-static void __sclp_vt220_flush_buffer(void)
-{
-	unsigned long flags;
-
-	sclp_vt220_emit_current();
-	spin_lock_irqsave(&sclp_vt220_lock, flags);
-	del_timer(&sclp_vt220_timer);
-	while (sclp_vt220_queue_running) {
-		spin_unlock_irqrestore(&sclp_vt220_lock, flags);
-		sclp_sync_wait();
-		spin_lock_irqsave(&sclp_vt220_lock, flags);
-	}
-	spin_unlock_irqrestore(&sclp_vt220_lock, flags);
-}
-
 static void
 sclp_vt220_con_write(struct console *con, const char *buf, unsigned int count)
 {
@@ -797,22 +782,41 @@ sclp_vt220_con_device(struct console *c, int *index)
 	return sclp_vt220_driver;
 }
 
+/*
+ * This panic/reboot notifier runs in atomic context, so
+ * locking restrictions apply to prevent potential lockups.
+ */
 static int
 sclp_vt220_notify(struct notifier_block *self,
 			  unsigned long event, void *data)
 {
-	__sclp_vt220_flush_buffer();
-	return NOTIFY_OK;
+	unsigned long flags;
+
+	if (spin_is_locked(&sclp_vt220_lock))
+		return NOTIFY_DONE;
+
+	sclp_vt220_emit_current();
+
+	spin_lock_irqsave(&sclp_vt220_lock, flags);
+	del_timer(&sclp_vt220_timer);
+	while (sclp_vt220_queue_running) {
+		spin_unlock_irqrestore(&sclp_vt220_lock, flags);
+		sclp_sync_wait();
+		spin_lock_irqsave(&sclp_vt220_lock, flags);
+	}
+	spin_unlock_irqrestore(&sclp_vt220_lock, flags);
+
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block on_panic_nb = {
 	.notifier_call = sclp_vt220_notify,
-	.priority = 1,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 static struct notifier_block on_reboot_nb = {
 	.notifier_call = sclp_vt220_notify,
-	.priority = 1,
+	.priority = INT_MIN + 1, /* run the callback late */
 };
 
 /* Structure needed to register with printk */
-- 
2.36.0

