Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 208A852C6EF
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 00:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiERW5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 18:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiERW4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 18:56:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5854DEE17
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:53 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2fee45054e4so31548787b3.3
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=knOwqSOW31Ie0Fuq80BKQny6u/Lt1IZLhkkqp6zZQx4=;
        b=Mkyz7ymmDrj+BrhPafFLqizriAnmJXE/Fcwu6h5I29nd4q4Fz2n+2yHk2e+yh6+NDO
         jkBFgsdOhByNjfpiK+KNTGCc6kQfRSkXi30vqmAEZklc/sfXWEM12A3s1mNpzTMbO6rm
         oBJk59+S8Z9RAGqiXHQ1AXgE2FOvFpYZcXc3LHpPllIyH1h+iRSR3RiYMs2tvy0kSmV4
         iVNyuDEhDuS8lEz6qKiaHUZCMkektchCjYgV6TvEI8w6Iq3Ld21zO5OO8SVKGWOyCwqL
         IV9VytcAJxcYj5LZco5NWEUMAmKQGilcbqsD4MUUb26flu4sHMN1VpE/cej7DGs230a0
         uNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=knOwqSOW31Ie0Fuq80BKQny6u/Lt1IZLhkkqp6zZQx4=;
        b=wbHIS1MHcnI/54+fGjJXGhV05yOLI7nybEwroRBWkFQajc7R1eCG5tfB2aLsQ7OQGo
         Uo/O2UhjByAW7iYWIJ2Y5LBPi/8BCFZwasmPGlCw0dXq8KkMYiUO5B2ilQWo5L0lJma5
         3F7SgaR0/11le8PUCa9qERXSeT0nFiPPizp3WGWNFUo+5QWfuMqgkCVTVUqfmGHB8ZmG
         4IEsh+QQmjbPWDTrPluobBFnfPQE8vaT4/hcUh+DUBQo/WPcxTjq+fPqkAXw9zoXpIlI
         3R3C+I0XzdGK57WutQL9w9N0H2LIVsxbAb8QwofbhU57eg+7pta8AToiquVj6izPx9oI
         v9+g==
X-Gm-Message-State: AOAM533blJHlB4sJsGRx9IjlhKeTo3xULzZSqhwNq70R+UtGBDtpr0ey
        Da2esXNgL94Hd7QPXf2SHCwCw6W1I1DWS9X9QK8DKplkNDp8/NlqobTO61mBQfJWWC3PSlJ68dP
        O5qAwDlugDRTC6/m/CE6fDeLHw2o7Sa4BkdVXO4BRdaILfBuP1l1lLg==
X-Google-Smtp-Source: ABdhPJw1bsvSuzsbFqWS7c+/XrBkgY8riIHfe3TrtWZLMCNYdBlz6+GwAG0qMcZAF64ABuob4k3Rg6Y=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:f763:3448:2567:bf00])
 (user=sdf job=sendgmr) by 2002:a25:4d4:0:b0:64d:8131:74fc with SMTP id
 203-20020a2504d4000000b0064d813174fcmr1684459ybe.608.1652914552605; Wed, 18
 May 2022 15:55:52 -0700 (PDT)
Date:   Wed, 18 May 2022 15:55:29 -0700
In-Reply-To: <20220518225531.558008-1-sdf@google.com>
Message-Id: <20220518225531.558008-10-sdf@google.com>
Mime-Version: 1.0
References: <20220518225531.558008-1-sdf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH bpf-next v7 09/11] bpftool: implement cgroup tree for BPF_LSM_CGROUP
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
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

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/bpf/bpftool/cgroup.c | 77 +++++++++++++++++++++++++++-----------
 tools/bpf/bpftool/common.c |  1 +
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index effe136119d7..23e2d8a21e28 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -15,6 +15,7 @@
 #include <unistd.h>
 
 #include <bpf/bpf.h>
+#include <bpf/btf.h>
 
 #include "main.h"
 
@@ -32,6 +33,7 @@
 	"                        sock_release }"
 
 static unsigned int query_flags;
+static struct btf *btf_vmlinux;
 
 static enum bpf_attach_type parse_attach_type(const char *str)
 {
@@ -51,6 +53,7 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			 int level)
 {
 	char prog_name[MAX_PROG_FULL_NAME];
+	const char *attach_btf_name = NULL;
 	struct bpf_prog_info info = {};
 	__u32 info_len = sizeof(info);
 	int prog_fd;
@@ -64,6 +67,18 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 		return -1;
 	}
 
+	if (btf_vmlinux &&
+	    info.attach_btf_func_id < btf__type_cnt(btf_vmlinux)) {
+		/* Note, we ignore info.btf_id for now. There
+		 * is no good way to resolve btf_id to vmlinux
+		 * or module btf.
+		 */
+		const struct btf_type *t = btf__type_by_id(btf_vmlinux,
+							   info.attach_btf_func_id);
+		attach_btf_name = btf__name_by_offset(btf_vmlinux,
+						      t->name_off);
+	}
+
 	get_prog_full_name(&info, prog_fd, prog_name, sizeof(prog_name));
 	if (json_output) {
 		jsonw_start_object(json_wtr);
@@ -76,6 +91,10 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 		jsonw_string_field(json_wtr, "attach_flags",
 				   attach_flags_str);
 		jsonw_string_field(json_wtr, "name", prog_name);
+		if (attach_btf_name)
+			jsonw_string_field(json_wtr, "attach_btf_name", attach_btf_name);
+		jsonw_uint_field(json_wtr, "btf_id", info.btf_id);
+		jsonw_uint_field(json_wtr, "attach_btf_func_id", info.attach_btf_func_id);
 		jsonw_end_object(json_wtr);
 	} else {
 		printf("%s%-8u ", level ? "    " : "", info.id);
@@ -83,7 +102,12 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			printf("%-15s", attach_type_name[attach_type]);
 		else
 			printf("type %-10u", attach_type);
-		printf(" %-15s %-15s\n", attach_flags_str, prog_name);
+		printf(" %-15s %-15s", attach_flags_str, prog_name);
+		if (attach_btf_name)
+			printf(" %-15s", attach_btf_name);
+		else if (info.attach_btf_func_id)
+			printf(" btf_id=%d btf_func_id=%d", info.btf_id, info.attach_btf_func_id);
+		printf("\n");
 	}
 
 	close(prog_fd);
@@ -125,40 +149,48 @@ static int cgroup_has_attached_progs(int cgroup_fd)
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
@@ -523,5 +555,6 @@ static const struct cmd cmds[] = {
 
 int do_cgroup(int argc, char **argv)
 {
+	btf_vmlinux = libbpf_find_kernel_btf();
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
2.36.1.124.g0e6072fb45-goog

