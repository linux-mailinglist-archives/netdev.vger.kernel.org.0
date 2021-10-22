Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7F03437BB9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhJVRTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233570AbhJVRTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 13:19:13 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809CBC061764
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:55 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r7so3317623wrc.10
        for <netdev@vger.kernel.org>; Fri, 22 Oct 2021 10:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JY1M5axy/HFCR/nrDDywk78F0Ek+jgKemoU/bfIl+L8=;
        b=AxmCKAG1FoKpdsStE75j/dgcjwa2QcvjbCsJs7qTsxuiH+uX0Hbg4oICOpIZYpQDCY
         tt4QhGjxCWZUihizmj1Afi3caWV/7g2iR2lWsCQCKqINbWb+k6Qm2/FTwHThuXG9oUn2
         /hmaCpjv8cF8KKg1enar3Jws6FFb0Fqf/UQpjDKnY2JNh7zvT7TIH5wNZMInj6vY8yfE
         iwzEsoYK2Y1DbfqWBBo1YNVaWQJhOm5vQHPpheDPrDgeBHZ5zyXHioKZwlZfvr36EKGV
         +2pAx9qHBDas7gzJNyMxre96D7E/RO6URHz5XMfGuIyACKcmpoeo0BcF3XzuxdK19eCD
         MupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JY1M5axy/HFCR/nrDDywk78F0Ek+jgKemoU/bfIl+L8=;
        b=P3XDbX7UuGau0mkyU+Thfo29qdJxvV8escSiMgAubl9jgxYYRZUw/UlE1DEpMAwgzn
         888HaJvOWjyeJGigqE3TJTp4smTa5e9pwTJL8NoWs4skcVHCoyzbRTEBV8xcsabjM5r2
         eCQ/Wx5wQBS6yOtIJVzYbnhswsAiGb+pU0OpFSnhS/QMa9wl/S35mtC1hTm6aQajceu9
         3UjYYxde6tzRK3PSTXWiBcntI9QvrMvHLbKhYExHz4NGnazmKMFR4wI/nsvSZJmyLusJ
         Mb2XfWvs/SUhMk0Pj6/FZNapZSM1PHU1yf+FGHGe9jMexqxFYKmpe2cC9Qx8lJR8REGd
         a6jg==
X-Gm-Message-State: AOAM532lEZR7sUeq2j7U6IBjlrwCw7ytR9+xhWW3c1XrT8LsLanaB7XT
        fczz0wjC6alrYRAETvG3ajK2Mg==
X-Google-Smtp-Source: ABdhPJxm6N3BLCtr7hN83Tz1DNlS7dgT3VgxD9U+I+PPTVF7S2juOFEdY8PWue/4HHamaj0zbX/kvw==
X-Received: by 2002:a5d:5287:: with SMTP id c7mr1422505wrv.236.1634923014130;
        Fri, 22 Oct 2021 10:16:54 -0700 (PDT)
Received: from localhost.localdomain ([149.86.74.50])
        by smtp.gmail.com with ESMTPSA id 6sm4427367wma.48.2021.10.22.10.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 10:16:53 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 4/5] bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
Date:   Fri, 22 Oct 2021 18:16:46 +0100
Message-Id: <20211022171647.27885-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022171647.27885-1-quentin@isovalent.com>
References: <20211022171647.27885-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to show BPF programs and maps using BTF objects when the latter
are being listed, bpftool creates hash maps to store all relevant items.
This commit is part of a set that transitions from the kernel's hash map
implementation to the one coming with libbpf.

The motivation is to make bpftool less dependent of kernel headers, to
ease the path to a potential out-of-tree mirror, like libbpf has.

This commit focuses on the two hash maps used by bpftool when listing
BTF objects to store references to programs and maps, and convert them
to the libbpf's implementation.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf.c  | 126 ++++++++++++++++-----------------------
 tools/bpf/bpftool/main.h |   5 ++
 2 files changed, 57 insertions(+), 74 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 7b68d4f65fe6..84959aa05265 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -8,14 +8,16 @@
 #include <stdio.h>
 #include <string.h>
 #include <unistd.h>
-#include <bpf/bpf.h>
-#include <bpf/btf.h>
-#include <bpf/libbpf.h>
 #include <linux/btf.h>
 #include <linux/hashtable.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
+#include <bpf/bpf.h>
+#include <bpf/btf.h>
+#include <bpf/hashmap.h>
+#include <bpf/libbpf.h>
+
 #include "json_writer.h"
 #include "main.h"
 
@@ -40,14 +42,9 @@ static const char * const btf_kind_str[NR_BTF_KINDS] = {
 	[BTF_KIND_DECL_TAG]	= "DECL_TAG",
 };
 
-struct btf_attach_table {
-	DECLARE_HASHTABLE(table, 16);
-};
-
 struct btf_attach_point {
 	__u32 obj_id;
 	__u32 btf_id;
-	struct hlist_node hash;
 };
 
 static const char *btf_int_enc_str(__u8 encoding)
@@ -645,21 +642,8 @@ static int btf_parse_fd(int *argc, char ***argv)
 	return fd;
 }
 
-static void delete_btf_table(struct btf_attach_table *tab)
-{
-	struct btf_attach_point *obj;
-	struct hlist_node *tmp;
-
-	unsigned int bkt;
-
-	hash_for_each_safe(tab->table, bkt, tmp, obj, hash) {
-		hash_del(&obj->hash);
-		free(obj);
-	}
-}
-
 static int
-build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
+build_btf_type_table(struct hashmap *tab, enum bpf_obj_type type,
 		     void *info, __u32 *len)
 {
 	static const char * const names[] = {
@@ -667,7 +651,6 @@ build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
 		[BPF_OBJ_PROG]		= "prog",
 		[BPF_OBJ_MAP]		= "map",
 	};
-	struct btf_attach_point *obj_node;
 	__u32 btf_id, id = 0;
 	int err;
 	int fd;
@@ -741,28 +724,20 @@ build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
 		if (!btf_id)
 			continue;
 
-		obj_node = calloc(1, sizeof(*obj_node));
-		if (!obj_node) {
-			p_err("failed to allocate memory: %s", strerror(errno));
-			err = -ENOMEM;
-			goto err_free;
-		}
-
-		obj_node->obj_id = id;
-		obj_node->btf_id = btf_id;
-		hash_add(tab->table, &obj_node->hash, obj_node->btf_id);
+		hashmap__append(tab, u32_as_hash_field(btf_id),
+				u32_as_hash_field(id));
 	}
 
 	return 0;
 
 err_free:
-	delete_btf_table(tab);
+	hashmap__free(tab);
 	return err;
 }
 
 static int
-build_btf_tables(struct btf_attach_table *btf_prog_table,
-		 struct btf_attach_table *btf_map_table)
+build_btf_tables(struct hashmap *btf_prog_table,
+		 struct hashmap *btf_map_table)
 {
 	struct bpf_prog_info prog_info;
 	__u32 prog_len = sizeof(prog_info);
@@ -778,7 +753,7 @@ build_btf_tables(struct btf_attach_table *btf_prog_table,
 	err = build_btf_type_table(btf_map_table, BPF_OBJ_MAP, &map_info,
 				   &map_len);
 	if (err) {
-		delete_btf_table(btf_prog_table);
+		hashmap__free(btf_prog_table);
 		return err;
 	}
 
@@ -787,10 +762,10 @@ build_btf_tables(struct btf_attach_table *btf_prog_table,
 
 static void
 show_btf_plain(struct bpf_btf_info *info, int fd,
-	       struct btf_attach_table *btf_prog_table,
-	       struct btf_attach_table *btf_map_table)
+	       struct hashmap *btf_prog_table,
+	       struct hashmap *btf_map_table)
 {
-	struct btf_attach_point *obj;
+	struct hashmap_entry *entry;
 	const char *name = u64_to_ptr(info->name);
 	int n;
 
@@ -804,18 +779,17 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
 	printf("size %uB", info->btf_size);
 
 	n = 0;
-	hash_for_each_possible(btf_prog_table->table, obj, hash, info->id) {
-		if (obj->btf_id == info->id)
-			printf("%s%u", n++ == 0 ? "  prog_ids " : ",",
-			       obj->obj_id);
-	}
+	hashmap__for_each_key_entry(btf_prog_table, entry,
+				    u32_as_hash_field(info->id))
+		printf("%s%u", n++ == 0 ? "  prog_ids " : ",",
+		       hash_field_as_u32(entry->value));
 
 	n = 0;
-	hash_for_each_possible(btf_map_table->table, obj, hash, info->id) {
-		if (obj->btf_id == info->id)
-			printf("%s%u", n++ == 0 ? "  map_ids " : ",",
-			       obj->obj_id);
-	}
+	hashmap__for_each_key_entry(btf_map_table, entry,
+				    u32_as_hash_field(info->id))
+		printf("%s%u", n++ == 0 ? "  map_ids " : ",",
+		       hash_field_as_u32(entry->value));
+
 	emit_obj_refs_plain(&refs_table, info->id, "\n\tpids ");
 
 	printf("\n");
@@ -823,10 +797,10 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
 
 static void
 show_btf_json(struct bpf_btf_info *info, int fd,
-	      struct btf_attach_table *btf_prog_table,
-	      struct btf_attach_table *btf_map_table)
+	      struct hashmap *btf_prog_table,
+	      struct hashmap *btf_map_table)
 {
-	struct btf_attach_point *obj;
+	struct hashmap_entry *entry;
 	const char *name = u64_to_ptr(info->name);
 
 	jsonw_start_object(json_wtr);	/* btf object */
@@ -835,20 +809,16 @@ show_btf_json(struct bpf_btf_info *info, int fd,
 
 	jsonw_name(json_wtr, "prog_ids");
 	jsonw_start_array(json_wtr);	/* prog_ids */
-	hash_for_each_possible(btf_prog_table->table, obj, hash,
-			       info->id) {
-		if (obj->btf_id == info->id)
-			jsonw_uint(json_wtr, obj->obj_id);
-	}
+	hashmap__for_each_key_entry(btf_prog_table, entry,
+				    u32_as_hash_field(info->id))
+		jsonw_uint(json_wtr, hash_field_as_u32(entry->value));
 	jsonw_end_array(json_wtr);	/* prog_ids */
 
 	jsonw_name(json_wtr, "map_ids");
 	jsonw_start_array(json_wtr);	/* map_ids */
-	hash_for_each_possible(btf_map_table->table, obj, hash,
-			       info->id) {
-		if (obj->btf_id == info->id)
-			jsonw_uint(json_wtr, obj->obj_id);
-	}
+	hashmap__for_each_key_entry(btf_map_table, entry,
+				    u32_as_hash_field(info->id))
+		jsonw_uint(json_wtr, hash_field_as_u32(entry->value));
 	jsonw_end_array(json_wtr);	/* map_ids */
 
 	emit_obj_refs_json(&refs_table, info->id, json_wtr); /* pids */
@@ -862,8 +832,8 @@ show_btf_json(struct bpf_btf_info *info, int fd,
 }
 
 static int
-show_btf(int fd, struct btf_attach_table *btf_prog_table,
-	 struct btf_attach_table *btf_map_table)
+show_btf(int fd, struct hashmap *btf_prog_table,
+	 struct hashmap *btf_map_table)
 {
 	struct bpf_btf_info info;
 	__u32 len = sizeof(info);
@@ -900,8 +870,8 @@ show_btf(int fd, struct btf_attach_table *btf_prog_table,
 
 static int do_show(int argc, char **argv)
 {
-	struct btf_attach_table btf_prog_table;
-	struct btf_attach_table btf_map_table;
+	struct hashmap *btf_prog_table;
+	struct hashmap *btf_map_table;
 	int err, fd = -1;
 	__u32 id = 0;
 
@@ -917,9 +887,17 @@ static int do_show(int argc, char **argv)
 		return BAD_ARG();
 	}
 
-	hash_init(btf_prog_table.table);
-	hash_init(btf_map_table.table);
-	err = build_btf_tables(&btf_prog_table, &btf_map_table);
+	btf_prog_table = hashmap__new(bpftool_hash_fn, bpftool_equal_fn, NULL);
+	btf_map_table = hashmap__new(bpftool_hash_fn, bpftool_equal_fn, NULL);
+	if (!btf_prog_table || !btf_map_table) {
+		hashmap__free(btf_prog_table);
+		hashmap__free(btf_map_table);
+		if (fd >= 0)
+			close(fd);
+		p_err("failed to create hashmap for object references");
+		return -1;
+	}
+	err = build_btf_tables(btf_prog_table, btf_map_table);
 	if (err) {
 		if (fd >= 0)
 			close(fd);
@@ -928,7 +906,7 @@ static int do_show(int argc, char **argv)
 	build_obj_refs_table(&refs_table, BPF_OBJ_BTF);
 
 	if (fd >= 0) {
-		err = show_btf(fd, &btf_prog_table, &btf_map_table);
+		err = show_btf(fd, btf_prog_table, btf_map_table);
 		close(fd);
 		goto exit_free;
 	}
@@ -960,7 +938,7 @@ static int do_show(int argc, char **argv)
 			break;
 		}
 
-		err = show_btf(fd, &btf_prog_table, &btf_map_table);
+		err = show_btf(fd, btf_prog_table, btf_map_table);
 		close(fd);
 		if (err)
 			break;
@@ -970,8 +948,8 @@ static int do_show(int argc, char **argv)
 		jsonw_end_array(json_wtr);	/* root array */
 
 exit_free:
-	delete_btf_table(&btf_prog_table);
-	delete_btf_table(&btf_map_table);
+	hashmap__free(btf_prog_table);
+	hashmap__free(btf_map_table);
 	delete_obj_refs_table(&refs_table);
 
 	return err;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index f61be172d864..a8e71ead848c 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -256,6 +256,11 @@ static inline void *u32_as_hash_field(__u32 x)
 	return (void *)(uintptr_t)x;
 }
 
+static inline __u32 hash_field_as_u32(const void *x)
+{
+	return (__u32)(uintptr_t)x;
+}
+
 static inline bool hashmap__empty(struct hashmap *map)
 {
 	return map ? hashmap__size(map) == 0 : true;
-- 
2.30.2

