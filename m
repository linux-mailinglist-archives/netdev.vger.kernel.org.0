Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D1326AA0
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 01:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhB0AI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 19:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhB0AIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 19:08:24 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA3EC06178B
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:06 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id v8so5918222ilh.12
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 16:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V/QgjySotsTTVdKM924dOYklYwsFMiK/ajNbbKthpHA=;
        b=gLHBNYEJB/sf0lZ4/ATW+Te0FFR47NHf7VvIgvncrWMDr5Ncc0RCGYGjoIHAF032oi
         JZBSvAxvwcy5o7uTFm1+5BqHSiF9W0SW1cjn/bXvhzUiDceQ3LeniAVFq6thAp81JvWu
         5ME9RGS1HUB9ZBRDkOe8pZE0R3lAGwRgLDfp4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V/QgjySotsTTVdKM924dOYklYwsFMiK/ajNbbKthpHA=;
        b=fxpe+sv7fKbpd1W7gVKX0RVieGKuMZ+Nd16rBpk4jkRirvOrfb5RUFoXVUAyPh7plx
         HIdTxQjxg1Tjrjl0b0LU8iXLeenikSovDznUpsjX/C4XL9mb+Lzwg5ZBlrIKFVq8ExIh
         yEidWA3PKnlqE6zQRx/+Xv1az/InfDlG7j52U1HYM1Y8ZK6xuWJ/E3t1s4vTgpAtNh8k
         76r+ZHZ+y+GMJuOJczTHXS94cFzyYkvnlTXh1ue93JTXCBIjTHoFgxs13vrUpWJ5rGhG
         u+v57pf5p1BDVQz8qiwSzZ06ENQ2NEbY78nWQBpjli1QcCYLNwOF/ByDL4qt77QdmrNB
         8Opw==
X-Gm-Message-State: AOAM532ryGfyCv4cmJFHdQsGh4oTAd510h+PAVubX+8LfVMQcN9g8tCW
        JfoEhWXpcsRFa9g4j9cevwREYw==
X-Google-Smtp-Source: ABdhPJyAon+ilh2FwUVc+YIJ6cSHG5ttF/eYAm9QraH2G+xx/rqg1Cg24nqYIM0+3ZcYRrFDVdxVAA==
X-Received: by 2002:a05:6e02:152f:: with SMTP id i15mr4713534ilu.277.1614384425759;
        Fri, 26 Feb 2021 16:07:05 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id w16sm5228805ilh.35.2021.02.26.16.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 16:07:05 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] lockdep: add lockdep lock state defines
Date:   Fri, 26 Feb 2021 17:06:59 -0700
Message-Id: <55548ba63a7e1b9f17cfc50370dcedefc9d5dd9f.1614383025.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1614383025.git.skhan@linuxfoundation.org>
References: <cover.1614383025.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds defines for lock state returns from lock_is_held_type() based on
Johannes Berg's suggestions as it make it easier to read and maintain
the lock states. These are defines and a enum to avoid changes to
lock_is_held_type() and lockdep_is_held() return types.

Updates to lock_is_held_type() and  __lock_is_held() to use the new
defines.

Link: https://lore.kernel.org/lkml/37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org/
Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 include/linux/lockdep.h  | 11 +++++++++--
 kernel/locking/lockdep.c | 11 ++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index dbd9ea846b36..17805aac0e85 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -268,6 +268,11 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 extern void lock_release(struct lockdep_map *lock, unsigned long ip);
 
+/* lock_is_held_type() returns */
+#define LOCK_STATE_UNKNOWN	-1
+#define LOCK_STATE_NOT_HELD	0
+#define LOCK_STATE_HELD		1
+
 /*
  * Same "read" as for lock_acquire(), except -1 means any.
  */
@@ -302,11 +307,13 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
 
 #define lockdep_assert_held(l)	do {					\
-		WARN_ON(debug_locks && lockdep_is_held(l) == 0);	\
+		WARN_ON(debug_locks &&					\
+			lockdep_is_held(l) == LOCK_STATE_NOT_HELD);	\
 	} while (0)
 
 #define lockdep_assert_not_held(l)	do {				\
-		WARN_ON(debug_locks && lockdep_is_held(l) == 1);	\
+		WARN_ON(debug_locks &&					\
+			lockdep_is_held(l) == LOCK_STATE_HELD);		\
 	} while (0)
 
 #define lockdep_assert_held_write(l)	do {			\
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 818d0ceed3eb..f5a8200f24f1 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -54,6 +54,7 @@
 #include <linux/nmi.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
+#include <linux/lockdep.h>
 
 #include <asm/sections.h>
 
@@ -5252,13 +5253,13 @@ int __lock_is_held(const struct lockdep_map *lock, int read)
 
 		if (match_held_lock(hlock, lock)) {
 			if (read == -1 || hlock->read == read)
-				return 1;
+				return LOCK_STATE_HELD;
 
-			return 0;
+			return LOCK_STATE_NOT_HELD;
 		}
 	}
 
-	return 0;
+	return LOCK_STATE_NOT_HELD;
 }
 
 static struct pin_cookie __lock_pin_lock(struct lockdep_map *lock)
@@ -5537,14 +5538,14 @@ EXPORT_SYMBOL_GPL(lock_release);
 noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 {
 	unsigned long flags;
-	int ret = 0;
+	int ret = LOCK_STATE_NOT_HELD;
 
 	/*
 	 * avoid false negative lockdep_assert_held() and
 	 * lockdep_assert_not_held()
 	 */
 	if (unlikely(!lockdep_enabled()))
-		return -1;
+		return LOCK_STATE_UNKNOWN;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
-- 
2.27.0

