Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0FDA3EFC60
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 08:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239090AbhHRGY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 02:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbhHRGYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 02:24:51 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE74C06129E
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:15 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id k24so1182512pgh.8
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 23:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=orREwqmDjC6eAbyLmeCBTfr28uXfwJ53YVeS5e6q0po=;
        b=bPPnHrhIoxiHuM8D+cA1VRSrPSxGoTSZYzeIp0b1bMI7T7u9fkHzfyCy90CBixJecQ
         8rQO70g2CIpjMfs6uIxO3ANUmFCIzSNPjrNE6HTUcqVjwNZ+V+Pgy0B/O1dDcj1VvxZ0
         kmsyQKHf4ee4t1fa2RmxDMulAyJEPUftMyLvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=orREwqmDjC6eAbyLmeCBTfr28uXfwJ53YVeS5e6q0po=;
        b=SxaPCXbyOcObWO61egzc9UiNbFh388z2VnCmXg3WUa4C7j33NCoRx7hAhPqH/Uvi18
         l9T8amdK8E5OfOJeAqejbCQ2hv36teAv1p2ut9J2VWwOk3OlUJsaXQrva55mSVveohN3
         muC0LBvZxcUwvNUKzt8yni1/2RpSMBqlYKmFUurHVv1kXRZXbbH56HLk/6suvtA4WVIY
         rgna5xLVjS2mmnRCAbEyexTDUeBeXdkp1RqQrYWO8HxWNfjLcfwnVOWEzxnpMawNoGWn
         uWTpNR72QXLTdkN8BTf0w2J7kH42Zl1j1ztZz4TYKGqgsLuS1y6qnIzh9HlKIiKNVX9l
         6bVA==
X-Gm-Message-State: AOAM533FxZaaeAjl9luIZPIVm5zOueMMQshtQ+AogWFSXnLF6qG5CjvN
        mP/8GdUjbaLEPI7+R6Vz2nCwCw==
X-Google-Smtp-Source: ABdhPJwhujyOzZJsyn/qls/NbUYTejcg76s5B/HGMQpCX0pMMUwKj7sY6oMzrnMq8C9M3Kvd92SiQQ==
X-Received: by 2002:a63:79c7:: with SMTP id u190mr7225234pgc.355.1629267854929;
        Tue, 17 Aug 2021 23:24:14 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j17sm4864162pfn.148.2021.08.17.23.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 23:24:12 -0700 (PDT)
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
Subject: [PATCH v2 33/63] lib: Introduce CONFIG_TEST_MEMCPY
Date:   Tue, 17 Aug 2021 23:05:03 -0700
Message-Id: <20210818060533.3569517-34-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210818060533.3569517-1-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9572; h=from:subject; bh=p1QoeTWxn6DEJODiVvxWPGNDYFdsmH5aDDL7ng36IGY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhHKMl2cfYNueA2t4nhVLJ6CVAeEsjEk0oThed6oX5 x/KTrVOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYRyjJQAKCRCJcvTf3G3AJjNtD/ 9N5316VubSv+/QS+eA4q6I4ZLlYJYJxhRVcKTXmABF+pqH1pk9B2RJ10lamIDk1OmGkZhAJqvpyRim EYokH8jG9ERic0ljriKnWlMvBvR/oqFpA/+1bZCKpqX2zEYltWlK61D3eS06lAM+vM40MAxt4J5p9B Qog/QGYXrYuMIkKd9yjMeabM28TL8oLSIggJhIMI1NOVYkgBVVHLiirmKkK4eoUR7ElzmioYXXkDIc viHwQIKCxcGk5M2nNFiGLLJWe4CWE7xcuhmbdAEUqvZ+JgzFWyjZyrFY+sd2X12ESGtgyB+sSYfcU+ LDVdEuxaVXzeBjbMVVfTSgmVirrL0zoSzHWADGXqRqmiOK4DWjAprBNTc49ylWScVtAuaWHSW2Y5Jm ro5UxxrVbOan+kZKESNzcaSOfaGbZd6OjmE4HHaA1VNsjzqT8nQOPmGIoX15aRPCO8Dd5ih9HjFxC9 6ku9y5cvlQG1ULxqdlizR6t2dQsYOSEsjiVZRuZoQy7xJW2rysHStYmf0mSCfZth19ppuksL9KS50A W2zNB45woRFFLXifUkqMD0FvJO173N3Tfc9qfMVHeDeSgZFfRo0oFUL4FXvnf5loAsIAq327/RJFrt n3UxEQGgNao9G6lvM0j3RPpuwsq2C5w76FchRc4K586gN5PfXPGaz1c3zyRw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before changing anything about memcpy(), memmove(), and memset(), add
run-time tests to check basic behaviors for any regressions.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/Kconfig.debug |   7 ++
 lib/Makefile      |   1 +
 lib/test_memcpy.c | 264 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 272 insertions(+)
 create mode 100644 lib/test_memcpy.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 139d362daa32..db2e8ffa6049 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2476,6 +2476,13 @@ config RATIONAL_KUNIT_TEST
 
 	  If unsure, say N.
 
+config MEMCPY_KUNIT_TEST
+	tristate "Test memcpy(), memmove(), and memset() functions at runtime" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds unit tests for memcpy(), memmove(), and memset() functions.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
diff --git a/lib/Makefile b/lib/Makefile
index bd17c2bf43e1..8a4c8bdb38a2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_TEST_MIN_HEAP) += test_min_heap.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_VMALLOC) += test_vmalloc.o
 obj-$(CONFIG_TEST_OVERFLOW) += test_overflow.o
+obj-$(CONFIG_TEST_MEMCPY) += test_memcpy.o
 obj-$(CONFIG_TEST_RHASHTABLE) += test_rhashtable.o
 obj-$(CONFIG_TEST_SORT) += test_sort.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
diff --git a/lib/test_memcpy.c b/lib/test_memcpy.c
new file mode 100644
index 000000000000..be192b8e82b7
--- /dev/null
+++ b/lib/test_memcpy.c
@@ -0,0 +1,264 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test cases for memcpy(), memmove(), and memset().
+ */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <kunit/test.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/overflow.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+struct some_bytes {
+	union {
+		u8 data[32];
+		struct {
+			u32 one;
+			u16 two;
+			u8  three;
+			/* 1 byte hole */
+			u32 four[4];
+		};
+	};
+};
+
+#define check(instance, v) do {	\
+	int i;	\
+	BUILD_BUG_ON(sizeof(instance.data) != 32);	\
+	for (i = 0; i < sizeof(instance.data); i++) {	\
+		KUNIT_ASSERT_EQ_MSG(test, instance.data[i], v, \
+			"line %d: '%s' not initialized to 0x%02x @ %d (saw 0x%02x)\n", \
+			__LINE__, #instance, v, i, instance.data[i]);	\
+	}	\
+} while (0)
+
+#define compare(name, one, two) do { \
+	int i; \
+	BUILD_BUG_ON(sizeof(one) != sizeof(two)); \
+	for (i = 0; i < sizeof(one); i++) {	\
+		KUNIT_EXPECT_EQ_MSG(test, one.data[i], two.data[i], \
+			"line %d: %s.data[%d] (0x%02x) != %s.data[%d] (0x%02x)\n", \
+			__LINE__, #one, i, one.data[i], #two, i, two.data[i]); \
+	}	\
+	kunit_info(test, "ok: " TEST_OP "() " name "\n");	\
+} while (0)
+
+static void memcpy_test(struct kunit *test)
+{
+#define TEST_OP "memcpy"
+	struct some_bytes control = {
+		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			},
+	};
+	struct some_bytes zero = { };
+	struct some_bytes middle = {
+		.data = { 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00,
+			  0x00, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			},
+	};
+	struct some_bytes three = {
+		.data = { 0x00, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x00, 0x00, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			  0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+			},
+	};
+	struct some_bytes dest = { };
+	int count;
+	u8 *ptr;
+
+	/* Verify static initializers. */
+	check(control, 0x20);
+	check(zero, 0);
+	compare("static initializers", dest, zero);
+
+	/* Verify assignment. */
+	dest = control;
+	compare("direct assignment", dest, control);
+
+	/* Verify complete overwrite. */
+	memcpy(dest.data, zero.data, sizeof(dest.data));
+	compare("complete overwrite", dest, zero);
+
+	/* Verify middle overwrite. */
+	dest = control;
+	memcpy(dest.data + 12, zero.data, 7);
+	compare("middle overwrite", dest, middle);
+
+	/* Verify argument side-effects aren't repeated. */
+	dest = control;
+	ptr = dest.data;
+	count = 1;
+	memcpy(ptr++, zero.data, count++);
+	ptr += 8;
+	memcpy(ptr++, zero.data, count++);
+	compare("argument side-effects", dest, three);
+#undef TEST_OP
+}
+
+static void memmove_test(struct kunit *test)
+{
+#define TEST_OP "memmove"
+	struct some_bytes control = {
+		.data = { 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			},
+	};
+	struct some_bytes zero = { };
+	struct some_bytes middle = {
+		.data = { 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x00, 0x00, 0x00, 0x00,
+			  0x00, 0x00, 0x00, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			},
+	};
+	struct some_bytes five = {
+		.data = { 0x00, 0x00, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x00, 0x00, 0x00, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			},
+	};
+	struct some_bytes overlap = {
+		.data = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+			  0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			},
+	};
+	struct some_bytes overlap_expected = {
+		.data = { 0x00, 0x01, 0x00, 0x01, 0x02, 0x03, 0x04, 0x07,
+			  0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			  0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99,
+			},
+	};
+	struct some_bytes dest = { };
+	int count;
+	u8 *ptr;
+
+	/* Verify static initializers. */
+	check(control, 0x99);
+	check(zero, 0);
+	compare("static initializers", zero, dest);
+
+	/* Verify assignment. */
+	dest = control;
+	compare("direct assignment", dest, control);
+
+	/* Verify complete overwrite. */
+	memmove(dest.data, zero.data, sizeof(dest.data));
+	compare("complete overwrite", dest, zero);
+
+	/* Verify middle overwrite. */
+	dest = control;
+	memmove(dest.data + 12, zero.data, 7);
+	compare("middle overwrite", dest, middle);
+
+	/* Verify argument side-effects aren't repeated. */
+	dest = control;
+	ptr = dest.data;
+	count = 2;
+	memmove(ptr++, zero.data, count++);
+	ptr += 9;
+	memmove(ptr++, zero.data, count++);
+	compare("argument side-effects", dest, five);
+
+	/* Verify overlapping overwrite is correct. */
+	ptr = &overlap.data[2];
+	memmove(ptr, overlap.data, 5);
+	compare("overlapping write", overlap, overlap_expected);
+#undef TEST_OP
+}
+
+static void memset_test(struct kunit *test)
+{
+#define TEST_OP "memset"
+	struct some_bytes control = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			},
+	};
+	struct some_bytes complete = {
+		.data = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+			},
+	};
+	struct some_bytes middle = {
+		.data = { 0x30, 0x30, 0x30, 0x30, 0x31, 0x31, 0x31, 0x31,
+			  0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31, 0x31,
+			  0x31, 0x31, 0x31, 0x31, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			},
+	};
+	struct some_bytes three = {
+		.data = { 0x60, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x61, 0x61, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			  0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30,
+			},
+	};
+	struct some_bytes dest = { };
+	int count, value;
+	u8 *ptr;
+
+	/* Verify static initializers. */
+	check(control, 0x30);
+	check(dest, 0);
+
+	/* Verify assignment. */
+	dest = control;
+	compare("direct assignment", dest, control);
+
+	/* Verify complete overwrite. */
+	memset(dest.data, 0xff, sizeof(dest.data));
+	compare("complete overwrite", dest, complete);
+
+	/* Verify middle overwrite. */
+	dest = control;
+	memset(dest.data + 4, 0x31, 16);
+	compare("middle overwrite", dest, middle);
+
+	/* Verify argument side-effects aren't repeated. */
+	dest = control;
+	ptr = dest.data;
+	value = 0x60;
+	count = 1;
+	memset(ptr++, value++, count++);
+	ptr += 8;
+	memset(ptr++, value++, count++);
+	compare("argument side-effects", dest, three);
+#undef TEST_OP
+}
+
+static struct kunit_case memcpy_test_cases[] = {
+	KUNIT_CASE(memset_test),
+	KUNIT_CASE(memcpy_test),
+	KUNIT_CASE(memmove_test),
+	{}
+};
+
+static struct kunit_suite memcpy_test_suite = {
+	.name = "memcpy-test",
+	.test_cases = memcpy_test_cases,
+};
+kunit_test_suite(memcpy_test_suite);
+
+MODULE_LICENSE("GPL");
-- 
2.30.2

