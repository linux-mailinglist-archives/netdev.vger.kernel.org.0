Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4D6232668C
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 18:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhBZRyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 12:54:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhBZRxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 12:53:42 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FE4C061793
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:52:20 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id z13so10484855iox.8
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RqKjcn5wYBxUDgGXla7FbQ8hvCQ5YPGkm8GvOW6PP/E=;
        b=RrvYZksgwaH67ZVRc4joOMms8r1OYTdoHXE2Z64g3k03EAqgOl+xfxRqrKdPLBQCqD
         9P2X5LJ7P1FLl26oNrdT/SZLMRs6Hh5JvPTRVmAf7HUgxz86AiUCdMNoqnOFVwGSor8F
         CQ2EJ2L/4UWf7DYLmegiVtOIJSan8XDN++IWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RqKjcn5wYBxUDgGXla7FbQ8hvCQ5YPGkm8GvOW6PP/E=;
        b=Mc1oVoSlxniDdkk5+j+8vAauDtxc6E9Y4yFOEPkiyiaEWi5FCOyblqiIgLt6SK2qjQ
         gTWZhTqYjeQ60urvl3E62XQ2TbviUz65E3cm0qit/NfjhIdnK50MUiUx4kNBqH8I1Zg3
         AUwpmIbEouWtNPyYGDxuxtIaSJaaQXhgV88moY1CSXyQCw/4v+t/FcWWR4CzfxidO46u
         nasNedkYVXQBrr8LYaB/g1+ew19sJDea2NF8x4YjyScGvg160IftQSG8row+VyjUD+GD
         tSnwaICyJ/2uCLzBES2vhd3j/0c1Kx5RCZO0N0Km3lkmKeRYW93WNH9S4WawilNxhO/L
         bwrQ==
X-Gm-Message-State: AOAM533cI1wnXgxS8DTxSRkcXWT/8/lbVNFLZvOSog7XN8lnYT6q+J5n
        liWdiL9m65g7OfWZAwlxTlQcrQ==
X-Google-Smtp-Source: ABdhPJy91vIDGXJWk9N2yqhUo0q6PdFitbP4jcPN+5IeoXRVv4Hj7tj3DiojkGULgr5M10ZnMYY32w==
X-Received: by 2002:a6b:b5c2:: with SMTP id e185mr3784589iof.204.1614361939843;
        Fri, 26 Feb 2021 09:52:19 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y25sm5594060ioa.5.2021.02.26.09.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 09:52:19 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] lockdep: add lockdep lock state defines
Date:   Fri, 26 Feb 2021 10:52:14 -0700
Message-Id: <af1511df953fe49f95953cbc23d86fb7cdaff58d.1614355914.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1614355914.git.skhan@linuxfoundation.org>
References: <cover.1614355914.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds defines for lock state returns from lock_is_held_type() based on
Johannes Berg's suggestions as it make it easier to read and maintain
the lock states. These are defines and a enum to avoid changes to
lock_is_held_type() and lockdep_is_held() return types.

Link: https://lore.kernel.org/lkml/37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org/
Link: https://lore.kernel.org/linux-wireless/871rdmu9z9.fsf@codeaurora.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 include/linux/lockdep.h  | 11 +++++++++--
 kernel/locking/lockdep.c |  3 ++-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 93eb5f797fc1..7c2622854152 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -261,6 +261,11 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 
 extern void lock_release(struct lockdep_map *lock, unsigned long ip);
 
+/* lock_is_held_type() returns */
+#define LOCK_STATE_UNKNOWN	-1
+#define LOCK_STATE_NOT_HELD	0
+#define LOCK_STATE_HELD		1
+
 /*
  * Same "read" as for lock_acquire(), except -1 means any.
  */
@@ -295,11 +300,13 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
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
index d3299fd85c4a..e3898c888ad2 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -54,6 +54,7 @@
 #include <linux/nmi.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
+#include <linux/lockdep.h>
 
 #include <asm/sections.h>
 
@@ -5475,7 +5476,7 @@ noinstr int lock_is_held_type(const struct lockdep_map *lock, int read)
 		/* avoid false negative lockdep_assert_not_held()
 		 * and lockdep_assert_held()
 		 */
-		return -1;
+		return LOCK_STATE_UNKNOWN;
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
-- 
2.27.0

