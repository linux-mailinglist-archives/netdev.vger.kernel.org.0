Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC47220443
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 07:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGOFNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 01:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgGOFNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 01:13:04 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BD9C061755;
        Tue, 14 Jul 2020 22:13:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q17so1545392pfu.8;
        Tue, 14 Jul 2020 22:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/AUgaV//mu/IhyWO8XOKIplPZQ8poyjpSJ406HJn+YY=;
        b=p7611sWYcFs4qiTaZw3FQX2esZt0IjdJcebtSeVlnpfUkMKxWz+f71cE3reh8Pmo/f
         MSoefRwXanV9N5KbAbNgGvVCea6xBB7csefoPcsmHygozc+a6/UY13W+6L3UqAy/8XI+
         Sz97KQKrGiVSRt9LqIFg9EfdQzGXCe9/0hAzwt0kZk0dRt7i4a5Cn9dons8M1CmVD0EQ
         F9SoIngKoE4NE7C7ZfNTLSuh7PeTrj2z6yGFbTw5GuGVMb8TNKVdCooYIch5yOGttGeb
         6B71Oti/1BWmgoa7+FvDT6z5oJlDBATiESuiRg6T936jC++K3vqGmc7j17hykEeC5Qwv
         GvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/AUgaV//mu/IhyWO8XOKIplPZQ8poyjpSJ406HJn+YY=;
        b=kPCnn6ZiffMjMVC2KDIb5KNocEC3pYhMJrsRqzZboJI+OAdZKfGXuc9s89s8OwYWe/
         MguS672Uch1cQpEfdQ0Lo3+tirpXi+K1kMTr6km/vAD7YfZ0ItiyI8/TPcFSeZ4MxURl
         /PNZ7I6zS5bWWBx27JkTruwSuDW5lYHk/XSh25dsienzEK3Ont9k74dGOzcAg8dp6Txy
         igOxp8AGdqdYhRcktBwJ2+t1hFpnkbbeqs/6qHBdfJamz2IBkVwdQOztllpVqmnzdceC
         383nmJHR3Qu4iQJ/K29IX25npZRHKQQ/nvW2HU8RTIOpZYprCtum5DANVp4nVygZODv4
         LdrQ==
X-Gm-Message-State: AOAM532typQrMKO/N1vUlxK4XubYCrqP63HgVlFsomZRP0P2BzBj0+VF
        AAZsAXLF+rohmq4OoPSBFQu497RSib4=
X-Google-Smtp-Source: ABdhPJzyTw6d5Q5WfyEsh2b/E7lJiVQ8w3Nb96jVSH6KzfQgSI1UuNoL6pT9Mgeajb701TLPYWrAtQ==
X-Received: by 2002:a63:2946:: with SMTP id p67mr6565230pgp.227.1594789982569;
        Tue, 14 Jul 2020 22:13:02 -0700 (PDT)
Received: from ubuntu.lan ([2001:470:e92d:10:6551:7fa7:cd6f:d69])
        by smtp.gmail.com with ESMTPSA id u23sm816034pgn.26.2020.07.14.22.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 22:13:02 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Tony Ambardar <Tony.Ambardar@gmail.com>
Subject: [PATCH bpf-next] bpftool: use only nftw for file tree parsing
Date:   Tue, 14 Jul 2020 22:12:14 -0700
Message-Id: <20200715051214.28099-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpftool sources include code to walk file trees, but use multiple
frameworks to do so: nftw and fts. While nftw conforms to POSIX/SUSv3 and
is widely available, fts is not conformant and less common, especially on
non-glibc systems. The inconsistent framework usage hampers maintenance
and portability of bpftool, in particular for embedded systems.

Standardize usage by rewriting one fts-based function to use nftw. This
change allows building bpftool against musl for OpenWrt.

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 tools/bpf/bpftool/common.c | 102 ++++++++++++++++++++-----------------
 1 file changed, 54 insertions(+), 48 deletions(-)

diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index 29f4e7611ae8..765de99770fb 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -4,7 +4,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <fcntl.h>
-#include <fts.h>
+#include <ftw.h>
 #include <libgen.h>
 #include <mntent.h>
 #include <stdbool.h>
@@ -367,68 +367,74 @@ void print_hex_data_json(uint8_t *data, size_t len)
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
-- 
2.17.1

