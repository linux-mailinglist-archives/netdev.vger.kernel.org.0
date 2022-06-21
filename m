Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FD5553801
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239233AbiFUQjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 12:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351923AbiFUQi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 12:38:57 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FC617AA7;
        Tue, 21 Jun 2022 09:38:56 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSBxQ4GYhz6H6n7;
        Wed, 22 Jun 2022 00:36:58 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 21 Jun 2022 18:38:53 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>, <john.fastabend@gmail.com>,
        <songliubraving@fb.com>, <kafai@fb.com>, <yhs@fb.com>
CC:     <dhowells@redhat.com>, <keyrings@vger.kernel.org>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v5 4/5] selftests/bpf: Add test for unreleased key references
Date:   Tue, 21 Jun 2022 18:37:56 +0200
Message-ID: <20220621163757.760304-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220621163757.760304-1-roberto.sassu@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that the verifier detects the attempt of acquiring a reference of a
key through the helper bpf_lookup_user_key(), without releasing that
reference with bpf_key_put(), and refuses to load the program.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../prog_tests/lookup_user_key_norelease.c    | 52 +++++++++++++++++++
 .../progs/test_lookup_user_key_norelease.c    | 24 +++++++++
 2 files changed, 76 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_user_key_norelease.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_user_key_norelease.c

diff --git a/tools/testing/selftests/bpf/prog_tests/lookup_user_key_norelease.c b/tools/testing/selftests/bpf/prog_tests/lookup_user_key_norelease.c
new file mode 100644
index 000000000000..6753c4f591e3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/lookup_user_key_norelease.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <test_progs.h>
+
+#include "test_lookup_user_key_norelease.skel.h"
+
+#define LOG_BUF_SIZE 16384
+
+void test_lookup_user_key_norelease(void)
+{
+	char *buf = NULL, *result;
+	struct test_lookup_user_key_norelease *skel = NULL;
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
+	skel = test_lookup_user_key_norelease__open_opts(&opts);
+	if (!ASSERT_OK_PTR(skel, "test_lookup_user_key_norelease__open_opts"))
+		goto close_prog;
+
+	ret = test_lookup_user_key_norelease__load(skel);
+	if (!ASSERT_LT(ret, 0, "test_lookup_user_key_norelease__load\n"))
+		goto close_prog;
+
+	if (strstr(buf, "unknown func bpf_lookup_user_key")) {
+		printf("%s:SKIP:bpf_lookup_user_key() helper not supported\n",
+		       __func__);
+		test__skip();
+		goto close_prog;
+	}
+
+	result = strstr(buf, "Unreleased reference");
+	ASSERT_OK_PTR(result, "Error message not found");
+
+close_prog:
+	free(buf);
+	test_lookup_user_key_norelease__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_lookup_user_key_norelease.c b/tools/testing/selftests/bpf/progs/test_lookup_user_key_norelease.c
new file mode 100644
index 000000000000..cfe474c77886
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_lookup_user_key_norelease.c
@@ -0,0 +1,24 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <linux/bpf.h>
+#include <linux/keyctl.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm.s/bpf")
+int BPF_PROG(bpf, int cmd, union bpf_attr *attr, unsigned int size)
+{
+	bpf_lookup_user_key(KEY_SPEC_SESSION_KEYRING, 0);
+	return 0;
+}
-- 
2.25.1

