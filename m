Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2F4FEFAE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 08:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbiDMGVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 02:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbiDMGVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 02:21:48 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E0935DD4;
        Tue, 12 Apr 2022 23:19:26 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KdXPl2C26zBsJD;
        Wed, 13 Apr 2022 14:15:07 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 13 Apr
 2022 14:19:24 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sdf@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf v2 2/2] selftests: bpf: add test for skb_load_bytes
Date:   Wed, 13 Apr 2022 14:21:31 +0800
Message-ID: <20220413062131.363740-3-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220413062131.363740-1-liujian56@huawei.com>
References: <20220413062131.363740-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bpf_prog_test_run_opts to test the skb_load_bytes function.
Tests the behavior when offset is greater than INT_MAX or a normal value.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
v1->v2: As Liu Song's review comments, use bpf skeleton and global variable.
 .../selftests/bpf/prog_tests/skb_load_bytes.c | 45 +++++++++++++++++++
 .../selftests/bpf/progs/skb_load_bytes.c      | 19 ++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
new file mode 100644
index 000000000000..81cc224a0c69
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+#include "skb_load_bytes.skel.h"
+
+void test_skb_load_bytes(void)
+{
+	struct skb_load_bytes *skel;
+	int err, prog_fd, test_result;
+	struct __sk_buff skb = { 0 };
+
+	LIBBPF_OPTS(bpf_test_run_opts, tattr,
+		.data_in = &pkt_v4,
+		.data_size_in = sizeof(pkt_v4),
+		.ctx_in = &skb,
+		.ctx_size_in = sizeof(skb),
+	);
+
+	skel = skb_load_bytes__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
+		return;
+
+	prog_fd = bpf_program__fd(skel->progs.skb_process);
+	if (prog_fd < 0)
+		goto out;
+
+	skel->bss->load_offset = (uint32_t)(-1);
+	tattr.data_out = NULL;
+	tattr.data_size_out = 0;
+	err = bpf_prog_test_run_opts(prog_fd, &tattr);
+	CHECK_ATTR(err != 0, "offset -1", "err %d errno %d\n", err, errno);
+	test_result = skel->bss->test_result;
+	CHECK_ATTR(test_result != -EFAULT, "offset -1", "test error\n");
+
+	skel->bss->load_offset = (uint32_t)10;
+	tattr.data_out = NULL;
+	tattr.data_size_out = 0;
+	err = bpf_prog_test_run_opts(prog_fd, &tattr);
+	CHECK_ATTR(err != 0, "offset 10", "err %d errno %d\n", err, errno);
+	test_result = skel->bss->test_result;
+	CHECK_ATTR(test_result != 0, "offset 10", "test error\n");
+
+out:
+	skb_load_bytes__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/skb_load_bytes.c b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
new file mode 100644
index 000000000000..e4252fd973be
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u32 load_offset = 0;
+int test_result = 0;
+
+SEC("tc")
+int skb_process(struct __sk_buff *skb)
+{
+	char buf[16];
+
+	test_result = bpf_skb_load_bytes(skb, load_offset, buf, 10);
+
+	return 0;
+}
-- 
2.17.1

