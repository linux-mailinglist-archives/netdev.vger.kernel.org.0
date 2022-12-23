Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F6E6556D2
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 02:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiLXBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 20:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiLXBCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 20:02:25 -0500
X-Greylist: delayed 2400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 17:02:22 PST
Received: from 5.mo545.mail-out.ovh.net (5.mo545.mail-out.ovh.net [46.105.46.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E231F13DF3
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 17:02:22 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.108.4.242])
        by mo545.mail-out.ovh.net (Postfix) with ESMTPS id 56F8125F6D;
        Fri, 23 Dec 2022 23:46:58 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 00:46:56 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     <kernel-team@meta.com>, Dmitrii Banshchikov <me@ubique.spb.ru>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: [PATCH bpf-next v3 04/16] bpfilter: add map container
Date:   Sat, 24 Dec 2022 00:40:12 +0100
Message-ID: <20221223234127.474463-5-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221223234127.474463-1-qde@naccy.de>
References: <20221223234127.474463-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4463911657738137207
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddufecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepshgufhesghhoohhglhgvrdgtohhmpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpshhhuhgrhheskhgvrhhnvghlrdhorhhgpdhmhihkohhlrghlsehfsgdrtghomhdpphgrsggvnhhisehrvgguhhgrthdrtghomhdpkhhusggrsehkvghrnhgvlhdrohhrghdpvgguuhhmrgiivghtsehgohhoghhlvgdrtghomhdpuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvth
 dpjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhhrgholhhuohesghhoohhglhgvrdgtohhmpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhmvgesuhgsihhquhgvrdhsphgsrdhruhdpkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheeghedpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce common code for an associative container. This common code
will be used for maps of matches, targets, and tables. Hash search
tables from libc are used as an index.

The supported sets of operations is: create, find, upsert, free.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |  2 +-
 net/bpfilter/map-common.c                     | 51 +++++++++++++++
 net/bpfilter/map-common.h                     | 19 ++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  2 +
 tools/testing/selftests/bpf/bpfilter/Makefile | 19 ++++++
 .../testing/selftests/bpf/bpfilter/test_map.c | 63 +++++++++++++++++++
 6 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/map-common.c
 create mode 100644 net/bpfilter/map-common.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_map.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 8d9c726ba1a5..1b0c399c19df 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o logger.o
+bpfilter_umh-objs := main.o logger.o map-common.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/map-common.c b/net/bpfilter/map-common.c
new file mode 100644
index 000000000000..cc6c3a59b315
--- /dev/null
+++ b/net/bpfilter/map-common.c
@@ -0,0 +1,51 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
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
index 000000000000..666a4ffe9b29
--- /dev/null
+++ b/net/bpfilter/map-common.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
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
2.38.1

