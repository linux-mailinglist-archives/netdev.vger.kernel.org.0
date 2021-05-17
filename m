Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB78F386D53
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344208AbhEQWz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344190AbhEQWzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:55:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C0AC061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:53 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id p7so4318686wru.10
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8AJ+jxD0mJxcb+pXTAGkhVM8Zb8FAm7HQ6ca/RFQITE=;
        b=Dx7cyi7+dmQb1L7F7l1HrllEOKYUbquCFFVzPGEeIoIaabD6k+kGZG9Xni53H021i9
         XfsLPwBam9ulhhH6/oaNz+SDONGeyfdhU7+Zt1LnjaYKunjeqAX8lKDtNEAmQ+fL2gSw
         P5/7raRuSv8Zx7YvbiR6slSVHkUq8xaPko26epOQcXiBnERa9072x2A6tFc1pZUiU88m
         UU8eC5dVjDLcaOa/6DTTvCXT8iPm4gjTybg8tp3xUWK1vh+MbQgcmDfJWBO3ThELTRYL
         A3Y2CnYqhtZT/+Oxxs+4GWSgEG96jpPZGFYr3BWeNCYzNPSrfKXc5GyzAzH5qwDpRBXH
         /xOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8AJ+jxD0mJxcb+pXTAGkhVM8Zb8FAm7HQ6ca/RFQITE=;
        b=jKT2y3xq0w/79x29rrYrNj1EVGdlRZSX8tQ45ZvA80FROGnPktl4iIVEhybZ9OARjr
         TtO/qBCKaZUKZGR1HOnuuQivqfEblfbl+4DdBASVzCUtls5thb4shmluw5pshmi2a1+w
         7rYvd3HliHXRZ6eU0oqtLMyAcplSc8bo+7Xbw0/aUTwxTA7ONnxztU2ouJ/g3kX6A+iX
         VaPo41zUH5aHt3ep9BsNaLjQCITqz4gb3l0E8avfLqxliF7+HgYRkQF8OHPxMps/ArOm
         JkPM78Iegr4H3pXKa78GDgHpOvQezz6W7kZFq1A8Jpva9LWkoqaD7B5Lbtt6wFxhCXHa
         krYQ==
X-Gm-Message-State: AOAM533XMhk7XH/aHA1MuKfgf8BYQNHVkDOC01KcaaXqeHusLNCKafl0
        0PsfF/dGYPQ6ecO+RyKvBeCTGQ==
X-Google-Smtp-Source: ABdhPJzzVEDlkKffEfvGF0HECbpkOKg7V4rjHT8AKdpmH/do3htHIGp86tF5FASizapoJEfXSmIqzQ==
X-Received: by 2002:a5d:4ed1:: with SMTP id s17mr2558698wrv.204.1621292032442;
        Mon, 17 May 2021 15:53:52 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id t17sm11853695wrp.89.2021.05.17.15.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:52 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 09/11] bpfilter: Add struct table
Date:   Tue, 18 May 2021 02:53:06 +0400
Message-Id: <20210517225308.720677-10-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A table keeps iptables' blob and an array of struct rule for this blob.
The array of rules provides more convenient way to interact with blob's
entries.

All tables are stored in table_ops_map map which is used for lookups.
Also all tables are linked into a list that is used for freeing them.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/context.c                        | 103 +++++++++++
 net/bpfilter/context.h                        |   3 +
 net/bpfilter/table-map.h                      |  41 +++++
 net/bpfilter/table.c                          | 167 ++++++++++++++++++
 net/bpfilter/table.h                          |  33 ++++
 tools/testing/selftests/bpf/bpfilter/Makefile |  10 +-
 7 files changed, 354 insertions(+), 5 deletions(-)
 create mode 100644 net/bpfilter/table-map.h
 create mode 100644 net/bpfilter/table.c
 create mode 100644 net/bpfilter/table.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 1191770d41f7..e0090563f2ca 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o rule.o
+bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o rule.o table.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
index a77134008540..5d9679212b25 100644
--- a/net/bpfilter/context.c
+++ b/net/bpfilter/context.c
@@ -10,7 +10,11 @@
 #include <linux/err.h>
 #include <linux/list.h>
 
+#include <stddef.h>
+
 #include "match.h"
+#include "rule.h"
+#include "table.h"
 #include "target.h"
 
 static int init_match_ops_map(struct context *ctx)
@@ -49,6 +53,86 @@ static int init_target_ops_map(struct context *ctx)
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
+static int init_table_map(struct context *ctx)
+{
+	struct table *table;
+	int err;
+
+	err = create_table_map(&ctx->table_map, 1);
+	if (err)
+		return err;
+
+	table = create_filter_table(ctx);
+	if (IS_ERR(table)) {
+		free_table_map(&ctx->table_map);
+		return PTR_ERR(table);
+	}
+
+	list_add_tail(&table->list, &ctx->table_list);
+
+	return table_map_insert(&ctx->table_map, table);
+}
+
 int create_context(struct context *ctx)
 {
 	int err;
@@ -63,11 +147,30 @@ int create_context(struct context *ctx)
 		return err;
 	}
 
+	INIT_LIST_HEAD(&ctx->table_list);
+
+	err = init_table_map(ctx);
+	if (err) {
+		free_match_ops_map(&ctx->match_ops_map);
+		free_target_ops_map(&ctx->target_ops_map);
+		return err;
+	}
+
 	return 0;
 }
 
 void free_context(struct context *ctx)
 {
+	struct list_head *t, *n;
+
+	list_for_each_safe(t, n, &ctx->table_list) {
+		struct table *table;
+
+		table = list_entry(t, struct table, list);
+		free_table(table);
+	}
+
+	free_table_map(&ctx->table_map);
 	free_target_ops_map(&ctx->target_ops_map);
 	free_match_ops_map(&ctx->match_ops_map);
 }
diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
index c62c1ba4781c..2d9e3fafb0f8 100644
--- a/net/bpfilter/context.h
+++ b/net/bpfilter/context.h
@@ -10,12 +10,15 @@
 
 #include "match-ops-map.h"
 #include "target-ops-map.h"
+#include "table-map.h"
 
 struct context {
 	FILE *log_file;
 	int log_level;
 	struct match_ops_map match_ops_map;
 	struct target_ops_map target_ops_map;
+	struct table_map table_map;
+	struct list_head table_list;
 };
 
 int create_context(struct context *ctx);
diff --git a/net/bpfilter/table-map.h b/net/bpfilter/table-map.h
new file mode 100644
index 000000000000..6c5340e88542
--- /dev/null
+++ b/net/bpfilter/table-map.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_TABLE_MAP_H
+#define NET_BPFILTER_TABLE_MAP_H
+
+#include "map-common.h"
+#include "table.h"
+
+struct table_map {
+	struct hsearch_data index;
+};
+
+static inline int create_table_map(struct table_map *map, size_t nelem)
+{
+	return create_map(&map->index, nelem);
+}
+
+static inline struct table *table_map_find(struct table_map *map, const char *name)
+{
+	return map_find(&map->index, name);
+}
+
+static inline int table_map_update(struct table_map *map, const char *name, void *data)
+{
+	return map_update(&map->index, name, data);
+}
+
+static inline int table_map_insert(struct table_map *map, struct table *table)
+{
+	return map_insert(&map->index, table->name, table);
+}
+
+static inline void free_table_map(struct table_map *map)
+{
+	free_map(&map->index);
+}
+
+#endif // NET_BPFILTER_TABLE_MAP_H
diff --git a/net/bpfilter/table.c b/net/bpfilter/table.c
new file mode 100644
index 000000000000..e8be6369ef71
--- /dev/null
+++ b/net/bpfilter/table.c
@@ -0,0 +1,167 @@
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
+#include "table-map.h"
+
+static int rule_offset_comparator(const void *x, const void *y)
+{
+	const struct rule *rule = y;
+	const uint32_t *offset = x;
+
+	return *offset < rule->offset ? -1 : *offset - rule->offset;
+}
+
+static struct rule *table_get_rule_by_offset(struct table *table, uint32_t offset)
+{
+	return bsearch(&offset, table->rules, table->num_rules, sizeof(table->rules[0]),
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
+		if (table->size < offset + ipt_entry->next_offset)
+			return -EINVAL;
+
+		err = init_rule(ctx, ipt_entry, &table->rules[i]);
+		if (err)
+			return err;
+
+		table->rules[i].offset = offset;
+		offset += ipt_entry->next_offset;
+	}
+
+	if (offset != ipt_replace->size)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int table_init_hooks(struct table *table, const struct bpfilter_ipt_replace *ipt_replace)
+{
+	int i;
+
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		if (!(table->valid_hooks & (1 << i)))
+			continue;
+
+		table->hook_entry[i] = table_get_rule_by_offset(table, ipt_replace->hook_entry[i]);
+		table->underflow[i] = table_get_rule_by_offset(table, ipt_replace->underflow[i]);
+
+		if (!table->hook_entry[i] || !table->underflow[i])
+			return -EINVAL;
+	}
+
+	return 0;
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
+	for (i = 0; i < BPFILTER_INET_HOOK_MAX; ++i) {
+		const struct rule *hook_entry = table->hook_entry[i];
+		const struct rule *underflow = table->underflow[i];
+
+		info->hook_entry[i] = hook_entry ? hook_entry->offset : 0;
+		info->underflow[i] = underflow ? underflow->offset : 0;
+	}
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
index 000000000000..101f6d813c8c
--- /dev/null
+++ b/net/bpfilter/table.h
@@ -0,0 +1,33 @@
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
+	struct rule *hook_entry[BPFILTER_INET_HOOK_MAX];
+	struct rule *underflow[BPFILTER_INET_HOOK_MAX];
+	struct rule *rules;
+	void *entries;
+};
+
+struct table *create_table(struct context *ctx, const struct bpfilter_ipt_replace *ipt_replace);
+void table_get_info(const struct table *table, struct bpfilter_ipt_get_info *info);
+void free_table(struct table *table);
+
+#endif // NET_BPFILTER_TABLE_H
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
index 02d860e02c58..131174dd2bdf 100644
--- a/tools/testing/selftests/bpf/bpfilter/Makefile
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -21,9 +21,11 @@ include ../../lib.mk
 $(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
 $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
 $(OUTPUT)/test_match: test_match.c $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/map-common.c \
-	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/target.c
-$(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/map-common.c \
-	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/match.c
+	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/target.c 		\
+	$(BPFILTERSRCDIR)/table.c $(BPFILTERSRCDIR)/rule.c
+$(OUTPUT)/test_target: test_target.c $(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/map-common.c 	\
+	$(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/bflog.c $(BPFILTERSRCDIR)/match.c				\
+	$(BPFILTERSRCDIR)/table.c $(BPFILTERSRCDIR)/rule.c
 $(OUTPUT)/test_rule: test_rule.c $(BPFILTERSRCDIR)/rule.c $(BPFILTERSRCDIR)/bflog.c 		\
 	$(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c $(BPFILTERSRCDIR)/match.c	\
-	$(BPFILTERSRCDIR)/target.c
+	$(BPFILTERSRCDIR)/target.c $(BPFILTERSRCDIR)/table.c $(BPFILTERSRCDIR)/rule.c
-- 
2.25.1

