Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B635550C3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 18:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376617AbiFVQEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 12:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376350AbiFVQEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 12:04:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C18C393EF
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:07 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id n21-20020a056a000d5500b005251893308cso4064472pfv.6
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 09:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v6cG1jyEcT1cSj2oX/6VN9uABoI6CtQFQ5wJUX56pLw=;
        b=R1pF20KFWgVdJdESzWMosWpDYQW75OaF8aHN8qecCue+gFUKmNMENGNCN/tKXftdjI
         4A6IO1ZiMF5MXcRBRgsaylDaj5jvpFxTPR28r9J+agC46RwukD4PiHSTjq1BmZhqwKxz
         Nt4GLH2itsoHg0h+3Vj7d34IcWJiRbMuN5ZSdSeuB/KebOxhFthhBJW4WaHkjDDcGeMK
         Diq45E0IqVgQJUZm1h3f2ozywtOuxjCHxaHJR0x2CoLv74w/OznMuQzTBXqWS/RwamNr
         qg5Cc5FJ+rv/Kog3sD8E7kCfvvgkADwY243LfHLVfok9IqqWF5hx0qUwjEsOlHVBCnKO
         km8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v6cG1jyEcT1cSj2oX/6VN9uABoI6CtQFQ5wJUX56pLw=;
        b=WdSNEfCe/HIEN/ByQvucDOwiNFwOT1mRFdHW5RVh92wreTgoWaYBsvoOQ+ZXA+tpBx
         H8NwuNpzrMAHRBb5KawOPUq5/G2REZJ9aTxMxTTWSAqlzdakZ8tVns+jovGnuTDdlh7t
         4vUOPOxyWgdERlkod65KZ2pN22c8arcuk84HDAT1uQ9o0TxNO9uSytD3JFj4agcqhKfv
         2U+1mX+RuHo/RBRSc8LlACWrDeDAuWCrC4Xm8j8rvpXOyE0c7Fu8WemmPRBYyvVrJeBn
         y1jXNIi7sAQSOxqeElTQvfdMJkgrY0K6fYiL9bdN2OSozv4zfoBN80OY1k2I0a0HscR6
         AFGg==
X-Gm-Message-State: AJIora8aG2XoCPUFg9+Kgn715fbt+H4GJXyB2E/TsVbJ0RkqHLDUITKF
        cLj1QN5ivJ0HVAajeuISYnApwNNlsRXcwSlaziZL7m6sDBbZPs+FdfEaKQpyBtiXOAxRZPSDRMN
        V7N2JuSspUZ/NJIijXP8/e7WqTaOjSjuM+YPDtkbnxyfevnkYfsA03Q==
X-Google-Smtp-Source: AGRyM1uxm/L866FgJAmwRMl3BkP1C8LGz7sE9Deor91lsea0HWjjqaWcroV4tUW9pqEURVnz01G9mL8=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:e811:b0:16a:22dc:d239 with SMTP id
 u17-20020a170902e81100b0016a22dcd239mr17430569plg.54.1655913846781; Wed, 22
 Jun 2022 09:04:06 -0700 (PDT)
Date:   Wed, 22 Jun 2022 09:03:45 -0700
In-Reply-To: <20220622160346.967594-1-sdf@google.com>
Message-Id: <20220622160346.967594-11-sdf@google.com>
Mime-Version: 1.0
References: <20220622160346.967594-1-sdf@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH bpf-next v10 10/11] bpftool: implement cgroup tree for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
6        lsm_cgroup                      socket_post_create bpf_lsm_socket_post_create
8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone

$ bpftool cgroup detach /sys/fs/cgroup lsm_cgroup pinned /sys/fs/bpf/x/socket_post_create
$ bpftool cgroup tree
CgroupPath
ID       AttachType      AttachFlags     Name
/sys/fs/cgroup
8        lsm_cgroup                      socket_bind     bpf_lsm_socket_bind
10       lsm_cgroup                      socket_alloc    bpf_lsm_sk_alloc_security
11       lsm_cgroup                      socket_clone    bpf_lsm_inet_csk_clone

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/cgroup.c | 109 +++++++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 42421fe47a58..cced668fb2a3 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
+#include <bpf/btf.h>
 
 #include "main.h"
 
@@ -36,6 +37,8 @@
 	"                        cgroup_inet_sock_release }"
 
 static unsigned int query_flags;
+static struct btf *btf_vmlinux;
+static __u32 btf_vmlinux_id;
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
@@ -64,11 +67,38 @@ static enum bpf_attach_type parse_attach_type(const char *str)
 	return __MAX_BPF_ATTACH_TYPE;
 }
 
+static void guess_vmlinux_btf_id(__u32 attach_btf_obj_id)
+{
+	struct bpf_btf_info btf_info = {};
+	__u32 btf_len = sizeof(btf_info);
+	char name[16] = {};
+	int err;
+	int fd;
+
+	btf_info.name = ptr_to_u64(name);
+	btf_info.name_len = sizeof(name);
+
+	fd = bpf_btf_get_fd_by_id(attach_btf_obj_id);
+	if (fd < 0)
+		return;
+
+	err = bpf_obj_get_info_by_fd(fd, &btf_info, &btf_len);
+	if (err)
+		goto out;
+
+	if (btf_info.kernel_btf && strncmp(name, "vmlinux", sizeof(name)) == 0)
+		btf_vmlinux_id = btf_info.id;
+
+out:
+	close(fd);
+}
+
 static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			 const char *attach_flags_str,
 			 int level)
 {
 	char prog_name[MAX_PROG_FULL_NAME];
+	const char *attach_btf_name = NULL;
 	struct bpf_prog_info info = {};
 	const char *attach_type_str;
 	__u32 info_len = sizeof(info);
@@ -84,6 +114,20 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 	}
 
 	attach_type_str = libbpf_bpf_attach_type_str(attach_type);
+
+	if (btf_vmlinux) {
+		if (!btf_vmlinux_id)
+			guess_vmlinux_btf_id(info.attach_btf_obj_id);
+
+		if (btf_vmlinux_id == info.attach_btf_obj_id &&
+		    info.attach_btf_id < btf__type_cnt(btf_vmlinux)) {
+			const struct btf_type *t =
+				btf__type_by_id(btf_vmlinux, info.attach_btf_id);
+			attach_btf_name =
+				btf__name_by_offset(btf_vmlinux, t->name_off);
+		}
+	}
+
 	get_prog_full_name(&info, prog_fd, prog_name, sizeof(prog_name));
 	if (json_output) {
 		jsonw_start_object(json_wtr);
@@ -95,6 +139,10 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 		jsonw_string_field(json_wtr, "attach_flags",
 				   attach_flags_str);
 		jsonw_string_field(json_wtr, "name", prog_name);
+		if (attach_btf_name)
+			jsonw_string_field(json_wtr, "attach_btf_name", attach_btf_name);
+		jsonw_uint_field(json_wtr, "attach_btf_obj_id", info.attach_btf_obj_id);
+		jsonw_uint_field(json_wtr, "attach_btf_id", info.attach_btf_id);
 		jsonw_end_object(json_wtr);
 	} else {
 		printf("%s%-8u ", level ? "    " : "", info.id);
@@ -102,7 +150,13 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			printf("%-15s", attach_type_str);
 		else
 			printf("type %-10u", attach_type);
-		printf(" %-15s %-15s\n", attach_flags_str, prog_name);
+		printf(" %-15s %-15s", attach_flags_str, prog_name);
+		if (attach_btf_name)
+			printf(" %-15s", attach_btf_name);
+		else if (info.attach_btf_id)
+			printf(" attach_btf_obj_id=%d attach_btf_id=%d",
+			       info.attach_btf_obj_id, info.attach_btf_id);
+		printf("\n");
 	}
 
 	close(prog_fd);
@@ -144,40 +198,49 @@ static int cgroup_has_attached_progs(int cgroup_fd)
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
+	__u32 prog_attach_flags[1024] = {0};
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
+	p.query_flags = query_flags;
+	p.prog_cnt = ARRAY_SIZE(prog_ids);
+	p.prog_ids = prog_ids;
+	p.prog_attach_flags = prog_attach_flags;
+
+	ret = bpf_prog_query_opts(cgroup_fd, type, &p);
 	if (ret)
 		return ret;
 
-	if (prog_cnt == 0)
+	if (p.prog_cnt == 0)
 		return 0;
 
-	switch (attach_flags) {
-	case BPF_F_ALLOW_MULTI:
-		attach_flags_str = "multi";
-		break;
-	case BPF_F_ALLOW_OVERRIDE:
-		attach_flags_str = "override";
-		break;
-	case 0:
-		attach_flags_str = "";
-		break;
-	default:
-		snprintf(buf, sizeof(buf), "unknown(%x)", attach_flags);
-		attach_flags_str = buf;
-	}
+	for (iter = 0; iter < p.prog_cnt; iter++) {
+		__u32 attach_flags;
+
+		attach_flags = prog_attach_flags[iter] ?: p.attach_flags;
+
+		switch (attach_flags) {
+		case BPF_F_ALLOW_MULTI:
+			attach_flags_str = "multi";
+			break;
+		case BPF_F_ALLOW_OVERRIDE:
+			attach_flags_str = "override";
+			break;
+		case 0:
+			attach_flags_str = "";
+			break;
+		default:
+			snprintf(buf, sizeof(buf), "unknown(%x)", attach_flags);
+			attach_flags_str = buf;
+		}
 
-	for (iter = 0; iter < prog_cnt; iter++)
 		show_bpf_prog(prog_ids[iter], type,
 			      attach_flags_str, level);
+	}
 
 	return 0;
 }
@@ -233,6 +296,7 @@ static int do_show(int argc, char **argv)
 		printf("%-8s %-15s %-15s %-15s\n", "ID", "AttachType",
 		       "AttachFlags", "Name");
 
+	btf_vmlinux = libbpf_find_kernel_btf();
 	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
 		/*
 		 * Not all attach types may be supported, so it's expected,
@@ -296,6 +360,7 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		printf("%s\n", fpath);
 	}
 
+	btf_vmlinux = libbpf_find_kernel_btf();
 	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++)
 		show_attached_bpf_progs(cgroup_fd, type, ftw->level);
 
-- 
2.37.0.rc0.104.g0611611a94-goog

