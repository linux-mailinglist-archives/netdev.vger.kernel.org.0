Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831E15BF7F4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 09:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiIUHkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 03:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiIUHkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 03:40:04 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0644F275CE;
        Wed, 21 Sep 2022 00:40:00 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MXVcs0hlGzHpmT;
        Wed, 21 Sep 2022 15:37:49 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 21 Sep 2022 15:39:57 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
Subject: [bpf-next v5 1/3] bpftool: Add auto_attach for bpf prog load|loadall
Date:   Wed, 21 Sep 2022 16:00:38 +0800
Message-ID: <1663747240-31210-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add auto_attach optional to support one-step load-attach-pin_link.

For example,
   $ bpftool prog loadall test.o /sys/fs/bpf/test auto_attach

   $ bpftool link
   26: tracing  name test1  tag f0da7d0058c00236  gpl
   	loaded_at 2022-09-09T21:39:49+0800  uid 0
   	xlated 88B  jited 55B  memlock 4096B  map_ids 3
   	btf_id 55
   28: kprobe  name test3  tag 002ef1bef0723833  gpl
   	loaded_at 2022-09-09T21:39:49+0800  uid 0
   	xlated 88B  jited 56B  memlock 4096B  map_ids 3
   	btf_id 55
   57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
   	loaded_at 2022-09-09T21:41:32+0800  uid 0
   	xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
   	btf_id 82

   $ bpftool link
   1: tracing  prog 26
   	prog_type tracing  attach_type trace_fentry
   3: perf_event  prog 28
   10: perf_event  prog 57

The auto_attach optional can support tracepoints, k(ret)probes,
u(ret)probes.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: Quentin Monnet <quentin@isovalent.com>
---
v4 -> v5: some formatting nits of doc
v3 -> v4: rename functions, update doc, bash and do_help()
v2 -> v3: switch to extend prog load command instead of extend perf
v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
 tools/bpf/bpftool/prog.c | 77 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index c81362a..aea0b57 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1453,6 +1453,68 @@ static int do_run(int argc, char **argv)
 	return ret;
 }
 
+static int
+auto_attach_program(struct bpf_program *prog, const char *path)
+{
+	struct bpf_link *link;
+	int err;
+
+	link = bpf_program__attach(prog);
+	err = libbpf_get_error(link);
+	if (err)
+		return err;
+
+	err = bpf_link__pin(link, path);
+	if (err) {
+		bpf_link__destroy(link);
+		return err;
+	}
+	return 0;
+}
+
+static int pathname_concat(const char *path, const char *name, char *buf)
+{
+	int len;
+
+	len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
+	if (len < 0)
+		return -EINVAL;
+	if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	return 0;
+}
+
+static int
+auto_attach_programs(struct bpf_object *obj, const char *path)
+{
+	struct bpf_program *prog;
+	char buf[PATH_MAX];
+	int err;
+
+	bpf_object__for_each_program(prog, obj) {
+		err = pathname_concat(path, bpf_program__name(prog), buf);
+		if (err)
+			goto err_unpin_programs;
+
+		err = auto_attach_program(prog, buf);
+		if (err)
+			goto err_unpin_programs;
+	}
+
+	return 0;
+
+err_unpin_programs:
+	while ((prog = bpf_object__prev_program(obj, prog))) {
+		if (pathname_concat(path, bpf_program__name(prog), buf))
+			continue;
+
+		bpf_program__unpin(prog, buf);
+	}
+
+	return err;
+}
+
 static int load_with_options(int argc, char **argv, bool first_prog_only)
 {
 	enum bpf_prog_type common_prog_type = BPF_PROG_TYPE_UNSPEC;
@@ -1464,6 +1526,7 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 	struct bpf_program *prog = NULL, *pos;
 	unsigned int old_map_fds = 0;
 	const char *pinmaps = NULL;
+	bool auto_attach = false;
 	struct bpf_object *obj;
 	struct bpf_map *map;
 	const char *pinfile;
@@ -1583,6 +1646,9 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 				goto err_free_reuse_maps;
 
 			pinmaps = GET_ARG();
+		} else if (is_prefix(*argv, "auto_attach")) {
+			auto_attach = true;
+			NEXT_ARG();
 		} else {
 			p_err("expected no more arguments, 'type', 'map' or 'dev', got: '%s'?",
 			      *argv);
@@ -1692,14 +1758,20 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
 			goto err_close_obj;
 		}
 
-		err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
+		if (auto_attach)
+			err = auto_attach_program(prog, pinfile);
+		else
+			err = bpf_obj_pin(bpf_program__fd(prog), pinfile);
 		if (err) {
 			p_err("failed to pin program %s",
 			      bpf_program__section_name(prog));
 			goto err_close_obj;
 		}
 	} else {
-		err = bpf_object__pin_programs(obj, pinfile);
+		if (auto_attach)
+			err = auto_attach_programs(obj, pinfile);
+		else
+			err = bpf_object__pin_programs(obj, pinfile);
 		if (err) {
 			p_err("failed to pin all programs");
 			goto err_close_obj;
@@ -2338,6 +2410,7 @@ static int do_help(int argc, char **argv)
 		"                         [type TYPE] [dev NAME] \\\n"
 		"                         [map { idx IDX | name NAME } MAP]\\\n"
 		"                         [pinmaps MAP_DIR]\n"
+		"                         [auto_attach]\n"
 		"       %1$s %2$s attach PROG ATTACH_TYPE [MAP]\n"
 		"       %1$s %2$s detach PROG ATTACH_TYPE [MAP]\n"
 		"       %1$s %2$s run PROG \\\n"
-- 
1.8.3.1

