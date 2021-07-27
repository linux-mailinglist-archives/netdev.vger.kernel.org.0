Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01F93D803B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbhG0VAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhG0U7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D311C0619D9
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m1so1827911pjv.2
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TnnuakIxzSbl2ekndF+mmNRk5JCUFYLmPq03TYEYi4k=;
        b=OPMH+TFnUyOTEkoxkT8a9j8pnksdmlN0EHCCksrBIkm8aOJzAl0mk/zWD1RoSGSmQz
         C/L9X9iBcobG1ib0rKCDjZAQKbHAE6R5gTbj2TCfQ0bFmmQczYMDgL/RRiTpYgFsbrW8
         HIkh5bpT1o12e3mnPAk9NbkSBT/Fxenz2D3aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TnnuakIxzSbl2ekndF+mmNRk5JCUFYLmPq03TYEYi4k=;
        b=fL0GxZrVeNQPHKmhhAmAROa0MgBBkMVrx92FoeWlcHi5b/TpZACEltHPDAMrmc5zOx
         hE9osgnUFvTsP0D6+75HR8uN035Xs46o9eqoU0S7ito5easWNUjCzwZk9xqHeAek0A8z
         Rph4kb+PPq8wwueATQBOQrBN1l/97VRBD1F2xtfcZS8KEmHf7oSy7NefJLL0jcNnkn8S
         Ca8fpwMIrWZgtKLsGUboq7r4ONuQlmCJm9jTPCodajWUlGFpzp8ASfbhGFzquxkAQJq8
         xV0RdtTOpZKtuFewZOkM9jKA1auAuH8VoUBl51rdse7/P2oXHtSC675XDfMSVguBntwX
         shOA==
X-Gm-Message-State: AOAM533gE04UH2PUw6Dq7DQb3x3+nO/pXdB641w3RyyWMPsgds2H/Hmg
        0O6M5rrP+ZcbewA2iWLMJD8n9g==
X-Google-Smtp-Source: ABdhPJxkBBzEoey05rWVspZzYMQI1JMDw2PU6mtY9bM/U5F8n9XWIHWcdKK6WHSgq+klclYhE6H0uQ==
X-Received: by 2002:a63:b1b:: with SMTP id 27mr25335957pgl.318.1627419553151;
        Tue, 27 Jul 2021 13:59:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id lt15sm3666524pjb.1.2021.07.27.13.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:12 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 32/64] fortify: Add compile-time FORTIFY_SOURCE tests
Date:   Tue, 27 Jul 2021 13:58:23 -0700
Message-Id: <20210727205855.411487-33-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727205855.411487-1-keescook@chromium.org>
References: <20210727205855.411487-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12511; h=from:subject; bh=Q4J+PNNQ0x2FrnExd2GwHSl8ygCKro8mVNuGZaaMvEE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOHi5BjqcFBl+fVaoddPaT/CE3HLMX7Qazay1gP NE/qbu+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzhwAKCRCJcvTf3G3AJiyCD/ 9585sT5/jANaceXo2dTbZNeExRTl60qzKyEptgQLDcqJQ/pFIiRSjR2+0L80/dIxqvN5/+ihCjDW7J lCJ6ZsCZXv68CLtTcWBldSTv3eUDI8StzDBDmDQRIWL/5FDUdyvXJWtPZdHNPE10asiv2l1CioXDoa NfhxbbrcVflJPgsM9GpqDGrQHMGANihgjnDGVmBgneVTW68KFFA9dc+ODfnE6zUPCMKiNjug/NMt+j 2GDoP40kDMm6VjUIA6Etvh0hcwV/L/hTOviNjwpvg9b3BibQqis1vPgggUETTlXn2EJQG2/D1SrJ30 5bAqoZ8n8T0ks/jqZXvHezrwBiCeNNoFoBARqEoPfErTigvKiUHaTT4wBMahrHizIRM155dGK/CHA6 h8aUk8QrQSwuaCcsl3nEpQLXQyW61FmXan4g40zpFcplT9dGLj4VGnSlyf13yXSnpxRcSVeSxTBSpq wUXKjf5LXgnkdMI6ru9eQ5DJ7By6AUd9RV69Pvvlym3hu7RafAgWQ0qqse7fG4DGRpBy3pLQI1oOsg Ju7VWB2w35RPMmODBa0sm1rh+eCuJcTk9nRvubxdoneCtG/2x1UVD4TYGBmVA80FM2ncZBrZJH9dWw V+iaOomJvPwMsKIPgbG0fjB3jlcHySCUo55X9f/zVnXGuGS6BPqDRnpXWYGQ==
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
 lib/.gitignore                              |  2 +
 lib/Makefile                                | 30 ++++++++++
 lib/test_fortify/read_overflow-memchr.c     |  5 ++
 lib/test_fortify/read_overflow-memchr_inv.c |  5 ++
 lib/test_fortify/read_overflow-memcmp.c     |  5 ++
 lib/test_fortify/read_overflow-memscan.c    |  5 ++
 lib/test_fortify/read_overflow2-memcmp.c    |  5 ++
 lib/test_fortify/read_overflow2-memcpy.c    |  5 ++
 lib/test_fortify/read_overflow2-memmove.c   |  5 ++
 lib/test_fortify/test_fortify.h             | 31 ++++++++++
 lib/test_fortify/write_overflow-memcpy.c    |  5 ++
 lib/test_fortify/write_overflow-memmove.c   |  5 ++
 lib/test_fortify/write_overflow-memset.c    |  5 ++
 lib/test_fortify/write_overflow-strlcpy.c   |  5 ++
 lib/test_fortify/write_overflow-strncpy.c   |  5 ++
 lib/test_fortify/write_overflow-strscpy.c   |  5 ++
 scripts/test_fortify.sh                     | 64 +++++++++++++++++++++
 17 files changed, 192 insertions(+)
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
 create mode 100644 lib/test_fortify/write_overflow-strlcpy.c
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
index 5efd1b435a37..40b4bf0bc847 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -360,3 +360,33 @@ obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
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
+$(obj)/test_fortify/%.log: $(src)/test_fortify/%.c $(srctree)/scripts/test_fortify.sh \
+			   $(srctree)/include/linux/fortify-string.h FORCE
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
index 000000000000..125f5c585e4f
--- /dev/null
+++ b/lib/test_fortify/test_fortify.h
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+
+void do_fortify_tests(void);
+
+# define __BUF_SMALL	16
+# define __BUF_LARGE	32
+struct fortify_object {
+	int a;
+	char buf[__BUF_SMALL];
+	int c;
+};
+const char small_src[__BUF_SMALL] = "AAAAAAAAAAAAAAA";
+const char large_src[__BUF_LARGE] = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
+
+char small[__BUF_SMALL];
+char large[__BUF_LARGE];
+struct fortify_object instance;
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
index 000000000000..59b362eed2ac
--- /dev/null
+++ b/scripts/test_fortify.sh
@@ -0,0 +1,64 @@
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
+FUNC="${FILE##*-}"
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
+# Skip this test, it is currently failing on all compilers.
+if [ "$WANT $FUNC" = "__write_overflow strlcpy" ] ; then
+	echo "skip: unsafe ${FUNC}() usage not checked for '$WANT' in $IN" > "$OUT"
+	exit 0
+fi
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

