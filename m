Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A4653AD7D
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 21:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiFATqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 15:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiFATq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 15:46:28 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E549226D378
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 12:40:31 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id a6-20020ac81086000000b002f65fd83048so2078721qtj.6
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 12:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=54T1/nd7Ar1saIFy2CpdsVaApgaxKnLuSaVoh3/JVNg=;
        b=EsVB6lJMtclVqPbqexifhv97yP83q8A4axOhKwR2DHUANB+BWRT6FFcov98WuNhopG
         oNpMYFPILM9nXavQ/1y0QLCrs4sZpXYO5ffpYsE3P4tmEhQiw+rkUaQCzbLFSZkquf0R
         cFzZPGXVtIqQeVpbVAa1RJDO9BMT1nUub9sVu0VfQhG0d8x5kW3d0u/YU+FvvK4Owswc
         iv9q9FUKZuD4P0cmt8yebOoH/+pcHIh4jjKMN5GXexELs+rEg6di9To/19kUDj5BCmz6
         R3l3DJrbeKT5DEjJJ/KMP1Uu2UfB+iTk9yhp9Ryzlunq+TgfqtuhyZmKpXFO7z9K8kKs
         kPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=54T1/nd7Ar1saIFy2CpdsVaApgaxKnLuSaVoh3/JVNg=;
        b=1ayga46o1I+hatH7lZMOSK9Pz/jByidNIJwqsQzSZcRlK0eDnDA3LVj+tNF8fuRjez
         xy5kU64Zy2gQ88bAUr6+8EohiWXGaEpEsGYgrgEMa6NsVsmJu+yt987pCJv+74yF62vL
         VS0iXmznJcmd7tv6DN7a+BlXmzE0z3KqdCr7tGbvIXWKgewMECjCUirsjfxJLTdvr10J
         /1VTclsTkEFyw6OUDNfi1+QqYvn4yy8PrfV2aP9ejLqvbC04bnEuaeMearNBngSO7LFi
         AUCdz2PIN5x/Z6z6+Uf+VYmpfGXiLJ1oawu0wsR0255jtSWmeYOqhfV6sTwSGVcbvw7r
         4ojQ==
X-Gm-Message-State: AOAM5330Qvxj1wa7T/xntjbOelzJdC7O4lHDBrjZQZ0hMfZ/S+5uOLwp
        CNP9uwMlfIy4mjTEJ9MHFnmTk8R00+u5X/HgzeFgViJgGRIi4ElG8a6KILLUPtgQhqnlEiTSquq
        Rb9jpEwBuf8z7/Qp8iz6sr6aNwSK1XwrPAySpPfR6c6BMSjbS1wMLMg==
X-Google-Smtp-Source: ABdhPJzhqupd72QVo6li7D+O80Q6vKMvYXBv7rPylVNJGGcDrbOfonQb0Js94kN26eULVgPAyVaFUdw=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:2310:b0:4fa:7eb1:e855 with SMTP id
 h16-20020a056a00231000b004fa7eb1e855mr1006189pfh.14.1654110155568; Wed, 01
 Jun 2022 12:02:35 -0700 (PDT)
Date:   Wed,  1 Jun 2022 12:02:16 -0700
In-Reply-To: <20220601190218.2494963-1-sdf@google.com>
Message-Id: <20220601190218.2494963-10-sdf@google.com>
Mime-Version: 1.0
References: <20220601190218.2494963-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH bpf-next v8 09/11] bpftool: implement cgroup tree for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/cgroup.c | 79 +++++++++++++++++++++++++++-----------
 1 file changed, 57 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 42421fe47a58..28f0f16b96ce 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
+#include <bpf/btf.h>
 
 #include "main.h"
 
@@ -36,6 +37,7 @@
 	"                        cgroup_inet_sock_release }"
 
 static unsigned int query_flags;
+static struct btf *btf_vmlinux;
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
@@ -69,6 +71,7 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			 int level)
 {
 	char prog_name[MAX_PROG_FULL_NAME];
+	const char *attach_btf_name = NULL;
 	struct bpf_prog_info info = {};
 	const char *attach_type_str;
 	__u32 info_len = sizeof(info);
@@ -84,6 +87,19 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 	}
 
 	attach_type_str = libbpf_bpf_attach_type_str(attach_type);
+
+	if (btf_vmlinux &&
+	    info.attach_btf_id < btf__type_cnt(btf_vmlinux)) {
+		/* Note, we ignore info.attach_btf_obj_id for now. There
+		 * is no good way to resolve btf_id to vmlinux
+		 * or module btf.
+		 */
+		const struct btf_type *t = btf__type_by_id(btf_vmlinux,
+							   info.attach_btf_id);
+		attach_btf_name = btf__name_by_offset(btf_vmlinux,
+						      t->name_off);
+	}
+
 	get_prog_full_name(&info, prog_fd, prog_name, sizeof(prog_name));
 	if (json_output) {
 		jsonw_start_object(json_wtr);
@@ -95,6 +111,10 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
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
@@ -102,7 +122,13 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
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
@@ -144,40 +170,48 @@ static int cgroup_has_attached_progs(int cgroup_fd)
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
 	const char *attach_flags_str;
 	__u32 prog_ids[1024] = {0};
-	__u32 prog_cnt, iter;
-	__u32 attach_flags;
+	__u32 attach_prog_flags[1024] = {0};
 	char buf[32];
+	__u32 iter;
 	int ret;
 
-	prog_cnt = ARRAY_SIZE(prog_ids);
-	ret = bpf_prog_query(cgroup_fd, type, query_flags, &attach_flags,
-			     prog_ids, &prog_cnt);
+	p.query_flags = query_flags;
+	p.prog_cnt = ARRAY_SIZE(prog_ids);
+	p.prog_ids = prog_ids;
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
+		attach_flags = attach_prog_flags[iter] ?: p.attach_flags;
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
@@ -542,5 +576,6 @@ static const struct cmd cmds[] = {
 
 int do_cgroup(int argc, char **argv)
 {
+	btf_vmlinux = libbpf_find_kernel_btf();
 	return cmd_select(cmds, argc, argv, do_help);
 }
-- 
2.36.1.255.ge46751e96f-goog

