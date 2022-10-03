Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236CB5F3567
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJCSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiJCSP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:15:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEF62AC5F
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:15:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1157FB811B2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 18:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE1DC433D6
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 18:15:52 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="fCdiazUD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1664820949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wbr6l1liVmpcbEEJMAT6hI4uzp1OCJusYxnU8Enxb70=;
        b=fCdiazUDhYNgNa1I1Q19XMuMKfCfoFfD7qteXwKHMjYzRuzKwv+OKAxK8ZsPSm5a3HWMVg
        3OW8fbWn7lHBZ8KAlzoaJgm6r8hqt0Vp/a0RHsRwNRWoKTkIbl3YWPAK1pKfCARk/GHoIL
        P09RzFEzagxJlHVb2sD43dMPruNvZtk=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f8f02928 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 3 Oct 2022 18:15:49 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH net-next] once: rename _SLOW to _SLEEPABLE
Date:   Mon,  3 Oct 2022 20:14:13 +0200
Message-Id: <20221003181413.1221968-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
References: <CAHmME9oh1aFCMBeV-vvtfMoCx4N5r_tABp79tkPNNLJnc1ug7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The _SLOW designation wasn't really descriptive of anything. This is
meant to be called from process context when it's possible to sleep. So
name this more aptly _SLEEPABLE, which better fits its intended use.

Fixes: 62c07983bef9 ("once: add DO_ONCE_SLOW() for sleepable contexts")
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/once.h       | 38 +++++++++++++++++++-------------------
 lib/once.c                 | 10 +++++-----
 net/ipv4/inet_hashtables.c |  4 ++--
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/once.h b/include/linux/once.h
index 176ab75b42df..bc714d414448 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -13,9 +13,9 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 		    unsigned long *flags, struct module *mod);
 
 /* Variant for process contexts only. */
-bool __do_once_slow_start(bool *done);
-void __do_once_slow_done(bool *done, struct static_key_true *once_key,
-			 struct module *mod);
+bool __do_once_sleepable_start(bool *done);
+void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
+			      struct module *mod);
 
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
@@ -61,26 +61,26 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 	})
 
 /* Variant of DO_ONCE() for process/sleepable contexts. */
-#define DO_ONCE_SLOW(func, ...)						     \
-	({								     \
-		bool ___ret = false;					     \
-		static bool __section(".data.once") ___done = false;	     \
-		static DEFINE_STATIC_KEY_TRUE(___once_key);		     \
-		if (static_branch_unlikely(&___once_key)) {		     \
-			___ret = __do_once_slow_start(&___done);	     \
-			if (unlikely(___ret)) {				     \
-				func(__VA_ARGS__);			     \
-				__do_once_slow_done(&___done, &___once_key,  \
-						    THIS_MODULE);	     \
-			}						     \
-		}							     \
-		___ret;							     \
+#define DO_ONCE_SLEEPABLE(func, ...)						\
+	({									\
+		bool ___ret = false;						\
+		static bool __section(".data.once") ___done = false;		\
+		static DEFINE_STATIC_KEY_TRUE(___once_key);			\
+		if (static_branch_unlikely(&___once_key)) {			\
+			___ret = __do_once_sleepable_start(&___done);		\
+			if (unlikely(___ret)) {					\
+				func(__VA_ARGS__);				\
+				__do_once_sleepable_done(&___done, &___once_key,\
+						    THIS_MODULE);		\
+			}							\
+		}								\
+		___ret;								\
 	})
 
 #define get_random_once(buf, nbytes)					     \
 	DO_ONCE(get_random_bytes, (buf), (nbytes))
 
-#define get_random_slow_once(buf, nbytes)				     \
-	DO_ONCE_SLOW(get_random_bytes, (buf), (nbytes))
+#define get_random_sleepable_once(buf, nbytes)				     \
+	DO_ONCE_SLEEPABLE(get_random_bytes, (buf), (nbytes))
 
 #endif /* _LINUX_ONCE_H */
diff --git a/lib/once.c b/lib/once.c
index 351f66aad310..2c306f0e891e 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -69,7 +69,7 @@ EXPORT_SYMBOL(__do_once_done);
 
 static DEFINE_MUTEX(once_mutex);
 
-bool __do_once_slow_start(bool *done)
+bool __do_once_sleepable_start(bool *done)
 	__acquires(once_mutex)
 {
 	mutex_lock(&once_mutex);
@@ -77,7 +77,7 @@ bool __do_once_slow_start(bool *done)
 		mutex_unlock(&once_mutex);
 		/* Keep sparse happy by restoring an even lock count on
 		 * this mutex. In case we return here, we don't call into
-		 * __do_once_done but return early in the DO_ONCE_SLOW() macro.
+		 * __do_once_done but return early in the DO_ONCE_SLEEPABLE() macro.
 		 */
 		__acquire(once_mutex);
 		return false;
@@ -85,9 +85,9 @@ bool __do_once_slow_start(bool *done)
 
 	return true;
 }
-EXPORT_SYMBOL(__do_once_slow_start);
+EXPORT_SYMBOL(__do_once_sleepable_start);
 
-void __do_once_slow_done(bool *done, struct static_key_true *once_key,
+void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
 			 struct module *mod)
 	__releases(once_mutex)
 {
@@ -95,4 +95,4 @@ void __do_once_slow_done(bool *done, struct static_key_true *once_key,
 	mutex_unlock(&once_mutex);
 	once_disable_jump(once_key, mod);
 }
-EXPORT_SYMBOL(__do_once_slow_done);
+EXPORT_SYMBOL(__do_once_sleepable_done);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index dc1c5629cd0d..a0ad34e4f044 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -958,8 +958,8 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	get_random_slow_once(table_perturb,
-			     INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	get_random_sleepable_once(table_perturb,
+				  INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
-- 
2.37.3

