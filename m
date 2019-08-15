Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66A178EEEC
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbfHOPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:00:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41548 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733310AbfHOPAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:00:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id j16so2479950wrr.8
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F3c3B8ToqzZZt83DOovnHXflBxS6NmcDdVW+ZOpTlGo=;
        b=AP8QcTXTuMMWWd5w7alGjDTF02YHMU03TRl28e6+vM04T/ZC5fDED5nGsZ7RWNy6ZW
         I/PPMD89dB5h+XdeW7nwtPJolxJ/8zOQh/cXog4eLLWf9Pg+NdNceZ9O/EocXjZUPesM
         jLzKjAimLOFNIWsqtK4TWBMyK1p9Xa5zc2+KB65+o+HIK5CSFSKj7Tv0WTg/Idbvsv30
         eGsr3SrGbsRd6ayxy5+YH7t+DBQwVZ4GVy69NY/i02k51aN2v0Myq/u/3kGr34MaXipC
         vfNu95qi9s4nDTsbfdyskDVNe36xzi2W44yWJApV1pqj5gBTjWQ8Cpa5RNRyHhJC3P5t
         +Xpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F3c3B8ToqzZZt83DOovnHXflBxS6NmcDdVW+ZOpTlGo=;
        b=UJkH3Fh4r6OTj4N62iVYRUhj7x7WNsae8n0M4A10bmNNDQw6SeRPq61Tw64el06AyG
         fJBZI2JgJ4SRDuMb2GUk0gUB9fGhhmYHzKeKP9D0E2x74QA1NYf6f1iODkGQhV4RQLw/
         yhZPF1yLK1fK5lHo70ozNmvG/f57uYqPQ/AtEFZIgqAezLRKegC0yD6NOYkDj7NWATye
         Ckn1AeKvv/CW+kYfvgwNZ5K6/XQokH8cqa00Uglzrx8ks1417Qtg0CqdzlUs0Hd7aiDt
         k6NI9R0UkVxCfkcIJ0XJ9cFKywyfQ6D6ZKIkG9FcRDsnj1NziMnIstanajronqeh/YSW
         FHdA==
X-Gm-Message-State: APjAAAXia7QmiDAC1T1iU1O/vFVBMfPEsb8KD2ciRUyn4um4HTtD/GpE
        iFMn9LPPJ6UwlY5j5FQOw6Ag+Q==
X-Google-Smtp-Source: APXvYqwK+qit5oq5RSA9DFoMN+WyG063cszNlVo/RL7ttpalDYNzqRYa7Bi9UwnmrytQljp8H/PeJA==
X-Received: by 2002:a05:6000:1085:: with SMTP id y5mr5871079wrw.285.1565881237312;
        Thu, 15 Aug 2019 08:00:37 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a23sm2794857wma.24.2019.08.15.08.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 08:00:35 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next 5/5] tools: bpftool: implement "bpftool btf show|list"
Date:   Thu, 15 Aug 2019 16:00:19 +0100
Message-Id: <20190815150019.8523-6-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815150019.8523-1-quentin.monnet@netronome.com>
References: <20190815150019.8523-1-quentin.monnet@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a "btf list" (alias: "btf show") subcommand to bpftool in order to
dump all BTF objects loaded on a system.

When running the command, hash tables are built in bpftool to retrieve
all the associations between BTF objects and BPF maps and programs. This
allows for printing all such associations when listing the BTF objects.

The command is added at the top of the subcommands for "bpftool btf", so
that typing only "bpftool btf" also comes down to listing the programs.
We could not have this with the previous command ("dump"), which
required a BTF object id, so it should not break any previous behaviour.
This also makes the "btf" command behaviour consistent with "prog" or
"map".

Bash completion is updated to use "bpftool btf" instead of "bpftool
prog" to list the BTF ids, as it looks more consistent.

Example output (plain):

    # bpftool btf show
    9: size 2989B  prog_ids 21  map_ids 15
    17: size 2847B  prog_ids 36  map_ids 30,29,28
    26: size 2847B

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst |   7 +
 tools/bpf/bpftool/bash-completion/bpftool     |  20 +-
 tools/bpf/bpftool/btf.c                       | 342 +++++++++++++++++-
 3 files changed, 363 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 6694a0fc8f99..39615f8e145b 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -19,6 +19,7 @@ SYNOPSIS
 BTF COMMANDS
 =============
 
+|	**bpftool** **btf** { **show** | **list** } [**id** *BTF_ID*]
 |	**bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
 |	**bpftool** **btf help**
 |
@@ -29,6 +30,12 @@ BTF COMMANDS
 
 DESCRIPTION
 ===========
+	**bpftool btf { show | list }** [**id** *BTF_ID*]
+		  Show information about loaded BTF objects. If a BTF ID is
+		  specified, show information only about given BTF object,
+		  otherwise list all BTF objects currently loaded on the
+		  system.
+
 	**bpftool btf dump** *BTF_SRC*
 		  Dump BTF entries from a given *BTF_SRC*.
 
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index df16c5415444..2c0081121b2b 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -73,8 +73,8 @@ _bpftool_get_prog_tags()
 
 _bpftool_get_btf_ids()
 {
-    COMPREPLY+=( $( compgen -W "$( bpftool -jp prog 2>&1 | \
-        command sed -n 's/.*"btf_id": \(.*\),\?$/\1/p' )" -- "$cur" ) )
+    COMPREPLY+=( $( compgen -W "$( bpftool -jp btf 2>&1 | \
+        command sed -n 's/.*"id": \(.*\),$/\1/p' )" -- "$cur" ) )
 }
 
 _bpftool_get_obj_map_names()
@@ -674,7 +674,7 @@ _bpftool()
                                 map)
                                     _bpftool_get_map_ids
                                     ;;
-                                dump)
+                                $command)
                                     _bpftool_get_btf_ids
                                     ;;
                             esac
@@ -702,9 +702,21 @@ _bpftool()
                             ;;
                     esac
                     ;;
+                show|list)
+                    case $prev in
+                        $command)
+                            COMPREPLY+=( $( compgen -W "id" -- "$cur" ) )
+                            ;;
+                        id)
+                            _bpftool_get_btf_ids
+                            ;;
+                    esac
+                    return 0
+                    ;;
                 *)
                     [[ $prev == $object ]] && \
-                        COMPREPLY=( $( compgen -W 'dump help' -- "$cur" ) )
+                        COMPREPLY=( $( compgen -W 'dump help show list' \
+                            -- "$cur" ) )
                     ;;
             esac
             ;;
diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 1b8ec91899e6..839b76af689c 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -11,6 +11,7 @@
 #include <bpf.h>
 #include <libbpf.h>
 #include <linux/btf.h>
+#include <linux/hashtable.h>
 
 #include "btf.h"
 #include "json_writer.h"
@@ -35,6 +36,16 @@ static const char * const btf_kind_str[NR_BTF_KINDS] = {
 	[BTF_KIND_DATASEC]	= "DATASEC",
 };
 
+struct btf_attach_table {
+	DECLARE_HASHTABLE(table, 16);
+};
+
+struct btf_attach_point {
+	__u32 obj_id;
+	__u32 btf_id;
+	struct hlist_node hash;
+};
+
 static const char *btf_int_enc_str(__u8 encoding)
 {
 	switch (encoding) {
@@ -522,6 +533,330 @@ static int do_dump(int argc, char **argv)
 	return err;
 }
 
+static int btf_parse_fd(int *argc, char ***argv)
+{
+	unsigned int id;
+	char *endptr;
+	int fd;
+
+	if (!is_prefix(*argv[0], "id")) {
+		p_err("expected 'id', got: '%s'?", **argv);
+		return -1;
+	}
+	NEXT_ARGP();
+
+	id = strtoul(**argv, &endptr, 0);
+	if (*endptr) {
+		p_err("can't parse %s as ID", **argv);
+		return -1;
+	}
+	NEXT_ARGP();
+
+	fd = bpf_btf_get_fd_by_id(id);
+	if (fd < 0)
+		p_err("can't get BTF object by id (%u): %s",
+		      id, strerror(errno));
+
+	return fd;
+}
+
+static void delete_btf_table(struct btf_attach_table *tab)
+{
+	struct btf_attach_point *obj;
+	struct hlist_node *tmp;
+
+	unsigned int bkt;
+
+	hash_for_each_safe(tab->table, bkt, tmp, obj, hash) {
+		hash_del(&obj->hash);
+		free(obj);
+	}
+}
+
+static int
+build_btf_type_table(struct btf_attach_table *tab, enum bpf_obj_type type,
+		     void *info, __u32 *len)
+{
+	static const char * const names[] = {
+		[BPF_OBJ_UNKNOWN]	= "unknown",
+		[BPF_OBJ_PROG]		= "prog",
+		[BPF_OBJ_MAP]		= "map",
+	};
+	struct btf_attach_point *obj_node;
+	__u32 btf_id, id = 0;
+	int err;
+	int fd;
+
+	while (true) {
+		switch (type) {
+		case BPF_OBJ_PROG:
+			err = bpf_prog_get_next_id(id, &id);
+			break;
+		case BPF_OBJ_MAP:
+			err = bpf_map_get_next_id(id, &id);
+			break;
+		default:
+			err = -1;
+			p_err("unexpected object type: %d", type);
+			goto err_free;
+		}
+		if (err) {
+			if (errno == ENOENT) {
+				err = 0;
+				break;
+			}
+			p_err("can't get next %s: %s%s", names[type],
+			      strerror(errno),
+			      errno == EINVAL ? " -- kernel too old?" : "");
+			goto err_free;
+		}
+
+		switch (type) {
+		case BPF_OBJ_PROG:
+			fd = bpf_prog_get_fd_by_id(id);
+			break;
+		case BPF_OBJ_MAP:
+			fd = bpf_map_get_fd_by_id(id);
+			break;
+		default:
+			err = -1;
+			p_err("unexpected object type: %d", type);
+			goto err_free;
+		}
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue;
+			p_err("can't get %s by id (%u): %s", names[type], id,
+			      strerror(errno));
+			err = -1;
+			goto err_free;
+		}
+
+		memset(info, 0, *len);
+		err = bpf_obj_get_info_by_fd(fd, info, len);
+		close(fd);
+		if (err) {
+			p_err("can't get %s info: %s", names[type],
+			      strerror(errno));
+			goto err_free;
+		}
+
+		switch (type) {
+		case BPF_OBJ_PROG:
+			btf_id = ((struct bpf_prog_info *)info)->btf_id;
+			break;
+		case BPF_OBJ_MAP:
+			btf_id = ((struct bpf_map_info *)info)->btf_id;
+			break;
+		default:
+			err = -1;
+			p_err("unexpected object type: %d", type);
+			goto err_free;
+		}
+		if (!btf_id)
+			continue;
+
+		obj_node = calloc(1, sizeof(*obj_node));
+		if (!obj_node) {
+			p_err("failed to allocate memory: %s", strerror(errno));
+			goto err_free;
+		}
+
+		obj_node->obj_id = id;
+		obj_node->btf_id = btf_id;
+		hash_add(tab->table, &obj_node->hash, obj_node->btf_id);
+	}
+
+	return 0;
+
+err_free:
+	delete_btf_table(tab);
+	return err;
+}
+
+static int
+build_btf_tables(struct btf_attach_table *btf_prog_table,
+		 struct btf_attach_table *btf_map_table)
+{
+	struct bpf_prog_info prog_info;
+	__u32 prog_len = sizeof(prog_info);
+	struct bpf_map_info map_info;
+	__u32 map_len = sizeof(map_info);
+	int err = 0;
+
+	err = build_btf_type_table(btf_prog_table, BPF_OBJ_PROG, &prog_info,
+				   &prog_len);
+	if (err)
+		return err;
+
+	err = build_btf_type_table(btf_map_table, BPF_OBJ_MAP, &map_info,
+				   &map_len);
+	if (err) {
+		delete_btf_table(btf_prog_table);
+		return err;
+	}
+
+	return 0;
+}
+
+static void
+show_btf_plain(struct bpf_btf_info *info, int fd,
+	       struct btf_attach_table *btf_prog_table,
+	       struct btf_attach_table *btf_map_table)
+{
+	struct btf_attach_point *obj;
+	int n;
+
+	printf("%u: ", info->id);
+	printf("size %uB", info->btf_size);
+
+	n = 0;
+	hash_for_each_possible(btf_prog_table->table, obj, hash, info->id) {
+		if (obj->btf_id == info->id)
+			printf("%s%u", n++ == 0 ? "  prog_ids " : ",",
+			       obj->obj_id);
+	}
+
+	n = 0;
+	hash_for_each_possible(btf_map_table->table, obj, hash, info->id) {
+		if (obj->btf_id == info->id)
+			printf("%s%u", n++ == 0 ? "  map_ids " : ",",
+			       obj->obj_id);
+	}
+
+	printf("\n");
+}
+
+static void
+show_btf_json(struct bpf_btf_info *info, int fd,
+	      struct btf_attach_table *btf_prog_table,
+	      struct btf_attach_table *btf_map_table)
+{
+	struct btf_attach_point *obj;
+
+	jsonw_start_object(json_wtr);	/* btf object */
+	jsonw_uint_field(json_wtr, "id", info->id);
+	jsonw_uint_field(json_wtr, "size", info->btf_size);
+
+	jsonw_name(json_wtr, "prog_ids");
+	jsonw_start_array(json_wtr);	/* prog_ids */
+	hash_for_each_possible(btf_prog_table->table, obj, hash,
+			       info->id) {
+		if (obj->btf_id == info->id)
+			jsonw_uint(json_wtr, obj->obj_id);
+	}
+	jsonw_end_array(json_wtr);	/* prog_ids */
+
+	jsonw_name(json_wtr, "map_ids");
+	jsonw_start_array(json_wtr);	/* map_ids */
+	hash_for_each_possible(btf_map_table->table, obj, hash,
+			       info->id) {
+		if (obj->btf_id == info->id)
+			jsonw_uint(json_wtr, obj->obj_id);
+	}
+	jsonw_end_array(json_wtr);	/* map_ids */
+	jsonw_end_object(json_wtr);	/* btf object */
+}
+
+static int
+show_btf(int fd, struct btf_attach_table *btf_prog_table,
+	 struct btf_attach_table *btf_map_table)
+{
+	struct bpf_btf_info info = {};
+	__u32 len = sizeof(info);
+	int err;
+
+	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (err) {
+		p_err("can't get BTF object info: %s", strerror(errno));
+		return -1;
+	}
+
+	if (json_output)
+		show_btf_json(&info, fd, btf_prog_table, btf_map_table);
+	else
+		show_btf_plain(&info, fd, btf_prog_table, btf_map_table);
+
+	return 0;
+}
+
+static int do_show(int argc, char **argv)
+{
+	struct btf_attach_table btf_prog_table;
+	struct btf_attach_table btf_map_table;
+	int err, fd = -1;
+	__u32 id = 0;
+
+	if (argc == 2) {
+		fd = btf_parse_fd(&argc, &argv);
+		if (fd < 0)
+			return -1;
+	}
+
+	if (argc) {
+		if (fd >= 0)
+			close(fd);
+		return BAD_ARG();
+	}
+
+	hash_init(btf_prog_table.table);
+	hash_init(btf_map_table.table);
+	err = build_btf_tables(&btf_prog_table, &btf_map_table);
+	if (err) {
+		if (fd >= 0)
+			close(fd);
+		return err;
+	}
+
+	if (fd >= 0) {
+		err = show_btf(fd, &btf_prog_table, &btf_map_table);
+		close(fd);
+		goto exit_free;
+	}
+
+	if (json_output)
+		jsonw_start_array(json_wtr);	/* root array */
+
+	while (true) {
+		err = bpf_btf_get_next_id(id, &id);
+		if (err) {
+			if (errno == ENOENT) {
+				err = 0;
+				break;
+			}
+			p_err("can't get next BTF object: %s%s",
+			      strerror(errno),
+			      errno == EINVAL ? " -- kernel too old?" : "");
+			err = -1;
+			break;
+		}
+
+		fd = bpf_btf_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue;
+			p_err("can't get BTF object by id (%u): %s",
+			      id, strerror(errno));
+			err = -1;
+			break;
+		}
+
+		err = show_btf(fd, &btf_prog_table, &btf_map_table);
+		close(fd);
+		if (err)
+			break;
+	}
+
+	if (json_output)
+		jsonw_end_array(json_wtr);	/* root array */
+
+exit_free:
+	delete_btf_table(&btf_prog_table);
+	delete_btf_table(&btf_map_table);
+
+	return err;
+}
+
 static int do_help(int argc, char **argv)
 {
 	if (json_output) {
@@ -530,7 +865,8 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s btf dump BTF_SRC [format FORMAT]\n"
+		"Usage: %s btf { show | list } [id BTF_ID]\n"
+		"       %s btf dump BTF_SRC [format FORMAT]\n"
 		"       %s btf help\n"
 		"\n"
 		"       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
@@ -539,12 +875,14 @@ static int do_help(int argc, char **argv)
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name, bin_name);
+		bin_name, bin_name, bin_name);
 
 	return 0;
 }
 
 static const struct cmd cmds[] = {
+	{ "show",	do_show },
+	{ "list",	do_show },
 	{ "help",	do_help },
 	{ "dump",	do_dump },
 	{ 0 }
-- 
2.17.1

