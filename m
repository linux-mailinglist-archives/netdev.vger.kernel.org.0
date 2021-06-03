Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DB8399EAB
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFCKRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:17:43 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:43566 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFCKRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:17:42 -0400
Received: by mail-wm1-f42.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso3365890wmj.2
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkMzs1gZP+Wiqtomowse5B6kMYYJOzZY6aRSXqIG0JI=;
        b=BP/RfwVZGL+MhCm8VqSNAn55REi0aIYV2Kcns2mEiX4rlB304AV6bA0avduvHA2ugd
         tQYNCkJhRzMcfuRyIxfdJLfXD8WDfBtY3GF0ZIWy0tnocK0MDMpf3AGgsJfh0pvWRdQB
         rzwloZoBNngrnmsYp1QLusYiPu/39qN7Y+/pKT1jDkIMqSRoQhrJz/1IrkGy5inB9SI8
         Jpwpk1uU1XIeilRPBAqFv27nApn1WsktdjvuJhlVeDbMzoiyp2vZO4if8jPI4WwtCG1P
         mul3/zbII50GwBWZKV3azd7YsQ/IlslkMmU7kR2vVvO+R09Gjq3HJuGHejd+ez3tA8mr
         EjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkMzs1gZP+Wiqtomowse5B6kMYYJOzZY6aRSXqIG0JI=;
        b=ptw8AOHisFtIXMhGaUjgPvVUiL59wMB72bRFfqfCaov19O+7cmaY426nhv+Py73Uue
         vks5lY0JNl9pBtWAgoglc1AbawvpWNovfW3D2lr4/GNlejTBQ5jdvZJsmMV6rv1mLWZC
         yF4Prtjvf3O5AGPBfAIBf+5AzfXncAAvstHu2HGzue3bv7EHo+zwX6aVo6nkYggVwG93
         zlCPr3Bg69l+zsd6O0HiICMGExcFs+FQCoShpeq48n5OnboPA9kofgZmHtXesaWrIYG4
         ZhZwomKe7GlzAYKmiFY0urne+g+9p2w3nuT8WuCOpVaSdpYaG0rVwVzIK0Dz/E1HOGsA
         kShA==
X-Gm-Message-State: AOAM530nnssoqa4ofIdwkKXqZ6QpterNpHdBPHf4onY0yTYjmdOswN+R
        zykpoA4av0oq2zCOQ3Tymdc2ZA==
X-Google-Smtp-Source: ABdhPJxTdC/yusBsxx+f4anipFDmYksJN/Jq/7hqvQ9LgHWeydhYim9rEbsUbTSji2FChKlxWnC/9g==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr20748100wme.147.1622715297711;
        Thu, 03 Jun 2021 03:14:57 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id y6sm5371063wmy.23.2021.06.03.03.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:14:57 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 05/10] bpfilter: Add struct match
Date:   Thu,  3 Jun 2021 14:14:20 +0400
Message-Id: <20210603101425.560384-6-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct match_ops defines polymorphic interface for matches. A match
consists of pointers to struct match_ops and struct xt_entry_match which
contains a payload for the match's type.

All match_ops are kept in a map by their name.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |  3 +-
 net/bpfilter/context.c                        | 44 +++++++++++++
 net/bpfilter/context.h                        |  5 ++
 net/bpfilter/match.c                          | 49 +++++++++++++++
 net/bpfilter/match.h                          | 33 ++++++++++
 net/bpfilter/xt_udp.c                         | 33 ++++++++++
 .../testing/selftests/bpf/bpfilter/.gitignore |  1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  7 +++
 .../selftests/bpf/bpfilter/test_match.c       | 63 +++++++++++++++++++
 9 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/context.c
 create mode 100644 net/bpfilter/match.c
 create mode 100644 net/bpfilter/match.h
 create mode 100644 net/bpfilter/xt_udp.c
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_match.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 1809759d08c4..59f2d35c1627 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,8 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o
+bpfilter_umh-objs := main.o map-common.o match.o context.o
+bpfilter_umh-objs += xt_udp.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
new file mode 100644
index 000000000000..6b6203dd22a7
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
+		err = map_insert(&ctx->match_ops_map, m->name, (void *)m);
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
index e7bc27ee1ace..60bb525843b0 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -10,9 +10,11 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <search.h>
 
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
index 000000000000..9879a3670711
--- /dev/null
+++ b/net/bpfilter/match.h
@@ -0,0 +1,33 @@
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
+
+struct match_ops {
+	char name[BPFILTER_EXTENSION_MAXNAMELEN];
+	uint8_t revision;
+	uint16_t size;
+	int (*check)(struct context *ctx, const struct bpfilter_ipt_match *ipt_match);
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
index 000000000000..a7fbe77a53cc
--- /dev/null
+++ b/net/bpfilter/xt_udp.c
@@ -0,0 +1,33 @@
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
+#include <errno.h>
+
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
+const struct match_ops xt_udp = { .name = "udp",
+				  .size = XT_ALIGN(sizeof(struct xt_udp)),
+				  .revision = 0,
+				  .check = xt_udp_check };
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 983fd06cbefa..9250411fa7aa 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -1,2 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_map
+test_match
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 647229a0596c..0ef156cdb198 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -9,9 +9,16 @@ BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
 CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 
 TEST_GEN_PROGS += test_map
+TEST_GEN_PROGS += test_match
 
 KSFT_KHDR_INSTALL := 1
 
 include ../../lib.mk
 
+BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
+
+BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c
+BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS)
+
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
+$(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS) $(BPFILTER_MATCH_SRCS)
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

