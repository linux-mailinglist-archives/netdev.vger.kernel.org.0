Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7994A8A9EA
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfHLVw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:27 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:45178 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727594AbfHLVw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:26 -0400
Received: by mail-vs1-f73.google.com with SMTP id v20so28211993vsi.12
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2AgXEJvicJBSy/SRKWnK2/gvt/mXyTWKNhSQOzYorzg=;
        b=QD2Q9TVxotj25Bb1ouljTvMCvR83QJDYk2233b6aDf5UyAOc4+c3u0nYzqK2HiP9Jd
         mWjfm3fF7X8BxISaaea7HPxbpoGJAkgRdVmpjYKrjmNuH3MarsX7MS4wsNBe6G8n6f36
         n47LxqcnSGzw6RtyrzlLPb+EQoVzrvthsOmuGkhCqDIEAEO62T+Ih/9XGutE8xHgaxex
         niw/b9YZcCQAxTuG+nGc6XTtMhuRJ36Q9JkIWVX4S93KEdLzIXq0UIzJZCfKPIBEyf5h
         yv65GUdyh/ZiBeRFUstxqphaAC9yA1yaTYOoX+hpm1aZ4CwSO39oD+vxLn1QJTqzYfuB
         H22A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2AgXEJvicJBSy/SRKWnK2/gvt/mXyTWKNhSQOzYorzg=;
        b=MLZqqOC5dqjCU/ay6Hk9qPnxAsP2NuM8dJN2WsikZPLv49AeNmF0EH7rDLswmckEAa
         V7Es58n+G9wziTPFLMYGSXzghYI6w/PhEjibC1ZmtskHA6JyKZkDNMLSUZj6VFlesZnp
         esOJzu0dcqzMhh1dy+WxwO3jDxYyonk6389pXsLzhQ9EZXvc4Q6B/wUGrwhofKy2LOVH
         iFxBS97GLs+OuUI2O75aGNJA9wzfKTdCh/Isg0+IEBZ3BvMOaocBDSjyovKBlRZ2hxRe
         DiZBooU3S+EIsJ30ZwR/ygdZpxlkm5aHrg7k9y6tXb73jP5l4bd9H/6n0rU4xYsBeH8W
         AcYA==
X-Gm-Message-State: APjAAAUFGTL1bB6wthJ6QrwnmMRc3NVj1ohPyJ2B/F7YYiTVd7850uBn
        PgX0HvxwMK1lmXPb0JhjKLRmQaRIEsxVs3hldYQ=
X-Google-Smtp-Source: APXvYqyYgGBEoezTTpIvU8mq/ZQBKS1RsoV2oTSHueva+H2OsTqtCQ71O4GdWT1QoPUyVfobIUtoTQjr5ewI4rtj4B0=
X-Received: by 2002:a67:e447:: with SMTP id n7mr10737492vsm.115.1565646745461;
 Mon, 12 Aug 2019 14:52:25 -0700 (PDT)
Date:   Mon, 12 Aug 2019 14:50:43 -0700
In-Reply-To: <20190812215052.71840-1-ndesaulniers@google.com>
Message-Id: <20190812215052.71840-10-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20190812215052.71840-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH 10/16] powerpc: prefer __section and __printf from compiler_attributes.h
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     akpm@linux-foundation.org
Cc:     sedat.dilek@gmail.com, jpoimboe@redhat.com, yhs@fb.com,
        miguel.ojeda.sandonis@gmail.com,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Geoff Levand <geoff@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Rob Herring <robh@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/powerpc/boot/main.c         | 3 +--
 arch/powerpc/boot/ps3.c          | 6 ++----
 arch/powerpc/include/asm/cache.h | 2 +-
 arch/powerpc/kernel/btext.c      | 2 +-
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/boot/main.c b/arch/powerpc/boot/main.c
index 102cc546444d..3ccc84e06fc4 100644
--- a/arch/powerpc/boot/main.c
+++ b/arch/powerpc/boot/main.c
@@ -150,8 +150,7 @@ static struct addr_range prep_initrd(struct addr_range vmlinux, void *chosen,
  * edit the command line passed to vmlinux (by setting /chosen/bootargs).
  * The buffer is put in it's own section so that tools may locate it easier.
  */
-static char cmdline[BOOT_COMMAND_LINE_SIZE]
-	__attribute__((__section__("__builtin_cmdline")));
+static char cmdline[BOOT_COMMAND_LINE_SIZE] __section(__builtin_cmdline);
 
 static void prep_cmdline(void *chosen)
 {
diff --git a/arch/powerpc/boot/ps3.c b/arch/powerpc/boot/ps3.c
index c52552a681c5..70b2ed82d2de 100644
--- a/arch/powerpc/boot/ps3.c
+++ b/arch/powerpc/boot/ps3.c
@@ -24,8 +24,7 @@ extern int lv1_get_repository_node_value(u64 in_1, u64 in_2, u64 in_3,
 #ifdef DEBUG
 #define DBG(fmt...) printf(fmt)
 #else
-static inline int __attribute__ ((format (printf, 1, 2))) DBG(
-	const char *fmt, ...) {return 0;}
+static inline int __printf(1, 2) DBG(const char *fmt, ...) { return 0; }
 #endif
 
 BSS_STACK(4096);
@@ -35,8 +34,7 @@ BSS_STACK(4096);
  * The buffer is put in it's own section so that tools may locate it easier.
  */
 
-static char cmdline[BOOT_COMMAND_LINE_SIZE]
-	__attribute__((__section__("__builtin_cmdline")));
+static char cmdline[BOOT_COMMAND_LINE_SIZE] __section(__builtin_cmdline);
 
 static void prep_cmdline(void *chosen)
 {
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 45e3137ccd71..9114495855eb 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -91,7 +91,7 @@ static inline u32 l1_cache_bytes(void)
 	isync
 
 #else
-#define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_mostly __section(.data..read_mostly)
 
 #ifdef CONFIG_PPC_BOOK3S_32
 extern long _get_L2CR(void);
diff --git a/arch/powerpc/kernel/btext.c b/arch/powerpc/kernel/btext.c
index 6dfceaa820e4..f57712a55815 100644
--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -26,7 +26,7 @@
 static void scrollscreen(void);
 #endif
 
-#define __force_data __attribute__((__section__(".data")))
+#define __force_data __section(.data)
 
 static int g_loc_X __force_data;
 static int g_loc_Y __force_data;
-- 
2.23.0.rc1.153.gdeed80330f-goog

