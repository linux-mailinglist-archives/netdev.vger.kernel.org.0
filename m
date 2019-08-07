Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81C5C8554D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389437AbfHGVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 17:40:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63392 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389389AbfHGVkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 17:40:18 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x77LeAAg030701
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 14:40:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=tCPvujuq6fTlni0Z7f9sjyHs9CxqOy4ofn/Br5cYS7w=;
 b=MEh2uCNrefak64RA3HKBs0p3w4KggxLMvXZgzDuFhisOc2TAiOwWTw4BdTuUcA8A+4oL
 VIS9ZDZCemdreb7wLzm+kbuChW3xQRtdU80GwKHGMXnVgopYFiuzArBcaq44qNJ2D6rv
 9a6x/cuAtJpOCQfKPuVGJLjT83uhjxA0XPQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u83wx0pet-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 14:40:17 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Aug 2019 14:40:15 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 853C8861682; Wed,  7 Aug 2019 14:40:14 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v6 bpf-next 06/14] selftests/bpf: add CO-RE relocs testing setup
Date:   Wed, 7 Aug 2019 14:39:53 -0700
Message-ID: <20190807214001.872988-7-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190807214001.872988-1-andriin@fb.com>
References: <20190807214001.872988-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-07_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=67 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908070187
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add CO-RE relocation test runner. Add one simple test validating that
libbpf's logic for searching for kernel image and loading BTF out of it
works.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 129 ++++++++++++++++++
 .../bpf/progs/test_core_reloc_kernel.c        |  36 +++++
 2 files changed, 165 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_reloc.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
new file mode 100644
index 000000000000..4323a459c8a2
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+struct core_reloc_test_case {
+	const char *case_name;
+	const char *bpf_obj_file;
+	const char *btf_src_file;
+	const char *input;
+	int input_len;
+	const char *output;
+	int output_len;
+	bool fails;
+};
+
+static struct core_reloc_test_case test_cases[] = {
+	/* validate we can find kernel image and use its BTF for relocs */
+	{
+		.case_name = "kernel",
+		.bpf_obj_file = "test_core_reloc_kernel.o",
+		.btf_src_file = NULL, /* load from /lib/modules/$(uname -r) */
+		.input = "",
+		.input_len = 0,
+		.output = "\1", /* true */
+		.output_len = 1,
+	},
+};
+
+struct data {
+	char in[256];
+	char out[256];
+};
+
+void test_core_reloc(void)
+{
+	const char *probe_name = "raw_tracepoint/sys_enter";
+	struct bpf_object_load_attr load_attr = {};
+	struct core_reloc_test_case *test_case;
+	int err, duration = 0, i, equal;
+	struct bpf_link *link = NULL;
+	struct bpf_map *data_map;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	const int zero = 0;
+	struct data data;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		test_case = &test_cases[i];
+
+		if (!test__start_subtest(test_case->case_name))
+			continue;
+
+		obj = bpf_object__open(test_case->bpf_obj_file);
+		if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
+			  "failed to open '%s': %ld\n",
+			  test_case->bpf_obj_file, PTR_ERR(obj)))
+			continue;
+
+		prog = bpf_object__find_program_by_title(obj, probe_name);
+		if (CHECK(!prog, "find_probe",
+			  "prog '%s' not found\n", probe_name))
+			goto cleanup;
+		bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
+
+		load_attr.obj = obj;
+		load_attr.log_level = 0;
+		load_attr.target_btf_path = test_case->btf_src_file;
+		err = bpf_object__load_xattr(&load_attr);
+		if (test_case->fails) {
+			CHECK(!err, "obj_load_fail",
+			      "should fail to load prog '%s'\n", probe_name);
+			goto cleanup;
+		} else {
+			if (CHECK(err, "obj_load",
+				  "failed to load prog '%s': %d\n",
+				  probe_name, err))
+				goto cleanup;
+		}
+
+		link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+			  PTR_ERR(link)))
+			goto cleanup;
+
+		data_map = bpf_object__find_map_by_name(obj, "test_cor.bss");
+		if (CHECK(!data_map, "find_data_map", "data map not found\n"))
+			goto cleanup;
+
+		memset(&data, 0, sizeof(data));
+		memcpy(data.in, test_case->input, test_case->input_len);
+
+		err = bpf_map_update_elem(bpf_map__fd(data_map),
+					  &zero, &data, 0);
+		if (CHECK(err, "update_data_map",
+			  "failed to update .data map: %d\n", err))
+			goto cleanup;
+
+		/* trigger test run */
+		usleep(1);
+
+		err = bpf_map_lookup_elem(bpf_map__fd(data_map), &zero, &data);
+		if (CHECK(err, "get_result",
+			  "failed to get output data: %d\n", err))
+			goto cleanup;
+
+		equal = memcmp(data.out, test_case->output,
+			       test_case->output_len) == 0;
+		if (CHECK(!equal, "check_result",
+			  "input/output data don't match\n")) {
+			int j;
+
+			for (j = 0; j < test_case->input_len; j++) {
+				printf("input byte #%d: 0x%02hhx\n",
+				       j, test_case->input[j]);
+			}
+			for (j = 0; j < test_case->output_len; j++) {
+				printf("output byte #%d: EXP 0x%02hhx GOT 0x%02hhx\n",
+				       j, test_case->output[j], data.out[j]);
+			}
+			goto cleanup;
+		}
+
+cleanup:
+		if (!IS_ERR_OR_NULL(link)) {
+			bpf_link__destroy(link);
+			link = NULL;
+		}
+		bpf_object__close(obj);
+	}
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
new file mode 100644
index 000000000000..37e02aa3f0c8
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include "bpf_helpers.h"
+
+char _license[] SEC("license") = "GPL";
+
+static volatile struct data {
+	char in[256];
+	char out[256];
+} data;
+
+struct task_struct {
+	int pid;
+	int tgid;
+};
+
+SEC("raw_tracepoint/sys_enter")
+int test_core_kernel(void *ctx)
+{
+	struct task_struct *task = (void *)bpf_get_current_task();
+	uint64_t pid_tgid = bpf_get_current_pid_tgid();
+	int pid, tgid;
+
+	if (BPF_CORE_READ(&pid, &task->pid) ||
+	    BPF_CORE_READ(&tgid, &task->tgid))
+		return 1;
+
+	/* validate pid + tgid matches */
+	data.out[0] = (((uint64_t)pid << 32) | tgid) == pid_tgid;
+
+	return 0;
+}
+
-- 
2.17.1

