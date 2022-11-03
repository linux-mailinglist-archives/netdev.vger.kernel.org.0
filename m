Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2ADD618A7F
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiKCVZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiKCVZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:25:35 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0B2018B
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:25:34 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l39-20020a05600c1d2700b003cf93c8156dso526431wms.4
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 14:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U6S2ZuEt0qgPUGG0AsxALXCScYxrmWzDM+6UP32zeuQ=;
        b=fa588U08aZVtksAr+gYqOxxYcKUoAQbyf6hqFyde0R9jc6mJqGkUElkSV19yh8wm2V
         BYtD7MoE/9JFWnZ2oTOMFwSYs1pEHNicUINDb3w22/NZfCE6MEGWiEqz6ORR8MAKz0hC
         JrJGsA0aZsT49K5vTQwU0UBXpM3qOkGdU7tSWD2TcPjwlbyxMrEuuvHw0HhN/yK7Z/UG
         sLtGOJvP25h9lcR02tNgi2A2CBXLJIkbspY1usDF50IsqvvjTVEDfN6V74v3640VCGBn
         DzCDfDutQY1VRKdXLtk2ch8ZoF1N/cdFsrQ6K0LZajNGZ1kb3W9bYa7VroHa4DwMQ2rk
         rtow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U6S2ZuEt0qgPUGG0AsxALXCScYxrmWzDM+6UP32zeuQ=;
        b=wYntWzinLONoVoLU9zDZZJYfD5qPVX1unSu7UfR83BNsvil7+Q043owG4SAhgxKvfY
         zncX9Iuxq0vZoFUROycDy6z2KKDiEu8mtpSUy1EZwCRozmRvB958pyslchplpK+wZIwQ
         W6133iH9r9kzBmv6Lvgwgl9niQKZL6kpOgPG6FZHsruAUgDfpfKr/PhtI9RAplo3V/oy
         2JQi5hbsjUJ9H+qK4jvXu/MImP3bLjVDNZN2FmdfrFGLYUC5F4jRkVk+Bm2P9FgNpoWe
         q62hXI2H2AgTPCqhRyYxb0LTkYCOtl/b/q5ol0DovOlVtSrvdHn0c/Oeuwzj3TL2FOJ6
         Uj8w==
X-Gm-Message-State: ACrzQf2woOtwX+/S3M+Y3OFquOhBl0/Jzy3ACzy0f4o0XN1y1OY2qbfJ
        jJI1YE7eAhE+vhfJUhd5BXcgig==
X-Google-Smtp-Source: AMsMyM69sea+RU7JIrUWgRP7XqWuZaaVpXvzXVvAeW4ilhVchMlFeWLl0aKjUGNk3ZQmBCZeaYpgPg==
X-Received: by 2002:a1c:a4c5:0:b0:3cf:56dc:fd14 with SMTP id n188-20020a1ca4c5000000b003cf56dcfd14mr20431140wme.180.1667510732944;
        Thu, 03 Nov 2022 14:25:32 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b003a601a1c2f7sm1038652wmq.19.2022.11.03.14.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:25:32 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 1/3] jump_label: Add static_key_fast_inc()
Date:   Thu,  3 Nov 2022 21:25:22 +0000
Message-Id: <20221103212524.865762-2-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103212524.865762-1-dima@arista.com>
References: <20221103212524.865762-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper to add another user for an existing enabled static key.

Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 include/linux/jump_label.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 570831ca9951..cb6c722c4816 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -75,6 +75,8 @@
 
 #include <linux/types.h>
 #include <linux/compiler.h>
+#include <linux/atomic.h>
+#include <linux/bug.h>
 
 extern bool static_key_initialized;
 
@@ -235,6 +237,21 @@ extern void static_key_enable_cpuslocked(struct static_key *key);
 extern void static_key_disable_cpuslocked(struct static_key *key);
 extern enum jump_label_type jump_label_init_type(struct jump_entry *entry);
 
+/***
+ * static_key_fast_inc - adds a user for a static key
+ * @key: static key that must be already enabled
+ *
+ * The caller must make sure that the static key can't get disabled while
+ * in this function. It doesn't patch jump labels, only adds a user to
+ * an already enabled static key.
+ */
+static inline void static_key_fast_inc(struct static_key *key)
+{
+	STATIC_KEY_CHECK_USE(key);
+	WARN_ON_ONCE(atomic_read(&key->enabled) < 1);
+	atomic_inc(&key->enabled);
+}
+
 /*
  * We should be using ATOMIC_INIT() for initializing .enabled, but
  * the inclusion of atomic.h is problematic for inclusion of jump_label.h
@@ -251,9 +268,6 @@ extern enum jump_label_type jump_label_init_type(struct jump_entry *entry);
 
 #else  /* !CONFIG_JUMP_LABEL */
 
-#include <linux/atomic.h>
-#include <linux/bug.h>
-
 static __always_inline int static_key_count(struct static_key *key)
 {
 	return arch_atomic_read(&key->enabled);
@@ -290,6 +304,7 @@ static inline void static_key_slow_dec(struct static_key *key)
 	atomic_dec(&key->enabled);
 }
 
+#define static_key_fast_inc(key) static_key_slow_inc(key)
 #define static_key_slow_inc_cpuslocked(key) static_key_slow_inc(key)
 #define static_key_slow_dec_cpuslocked(key) static_key_slow_dec(key)
 
-- 
2.38.1

