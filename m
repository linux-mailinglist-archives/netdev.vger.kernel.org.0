Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41844FBCAF
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346310AbiDKNDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346304AbiDKNDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:03:01 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F451EC71;
        Mon, 11 Apr 2022 06:00:46 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KcTPm230gzBrx3;
        Mon, 11 Apr 2022 20:56:28 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Apr
 2022 21:00:43 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sdf@google.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH bpf 2/2] selftests: bpf: add test for skb_load_bytes
Date:   Mon, 11 Apr 2022 21:02:55 +0800
Message-ID: <20220411130255.385520-3-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220411130255.385520-1-liujian56@huawei.com>
References: <20220411130255.385520-1-liujian56@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
Tests behavior when offset is greater than INT_MAX or a normal value.

Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 .../selftests/bpf/prog_tests/skb_load_bytes.c | 65 +++++++++++++++++++
 .../selftests/bpf/progs/skb_load_bytes.c      | 37 +++++++++++
 2 files changed, 102 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_load_bytes.c

diff --git a/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
new file mode 100644
index 000000000000..2e86f81d85f1
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/skb_load_bytes.c
@@ -0,0 +1,65 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <network_helpers.h>
+
+void test_skb_load_bytes(void)
+{
+	struct bpf_map *test_result;
+
+	__u32 map_key = 0;
+	__u32 map_value = 0;
+
+	struct bpf_object *obj;
+	int err, map_fd, prog_fd;
+
+	struct __sk_buff skb = { 0 };
+
+	LIBBPF_OPTS(bpf_test_run_opts, tattr,
+			.data_in = &pkt_v4,
+			.data_size_in = sizeof(pkt_v4),
+			.ctx_in = &skb,
+			.ctx_size_in = sizeof(skb),
+		   );
+
+	err = bpf_prog_test_load("./skb_load_bytes.o", BPF_PROG_TYPE_SCHED_CLS, &obj,
+			&prog_fd);
+	if (CHECK_ATTR(err, "load", "err %d errno %d\n", err, errno))
+		return;
+
+	test_result = bpf_object__find_map_by_name(obj, "test_result");
+	if (CHECK_FAIL(!test_result))
+		goto close_bpf_object;
+
+	map_fd = bpf_map__fd(test_result);
+	if (map_fd < 0)
+		goto close_bpf_object;
+
+	map_key = 0;
+	map_value = -1;
+	err = bpf_map_update_elem(map_fd, &map_key, &map_value, BPF_ANY);
+	if (CHECK_FAIL(err))
+		goto close_bpf_object;
+	tattr.data_out = NULL;
+	tattr.data_size_out = 0;
+	err = bpf_prog_test_run_opts(prog_fd, &tattr);
+	CHECK_ATTR(err != 0, "offset -1", "err %d errno %d\n", err, errno);
+	map_key = 1;
+	bpf_map_lookup_elem(map_fd, &map_key, &map_value);
+	CHECK_ATTR(map_value != -14, "offset -1", "get result error\n");
+
+	map_key = 0;
+	map_value = 10;
+	err = bpf_map_update_elem(map_fd, &map_key, &map_value, BPF_ANY);
+	if (CHECK_FAIL(err))
+		goto close_bpf_object;
+	tattr.data_out = NULL;
+	tattr.data_size_out = 0;
+	err = bpf_prog_test_run_opts(prog_fd, &tattr);
+	CHECK_ATTR(err != 0, "offset 10", "err %d errno %d\n", err, errno);
+	map_key = 1;
+	bpf_map_lookup_elem(map_fd, &map_key, &map_value);
+	CHECK_ATTR(map_value != 0, "offset 10", "get result error\n");
+
+close_bpf_object:
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/skb_load_bytes.c b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
new file mode 100644
index 000000000000..1652540aa45d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/skb_load_bytes.c
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, __u32);
+} test_result SEC(".maps");
+
+SEC("tc")
+int skb_process(struct __sk_buff *skb)
+{
+	char buf[16];
+	int ret = 0;
+	__u32 map_key = 0;
+	__u32 *offset = NULL;
+
+	offset = bpf_map_lookup_elem(&test_result, &map_key);
+	if (offset == NULL) {
+		bpf_printk("get offset failed\n");
+		map_key = 1;
+		ret = -1;
+		bpf_map_update_elem(&test_result, &map_key, &ret, BPF_ANY);
+		return ret;
+	}
+
+	ret = bpf_skb_load_bytes(skb, *offset, buf, 10);
+	map_key = 1;
+	bpf_map_update_elem(&test_result, &map_key, &ret, BPF_ANY);
+
+	return 0;
+}
-- 
2.17.1

