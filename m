Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB744ADCA5
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 18:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfIIQF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 12:05:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfIIQF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 12:05:28 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE27B315C01B;
        Mon,  9 Sep 2019 16:05:27 +0000 (UTC)
Received: from renaissance-vector.mxp.redhat.com (unknown [10.32.181.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB50F5C1D8;
        Mon,  9 Sep 2019 16:05:26 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org
Subject: [PATCH iproute2-next] bpf: replace snprintf with asprintf when dealing with long buffers
Date:   Mon,  9 Sep 2019 18:05:05 +0200
Message-Id: <d2631870837a01f1488bf0bd547bb126f24de6b9.1568043463.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 09 Sep 2019 16:05:27 +0000 (UTC)
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
 lib/bpf.c | 95 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 57 insertions(+), 38 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 7d2a322ffbaec..18e0334d3f11b 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -406,13 +406,14 @@ static int bpf_derive_elf_map_from_fdinfo(int fd, struct bpf_elf_map *map,
 					  struct bpf_map_ext *ext)
 {
 	unsigned int val, owner_type = 0, owner_jited = 0;
-	char file[PATH_MAX], buff[4096];
+	char *file, buff[4096];
 	FILE *fp;
 
-	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
 	memset(map, 0, sizeof(*map));
 
 	fp = fopen(file, "r");
+	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
@@ -600,7 +601,7 @@ int bpf_trace_pipe(void)
 		0,
 	};
 	int fd_in, fd_out = STDERR_FILENO;
-	char tpipe[PATH_MAX];
+	char *tpipe;
 	const char *mnt;
 
 	mnt = bpf_find_mntpt("tracefs", TRACEFS_MAGIC, tracefs_mnt,
@@ -610,9 +611,10 @@ int bpf_trace_pipe(void)
 		return -1;
 	}
 
-	snprintf(tpipe, sizeof(tpipe), "%s/trace_pipe", mnt);
+	asprintf(&tpipe, "%s/trace_pipe", mnt);
 
 	fd_in = open(tpipe, O_RDONLY);
+	free(tpipe);
 	if (fd_in < 0)
 		return -1;
 
@@ -633,37 +635,42 @@ int bpf_trace_pipe(void)
 
 static int bpf_gen_global(const char *bpf_sub_dir)
 {
-	char bpf_glo_dir[PATH_MAX];
+	char *bpf_glo_dir;
 	int ret;
 
-	snprintf(bpf_glo_dir, sizeof(bpf_glo_dir), "%s/%s/",
-		 bpf_sub_dir, BPF_DIR_GLOBALS);
+	asprintf(&bpf_glo_dir, "%s/%s/", bpf_sub_dir, BPF_DIR_GLOBALS);
 
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
+	char *bpf_sub_dir;
 	int ret;
 
-	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s/", base, name);
+	asprintf(&bpf_sub_dir, "%s%s/", base, name);
 
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
@@ -692,13 +699,13 @@ static int bpf_slave_via_bind_mnt(const char *full_name,
 static int bpf_gen_slave(const char *base, const char *name,
 			 const char *link)
 {
-	char bpf_lnk_dir[PATH_MAX + NAME_MAX + 1];
-	char bpf_sub_dir[PATH_MAX + NAME_MAX];
+	char *bpf_lnk_dir;
+	char *bpf_sub_dir;
 	struct stat sb = {};
 	int ret;
 
-	snprintf(bpf_lnk_dir, sizeof(bpf_lnk_dir), "%s%s/", base, link);
-	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s",  base, name);
+	asprintf(&bpf_lnk_dir, "%s%s/", base, link);
+	asprintf(&bpf_sub_dir, "%s%s",  base, name);
 
 	ret = symlink(bpf_lnk_dir, bpf_sub_dir);
 	if (ret) {
@@ -706,25 +713,30 @@ static int bpf_gen_slave(const char *base, const char *name,
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
@@ -742,7 +754,7 @@ static int bpf_gen_hierarchy(const char *base)
 static const char *bpf_get_work_dir(enum bpf_prog_type type)
 {
 	static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
-	static char bpf_wrk_dir[PATH_MAX];
+	static char *bpf_wrk_dir;
 	static const char *mnt;
 	static bool bpf_mnt_cached;
 	const char *mnt_env = getenv(BPF_ENV_MNT);
@@ -781,7 +793,7 @@ static const char *bpf_get_work_dir(enum bpf_prog_type type)
 		}
 	}
 
-	snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
+	asprintf(&bpf_wrk_dir, "%s/", mnt);
 
 	ret = bpf_gen_hierarchy(bpf_wrk_dir);
 	if (ret) {
@@ -1438,29 +1450,31 @@ static int bpf_probe_pinned(const char *name, const struct bpf_elf_ctx *ctx,
 
 static int bpf_make_obj_path(const struct bpf_elf_ctx *ctx)
 {
-	char tmp[PATH_MAX];
+	char *tmp;
 	int ret;
 
-	snprintf(tmp, sizeof(tmp), "%s/%s", bpf_get_work_dir(ctx->type),
-		 ctx->obj_uid);
+	asprintf(&tmp, "%s/%s", bpf_get_work_dir(ctx->type), ctx->obj_uid);
 
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
+	char *tmp, *rem, *sub;
 	int ret;
 
-	snprintf(tmp, sizeof(tmp), "%s/../", bpf_get_work_dir(ctx->type));
-	snprintf(rem, sizeof(rem), "%s/", todo);
+	asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
+	asprintf(&rem, "%s/", todo);
 	sub = strtok(rem, "/");
 
 	while (sub) {
@@ -1474,13 +1488,17 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
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
@@ -2581,14 +2599,15 @@ struct bpf_jited_aux {
 
 static int bpf_derive_prog_from_fdinfo(int fd, struct bpf_prog_data *prog)
 {
-	char file[PATH_MAX], buff[4096];
+	char *file, buff[4096];
 	unsigned int val;
 	FILE *fp;
 
-	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
 	memset(prog, 0, sizeof(*prog));
 
 	fp = fopen(file, "r");
+	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
-- 
2.21.0

