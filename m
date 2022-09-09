Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80C65B2E36
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 07:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiIIFmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 01:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIIFmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 01:42:09 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70A49DB79;
        Thu,  8 Sep 2022 22:42:07 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MP4XQ3kjdzlVsY;
        Fri,  9 Sep 2022 13:38:14 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 9 Sep 2022 13:42:04 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <quentin@isovalent.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <martin.lau@linux.dev>, <song@kernel.org>,
        <yhs@fb.com>, <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <sdf@google.com>, <haoluo@google.com>, <jolsa@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <hawk@kernel.org>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
Subject: [bpf-next v3 1/2] bpftool: Add auto_attach for bpf prog load|loadall
Date:   Fri, 9 Sep 2022 13:53:26 +0800
Message-ID: <1662702807-591-1-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---
v2 -> v3: switch to extend prog load command instead of extend perf
v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
 tools/bpf/bpftool/prog.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index c81362a..853a73e 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1453,6 +1453,68 @@ static int do_run(int argc, char **argv)
 	return ret;
 }
 
+static int
+do_prog_attach_pin(struct bpf_program *prog, const char *path)
+{
+	struct bpf_link *link = NULL;
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
+	else if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	return 0;
+}
+
+static int
+do_obj_attach_pin_programs(struct bpf_object *obj, const char *path)
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
+		err = do_prog_attach_pin(prog, buf);
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
+			err = do_prog_attach_pin(prog, pinfile);
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
+			err = do_obj_attach_pin_programs(obj, pinfile);
+		else
+			err = bpf_object__pin_programs(obj, pinfile);
 		if (err) {
 			p_err("failed to pin all programs");
 			goto err_close_obj;
-- 
1.8.3.1

