Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BBD3EFC73
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240272AbhHRGZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbhHRGYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:52 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A632C06124C
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id o10so1220151plg.0
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7BVTAnQ8KWAba3s9PSeGwDU7zhQzuDKzH5xAAzSSPw=;
        b=ZMHNI+Ym8KFjOPStL1zRDeCs0DwWX9xKI5eAa1oIFJHt8Us0YTDCwe/vD3lBXav7qH
         GzfjdFeFvKTrN1oQr2xUCCPvc3ZhPpNbOitIEfvY4L88xkwWlI2xVLQ9SkFqscouFuO3
         qmtzNObAmhoOfnh1IOMAQ6DVjhOYZfe4W3Zlo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7BVTAnQ8KWAba3s9PSeGwDU7zhQzuDKzH5xAAzSSPw=;
        b=WtmnH/CPi9GAgpZvT3fyCWdTFBi6RI+yJ9277k0yrLepbFu/dk7CVa2HCgxLpWea+h
         +2Py5FF04niqhppPai8UcxM8i0B1u6MasQxc7NAm+pjD/QIfbrq7jIgYb+Z9+3t4Hw4L
         tgkm8xadpw+/21YXVPK3zaWHbo2CwRzg3WQBlhQhj+VWDgugxJotilhA4HPKB7ujGZ4g
         0fys3Drf/9l0EaaRUGMbKVIlaBOls3YkhlKl1bwPzLuUtH1ch1/GLMrH836pPC4NS3qE
         iyDr1nWRnFPft3XySBtU09PcEVfat3bJ+qaFc5kz0M0ui6WBGR3lli7Np/70wVzoHNpM
         kndQ==
X-Gm-Message-State: AOAM531uGNWUWlPWNXjzqjX8+hHCXZpxWfK+pA7lLie02GzolMF6Lv+B
        ayOcmdbpp+E0HOYqmFQBWiyDHg==
X-Google-Smtp-Source: ABdhPJwgoZqZPymW44bKh5Pf2I/v506zJoj9TsAAfRuwN7h6y4fxkDYAaTilqzgTnjATdxl92mSydg==
X-Received: by 2002:a17:90b:3ec3:: with SMTP id rm3mr7432229pjb.7.1629267856411;
        Tue, 17 Aug 2021 23:24:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id z33sm5580994pga.20.2021.08.17.23.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 32/63] fortify: Add compile-time FORTIFY_SOURCE tests
Date:   Tue, 17 Aug 2021 23:05:02 -0700
Message-Id: <20210818060533.3569517-33-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14488; h=from:subject; bh=4CFYuaBLYz0lFjOjNx//rrY4Et67yt92T+e8DD2y+sw=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMlm+MPDSarxn6l3GdHFIEU7LZvWMlELnRpy9uf Vje94jCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJQAKCRCJcvTf3G3AJrWQEA CeoUAbhRbS6vCwD6skjxcpFHdYQ8ewl5rHdVS5DiHMasJNh7bw1v2rKGfRKguHg7h739GlpBgw7haA YdunfnYKuZnM4kI2XMyXvKZwXinm+/sPci1V4/SWOwZhqUZKkQQe+Zx9S6X5PAhmkEVSaBmeJpCfbT DJw7qHosMLbW8Dzv6XjaOrXJ0298uuLXqyjj2en3dtnuXLTqgsj75jL6VlH7n/VhvcsULKxCeOs5T2 D5zXcHZj+FyVhq6T2prP0IqcaxDobhIgA4RvTJKmThNl/aibeWOSTBxHCBkxASgBKYiL2Sv7hxlXzz M9dd06Omw1K7jS1N821qbXbyAnCB4QbDT5j6LQZiyMDiDHXbvcaq8QyBHUj5c+eQj7MehHOaLNBGvv o+luwwhX2ErZVSlbyi8tmFROZNJrFGxgzpfIJMtMt7JYvxNTNwSwQbqkIO0iICBxjvUu97rygz7iPz I7MRLlc6br7hZiiVWz7xQGcGvMerwJ1Fbce0XJ+pFQdbKm7TquwHiZO0I2WheZuyHQb9upyrpjm6wZ TmQnXtwgb7LnKitlQ/RIjF2Kxha0SBst8LCJm4RqV3GafX4oFI/zPimeDgRTKlJFQ4GrpzEetxGnDe sOvpc5D0uldFLJf2G0UfypV8uBODHFmaO0xPGFo3TOtxM6aJ+dnJ4h7oU3ug==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While the run-time testing of FORTIFY_SOURCE is already present in
LKDTM, there is no testing of the expected compile-time detections. In
preparation for correctly supporting FORTIFY_SOURCE under Clang, adding
additional FORTIFY_SOURCE defenses, and making sure FORTIFY_SOURCE
doesn't silently regress with GCC, introduce a build-time test suite that
checks each expected compile-time failure condition.

As this is relatively backwards from standard build rules in the
sense that a successful test is actually a compile _failure_, create
a wrapper script to check for the correct errors, and wire it up as
a dummy dependency to lib/string.o, collecting the results into a log
file artifact.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/.gitignore                                |  2 +
 lib/Makefile                                  | 33 +++++++++++
 lib/test_fortify/read_overflow-memchr.c       |  5 ++
 lib/test_fortify/read_overflow-memchr_inv.c   |  5 ++
 lib/test_fortify/read_overflow-memcmp.c       |  5 ++
 lib/test_fortify/read_overflow-memscan.c      |  5 ++
 lib/test_fortify/read_overflow2-memcmp.c      |  5 ++
 lib/test_fortify/read_overflow2-memcpy.c      |  5 ++
 lib/test_fortify/read_overflow2-memmove.c     |  5 ++
 lib/test_fortify/test_fortify.h               | 35 +++++++++++
 lib/test_fortify/write_overflow-memcpy.c      |  5 ++
 lib/test_fortify/write_overflow-memmove.c     |  5 ++
 lib/test_fortify/write_overflow-memset.c      |  5 ++
 lib/test_fortify/write_overflow-strcpy-lit.c  |  5 ++
 lib/test_fortify/write_overflow-strcpy.c      |  5 ++
 lib/test_fortify/write_overflow-strlcpy-src.c |  5 ++
 lib/test_fortify/write_overflow-strlcpy.c     |  5 ++
 lib/test_fortify/write_overflow-strncpy-src.c |  5 ++
 lib/test_fortify/write_overflow-strncpy.c     |  5 ++
 lib/test_fortify/write_overflow-strscpy.c     |  5 ++
 scripts/test_fortify.sh                       | 59 +++++++++++++++++++
 21 files changed, 214 insertions(+)
 create mode 100644 lib/test_fortify/read_overflow-memchr.c
 create mode 100644 lib/test_fortify/read_overflow-memchr_inv.c
 create mode 100644 lib/test_fortify/read_overflow-memcmp.c
 create mode 100644 lib/test_fortify/read_overflow-memscan.c
 create mode 100644 lib/test_fortify/read_overflow2-memcmp.c
 create mode 100644 lib/test_fortify/read_overflow2-memcpy.c
 create mode 100644 lib/test_fortify/read_overflow2-memmove.c
 create mode 100644 lib/test_fortify/test_fortify.h
 create mode 100644 lib/test_fortify/write_overflow-memcpy.c
 create mode 100644 lib/test_fortify/write_overflow-memmove.c
 create mode 100644 lib/test_fortify/write_overflow-memset.c
 create mode 100644 lib/test_fortify/write_overflow-strcpy-lit.c
 create mode 100644 lib/test_fortify/write_overflow-strcpy.c
 create mode 100644 lib/test_fortify/write_overflow-strlcpy-src.c
 create mode 100644 lib/test_fortify/write_overflow-strlcpy.c
 create mode 100644 lib/test_fortify/write_overflow-strncpy-src.c
 create mode 100644 lib/test_fortify/write_overflow-strncpy.c
 create mode 100644 lib/test_fortify/write_overflow-strscpy.c
 create mode 100644 scripts/test_fortify.sh

diff --git a/lib/.gitignore b/lib/.gitignore
index 5e7fa54c4536..e5e217b8307b 100644
--- a/lib/.gitignore
+++ b/lib/.gitignore
@@ -4,3 +4,5 @@
 /gen_crc32table
 /gen_crc64table
 /oid_registry_data.c
+/test_fortify.log
+/test_fortify/*.log
diff --git a/lib/Makefile b/lib/Makefile
index 5efd1b435a37..bd17c2bf43e1 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -360,3 +360,36 @@ obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
 obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
+
+# FORTIFY_SOURCE compile-time behavior tests
+TEST_FORTIFY_SRCS = $(wildcard $(srctree)/$(src)/test_fortify/*-*.c)
+TEST_FORTIFY_LOGS = $(patsubst $(srctree)/$(src)/%.c, %.log, $(TEST_FORTIFY_SRCS))
+TEST_FORTIFY_LOG = test_fortify.log
+
+quiet_cmd_test_fortify = TEST    $@
+      cmd_test_fortify = $(CONFIG_SHELL) $(srctree)/scripts/test_fortify.sh \
+			$< $@ "$(NM)" $(CC) $(c_flags) \
+			$(call cc-disable-warning,fortify-source)
+
+targets += $(TEST_FORTIFY_LOGS)
+clean-files += $(TEST_FORTIFY_LOGS)
+clean-files += $(addsuffix .o, $(TEST_FORTIFY_LOGS))
+$(obj)/test_fortify/%.log: $(src)/test_fortify/%.c \
+			   $(src)/test_fortify/test_fortify.h \
+			   $(srctree)/include/linux/fortify-string.h \
+			   $(srctree)/scripts/test_fortify.sh \
+			   FORCE
+	$(call if_changed,test_fortify)
+
+quiet_cmd_gen_fortify_log = GEN     $@
+      cmd_gen_fortify_log = cat </dev/null $(filter-out FORCE,$^) 2>/dev/null > $@ || true
+
+targets += $(TEST_FORTIFY_LOG)
+clean-files += $(TEST_FORTIFY_LOG)
+$(obj)/$(TEST_FORTIFY_LOG): $(addprefix $(obj)/, $(TEST_FORTIFY_LOGS)) FORCE
+	$(call if_changed,gen_fortify_log)
+
+# Fake dependency to trigger the fortify tests.
+ifeq ($(CONFIG_FORTIFY_SOURCE),y)
+$(obj)/string.o: $(obj)/$(TEST_FORTIFY_LOG)
+endif
diff --git a/lib/test_fortify/read_overflow-memchr.c b/lib/test_fortify/read_overflow-memchr.c
new file mode 100644
index 000000000000..2743084b32af
--- /dev/null
+++ b/lib/test_fortify/read_overflow-memchr.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memchr(small, 0x7A, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow-memchr_inv.c b/lib/test_fortify/read_overflow-memchr_inv.c
new file mode 100644
index 000000000000..b26e1f1bc217
--- /dev/null
+++ b/lib/test_fortify/read_overflow-memchr_inv.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memchr_inv(small, 0x7A, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow-memcmp.c b/lib/test_fortify/read_overflow-memcmp.c
new file mode 100644
index 000000000000..d5d301ff64ef
--- /dev/null
+++ b/lib/test_fortify/read_overflow-memcmp.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcmp(small, large, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow-memscan.c b/lib/test_fortify/read_overflow-memscan.c
new file mode 100644
index 000000000000..c1a97f2df0f0
--- /dev/null
+++ b/lib/test_fortify/read_overflow-memscan.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memscan(small, 0x7A, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow2-memcmp.c b/lib/test_fortify/read_overflow2-memcmp.c
new file mode 100644
index 000000000000..c6091e640f76
--- /dev/null
+++ b/lib/test_fortify/read_overflow2-memcmp.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcmp(large, small, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow2-memcpy.c b/lib/test_fortify/read_overflow2-memcpy.c
new file mode 100644
index 000000000000..07b62e56cf16
--- /dev/null
+++ b/lib/test_fortify/read_overflow2-memcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcpy(large, instance.buf, sizeof(large))
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/read_overflow2-memmove.c b/lib/test_fortify/read_overflow2-memmove.c
new file mode 100644
index 000000000000..34edfab040a3
--- /dev/null
+++ b/lib/test_fortify/read_overflow2-memmove.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memmove(large, instance.buf, sizeof(large))
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/test_fortify.h b/lib/test_fortify/test_fortify.h
new file mode 100644
index 000000000000..e1dfe64d79a3
--- /dev/null
+++ b/lib/test_fortify/test_fortify.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+void do_fortify_tests(void);
+
+#define __BUF_SMALL	16
+#define __BUF_LARGE	32
+struct fortify_object {
+	int a;
+	char buf[__BUF_SMALL];
+	int c;
+};
+
+#define LITERAL_SMALL "AAAAAAAAAAAAAAA"
+#define LITERAL_LARGE "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
+const char small_src[__BUF_SMALL] = LITERAL_SMALL;
+const char large_src[__BUF_LARGE] = LITERAL_LARGE;
+
+char small[__BUF_SMALL];
+char large[__BUF_LARGE];
+struct fortify_object instance;
+size_t size;
+
+void do_fortify_tests(void)
+{
+	/* Normal initializations. */
+	memset(&instance, 0x32, sizeof(instance));
+	memset(small, 0xA5, sizeof(small));
+	memset(large, 0x5A, sizeof(large));
+
+	TEST;
+}
diff --git a/lib/test_fortify/write_overflow-memcpy.c b/lib/test_fortify/write_overflow-memcpy.c
new file mode 100644
index 000000000000..3b3984e428fb
--- /dev/null
+++ b/lib/test_fortify/write_overflow-memcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memcpy(instance.buf, large_src, sizeof(large_src))
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-memmove.c b/lib/test_fortify/write_overflow-memmove.c
new file mode 100644
index 000000000000..640437c3b3e0
--- /dev/null
+++ b/lib/test_fortify/write_overflow-memmove.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memmove(instance.buf, large_src, sizeof(large_src))
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-memset.c b/lib/test_fortify/write_overflow-memset.c
new file mode 100644
index 000000000000..36e34908cfb3
--- /dev/null
+++ b/lib/test_fortify/write_overflow-memset.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	memset(instance.buf, 0x5A, sizeof(large_src))
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strcpy-lit.c b/lib/test_fortify/write_overflow-strcpy-lit.c
new file mode 100644
index 000000000000..51effb3e50f9
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strcpy-lit.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strcpy(small, LITERAL_LARGE)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strcpy.c b/lib/test_fortify/write_overflow-strcpy.c
new file mode 100644
index 000000000000..84f1c56a64c8
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strcpy(small, large_src)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strlcpy-src.c b/lib/test_fortify/write_overflow-strlcpy-src.c
new file mode 100644
index 000000000000..91bf83ebd34a
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strlcpy-src.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strlcpy(small, large_src, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strlcpy.c b/lib/test_fortify/write_overflow-strlcpy.c
new file mode 100644
index 000000000000..1883db7c0cd6
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strlcpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strlcpy(instance.buf, large_src, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strncpy-src.c b/lib/test_fortify/write_overflow-strncpy-src.c
new file mode 100644
index 000000000000..8dcfb8c788dd
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strncpy-src.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strncpy(small, large_src, sizeof(small) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strncpy.c b/lib/test_fortify/write_overflow-strncpy.c
new file mode 100644
index 000000000000..b85f079c815d
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strncpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strncpy(instance.buf, large_src, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
diff --git a/lib/test_fortify/write_overflow-strscpy.c b/lib/test_fortify/write_overflow-strscpy.c
new file mode 100644
index 000000000000..38feddf377dc
--- /dev/null
+++ b/lib/test_fortify/write_overflow-strscpy.c
@@ -0,0 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define TEST	\
+	strscpy(instance.buf, large_src, sizeof(instance.buf) + 1)
+
+#include "test_fortify.h"
diff --git a/scripts/test_fortify.sh b/scripts/test_fortify.sh
new file mode 100644
index 000000000000..a6d63871738b
--- /dev/null
+++ b/scripts/test_fortify.sh
@@ -0,0 +1,59 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0-only
+set -e
+
+# Argument 1: Source file to build.
+IN="$1"
+shift
+# Extract just the filename for error messages below.
+FILE="${IN##*/}"
+# Extract the function name for error messages below.
+FUNC="${FILE#*-}"
+FUNC="${FUNC%%-*}"
+FUNC="${FUNC%%.*}"
+# Extract the symbol to test for in build/symbol test below.
+WANT="__${FILE%%-*}"
+
+# Argument 2: Where to write the build log.
+OUT="$1"
+shift
+TMP="${OUT}.tmp"
+
+# Argument 3: Path to "nm" tool.
+NM="$1"
+shift
+
+# Remaining arguments are: $(CC) $(c_flags)
+
+# Clean up temporary file at exit.
+__cleanup() {
+	rm -f "$TMP"
+}
+trap __cleanup EXIT
+
+status=
+# Attempt to build a source that is expected to fail with a specific warning.
+if "$@" -Werror -c "$IN" -o "$OUT".o 2> "$TMP" ; then
+	# If the build succeeds, either the test has failed or the the
+	# warning may only happen at link time (Clang). In that case,
+	# make sure the expected symbol is unresolved in the symbol list.
+	# If so, FORTIFY is working for this case.
+	if ! $NM -A "$OUT".o | grep -m1 "\bU ${WANT}$" >>"$TMP" ; then
+		status="warning: unsafe ${FUNC}() usage lacked '$WANT' symbol in $IN"
+	fi
+else
+	# If the build failed, check for the warning in the stderr (gcc).
+	if ! grep -q -m1 "error:.*\b${WANT}'" "$TMP" ; then
+		status="warning: unsafe ${FUNC}() usage lacked '$WANT' warning in $IN"
+	fi
+fi
+
+if [ -n "$status" ]; then
+	# Report on failure results, including compilation warnings.
+	echo "$status" | tee "$OUT" >&2
+	cat "$TMP" | tee -a "$OUT" >&2
+else
+	# Report on good results, and save any compilation output to log.
+	echo "ok: unsafe ${FUNC}() usage correctly detected with '$WANT' in $IN" >"$OUT"
+	cat "$TMP" >>"$OUT"
+fi
-- 
2.30.2

