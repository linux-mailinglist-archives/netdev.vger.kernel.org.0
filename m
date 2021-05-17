Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA68D386D4C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344279AbhEQWzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbhEQWzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:55:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5F8C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:42 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o127so4370652wmo.4
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vnjpYE6a+/qN6qBE52lhBST4EhfaOWI/BYnTi+GvsjA=;
        b=r2ryPwPxyQ5WUzorJbvzGt1NNv/BQdIP2e02Uk1uc6KsjV6Dp/hPbDuE3S7LYoHvSK
         YYP7IAvsmnSNvwrA5ki6QxjL52ckydoDqVyrAND+whvmPc3SxxbeShXxAZ4o5xgeurBS
         X5kgovSrnbwT0eGrZMTn7LeOGqMvweFtgPy3xAdhCdrZ4qYlER7EL9QDQF9PAP0wNTsy
         XN8NRQasnQP1zi2F5tscace5v61KFuyejbVseO6PDZRi4UxRb/t4oVEgIVqKc/eSdFmd
         9a+X5gOyHlWQFa/L/15brMqbcJzAz2WuPKGsfoFyQa3MgWFJGmO16dJ+Fj9SZajXhrdK
         t6xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vnjpYE6a+/qN6qBE52lhBST4EhfaOWI/BYnTi+GvsjA=;
        b=fuNWun6lf4aphjAWGI/dkOHkbSjhGkG0AzWgXWuTzyOyn/DqhNAU7xbJfwrsHwi7ap
         e83O/Y7khObJJ8+ElrUk9xBVpBOmtRBI6l4rp7tKQD6tGVhLbtDPb/cXVMd4nlOK+5ar
         T98QkWx/XTzkezk6VmocipTHjm7kZmihvPy0WIon99NK68BUok1lvBoW5Fnx/vYdGIRf
         UTYWU29EKvCIysSo/gljdIknjE+M1YIRm8g2fvFriimsGt246EUi4Zl3Q4MuxZIQgkIK
         N/k9tDbQPzHPbUmFzC99ru33f+AA5D7QOzII21SeKgeLAA22fK/D2dYgg28Qq6AvgbqY
         bBPg==
X-Gm-Message-State: AOAM533GBr2g1B2EM+juzzqpBXKa9uviiWolxJUDUvW/Ws/+99ozkbgk
        kxAsEql7jfjAm8esAWB3urnMxg==
X-Google-Smtp-Source: ABdhPJwk82o7DyR5VfeFIqiOXFgp/m3Bc6j2OyFFn1PNYpDduWe7ExjiG8nEGmUB732xYnMYrjJIpg==
X-Received: by 2002:a1c:f70b:: with SMTP id v11mr1918160wmh.186.1621292021546;
        Mon, 17 May 2021 15:53:41 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id n189sm9707881wme.9.2021.05.17.15.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:41 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 06/11] bpfilter: Add struct match
Date:   Tue, 18 May 2021 02:53:03 +0400
Message-Id: <20210517225308.720677-7-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct match_ops defines polymorphic interface for matches. A match
consists of pointers to struct match_ops and struct xt_entry_match which
contains a payload for the match's type.

All match_ops are kept in map match_ops_map by their name.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  2 +-
 net/bpfilter/context.c                        | 41 +++++++++++
 net/bpfilter/context.h                        |  6 ++
 net/bpfilter/match-ops-map.h                  | 48 ++++++++++++
 net/bpfilter/match.c                          | 73 +++++++++++++++++++
 net/bpfilter/match.h                          | 34 +++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  3 +
 .../selftests/bpf/bpfilter/test_match.c       | 63 ++++++++++++++++
 9 files changed, 270 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/match-ops-map.h
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 908fbad680ec..d1a36dd2c666 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o io.o map-common.o
+bpfilter_umh-objs := main.o bflog.o io.o map-common.o match.o context.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
new file mode 100644
index 000000000000..96735c7883bf
--- /dev/null
+++ b/net/bpfilter/context.c
@@ -0,0 +1,41 @@
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
+#include "match.h"
+
+static int init_match_ops_map(struct context *ctx)
+{
+	const struct match_ops *match_ops[] = { &udp_match_ops };
+	int i, err;
+
+	err = create_match_ops_map(&ctx->match_ops_map, ARRAY_SIZE(match_ops));
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(match_ops); ++i) {
+		err = match_ops_map_insert(&ctx->match_ops_map, match_ops[i]);
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
+	free_match_ops_map(&ctx->match_ops_map);
+}
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index e85c97c3d010..a3e737b603f0 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -8,9 +8,15 @@
 
 #include <stdio.h>
 
+#include "match-ops-map.h"
+
 struct context {
 	FILE *log_file;
 	int log_level;
+	struct match_ops_map match_ops_map;
 };
 
+int create_context(struct context *ctx);
+void free_context(struct context *ctx);
+
 #endif // NET_BPFILTER_CONTEXT_H
diff --git a/net/bpfilter/match-ops-map.h b/net/bpfilter/match-ops-map.h
new file mode 100644
index 000000000000..0ff57f2d8da8
--- /dev/null
+++ b/net/bpfilter/match-ops-map.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_MATCH_OPS_MAP_H
+#define NET_BPFILTER_MATCH_OPS_MAP_H
+
+#include "map-common.h"
+
+#include <linux/err.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "match.h"
+
+struct match_ops_map {
+	struct hsearch_data index;
+};
+
+static inline int create_match_ops_map(struct match_ops_map *map, size_t nelem)
+{
+	return create_map(&map->index, nelem);
+}
+
+static inline const struct match_ops *match_ops_map_find(struct match_ops_map *map,
+							 const char *name)
+{
+	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
+
+	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
+		return map_find(&map->index, name);
+
+	return ERR_PTR(-EINVAL);
+}
+
+static inline int match_ops_map_insert(struct match_ops_map *map, const struct match_ops *match_ops)
+{
+	return map_insert(&map->index, match_ops->name, (void *)match_ops);
+}
+
+static inline void free_match_ops_map(struct match_ops_map *map)
+{
+	free_map(&map->index);
+}
+
+#endif // NET_BPFILTER_MATCT_OPS_MAP_H
diff --git a/net/bpfilter/match.c b/net/bpfilter/match.c
new file mode 100644
index 000000000000..aeca1b93cd2d
--- /dev/null
+++ b/net/bpfilter/match.c
@@ -0,0 +1,73 @@
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
+#include <linux/netfilter/xt_tcpudp.h>
+
+#include <errno.h>
+#include <string.h>
+
+#include "bflog.h"
+#include "context.h"
+#include "match-ops-map.h"
+
+#define BPFILTER_ALIGN(__X) __ALIGN_KERNEL(__X, __alignof__(__u64))
+#define MATCH_SIZE(type) (sizeof(struct bpfilter_ipt_match) + BPFILTER_ALIGN(sizeof(type)))
+
+static int udp_match_check(struct context *ctx, const struct bpfilter_ipt_match *ipt_match)
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
+const struct match_ops udp_match_ops = { .name = "udp",
+					 .size = MATCH_SIZE(struct xt_udp),
+					 .revision = 0,
+					 .check = udp_match_check };
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
+	found = match_ops_map_find(&ctx->match_ops_map, ipt_match->u.user.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find match by name: '%s'\n", ipt_match->u.user.name);
+		return PTR_ERR(found);
+	}
+
+	if (found->size != ipt_match->u.match_size ||
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
index 000000000000..79b7c87016d4
--- /dev/null
+++ b/net/bpfilter/match.h
@@ -0,0 +1,34 @@
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
+struct context;
+struct match_ops_map;
+
+struct match_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint16_t size;
+	uint8_t revision;
+	int (*check)(struct context *ctx, const struct bpfilter_ipt_match *ipt_match);
+};
+
+extern const struct match_ops udp_match_ops;
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
index be10b50ca289..e5073231f811 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_io
 test_map
+test_match
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 77afbbdf27c5..362c9a28b88d 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -10,6 +10,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 
 TEST_GEN_PROGS += test_io
 TEST_GEN_PROGS += test_map
+TEST_GEN_PROGS += test_match
 
 KSFT_KHDR_INSTALL := 1
 
@@ -17,3 +18,5 @@ include ../../lib.mk
 
 $(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
+$(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/map-common.c \
+	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c
diff --git a/tools/testing/selftests/bpf/bpfilter/test_match.c b/tools/testing/selftests/bpf/bpfilter/test_match.c
new file mode 100644
index 000000000000..3a56d79ed24c
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_match.c
@@ -0,0 +1,63 @@
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
+	memset(&self->udp_match, 0, sizeof(self->udp_match));
+	snprintf(self->udp_match.ipt_match.u.user.name,
+		 sizeof(self->udp_match.ipt_match.u.user.name), "udp");
+	self->udp_match.ipt_match.u.user.match_size = sizeof(struct udp_match);
+	self->udp_match.ipt_match.u.user.revision = 0;
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
-- 
2.25.1

