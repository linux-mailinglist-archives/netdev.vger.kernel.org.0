Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF75533DCA
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbiEYNVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 09:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiEYNVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 09:21:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998B4286DA;
        Wed, 25 May 2022 06:21:39 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L7Wpn0nPGz67PnL;
        Wed, 25 May 2022 21:18:25 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 25 May 2022 15:21:37 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 3/3] bpf: Add tests for signed map values
Date:   Wed, 25 May 2022 15:21:15 +0200
Message-ID: <20220525132115.896698-4-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220525132115.896698-1-roberto.sassu@huawei.com>
References: <20220525132115.896698-1-roberto.sassu@huawei.com>
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

Check the ability of eBPF to restrict map update operations based on
signature verification of provided map values, if the map flag
BPF_F_VERIFY_ELEM is set.

Ensure that the map update operation is rejected if the signature is
invalid, or the data format is not correct. Also check that
bpf_map_verified_data_size() returns the correct data size for an added
signed map value.

Execute the test for a single element and in batch mode.

The test requires access to the kernel modules signing key and the
execution of the sign-file tool with the signing key path passed as
argument.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 .../bpf/prog_tests/test_map_value_sig.c       | 212 ++++++++++++++++++
 .../selftests/bpf/progs/map_value_sig.c       |  50 +++++
 2 files changed, 262 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_map_value_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_value_sig.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_map_value_sig.c b/tools/testing/selftests/bpf/prog_tests/test_map_value_sig.c
new file mode 100644
index 000000000000..0c74627f54c6
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_map_value_sig.c
@@ -0,0 +1,212 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <endian.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <test_progs.h>
+
+#include "map_value_sig.skel.h"
+
+#define MAX_DATA_SIZE 1024
+#define ARRAY_ELEMS 5
+
+struct data {
+	u8 payload[MAX_DATA_SIZE];
+};
+
+struct data_info {
+	char str[10];
+	int str_len;
+};
+
+int populate_data_item(struct data *data_item, struct data_info *data_info_item)
+{
+	struct stat st;
+	char signed_file_template[] = "/tmp/signed_fileXXXXXX";
+	int ret, fd, child_status, child_pid;
+
+	fd = mkstemp(signed_file_template);
+	if (fd == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = write(fd, data_info_item->str, data_info_item->str_len);
+
+	close(fd);
+
+	if (ret != data_info_item->str_len) {
+		ret = -EIO;
+		goto out;
+	}
+
+	child_pid = fork();
+
+	if (child_pid == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	if (child_pid == 0)
+		return execlp("../../../../scripts/sign-file",
+			      "../../../../scripts/sign-file", "sha256",
+			      "../../../../certs/signing_key.pem",
+			      "../../../../certs/signing_key.pem",
+			      signed_file_template, NULL);
+
+	waitpid(child_pid, &child_status, 0);
+
+	ret = WEXITSTATUS(child_status);
+	if (ret)
+		goto out;
+
+	ret = stat(signed_file_template, &st);
+	if (ret == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	if (st.st_size > sizeof(data_item->payload) - sizeof(u32)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	*(u32 *)data_item->payload = __cpu_to_be32(st.st_size);
+
+	fd = open(signed_file_template, O_RDONLY);
+	if (fd == -1) {
+		ret = -errno;
+		goto out;
+	}
+
+	ret = read(fd, data_item->payload + sizeof(u32), st.st_size);
+
+	close(fd);
+
+	if (ret != st.st_size) {
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = 0;
+out:
+	unlink(signed_file_template);
+	return ret;
+}
+
+void test_test_map_value_sig(void)
+{
+	struct map_value_sig *skel = NULL;
+	struct bpf_map *map;
+	struct data *data_array = NULL;
+	struct data_info *data_info_array = NULL;
+	int keys[ARRAY_ELEMS];
+	u32 max_entries = ARRAY_ELEMS;
+	int ret, zero = 0, i, map_fd, duration = 0;
+
+	DECLARE_LIBBPF_OPTS(bpf_map_create_opts, create_opts,
+			    .map_flags = BPF_F_MMAPABLE | BPF_F_VERIFY_ELEM);
+
+	DECLARE_LIBBPF_OPTS(bpf_map_batch_opts, opts,
+		.elem_flags = 0,
+		.flags = 0,
+	);
+
+	data_array = malloc(sizeof(*data_array) * ARRAY_ELEMS);
+	if (CHECK(!data_array, "data array", "not enough memory\n"))
+		goto close_prog;
+
+	data_info_array = malloc(sizeof(*data_info_array) * ARRAY_ELEMS);
+	if (CHECK(!data_info_array, "data info array", "not enough memory\n"))
+		goto close_prog;
+
+	skel = map_value_sig__open_and_load();
+	if (CHECK(!skel, "skel", "open_and_load failed\n"))
+		goto close_prog;
+
+	ret = map_value_sig__attach(skel);
+	if (CHECK(ret < 0, "skel", "attach failed\n"))
+		goto close_prog;
+
+	map_fd = bpf_map_create(BPF_MAP_TYPE_ARRAY, NULL, 4,
+				sizeof(struct data), ARRAY_ELEMS, &create_opts);
+	if (CHECK(map_fd != -EINVAL, "bpf_map_create",
+		  "should fail (mmapable & verify_elem flags set\n"))
+		goto close_prog;
+
+	map = bpf_object__find_map_by_name(skel->obj, "data_input");
+	if (CHECK(!map, "bpf_object__find_map_by_name", "not found\n"))
+		goto close_prog;
+
+	for (i = 0; i < ARRAY_ELEMS; i++) {
+		keys[i] = i;
+
+		data_info_array[i].str_len = snprintf(data_info_array[i].str,
+						 sizeof(data_info_array[i].str),
+						 "test%d", i);
+
+		ret = populate_data_item(&data_array[i], &data_info_array[i]);
+		if (CHECK(ret, "populate_data_item", "error: %d\n", ret))
+			goto close_prog;
+
+		ret = bpf_map_update_elem(bpf_map__fd(map), &zero,
+					  &data_array[i], BPF_ANY);
+		if (CHECK(ret < 0, "bpf_map_update_elem", "error: %d\n", ret))
+			goto close_prog;
+
+		if (CHECK(skel->bss->verified_data_size !=
+			  data_info_array[i].str_len, "data size",
+			  "mismatch\n"))
+			goto close_prog;
+	}
+
+	ret = bpf_map_update_batch(bpf_map__fd(map), keys, (void *)data_array,
+				   &max_entries, &opts);
+	if (CHECK(ret, "bpf_map_update_batch", "error: %d\n", ret))
+		goto close_prog;
+
+	*(u32 *)data_array[0].payload =
+				__cpu_to_be32(sizeof(data_array[0].payload));
+
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data_array[0],
+				  BPF_ANY);
+	if (CHECK(!ret, "bpf_map_update_elem", "should fail (invalid size)\n"))
+		goto close_prog;
+
+	ret = bpf_map_update_batch(bpf_map__fd(map), keys, (void *)data_array,
+				   &max_entries, &opts);
+	if (CHECK(!ret, "bpf_map_update_batch", "should fail (invalid size)\n"))
+		goto close_prog;
+
+	*(u32 *)data_array[0].payload =
+				__cpu_to_be32(data_info_array[0].str_len);
+
+	data_array[0].payload[sizeof(u32) + data_info_array[0].str_len - 1] =
+									'\0';
+	ret = bpf_map_update_elem(bpf_map__fd(map), &zero, &data_array[0], 0);
+	if (CHECK(!ret, "bpf_map_update_elem",
+		  "should fail (invalid signature)\n"))
+		goto close_prog;
+
+	max_entries = ARRAY_ELEMS;
+
+	ret = bpf_map_update_batch(bpf_map__fd(map), keys, (void *)data_array,
+				   &max_entries, &opts);
+	if (CHECK(!ret, "bpf_map_update_batch",
+		  "should fail (invalid signature)\n"))
+		goto close_prog;
+close_prog:
+	map_value_sig__destroy(skel);
+	free(data_array);
+	free(data_info_array);
+}
diff --git a/tools/testing/selftests/bpf/progs/map_value_sig.c b/tools/testing/selftests/bpf/progs/map_value_sig.c
new file mode 100644
index 000000000000..a1d0fc021127
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/map_value_sig.c
@@ -0,0 +1,50 @@
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
+#define MAX_DATA_SIZE 1024
+#define ARRAY_ELEMS 5
+
+u32 verified_data_size;
+
+struct data {
+	u8 payload[MAX_DATA_SIZE];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(map_flags, BPF_F_VERIFY_ELEM);
+	__uint(max_entries, ARRAY_ELEMS);
+	__type(key, __u32);
+	__type(value, struct data);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("fexit/array_map_update_elem")
+int BPF_PROG(array_map_update_elem, struct bpf_map *map, void *key, void *value,
+	     u64 map_flags)
+{
+	struct data *data_ptr;
+	int zero = 0;
+
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	data_ptr = bpf_map_lookup_elem(&data_input, &zero);
+	if (!data_ptr)
+		return 0;
+
+	verified_data_size = bpf_map_verified_data_size((void *)data_ptr,
+							sizeof(struct data));
+	return 0;
+}
-- 
2.25.1

