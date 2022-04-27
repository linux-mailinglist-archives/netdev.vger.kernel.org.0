Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAC951273F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241818AbiD0XFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239843AbiD0XBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:01:38 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0698E4EF42;
        Wed, 27 Apr 2022 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=durrkKWmzUfzH9qHOG14tQL4R8NCjUjLsTL3Zd00Gek=; b=My7iXYZdsvmohLkJmMGImfYof2
        p5qkpSJIhXISH+Sbyoj7EeJcOzhmrD5DtjdC6ethktkBlGYO4OfumrpixOUOKLn0Yc0W3TzG54aQY
        qwtzEOPADTIziH/itInY9Ffg69Sdqh65llZVZNXQlNolBLE2NFdio5E/kUq6oVXX/i2DBK4KweBxr
        JYm/gjauE4ZVcDNk28sbO0j6B73HXBblZWGmkswBaL+iIGNqLKObr06z5uxWmvVGTIOTQmQ/deHWL
        LutJobNbiLmganjaFUa+PvHzE64AyIeADEi0jWz8oHx43nzynoDLyNtzoi4XrtuDHAtIno5r39V8q
        Qw3pgkkw==;
Received: from [179.113.53.197] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1njqZo-0002Om-0k; Thu, 28 Apr 2022 00:56:04 +0200
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
        will@kernel.org
Subject: [PATCH 23/30] printk: kmsg_dump: Introduce helper to inform number of dumpers
Date:   Wed, 27 Apr 2022 19:49:17 -0300
Message-Id: <20220427224924.592546-24-gpiccoli@igalia.com>
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

Currently we don't have a way to check if there are dumpers set,
except counting the list members maybe. This patch introduces a very
simple helper to provide this information, by just keeping track of
registered/unregistered kmsg dumpers. It's going to be used on the
panic path in the subsequent patch.

Notice that the spinlock guarding kmsg_dumpers list also guards
increment/decrement of the dumper's counter, but there's no need
for that when reading the counter in the panic path, since that is
an atomic path and there's no other (planned) user.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 include/linux/kmsg_dump.h |  7 +++++++
 kernel/printk/printk.c    | 14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index 906521c2329c..abea1974bff8 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -65,6 +65,8 @@ bool kmsg_dump_get_buffer(struct kmsg_dump_iter *iter, bool syslog,
 
 void kmsg_dump_rewind(struct kmsg_dump_iter *iter);
 
+bool kmsg_has_dumpers(void);
+
 int kmsg_dump_register(struct kmsg_dumper *dumper);
 
 int kmsg_dump_unregister(struct kmsg_dumper *dumper);
@@ -91,6 +93,11 @@ static inline void kmsg_dump_rewind(struct kmsg_dump_iter *iter)
 {
 }
 
+static inline bool kmsg_has_dumpers(void)
+{
+	return false;
+}
+
 static inline int kmsg_dump_register(struct kmsg_dumper *dumper)
 {
 	return -EINVAL;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index da03c15ecc89..e3a1c429fbbc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3399,6 +3399,18 @@ EXPORT_SYMBOL(printk_timed_ratelimit);
 
 static DEFINE_SPINLOCK(dump_list_lock);
 static LIST_HEAD(dump_list);
+static int num_dumpers;
+
+/**
+ * kmsg_has_dumpers - inform if there is any kmsg dumper registered.
+ *
+ * Returns true if there's at least one registered dumper, or false
+ * if otherwise.
+ */
+bool kmsg_has_dumpers(void)
+{
+	return num_dumpers ? true : false;
+}
 
 /**
  * kmsg_dump_register - register a kernel log dumper.
@@ -3423,6 +3435,7 @@ int kmsg_dump_register(struct kmsg_dumper *dumper)
 		dumper->registered = 1;
 		list_add_tail_rcu(&dumper->list, &dump_list);
 		err = 0;
+		num_dumpers++;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 
@@ -3447,6 +3460,7 @@ int kmsg_dump_unregister(struct kmsg_dumper *dumper)
 		dumper->registered = 0;
 		list_del_rcu(&dumper->list);
 		err = 0;
+		num_dumpers--;
 	}
 	spin_unlock_irqrestore(&dump_list_lock, flags);
 	synchronize_rcu();
-- 
2.36.0

