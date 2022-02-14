Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53A8A4B4DC9
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350686AbiBNLS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:18:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350676AbiBNLST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:18:19 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C7C66218;
        Mon, 14 Feb 2022 02:51:31 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Jy1BQ3P6SzZfdl;
        Mon, 14 Feb 2022 18:47:10 +0800 (CST)
Received: from huawei.com (10.175.112.60) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 18:51:29 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [RFC PATCH bpf-next v2 2/3] selftests/bpf: add a simple test for htab str key
Date:   Mon, 14 Feb 2022 19:13:36 +0800
Message-ID: <20220214111337.3539-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220214111337.3539-1-houtao1@huawei.com>
References: <20220214111337.3539-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.112.60]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test to demonstrate that str key doesn't care about
the content of unused part in hash-table key.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/str_key.c        | 71 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/str_key.c   | 75 +++++++++++++++++++
 2 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/str_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/str_key.c

diff --git a/tools/testing/selftests/bpf/prog_tests/str_key.c b/tools/testing/selftests/bpf/prog_tests/str_key.c
new file mode 100644
index 000000000000..998f12f8b919
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/str_key.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <test_progs.h>
+#include "str_key.skel.h"
+
+#define HTAB_NAME_SIZE 64
+
+struct str_htab_key {
+	struct bpf_str_key_stor name;
+	char raw[HTAB_NAME_SIZE];
+};
+
+static int setup_maps(struct str_key *skel, const char *name, unsigned int value)
+{
+	struct str_htab_key key;
+	int fd, err;
+
+	memset(&key, 0, sizeof(key));
+	strncpy(key.raw, name, sizeof(key.raw) - 1);
+	key.name.len = strlen(name) + 1;
+
+	fd = bpf_map__fd(skel->maps.str_htab);
+	err = bpf_map_update_elem(fd, &key, &value, BPF_NOEXIST);
+	if (!ASSERT_OK(err, "str htab add"))
+		return -EINVAL;
+
+	fd = bpf_map__fd(skel->maps.byte_htab);
+	err = bpf_map_update_elem(fd, key.raw, &value, BPF_NOEXIST);
+	if (!ASSERT_OK(err, "byte htab add"))
+		return -EINVAL;
+
+	return 0;
+}
+
+void test_str_key(void)
+{
+	const char *name = "/tmp/str_key_test";
+	struct str_key *skel;
+	unsigned int value;
+	int err, fd;
+
+	skel = str_key__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_load str key"))
+		return;
+
+	srandom(time(NULL));
+	value = random();
+	if (setup_maps(skel, name, value))
+		goto out;
+
+	skel->bss->pid = getpid();
+	err = str_key__attach(skel);
+	if (!ASSERT_OK(err, "attach"))
+		goto out;
+
+	fd = open(name, O_RDONLY | O_CREAT, 0644);
+	if (!ASSERT_GE(fd, 0, "open tmp file"))
+		goto out;
+	close(fd);
+	unlink(name);
+
+	ASSERT_EQ(skel->bss->str_htab_value, value, "str htab find");
+	ASSERT_EQ(skel->bss->byte_htab_value, -1, "byte htab find");
+
+out:
+	str_key__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/str_key.c b/tools/testing/selftests/bpf/progs/str_key.c
new file mode 100644
index 000000000000..4d5a4b7cf183
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/str_key.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022. Huawei Technologies Co., Ltd */
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct path {
+} __attribute__((preserve_access_index));
+
+struct file {
+	struct path f_path;
+} __attribute__((preserve_access_index));
+
+#define HTAB_NAME_SIZE 64
+
+struct str_htab_key {
+	struct bpf_str_key_stor name;
+	char raw[HTAB_NAME_SIZE];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, struct str_htab_key);
+	__type(value, __u32);
+	__uint(map_flags, BPF_F_STR_IN_KEY);
+} str_htab SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__uint(key_size, HTAB_NAME_SIZE);
+	__uint(value_size, sizeof(__u32));
+} byte_htab SEC(".maps");
+
+int pid = 0;
+unsigned int str_htab_value = 0;
+unsigned int byte_htab_value = 0;
+
+SEC("fentry/filp_close")
+int BPF_PROG(filp_close, struct file *filp)
+{
+	struct path *p = &filp->f_path;
+	struct str_htab_key key;
+	unsigned int *value;
+	int len;
+
+	if (bpf_get_current_pid_tgid() >> 32 != pid)
+		return 0;
+
+	__builtin_memset(key.raw, 0, sizeof(key.raw));
+	len = bpf_d_path(p, key.raw, sizeof(key.raw));
+	if (len < 0 || len > sizeof(key.raw))
+		return 0;
+
+	key.name.hash = 0;
+	key.name.len = len;
+	value = bpf_map_lookup_elem(&str_htab, &key);
+	if (value)
+		str_htab_value = *value;
+	else
+		str_htab_value = -1;
+
+	value = bpf_map_lookup_elem(&byte_htab, key.raw);
+	if (value)
+		byte_htab_value = *value;
+	else
+		byte_htab_value = -1;
+
+	return 0;
+}
-- 
2.25.4

