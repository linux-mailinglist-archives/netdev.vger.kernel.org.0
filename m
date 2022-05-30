Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1BF5376FA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234067AbiE3Ip7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233523AbiE3Ip4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:45:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4D052B3A;
        Mon, 30 May 2022 01:45:55 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LBTR21D2wz685ZP;
        Mon, 30 May 2022 16:41:34 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 10:45:53 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 2/2] selftests/bpf: Add test for retrying access to map with read-only perm
Date:   Mon, 30 May 2022 10:45:14 +0200
Message-ID: <20220530084514.10170-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220530084514.10170-1-roberto.sassu@huawei.com>
References: <20220530084514.10170-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
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

Add a test to check the ability of bpf_map_get_fd_by_id() to get a map file
descriptor if write permission is denied.

Also ensure that a map update operation fails with the obtained read-only
file descriptor.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../bpf/prog_tests/test_map_retry_access.c    | 54 +++++++++++++++++++
 .../selftests/bpf/progs/map_retry_access.c    | 36 +++++++++++++
 2 files changed, 90 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_retry_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_retry_access.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_map_retry_access.c b/tools/testing/selftests/bpf/prog_tests/test_map_retry_access.c
new file mode 100644
index 000000000000..beffb2026dcd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_map_retry_access.c
@@ -0,0 +1,54 @@
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
+#include "map_retry_access.skel.h"
+
+void test_test_map_retry_access(void)
+{
+	struct map_retry_access *skel;
+	struct bpf_map_info info;
+	struct bpf_map *map;
+	__u32 len = sizeof(info);
+	int ret, zero = 0, fd, duration = 0;
+
+	skel = map_retry_access__open_and_load();
+	if (CHECK(!skel, "skel", "open_and_load failed\n"))
+		goto close_prog;
+
+	ret = map_retry_access__attach(skel);
+	if (CHECK(ret < 0, "skel", "attach failed\n"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (CHECK(!map, "bpf_object__find_map_by_name", "not found\n"))
+		goto close_prog;
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(map), &info, &len);
+	if (CHECK(ret < 0, "bpf_obj_get_info_by_fd", "error: %d\n", ret))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id(info.id);
+	if (CHECK(fd < 0, "bpf_map_get_fd_by_id", "error: %d\n", fd))
+		goto close_prog;
+
+	ret = bpf_map_update_elem(fd, &zero, &len, BPF_ANY);
+
+	close(fd);
+
+	if (CHECK(!ret, "bpf_map_update_elem",
+		  "should fail (read-only permission)\n"))
+		goto close_prog;
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &len, BPF_ANY);
+
+	CHECK(ret < 0, "bpf_map_update_elem", "error: %d\n", ret);
+close_prog:
+	map_retry_access__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/map_retry_access.c b/tools/testing/selftests/bpf/progs/map_retry_access.c
new file mode 100644
index 000000000000..1ed7b137a286
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/map_retry_access.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* From include/linux/mm.h. */
+#define FMODE_WRITE	0x2
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm/bpf_map")
+int BPF_PROG(bpf_map_retry_access, struct bpf_map *map, fmode_t fmode)
+{
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	if (fmode & FMODE_WRITE)
+		return -EACCES;
+
+	return 0;
+}
-- 
2.25.1

