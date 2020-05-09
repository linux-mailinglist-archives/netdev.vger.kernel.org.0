Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69E81CC2E0
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEIQw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:52:28 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:38342 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726214AbgEIQw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 12:52:27 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id C1ED32E0DF2;
        Sat,  9 May 2020 19:52:22 +0300 (MSK)
Received: from vla1-81430ab5870b.qloud-c.yandex.net (vla1-81430ab5870b.qloud-c.yandex.net [2a02:6b8:c0d:35a1:0:640:8143:ab5])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id XdwogZeIWl-qMWmaNAC;
        Sat, 09 May 2020 19:52:22 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589043142; bh=8jFLpqTS7drSlAmHwwOWLmMftyzh4hpif5bq1HUzQG0=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=MJQZH00WHvpQNDpGyq2iS/yTFR78QR4SL6sI/WAzh+trZ8ezTEzUBD0iLrqSTzGs5
         9RrZgCUCYOJ37rHLAKa+1DPpJk7KgWzVjYEK6vGU+fL+GbQwLFJcvUx+cI9mV3YRqy
         oJWFV+3zXlPl8VV5V0LHnlMK6GR8a31bitFAH3d0=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.191.33-vpn.dhcp.yndx.net (178.154.191.33-vpn.dhcp.yndx.net [178.154.191.33])
        by vla1-81430ab5870b.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lkcxSGO050-qLXaPCrk;
        Sat, 09 May 2020 19:52:21 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     netdev@vger.kernel.org, dsahern@gmail.com
Cc:     cgroups@vger.kernel.org
Subject: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and helper functions
Date:   Sat,  9 May 2020 19:52:00 +0300
Message-Id: <20200509165202.17959-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch prepares infrastructure for matching sockets by cgroups.
Two helper functions are added for transformation between cgroup v2 ID
and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
This cache is needed for faster lookups of socket cgroup.

v2:
  - style fixes (David Ahern)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
---
 include/cg_map.h |   6 +++
 include/utils.h  |   4 +-
 ip/ipvrf.c       |   4 +-
 lib/Makefile     |   2 +-
 lib/cg_map.c     | 135 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/fs.c         | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 6 files changed, 282 insertions(+), 6 deletions(-)
 create mode 100644 include/cg_map.h
 create mode 100644 lib/cg_map.c

diff --git a/include/cg_map.h b/include/cg_map.h
new file mode 100644
index 0000000..d30517f
--- /dev/null
+++ b/include/cg_map.h
@@ -0,0 +1,6 @@
+#ifndef __CG_MAP_H__
+#define __CG_MAP_H__
+
+const char *cg_id_to_path(__u64 id);
+
+#endif /* __CG_MAP_H__ */
diff --git a/include/utils.h b/include/utils.h
index 001491a..7041c46 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -302,7 +302,9 @@ int get_real_family(int rtm_type, int rtm_family);
 int cmd_exec(const char *cmd, char **argv, bool do_fork,
 	     int (*setup)(void *), void *arg);
 int make_path(const char *path, mode_t mode);
-char *find_cgroup2_mount(void);
+char *find_cgroup2_mount(bool do_mount);
+__u64 get_cgroup2_id(const char *path);
+char *get_cgroup2_path(__u64 id, bool full);
 int get_command_name(const char *pid, char *comm, size_t len);
 
 int get_rtnl_link_stats_rta(struct rtnl_link_stats64 *stats64,
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index b9a4367..28dd8e2 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -225,7 +225,7 @@ static int ipvrf_pids(int argc, char **argv)
 		return -1;
 	}
 
-	mnt = find_cgroup2_mount();
+	mnt = find_cgroup2_mount(true);
 	if (!mnt)
 		return -1;
 
@@ -366,7 +366,7 @@ static int vrf_switch(const char *name)
 		}
 	}
 
-	mnt = find_cgroup2_mount();
+	mnt = find_cgroup2_mount(true);
 	if (!mnt)
 		return -1;
 
diff --git a/lib/Makefile b/lib/Makefile
index bab8cbf..7cba185 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -fPIC
 
 UTILOBJ = utils.o rt_names.o ll_map.o ll_types.o ll_proto.o ll_addr.o \
 	inet_proto.o namespace.o json_writer.o json_print.o \
-	names.o color.o bpf.o exec.o fs.o
+	names.o color.o bpf.o exec.o fs.o cg_map.o
 
 NLOBJ=libgenl.o libnetlink.o
 
diff --git a/lib/cg_map.c b/lib/cg_map.c
new file mode 100644
index 0000000..77f030e
--- /dev/null
+++ b/lib/cg_map.c
@@ -0,0 +1,135 @@
+/*
+ * cg_map.c	cgroup v2 cache
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ *
+ * Authors:	Dmitry Yakunin <zeil@yandex-team.ru>
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <linux/types.h>
+#include <linux/limits.h>
+#include <ftw.h>
+
+#include "cg_map.h"
+#include "list.h"
+#include "utils.h"
+
+struct cg_cache {
+	struct hlist_node id_hash;
+	__u64	id;
+	char	path[];
+};
+
+#define IDMAP_SIZE	1024
+static struct hlist_head id_head[IDMAP_SIZE];
+
+static struct cg_cache *cg_get_by_id(__u64 id)
+{
+	unsigned int h = id & (IDMAP_SIZE - 1);
+	struct hlist_node *n;
+
+	hlist_for_each(n, &id_head[h]) {
+		struct cg_cache *cg;
+
+		cg = container_of(n, struct cg_cache, id_hash);
+		if (cg->id == id)
+			return cg;
+	}
+
+	return NULL;
+}
+
+static struct cg_cache *cg_entry_create(__u64 id, const char *path)
+{
+	unsigned int h = id & (IDMAP_SIZE - 1);
+	struct cg_cache *cg;
+
+	cg = malloc(sizeof(*cg) + strlen(path) + 1);
+	if (!cg) {
+		fprintf(stderr,
+			"Failed to allocate memory for cgroup2 cache entry");
+		return NULL;
+	}
+	cg->id = id;
+	strcpy(cg->path, path);
+
+	hlist_add_head(&cg->id_hash, &id_head[h]);
+
+	return cg;
+}
+
+static int mntlen;
+
+static int nftw_fn(const char *fpath, const struct stat *sb,
+		   int typeflag, struct FTW *ftw)
+{
+	const char *path;
+	__u64 id;
+
+	if (typeflag != FTW_D)
+		return 0;
+
+	id = get_cgroup2_id(fpath);
+	if (!id)
+		return -1;
+
+	path = fpath + mntlen;
+	if (*path == '\0')
+		/* root cgroup */
+		path = "/";
+	if (!cg_entry_create(id, path))
+		return -1;
+
+	return 0;
+}
+
+static void cg_init_map(void)
+{
+	char *mnt;
+
+	mnt = find_cgroup2_mount(false);
+	if (!mnt)
+		exit(1);
+
+	mntlen = strlen(mnt);
+	if (nftw(mnt, nftw_fn, 1024, FTW_MOUNT) < 0)
+		exit(1);
+
+	free(mnt);
+}
+
+const char *cg_id_to_path(__u64 id)
+{
+	static int initialized;
+	static char buf[64];
+
+	const struct cg_cache *cg;
+	char *path;
+
+	if (!initialized) {
+		cg_init_map();
+		initialized = 1;
+	}
+
+	cg = cg_get_by_id(id);
+	if (cg)
+		return cg->path;
+
+	path = get_cgroup2_path(id, false);
+	if (path) {
+		cg = cg_entry_create(id, path);
+		free(path);
+		if (cg)
+			return cg->path;
+	}
+
+	snprintf(buf, sizeof(buf), "unreachable:%llx", id);
+	return buf;
+}
diff --git a/lib/fs.c b/lib/fs.c
index 86efd4e..e265fc0 100644
--- a/lib/fs.c
+++ b/lib/fs.c
@@ -59,13 +59,18 @@ static char *find_fs_mount(const char *fs_to_find)
 }
 
 /* caller needs to free string returned */
-char *find_cgroup2_mount(void)
+char *find_cgroup2_mount(bool do_mount)
 {
 	char *mnt = find_fs_mount(CGROUP2_FS_NAME);
 
 	if (mnt)
 		return mnt;
 
+	if (!do_mount) {
+		fprintf(stderr, "Failed to find cgroup2 mount\n");
+		return NULL;
+	}
+
 	mnt = strdup(MNT_CGRP2_PATH);
 	if (!mnt) {
 		fprintf(stderr, "Failed to allocate memory for cgroup2 path\n");
@@ -74,7 +79,7 @@ char *find_cgroup2_mount(void)
 	}
 
 	if (make_path(mnt, 0755)) {
-		fprintf(stderr, "Failed to setup vrf cgroup2 directory\n");
+		fprintf(stderr, "Failed to setup cgroup2 directory\n");
 		free(mnt);
 		return NULL;
 	}
@@ -99,6 +104,134 @@ out:
 	return mnt;
 }
 
+__u64 get_cgroup2_id(const char *path)
+{
+	char fh_buf[sizeof(struct file_handle) + sizeof(__u64)] = { 0 };
+	struct file_handle *fhp = (struct file_handle *)fh_buf;
+	union {
+		__u64 id;
+		unsigned char bytes[sizeof(__u64)];
+	} cg_id = { .id = 0 };
+	char *mnt = NULL;
+	int mnt_fd = -1;
+	int mnt_id;
+
+	if (!path) {
+		fprintf(stderr, "Invalid cgroup2 path\n");
+		return 0;
+	}
+
+	fhp->handle_bytes = sizeof(__u64);
+	if (name_to_handle_at(AT_FDCWD, path, fhp, &mnt_id, 0) < 0) {
+		/* try at cgroup2 mount */
+
+		while (*path == '/')
+			path++;
+		if (*path == '\0') {
+			fprintf(stderr, "Invalid cgroup2 path\n");
+			goto out;
+		}
+
+		mnt = find_cgroup2_mount(false);
+		if (!mnt)
+			goto out;
+
+		mnt_fd = open(mnt, O_RDONLY);
+		if (mnt_fd < 0) {
+			fprintf(stderr, "Failed to open cgroup2 mount\n");
+			goto out;
+		}
+
+		fhp->handle_bytes = sizeof(__u64);
+		if (name_to_handle_at(mnt_fd, path, fhp, &mnt_id, 0) < 0) {
+			fprintf(stderr, "Failed to get cgroup2 ID: %s\n",
+					strerror(errno));
+			goto out;
+		}
+		if (fhp->handle_bytes != sizeof(__u64)) {
+			fprintf(stderr, "Invalid size of cgroup2 ID\n");
+			goto out;
+		}
+	}
+
+	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));
+
+out:
+	close(mnt_fd);
+	free(mnt);
+
+	return cg_id.id;
+}
+
+#define FILEID_INO32_GEN 1
+
+/* caller needs to free string returned */
+char *get_cgroup2_path(__u64 id, bool full)
+{
+	char fh_buf[sizeof(struct file_handle) + sizeof(__u64)] = { 0 };
+	struct file_handle *fhp = (struct file_handle *)fh_buf;
+	union {
+		__u64 id;
+		unsigned char bytes[sizeof(__u64)];
+	} cg_id = { .id = id };
+	int mnt_fd = -1, fd = -1;
+	char link_buf[PATH_MAX];
+	char *path = NULL;
+	char fd_path[64];
+	int link_len;
+	char *mnt;
+
+	if (!id) {
+		fprintf(stderr, "Invalid cgroup2 ID\n");
+		return NULL;
+	}
+
+	mnt = find_cgroup2_mount(false);
+	if (!mnt)
+		return NULL;
+
+	mnt_fd = open(mnt, O_RDONLY);
+	if (mnt_fd < 0) {
+		fprintf(stderr, "Failed to open cgroup2 mount\n");
+		goto out;
+	}
+
+	fhp->handle_bytes = sizeof(__u64);
+	fhp->handle_type = FILEID_INO32_GEN;
+	memcpy(fhp->f_handle, cg_id.bytes, sizeof(__u64));
+
+	fd = open_by_handle_at(mnt_fd, fhp, 0);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open cgroup2 by ID\n");
+		goto out;
+	}
+
+	snprintf(fd_path, sizeof(fd_path), "/proc/self/fd/%d", fd);
+	link_len = readlink(fd_path, link_buf, sizeof(link_buf) - 1);
+	if (link_len < 0) {
+		fprintf(stderr,
+			"Failed to read value of symbolic link %s\n",
+			fd_path);
+		goto out;
+	}
+	link_buf[link_len] = '\0';
+
+	if (full)
+		path = strdup(link_buf);
+	else
+		path = strdup(link_buf + strlen(mnt));
+	if (!path)
+		fprintf(stderr,
+			"Failed to allocate memory for cgroup2 path\n");
+
+out:
+	close(fd);
+	close(mnt_fd);
+	free(mnt);
+
+	return path;
+}
+
 int make_path(const char *path, mode_t mode)
 {
 	char *dir, *delim;
-- 
2.7.4

