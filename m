Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8BBE3FADD3
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhH2She (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbhH2Sh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:27 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EE3C06175F
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id t19so26184286ejr.8
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yjMwzlzJCsJ2K95uZCEDXsotI3JR8EQAiCrEaLA40kc=;
        b=vP1uOWqYdK6vBWvlt/QAyX/lNgefEeCuV9l0mIfrScvL51v6Rg8YgGUXIx6SWDcIEL
         X1/QXBZK26dRj9mCfGJ1O9fqI1++8y7BnA4R4tGpcrfrLp/mznJjJUoQoc+Pr0jQhcGQ
         ppOmISsWcs3nhQUoXKuaL9JgyII6d+PC1e16Hm5Pvg/bCv1n7WYmmCCZk/SK10k+1Om6
         nT1HSRCGfXcjqMr8+n0cl/lademJvI6RO3AjSWUM6mylV5ztP6/aCclMqp9TwR0fAczZ
         fOJ6aRjJkzDETVV2FGBL/DkpaG9yoD8fSGoWXE5kUPfGDGKBBNEAvTJ8z7Bk5HS4Gag7
         XGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjMwzlzJCsJ2K95uZCEDXsotI3JR8EQAiCrEaLA40kc=;
        b=fk3QggDQkVwtiXmOVjiaBY06HUzbXZHh9D+7xKEDqAfB3fX8X8bh9GtFgVZu7y9VJf
         bJ2dbFgbpHyzwsBBsOkZid8ZaZKDsYiAVi+woeiK0lKhWna59iRdByYfDh+MZVxPyOMA
         mpIndoIomcEFBAQCiN0ytafecG7VSnFpGzE8U3sCtlm3/5BpSPvMSQndi655uJ3T76Pa
         JvPgkRe61IW4Woy5GOJdLGiug05jGCDg+ccix0oV4h3NtS3710IVs9k69Jr2i+dv4DpE
         YXKWzopZH3lQFN43yTqAS/1UyngyFJp1IUKQ7TU83G/tNu4iYikJNt0+m1tEBXb3pd7/
         uZuw==
X-Gm-Message-State: AOAM533wYF93wMtEdf8zsfRKuSVjs+nnIstTPZM70pPyH8rkEJHrSfFu
        ZQcs93v+rQ65HA3MFtnBiOdMLQ==
X-Google-Smtp-Source: ABdhPJwPtLUG1xuQn5zeWY2m07B2NnXNA6nY1TnNsXYMCrIL25NH6tHMnRasLCl6mg0878Eh8xUHBQ==
X-Received: by 2002:a17:906:d183:: with SMTP id c3mr21211752ejz.283.1630262193127;
        Sun, 29 Aug 2021 11:36:33 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id lu4sm5440475ejb.103.2021.08.29.11.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:32 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 04/13] bpfilter: Add map container
Date:   Sun, 29 Aug 2021 22:35:59 +0400
Message-Id: <20210829183608.2297877-5-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce common code for an associative container. This common code
will be used for maps of matches, targets and tables. Hash search tables
from libc are used as an index. The supported set of operations is:
find and upsert.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  2 +-
 net/bpfilter/map-common.c                     | 50 +++++++++++++++
 net/bpfilter/map-common.h                     | 18 ++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  2 +
 tools/testing/selftests/bpf/bpfilter/Makefile | 19 ++++++
 .../testing/selftests/bpf/bpfilter/test_map.c | 63 +++++++++++++++++++
 6 files changed, 153 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/map-common.c
 create mode 100644 net/bpfilter/map-common.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index cdac82b8c53a..1809759d08c4 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o
+bpfilter_umh-objs := main.o map-common.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/map-common.c b/net/bpfilter/map-common.c
new file mode 100644
index 000000000000..f933929a3909
--- /dev/null
+++ b/net/bpfilter/map-common.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#include "map-common.h"
+
+#include <linux/err.h>
+
+#include <errno.h>
+#include <string.h>
+
+int create_map(struct hsearch_data *htab, size_t nelem)
+{
+	memset(htab, 0, sizeof(*htab));
+	if (!hcreate_r(nelem, htab))
+		return -errno;
+
+	return 0;
+}
+
+void *map_find(struct hsearch_data *htab, const char *key)
+{
+	const ENTRY needle = { .key = (char *)key };
+	ENTRY *found;
+
+	if (!hsearch_r(needle, FIND, &found, htab))
+		return ERR_PTR(-ENOENT);
+
+	return found->data;
+}
+
+int map_upsert(struct hsearch_data *htab, const char *key, void *value)
+{
+	const ENTRY needle = { .key = (char *)key, .data = value };
+	ENTRY *found;
+
+	if (!hsearch_r(needle, ENTER, &found, htab))
+		return -errno;
+
+	found->key = (char *)key;
+	found->data = value;
+
+	return 0;
+}
+
+void free_map(struct hsearch_data *htab)
+{
+	hdestroy_r(htab);
+}
diff --git a/net/bpfilter/map-common.h b/net/bpfilter/map-common.h
new file mode 100644
index 000000000000..236ba906828e
--- /dev/null
+++ b/net/bpfilter/map-common.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_MAP_COMMON_H
+#define NET_BPFILTER_MAP_COMMON_H
+
+#define _GNU_SOURCE
+
+#include <search.h>
+
+int create_map(struct hsearch_data *htab, size_t nelem);
+void *map_find(struct hsearch_data *htab, const char *key);
+int map_upsert(struct hsearch_data *htab, const char *key, void *value);
+void free_map(struct hsearch_data *htab);
+
+#endif // NET_BPFILTER_MAP_COMMON_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
new file mode 100644
index 000000000000..983fd06cbefa
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+test_map
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
new file mode 100644
index 000000000000..c262aad8c2a4
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0
+
+top_srcdir = ../../../../..
+TOOLSDIR := $(abspath ../../../../)
+TOOLSINCDIR := $(TOOLSDIR)/include
+APIDIR := $(TOOLSINCDIR)/uapi
+BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
+
+CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
+
+TEST_GEN_PROGS += test_map
+
+KSFT_KHDR_INSTALL := 1
+
+include ../../lib.mk
+
+BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
+
+$(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/test_map.c b/tools/testing/selftests/bpf/bpfilter/test_map.c
new file mode 100644
index 000000000000..7ed737b78816
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_map.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "map-common.h"
+
+#include <linux/err.h>
+
+#include "../../kselftest_harness.h"
+
+FIXTURE(test_map)
+{
+	struct hsearch_data map;
+	const char *key;
+	void *expected;
+	void *actual;
+};
+
+FIXTURE_SETUP(test_map)
+{
+	const int max_nelements = 100;
+
+	create_map(&self->map, max_nelements);
+	self->key = "key";
+	self->expected = "expected";
+	self->actual = "actual";
+}
+
+FIXTURE_TEARDOWN(test_map)
+{
+	free_map(&self->map);
+}
+
+TEST_F(test_map, upsert_and_find)
+{
+	void *found;
+
+	found = map_find(&self->map, self->key);
+	ASSERT_TRUE(IS_ERR(found))
+	ASSERT_EQ(-ENOENT, PTR_ERR(found))
+
+	ASSERT_EQ(0, map_upsert(&self->map, self->key, self->expected));
+	ASSERT_EQ(0, map_upsert(&self->map, self->key, self->expected));
+	ASSERT_EQ(0, map_upsert(&self->map, self->key, self->actual));
+
+	found = map_find(&self->map, self->key);
+
+	ASSERT_FALSE(IS_ERR(found));
+	ASSERT_STREQ(self->actual, found);
+}
+
+TEST_F(test_map, update)
+{
+	void *found;
+
+	ASSERT_EQ(0, map_upsert(&self->map, self->key, self->actual));
+	ASSERT_EQ(0, map_upsert(&self->map, self->key, self->expected));
+
+	found = map_find(&self->map, self->key);
+
+	ASSERT_FALSE(IS_ERR(found));
+	ASSERT_STREQ(self->expected, found);
+}
+
+TEST_HARNESS_MAIN
-- 
2.25.1

