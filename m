Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8EF15156A2
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236842AbiD2VTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 17:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236993AbiD2VTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 17:19:25 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DADBD89CF1
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2f4e28ae604so85682257b3.8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 14:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ZagOx1nrYSXgivvOEfaNRK7mO9pl3Zu616/sPDGflLY=;
        b=VXeoF1i5vUB0MVuOydrigvI8yY5yMhID8g0dRu55Fe0/gNmFiYsuZqWsd3ej3+4LDO
         ObrGhdGZTh5RJpPYm+fo25K5nGgKJvd4OnumB9mUTVOF6vgPYVaqpXITl2cOBb4EIxcm
         xBzxEPYaKg9Q05mYhqRSnw9ZMykbVqZzqOEAzFHAiCYfiBFqYDxQ5xUokgQnV/D5V16f
         rhG8Ai6Wa+R10Pfj/ASjnEBpOm33y6BAXUgJ5+1cjWDl0M6EcS87NTrHpId0tobLWt2V
         co4OEwG36gvHU6u8YRmdEkGZQzx80kZNFyiu4pkc5sIsHbdoZblvHqHFwbSklqx9wqt3
         DCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ZagOx1nrYSXgivvOEfaNRK7mO9pl3Zu616/sPDGflLY=;
        b=j/9NY5yYl2Es26V5ir5lITy1tZq5CbjJMK0hGBBEUcugKgV6T38fSHJnAXX0roOdq5
         AucMIrvgpnxAmefBVkJHwqguMRKWb8Us42Tx0RETkEkyTIxyrXhvyThylvolWA6n2JWH
         nPb2r1D3aJDplECaL0Q/3hyqAV4a3wmWXNgOguFnnT2fBp3oO9lmRUaGUKpI3mxrDayf
         msDOZGSdEh9Ouib1NiPoheejpf0DK86GPzpwZ/TiDHAlJVLapLdsqYqJllX7qVULCOw2
         EUOCTDCupy5Rv4o2PrjV+6POPeaarXh3hxqVEBkabVrPUIQGrBNqk7uOhYT2lQ9UZxKu
         kIRQ==
X-Gm-Message-State: AOAM531NiwAv7qxR1IlTI9ABp6oe44oOEPHrw6b1mZpTs0KymGidyPJ/
        ZBdXbL/uwjHsqz/9WNpk3Bq2F7XutF90/j0m+st1RxjDqjLCEMlPFJAvNJbZdSfcoD3KX/T1ez2
        7ROlG9jw1OejgkwRMFw9L7RwwiJjCJdN3FoBXS7Y7wyawJuAcL7xOxg==
X-Google-Smtp-Source: ABdhPJwE0hopgzV8kiL+RmpyBAi7bi+L3l7HA39CYfgmoByRE3u8sSHBnkjSLYzdqK40/5laHEOnCeI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:b0cc:7605:1029:2d96])
 (user=sdf job=sendgmr) by 2002:a25:cdc7:0:b0:648:f57d:c0ed with SMTP id
 d190-20020a25cdc7000000b00648f57dc0edmr1391857ybf.480.1651266962066; Fri, 29
 Apr 2022 14:16:02 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:15:38 -0700
In-Reply-To: <20220429211540.715151-1-sdf@google.com>
Message-Id: <20220429211540.715151-9-sdf@google.com>
Mime-Version: 1.0
References: <20220429211540.715151-1-sdf@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH bpf-next v6 08/10] bpftool: implement cgroup tree for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ bpftool --nomount prog loadall $KDIR/tools/testing/selftests/bpf/lsm_cgroup.o /sys/fs/bpf/x
$ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_alloc
$ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_bind
$ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_clone
$ bpftool cgroup attach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
$ bpftool cgroup tree
CgroupPath
ID       AttachType      AttachFlags     Name
/sys/fs/cgroup
6        lsm_cgroup                      socket_post_create bpf_lsm_socket_post_create 33733
8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind 33737
10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security 33761
11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone 33772

$ bpftool cgroup detach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
$ bpftool cgroup tree
CgroupPath
ID       AttachType      AttachFlags     Name
/sys/fs/cgroup
8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind 33737
10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security 33761
11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone 33772

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/cgroup.c | 138 +++++++++++++++++++++++++++++--------
 tools/bpf/bpftool/common.c |   1 +
 2 files changed, 112 insertions(+), 27 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index effe136119d7..d271600c76dd 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
+#include <bpf/btf.h>
 
 #include "main.h"
 
@@ -32,6 +33,41 @@
 	"                        sock_release }"
 
 static unsigned int query_flags;
+static struct btf *btf_vmlinux;
+static __u32 bpf_lsm_id[1024];
+static int bpf_lsm_num;
+
+static void load_btf_lsm(void)
+{
+	__u32 i;
+
+	btf_vmlinux = libbpf_find_kernel_btf();
+	if (libbpf_get_error(btf_vmlinux))
+		goto no_btf;
+
+	for (i = 1; i < btf__type_cnt(btf_vmlinux); i++) {
+		const struct btf_type *t = btf__type_by_id(btf_vmlinux, i);
+		const char *name = btf__name_by_offset(btf_vmlinux,
+						       t->name_off);
+
+		if (btf_kind(t) != BTF_KIND_FUNC)
+			continue;
+
+		if (name && strstr(name, "bpf_lsm_") != name)
+			continue;
+
+		bpf_lsm_id[bpf_lsm_num++] = i;
+	}
+
+	if (!bpf_lsm_num)
+		goto no_btf;
+
+	return;
+
+no_btf:
+	bpf_lsm_num = 1;
+	bpf_lsm_id[0] = 0;
+}
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
@@ -48,9 +84,11 @@ static enum bpf_attach_type parse_attach_type(const char *str)
 
 static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			 const char *attach_flags_str,
+			 __u32 attach_btf_id,
 			 int level)
 {
 	char prog_name[MAX_PROG_FULL_NAME];
+	const char *attach_btf_name = NULL;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	int prog_fd;
@@ -64,6 +102,16 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 		return -1;
 	}
 
+	if (attach_btf_id) {
+		if (btf_vmlinux &&
+		    attach_btf_id < btf__type_cnt(btf_vmlinux)) {
+			const struct btf_type *t = btf__type_by_id(btf_vmlinux,
+								   attach_btf_id);
+			attach_btf_name = btf__name_by_offset(btf_vmlinux,
+							      t->name_off);
+		}
+	}
+
 	get_prog_full_name(&info, prog_fd, prog_name, sizeof(prog_name));
 	if (json_output) {
 		jsonw_start_object(json_wtr);
@@ -76,6 +124,10 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 		jsonw_string_field(json_wtr, "attach_flags",
 				   attach_flags_str);
 		jsonw_string_field(json_wtr, "name", prog_name);
+		if (attach_btf_name)
+			jsonw_string_field(json_wtr, "attach_btf_name", attach_btf_name);
+		if (attach_btf_id)
+			jsonw_uint_field(json_wtr, "attach_btf_id", attach_btf_id);
 		jsonw_end_object(json_wtr);
 	} else {
 		printf("%s%-8u ", level ? "    " : "", info.id);
@@ -83,65 +135,82 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			printf("%-15s", attach_type_name[attach_type]);
 		else
 			printf("type %-10u", attach_type);
-		printf(" %-15s %-15s\n", attach_flags_str, prog_name);
+		printf(" %-15s %-15s", attach_flags_str, prog_name);
+		if (attach_btf_name)
+			printf(" %-15s", attach_btf_name);
+		if (attach_btf_id)
+			printf(" %d", attach_btf_id);
+		printf("\n");
 	}
 
 	close(prog_fd);
 	return 0;
 }
 
-static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
+static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
+				    __u32 attach_btf_id)
 {
-	__u32 prog_cnt = 0;
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
 	int ret;
 
-	ret = bpf_prog_query(cgroup_fd, type, query_flags, NULL,
-			     NULL, &prog_cnt);
+	p.query_flags = query_flags;
+	p.attach_btf_id = attach_btf_id;
+
+	ret = bpf_prog_query2(cgroup_fd, type, &p);
 	if (ret)
 		return -1;
 
-	return prog_cnt;
+	return p.prog_cnt;
 }
 
 static int cgroup_has_attached_progs(int cgroup_fd)
 {
 	enum bpf_attach_type type;
 	bool no_prog = true;
+	int i;
 
 	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		int count = count_attached_bpf_progs(cgroup_fd, type);
+		for (i = 0; i < bpf_lsm_num; i++) {
+			int count = count_attached_bpf_progs(cgroup_fd, type, bpf_lsm_id[i]);
 
-		if (count < 0 && errno != EINVAL)
-			return -1;
+			if (count < 0 && errno != EINVAL)
+				return -1;
+
+			if (count > 0) {
+				no_prog = false;
+				break;
+			}
 
-		if (count > 0) {
-			no_prog = false;
-			break;
+			if (type != BPF_LSM_CGROUP)
+				break;
 		}
 	}
 
 	return no_prog ? 0 : 1;
 }
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
-				   int level)
+				   __u32 attach_btf_id, int level)
 {
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
 	const char *attach_flags_str;
 	__u32 prog_ids[1024] = {0};
-	__u32 prog_cnt, iter;
-	__u32 attach_flags;
 	char buf[32];
+	__u32 iter;
 	int ret;
 
-	prog_cnt = ARRAY_SIZE(prog_ids);
-	ret = bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
-			     prog_ids, &prog_cnt);
+	p.attach_btf_id = attach_btf_id;
+	p.query_flags = query_flags;
+	p.prog_cnt = ARRAY_SIZE(prog_ids);
+	p.prog_ids = prog_ids;
+
+	ret = bpf_prog_query2(cgroup_fd, type, &p);
 	if (ret)
 		return ret;
 
-	if (prog_cnt == 0)
+	if (p.prog_cnt == 0)
 		return 0;
 
-	switch (attach_flags) {
+	switch (p.attach_flags) {
 	case BPF_F_ALLOW_MULTI:
 		attach_flags_str = "multi";
 		break;
@@ -152,13 +221,13 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 		attach_flags_str = "";
 		break;
 	default:
-		snprintf(buf, sizeof(buf), "unknown(%x)", attach_flags);
+		snprintf(buf, sizeof(buf), "unknown(%x)", p.attach_flags);
 		attach_flags_str = buf;
 	}
 
-	for (iter = 0; iter < prog_cnt; iter++)
+	for (iter = 0; iter < p.prog_cnt; iter++)
 		show_bpf_prog(prog_ids[iter], type,
-			      attach_flags_str, level);
+			      attach_flags_str, attach_btf_id, level);
 
 	return 0;
 }
@@ -170,6 +239,7 @@ static int do_show(int argc, char **argv)
 	const char *path;
 	int cgroup_fd;
 	int ret = -1;
+	int i;
 
 	query_flags = 0;
 
@@ -221,8 +291,14 @@ static int do_show(int argc, char **argv)
 		 * If we were able to get the show for at least one
 		 * attach type, let's return 0.
 		 */
-		if (show_attached_bpf_progs(cgroup_fd, type, 0) == 0)
-			ret = 0;
+
+		for (i = 0; i < bpf_lsm_num; i++) {
+			if (show_attached_bpf_progs(cgroup_fd, type, bpf_lsm_id[i], 0) == 0)
+				ret = 0;
+
+			if (type != BPF_LSM_CGROUP)
+				break;
+		}
 	}
 
 	if (json_output)
@@ -247,6 +323,7 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 	enum bpf_attach_type type;
 	int has_attached_progs;
 	int cgroup_fd;
+	int i;
 
 	if (typeflag != FTW_D)
 		return 0;
@@ -277,8 +354,14 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		printf("%s\n", fpath);
 	}
 
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++)
-		show_attached_bpf_progs(cgroup_fd, type, ftw->level);
+	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
+		for (i = 0; i < bpf_lsm_num; i++) {
+			show_attached_bpf_progs(cgroup_fd, type, bpf_lsm_id[i], 0);
+
+			if (type != BPF_LSM_CGROUP)
+				break;
+		}
+	}
 
 	if (errno == EINVAL)
 		/* Last attach type does not support query.
@@ -523,5 +606,6 @@ static const struct cmd cmds[] = {
 
 int do_cgroup(int argc, char **argv)
 {
+	load_btf_lsm();
 	return cmd_select(cmds, argc, argv, do_help);
 }
diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
index c740142c24d8..a7a913784c47 100644
--- a/tools/bpf/bpftool/common.c
+++ b/tools/bpf/bpftool/common.c
@@ -66,6 +66,7 @@ const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
 	[BPF_TRACE_FEXIT]		= "fexit",
 	[BPF_MODIFY_RETURN]		= "mod_ret",
 	[BPF_LSM_MAC]			= "lsm_mac",
+	[BPF_LSM_CGROUP]		= "lsm_cgroup",
 	[BPF_SK_LOOKUP]			= "sk_lookup",
 	[BPF_TRACE_ITER]		= "trace_iter",
 	[BPF_XDP_DEVMAP]		= "xdp_devmap",
-- 
2.36.0.464.gb9c8b46e94-goog

