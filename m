Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9901E2664
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 18:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731443AbgEZQEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 12:04:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728016AbgEZQEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 12:04:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590509080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lk1gQon1XbnEb2aWUvf7AESIDMAYoyidTXDr1jZtokM=;
        b=P+cV4lsMPxRRfBmMPRtrYW6DZA1+yzvbp/PRKAv9d0bQD8WZ67+VIqfAtBQoG6ncKVrVGC
        5hDvbU0Ra7bPklLGaItbLZsEo95gslmY3ZXJvuaxrvbP2y7jhcbu1RQv1Vt94fnrt25adO
        DCB4FNFzmCD5vtsDaMMxfvnx2bvzGmQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-W76zC8tsOLeJQWZi0ZmWxg-1; Tue, 26 May 2020 12:04:38 -0400
X-MC-Unique: W76zC8tsOLeJQWZi0ZmWxg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E5E6107ACCA;
        Tue, 26 May 2020 16:04:37 +0000 (UTC)
Received: from renaissance-vector.redhat.com (unknown [10.40.192.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E000B5C1BB;
        Tue, 26 May 2020 16:04:28 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, jhs@mojatatu.com
Subject: [iproute2 PATCH 1/2] Revert "bpf: replace snprintf with asprintf when dealing with long buffers"
Date:   Tue, 26 May 2020 18:04:10 +0200
Message-Id: <78a3cde8ebd319821f43ab7e8343468d895028b4.1590508215.git.aclaudi@redhat.com>
In-Reply-To: <cover.1590508215.git.aclaudi@redhat.com>
References: <cover.1590508215.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit c0325b06382cb4f7ebfaf80c29c8800d74666fd9.
It introduces a segfault in bpf_make_custom_path() when custom pinning is used.

This happens because asprintf allocates exactly the space needed to hold a
string in the buffer passed as its first argument, but if this buffer is later
used in strcat() or similar we have a buffer overrun.

As the aim of commit c0325b06382c is simply to fix a compiler warning, it
seems safe and reasonable to revert it.

Fixes: c0325b06382c ("bpf: replace snprintf with asprintf when dealing with long buffers")
Reported-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
---
 lib/bpf.c | 155 ++++++++++++++----------------------------------------
 1 file changed, 39 insertions(+), 116 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf44419a..23cb0d96a85ba 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -406,21 +406,13 @@ static int bpf_derive_elf_map_from_fdinfo(int fd, struct bpf_elf_map *map,
 					  struct bpf_map_ext *ext)
 {
 	unsigned int val, owner_type = 0, owner_jited = 0;
-	char *file = NULL;
-	char buff[4096];
+	char file[PATH_MAX], buff[4096];
 	FILE *fp;
-	int ret;
 
-	ret = asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		free(file);
-		return ret;
-	}
+	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
 	memset(map, 0, sizeof(*map));
 
 	fp = fopen(file, "r");
-	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
@@ -608,9 +600,8 @@ int bpf_trace_pipe(void)
 		0,
 	};
 	int fd_in, fd_out = STDERR_FILENO;
-	char *tpipe = NULL;
+	char tpipe[PATH_MAX];
 	const char *mnt;
-	int ret;
 
 	mnt = bpf_find_mntpt("tracefs", TRACEFS_MAGIC, tracefs_mnt,
 			     sizeof(tracefs_mnt), tracefs_known_mnts);
@@ -619,15 +610,9 @@ int bpf_trace_pipe(void)
 		return -1;
 	}
 
-	ret = asprintf(&tpipe, "%s/trace_pipe", mnt);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		free(tpipe);
-		return ret;
-	}
+	snprintf(tpipe, sizeof(tpipe), "%s/trace_pipe", mnt);
 
 	fd_in = open(tpipe, O_RDONLY);
-	free(tpipe);
 	if (fd_in < 0)
 		return -1;
 
@@ -648,50 +633,37 @@ int bpf_trace_pipe(void)
 
 static int bpf_gen_global(const char *bpf_sub_dir)
 {
-	char *bpf_glo_dir = NULL;
+	char bpf_glo_dir[PATH_MAX];
 	int ret;
 
-	ret = asprintf(&bpf_glo_dir, "%s/%s/", bpf_sub_dir, BPF_DIR_GLOBALS);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
+	snprintf(bpf_glo_dir, sizeof(bpf_glo_dir), "%s/%s/",
+		 bpf_sub_dir, BPF_DIR_GLOBALS);
 
 	ret = mkdir(bpf_glo_dir, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", bpf_glo_dir,
 			strerror(errno));
-		goto out;
+		return ret;
 	}
 
-	ret = 0;
-out:
-	free(bpf_glo_dir);
-	return ret;
+	return 0;
 }
 
 static int bpf_gen_master(const char *base, const char *name)
 {
-	char *bpf_sub_dir = NULL;
+	char bpf_sub_dir[PATH_MAX + NAME_MAX + 1];
 	int ret;
 
-	ret = asprintf(&bpf_sub_dir, "%s%s/", base, name);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
+	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s/", base, name);
 
 	ret = mkdir(bpf_sub_dir, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", bpf_sub_dir,
 			strerror(errno));
-		goto out;
+		return ret;
 	}
 
-	ret = bpf_gen_global(bpf_sub_dir);
-out:
-	free(bpf_sub_dir);
-	return ret;
+	return bpf_gen_global(bpf_sub_dir);
 }
 
 static int bpf_slave_via_bind_mnt(const char *full_name,
@@ -720,22 +692,13 @@ static int bpf_slave_via_bind_mnt(const char *full_name,
 static int bpf_gen_slave(const char *base, const char *name,
 			 const char *link)
 {
-	char *bpf_lnk_dir = NULL;
-	char *bpf_sub_dir = NULL;
+	char bpf_lnk_dir[PATH_MAX + NAME_MAX + 1];
+	char bpf_sub_dir[PATH_MAX + NAME_MAX];
 	struct stat sb = {};
 	int ret;
 
-	ret = asprintf(&bpf_lnk_dir, "%s%s/", base, link);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
-
-	ret = asprintf(&bpf_sub_dir, "%s%s",  base, name);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
+	snprintf(bpf_lnk_dir, sizeof(bpf_lnk_dir), "%s%s/", base, link);
+	snprintf(bpf_sub_dir, sizeof(bpf_sub_dir), "%s%s",  base, name);
 
 	ret = symlink(bpf_lnk_dir, bpf_sub_dir);
 	if (ret) {
@@ -743,30 +706,25 @@ static int bpf_gen_slave(const char *base, const char *name,
 			if (errno != EPERM) {
 				fprintf(stderr, "symlink %s failed: %s\n",
 					bpf_sub_dir, strerror(errno));
-				goto out;
+				return ret;
 			}
 
-			ret = bpf_slave_via_bind_mnt(bpf_sub_dir, bpf_lnk_dir);
-			goto out;
+			return bpf_slave_via_bind_mnt(bpf_sub_dir,
+						      bpf_lnk_dir);
 		}
 
 		ret = lstat(bpf_sub_dir, &sb);
 		if (ret) {
 			fprintf(stderr, "lstat %s failed: %s\n",
 				bpf_sub_dir, strerror(errno));
-			goto out;
+			return ret;
 		}
 
-		if ((sb.st_mode & S_IFMT) != S_IFLNK) {
-			ret = bpf_gen_global(bpf_sub_dir);
-			goto out;
-		}
+		if ((sb.st_mode & S_IFMT) != S_IFLNK)
+			return bpf_gen_global(bpf_sub_dir);
 	}
 
-out:
-	free(bpf_lnk_dir);
-	free(bpf_sub_dir);
-	return ret;
+	return 0;
 }
 
 static int bpf_gen_hierarchy(const char *base)
@@ -784,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
 static const char *bpf_get_work_dir(enum bpf_prog_type type)
 {
 	static char bpf_tmp[PATH_MAX] = BPF_DIR_MNT;
-	static char *bpf_wrk_dir;
+	static char bpf_wrk_dir[PATH_MAX];
 	static const char *mnt;
 	static bool bpf_mnt_cached;
 	const char *mnt_env = getenv(BPF_ENV_MNT);
@@ -823,12 +781,7 @@ static const char *bpf_get_work_dir(enum bpf_prog_type type)
 		}
 	}
 
-	ret = asprintf(&bpf_wrk_dir, "%s/", mnt);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		free(bpf_wrk_dir);
-		goto out;
-	}
+	snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
 
 	ret = bpf_gen_hierarchy(bpf_wrk_dir);
 	if (ret) {
@@ -1485,48 +1438,31 @@ static int bpf_probe_pinned(const char *name, const struct bpf_elf_ctx *ctx,
 
 static int bpf_make_obj_path(const struct bpf_elf_ctx *ctx)
 {
-	char *tmp = NULL;
+	char tmp[PATH_MAX];
 	int ret;
 
-	ret = asprintf(&tmp, "%s/%s", bpf_get_work_dir(ctx->type), ctx->obj_uid);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
+	snprintf(tmp, sizeof(tmp), "%s/%s", bpf_get_work_dir(ctx->type),
+		 ctx->obj_uid);
 
 	ret = mkdir(tmp, S_IRWXU);
 	if (ret && errno != EEXIST) {
 		fprintf(stderr, "mkdir %s failed: %s\n", tmp, strerror(errno));
-		goto out;
+		return ret;
 	}
 
-	ret = 0;
-out:
-	free(tmp);
-	return ret;
+	return 0;
 }
 
 static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 				const char *todo)
 {
-	char *tmp = NULL;
-	char *rem = NULL;
-	char *sub;
+	char tmp[PATH_MAX], rem[PATH_MAX], *sub;
 	int ret;
 
-	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
-
-	ret = asprintf(&rem, "%s/", todo);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		goto out;
-	}
-
+	snprintf(tmp, sizeof(tmp), "%s/../", bpf_get_work_dir(ctx->type));
+	snprintf(rem, sizeof(rem), "%s/", todo);
 	sub = strtok(rem, "/");
+
 	while (sub) {
 		if (strlen(tmp) + strlen(sub) + 2 > PATH_MAX)
 			return -EINVAL;
@@ -1538,17 +1474,13 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 		if (ret && errno != EEXIST) {
 			fprintf(stderr, "mkdir %s failed: %s\n", tmp,
 				strerror(errno));
-			goto out;
+			return ret;
 		}
 
 		sub = strtok(NULL, "/");
 	}
 
-	ret = 0;
-out:
-	free(rem);
-	free(tmp);
-	return ret;
+	return 0;
 }
 
 static int bpf_place_pinned(int fd, const char *name,
@@ -2655,23 +2587,14 @@ struct bpf_jited_aux {
 
 static int bpf_derive_prog_from_fdinfo(int fd, struct bpf_prog_data *prog)
 {
-	char *file = NULL;
-	char buff[4096];
+	char file[PATH_MAX], buff[4096];
 	unsigned int val;
 	FILE *fp;
-	int ret;
-
-	ret = asprintf(&file, "/proc/%d/fdinfo/%d", getpid(), fd);
-	if (ret < 0) {
-		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
-		free(file);
-		return ret;
-	}
 
+	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
 	memset(prog, 0, sizeof(*prog));
 
 	fp = fopen(file, "r");
-	free(file);
 	if (!fp) {
 		fprintf(stderr, "No procfs support?!\n");
 		return -EIO;
-- 
2.25.4

