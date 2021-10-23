Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6170A43856F
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 22:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhJWUy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Oct 2021 16:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhJWUy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Oct 2021 16:54:27 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D55C061224
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:52:04 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v17so3357285wrv.9
        for <netdev@vger.kernel.org>; Sat, 23 Oct 2021 13:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnsaoE1e74DLOSAtR3sU8+tx3L1vl2315dJJbbFqhwA=;
        b=xk1sp6FCgFAnCZkSENGff/VbflX4iTBSz2KUmXUhJCUDyUVRfwgIrMPLBv7EmXZPjO
         chbHeTGOpixKlIRopb7I35yB7OgEDfJGu42cRdHblcbM8E7FChRFyhNhKVr/bMLI0PFR
         +lQem7iLZ+l9taKeuA4DgHACbG6bbhRs8tL0v+nX7wI4fvwIr2Nr2vMkTw5xG9RkmtCZ
         zw8qV4tZNs3/1ORhfNQ4f4hmRhv3ip9k4fHghGz3gkpZzXEebv/mQzHDl+vBws5mbNiJ
         zcNQ1QcLAN1Fupoc7y+skKe16Bx4+I+/KyX7WOpwXOBa70JfTIIsVGLREYmG1SQ2niAJ
         ciKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnsaoE1e74DLOSAtR3sU8+tx3L1vl2315dJJbbFqhwA=;
        b=iqSYt+NWGPdiuq8nsP1S/7jZwNeZT+ORCffyeMxK5au8Y2YbqCmbuwW9viVuwNRsme
         5vsAnZM0GRc0NKvYzV4dLgCEZtO9h05ct+8rhowehxKSXlcoA3AX8MFjGU+nTz2YhBwZ
         bWmWuUNzxrpzB/iPU1afSdxoY3jUzh1cCy2XGYKSD3iyys5Ycf7dWg+I3tMmmHIt+Lw3
         E7cc9K8AcW+tsuAeP4LflLyuYCd4kDGQm635Pd0XNt0/gbr3NnG042AL6h4ur8DVeitD
         Pb4fwUSzz59W1kfrw52yko9TL60kjjaL3TRWKqEs7k7HzTZVJOkMB/DZHKRHl6qzdgM9
         +BEQ==
X-Gm-Message-State: AOAM5309QZB1D3oZem3KrHDlObpUVEYMqxLNGOw2x5G2AOPYO+XPQaoA
        p7RU9KU+OGBSAmuwGeYzZ5tdQg==
X-Google-Smtp-Source: ABdhPJy8zfqQ9Kcn1jlxAOcN8Jp5M1mwAfrL6QI3aDVgXlEDmmdWlPojEETFIIV82GeNBlEy7nBoPg==
X-Received: by 2002:a05:6000:2a1:: with SMTP id l1mr10366862wry.87.1635022323449;
        Sat, 23 Oct 2021 13:52:03 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id u16sm13555398wmc.21.2021.10.23.13.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 13:52:03 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 3/5] bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
Date:   Sat, 23 Oct 2021 21:51:52 +0100
Message-Id: <20211023205154.6710-4-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211023205154.6710-1-quentin@isovalent.com>
References: <20211023205154.6710-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to show pinned paths for BPF programs, maps, or links when
listing them with the "-f" option, bpftool creates hash maps to store
all relevant paths under the bpffs. So far, it would rely on the
kernel implementation (from tools/include/linux/hashtable.h).

We can make bpftool rely on libbpf's implementation instead. The
motivation is to make bpftool less dependent of kernel headers, to ease
the path to a potential out-of-tree mirror, like libbpf has.

This commit is the first step of the conversion: the hash maps for
pinned paths for programs, maps, and links are converted to libbpf's
hashmap.{c,h}. Other hash maps used for the PIDs of process holding
references to BPF objects are left unchanged for now. On the build side,
this requires adding a dependency to a second header internal to libbpf,
and making it a dependency for the bootstrap bpftool version as well.
The rest of the changes are a rather straightforward conversion.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Makefile |  8 +++---
 tools/bpf/bpftool/common.c | 50 +++++++++++++++++++++++---------------
 tools/bpf/bpftool/link.c   | 36 +++++++++++++++------------
 tools/bpf/bpftool/main.h   | 29 +++++++++++++---------
 tools/bpf/bpftool/map.c    | 36 +++++++++++++++------------
 tools/bpf/bpftool/prog.c   | 36 +++++++++++++++------------
 6 files changed, 111 insertions(+), 84 deletions(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index 939b0fca5fb9..c0c30e56988f 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -31,9 +31,9 @@ LIBBPF = $(LIBBPF_OUTPUT)libbpf.a
 LIBBPF_BOOTSTRAP_OUTPUT = $(BOOTSTRAP_OUTPUT)libbpf/
 LIBBPF_BOOTSTRAP = $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
 
-# We need to copy nlattr.h which is not otherwise exported by libbpf, but still
-# required by bpftool.
-LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,nlattr.h)
+# We need to copy hashmap.h and nlattr.h which is not otherwise exported by
+# libbpf, but still required by bpftool.
+LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
 
 ifeq ($(BPFTOOL_VERSION),)
 BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
@@ -209,7 +209,7 @@ $(BPFTOOL_BOOTSTRAP): $(BOOTSTRAP_OBJS) $(LIBBPF_BOOTSTRAP)
 $(OUTPUT)bpftool: $(OBJS) $(LIBBPF)
 	$(QUIET_LINK)$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)
 
-$(BOOTSTRAP_OUTPUT)%.o: %.c | $(BOOTSTRAP_OUTPUT)
+$(BOOTSTRAP_OUTPUT)%.o: %.c $(LIBBPF_INTERNAL_HDRS) | $(BOOTSTRAP_OUTPUT)
 	$(QUIET_CC)$(HOSTCC) $(CFLAGS) -c -MMD -o $@ $<
 
 $(OUTPUT)%.o: %.c
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index d42d930a3ec4..511eccdbdfe6 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -22,6 +22,7 @@
 #include <sys/vfs.h>
 
 #include <bpf/bpf.h>
+#include <bpf/hashmap.h>
 #include <bpf/libbpf.h> /* libbpf_num_possible_cpus */
 
 #include "main.h"
@@ -393,7 +394,7 @@ void print_hex_data_json(uint8_t *data, size_t len)
 }
 
 /* extra params for nftw cb */
-static struct pinned_obj_table *build_fn_table;
+static struct hashmap *build_fn_table;
 static enum bpf_obj_type build_fn_type;
 
 static int do_build_table_cb(const char *fpath, const struct stat *sb,
@@ -401,9 +402,9 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 {
 	struct bpf_prog_info pinned_info;
 	__u32 len = sizeof(pinned_info);
-	struct pinned_obj *obj_node;
 	enum bpf_obj_type objtype;
 	int fd, err = 0;
+	char *path;
 
 	if (typeflag != FTW_F)
 		goto out_ret;
@@ -420,28 +421,26 @@ static int do_build_table_cb(const char *fpath, const struct stat *sb,
 	if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len))
 		goto out_close;
 
-	obj_node = calloc(1, sizeof(*obj_node));
-	if (!obj_node) {
+	path = strdup(fpath);
+	if (!path) {
 		err = -1;
 		goto out_close;
 	}
 
-	obj_node->id = pinned_info.id;
-	obj_node->path = strdup(fpath);
-	if (!obj_node->path) {
-		err = -1;
-		free(obj_node);
+	err = hashmap__append(build_fn_table, u32_as_hash_field(pinned_info.id), path);
+	if (err) {
+		p_err("failed to append entry to hashmap for ID %u, path '%s': %s",
+		      pinned_info.id, path, strerror(errno));
 		goto out_close;
 	}
 
-	hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
 out_close:
 	close(fd);
 out_ret:
 	return err;
 }
 
-int build_pinned_obj_table(struct pinned_obj_table *tab,
+int build_pinned_obj_table(struct hashmap *tab,
 			   enum bpf_obj_type type)
 {
 	struct mntent *mntent = NULL;
@@ -470,17 +469,18 @@ int build_pinned_obj_table(struct pinned_obj_table *tab,
 	return err;
 }
 
-void delete_pinned_obj_table(struct pinned_obj_table *tab)
+void delete_pinned_obj_table(struct hashmap *map)
 {
-	struct pinned_obj *obj;
-	struct hlist_node *tmp;
-	unsigned int bkt;
+	struct hashmap_entry *entry;
+	size_t bkt;
 
-	hash_for_each_safe(tab->table, bkt, tmp, obj, hash) {
-		hash_del(&obj->hash);
-		free(obj->path);
-		free(obj);
-	}
+	if (!map)
+		return;
+
+	hashmap__for_each_entry(map, entry, bkt)
+		free(entry->value);
+
+	hashmap__free(map);
 }
 
 unsigned int get_page_size(void)
@@ -962,3 +962,13 @@ int map_parse_fd_and_info(int *argc, char ***argv, void *info, __u32 *info_len)
 
 	return fd;
 }
+
+size_t hash_fn_for_key_as_id(const void *key, void *ctx)
+{
+	return (size_t)key;
+}
+
+bool equal_fn_for_key_as_id(const void *k1, const void *k2, void *ctx)
+{
+	return k1 == k2;
+}
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index a5effb1816b7..404cc5459c6b 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -7,6 +7,7 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
+#include <bpf/hashmap.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -20,7 +21,7 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_NETNS]			= "netns",
 };
 
-static struct pinned_obj_table link_table;
+static struct hashmap *link_table;
 
 static int link_parse_fd(int *argc, char ***argv)
 {
@@ -158,15 +159,14 @@ static int show_link_close_json(int fd, struct bpf_link_info *info)
 		break;
 	}
 
-	if (!hash_empty(link_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(link_table)) {
+		struct hashmap_entry *entry;
 
 		jsonw_name(json_wtr, "pinned");
 		jsonw_start_array(json_wtr);
-		hash_for_each_possible(link_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				jsonw_string(json_wtr, obj->path);
-		}
+		hashmap__for_each_key_entry(link_table, entry,
+					    u32_as_hash_field(info->id))
+			jsonw_string(json_wtr, entry->value);
 		jsonw_end_array(json_wtr);
 	}
 
@@ -246,13 +246,12 @@ static int show_link_close_plain(int fd, struct bpf_link_info *info)
 		break;
 	}
 
-	if (!hash_empty(link_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(link_table)) {
+		struct hashmap_entry *entry;
 
-		hash_for_each_possible(link_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				printf("\n\tpinned %s", obj->path);
-		}
+		hashmap__for_each_key_entry(link_table, entry,
+					    u32_as_hash_field(info->id))
+			printf("\n\tpinned %s", (char *)entry->value);
 	}
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
@@ -305,8 +304,13 @@ static int do_show(int argc, char **argv)
 	int err, fd;
 
 	if (show_pinned) {
-		hash_init(link_table.table);
-		build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
+		link_table = hashmap__new(hash_fn_for_key_as_id,
+					  equal_fn_for_key_as_id, NULL);
+		if (!link_table) {
+			p_err("failed to create hashmap for pinned paths");
+			return -1;
+		}
+		build_pinned_obj_table(link_table, BPF_OBJ_LINK);
 	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_LINK);
 
@@ -351,7 +355,7 @@ static int do_show(int argc, char **argv)
 	delete_obj_refs_table(&refs_table);
 
 	if (show_pinned)
-		delete_pinned_obj_table(&link_table);
+		delete_pinned_obj_table(link_table);
 
 	return errno == ENOENT ? 0 : -1;
 }
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index baf607cd5924..0d64e39573f2 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -14,6 +14,7 @@
 #include <linux/hashtable.h>
 #include <tools/libc_compat.h>
 
+#include <bpf/hashmap.h>
 #include <bpf/libbpf.h>
 
 #include "json_writer.h"
@@ -105,16 +106,6 @@ void set_max_rlimit(void);
 
 int mount_tracefs(const char *target);
 
-struct pinned_obj_table {
-	DECLARE_HASHTABLE(table, 16);
-};
-
-struct pinned_obj {
-	__u32 id;
-	char *path;
-	struct hlist_node hash;
-};
-
 struct obj_refs_table {
 	DECLARE_HASHTABLE(table, 16);
 };
@@ -134,9 +125,9 @@ struct obj_refs {
 struct btf;
 struct bpf_line_info;
 
-int build_pinned_obj_table(struct pinned_obj_table *table,
+int build_pinned_obj_table(struct hashmap *table,
 			   enum bpf_obj_type type);
-void delete_pinned_obj_table(struct pinned_obj_table *tab);
+void delete_pinned_obj_table(struct hashmap *table);
 __weak int build_obj_refs_table(struct obj_refs_table *table,
 				enum bpf_obj_type type);
 __weak void delete_obj_refs_table(struct obj_refs_table *table);
@@ -256,4 +247,18 @@ int do_filter_dump(struct tcmsg *ifinfo, struct nlattr **tb, const char *kind,
 
 int print_all_levels(__maybe_unused enum libbpf_print_level level,
 		     const char *format, va_list args);
+
+size_t hash_fn_for_key_as_id(const void *key, void *ctx);
+bool equal_fn_for_key_as_id(const void *k1, const void *k2, void *ctx);
+
+static inline void *u32_as_hash_field(__u32 x)
+{
+	return (void *)(uintptr_t)x;
+}
+
+static inline bool hashmap__empty(struct hashmap *map)
+{
+	return map ? hashmap__size(map) == 0 : true;
+}
+
 #endif
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 0085039d9610..2647603c5e5d 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -17,6 +17,7 @@
 
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+#include <bpf/hashmap.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -56,7 +57,7 @@ const char * const map_type_name[] = {
 
 const size_t map_type_name_size = ARRAY_SIZE(map_type_name);
 
-static struct pinned_obj_table map_table;
+static struct hashmap *map_table;
 
 static bool map_is_per_cpu(__u32 type)
 {
@@ -537,15 +538,14 @@ static int show_map_close_json(int fd, struct bpf_map_info *info)
 	if (info->btf_id)
 		jsonw_int_field(json_wtr, "btf_id", info->btf_id);
 
-	if (!hash_empty(map_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(map_table)) {
+		struct hashmap_entry *entry;
 
 		jsonw_name(json_wtr, "pinned");
 		jsonw_start_array(json_wtr);
-		hash_for_each_possible(map_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				jsonw_string(json_wtr, obj->path);
-		}
+		hashmap__for_each_key_entry(map_table, entry,
+					    u32_as_hash_field(info->id))
+			jsonw_string(json_wtr, entry->value);
 		jsonw_end_array(json_wtr);
 	}
 
@@ -612,13 +612,12 @@ static int show_map_close_plain(int fd, struct bpf_map_info *info)
 	}
 	close(fd);
 
-	if (!hash_empty(map_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(map_table)) {
+		struct hashmap_entry *entry;
 
-		hash_for_each_possible(map_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				printf("\n\tpinned %s", obj->path);
-		}
+		hashmap__for_each_key_entry(map_table, entry,
+					    u32_as_hash_field(info->id))
+			printf("\n\tpinned %s", (char *)entry->value);
 	}
 	printf("\n");
 
@@ -697,8 +696,13 @@ static int do_show(int argc, char **argv)
 	int fd;
 
 	if (show_pinned) {
-		hash_init(map_table.table);
-		build_pinned_obj_table(&map_table, BPF_OBJ_MAP);
+		map_table = hashmap__new(hash_fn_for_key_as_id,
+					 equal_fn_for_key_as_id, NULL);
+		if (!map_table) {
+			p_err("failed to create hashmap for pinned paths");
+			return -1;
+		}
+		build_pinned_obj_table(map_table, BPF_OBJ_MAP);
 	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_MAP);
 
@@ -747,7 +751,7 @@ static int do_show(int argc, char **argv)
 	delete_obj_refs_table(&refs_table);
 
 	if (show_pinned)
-		delete_pinned_obj_table(&map_table);
+		delete_pinned_obj_table(map_table);
 
 	return errno == ENOENT ? 0 : -1;
 }
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 48c2fa4d068e..8fce78ce6f8b 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -24,6 +24,7 @@
 
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+#include <bpf/hashmap.h>
 #include <bpf/libbpf.h>
 #include <bpf/skel_internal.h>
 
@@ -84,7 +85,7 @@ static const char * const attach_type_strings[] = {
 	[__MAX_BPF_ATTACH_TYPE] = NULL,
 };
 
-static struct pinned_obj_table prog_table;
+static struct hashmap *prog_table;
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
@@ -418,15 +419,14 @@ static void print_prog_json(struct bpf_prog_info *info, int fd)
 	if (info->btf_id)
 		jsonw_int_field(json_wtr, "btf_id", info->btf_id);
 
-	if (!hash_empty(prog_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(prog_table)) {
+		struct hashmap_entry *entry;
 
 		jsonw_name(json_wtr, "pinned");
 		jsonw_start_array(json_wtr);
-		hash_for_each_possible(prog_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				jsonw_string(json_wtr, obj->path);
-		}
+		hashmap__for_each_key_entry(prog_table, entry,
+					    u32_as_hash_field(info->id))
+			jsonw_string(json_wtr, entry->value);
 		jsonw_end_array(json_wtr);
 	}
 
@@ -490,13 +490,12 @@ static void print_prog_plain(struct bpf_prog_info *info, int fd)
 	if (info->nr_map_ids)
 		show_prog_maps(fd, info->nr_map_ids);
 
-	if (!hash_empty(prog_table.table)) {
-		struct pinned_obj *obj;
+	if (!hashmap__empty(prog_table)) {
+		struct hashmap_entry *entry;
 
-		hash_for_each_possible(prog_table.table, obj, hash, info->id) {
-			if (obj->id == info->id)
-				printf("\n\tpinned %s", obj->path);
-		}
+		hashmap__for_each_key_entry(prog_table, entry,
+					    u32_as_hash_field(info->id))
+			printf("\n\tpinned %s", (char *)entry->value);
 	}
 
 	if (info->btf_id)
@@ -570,8 +569,13 @@ static int do_show(int argc, char **argv)
 	int fd;
 
 	if (show_pinned) {
-		hash_init(prog_table.table);
-		build_pinned_obj_table(&prog_table, BPF_OBJ_PROG);
+		prog_table = hashmap__new(hash_fn_for_key_as_id,
+					  equal_fn_for_key_as_id, NULL);
+		if (!prog_table) {
+			p_err("failed to create hashmap for pinned paths");
+			return -1;
+		}
+		build_pinned_obj_table(prog_table, BPF_OBJ_PROG);
 	}
 	build_obj_refs_table(&refs_table, BPF_OBJ_PROG);
 
@@ -618,7 +622,7 @@ static int do_show(int argc, char **argv)
 	delete_obj_refs_table(&refs_table);
 
 	if (show_pinned)
-		delete_pinned_obj_table(&prog_table);
+		delete_pinned_obj_table(prog_table);
 
 	return err;
 }
-- 
2.30.2

