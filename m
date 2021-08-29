Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49B23FADDD
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhH2Sho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235936AbhH2Shh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:37:37 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EE2C061575
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:45 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z19so18184187edi.9
        for <netdev@vger.kernel.org>; Sun, 29 Aug 2021 11:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8hbmZQTTC0oUqf0t3P9f5l+TfblulbFw/n1Gdz/zdTM=;
        b=0qMPZ56lCURdBiMHGho/aHlQlcWxI6bsrZ7IUinH9UXKfQ/IE1zuizqHaeQITh70+Q
         pO7jMJ6ke8Wsbsp5Z7RT2OpaZF61pLWMarv6dikPrMFsrD0p+KtWh1Z26T2wEoY1BWJk
         ZOOWez731LF75VDhuRMirusPN2BG7LdyxvgSvEJblJcEzZFDhimUZrSMkTeGDCO56LX3
         F1EaFpkDak8+pbB5AoqxCZQIMUKWTdDatRgypMSb4oHwocOrX8ylkJ6CI+8oulsROyLR
         C94eVNghELqkMz2DTZY0mjkbBiS3xZ2QG+UeHz+Nz9RuF5qHfn86h2AmED+cBLrQ+A30
         UyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8hbmZQTTC0oUqf0t3P9f5l+TfblulbFw/n1Gdz/zdTM=;
        b=ikBcGRJukE/xGylQ2zLCCpiR6ZKGFG1KldrkIf3pCluBsDgWIbieDsx8pnIeDXoD9B
         iA0PBtQOqDUKxwzfQ9tYz2PquqHZroCsMZuaCS91G/orNjt2NQMxm1ScY40FYo4zwxAC
         MtX5oBGTGqzWgzy9T+DiBl+WZ4rVr10bUsKRJPhe2RrMR86YWVPTNdfArNPLg2sg+LQd
         cCCCdj58oQViPnUrByk09OR1q0ywudfvnGYZCzxu9Bs4h2zleKDfaCuCHZ7hu0rr2fXZ
         XLUx5RVQKkT81Us7Nr75kOI1j4jwgI0yWz8FQ0siDPwsXOgevvcW16Tshtymg4a/oiaH
         hE4w==
X-Gm-Message-State: AOAM531CCOzbIdevTngjd/eWNfs7ANrW2YxisUgEXmc4MKP4J8Q9utE/
        T1m5K6k64O8+EWFyFzKzn87jig==
X-Google-Smtp-Source: ABdhPJwh5szTQcYZWqlnoTOlk2pBiycARp2lZn5pXs0ENHwjpcpGKehlGmI7a1Hlf8TKHx9yn+wnCw==
X-Received: by 2002:aa7:d40b:: with SMTP id z11mr20068235edq.224.1630262203711;
        Sun, 29 Aug 2021 11:36:43 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id jz16sm3815428ejc.34.2021.08.29.11.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Aug 2021 11:36:43 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v2 09/13] bpfilter: Add struct table
Date:   Sun, 29 Aug 2021 22:36:04 +0400
Message-Id: <20210829183608.2297877-10-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210829183608.2297877-1-me@ubique.spb.ru>
References: <20210829183608.2297877-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct table_ops describes a set of operations for an individual table
type.
The set of operations consists of the following methods:
 * create: create an instance of a table from ipt_replace blob
 * codegen: generate code for a table
 * install: load BPF maps and progs and attach them
 * uninstall: detach loaded BPF maps and progs and unload them
 * free: free all resources used by a table

A table keeps an instance of iptables' table blob and an array of struct
rule for this blob.  The array of rules provides more convenient way to
interact with blob's entries.
struct table has a pointer to a struct table_ops which abstracts all the
operations with a table.

All tables are stored in a map which is used for lookups.
Also all tables are linked into a list that is used for freeing them.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        |  43 ++-
 net/bpfilter/context.h                        |   4 +
 net/bpfilter/table.c                          | 346 ++++++++++++++++++
 net/bpfilter/table.h                          |  54 +++
 tools/testing/selftests/bpf/bpfilter/Makefile |   3 +-
 6 files changed, 449 insertions(+), 3 deletions(-)
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 3f7c5c28cca2..cc4a16fbca04 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -11,7 +11,7 @@ $(LIBBPF_A):
 	$(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(LIBBPF_OUT)/ OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o codegen.o context.o match.o target.o rule.o
+bpfilter_umh-objs := main.o map-common.o codegen.o context.o match.o target.o rule.o table.o
 bpfilter_umh-objs += xt_udp.o
 bpfilter_umh-userldlibs := $(LIBBPF_A) -lelf -lz
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi -I $(srctree)/tools/lib
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index d3afc4ec0b05..898bd9520fa8 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -10,8 +10,12 @@
 #include <linux/err.h>
 #include <linux/list.h>
 
+#include <string.h>
+
 #include "map-common.h"
 #include "match.h"
+#include "rule.h"
+#include "table.h"
 #include "target.h"
 
 static int init_match_ops_map(struct context *ctx)
@@ -54,6 +58,18 @@ static int init_target_ops_map(struct context *ctx)
 	return 0;
 }
 
+static int init_table_ops_map(struct context *ctx)
+{
+	return create_map(&ctx->table_ops_map, 1);
+}
+
+static int init_table_index(struct context *ctx)
+{
+	INIT_LIST_HEAD(&ctx->table_index.list);
+
+	return create_map(&ctx->table_index.map, 1);
+}
+
 int create_context(struct context *ctx)
 {
 	int err;
@@ -66,8 +82,22 @@ int create_context(struct context *ctx)
 	if (err)
 		goto err_free_match_ops_map;
 
+	err = init_table_ops_map(ctx);
+	if (err)
+		goto err_free_target_ops_map;
+
+	err = init_table_index(ctx);
+	if (err)
+		goto err_free_table_ops_map;
+
 	return 0;
 
+err_free_table_ops_map:
+	free_map(&ctx->table_ops_map);
+
+err_free_target_ops_map:
+	free_map(&ctx->target_ops_map);
+
 err_free_match_ops_map:
 	free_map(&ctx->match_ops_map);
 
@@ -76,6 +106,17 @@ int create_context(struct context *ctx)
 
 void free_context(struct context *ctx)
 {
-	free_map(&ctx->match_ops_map);
+	struct list_head *t, *n;
+
+	list_for_each_safe(t, n, &ctx->table_index.list) {
+		struct table *table;
+
+		table = list_entry(t, struct table, list);
+		table->table_ops->uninstall(ctx, table);
+		table->table_ops->free(table);
+	}
+	free_map(&ctx->table_index.map);
+	free_map(&ctx->table_ops_map);
 	free_map(&ctx->target_ops_map);
+	free_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index fa73fc3ac64b..7fefa2393a32 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -12,10 +12,14 @@
 #include <stdio.h>
 #include <stdlib.h>
 
+#include "table.h"
+
 struct context {
 	FILE *log_file;
 	struct hsearch_data match_ops_map;
 	struct hsearch_data target_ops_map;
+	struct hsearch_data table_ops_map;
+	struct table_index table_index;
 };
 
 #define BFLOG_IMPL(ctx, level, fmt, ...)                                                           \
diff --git a/net/bpfilter/table.c b/net/bpfilter/table.c
new file mode 100644
index 000000000000..3092ec800853
--- /dev/null
+++ b/net/bpfilter/table.c
@@ -0,0 +1,346 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "table.h"
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "context.h"
+#include "rule.h"
+
+static int rule_offset_comparator(const void *x, const void *y)
+{
+	const struct rule *rule = y;
+
+	return x - (const void *)rule->ipt_entry;
+}
+
+static bool table_has_hook(const struct table *table, uint32_t hook)
+{
+	BUG_ON(hook >= BPFILTER_INET_HOOK_MAX);
+
+	return table->valid_hooks & (1 << hook);
+}
+
+static int table_init_rules(struct context *ctx, struct table *table,
+			    const struct bpfilter_ipt_replace *ipt_replace)
+{
+	uint32_t offset;
+	int i;
+
+	table->entries = malloc(table->size);
+	if (!table->entries)
+		return -ENOMEM;
+
+	memcpy(table->entries, ipt_replace->entries, table->size);
+
+	table->rules = calloc(table->num_rules, sizeof(table->rules[0]));
+	if (!table->rules)
+		return -ENOMEM;
+
+	offset = 0;
+	for (i = 0; i < table->num_rules; ++i) {
+		const struct bpfilter_ipt_entry *ipt_entry;
+		int err;
+
+		if (table->size < offset)
+			return -EINVAL;
+
+		if (table->size < offset + sizeof(*ipt_entry))
+			return -EINVAL;
+
+		ipt_entry = table->entries + offset;
+
+		if ((uintptr_t)ipt_entry % __alignof__(struct bpfilter_ipt_entry))
+			return -EINVAL;
+
+		if (table->size < offset + ipt_entry->next_offset)
+			return -EINVAL;
+
+		err = init_rule(ctx, ipt_entry, &table->rules[i]);
+		if (err)
+			return err;
+
+		table->rules[i].ipt_entry = ipt_entry;
+		offset += ipt_entry->next_offset;
+	}
+
+	if (offset != ipt_replace->size)
+		return -EINVAL;
+
+	if (table->num_rules != ipt_replace->num_entries)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int table_check_hooks(const struct table *table)
+{
+	uint32_t max_rule_front, max_rule_last;
+	bool check = false;
+	int i;
+
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		if (!table_has_hook(table, i))
+			continue;
+
+		if (check) {
+			if (table->hook_entry[i] <= max_rule_front)
+				return -EINVAL;
+
+			if (table->underflow[i] <= max_rule_last)
+				return -EINVAL;
+		}
+
+		max_rule_front = table->hook_entry[i];
+		max_rule_last = table->underflow[i];
+		check = true;
+	}
+
+	return 0;
+}
+
+static int table_init_hooks(struct table *table, const struct bpfilter_ipt_replace *ipt_replace)
+{
+	int i;
+
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		struct rule *rule_front, *rule_last;
+		int verdict;
+
+		if (!table_has_hook(table, i))
+			continue;
+
+		rule_front = table_find_rule_by_offset(table, ipt_replace->hook_entry[i]);
+		rule_last = table_find_rule_by_offset(table, ipt_replace->underflow[i]);
+
+		if (!rule_front || !rule_last)
+			return -EINVAL;
+
+		if (!is_rule_unconditional(rule_last))
+			return -EINVAL;
+
+		if (!rule_has_standard_target(rule_last))
+			return -EINVAL;
+
+		verdict = standard_target_verdict(rule_last->target.ipt_target);
+		if (verdict >= 0)
+			return -EINVAL;
+
+		verdict = convert_verdict(verdict);
+
+		if (verdict != BPFILTER_NF_DROP && verdict != BPFILTER_NF_ACCEPT)
+			return -EINVAL;
+
+		table->hook_entry[i] = rule_front - table->rules;
+		table->underflow[i] = rule_last - table->rules;
+	}
+
+	return table_check_hooks(table);
+}
+
+static struct rule *next_rule(const struct table *table, struct rule *rule)
+{
+	const uint32_t i = rule - table->rules;
+
+	if (table->num_rules <= i + 1)
+		return ERR_PTR(-EINVAL);
+
+	++rule;
+	rule->came_from = i;
+
+	return rule;
+}
+
+static struct rule *backtrack_rule(const struct table *table, struct rule *rule)
+{
+	uint32_t i = rule - table->rules;
+	int prev_i;
+
+	do {
+		rule->hook_mask ^= (1 << BPFILTER_INET_HOOK_MAX);
+		prev_i = i;
+		i = rule->came_from;
+		rule->came_from = 0;
+
+		if (i == prev_i)
+			return NULL;
+
+		rule = &table->rules[i];
+	} while (prev_i == i + 1);
+
+	return next_rule(table, rule);
+}
+
+static int table_check_chain(struct table *table, uint32_t hook, struct rule *rule)
+{
+	uint32_t i = rule - table->rules;
+
+	rule->came_from = i;
+
+	for (;;) {
+		bool visited;
+		int verdict;
+
+		if (!rule)
+			return 0;
+
+		if (IS_ERR(rule))
+			return PTR_ERR(rule);
+
+		i = rule - table->rules;
+
+		if (table->num_rules <= i)
+			return -EINVAL;
+
+		if (rule->hook_mask & (1 << BPFILTER_INET_HOOK_MAX))
+			return -EINVAL;
+
+		// already visited
+		visited = rule->hook_mask & (1 << hook);
+		rule->hook_mask |= (1 << hook) | (1 << BPFILTER_INET_HOOK_MAX);
+
+		if (visited) {
+			rule = backtrack_rule(table, rule);
+			continue;
+		}
+
+		if (!rule_has_standard_target(rule)) {
+			rule = next_rule(table, rule);
+			continue;
+		}
+
+		verdict = standard_target_verdict(rule->target.ipt_target);
+		if (verdict > 0) {
+			rule = table_find_rule_by_offset(table, verdict);
+			if (!rule)
+				return -EINVAL;
+
+			rule->came_from = i;
+			continue;
+		}
+
+		if (!is_rule_unconditional(rule)) {
+			rule = next_rule(table, rule);
+			continue;
+		}
+
+		rule = backtrack_rule(table, rule);
+	}
+
+	return 0;
+}
+
+static int table_check_chains(struct table *table)
+{
+	int i, err;
+
+	for (i = 0, err = 0; !err && i < BPFILTER_INET_HOOK_MAX; ++i) {
+		if (table_has_hook(table, i))
+			err = table_check_chain(table, i, &table->rules[table->hook_entry[i]]);
+	}
+
+	return err;
+}
+
+struct table *create_table(struct context *ctx, const struct bpfilter_ipt_replace *ipt_replace)
+{
+	struct table *table;
+	int err;
+
+	table = calloc(1, sizeof(*table));
+	if (!table)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&table->list);
+	table->valid_hooks = ipt_replace->valid_hooks;
+	table->num_rules = ipt_replace->num_entries;
+	table->num_counters = ipt_replace->num_counters;
+	table->size = ipt_replace->size;
+
+	err = table_init_rules(ctx, table, ipt_replace);
+	if (err)
+		goto err_free;
+
+	err = table_init_hooks(table, ipt_replace);
+	if (err)
+		goto err_free;
+
+	err = table_check_chains(table);
+	if (err)
+		goto err_free;
+
+	return table;
+
+err_free:
+	free_table(table);
+
+	return ERR_PTR(err);
+}
+
+struct rule *table_find_rule_by_offset(const struct table *table, uint32_t offset)
+{
+	const struct bpfilter_ipt_entry *key;
+
+	key = table->entries + offset;
+
+	return bsearch(key, table->rules, table->num_rules, sizeof(table->rules[0]),
+		       rule_offset_comparator);
+}
+
+void table_get_info(const struct table *table, struct bpfilter_ipt_get_info *info)
+{
+	int i;
+
+	snprintf(info->name, sizeof(info->name), "%s", table->table_ops->name);
+	info->valid_hooks = table->valid_hooks;
+
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		const struct rule *rule_front, *rule_last;
+
+		if (!table_has_hook(table, i)) {
+			info->hook_entry[i] = 0;
+			info->underflow[i] = 0;
+			continue;
+		}
+
+		rule_front = &table->rules[table->hook_entry[i]];
+		rule_last = &table->rules[table->underflow[i]];
+		info->hook_entry[i] = (const void *)rule_front->ipt_entry - table->entries;
+		info->underflow[i] = (const void *)rule_last->ipt_entry - table->entries;
+	}
+
+	info->num_entries = table->num_rules;
+	info->size = table->size;
+}
+
+void free_table(struct table *table)
+{
+	int i;
+
+	if (!table)
+		return;
+
+	list_del(&table->list);
+
+	if (table->rules) {
+		for (i = 0; i < table->num_rules; ++i)
+			free_rule(&table->rules[i]);
+		free(table->rules);
+	}
+
+	free(table->entries);
+	free(table);
+}
diff --git a/net/bpfilter/table.h b/net/bpfilter/table.h
new file mode 100644
index 000000000000..799a58f49687
--- /dev/null
+++ b/net/bpfilter/table.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_TABLE_H
+#define NET_BPFILTER_TABLE_H
+
+#include "../../include/uapi/linux/bpfilter.h"
+
+#include <linux/types.h>
+
+#include <search.h>
+#include <stdint.h>
+
+struct context;
+struct rule;
+struct table;
+
+struct table_ops {
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	struct table *(*create)(struct context *ctx,
+				const struct bpfilter_ipt_replace *ipt_replace);
+	int (*codegen)(struct context *ctx, struct table *table);
+	int (*install)(struct context *ctx, struct table *table);
+	void (*uninstall)(struct context *ctx, struct table *table);
+	void (*free)(struct table *table);
+};
+
+struct table {
+	const struct table_ops *table_ops;
+	uint32_t valid_hooks;
+	uint32_t num_rules;
+	uint32_t num_counters;
+	uint32_t size;
+	uint32_t hook_entry[BPFILTER_INET_HOOK_MAX];
+	uint32_t underflow[BPFILTER_INET_HOOK_MAX];
+	struct rule *rules;
+	void *entries;
+	void *ctx;
+	struct list_head list;
+};
+
+struct table_index {
+	struct hsearch_data map;
+	struct list_head list;
+};
+
+struct table *create_table(struct context *ctx, const struct bpfilter_ipt_replace *ipt_replace);
+struct rule *table_find_rule_by_offset(const struct table *table, uint32_t offset);
+void table_get_info(const struct table *table, struct bpfilter_ipt_get_info *info);
+void free_table(struct table *table);
+
+#endif // NET_BPFILTER_TABLE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 779add65fa27..d47f6bcd342b 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -42,10 +42,11 @@ BPFILTER_CODEGEN_SRCS := $(BPFILTERSRCDIR)/codegen.c $(BPFOBJ) -lelf -lz
 BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
 BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
 BPFILTER_RULE_SRCS := $(BPFILTERSRCDIR)/rule.c
+BPFILTER_TABLE_SRCS := $(BPFILTERSRCDIR)/table.c
 
 BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/context.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MAP_SRCS) $(BPFILTER_CODEGEN_SRCS) $(BPFILTER_MATCH_SRCS)
-BPFILTER_COMMON_SRCS += $(BPFILTER_TARGET_SRCS) $(BPFILTER_RULE_SRCS)
+BPFILTER_COMMON_SRCS += $(BPFILTER_TARGET_SRCS) $(BPFILTER_RULE_SRCS) $(BPFILTER_TABLE_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTER_MAP_SRCS)
 $(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
-- 
2.25.1

