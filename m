Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E367D22467C
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 00:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgGQWz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 18:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgGQWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 18:55:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D185C0619D2;
        Fri, 17 Jul 2020 15:55:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z3so6056335pfn.12;
        Fri, 17 Jul 2020 15:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QdtE/wmAhW05sZUPuma2RrTvSoHqzbaenBHjoIn5xqU=;
        b=gBWz+8dl61r1GSerP4sA7je21spl+HEHE7M3zm1HMk/+NFkLzwk6pzChiClaDCfLok
         P7be1O9/DTpWVLPsuI4FaiP5mgw7JfMN2ePFfNY0yZBooW+iyGynDj85tJozO473VEPq
         R7Ujxwf1u1602SldEbunjmqn2/86XRGLtPOgdbrXU6j3nCgnJjKDjoDwaSBrI7BOsTWS
         LSrcDt6eqP0455mSGZBti36C6MpmnNIjVJ5bGkJv2o1Vk5bzjobjsYgjxOrdAv0ylzdS
         H0welAmswuTR2aixLrUyTTz6IZ6eQ+c9fDhr94rOfAWex2PKA8SOuTnd4Z0Rfjik0J5T
         buew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QdtE/wmAhW05sZUPuma2RrTvSoHqzbaenBHjoIn5xqU=;
        b=rCrAogkOnVXjp8msr4M19OGQyZSCg92ZcAw69ByMkmBQsO3R3Vft27J97cPQxDE5g4
         CFc9ZYdeqDoI8/BN/JCFALPsBlnz+CNRtvh3b0xsTXpQTMZ0qAN8IgW4tlvhtkvJGQk3
         ZNdyxSg+OM92ii99+uA0qBsj/qFBXusyOXzpoOugdb+cXJ7SxIyDR4Bpy/SjDXDBnvF6
         5KocBciBkIUp6b2zwBghD4FpR//7Gp++TDWIqAwj0Hk8R/gY9exMBX7skMnKvqRUymiw
         mdGO37ZbhxP8NP/nnH9x44pK1jCEjDkJI2ft0sATRlLj/ict2jCIjrvppTI8Mnj2tSn+
         OT3A==
X-Gm-Message-State: AOAM531btmldcL+39mrEBzp3GFlLs8ZjcNXKU6f+rwNOGeOpO2cli7qP
        biGJrcdHAXSUcxteEV4FnkQ=
X-Google-Smtp-Source: ABdhPJyi6yW86kzcaPaqYYpunKHuCOiiVfZSxn2lpbvXi/TPHVoYjGbq+kwm9hoiPBLdv2wk8wJdxw==
X-Received: by 2002:a63:3151:: with SMTP id x78mr10768674pgx.210.1595026558778;
        Fri, 17 Jul 2020 15:55:58 -0700 (PDT)
Received: from ubuntu.lan ([2001:470:e92d:10:3505:f2d8:29e6:fd26])
        by smtp.gmail.com with ESMTPSA id 204sm8536759pfx.3.2020.07.17.15.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 15:55:58 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v3] bpftool: use only nftw for file tree parsing
Date:   Fri, 17 Jul 2020 15:55:43 -0700
Message-Id: <20200717225543.32126-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200716052926.10933-1-Tony.Ambardar () gmail ! com>
References: <20200716052926.10933-1-Tony.Ambardar () gmail ! com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpftool sources include code to walk file trees, but use multiple
frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
is widely available, fts is not conformant and less common, especially on
non-glibc systems. The inconsistent framework usage hampers maintenance
and portability of bpftool, in particular for embedded systems.

Standardize code usage by rewriting one fts-based function to use nftw and
clean up some related function warnings by extending use of "const char *"
arguments. This change helps in building bpftool against musl for OpenWrt.

Also fix an unsafe call to dirname() by duplicating the string to pass,
since some implementations may directly alter it. The same approach is
used in libbpf.c.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---

V3:
* clarify dirname() path copy in commit message
* fix whitespace and rearrange comment for clarity
* drop unnecessary initializers, rebalance Christmas tree
* fixup error message and drop others not previously present
* simplify malloc() + memset() -> calloc() and check for mem errors

V2:
* use _GNU_SOURCE to pull in getpagesize(), getline(), nftw() definitions
* use "const char *" in open_obj_pinned() and open_obj_pinned_any()
* make dirname() safely act on a string copy

---
 tools/bpf/bpftool/common.c | 132 +++++++++++++++++++++----------------
 tools/bpf/bpftool/main.h   |   4 +-
 2 files changed, 78 insertions(+), 58 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 29f4e7611ae8..2ecfafcd01df 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 /* Copyright (C) 2017-2018 Netronome Systems, Inc. */
 
+#define _GNU_SOURCE
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <fts.h>
+#include <ftw.h>
 #include <libgen.h>
 #include <mntent.h>
 #include <stdbool.h>
@@ -160,24 +161,35 @@ int mount_tracefs(const char *target)
 	return err;
 }
 
-int open_obj_pinned(char *path, bool quiet)
+int open_obj_pinned(const char *path, bool quiet)
 {
-	int fd;
+	char *pname;
+	int fd = -1;
 
-	fd = bpf_obj_get(path);
+	pname = strdup(path);
+	if (!pname) {
+		if (!quiet)
+			p_err("mem alloc failed");
+		goto out_ret;
+	}
+
+	fd = bpf_obj_get(pname);
 	if (fd < 0) {
 		if (!quiet)
-			p_err("bpf obj get (%s): %s", path,
-			      errno == EACCES && !is_bpffs(dirname(path)) ?
+			p_err("bpf obj get (%s): %s", pname,
+			      errno == EACCES && !is_bpffs(dirname(pname)) ?
 			    "directory not in bpf file system (bpffs)" :
 			    strerror(errno));
-		return -1;
+		goto out_free;
 	}
 
+out_free:
+	free(pname);
+out_ret:
 	return fd;
 }
 
-int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type)
+int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type)
 {
 	enum bpf_obj_type type;
 	int fd;
@@ -367,68 +379,76 @@ void print_hex_data_json(uint8_t *data, size_t len)
 	jsonw_end_array(json_wtr);
 }
 
+/* extra params for nftw cb*/
+static struct pinned_obj_table *build_fn_table;
+static enum bpf_obj_type build_fn_type;
+
+static int do_build_table_cb(const char *fpath, const struct stat *sb,
+			     int typeflag, struct FTW *ftwbuf)
+{
+	struct bpf_prog_info pinned_info;
+	__u32 len = sizeof(pinned_info);
+	struct pinned_obj *obj_node;
+	enum bpf_obj_type objtype;
+	int fd, err = 0;
+
+	if (typeflag != FTW_F)
+		goto out_ret;
+	fd = open_obj_pinned(fpath, true);
+	if (fd < 0)
+		goto out_ret;
+
+	objtype = get_fd_type(fd);
+	if (objtype != build_fn_type)
+		goto out_close;
+
+	memset(&pinned_info, 0, sizeof(pinned_info));
+	if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len))
+		goto out_close;
+
+	obj_node = calloc(1, sizeof(*obj_node));
+	if (!obj_node) {
+		err = -1;
+		goto out_close;
+	}
+
+	obj_node->id = pinned_info.id;
+	obj_node->path = strdup(fpath);
+	if (!obj_node->path) {
+		err = -1;
+		free(obj_node);
+		goto out_close;
+	}
+	hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
+
+out_close:
+	close(fd);
+out_ret:
+	return err;
+}
+
 int build_pinned_obj_table(struct pinned_obj_table *tab,
 			   enum bpf_obj_type type)
 {
-	struct bpf_prog_info pinned_info = {};
-	struct pinned_obj *obj_node = NULL;
-	__u32 len = sizeof(pinned_info);
 	struct mntent *mntent = NULL;
-	enum bpf_obj_type objtype;
 	FILE *mntfile = NULL;
-	FTSENT *ftse = NULL;
-	FTS *fts = NULL;
-	int fd, err;
+	int flags = FTW_PHYS;
+	int nopenfd = 16;
 
 	mntfile = setmntent("/proc/mounts", "r");
 	if (!mntfile)
 		return -1;
 
+	build_fn_table = tab;
+	build_fn_type = type;
+
 	while ((mntent = getmntent(mntfile))) {
-		char *path[] = { mntent->mnt_dir, NULL };
+		char *path = mntent->mnt_dir;
 
 		if (strncmp(mntent->mnt_type, "bpf", 3) != 0)
 			continue;
-
-		fts = fts_open(path, 0, NULL);
-		if (!fts)
-			continue;
-
-		while ((ftse = fts_read(fts))) {
-			if (!(ftse->fts_info & FTS_F))
-				continue;
-			fd = open_obj_pinned(ftse->fts_path, true);
-			if (fd < 0)
-				continue;
-
-			objtype = get_fd_type(fd);
-			if (objtype != type) {
-				close(fd);
-				continue;
-			}
-			memset(&pinned_info, 0, sizeof(pinned_info));
-			err = bpf_obj_get_info_by_fd(fd, &pinned_info, &len);
-			if (err) {
-				close(fd);
-				continue;
-			}
-
-			obj_node = malloc(sizeof(*obj_node));
-			if (!obj_node) {
-				close(fd);
-				fts_close(fts);
-				fclose(mntfile);
-				return -1;
-			}
-
-			memset(obj_node, 0, sizeof(*obj_node));
-			obj_node->id = pinned_info.id;
-			obj_node->path = strdup(ftse->fts_path);
-			hash_add(tab->table, &obj_node->hash, obj_node->id);
-
-			close(fd);
-		}
-		fts_close(fts);
+		if (nftw(path, do_build_table_cb, nopenfd, flags) == -1)
+			break;
 	}
 	fclose(mntfile);
 	return 0;
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index 78d34e860713..e3a79b5a9960 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -152,8 +152,8 @@ int cmd_select(const struct cmd *cmds, int argc, char **argv,
 int get_fd_type(int fd);
 const char *get_fd_type_name(enum bpf_obj_type type);
 char *get_fdinfo(int fd, const char *key);
-int open_obj_pinned(char *path, bool quiet);
-int open_obj_pinned_any(char *path, enum bpf_obj_type exp_type);
+int open_obj_pinned(const char *path, bool quiet);
+int open_obj_pinned_any(const char *path, enum bpf_obj_type exp_type);
 int mount_bpffs_for_pin(const char *name);
 int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(int *, char ***));
 int do_pin_fd(int fd, const char *name);
-- 
2.17.1

