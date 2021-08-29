Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE103FADDA
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbhH2Shj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234080AbhH2Shc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:32 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAB9C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:40 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u19so1508282edb.3
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yo3cg03SQGz/lSQOon4ZrOVwiHCRGqrrK91lU4GIfco=;
        b=MxnG+ArBlzJeOLVti831DGlN8cm7N/fN6CAbKY919/bGgLPXe4PbQ2s0aNFc3Qr4Tu
         xzzbOZFMt4xRxS/04s2lMTq24o/m2FRT7QZfzUrPhT2E9veN45Mvlv3sa/ORlyyzpJHA
         4BKI/ZGQMVthzXs3ywZ9EV/KZJxPRqnbs2QQX6W0AwPKWc79PRXVjie+u86gq4PLEAoP
         G3fFMvTiGOhcENDHylNos7p8etDyK/Dy3RomOk5c6HFck3YkklihuyWmhvcMlqSnzyXG
         L6wr0+sVjAP4Lo3aqLFq4mY2UHB/6+4D7Blfm9SH7yRCjqAfGp1g/QVkAbuZjZdVyFlj
         fapQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yo3cg03SQGz/lSQOon4ZrOVwiHCRGqrrK91lU4GIfco=;
        b=YgtF1W7/JVJR9CXxqmV03h+gVJrQ0rU/0tQbKxMPwKgmEkcC6LvMQuk+KZaXmLJhhl
         G5TQPVoxfqu0hVsM/2xQbd994yOcSo80/jmtJy8dJjDI9JhrcKN+QDh22k5GK8m3LmKm
         6g5ZKLCdPP657N11947lIldHyVwePI1DPJHvQPCPxTPe/OLdU7RJ2gB7bks4mV+HxWQA
         fl7Gmandy//Pz9qAF10CIKcqwir/xQGTSMVfEzqlGer+a3IHClHbIZQp1m5rkOglh8Ur
         3YDfqSXxbDPpwSt8W1wCN0fYtLgRhhwu7sD+w1pykaqowqr6CVjAFW5CgRwnUpp5o2xq
         70wQ==
X-Gm-Message-State: AOAM532IbXgJ3+V+CyDq/aNuXLg9NAe6K6YBS+M++f33lIT3b9WbhpSA
        yFNJd/oUpKVvFdw6fL0Yg1dGqA==
X-Google-Smtp-Source: ABdhPJxZRMSCMXHFIWqIHEqU6TSWBa5+1OH2gdK2mjVNRdp9ERj6ZRJ1OFawjWbQWuHi/IOCGt0kug==
X-Received: by 2002:aa7:ccc1:: with SMTP id y1mr19844019edt.321.1630262198933;
        Sun, 29 Aug 2021 11:36:38 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id m6sm1413220edi.10.2021.08.29.11.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:38 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 07/13] bpfilter: Add struct target
Date:   Sun, 29 Aug 2021 22:36:02 +0400
Message-Id: <20210829183608.2297877-8-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct target_ops defines polymorphic interface for targets. A target
consists of pointers to struct target_ops and struct xt_entry_target
which contains a payload for the target's type.

The set of operations of a target's interface consists of:
 * check: is used to check a target
 * gen_inline: is used to emit an inline version of a target

All target_ops are kept in a map by their name.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |  39 +++-
 net/bpfilter/context.h                        |   1 +
 net/bpfilter/target.c                         | 184 ++++++++++++++++++
 net/bpfilter/target.h                         |  52 +++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   4 +
 .../selftests/bpf/bpfilter/bpfilter_util.h    |  22 +++
 .../selftests/bpf/bpfilter/test_target.c      |  85 ++++++++
 9 files changed, 388 insertions(+), 2 deletions(-)
 create mode 100644 net/bpfilter/target.c
 create mode 100644 net/bpfilter/target.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index ffad25b41aad..a7c643a1b52a 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -11,7 +11,7 @@ $(LIBBPF_A):
 	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o codegen.o match.o context.o
+bpfilter_umh-objs := main.o map-common.o codegen.o context.o match.o target.o
 bpfilter_umh-objs += xt_udp.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I $(srctree)/tools/lib
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index b377f5f73f69..d3afc4ec0b05 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -12,6 +12,7 @@
 
 #include "map-common.h"
 #include "match.h"
+#include "target.h"
 
 static int init_match_ops_map(struct context *ctx)
 {
@@ -33,12 +34,48 @@ static int init_match_ops_map(struct context *ctx)
 	return 0;
 }
 
+static int init_target_ops_map(struct context *ctx)
+{
+	const struct target_ops *target_ops[] = { &standard_target_ops, &error_target_ops };
+	int i, err;
+
+	err = create_map(&ctx->target_ops_map, ARRAY_SIZE(target_ops));
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(target_ops); ++i) {
+		const struct target_ops *t = target_ops[i];
+
+		err = map_upsert(&ctx->target_ops_map, t->name, (void *)t);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 int create_context(struct context *ctx)
 {
-	return init_match_ops_map(ctx);
+	int err;
+
+	err = init_match_ops_map(ctx);
+	if (err)
+		return err;
+
+	err = init_target_ops_map(ctx);
+	if (err)
+		goto err_free_match_ops_map;
+
+	return 0;
+
+err_free_match_ops_map:
+	free_map(&ctx->match_ops_map);
+
+	return err;
 }
 
 void free_context(struct context *ctx)
 {
 	free_map(&ctx->match_ops_map);
+	free_map(&ctx->target_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index da248ae254e5..fa73fc3ac64b 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -15,6 +15,7 @@
 struct context {
 	FILE *log_file;
 	struct hsearch_data match_ops_map;
+	struct hsearch_data target_ops_map;
 };
 
 #define BFLOG_IMPL(ctx, level, fmt, ...)                                                           \
diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
new file mode 100644
index 000000000000..72fba24f50e4
--- /dev/null
+++ b/net/bpfilter/target.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "target.h"
+
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/netfilter/x_tables.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "codegen.h"
+#include "context.h"
+#include "map-common.h"
+
+static const struct target_ops *target_ops_map_find(struct hsearch_data *map, const char *name)
+{
+	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
+
+	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
+		return map_find(map, name);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static int standard_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
+
+	// Positive values of verdict denote a jump offset into a blob.
+	if (standard_target->verdict > 0)
+		return 0;
+
+	// Special values like ACCEPT, DROP, RETURN are encoded as negative values.
+	if (standard_target->verdict < 0) {
+		if (standard_target->verdict == BPFILTER_RETURN)
+			return 0;
+
+		switch (convert_verdict(standard_target->verdict)) {
+		case BPFILTER_NF_ACCEPT:
+		case BPFILTER_NF_DROP:
+		case BPFILTER_NF_QUEUE:
+			return 0;
+		}
+	}
+
+	BFLOG_DEBUG(ctx, "invalid verdict: %d\n", standard_target->verdict);
+
+	return -EINVAL;
+}
+
+static int standard_target_gen_inline(struct codegen *ctx, const struct target *target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+	int err;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)target->ipt_target;
+
+	if (standard_target->verdict >= 0) {
+		struct codegen_subprog_desc *subprog;
+		struct codegen_fixup_desc *fixup;
+
+		subprog = malloc(sizeof(*subprog));
+		if (!subprog)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(&subprog->list);
+		subprog->type = CODEGEN_SUBPROG_USER_CHAIN;
+		subprog->insn = 0;
+		subprog->offset = standard_target->verdict;
+
+		fixup = malloc(sizeof(*fixup));
+		if (!fixup) {
+			free(subprog);
+			return -ENOMEM;
+		}
+
+		INIT_LIST_HEAD(&fixup->list);
+		fixup->type = CODEGEN_FIXUP_JUMP_TO_CHAIN;
+		fixup->insn = ctx->len_cur;
+		fixup->offset = standard_target->verdict;
+
+		list_add_tail(&fixup->list, &ctx->fixup);
+
+		err = codegen_push_awaiting_subprog(ctx, subprog);
+		if (err)
+			return err;
+
+		EMIT(ctx, BPF_JMP_IMM(BPF_JA, 0, 0, 0));
+
+		return 0;
+	}
+
+	if (standard_target->verdict == BPFILTER_RETURN) {
+		EMIT(ctx, BPF_EXIT_INSN());
+
+		return 0;
+	}
+
+	err = ctx->codegen_ops->emit_ret_code(ctx, convert_verdict(standard_target->verdict));
+	if (err)
+		return err;
+
+	EMIT(ctx, BPF_EXIT_INSN());
+
+	return 0;
+}
+
+const struct target_ops standard_target_ops = {
+	.name = "",
+	.revision = 0,
+	.size = sizeof(struct xt_standard_target),
+	.check = standard_target_check,
+	.gen_inline = standard_target_gen_inline,
+};
+
+static int error_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_error_target *error_target;
+	size_t maxlen;
+
+	error_target = (const struct bpfilter_ipt_error_target *)&ipt_target;
+	maxlen = sizeof(error_target->error_name);
+	if (strnlen(error_target->error_name, maxlen) == maxlen) {
+		BFLOG_DEBUG(ctx, "cannot check error target: too long errorname\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int error_target_gen_inline(struct codegen *ctx, const struct target *target)
+{
+	return -EINVAL;
+}
+
+const struct target_ops error_target_ops = {
+	.name = "ERROR",
+	.revision = 0,
+	.size = sizeof(struct xt_error_target),
+	.check = error_target_check,
+	.gen_inline = error_target_gen_inline,
+};
+
+int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
+		struct target *target)
+{
+	const size_t maxlen = sizeof(ipt_target->u.user.name);
+	const struct target_ops *found;
+	int err;
+
+	if (strnlen(ipt_target->u.user.name, maxlen) == maxlen) {
+		BFLOG_DEBUG(ctx, "cannot init target: too long target name\n");
+		return -EINVAL;
+	}
+
+	found = target_ops_map_find(&ctx->target_ops_map, ipt_target->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find target by name: '%s'\n", ipt_target->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size != ipt_target->u.target_size ||
+	    found->revision != ipt_target->u.user.revision) {
+		BFLOG_DEBUG(ctx, "invalid target: '%s'\n", ipt_target->u.user.name);
+		return -EINVAL;
+	}
+
+	err = found->check(ctx, ipt_target);
+	if (err)
+		return err;
+
+	target->target_ops = found;
+	target->ipt_target = ipt_target;
+
+	return 0;
+}
diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
new file mode 100644
index 000000000000..cb4821c1d3f5
--- /dev/null
+++ b/net/bpfilter/target.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_TARGET_H
+#define NET_BPFILTER_TARGET_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <stdint.h>
+
+struct codegen;
+struct context;
+struct target;
+struct target_ops_map;
+
+struct target_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint8_t revision;
+	uint16_t size;
+	int (*check)(struct context *ctx, const struct bpfilter_ipt_target *ipt_target);
+	int (*gen_inline)(struct codegen *ctx, const struct target *target);
+};
+
+struct target {
+	const struct target_ops *target_ops;
+	const struct bpfilter_ipt_target *ipt_target;
+};
+
+extern const struct target_ops standard_target_ops;
+extern const struct target_ops error_target_ops;
+
+/* Restore verdict's special value(ACCEPT, DROP, etc.) from its negative representation. */
+static inline int convert_verdict(int verdict)
+{
+	return -verdict - 1;
+}
+
+static inline int standard_target_verdict(const struct bpfilter_ipt_target *ipt_target)
+{
+	const struct bpfilter_ipt_standard_target *standard_target;
+
+	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
+
+	return standard_target->verdict;
+}
+
+int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
+		struct target *target);
+
+#endif // NET_BPFILTER_TARGET_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index f84cc86493df..89912a44109f 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -3,3 +3,4 @@ tools/**
 test_map
 test_match
 test_xt_udp
+test_target
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 281107f5ad88..670f28413e42 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -13,6 +13,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR) -I$
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
 TEST_GEN_PROGS += test_xt_udp
+TEST_GEN_PROGS += test_target
 
 KSFT_KHDR_INSTALL := 1
 
@@ -38,10 +39,13 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       		\
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
+BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
 
 BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/context.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS) $(BPFILTER_MATCH_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTER_TARGET_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
 $(OUTPUT)/test_xt_udp: test_xt_udp.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
index e4188c56f690..945633c5415e 100644
--- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -3,6 +3,7 @@
 #ifndef BPFILTER_UTIL_H
 #define BPFILTER_UTIL_H
 
+#include <linux/bpfilter.h>
 #include <linux/netfilter/x_tables.h>
 
 #include <stdint.h>
@@ -17,4 +18,25 @@ static inline void init_entry_match(struct xt_entry_match *match, uint16_t size,
 	match->u.user.match_size = size;
 	match->u.user.revision = revision;
 }
+
+static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
+					int verdict)
+{
+	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_STANDARD_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	ipt_target->verdict = verdict;
+}
+
+static inline void init_error_target(struct xt_error_target *ipt_target, int revision,
+				     const char *error_name)
+{
+	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
+		 BPFILTER_ERROR_TARGET);
+	ipt_target->target.u.user.revision = revision;
+	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
+	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
+}
+
 #endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_target.c b/tools/testing/selftests/bpf/bpfilter/test_target.c
new file mode 100644
index 000000000000..6765497b53c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_target.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include "context.h"
+#include "target.h"
+
+#include <linux/bpfilter.h>
+#include <linux/err.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#include "../../kselftest_harness.h"
+
+#include "bpfilter_util.h"
+
+FIXTURE(test_standard_target)
+{
+	struct context ctx;
+	struct xt_standard_target ipt_target;
+	struct target target;
+};
+
+FIXTURE_VARIANT(test_standard_target)
+{
+	int verdict;
+};
+
+FIXTURE_VARIANT_ADD(test_standard_target, accept) {
+	.verdict = -BPFILTER_NF_ACCEPT - 1,
+};
+
+FIXTURE_VARIANT_ADD(test_standard_target, drop) {
+	.verdict = -BPFILTER_NF_DROP - 1,
+};
+
+FIXTURE_SETUP(test_standard_target)
+{
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
+
+	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
+	init_standard_target(&self->ipt_target, 0, variant->verdict);
+}
+
+FIXTURE_TEARDOWN(test_standard_target)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_standard_target, init)
+{
+	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
+				 &self->target));
+}
+
+FIXTURE(test_error_target)
+{
+	struct context ctx;
+	struct xt_error_target ipt_target;
+	struct target target;
+};
+
+FIXTURE_SETUP(test_error_target)
+{
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
+
+	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
+	init_error_target(&self->ipt_target, 0, "x");
+}
+
+FIXTURE_TEARDOWN(test_error_target)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_error_target, init)
+{
+	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
+				 &self->target));
+}
+
+TEST_HARNESS_MAIN
-- 
2.25.1

