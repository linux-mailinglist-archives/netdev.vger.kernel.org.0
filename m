Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071F4399EAD
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhFCKRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:17:51 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:39677 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhFCKRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:17:50 -0400
Received: by mail-wr1-f46.google.com with SMTP id l2so5263614wrw.6
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y8W3XdtBsyo4G7m2GOlm4F23ti6XMBPdC4TasHorY8U=;
        b=r6nOTOVt5iuhnwfTN0/shMtC0jshcHLjtJdP7YGywikchCo7u7hAnAuX1TP3e+UWSd
         YVH7+QRXbL87kDLvAqLXbB4UbBcPL8HTLxIP346WUvGP78aZjtW+Gu3qoCNiro+hFTrx
         Iei9hm35IE4HGMJF5BaxPeaM4g5VhqEOH3W5QNru+JM8LQtRg31LySqufrII4lxMslgf
         +uP9URCS+qCc9lPr5HpEJHJvmkN+mcr93ymNwzy/VSgi8kXrbA4tDOJ65/msz95XOddz
         RZTFPZ/Cmf2J4C4ftrVQ4lBlTyrv5+YayCJAruuyLGVHX4EiR70HnPj9RjS/oLgjZufk
         DIBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y8W3XdtBsyo4G7m2GOlm4F23ti6XMBPdC4TasHorY8U=;
        b=er5CmNbT6jtr6/BbF75uNq1KuFIAxXkiHk0IKeub3DV6+hn/Up1LX/KlUxr55XMB5g
         Exat8lLExg3iyaJTHlpkM+q918yhabcga3UAfwnMvKG/c9o66BRQSaKXv4DKFP1toSeC
         O5ZN4q5dh4R9FQeC0LJpMZvnVX1PeKcRghEOQgMFwoxvqkps9nyc0dFhloizV5d2WYqX
         gahfHuBMOawkbYJhHuKzq4W3z2O8qFViBAlQsejULoNwvSabyS2gucNP3DVmXyrDE6kF
         ksyGNTWGxCCxx1wckvpgBLm1YcHiPnRwEP57EFsPIqhCuUfAeOcZlLIT991c7BvdlQOV
         4uig==
X-Gm-Message-State: AOAM5338UfBS13P7qUz3wegRAIMp7iraj++tPkEAuQBqZTmsQiGaQ9FS
        qhA/ElHSsKBg+6obn9wyseHGPKhWnLUfjQgv2AA=
X-Google-Smtp-Source: ABdhPJw2hbGU8yvOrHPYQOT+gkY9gGKgAupue+G4io0kYzK8fkoD8IQVUflOPGNaUSQ1cfTZp0z6TQ==
X-Received: by 2002:a5d:5902:: with SMTP id v2mr25405209wrd.272.1622715305598;
        Thu, 03 Jun 2021 03:15:05 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id 30sm3052943wrl.37.2021.06.03.03.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:15:05 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 07/10] bpfilter: Add struct rule
Date:   Thu,  3 Jun 2021 14:14:22 +0400
Message-Id: <20210603101425.560384-8-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct rule is an equivalent of struct ipt_entry. A rule consists of
zero or more matches and a target. A rule has a pointer to its ipt_entry
in entries blob.  struct rule should simplify iteration over a blob and
avoid blob's guts in code generation.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/rule.c                           | 163 ++++++++++++++++++
 net/bpfilter/rule.h                           |  32 ++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
 tools/testing/selftests/bpf/bpfilter/Makefile |   5 +-
 .../selftests/bpf/bpfilter/bpfilter_util.h    |   8 +
 .../selftests/bpf/bpfilter/test_rule.c        |  55 ++++++
 7 files changed, 264 insertions(+), 2 deletions(-)
 create mode 100644 net/bpfilter/rule.c
 create mode 100644 net/bpfilter/rule.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_rule.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 031c9dd40d2d..7ce961162283 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o context.o match.o target.o
+bpfilter_umh-objs := main.o map-common.o context.o match.o target.o rule.o
 bpfilter_umh-objs += xt_udp.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/rule.c b/net/bpfilter/rule.c
new file mode 100644
index 000000000000..6018b4b7c0cc
--- /dev/null
+++ b/net/bpfilter/rule.c
@@ -0,0 +1,163 @@
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
+#include <linux/netfilter/x_tables.h>
+
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "context.h"
+#include "match.h"
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
+		if ((uintptr_t)ipt_match % __alignof__(struct bpfilter_ipt_match))
+			return -EINVAL;
+
+		if (ipt_entry->target_offset < offset + sizeof(*ipt_match))
+			return -EINVAL;
+
+		if (ipt_match->u.match_size < sizeof(*ipt_match))
+			return -EINVAL;
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
+		if (err) {
+			free(rule->matches);
+			rule->matches = NULL;
+			return err;
+		}
+
+		++match;
+		offset += ipt_match->u.match_size;
+	}
+
+	return 0;
+}
+
+static int check_ipt_entry_ip(const struct bpfilter_ipt_ip *ip)
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
+bool rule_has_standard_target(const struct rule *rule)
+{
+	return rule->target.target_ops == &standard_target_ops;
+}
+
+bool is_rule_unconditional(const struct rule *rule)
+{
+	static const struct bpfilter_ipt_ip unconditional;
+
+	if (rule->num_matches)
+		return false;
+
+	return !memcmp(&rule->ipt_entry->ip, &unconditional, sizeof(unconditional));
+}
+
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule)
+{
+	const struct bpfilter_ipt_target *ipt_target;
+	int err;
+
+	err = check_ipt_entry_ip(&ipt_entry->ip);
+	if (err)
+		return err;
+
+	if (ipt_entry->target_offset < sizeof(*ipt_entry))
+		return -EINVAL;
+
+	if (ipt_entry->next_offset < ipt_entry->target_offset + sizeof(*ipt_target))
+		return -EINVAL;
+
+	ipt_target = ipt_entry_target(ipt_entry);
+
+	if (ipt_target->u.target_size < sizeof(*ipt_target))
+		return -EINVAL;
+
+	if (ipt_entry->next_offset < ipt_entry->target_offset + ipt_target->u.target_size)
+		return -EINVAL;
+
+	err = init_target(ctx, ipt_target, &rule->target);
+	if (err)
+		return err;
+
+	if (rule_has_standard_target(rule)) {
+		if (XT_ALIGN(ipt_entry->target_offset +
+			     sizeof(struct bpfilter_ipt_standard_target)) != ipt_entry->next_offset)
+			return -EINVAL;
+	}
+
+	rule->num_matches = ipt_entry_num_matches(ipt_entry);
+	if (rule->num_matches < 0)
+		return rule->num_matches;
+
+	return init_rule_matches(ctx, ipt_entry, rule);
+}
+
+void free_rule(struct rule *rule)
+{
+	free(rule->matches);
+}
diff --git a/net/bpfilter/rule.h b/net/bpfilter/rule.h
new file mode 100644
index 000000000000..cf879a19c670
--- /dev/null
+++ b/net/bpfilter/rule.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_RULE_H
+#define NET_BPFILTER_RULE_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "target.h"
+
+struct bpfilter_ipt_entry;
+struct context;
+struct match;
+
+struct rule {
+	const struct bpfilter_ipt_entry *ipt_entry;
+	uint32_t came_from;
+	uint32_t hook_mask;
+	uint16_t num_matches;
+	struct match *matches;
+	struct target target;
+};
+
+bool rule_has_standard_target(const struct rule *rule);
+bool is_rule_unconditional(const struct rule *rule);
+int init_rule(struct context *ctx, const struct bpfilter_ipt_entry *ipt_entry, struct rule *rule);
+void free_rule(struct rule *rule);
+
+#endif // NET_BPFILTER_RULE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
index 7e077f506af1..4d7c5083d980 100644
--- a/tools/testing/selftests/bpf/bpfilter/.gitignore
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -2,3 +2,4 @@
 test_map
 test_match
 test_target
+test_rule
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index a11775e8b5af..27a1ddcb6dc9 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -11,6 +11,7 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
 TEST_GEN_PROGS += test_map
 TEST_GEN_PROGS += test_match
 TEST_GEN_PROGS += test_target
+TEST_GEN_PROGS += test_rule
 
 KSFT_KHDR_INSTALL := 1
 
@@ -19,9 +20,11 @@ include ../../lib.mk
 BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
 BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
 
-BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c
+BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c \
+	$(BPFILTERSRCDIR)/rule.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
 $(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
+$(OUTPUT)/test_rule: test_rule.c $(BPFILTER_COMMON_SRCS)
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

