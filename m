Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B16F65569E
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 01:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiLXAVL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 19:21:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiLXAVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 19:21:10 -0500
X-Greylist: delayed 989 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 23 Dec 2022 16:21:09 PST
Received: from 5.mo619.mail-out.ovh.net (5.mo619.mail-out.ovh.net [46.105.40.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CDFB49F
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 16:21:09 -0800 (PST)
Received: from ex4.mail.ovh.net (unknown [10.109.143.210])
        by mo619.mail-out.ovh.net (Postfix) with ESMTPS id EDD8922EA5;
        Sat, 24 Dec 2022 00:04:36 +0000 (UTC)
Received: from dev-fedora-x86-64.naccy.de (37.65.8.229) by
 DAG10EX1.indiv4.local (172.16.2.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 01:04:35 +0100
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
Subject: [PATCH bpf-next v3 09/16] bpfilter: add support for src/dst addr and ports
Date:   Sat, 24 Dec 2022 01:03:55 +0100
Message-ID: <20221224000402.476079-10-qde@naccy.de>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221224000402.476079-1-qde@naccy.de>
References: <20221224000402.476079-1-qde@naccy.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [37.65.8.229]
X-ClientProxiedBy: CAS6.indiv4.local (172.16.1.6) To DAG10EX1.indiv4.local
 (172.16.2.91)
X-Ovh-Tracer-Id: 4761712181562895991
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -85
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrheefgddujecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenogetfedtuddqtdduucdludehmdenucfjughrpefhvfevufffkffojghfggfgtghisehtkeertdertddtnecuhfhrohhmpefsuhgvnhhtihhnucffvghslhgrnhguvghsuceoqhguvgesnhgrtggthidruggvqeenucggtffrrghtthgvrhhnpeduledugfeileetvdelieeujedttedtvedtgfetteevfeejhfffkeeujeetfffgudenucfkphepuddvjedrtddrtddruddpfeejrdeihedrkedrvddvleenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoehquggvsehnrggttgihrdguvgeqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepjhholhhsrgeskhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkshgvlhhfthgvshhtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdgsphhfsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpmhgvsehusghiqhhuvgdrshhpsgdrrhhupdhshhhurghhsehkvghrnhgvlhdrohhrghdpmhihkhholhgrlhesfhgsrdgtohhmpdhprggsvghnihesrhgvughhrghtrdgtohhmpdhkuhgsrg
 eskhgvrhhnvghlrdhorhhgpdgvughumhgriigvthesghhoohhglhgvrdgtohhmpdgurghvvghmsegurghvvghmlhhofhhtrdhnvghtpdhkvghrnhgvlhdqthgvrghmsehmvghtrgdrtghomhdphhgrohhluhhosehgohhoghhlvgdrtghomhdpshgufhesghhoohhglhgvrdgtohhmpdhkphhsihhnghhhsehkvghrnhgvlhdrohhrghdpjhhohhhnrdhfrghsthgrsggvnhgusehgmhgrihhlrdgtohhmpdihhhhssehfsgdrtghomhdpshhonhhgsehkvghrnhgvlhdrohhrghdpmhgrrhhtihhnrdhlrghusehlihhnuhigrdguvghvpdgrnhgurhhiiheskhgvrhhnvghlrdhorhhgpdgurghnihgvlhesihhoghgvrghrsghogidrnhgvthdprghstheskhgvrhhnvghlrdhorhhgpdhnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoieduledpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement support for source and destination addresses and ports
matching.

Co-developed-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
Signed-off-by: Quentin Deslandes <qde@naccy.de>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |   2 +-
 net/bpfilter/match.h                          |   2 +
 net/bpfilter/xt_udp.c                         | 111 ++++++++++++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   6 +-
 .../selftests/bpf/bpfilter/test_xt_udp.c      |  48 ++++++++
 7 files changed, 168 insertions(+), 4 deletions(-)
 create mode 100644 net/bpfilter/xt_udp.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_xt_udp.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 2f8d867a6038..345341a9ee30 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -13,7 +13,7 @@ $(LIBBPF_A):
 userprogs := bpfilter_umh
 bpfilter_umh-objs := main.o logger.o map-common.o
 bpfilter_umh-objs += context.o codegen.o
-bpfilter_umh-objs += match.o
+bpfilter_umh-objs += match.o xt_udp.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index b5e172412fab..f420fb8b6507 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -16,7 +16,7 @@
 #include "map-common.h"
 #include "match.h"
 
-static const struct match_ops *match_ops[] = { };
+static const struct match_ops *match_ops[] = { &xt_udp };
 
 static int init_match_ops_map(struct context *ctx)
 {
diff --git a/net/bpfilter/match.h b/net/bpfilter/match.h
index c6541e6a6567..7de3d2a07dc5 100644
--- a/net/bpfilter/match.h
+++ b/net/bpfilter/match.h
@@ -29,6 +29,8 @@ struct match {
 	const struct bpfilter_ipt_match *ipt_match;
 };
 
+extern const struct match_ops xt_udp;
+
 int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match,
 	       struct match *match);
 
diff --git a/net/bpfilter/xt_udp.c b/net/bpfilter/xt_udp.c
new file mode 100644
index 000000000000..c78cd4341f81
--- /dev/null
+++ b/net/bpfilter/xt_udp.c
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ * Copyright (c) 2022 Meta Platforms, Inc. and affiliates.
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/filter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+#include <linux/udp.h>
+
+#include <arpa/inet.h>
+#include <errno.h>
+
+#include "codegen.h"
+#include "context.h"
+#include "logger.h"
+#include "match.h"
+
+static int xt_udp_check(struct context *ctx,
+			const struct bpfilter_ipt_match *ipt_match)
+{
+	const struct xt_udp *udp;
+
+	udp = (const struct xt_udp *)&ipt_match->data;
+
+	if (udp->invflags & XT_UDP_INV_MASK) {
+		BFLOG_ERR("cannot check match 'udp': invalid flags\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int xt_udp_gen_inline_ports(struct codegen *ctx, int regno, bool inv,
+				   const u16 (*ports)[2])
+{
+	if ((*ports)[0] == 0 && (*ports)[1] == 65535) {
+		if (inv)
+			EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+				   BPF_JMP_IMM(BPF_JA, 0, 0, 0));
+	} else if ((*ports)[0] == (*ports)[1]) {
+		const u16 port = htons((*ports)[0]);
+
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM((inv ? BPF_JEQ : BPF_JNE), regno, port, 0));
+	} else {
+		EMIT_LITTLE_ENDIAN(ctx, BPF_ENDIAN(BPF_TO_BE, regno, 16));
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM(inv ? BPF_JGT : BPF_JLT, regno, (*ports)[0], 0));
+		EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+			   BPF_JMP_IMM(inv ? BPF_JLT : BPF_JGT, regno, (*ports)[1], 0));
+	}
+
+	return 0;
+}
+
+static int xt_udp_gen_inline(struct codegen *ctx, const struct match *match)
+{
+	const struct xt_udp *udp;
+	int r;
+
+	udp = (const struct xt_udp *)&match->ipt_match->data;
+
+	EMIT(ctx, BPF_MOV64_REG(CODEGEN_REG_SCRATCH1, CODEGEN_REG_L4));
+	EMIT(ctx, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_SCRATCH1, sizeof(struct udphdr)));
+	r = ctx->codegen_ops->load_packet_data_end(ctx, CODEGEN_REG_DATA_END);
+	if (r) {
+		BFLOG_ERR("failed to generate code to load packet data end: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+		   BPF_JMP_REG(BPF_JGT, CODEGEN_REG_SCRATCH1, CODEGEN_REG_DATA_END, 0));
+
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH4, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, source)));
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH5, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, dest)));
+
+	r = xt_udp_gen_inline_ports(ctx, CODEGEN_REG_SCRATCH4,
+				    udp->invflags & XT_UDP_INV_SRCPT,
+				    &udp->spts);
+	if (r) {
+		BFLOG_ERR("failed to generate code to match source ports: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	r = xt_udp_gen_inline_ports(ctx, CODEGEN_REG_SCRATCH5,
+				    udp->invflags & XT_UDP_INV_DSTPT,
+				    &udp->dpts);
+	if (r) {
+		BFLOG_ERR("failed to generate code to match destination ports: %s",
+			  STRERR(r));
+		return r;
+	}
+
+	return 0;
+}
+
+const struct match_ops xt_udp = {
+	.name = "udp",
+	.size = XT_ALIGN(sizeof(struct xt_udp)),
+	.revision = 0,
+	.check = xt_udp_check,
+	.gen_inline = xt_udp_gen_inline
+};
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 9ac1b3caf246..f84cc86493df 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -2,3 +2,4 @@
 tools/**
 test_map
 test_match
+test_xt_udp
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 10642c1d6a87..97f8d596de36 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -12,6 +12,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
+TEST_GEN_PROGS += test_xt_udp
 
 KSFT_KHDR_INSTALL := 1
 
@@ -35,11 +36,12 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
 
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
-BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c
+BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
 
-BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS)
+BPFILTER_COMMON_SRCS := $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS)
 BPFILTER_COMMON_SRCS += $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/logger.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_xt_udp: test_xt_udp.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c b/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c
new file mode 100644
index 000000000000..c0898b0eca30
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c
@@ -0,0 +1,48 @@
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
+FIXTURE(test_xt_udp)
+{
+	struct context ctx;
+	struct {
+		struct xt_entry_match match;
+		struct xt_udp udp;
+
+	} ipt_match;
+	struct match match;
+};
+
+FIXTURE_SETUP(test_xt_udp)
+{
+	logger_set_file(stderr);
+	ASSERT_EQ(0, create_context(&self->ctx));
+};
+
+FIXTURE_TEARDOWN(test_xt_udp)
+{
+	free_context(&self->ctx);
+};
+
+TEST_F(test_xt_udp, init)
+{
+	init_entry_match((struct xt_entry_match *)&self->ipt_match,
+			 sizeof(self->ipt_match), 0, "udp");
+	ASSERT_EQ(init_match(&self->ctx,
+			     (const struct bpfilter_ipt_match *)&self->ipt_match,
+			     &self->match),
+		 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.38.1

