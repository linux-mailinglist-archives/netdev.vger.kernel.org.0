Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2685399EB2
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhFCKSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:18:09 -0400
Received: from mail-wm1-f48.google.com ([209.85.128.48]:42746 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFCKSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:18:06 -0400
Received: by mail-wm1-f48.google.com with SMTP id o2-20020a05600c4fc2b029019a0a8f959dso3370500wmq.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MWVBG8bhTEvfTNX0c7USO3GdvAznp6eDvMG3ty9z5II=;
        b=s4x5M5RYrYZvr65JyalSxELpLfoJHYifiEwUAEIxZ1+isRiIJSY3bnItvux5TxzUMX
         A3ZEysA3/LtnLl7U0V3r7ywU6DqfEKLua2UcG5NStcCpDc0HOBfjnfmLdQYN4ppG5O3A
         EB0ELyuJtkIQNhd0xx38fgx+bZwfRuVjlaZTzMiRy5MmWWe/cQZDzhdNMf9UuLYR2rm4
         ixak4HgPdBjUdI/N4mEo3QaYy3sIwI9V+Y9aTf714/L6pjsCfZ+0btn71XiOQCFRKUAP
         cPYM4oL6o1L55CkSHc4hb4QAdhNAFOLQDmqZsi6xu6Zv/P0phNU84SaY4MHsrIX7IRwO
         uEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MWVBG8bhTEvfTNX0c7USO3GdvAznp6eDvMG3ty9z5II=;
        b=Ck8KwZmgm5hCtg0HOawtr218Gx8TDjAnnydnadTzzeZPe5qz/7UGBj/jQtwCu0iRZe
         jsHTiYew+e7u9JZSkx152HxMxuvEJMx2RpPmiAAOAqZvT91XBUfEZ7UG2RamMWIQQzpv
         0oMuG+1hi+l5EOcBe5IqL8XBJxEJmlptAv4ehToKZ+JAAEHRChcanNtMnBtgSGDCWE9Y
         s2tzPOt10jxSw/STtCfwkv7UNbN0raynJCOeXC62AzW50bp81QOl9SRLlBVF1asEcmQ5
         yGhKV8nCWuicrxruYw/fcdMZr/+VCMN3b9eKXFIUI2jjm7tlfgfCMeaYfUoULUvA+oPZ
         QcqA==
X-Gm-Message-State: AOAM530GFO9+2epJrukbTLXtoPzHJFkHrGoC5hWMbAZl3RYzaNhM5XT6
        Ut2K3VCE/iD4Y3rMTccyhZiN3g==
X-Google-Smtp-Source: ABdhPJzY9Lk15AJLUhUFbRzauVo+JS14USdSjVB1SMw90oo7usk79KrfTvbRDLDTIxpso0fmOxDn+g==
X-Received: by 2002:a05:600c:19d3:: with SMTP id u19mr4430741wmq.100.1622715308959;
        Thu, 03 Jun 2021 03:15:08 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id i12sm2293739wmq.7.2021.06.03.03.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:15:08 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 08/10] bpfilter: Add struct table
Date:   Thu,  3 Jun 2021 14:14:23 +0400
Message-Id: <20210603101425.560384-9-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A table keeps iptables' blob and an array of struct rule for this blob.
The array of rules provides more convenient way to interact with blob's
entries.

All tables are stored in a map which is used for lookups.
Also all tables are linked into a list that is used for freeing them.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        | 103 ++++++
 net/bpfilter/context.h                        |   5 +-
 net/bpfilter/table.c                          | 339 ++++++++++++++++++
 net/bpfilter/table.h                          |  39 ++
 tools/testing/selftests/bpf/bpfilter/Makefile |   2 +-
 6 files changed, 487 insertions(+), 3 deletions(-)
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 7ce961162283..e16fee837ca0 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o context.o match.o target.o rule.o
+bpfilter_umh-objs := main.o map-common.o context.o match.o target.o rule.o table.o
 bpfilter_umh-objs += xt_udp.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index 6e186399609e..beb4454d1218 100644
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
@@ -54,6 +58,88 @@ static int init_target_ops_map(struct context *ctx)
 	return 0;
 }
 
+static void init_standard_entry(struct bpfilter_ipt_standard_entry *ipt_entry)
+{
+	ipt_entry->entry.next_offset = sizeof(*ipt_entry);
+	ipt_entry->entry.target_offset = sizeof(ipt_entry->entry);
+	ipt_entry->target.target.u.user.revision = 0;
+	ipt_entry->target.target.u.user.target_size = sizeof(struct bpfilter_ipt_standard_target);
+	ipt_entry->target.verdict = -BPFILTER_NF_ACCEPT - 1;
+}
+
+static void init_error_entry(struct bpfilter_ipt_error_entry *ipt_entry)
+{
+	ipt_entry->entry.next_offset = sizeof(*ipt_entry);
+	ipt_entry->entry.target_offset = sizeof(ipt_entry->entry);
+	ipt_entry->target.target.u.target_size = sizeof(struct bpfilter_ipt_error_target);
+	ipt_entry->target.target.u.user.revision = 0;
+	snprintf(ipt_entry->target.target.u.user.name, sizeof(ipt_entry->target.target.u.user.name),
+		 "ERROR");
+}
+
+static struct table *create_filter_table(struct context *ctx)
+{
+	struct filter_table_entries {
+		struct bpfilter_ipt_standard_entry local_in;
+		struct bpfilter_ipt_standard_entry forward;
+		struct bpfilter_ipt_standard_entry local_out;
+		struct bpfilter_ipt_error_entry error;
+	};
+
+	struct filter_table {
+		struct bpfilter_ipt_replace replace;
+		struct filter_table_entries entries;
+	} filter_table;
+
+	memset(&filter_table, 0, sizeof(filter_table));
+
+	snprintf(filter_table.replace.name, sizeof(filter_table.replace.name), "filter");
+	filter_table.replace.valid_hooks = 1 << BPFILTER_INET_HOOK_LOCAL_IN |
+					   1 << BPFILTER_INET_HOOK_FORWARD |
+					   1 << BPFILTER_INET_HOOK_LOCAL_OUT;
+	filter_table.replace.num_entries = 4;
+	filter_table.replace.size = sizeof(struct filter_table_entries);
+
+	filter_table.replace.hook_entry[BPFILTER_INET_HOOK_FORWARD] =
+		offsetof(struct filter_table_entries, forward);
+	filter_table.replace.underflow[BPFILTER_INET_HOOK_FORWARD] =
+		offsetof(struct filter_table_entries, forward);
+
+	filter_table.replace.hook_entry[BPFILTER_INET_HOOK_LOCAL_OUT] =
+		offsetof(struct filter_table_entries, local_out);
+	filter_table.replace.underflow[BPFILTER_INET_HOOK_LOCAL_OUT] =
+		offsetof(struct filter_table_entries, local_out);
+
+	init_standard_entry(&filter_table.entries.local_in);
+	init_standard_entry(&filter_table.entries.forward);
+	init_standard_entry(&filter_table.entries.local_out);
+	init_error_entry(&filter_table.entries.error);
+
+	return create_table(ctx, &filter_table.replace);
+}
+
+static int init_table_index(struct context *ctx)
+{
+	struct table *table;
+	int err;
+
+	INIT_LIST_HEAD(&ctx->table_index.list);
+
+	err = create_map(&ctx->table_index.map, 1);
+	if (err)
+		return err;
+
+	table = create_filter_table(ctx);
+	if (IS_ERR(table)) {
+		free_map(&ctx->table_index.map);
+		return PTR_ERR(table);
+	}
+
+	list_add_tail(&table->list, &ctx->table_index.list);
+
+	return map_insert(&ctx->table_index.map, table->name, table);
+}
+
 int create_context(struct context *ctx)
 {
 	int err;
@@ -68,11 +154,28 @@ int create_context(struct context *ctx)
 		return err;
 	}
 
+	err = init_table_index(ctx);
+	if (err) {
+		free_map(&ctx->match_ops_map);
+		free_map(&ctx->target_ops_map);
+		return err;
+	}
+
 	return 0;
 }
 
 void free_context(struct context *ctx)
 {
+	struct list_head *t, *n;
+
+	list_for_each_safe(t, n, &ctx->table_index.list) {
+		struct table *table;
+
+		table = list_entry(t, struct table, list);
+		free_table(table);
+	}
+
+	free_map(&ctx->table_index.map);
 	free_map(&ctx->match_ops_map);
 	free_map(&ctx->target_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index ed268259adcc..740d30af9087 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -8,14 +8,17 @@
 
 #include <sys/syslog.h>
 
+#include <search.h>
 #include <stdio.h>
 #include <stdlib.h>
-#include <search.h>
+
+#include "table.h"
 
 struct context {
 	FILE *log_file;
 	struct hsearch_data match_ops_map;
 	struct hsearch_data target_ops_map;
+	struct table_index table_index;
 };
 
 #define BFLOG_IMPL(ctx, level, fmt, ...)                                                           \
diff --git a/net/bpfilter/table.c b/net/bpfilter/table.c
new file mode 100644
index 000000000000..506ad3c9402f
--- /dev/null
+++ b/net/bpfilter/table.c
@@ -0,0 +1,339 @@
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
+static struct rule *table_find_rule_by_offset(struct table *table, uint32_t offset)
+{
+	const struct bpfilter_ipt_entry *key;
+
+	key = table->entries + offset;
+
+	return bsearch(key, table->rules, table->num_rules, sizeof(table->rules[0]),
+		       rule_offset_comparator);
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
+		if (!(table->valid_hooks & (1 << i)))
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
+		if (!(table->valid_hooks & (1 << i)))
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
+		if (table->valid_hooks & (1 << i))
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
+	snprintf(table->name, sizeof(table->name), "%s", ipt_replace->name);
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
+void table_get_info(const struct table *table, struct bpfilter_ipt_get_info *info)
+{
+	int i;
+
+	snprintf(info->name, sizeof(info->name), "%s", table->name);
+	info->valid_hooks = table->valid_hooks;
+
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		const struct rule *rule_front, *rule_last;
+
+		if (!(table->valid_hooks & (1 << i))) {
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
index 000000000000..0f5d653c4460
--- /dev/null
+++ b/net/bpfilter/table.h
@@ -0,0 +1,39 @@
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
+#include <search.h>
+#include <stdint.h>
+
+struct context;
+struct rule;
+
+struct table {
+	struct list_head list;
+	char name[BPFILTER_XT_TABLE_MAXNAMELEN];
+	uint32_t valid_hooks;
+	uint32_t num_rules;
+	uint32_t num_counters;
+	uint32_t size;
+	uint32_t hook_entry[BPFILTER_INET_HOOK_MAX];
+	uint32_t underflow[BPFILTER_INET_HOOK_MAX];
+	struct rule *rules;
+	void *entries;
+};
+
+struct table_index {
+	struct hsearch_data map;
+	struct list_head list;
+};
+
+struct table *create_table(struct context *ctx, const struct bpfilter_ipt_replace *ipt_replace);
+void table_get_info(const struct table *table, struct bpfilter_ipt_get_info *info);
+void free_table(struct table *table);
+
+#endif // NET_BPFILTER_TABLE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 27a1ddcb6dc9..267a96a4c8a6 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -21,7 +21,7 @@ BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
 BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
 
 BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c \
-	$(BPFILTERSRCDIR)/rule.c
+	$(BPFILTERSRCDIR)/rule.c $(BPFILTERSRCDIR)/table.c
 BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
 
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
-- 
2.25.1

