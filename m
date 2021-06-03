Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7C6399E9F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhFCKQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFCKQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:16:40 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AFDC06175F
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 03:14:55 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l11-20020a05600c4f0bb029017a7cd488f5so3399114wmq.0
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=epMo+f/eNlt4LlGPzfnkDskp+A+/a1y/gqFYWM9IJC8=;
        b=k71EdRkxQcirEAm7G4VJeaOuVbUmxDlMHgMpe5SSPMnAsHYGOd9dpFhwrKNvuYXmnj
         udk0sZs0umPQ+fG69vd67ZJCWJYDmykNHa89DxIgYptWb7WrgprYV/CJvOOCySEfEFk6
         3CbGxJcsayFPncGds0rNZ8v1CYxvNW67y+T1YNOII4WUtG4PHzVYMHVPKuYMtOUCtRu1
         c6bpaXtZyRM1P7sRA4dOL2SiPI/NYnqTs7/zxIr9UQUM47sW78Sc2kAovQT/UyXlQDYw
         Gy78ofFQdCtfFXL0Qgqem5YaS3yug67slA12xzgYEpDCORYh+0ec6HrwO7JTAkoQrsWF
         DQ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=epMo+f/eNlt4LlGPzfnkDskp+A+/a1y/gqFYWM9IJC8=;
        b=leKUPKJpm2y7aMRWkdisJrIu52tU2ikvq6y6+F/9dK5huPP14Iy6iPs3F9xS9QdGHT
         miiT+xZ7BerxS2b8PhOzGAEEmM5Nj+cgeE+U9/As8HFYFoj08gYDDBL1ah+Mj26QHZoB
         IxZWwAJRXY9L3HnEi1t4SpQlzoBFKmZwKZeAwm2bmrSn4g2PyQsreQRBbuLHeUweGTYL
         Ar10JE8adQ4PlKOjEtOKPkAGzqy8I3+Jo4PV0T26ze+Ospl4Uak1KZdrgiMg20V0ZCbz
         oLmCMJSMYXOCuis3FW/CqjXH8iFzZXKH7PNF1eyFRpyB/FfMHRPhmo9M8n35ZfEJqcQp
         0Cdw==
X-Gm-Message-State: AOAM531dJDWnO5kJtUKSG9Q3vcQUHR3I3gQ0IKjGLac+JutOoIQ4b8dH
        STPjefmWKiiSVt0sNT4IijrBiA==
X-Google-Smtp-Source: ABdhPJzlibXpfWWZbItFVs1TbLYl8j1xe+IWHe4g323PqtGY4WMHhnGpkKic6h/ZD8W6hvjODNnXeg==
X-Received: by 2002:a1c:d5:: with SMTP id 204mr9351093wma.144.1622715294299;
        Thu, 03 Jun 2021 03:14:54 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id s2sm5168987wmc.21.2021.06.03.03.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:14:54 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 04/10] bpfilter: Add map container
Date:   Thu,  3 Jun 2021 14:14:19 +0400
Message-Id: <20210603101425.560384-5-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce common code for an associative container. This common code
will be used for maps of matches, targets and tables. Hash search tables
from libc are used as an index. The supported set of operations is:
insert, update and find.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  2 +-
 net/bpfilter/map-common.c                     | 64 +++++++++++++++++++
 net/bpfilter/map-common.h                     | 19 ++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  2 +
 tools/testing/selftests/bpf/bpfilter/Makefile | 17 +++++
 .../testing/selftests/bpf/bpfilter/test_map.c | 63 ++++++++++++++++++
 6 files changed, 166 insertions(+), 1 deletion(-)
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
index 000000000000..6a4ab0c5d3ec
--- /dev/null
+++ b/net/bpfilter/map-common.c
@@ -0,0 +1,64 @@
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
+void *map_find(struct hsearch_data *htab, const char *name)
+{
+	const ENTRY needle = { .key = (char *)name };
+	ENTRY *found;
+
+	if (!hsearch_r(needle, FIND, &found, htab))
+		return ERR_PTR(-ENOENT);
+
+	return found->data;
+}
+
+int map_update(struct hsearch_data *htab, const char *name, void *data)
+{
+	const ENTRY needle = { .key = (char *)name, .data = data };
+	ENTRY *found;
+
+	if (!hsearch_r(needle, ENTER, &found, htab))
+		return -errno;
+
+	found->key = (char *)name;
+	found->data = data;
+
+	return 0;
+}
+
+int map_insert(struct hsearch_data *htab, const char *name, void *data)
+{
+	const ENTRY needle = { .key = (char *)name, .data = data };
+	ENTRY *found;
+
+	if (!hsearch_r(needle, ENTER, &found, htab))
+		return -errno;
+
+	if (found->data != data)
+		return -EEXIST;
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
index 000000000000..b29829230eff
--- /dev/null
+++ b/net/bpfilter/map-common.h
@@ -0,0 +1,19 @@
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
+void *map_find(struct hsearch_data *htab, const char *name);
+int map_insert(struct hsearch_data *htab, const char *name, void *data);
+int map_update(struct hsearch_data *htab, const char *name, void *data);
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
index 000000000000..647229a0596c
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -0,0 +1,17 @@
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
+$(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
diff --git a/tools/testing/selftests/bpf/bpfilter/test_map.c b/tools/testing/selftests/bpf/bpfilter/test_map.c
new file mode 100644
index 000000000000..6ac61a634e41
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
+TEST_F(test_map, insert_and_find)
+{
+	void *found;
+
+	found = map_find(&self->map, self->key);
+	ASSERT_TRUE(IS_ERR(found))
+	ASSERT_EQ(-ENOENT, PTR_ERR(found))
+
+	ASSERT_EQ(0, map_insert(&self->map, self->key, self->expected));
+	ASSERT_EQ(0, map_insert(&self->map, self->key, self->expected));
+	ASSERT_EQ(-EEXIST, map_insert(&self->map, self->key, self->actual));
+
+	found = map_find(&self->map, self->key);
+
+	ASSERT_FALSE(IS_ERR(found));
+	ASSERT_STREQ(self->expected, found);
+}
+
+TEST_F(test_map, update)
+{
+	void *found;
+
+	ASSERT_EQ(0, map_insert(&self->map, self->key, self->actual));
+	ASSERT_EQ(0, map_update(&self->map, self->key, self->expected));
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

