Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD31B3ADC
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 14:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbfIPM7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 08:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfIPM7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Sep 2019 08:59:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 11961CA380;
        Mon, 16 Sep 2019 12:59:54 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 388AF1D9;
        Mon, 16 Sep 2019 12:59:53 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next v2] bpf: replace snprintf with asprintf when dealing with long buffers
Date:   Mon, 16 Sep 2019 15:00:55 +0200
Message-Id: <c25efdff9a67ed4bc23862d0ef4ff8073de69c4e.1568638725.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 16 Sep 2019 12:59:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reduces stack usage, as asprintf allocates memory on the heap.

This indirectly fixes a snprintf truncation warning (from gcc v9.2.1):

bpf.c: In function ‘bpf_get_work_dir’:
bpf.c:784:49: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |                                                 ^
bpf.c:784:2: note: ‘snprintf’ output between 2 and 4097 bytes into a destination of size 4096
  784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: e42256699cac ("bpf: make tc's bpf loader generic and move into lib")
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf.c | 155 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 116 insertions(+), 39 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 7d2a322ffbaec..0fe2e9eb2cbf8 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -406,13 +406,21 @@ static int bpf_derive_elf_map_from_fdinfo(int fd, struct bpf_elf_map *map,
 					  struct bpf_map_ext *ext)
 {
 	unsigned int val, owner_type = 0, owner_jited = 0;
-	char file[PATH_MAX], buff[4096];
+	char *file = NULL;
+	char buff[4096];
 	FILE *fp;
+	int ret;
 
-	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	ret = asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		free(file);
+		return ret;
+	}
 	memset(map, 0, sizeof(*map));
 
 	fp = fopen(file, "r");
+	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
@@ -600,8 +608,9 @@ int bpf_trace_pipe(void)
 		0,
 	};
 	int fd_in, fd_out = STDERR_FILENO;
-	char tpipe[PATH_MAX];
+	char *tpipe = NULL;
 	const char *mnt;
+	int ret;
 
 	mnt = bpf_find_mntpt("tracefs", TRACEFS_MAGIC, tracefs_mnt,
 			     sizeof(tracefs_mnt), tracefs_known_mnts);
@@ -610,9 +619,15 @@ int bpf_trace_pipe(void)
 		return -1;
 	}
 
-	snprintf(tpipe, sizeof(tpipe), "%s/trace_pipe", mnt);
+	ret = asprintf(&tpipe, "%s/trace_pipe", mnt);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		free(tpipe);
+		return ret;
+	}
 
 	fd_in = open(tpipe, O_RDONLY);
+	free(tpipe);
 	if (fd_in < 0)
 		return -1;
 
@@ -633,37 +648,50 @@ int bpf_trace_pipe(void)
 
 static int bpf_gen_global(const char *bpf_sub_dir)
 {
-	char bpf_glo_dir[PATH_MAX];
+	char *bpf_glo_dir = NULL;
 	int ret;
 
-	snprintf(bpf_glo_dir, sizeof(bpf_glo_dir), "%s/%s/",
-		 bpf_sub_dir, BPF_DIR_GLOBALS);
+	ret = asprintf(&bpf_glo_dir, "%s/%s/", bpf_sub_dir, BPF_DIR_GLOBALS);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
 
 	ret = mkdir(bpf_glo_dir, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", bpf_glo_dir,
 			strerror(errno));
-		return ret;
+		goto out;
 	}
 
-	return 0;
+	ret = 0;
+out:
+	free(bpf_glo_dir);
+	return ret;
 }
 
 static int bpf_gen_master(const char *base, const char *name)
 {
-	char bpf_sub_dir[PATH_MAX + NAME_MAX + 1];
+	char *bpf_sub_dir = NULL;
 	int ret;
 
-	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s/", base, name);
+	ret = asprintf(&bpf_sub_dir, "%s%s/", base, name);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
 
 	ret = mkdir(bpf_sub_dir, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", bpf_sub_dir,
 			strerror(errno));
-		return ret;
+		goto out;
 	}
 
-	return bpf_gen_global(bpf_sub_dir);
+	ret = bpf_gen_global(bpf_sub_dir);
+out:
+	free(bpf_sub_dir);
+	return ret;
 }
 
 static int bpf_slave_via_bind_mnt(const char *full_name,
@@ -692,13 +720,22 @@ static int bpf_slave_via_bind_mnt(const char *full_name,
 static int bpf_gen_slave(const char *base, const char *name,
 			 const char *link)
 {
-	char bpf_lnk_dir[PATH_MAX + NAME_MAX + 1];
-	char bpf_sub_dir[PATH_MAX + NAME_MAX];
+	char *bpf_lnk_dir = NULL;
+	char *bpf_sub_dir = NULL;
 	struct stat sb = {};
 	int ret;
 
-	snprintf(bpf_lnk_dir, sizeof(bpf_lnk_dir), "%s%s/", base, link);
-	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s",  base, name);
+	ret = asprintf(&bpf_lnk_dir, "%s%s/", base, link);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	ret = asprintf(&bpf_sub_dir, "%s%s",  base, name);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
 
 	ret = symlink(bpf_lnk_dir, bpf_sub_dir);
 	if (ret) {
@@ -706,25 +743,30 @@ static int bpf_gen_slave(const char *base, const char *name,
 			if (errno != EPERM) {
 				fprintf(stderr, "symlink %s failed: %s\n",
 					bpf_sub_dir, strerror(errno));
-				return ret;
+				goto out;
 			}
 
-			return bpf_slave_via_bind_mnt(bpf_sub_dir,
-						      bpf_lnk_dir);
+			ret = bpf_slave_via_bind_mnt(bpf_sub_dir, bpf_lnk_dir);
+			goto out;
 		}
 
 		ret = lstat(bpf_sub_dir, &sb);
 		if (ret) {
 			fprintf(stderr, "lstat %s failed: %s\n",
 				bpf_sub_dir, strerror(errno));
-			return ret;
+			goto out;
 		}
 
-		if ((sb.st_mode & S_IFMT) != S_IFLNK)
-			return bpf_gen_global(bpf_sub_dir);
+		if ((sb.st_mode & S_IFMT) != S_IFLNK) {
+			ret = bpf_gen_global(bpf_sub_dir);
+			goto out;
+		}
 	}
 
-	return 0;
+out:
+	free(bpf_lnk_dir);
+	free(bpf_sub_dir);
+	return ret;
 }
 
 static int bpf_gen_hierarchy(const char *base)
@@ -742,7 +784,7 @@ static int bpf_gen_hierarchy(const char *base)
 static const char *bpf_get_work_dir(enum bpf_prog_type type)
 {
 	static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
-	static char bpf_wrk_dir[PATH_MAX];
+	static char *bpf_wrk_dir;
 	static const char *mnt;
 	static bool bpf_mnt_cached;
 	const char *mnt_env = getenv(BPF_ENV_MNT);
@@ -781,7 +823,12 @@ static const char *bpf_get_work_dir(enum bpf_prog_type type)
 		}
 	}
 
-	snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
+	ret = asprintf(&bpf_wrk_dir, "%s/", mnt);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		free(bpf_wrk_dir);
+		goto out;
+	}
 
 	ret = bpf_gen_hierarchy(bpf_wrk_dir);
 	if (ret) {
@@ -1438,31 +1485,48 @@ static int bpf_probe_pinned(const char *name, const struct bpf_elf_ctx *ctx,
 
 static int bpf_make_obj_path(const struct bpf_elf_ctx *ctx)
 {
-	char tmp[PATH_MAX];
+	char *tmp = NULL;
 	int ret;
 
-	snprintf(tmp, sizeof(tmp), "%s/%s", bpf_get_work_dir(ctx->type),
-		 ctx->obj_uid);
+	ret = asprintf(&tmp, "%s/%s", bpf_get_work_dir(ctx->type), ctx->obj_uid);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
 
 	ret = mkdir(tmp, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", tmp, strerror(errno));
-		return ret;
+		goto out;
 	}
 
-	return 0;
+	ret = 0;
+out:
+	free(tmp);
+	return ret;
 }
 
 static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 				const char *todo)
 {
-	char tmp[PATH_MAX], rem[PATH_MAX], *sub;
+	char *tmp = NULL;
+	char *rem = NULL;
+	char *sub;
 	int ret;
 
-	snprintf(tmp, sizeof(tmp), "%s/../", bpf_get_work_dir(ctx->type));
-	snprintf(rem, sizeof(rem), "%s/", todo);
-	sub = strtok(rem, "/");
+	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
 
+	ret = asprintf(&rem, "%s/", todo);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		goto out;
+	}
+
+	sub = strtok(rem, "/");
 	while (sub) {
 		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
 			return -EINVAL;
@@ -1474,13 +1538,17 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 		if (ret && errno != EEXIST) {
 			fprintf(stderr, "mkdir %s failed: %s\n", tmp,
 				strerror(errno));
-			return ret;
+			goto out;
 		}
 
 		sub = strtok(NULL, "/");
 	}
 
-	return 0;
+	ret = 0;
+out:
+	free(rem);
+	free(tmp);
+	return ret;
 }
 
 static int bpf_place_pinned(int fd, const char *name,
@@ -2581,14 +2649,23 @@ struct bpf_jited_aux {
 
 static int bpf_derive_prog_from_fdinfo(int fd, struct bpf_prog_data *prog)
 {
-	char file[PATH_MAX], buff[4096];
+	char *file = NULL;
+	char buff[4096];
 	unsigned int val;
 	FILE *fp;
+	int ret;
+
+	ret = asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
+	if (ret < 0) {
+		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
+		free(file);
+		return ret;
+	}
 
-	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
 	memset(prog, 0, sizeof(*prog));
 
 	fp = fopen(file, "r");
+	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
-- 
2.21.0

