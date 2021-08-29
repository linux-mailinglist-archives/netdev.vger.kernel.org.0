Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F45F3FADD8
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhH2Shh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbhH2Sha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C82C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id lc21so26228672ejc.7
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JbdpS3iQ6KiN2gh8SfHUOgj5LSHnQ7i3+q+wV3LTBnY=;
        b=K7aowS0rUV8Bevg3ZJSywXVbB9lu9HcGAz+Jr6tXaARXv5dhcEFbghrz9/2To0sEzk
         Zr6Mr6h9D4udVASXriQGZNkSuL/EzRHwyrdSMbWBL7oWE47Rxm3/PvL2BBaeoKvFUOti
         dNABxq9NMmHb1dU6IMBE5qw2dH5uO3Q3kdRPB3YcuCoH6LDN33HraXgaxnFRHbHWcPWm
         nX7V7kUswJTICvxOUW+cmoAlOmj0lZQsA8Wude3bEoQgU8hVO06e50zey7YuRJcKXPY+
         Knu2avAfYH5WSTnpIoYczZRKvaMztlwA7VbAtv7kOTAsRXeWpsS7mDg7Nf+QNa7b00k7
         NDoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JbdpS3iQ6KiN2gh8SfHUOgj5LSHnQ7i3+q+wV3LTBnY=;
        b=C+D7GGZhEH1XqbNrJ2pj7cIbd5N9uF/HAdnWOWpWB0HTSEBygbr0LOr2BGFpDpHtwf
         anqu3rjuCxIEj5Ap4Zze69Q4Cbax0oF4ZBLoDj1Q8Y2ysipoQEjbioFzbME0/Evl4z26
         3i5DPyxE4QCvwrE6AdlRv1HqNUh22k2F+UGhlUFjOAXgrMrGes4Nqw9BsswZZRkXHYsa
         xBFHYUnBet4t5w6dDeSQQVCEhyxMpIGYXAkmFm+i9md5B0ilvJO0GkO1Q8I7pJR6mMTP
         QtuXKjihy0pZivkm4zFUTnMsXfE0ZdBrK+Xp16SdLnUbKCxid3QmVH09rEk1U/THNpj1
         oUeQ==
X-Gm-Message-State: AOAM530OuGIE4rIw+l2CCN3YdVQ2Bl7W7A5SXG9IIsLNjAz82U8sQXjA
        AnJ1StRR0AwdPrT9H9L7qjt2kQ==
X-Google-Smtp-Source: ABdhPJwXOQSx8z9ZqxbsIpz864cfOQ0Zpp7MqklXSEECFEtaiVX9qtdFLxuc/PYsQtbIGx4dsutzGQ==
X-Received: by 2002:a17:907:2137:: with SMTP id qo23mr19042687ejb.508.1630262196722;
        Sun, 29 Aug 2021 11:36:36 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id y23sm5594539ejp.115.2021.08.29.11.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:36 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 06/13] bpfilter: Add struct match
Date:   Sun, 29 Aug 2021 22:36:01 +0400
Message-Id: <20210829183608.2297877-7-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct match_ops defines polymorphic interface for matches. A match
consists of pointers to struct match_ops and struct xt_entry_match which
contains a payload for the match's type.

The set of operations of a match's interface consists of:
 * check: is used to check a rule's match
 * gen_inline: is used to emit an inline version of a match

All match_ops are kept in a map by their name.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  3 +-
 net/bpfilter/context.c                        | 44 +++++++++
 net/bpfilter/context.h                        |  5 +
 net/bpfilter/match.c                          | 49 ++++++++++
 net/bpfilter/match.h                          | 36 +++++++
 net/bpfilter/xt_udp.c                         | 96 +++++++++++++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  2 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  8 ++
 .../selftests/bpf/bpfilter/bpfilter_util.h    | 20 ++++
 .../selftests/bpf/bpfilter/test_match.c       | 61 ++++++++++++
 .../selftests/bpf/bpfilter/test_xt_udp.c      | 41 ++++++++
 11 files changed, 364 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 net/bpfilter/xt_udp.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_xt_udp.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index f3838368ba08..ffad25b41aad 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -11,7 +11,8 @@ $(LIBBPF_A):
 	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o codegen.o
+bpfilter_umh-objs := main.o map-common.o codegen.o match.o context.o
+bpfilter_umh-objs += xt_udp.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I $(srctree)/tools/lib
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
new file mode 100644
index 000000000000..b377f5f73f69
--- /dev/null
+++ b/net/bpfilter/context.c
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "context.h"
+
+#include <linux/err.h>
+#include <linux/list.h>
+
+#include "map-common.h"
+#include "match.h"
+
+static int init_match_ops_map(struct context *ctx)
+{
+	const struct match_ops *match_ops[] = { &xt_udp };
+	int i, err;
+
+	err = create_map(&ctx->match_ops_map, ARRAY_SIZE(match_ops));
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(match_ops); ++i) {
+		const struct match_ops *m = match_ops[i];
+
+		err = map_upsert(&ctx->match_ops_map, m->name, (void *)m);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int create_context(struct context *ctx)
+{
+	return init_match_ops_map(ctx);
+}
+
+void free_context(struct context *ctx)
+{
+	free_map(&ctx->match_ops_map);
+}
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index 6503eda27809..da248ae254e5 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -8,11 +8,13 @@
 
 #include <sys/syslog.h>
 
+#include <search.h>
 #include <stdio.h>
 #include <stdlib.h>
 
 struct context {
 	FILE *log_file;
+	struct hsearch_data match_ops_map;
 };
 
 #define BFLOG_IMPL(ctx, level, fmt, ...)                                                           \
@@ -34,4 +36,7 @@ struct context {
 #define BFLOG_DEBUG(ctx, fmt, ...)
 #endif
 
+int create_context(struct context *ctx);
+void free_context(struct context *ctx);
+
 #endif // NET_BPFILTER_CONTEXT_H
diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
new file mode 100644
index 000000000000..3b49196efabf
--- /dev/null
+++ b/net/bpfilter/match.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
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
+#include "map-common.h"
+
+int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match, struct match *match)
+{
+	const size_t maxlen = sizeof(ipt_match->u.user.name);
+	const struct match_ops *found;
+	int err;
+
+	if (strnlen(ipt_match->u.user.name, maxlen) == maxlen) {
+		BFLOG_DEBUG(ctx, "cannot init match: too long match name\n");
+		return -EINVAL;
+	}
+
+	found = map_find(&ctx->match_ops_map, ipt_match->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find match by name: '%s'\n", ipt_match->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size + sizeof(*ipt_match) != ipt_match->u.match_size ||
+	    found->revision != ipt_match->u.user.revision) {
+		BFLOG_DEBUG(ctx, "invalid match: '%s'\n", ipt_match->u.user.name);
+		return -EINVAL;
+	}
+
+	err = found->check(ctx, ipt_match);
+	if (err)
+		return err;
+
+	match->match_ops = found;
+	match->ipt_match = ipt_match;
+
+	return 0;
+}
diff --git a/net/bpfilter/match.h b/net/bpfilter/match.h
new file mode 100644
index 000000000000..107b69eb3664
--- /dev/null
+++ b/net/bpfilter/match.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
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
+extern const struct match_ops xt_udp;
+
+int init_match(struct context *ctx, const struct bpfilter_ipt_match *ipt_match,
+	       struct match *match);
+
+#endif // NET_BPFILTER_MATCH_H
diff --git a/net/bpfilter/xt_udp.c b/net/bpfilter/xt_udp.c
new file mode 100644
index 000000000000..53e6305bc208
--- /dev/null
+++ b/net/bpfilter/xt_udp.c
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <stddef.h>
+
+#include "codegen.h"
+#include "context.h"
+#include "match.h"
+
+static int xt_udp_check(struct context *ctx, const struct bpfilter_ipt_match *ipt_match)
+{
+	const struct xt_udp *udp;
+
+	udp = (const struct xt_udp *)&ipt_match->data;
+
+	if (udp->invflags & XT_UDP_INV_MASK) {
+		BFLOG_DEBUG(ctx, "cannot check match 'udp': invalid flags\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int xt_udp_gen_inline_ports(struct codegen *ctx, int regno, bool inv, const u16 (*ports)[2])
+{
+	if ((*ports)[0] == 0 && (*ports)[1] == 65535) {
+		if (inv)
+			EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE, BPF_JMP_IMM(BPF_JA, 0, 0, 0));
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
+	int err;
+
+	udp = (const struct xt_udp *)&match->ipt_match->data;
+
+	EMIT(ctx, BPF_MOV64_REG(CODEGEN_REG_SCRATCH1, CODEGEN_REG_L4));
+	EMIT(ctx, BPF_ALU64_IMM(BPF_ADD, CODEGEN_REG_SCRATCH1, sizeof(struct udphdr)));
+	err = ctx->codegen_ops->load_packet_data_end(ctx, CODEGEN_REG_DATA_END);
+	if (err)
+		return err;
+	EMIT_FIXUP(ctx, CODEGEN_FIXUP_NEXT_RULE,
+		   BPF_JMP_REG(BPF_JGT, CODEGEN_REG_SCRATCH1, CODEGEN_REG_DATA_END, 0));
+
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH4, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, source)));
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH5, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, dest)));
+
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH4, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, source)));
+	EMIT(ctx, BPF_LDX_MEM(BPF_H, CODEGEN_REG_SCRATCH5, CODEGEN_REG_L4,
+			      offsetof(struct udphdr, dest)));
+
+	err = xt_udp_gen_inline_ports(ctx, CODEGEN_REG_SCRATCH4, udp->invflags & XT_UDP_INV_SRCPT,
+				      &udp->spts);
+	if (err)
+		return err;
+
+	err = xt_udp_gen_inline_ports(ctx, CODEGEN_REG_SCRATCH5, udp->invflags & XT_UDP_INV_DSTPT,
+				      &udp->dpts);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+const struct match_ops xt_udp = { .name = "udp",
+				  .size = XT_ALIGN(sizeof(struct xt_udp)),
+				  .revision = 0,
+				  .check = xt_udp_check,
+				  .gen_inline = xt_udp_gen_inline };
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 39ec0c09dff4..f84cc86493df 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 tools/**
 test_map
+test_match
+test_xt_udp
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 48dc696e0f09..281107f5ad88 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -11,6 +11,8 @@ BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
 CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR) -I$(LIBDIR)
 
 TEST_GEN_PROGS += test_map
+TEST_GEN_PROGS += test_match
+TEST_GEN_PROGS += test_xt_udp
 
 KSFT_KHDR_INSTALL := 1
 
@@ -35,5 +37,11 @@ $(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       		\
 
 BPFILTER_MAP_SRCS := $(BPFILTERSRCDIR)/map-common.c
 BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
+BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
+
+BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/context.c
+BPFILTER_COMMON_SRCS += $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS) $(BPFILTER_MATCH_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
+$(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_xt_udp: test_xt_udp.c $(BPFILTER_COMMON_SRCS)
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
new file mode 100644
index 000000000000..e4188c56f690
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef BPFILTER_UTIL_H
+#define BPFILTER_UTIL_H
+
+#include <linux/netfilter/x_tables.h>
+
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+
+static inline void init_entry_match(struct xt_entry_match *match, uint16_t size, uint8_t revision,
+				    const char *name)
+{
+	memset(match, 0, sizeof(*match));
+	snprintf(match->u.user.name, sizeof(match->u.user.name), "%s", name);
+	match->u.user.match_size = size;
+	match->u.user.revision = revision;
+}
+#endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_match.c b/tools/testing/selftests/bpf/bpfilter/test_match.c
new file mode 100644
index 000000000000..583490397aef
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_match.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include "context.h"
+#include "match.h"
+
+#include <linux/bpfilter.h>
+#include <linux/err.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+
+#include <stdio.h>
+
+#include "../../kselftest_harness.h"
+
+#include "bpfilter_util.h"
+
+struct udp_match {
+	struct xt_entry_match ipt_match;
+	struct xt_udp udp;
+};
+
+FIXTURE(test_udp_match)
+{
+	struct context ctx;
+	struct udp_match udp_match;
+	struct match match;
+};
+
+FIXTURE_SETUP(test_udp_match)
+{
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
+
+	init_entry_match(&self->udp_match.ipt_match, sizeof(self->udp_match), 0, "udp");
+};
+
+FIXTURE_TEARDOWN(test_udp_match)
+{
+	free_context(&self->ctx);
+}
+
+TEST_F(test_udp_match, init)
+{
+	self->udp_match.udp.spts[0] = 1;
+	self->udp_match.udp.spts[1] = 2;
+	self->udp_match.udp.dpts[0] = 3;
+	self->udp_match.udp.dpts[1] = 4;
+	self->udp_match.udp.invflags = 0;
+
+	ASSERT_EQ(init_match(&self->ctx,
+			     (const struct bpfilter_ipt_match *)&self->udp_match
+				     .ipt_match,
+			     &self->match),
+		  0);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c b/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c
new file mode 100644
index 000000000000..c6c0f7ac16b7
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_xt_udp.c
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <linux/netfilter/xt_tcpudp.h>
+
+#include "../../kselftest_harness.h"
+
+#include "context.h"
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
+	ASSERT_EQ(0, create_context(&self->ctx));
+	self->ctx.log_file = stderr;
+
+	init_entry_match((struct xt_entry_match *)&self->ipt_match, sizeof(self->ipt_match),
+			 0, "udp");
+	ASSERT_EQ(0, init_match(&self->ctx, (const struct bpfilter_ipt_match *)&self->ipt_match,
+				&self->match));
+};
+
+FIXTURE_TEARDOWN(test_xt_udp)
+{
+	free_context(&self->ctx);
+};
+
+TEST_HARNESS_MAIN
-- 
2.25.1

