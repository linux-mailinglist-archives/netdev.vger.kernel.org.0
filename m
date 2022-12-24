Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1829E655671
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbiLXAFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233469AbiLXAEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:04:54 -0500
Received: from smtpout15.r2.mail-out.ovh.net (smtpout15.r2.mail-out.ovh.net [54.36.141.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E85719C1D
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:04:38 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.111.172.35])
        by mo512.mail-out.ovh.net (Postfix) with ESMTPS id EB8CC25F90;
        Sat, 24 Dec 2022 00:04:35 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:34 +0100
From:   Quentin Deslandes <qde@naccy.de>
To:     <qde@naccy.de>
CC:     Alexei Starovoitov <ast@kernel.org>,
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
        Dmitrii Banshchikov <me@ubique.spb.ru>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: [PATCH bpf-next v3 08/16] bpfilter: add match structure
Date:   Sat, 24 Dec 2022 01:03:54 +0100
Message-ID: <20221224000402.476079-9-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4761430709050994295
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeffveejjeeiffekueefgfdvudffveetleehiedvheekkeejfedufedvieduudeiffenucffohhmrghinhepuhhsvghrrdhnrghmvgenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvg
 hnihesrhgvughhrghtrdgtohhmpdhkuhgsrgeskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheduvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct match_ops defines a polymorphic interface for matches. A match
consists of pointers to struct match_ops and struct xt_entry_match which
contains a payload for the match's type.

The match interface supports the following operations:
- check: validate a rule's match.
- gen_inline: generate eBPF bytecode for the match.

All match_ops structures are kept in a map by their name.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |  1 +
 net/bpfilter/context.c                        | 43 ++++++++++++
 net/bpfilter/context.h                        |  3 +
 net/bpfilter/match.c                          | 55 +++++++++++++++
 net/bpfilter/match.h                          | 35 ++++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  7 ++
 .../selftests/bpf/bpfilter/bpfilter_util.h    | 22 ++++++
 .../selftests/bpf/bpfilter/test_match.c       | 69 +++++++++++++++++++
 9 files changed, 236 insertions(+)
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index ac039f1fac34..2f8d867a6038 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -13,6 +13,7 @@ $(LIBBPF_A):
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o logger.o map-common.o
 bpfilter_umh-objs += context.o codegen.o
+bpfilter_umh-objs += match.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index fdfd5fe78424..b5e172412fab 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -8,11 +8,54 @@
 
 #include "context.h"
 
+#include <linux/kernel.h>
+
+#include <string.h>
+
+#include "logger.h"
+#include "map-common.h"
+#include "match.h"
+
+static const struct match_ops *match_ops[] = { };
+
+static int init_match_ops_map(struct context *ctx)
+{
+	int r;
+
+	r = create_map(&ctx->match_ops_map, ARRAY_SIZE(match_ops));
+	if (r) {
+		BFLOG_ERR("failed to create matches map: %s", STRERR(r));
+		return r;
+	}
+
+	for (int i = 0; i < ARRAY_SIZE(match_ops); ++i) {
+		const struct match_ops *m = match_ops[i];
+
+		r = map_upsert(&ctx->match_ops_map, m->name, (void *)m);
+		if (r) {
+			BFLOG_ERR("failed to upsert in matches map: %s",
+				  STRERR(r));
+			return r;
+		}
+	}
+
+	return 0;
+}
+
 int create_context(struct context *ctx)
 {
+	int r;
+
+	r = init_match_ops_map(ctx);
+	if (r) {
+		BFLOG_ERR("failed to initialize matches map: %s", STRERR(r));
+		return r;
+	}
+
 	return 0;
 }
 
 void free_context(struct context *ctx)
 {
+	free_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index df41b9707a81..e36aa8ebf57e 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -7,7 +7,10 @@
 #ifndef NET_BPFILTER_CONTEXT_H
 #define NET_BPFILTER_CONTEXT_H
 
+#include <search.h>
+
 struct context {
+	struct hsearch_data match_ops_map;
 };
 
 int create_context(struct context *ctx);
diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
new file mode 100644
index 000000000000..fdb0926442a8
--- /dev/null
+++ b/net/bpfilter/match.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#define _GNU_SOURCE
+
+#include "match.h"
+
+#include <linux/err.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "context.h"
+#include "logger.h"
+#include "map-common.h"
+
+int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match,
+	       struct match *match)
+{
+	const size_t maxlen = sizeof(ipt_match->u.user.name);
+	const struct match_ops *found;
+	int r;
+
+	if (strnlen(ipt_match->u.user.name, maxlen) == maxlen) {
+		BFLOG_ERR("failed to init match: name too long");
+		return -EINVAL;
+	}
+
+	found = map_find(&ctx->match_ops_map, ipt_match->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_ERR("failed to find match by name: '%s'",
+			  ipt_match->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size + sizeof(*ipt_match) != ipt_match->u.match_size ||
+	    found->revision != ipt_match->u.user.revision) {
+		BFLOG_ERR("invalid match: '%s'", ipt_match->u.user.name);
+		return -EINVAL;
+	}
+
+	r = found->check(ctx, ipt_match);
+	if (r) {
+		BFLOG_ERR("match check failed: %s", STRERR(r));
+		return r;
+	}
+
+	match->match_ops = found;
+	match->ipt_match = ipt_match;
+
+	return 0;
+}
diff --git a/net/bpfilter/match.h b/net/bpfilter/match.h
new file mode 100644
index 000000000000..c6541e6a6567
--- /dev/null
+++ b/net/bpfilter/match.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#ifndef NET_BPFILTER_MATCH_H
+#define NET_BPFILTER_MATCH_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <stdint.h>
+
+struct bpfilter_ipt_match;
+struct codegen;
+struct context;
+struct match;
+
+struct match_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint8_t revision;
+	uint16_t size;
+	int (*check)(struct context *ctx, const struct bpfilter_ipt_match *ipt_match);
+	int (*gen_inline)(struct codegen *ctx, const struct match *match);
+};
+
+struct match {
+	const struct match_ops *match_ops;
+	const struct bpfilter_ipt_match *ipt_match;
+};
+
+int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match,
+	       struct match *match);
+
+#endif // NET_BPFILTER_MATCH_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 39ec0c09dff4..9ac1b3caf246 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 tools/**
 test_map
+test_match
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index e3b8bf76a10c..10642c1d6a87 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -11,6 +11,7 @@ BPFDIR := $(LIBDIR)/bpf
 CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 
 TEST_GEN_PROGS += test_map
+TEST_GEN_PROGS += test_match
 
 KSFT_KHDR_INSTALL := 1
 
@@ -34,5 +35,11 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
 
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
+BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c
+
+BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/logger.c
+BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
+$(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
new file mode 100644
index 000000000000..705fd1777a67
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef BPFILTER_UTIL_H
+#define BPFILTER_UTIL_H
+
+#include <linux/netfilter/x_tables.h>
+
+#include <stdio.h>
+#include <stdint.h>
+#include <string.h>
+
+static inline void init_entry_match(struct xt_entry_match *match,
+				    uint16_t size, uint8_t revision,
+				    const char *name)
+{
+	memset(match, 0, sizeof(*match));
+	sprintf(match->u.user.name, "%s", name);
+	match->u.user.match_size = size;
+	match->u.user.revision = revision;
+}
+
+#endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_match.c b/tools/testing/selftests/bpf/bpfilter/test_match.c
new file mode 100644
index 000000000000..4a0dc1b14e4d
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_match.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+
+#include "../../kselftest_harness.h"
+
+#include "context.h"
+#include "logger.h"
+#include "match.h"
+
+#include "bpfilter_util.h"
+
+/**
+ * struct udp_match - Dummy test structure.
+ *
+ * This structure provides enough space to allow for name too long, so it
+ * doesn't overwrite anything.
+ */
+struct udp_match {
+	struct xt_entry_match ipt_match;
+	char placeholder[32];
+};
+
+FIXTURE(test_match_init)
+{
+	struct context ctx;
+	struct udp_match udp_match;
+	struct match match;
+};
+
+FIXTURE_SETUP(test_match_init)
+{
+	logger_set_file(stderr);
+	ASSERT_EQ(0, create_context(&self->ctx));
+};
+
+FIXTURE_TEARDOWN(test_match_init)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_match_init, name_too_long)
+{
+	init_entry_match(&self->udp_match.ipt_match, sizeof(self->udp_match), 0,
+			 "this match name is supposed to be way too long...");
+
+	ASSERT_EQ(init_match(&self->ctx,
+			     (const struct bpfilter_ipt_match *)&self->udp_match
+				     .ipt_match,
+			     &self->match),
+		  -EINVAL);
+}
+
+TEST_F(test_match_init, not_found)
+{
+	init_entry_match(&self->udp_match.ipt_match, sizeof(self->udp_match), 0,
+			 "doesn't exist");
+
+	ASSERT_EQ(init_match(&self->ctx,
+			     (const struct bpfilter_ipt_match *)&self->udp_match
+				     .ipt_match,
+			     &self->match),
+		  -ENOENT);
+}
+
+TEST_HARNESS_MAIN
-- 
2.38.1

