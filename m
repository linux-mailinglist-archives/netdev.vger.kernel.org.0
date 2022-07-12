Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9DE57238C
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 20:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbiGLSrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 14:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbiGLSr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 14:47:26 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D633BFAFE;
        Tue, 12 Jul 2022 11:43:15 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Lj8jh4cQjz689sp;
        Wed, 13 Jul 2022 02:41:44 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 12 Jul 2022 20:43:06 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <dhowells@redhat.com>, <jarkko@kernel.org>,
        <shuah@kernel.org>
CC:     <bpf@vger.kernel.org>, <keyrings@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v7 6/7] selftests/bpf: Add additional test for bpf_lookup_user_key()
Date:   Tue, 12 Jul 2022 20:41:27 +0200
Message-ID: <20220712184128.999301-7-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220712184128.999301-1-roberto.sassu@huawei.com>
References: <20220712184128.999301-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an additional test to ensure that bpf_lookup_user_key() creates a
referenced special keyring when the KEY_LOOKUP_CREATE flag is passed to
this function.

Also ensure that the helper rejects invalid flags.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../bpf/prog_tests/lookup_user_key.c          | 94 +++++++++++++++++++
 .../bpf/progs/test_lookup_user_key.c          | 35 +++++++
 2 files changed, 129 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_user_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_user_key.c

diff --git a/tools/testing/selftests/bpf/prog_tests/lookup_user_key.c b/tools/testing/selftests/bpf/prog_tests/lookup_user_key.c
new file mode 100644
index 000000000000..6487699d30f6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/lookup_user_key.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <linux/keyctl.h>
+#include <test_progs.h>
+
+#include "test_lookup_user_key.skel.h"
+
+#define LOG_BUF_SIZE 16384
+
+#define KEY_LOOKUP_CREATE	0x01
+#define KEY_LOOKUP_PARTIAL	0x02
+
+void test_lookup_user_key(void)
+{
+	char *buf = NULL;
+	struct test_lookup_user_key *skel = NULL;
+	u32 next_id;
+	int ret;
+
+	LIBBPF_OPTS(bpf_object_open_opts, opts);
+
+	buf = malloc(LOG_BUF_SIZE);
+	if (!ASSERT_OK_PTR(buf, "malloc"))
+		goto close_prog;
+
+	opts.kernel_log_buf = buf;
+	opts.kernel_log_size = LOG_BUF_SIZE;
+	opts.kernel_log_level = 1;
+
+	skel = test_lookup_user_key__open_opts(&opts);
+	if (!ASSERT_OK_PTR(skel, "test_lookup_user_key__open_opts"))
+		goto close_prog;
+
+	ret = test_lookup_user_key__load(skel);
+
+	if (ret < 0 && strstr(buf, "unknown func bpf_lookup_user_key")) {
+		printf("%s:SKIP:bpf_lookup_user_key() helper not supported\n",
+		       __func__);
+		test__skip();
+		goto close_prog;
+	}
+
+	if (!ASSERT_OK(ret, "test_lookup_user_key__load"))
+		goto close_prog;
+
+	ret = test_lookup_user_key__attach(skel);
+	if (!ASSERT_OK(ret, "test_lookup_user_key__attach"))
+		goto close_prog;
+
+	skel->bss->monitored_pid = getpid();
+	skel->bss->key_serial = KEY_SPEC_THREAD_KEYRING;
+
+	/* The thread-specific keyring does not exist, this test fails. */
+	skel->bss->flags = 0;
+
+	ret = bpf_prog_get_next_id(0, &next_id);
+	if (!ASSERT_LT(ret, 0, "bpf_prog_get_next_id"))
+		goto close_prog;
+
+	/* Force creation of the thread-specific keyring, this test succeeds. */
+	skel->bss->flags = KEY_LOOKUP_CREATE;
+
+	ret = bpf_prog_get_next_id(0, &next_id);
+	if (!ASSERT_OK(ret, "bpf_prog_get_next_id"))
+		goto close_prog;
+
+	/* Pass both lookup flags for parameter validation. */
+	skel->bss->flags = KEY_LOOKUP_CREATE | KEY_LOOKUP_PARTIAL;
+
+	ret = bpf_prog_get_next_id(0, &next_id);
+	if (!ASSERT_OK(ret, "bpf_prog_get_next_id"))
+		goto close_prog;
+
+	/* Pass invalid flags. */
+	skel->bss->flags = UINT64_MAX;
+
+	ret = bpf_prog_get_next_id(0, &next_id);
+	ASSERT_LT(ret, 0, "bpf_prog_get_next_id");
+
+close_prog:
+	free(buf);
+
+	if (!skel)
+		return;
+
+	skel->bss->monitored_pid = 0;
+	test_lookup_user_key__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_lookup_user_key.c b/tools/testing/selftests/bpf/progs/test_lookup_user_key.c
new file mode 100644
index 000000000000..5b63753ba163
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_lookup_user_key.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <errno.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u32 monitored_pid;
+__u32 key_serial;
+__u64 flags;
+
+SEC("lsm.s/bpf")
+int BPF_PROG(bpf, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	struct key *key;
+	__u32 pid;
+
+	pid = bpf_get_current_pid_tgid() >> 32;
+	if (pid != monitored_pid)
+		return 0;
+
+	key = bpf_lookup_user_key(key_serial, flags);
+	if (key)
+		bpf_key_put(key);
+
+	return (key) ? 0 : -ENOENT;
+}
-- 
2.25.1

