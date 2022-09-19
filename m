Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12C1E5BC15C
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 04:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiISC2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 22:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiISC2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 22:28:12 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6C914D36;
        Sun, 18 Sep 2022 19:28:09 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MW7ll2ZRDz14QMJ;
        Mon, 19 Sep 2022 10:24:03 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 19 Sep 2022 10:28:06 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <haoluo@google.com>, <jolsa@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <nathan@kernel.org>, <ndesaulniers@google.com>,
        <trix@redhat.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <llvm@lists.linux.dev>
Subject: [bpf-next v3 2/2] selftests/bpf: Add testcases for pinning to errpath
Date:   Mon, 19 Sep 2022 10:48:45 +0800
Message-ID: <1663555725-17016-2-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
References: <1663555725-17016-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add testcases for map and prog pin to errpath.

Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 tools/testing/selftests/bpf/prog_tests/pinning.c   | 67 ++++++++++++++++++++++
 .../selftests/bpf/progs/test_pinning_path.c        | 19 ++++++
 2 files changed, 86 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_path.c

diff --git a/tools/testing/selftests/bpf/prog_tests/pinning.c b/tools/testing/selftests/bpf/prog_tests/pinning.c
index d95cee5..ab7780f 100644
--- a/tools/testing/selftests/bpf/prog_tests/pinning.c
+++ b/tools/testing/selftests/bpf/prog_tests/pinning.c
@@ -24,6 +24,61 @@ __u32 get_map_id(struct bpf_object *obj, const char *name)
 	return map_info.id;
 }
 
+static void test_pin_path(void)
+{
+	const char *progfile = "./test_pinning_path.bpf.o";
+	const char *progpinpath = "/sys/fs/bpf/test_pinpath";
+	char errpath[PATH_MAX + 1];
+	char command[64];
+	int prog_fd, err;
+	struct bpf_object *obj;
+	__u32 duration = 0;
+
+	/* Use libbpf 1.0 API mode */
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+
+	err = bpf_prog_test_load(progfile, BPF_PROG_TYPE_SOCK_OPS, &obj,
+				 &prog_fd);
+	CHECK(err, "bpf_prog_test_load", "err %d errno %d\n", err, errno);
+
+	memset(&errpath, 't', PATH_MAX);
+	err = bpf_object__pin_maps(obj, errpath);
+	if (CHECK(err != -ENAMETOOLONG, "pin maps errpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__pin_maps(obj, progpinpath);
+	if (CHECK(err, "pin maps", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__pin_programs(obj, errpath);
+	if (CHECK(err != -ENAMETOOLONG, "pin progs errpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__pin_programs(obj, progpinpath);
+	if (CHECK(err, "pin prog", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__unpin_programs(obj, errpath);
+	if (CHECK(err != -ENAMETOOLONG, "pin progs errpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__unpin_programs(obj, progpinpath);
+	if (CHECK(err, "pin prog", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__unpin_maps(obj, errpath);
+	if (CHECK(err != -ENAMETOOLONG, "pin maps errpath", "err %d errno %d\n", err, errno))
+		goto out;
+
+	err = bpf_object__unpin_maps(obj, progpinpath);
+	if (CHECK(err, "pin maps", "err %d errno %d\n", err, errno))
+		goto out;
+out:
+	bpf_object__close(obj);
+	sprintf(command, "rm -r %s", progpinpath);
+	system(command);
+}
+
 void test_pinning(void)
 {
 	const char *file_invalid = "./test_pinning_invalid.bpf.o";
@@ -32,6 +87,7 @@ void test_pinning(void)
 	const char *nopinpath2 = "/sys/fs/bpf/nopinmap2";
 	const char *custpath = "/sys/fs/bpf/custom";
 	const char *pinpath = "/sys/fs/bpf/pinmap";
+	char errpath[PATH_MAX + 1];
 	const char *file = "./test_pinning.bpf.o";
 	__u32 map_id, map_id2, duration = 0;
 	struct stat statbuf = {};
@@ -206,7 +262,17 @@ void test_pinning(void)
 
 	bpf_object__close(obj);
 
+	/* test auto-pinning at err path with open opt */
+	memset(&errpath, 't', PATH_MAX);
+	opts.pin_root_path = errpath;
+	obj = bpf_object__open_file(file, &opts);
+	if (CHECK_FAIL(libbpf_get_error(obj) != -ENAMETOOLONG)) {
+		obj = NULL;
+		goto out;
+	}
+
 	/* test auto-pinning at custom path with open opt */
+	opts.pin_root_path = custpath;
 	obj = bpf_object__open_file(file, &opts);
 	if (CHECK_FAIL(libbpf_get_error(obj))) {
 		obj = NULL;
@@ -277,4 +343,5 @@ void test_pinning(void)
 	rmdir(custpath);
 	if (obj)
 		bpf_object__close(obj);
+	test_pin_path();
 }
diff --git a/tools/testing/selftests/bpf/progs/test_pinning_path.c b/tools/testing/selftests/bpf/progs/test_pinning_path.c
new file mode 100644
index 0000000..b4e2099
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_pinning_path.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKHASH);
+	__uint(max_entries, 64);
+	__type(key, __u32);
+	__type(value, __u64);
+} sock_ops_map SEC(".maps");
+
+SEC("sockops")
+int bpf_sockmap(struct bpf_sock_ops *skops)
+{
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
1.8.3.1

