Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35988221BEE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 07:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgGPF3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 01:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPF3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 01:29:49 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFAC6C061755;
        Wed, 15 Jul 2020 22:29:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ls15so4237607pjb.1;
        Wed, 15 Jul 2020 22:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xggW8iaRIpjjsgUhKPAxCf9ytTaJmtsUx10hl+/oMsI=;
        b=jZuL9BXAwT2VrHGdz1Gh9kSGX5iIsxt436+f4NtX5QqfGmGyoGjTiQIIC5uzT9N+Re
         LzK+0VNIKb2XX0neH7gNyMsuhdpi9foMAonCQuyGkd/Yo6+HzVibiS65Dex3F9pf374W
         +SDqpUiE/03SD+pRT0Bs9gmrECVT3IjRDz31+rwrRBCjPMkpZPDj0n8y9i/TzZ1YxBLZ
         sEIU9m/+U15gVBJJNYlsn/H/30RulCYGLBbLCntygjvvCUc2NF+SC5P24/Ib9SqMRk1H
         oGkw8R/mGEjMyezAi8yCu/bwtAw33T6iNKReiN/34hfa9Qwk9jPAC0Oqz6CWEpoYTqzu
         Ajng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xggW8iaRIpjjsgUhKPAxCf9ytTaJmtsUx10hl+/oMsI=;
        b=N7k/+7a6bYs/89VCgvP7omK1zZ7nXpQjRC+EX3+6uzQleNDPIaiJNSkcOyxZBIwP/R
         52zyjO5qs4ZthtvhZLMRHcFPKzKGmICtaiZjx/hTIEpvc6N/HoH5TNondcBFY7fKVU2e
         1b9/JjP4Gshd3la3as8Qk+g6XEXxbVOWAfLbByatJK6gOn4vqn2UzxSkuuEv3FFaFEox
         lx0vCh/Kil0UyOV2kyu0kvkonc2LwH0oj0secLzIkvD40+9Mml6tWzviE/T82kkv9RD3
         uVKasFv3wR5ubI4qP69KbcJGxFt5c0FnZ876pNT7hiHO0ctMj/azUPEur4zHLM22b7rL
         PXEg==
X-Gm-Message-State: AOAM532WqR8u3fMhX2yT6KtwMQfYj+SSpGU4juIBhpRJUij+opQCnWxC
        Y8e1nzFXkon3l8WFS59nS5g=
X-Google-Smtp-Source: ABdhPJzIZHYpo4BSVWNzRlHDhV+MdqGm1xQU7huFWMFuyYcRGFodVpwnhIuKarRiTz6hzGVVXiwrIQ==
X-Received: by 2002:a17:90a:be06:: with SMTP id a6mr3165092pjs.136.1594877388306;
        Wed, 15 Jul 2020 22:29:48 -0700 (PDT)
Received: from ubuntu.lan ([2001:470:e92d:10:ddc5:f9e2:12b8:d43])
        by smtp.gmail.com with ESMTPSA id i67sm3700556pfg.13.2020.07.15.22.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 22:29:47 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2] bpftool: use only nftw for file tree parsing
Date:   Wed, 15 Jul 2020 22:29:26 -0700
Message-Id: <20200716052926.10933-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200715051214.28099-1-Tony.Ambardar () gmail ! com>
References: <20200715051214.28099-1-Tony.Ambardar () gmail ! com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpftool sources include code to walk file trees, but use multiple
frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
is widely available, fts is not conformant and less common, especially on
non-glibc systems. The inconsistent framework usage hampers maintenance
and portability of bpftool, in particular for embedded systems.

Standardize code usage by rewriting one fts-based function to use nftw.
Clean up related function warnings by using "const char *" arguments and
fixing an unsafe call to dirname().

These changes help in building bpftool against musl for OpenWrt.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---

V2:
* use _GNU_SOURCE to pull in getpagesize(), getline(), nftw() definitions
* use "const char *" in open_obj_pinned() and open_obj_pinned_any()
* make dirname() safely act on a string copy

---
 tools/bpf/bpftool/common.c | 129 +++++++++++++++++++++----------------
 tools/bpf/bpftool/main.h   |   4 +-
 2 files changed, 76 insertions(+), 57 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 29f4e7611ae8..7c2e52fc5784 100644
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
@@ -160,24 +161,36 @@ int mount_tracefs(const char *target)
 	return err;
 }
 
-int open_obj_pinned(char *path, bool quiet)
+int open_obj_pinned(const char *path, bool quiet)
 {
-	int fd;
+	char *pname;
+	int fd = -1;
+
+	pname = strdup(path);
+	if (pname == NULL) {
+		if (!quiet)
+			p_err("bpf obj get (%s): %s", path, strerror(errno));
+		goto out_ret;
+	}
+
 
-	fd = bpf_obj_get(path);
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
@@ -367,68 +380,74 @@ void print_hex_data_json(uint8_t *data, size_t len)
 	jsonw_end_array(json_wtr);
 }
 
-int build_pinned_obj_table(struct pinned_obj_table *tab,
-			   enum bpf_obj_type type)
+static struct pinned_obj_table *build_fn_table; /* params for nftw cb*/
+static enum bpf_obj_type build_fn_type;
+
+static int do_build_table_cb(const char *fpath, const struct stat *sb,
+			    int typeflag, struct FTW *ftwbuf)
 {
 	struct bpf_prog_info pinned_info = {};
 	struct pinned_obj *obj_node = NULL;
 	__u32 len = sizeof(pinned_info);
-	struct mntent *mntent = NULL;
 	enum bpf_obj_type objtype;
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
+	if (bpf_obj_get_info_by_fd(fd, &pinned_info, &len)) {
+		p_err("can't get obj info: %s", strerror(errno));
+		goto out_close;
+	}
+
+	obj_node = malloc(sizeof(*obj_node));
+	if (!obj_node) {
+		p_err("mem alloc failed");
+		err = -1;
+		goto out_close;
+	}
+
+	memset(obj_node, 0, sizeof(*obj_node));
+	obj_node->id = pinned_info.id;
+	obj_node->path = strdup(fpath);
+	hash_add(build_fn_table->table, &obj_node->hash, obj_node->id);
+
+out_close:
+	close(fd);
+out_ret:
+	return err;
+}
+
+int build_pinned_obj_table(struct pinned_obj_table *tab,
+			   enum bpf_obj_type type)
+{
+	struct mntent *mntent = NULL;
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

