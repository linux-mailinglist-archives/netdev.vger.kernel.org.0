Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E69437BBA
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233674AbhJVRTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhJVRTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:19:14 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B623C061767
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:56 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 193-20020a1c01ca000000b00327775075f7so4129015wmb.5
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HTHo6ZbXBFvF2A/wD9Er2v7eFpQ0QuPWVWjrIjNpQJM=;
        b=pQR8nPaiD603ypyXFEdndsOwslaIJkVJeIu8q96WF2wV66J0kePcuioicP/wXq+jis
         ilAHXsubgiXmIeNW/5m1hoV0T5FiQFsX7FAt/uk4jzp2cj1vilh3/oVlfUIo45e5pN9O
         bwqTQ/1PUfvB7jns+rDA9UBWDRrMX+/Q4s0KRGMIKpet5O2J7ITpdNtc2E7rtdEgYJ4p
         MQHGpyTRgPdw6oKX273HosQpjpslUDJY7tM5sZL0ZMTSRCmjDZyg3zUOQQ8XvNqQAew5
         bW6qVU9XwrbSfxQIEshhfOCrlhgD+eICB1d+gm/pMbONRrhYTIINWrbLkzPM5cALOXfd
         aFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HTHo6ZbXBFvF2A/wD9Er2v7eFpQ0QuPWVWjrIjNpQJM=;
        b=PYHL8BLKg58Q9u8aC+PTBNhagqoIPp0uE7ZvR69RqAu+BGZvBupbAlCHaroH095QDq
         67e2m/8fBH02rmAFQtNaWUiV6LoSpU4XB/0lE281cd/dbQsxSGUXwJMsZEHtHR3Azuh7
         6vV0KPR+Lbj246XS5icLDJhnFQAivOJxkOJ5FxWWmp9/Q/fMpx6Vg79l7VSIKJcHR5B1
         +87rwpoW+GRKxdxI8FP1fmYcwXuV7+EvJeiSBWf74NmF140mtcjoBq89zhbVAoEnpwxv
         eDlxFScE3CU0Hd5lhEbdk/KLtUJSuZZt0Tm6pCRvt/xwQ5n/TeD9GziyCCAuqsiNtRGV
         yHzQ==
X-Gm-Message-State: AOAM533fptNr+R0v2MEkTMXwA75kLZeaGqWVa88UQNFj2kyBBSDuHojc
        dRsK/JPWCbZLtFAZBLEvQXz+vg==
X-Google-Smtp-Source: ABdhPJynttB+Uf1xYvfmvBCaJoT1eWRxydXXnm/YlhKVld5sbYZlTnPF9ZYMjAPZXGo+cBR2o0Jt3Q==
X-Received: by 2002:a05:600c:3511:: with SMTP id h17mr29891892wmq.144.1634923014886;
        Fri, 22 Oct 2021 10:16:54 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id 6sm4427367wma.48.2021.10.22.10.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:16:54 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 5/5] bpftool: Switch to libbpf's hashmap for PIDs/names references
Date:   Fri, 22 Oct 2021 18:16:47 +0100
Message-Id: <20211022171647.27885-6-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022171647.27885-1-quentin@isovalent.com>
References: <20211022171647.27885-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to show PIDs and names for processes holding references to BPF
programs, maps, links, or BTF objects, bpftool creates hash maps to
store all relevant information. This commit is part of a set that
transitions from the kernel's hash map implementation to the one coming
with libbpf.

The motivation is to make bpftool less dependent of kernel headers, to
ease the path to a potential out-of-tree mirror, like libbpf has.

This is the third and final step of the transition, in which we convert
the hash maps used for storing the information about the processes
holding references to BPF objects (programs, maps, links, BTF), and at
last we drop the inclusion of tools/include/linux/hashtable.h.

Note: Checkpatch complains about the use of __weak declarations, and the
missing empty lines after the bunch of empty function declarations when
compiling without the BPF skeletons (none of these were introduced in
this patch). We want to keep things as they are, and the reports should
be safe to ignore.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf.c  |  7 ++--
 tools/bpf/bpftool/link.c |  6 +--
 tools/bpf/bpftool/main.c |  5 ++-
 tools/bpf/bpftool/main.h | 17 +++-----
 tools/bpf/bpftool/map.c  |  6 +--
 tools/bpf/bpftool/pids.c | 84 ++++++++++++++++++++++------------------
 tools/bpf/bpftool/prog.c |  6 +--
 7 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 84959aa05265..2a07b460d728 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -9,7 +9,6 @@
 #include <string.h>
 #include <unistd.h>
 #include <linux/btf.h>
-#include <linux/hashtable.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -790,7 +789,7 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
 		printf("%s%u", n++ == 0 ? "  map_ids " : ",",
 		       hash_field_as_u32(entry->value));
 
-	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
+	emit_obj_refs_plain(refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
 }
@@ -821,7 +820,7 @@ show_btf_json(struct bpf_btf_info *info, int fd,
 		jsonw_uint(json_wtr, hash_field_as_u32(entry->value));
 	jsonw_end_array(json_wtr);	/* map_ids */
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr); /* pids */
+	emit_obj_refs_json(refs_table, info->id, json_wtr); /* pids */
 
 	jsonw_bool_field(json_wtr, "kernel", info->kernel_btf);
 
@@ -950,7 +949,7 @@ static int do_show(int argc, char **argv)
 exit_free:
 	hashmap__free(btf_prog_table);
 	hashmap__free(btf_map_table);
-	delete_obj_refs_table(&refs_table);
+	delete_obj_refs_table(refs_table);
 
 	return err;
 }
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index be802e6ccc53..00cb8aea6eec 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -170,7 +170,7 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(refs_table, info->id, json_wtr);
 
 	jsonw_end_object(json_wtr);
 
@@ -253,7 +253,7 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 					    u32_as_hash_field(info->id))
 			printf("\n\tpinned %s", (char *)entry->value);
 	}
-	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
+	emit_obj_refs_plain(refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
 
@@ -351,7 +351,7 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-	delete_obj_refs_table(&refs_table);
+	delete_obj_refs_table(refs_table);
 
 	return errno == ENOENT ? 0 : -1;
 }
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 7a33f0e6da28..28237d7cef67 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -10,8 +10,9 @@
 #include <string.h>
 
 #include <bpf/bpf.h>
-#include <bpf/libbpf.h>
 #include <bpf/btf.h>
+#include <bpf/hashmap.h>
+#include <bpf/libbpf.h>
 
 #include "main.h"
 
@@ -31,7 +32,7 @@ bool verifier_logs;
 bool relaxed_maps;
 bool use_loader;
 struct btf *base_btf;
-struct obj_refs_table refs_table;
+struct hashmap *refs_table;
 
 static void __noreturn clean_and_exit(int i)
 {
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index a8e71ead848c..0344afd1dbbd 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -11,7 +11,6 @@
 #include <linux/bpf.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
-#include <linux/hashtable.h>
 #include <tools/libc_compat.h>
 
 #include <bpf/hashmap.h>
@@ -92,7 +91,7 @@ extern bool verifier_logs;
 extern bool relaxed_maps;
 extern bool use_loader;
 extern struct btf *base_btf;
-extern struct obj_refs_table refs_table;
+extern struct hashmap *refs_table;
 
 void __printf(1, 2) p_err(const char *fmt, ...);
 void __printf(1, 2) p_info(const char *fmt, ...);
@@ -106,18 +105,12 @@ void set_max_rlimit(void);
 
 int mount_tracefs(const char *target);
 
-struct obj_refs_table {
-	DECLARE_HASHTABLE(table, 16);
-};
-
 struct obj_ref {
 	int pid;
 	char comm[16];
 };
 
 struct obj_refs {
-	struct hlist_node node;
-	__u32 id;
 	int ref_cnt;
 	struct obj_ref *refs;
 };
@@ -128,12 +121,12 @@ struct bpf_line_info;
 int build_pinned_obj_table(struct hashmap *table,
 			   enum bpf_obj_type type);
 void delete_pinned_obj_table(struct hashmap *table);
-__weak int build_obj_refs_table(struct obj_refs_table *table,
+__weak int build_obj_refs_table(struct hashmap **table,
 				enum bpf_obj_type type);
-__weak void delete_obj_refs_table(struct obj_refs_table *table);
-__weak void emit_obj_refs_json(struct obj_refs_table *table, __u32 id,
+__weak void delete_obj_refs_table(struct hashmap *table);
+__weak void emit_obj_refs_json(struct hashmap *table, __u32 id,
 			       json_writer_t *json_wtr);
-__weak void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id,
+__weak void emit_obj_refs_plain(struct hashmap *table, __u32 id,
 				const char *prefix);
 void print_dev_plain(__u32 ifindex, __u64 ns_dev, __u64 ns_inode);
 void print_dev_json(__u32 ifindex, __u64 ns_dev, __u64 ns_inode);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index a2c19324efa7..3479639664d0 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -549,7 +549,7 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(refs_table, info->id, json_wtr);
 
 	jsonw_end_object(json_wtr);
 
@@ -637,7 +637,7 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	if (frozen)
 		printf("%sfrozen", info->btf_id ? "  " : "");
 
-	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
+	emit_obj_refs_plain(refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
 	return 0;
@@ -747,7 +747,7 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-	delete_obj_refs_table(&refs_table);
+	delete_obj_refs_table(refs_table);
 
 	if (show_pinned)
 		delete_pinned_obj_table(map_table);
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 477e55d59c34..02fea61243c8 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -6,35 +6,37 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+
 #include <bpf/bpf.h>
+#include <bpf/hashmap.h>
 
 #include "main.h"
 #include "skeleton/pid_iter.h"
 
 #ifdef BPFTOOL_WITHOUT_SKELETONS
 
-int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
+int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 {
 	return -ENOTSUP;
 }
-void delete_obj_refs_table(struct obj_refs_table *table) {}
-void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix) {}
-void emit_obj_refs_json(struct obj_refs_table *table, __u32 id, json_writer_t *json_writer) {}
+void delete_obj_refs_table(struct hashmap *map) {}
+void emit_obj_refs_plain(struct hashmap *map, __u32 id, const char *prefix) {}
+void emit_obj_refs_json(struct hashmap *map, __u32 id, json_writer_t *json_writer) {}
 
 #else /* BPFTOOL_WITHOUT_SKELETONS */
 
 #include "pid_iter.skel.h"
 
-static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
+static void add_ref(struct hashmap *map, struct pid_iter_entry *e)
 {
+	struct hashmap_entry *entry;
 	struct obj_refs *refs;
 	struct obj_ref *ref;
 	void *tmp;
 	int i;
 
-	hash_for_each_possible(table->table, refs, node, e->id) {
-		if (refs->id != e->id)
-			continue;
+	hashmap__for_each_key_entry(map, entry, u32_as_hash_field(e->id)) {
+		refs = entry->value;
 
 		for (i = 0; i < refs->ref_cnt; i++) {
 			if (refs->refs[i].pid == e->pid)
@@ -64,7 +66,6 @@ static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
 		return;
 	}
 
-	refs->id = e->id;
 	refs->refs = malloc(sizeof(*refs->refs));
 	if (!refs->refs) {
 		free(refs);
@@ -76,7 +77,7 @@ static void add_ref(struct obj_refs_table *table, struct pid_iter_entry *e)
 	ref->pid = e->pid;
 	memcpy(ref->comm, e->comm, sizeof(ref->comm));
 	refs->ref_cnt = 1;
-	hash_add(table->table, &refs->node, e->id);
+	hashmap__append(map, u32_as_hash_field(e->id), refs);
 }
 
 static int __printf(2, 0)
@@ -87,7 +88,7 @@ libbpf_print_none(__maybe_unused enum libbpf_print_level level,
 	return 0;
 }
 
-int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
+int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 {
 	struct pid_iter_entry *e;
 	char buf[4096 / sizeof(*e) * sizeof(*e)];
@@ -95,7 +96,11 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 	int err, ret, fd = -1, i;
 	libbpf_print_fn_t default_print;
 
-	hash_init(table->table);
+	*map = hashmap__new(bpftool_hash_fn, bpftool_equal_fn, NULL);
+	if (!*map) {
+		p_err("failed to create hashmap for PID references");
+		return -1;
+	}
 	set_max_rlimit();
 
 	skel = pid_iter_bpf__open();
@@ -151,7 +156,7 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 
 		e = (void *)buf;
 		for (i = 0; i < ret; i++, e++) {
-			add_ref(table, e);
+			add_ref(*map, e);
 		}
 	}
 	err = 0;
@@ -162,39 +167,44 @@ int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
 	return err;
 }
 
-void delete_obj_refs_table(struct obj_refs_table *table)
+void delete_obj_refs_table(struct hashmap *map)
 {
-	struct obj_refs *refs;
-	struct hlist_node *tmp;
-	unsigned int bkt;
+	struct hashmap_entry *entry;
+	size_t bkt;
+
+	if (!map)
+		return;
+
+	hashmap__for_each_entry(map, entry, bkt) {
+		struct obj_refs *refs = entry->value;
 
-	hash_for_each_safe(table->table, bkt, tmp, refs, node) {
-		hash_del(&refs->node);
 		free(refs->refs);
 		free(refs);
 	}
+
+	hashmap__free(map);
 }
 
-void emit_obj_refs_json(struct obj_refs_table *table, __u32 id,
+void emit_obj_refs_json(struct hashmap *map, __u32 id,
 			json_writer_t *json_writer)
 {
-	struct obj_refs *refs;
-	struct obj_ref *ref;
-	int i;
+	struct hashmap_entry *entry;
 
-	if (hash_empty(table->table))
+	if (hashmap__empty(map))
 		return;
 
-	hash_for_each_possible(table->table, refs, node, id) {
-		if (refs->id != id)
-			continue;
+	hashmap__for_each_key_entry(map, entry, u32_as_hash_field(id)) {
+		struct obj_refs *refs = entry->value;
+		int i;
+
 		if (refs->ref_cnt == 0)
 			break;
 
 		jsonw_name(json_writer, "pids");
 		jsonw_start_array(json_writer);
 		for (i = 0; i < refs->ref_cnt; i++) {
-			ref = &refs->refs[i];
+			struct obj_ref *ref = &refs->refs[i];
+
 			jsonw_start_object(json_writer);
 			jsonw_int_field(json_writer, "pid", ref->pid);
 			jsonw_string_field(json_writer, "comm", ref->comm);
@@ -205,24 +215,24 @@ void emit_obj_refs_json(struct obj_refs_table *table, __u32 id,
 	}
 }
 
-void emit_obj_refs_plain(struct obj_refs_table *table, __u32 id, const char *prefix)
+void emit_obj_refs_plain(struct hashmap *map, __u32 id, const char *prefix)
 {
-	struct obj_refs *refs;
-	struct obj_ref *ref;
-	int i;
+	struct hashmap_entry *entry;
 
-	if (hash_empty(table->table))
+	if (hashmap__empty(map))
 		return;
 
-	hash_for_each_possible(table->table, refs, node, id) {
-		if (refs->id != id)
-			continue;
+	hashmap__for_each_key_entry(map, entry, u32_as_hash_field(id)) {
+		struct obj_refs *refs = entry->value;
+		int i;
+
 		if (refs->ref_cnt == 0)
 			break;
 
 		printf("%s", prefix);
 		for (i = 0; i < refs->ref_cnt; i++) {
-			ref = &refs->refs[i];
+			struct obj_ref *ref = &refs->refs[i];
+
 			printf("%s%s(%d)", i == 0 ? "" : ", ", ref->comm, ref->pid);
 		}
 		break;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 20026b4178b0..11a250f60cd5 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -428,7 +428,7 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 		jsonw_end_array(json_wtr);
 	}
 
-	emit_obj_refs_json(&refs_table, info->id, json_wtr);
+	emit_obj_refs_json(refs_table, info->id, json_wtr);
 
 	show_prog_metadata(fd, info->nr_map_ids);
 
@@ -499,7 +499,7 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	if (info->btf_id)
 		printf("\n\tbtf_id %d", info->btf_id);
 
-	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
+	emit_obj_refs_plain(refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
 
@@ -616,7 +616,7 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
-	delete_obj_refs_table(&refs_table);
+	delete_obj_refs_table(refs_table);
 
 	if (show_pinned)
 		delete_pinned_obj_table(prog_table);
-- 
2.30.2

