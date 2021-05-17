Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6E386D50
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344296AbhEQWzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344295AbhEQWzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:55:07 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FAEC06138B
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:50 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c14so6257154wrx.3
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fBmlXuxpodPLFCV6Z3mqL72cuU4IQnrOwtA/np0iQRw=;
        b=NxZ+9AhsJbent2L5MCyTBwYnpY9+i82pgAXRuuAiU2rnt/pbZd3LyVR/jLI8uBvwPi
         HwT0YN0qv+bLO+72Aksow+q0SPn2jcrOPYQS/k8jkeQtxFwGVuTZQ2RFZjcrOMioMOXj
         e5R+L4QGbWTXVWVTm4nopcHJaUQyR2DWIBqeuUFWa/C2/w1Jsyah5PbBpQ1gwUr6/WNM
         yZ/Ll1HpdVTqXkOG4kv/moV88asH9/os8IoXK5GybOqW4SJuxbarM+sKfYheHmmy86t8
         fRoDpH3LxxAi+/AD/LI60A7kksIA03iz0I+VVE7A1ia80aDHIBWOIjl4XuuCnaRS/+Pu
         gwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fBmlXuxpodPLFCV6Z3mqL72cuU4IQnrOwtA/np0iQRw=;
        b=GkBnvEBtW8KwwiinunLsH06GjCc34wOr8qxE3FP08l0OH1TnAEvFOABtMeGEFG75ee
         FbeTzLyyl+f/T/Fgr1cMQrmt2A49b9qCYnLaoQPkYPl3RdKcBUYYkrXrMZD7h32cbGN4
         gsH1HOWelovj/ZBd1npmNP6lg/jPgvd5r/t9qWZii72niaPOKjRvJL50KJc9MAYvXvr6
         EI2FFW//0/vSdturB3/sLtQzfdjgPwsCmYxp0Qq2paL9IgHhwBhbAR4ksh2MNjOmTZE9
         J9GxUR9wmhf0AnF/1DLjpRCOIWgHb9eQryx3xMbSORjqKdwSzkXCHZ+v30jEOR0Tq3rF
         B0bw==
X-Gm-Message-State: AOAM531JwidSjWUw5nyG52oqF+2urpnGYla3DBh9CieDGGKhphvqiJyy
        yxczSDZDPEu+f6u65ChhsMNOLQ==
X-Google-Smtp-Source: ABdhPJxh8ZRmCYF3CtzithAqkpP8LylGkmCLAaOQJI4xfGHkgq97jrsyIIfkHLiP+JqMKBuG7BFCTQ==
X-Received: by 2002:a5d:4e8c:: with SMTP id e12mr2531229wru.94.1621292029018;
        Mon, 17 May 2021 15:53:49 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id b10sm22257300wrr.27.2021.05.17.15.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:48 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 08/11] bpfilter: Add struct rule
Date:   Tue, 18 May 2021 02:53:05 +0400
Message-Id: <20210517225308.720677-9-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct rule is an equivalent of struct ipt_entry. A rule consists of
zero or more matches and a target. A rule tracks its own offset in
iptables' entries blob. struct rule should simplify iteration over a
blob and avoid blob's guts in code generation.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/rule.c                           | 128 ++++++++++++++++++
 net/bpfilter/rule.h                           |  27 ++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   4 +
 .../selftests/bpf/bpfilter/bpfilter_util.h    |   8 ++
 .../selftests/bpf/bpfilter/test_rule.c        |  55 ++++++++
 7 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index f3de07bc8004..1191770d41f7 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o
+bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o rule.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/rule.c b/net/bpfilter/rule.c
new file mode 100644
index 000000000000..0cbee4656070
--- /dev/null
+++ b/net/bpfilter/rule.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "rule.h"
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <linux/err.h>
+
+#include <errno.h>
+#include <stdlib.h>
+
+#include "context.h"
+#include "bflog.h"
+
+static const struct bpfilter_ipt_target *
+ipt_entry_target(const struct bpfilter_ipt_entry *ipt_entry)
+{
+	return (const void *)ipt_entry + ipt_entry->target_offset;
+}
+
+static const struct bpfilter_ipt_match *ipt_entry_match(const struct bpfilter_ipt_entry *entry,
+							size_t offset)
+{
+	return (const void *)entry + offset;
+}
+
+static int ipt_entry_num_matches(const struct bpfilter_ipt_entry *ipt_entry)
+{
+	const struct bpfilter_ipt_match *ipt_match;
+	uint32_t offset = sizeof(*ipt_entry);
+	int num_matches = 0;
+
+	while (offset < ipt_entry->target_offset) {
+		ipt_match = ipt_entry_match(ipt_entry, offset);
+
+		if (ipt_entry->target_offset < offset + ipt_match->u.match_size)
+			return -EINVAL;
+
+		++num_matches;
+		offset += ipt_match->u.match_size;
+	}
+
+	if (offset != ipt_entry->target_offset)
+		return -EINVAL;
+
+	return num_matches;
+}
+
+static int check_ipt_entry_ip(struct context *ctx, const struct bpfilter_ipt_ip *ip)
+{
+	if (ip->flags & ~BPFILTER_IPT_F_MASK)
+		return -EINVAL;
+
+	if (ip->invflags & ~BPFILTER_IPT_INV_MASK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int init_rule_matches(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry,
+			     struct rule *rule)
+{
+	const struct bpfilter_ipt_match *ipt_match;
+	uint32_t offset = sizeof(*ipt_entry);
+	struct match *match;
+	int err;
+
+	rule->matches = calloc(rule->num_matches, sizeof(rule->matches[0]));
+	if (!rule->matches)
+		return -ENOMEM;
+
+	match = rule->matches;
+	while (offset < ipt_entry->target_offset) {
+		ipt_match = ipt_entry_match(ipt_entry, offset);
+		err = init_match(ctx, ipt_match, match);
+		if (err)
+			return err;
+
+		++match;
+		offset += ipt_match->u.match_size;
+	}
+
+	return 0;
+}
+
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule)
+{
+	const struct bpfilter_ipt_target *ipt_target;
+	int err;
+
+	err = check_ipt_entry_ip(ctx, &ipt_entry->ip);
+
+	if (ipt_entry->next_offset < ipt_entry->target_offset)
+		return -EINVAL;
+
+	if (ipt_entry->target_offset < sizeof(*ipt_entry))
+		return -EINVAL;
+
+	ipt_target = ipt_entry_target(ipt_entry);
+	if (ipt_target->u.target_size != ipt_entry->next_offset - ipt_entry->target_offset)
+		return -EINVAL;
+
+	err = init_target(ctx, ipt_target, &rule->target);
+	if (err)
+		return err;
+
+	rule->num_matches = ipt_entry_num_matches(ipt_entry);
+	if (rule->num_matches < 0)
+		return rule->num_matches;
+
+	err = init_rule_matches(ctx, ipt_entry, rule);
+	if (err) {
+		free_rule(rule);
+		return err;
+	}
+
+	return 0;
+}
+
+void free_rule(struct rule *rule)
+{
+	free(rule->matches);
+}
diff --git a/net/bpfilter/rule.h b/net/bpfilter/rule.h
new file mode 100644
index 000000000000..b445962485a4
--- /dev/null
+++ b/net/bpfilter/rule.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_RULE_H
+#define NET_BPFILTER_RULE_H
+
+#include <stdint.h>
+
+#include "target.h"
+
+struct bpfilter_ipt_entry;
+struct context;
+struct match;
+
+struct rule {
+	uint32_t offset;
+	uint16_t num_matches;
+	struct match *matches;
+	struct target target;
+};
+
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule);
+void free_rule(struct rule *rule);
+
+#endif // NET_BPFILTER_RULE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 1856d0515f49..c5ccfe4db881 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -3,3 +3,4 @@ test_io
 test_map
 test_match
 test_target
+test_rule
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 78da74b9ee68..02d860e02c58 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -12,6 +12,7 @@ TEST_GEN_PROGS += test_io
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
 TEST_GEN_PROGS += test_target
+TEST_GEN_PROGS += test_rule
 
 KSFT_KHDR_INSTALL := 1
 
@@ -23,3 +24,6 @@ $(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/m
 	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/target.c
 $(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/map-common.c \
 	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/match.c
+$(OUTPUT)/test_rule: test_rule.c $(BPFILTERSRCDIR)/rule.c $(BPFILTERSRCDIR)/bflog.c 		\
+	$(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/match.c	\
+	$(BPFILTERSRCDIR)/target.c
diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
index d82ff86f280e..55fb0e959fca 100644
--- a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
+++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
@@ -7,6 +7,7 @@
 #include <linux/netfilter/x_tables.h>
 
 #include <stdio.h>
+#include <string.h>
 
 static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
 					int verdict)
@@ -28,4 +29,11 @@ static inline void init_error_target(struct xt_error_target *ipt_target, int rev
 	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
 }
 
+static inline void init_standard_entry(struct ipt_entry *entry, __u16 matches_size)
+{
+	memset(entry, 0, sizeof(*entry));
+	entry->target_offset = sizeof(*entry) + matches_size;
+	entry->next_offset = sizeof(*entry) + matches_size + sizeof(struct xt_standard_target);
+}
+
 #endif // BPFILTER_UTIL_H
diff --git a/tools/testing/selftests/bpf/bpfilter/test_rule.c b/tools/testing/selftests/bpf/bpfilter/test_rule.c
new file mode 100644
index 000000000000..fe12adf32fe5
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_rule.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include "rule.h"
+
+#include <linux/bpfilter.h>
+#include <linux/err.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "../../kselftest_harness.h"
+
+#include "context.h"
+#include "rule.h"
+
+#include "bpfilter_util.h"
+
+FIXTURE(test_standard_rule)
+{
+	struct context ctx;
+	struct {
+		struct ipt_entry entry;
+		struct xt_standard_target target;
+	} entry;
+	struct rule rule;
+};
+
+FIXTURE_SETUP(test_standard_rule)
+{
+	const int verdict = BPFILTER_NF_ACCEPT;
+
+	ASSERT_EQ(create_context(&self->ctx), 0);
+	self->ctx.log_file = stderr;
+
+	init_standard_entry(&self->entry.entry, 0);
+	init_standard_target(&self->entry.target, 0, -verdict - 1);
+}
+
+FIXTURE_TEARDOWN(test_standard_rule)
+{
+	free_rule(&self->rule);
+	free_context(&self->ctx);
+}
+
+TEST_F(test_standard_rule, init)
+{
+	ASSERT_EQ(0, init_rule(&self->ctx, (const struct bpfilter_ipt_entry *)&self->entry.entry,
+			       &self->rule));
+}
+
+TEST_HARNESS_MAIN
-- 
2.25.1

