Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741BFD1977
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731144AbfJIUPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:15:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63512 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729865AbfJIUPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 16:15:10 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x99KDkRL021294
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 13:15:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=b/37hP6aVO7euZ6+MHCFQ+qA9swSTSWlr9O/veB7rbc=;
 b=o6WSPOMxOYXWxshOKZRfd4uT33I72f7ed2luUccBVdad2h4g9F+FFxSzy7QrSL9e/auI
 ouAKw0SyeCiIHNgQ5TB/VtDBpF7d/Fks5Bpa103da/xKTWw1XMVhGw3YBz5vvuec6Fjr
 31C/usvwHnxibR2OgV+SRbxtWXW0e0oqwOE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vhfsdt7hr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 13:15:09 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 9 Oct 2019 13:15:08 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 86DF086191B; Wed,  9 Oct 2019 13:15:05 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 2/2] selftests/bpf: add read-only map values propagation tests
Date:   Wed, 9 Oct 2019 13:14:58 -0700
Message-ID: <20191009201458.2679171-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191009201458.2679171-1-andriin@fb.com>
References: <20191009201458.2679171-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_09:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 suspectscore=8
 clxscore=1015 mlxlogscore=704 spamscore=0 mlxscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090161
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests checking that verifier does proper constant propagation for
read-only maps. If constant propagation didn't work, skipp_loop and
part_loop BPF programs would be rejected due to BPF verifier otherwise
not being able to prove they ever complete. With constant propagation,
though, they are succesfully validated as properly terminating loops.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/rdonly_maps.c    | 99 +++++++++++++++++++
 .../selftests/bpf/progs/test_rdonly_maps.c    | 83 ++++++++++++++++
 2 files changed, 182 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_rdonly_maps.c

diff --git a/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
new file mode 100644
index 000000000000..9bf9de0aaeea
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/rdonly_maps.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+
+struct bss {
+	unsigned did_run;
+	unsigned iters;
+	unsigned sum;
+};
+
+struct rdonly_map_subtest {
+	const char *subtest_name;
+	const char *prog_name;
+	unsigned exp_iters;
+	unsigned exp_sum;
+};
+
+void test_rdonly_maps(void)
+{
+	const char *prog_name_skip_loop = "raw_tracepoint/sys_enter:skip_loop";
+	const char *prog_name_part_loop = "raw_tracepoint/sys_enter:part_loop";
+	const char *prog_name_full_loop = "raw_tracepoint/sys_enter:full_loop";
+	const char *file = "test_rdonly_maps.o";
+	struct rdonly_map_subtest subtests[] = {
+		{ "skip loop", prog_name_skip_loop, 0, 0 },
+		{ "part loop", prog_name_part_loop, 3, 2 + 3 + 4 },
+		{ "full loop", prog_name_full_loop, 4, 2 + 3 + 4 + 5 },
+	};
+	int i, err, zero = 0, duration = 0;
+	struct bpf_link *link = NULL;
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct bpf_object *obj;
+	struct bss bss;
+
+	obj = bpf_object__open_file(file, NULL);
+	if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
+		return;
+
+	bpf_object__for_each_program(prog, obj) {
+		bpf_program__set_raw_tracepoint(prog);
+	}
+
+	err = bpf_object__load(obj);
+	if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
+		goto cleanup;
+
+	bss_map = bpf_object__find_map_by_name(obj, "test_rdo.bss");
+	if (CHECK(!bss_map, "find_bss_map", "failed\n"))
+		goto cleanup;
+
+	for (i = 0; i < ARRAY_SIZE(subtests); i++) {
+		const struct rdonly_map_subtest *t = &subtests[i];
+
+		if (!test__start_subtest(t->subtest_name))
+			continue;
+
+		prog = bpf_object__find_program_by_title(obj, t->prog_name);
+		if (CHECK(!prog, "find_prog", "prog '%s' not found\n",
+			  t->prog_name))
+			goto cleanup;
+
+		memset(&bss, 0, sizeof(bss));
+		err = bpf_map_update_elem(bpf_map__fd(bss_map), &zero, &bss, 0);
+		if (CHECK(err, "set_bss", "failed to set bss data: %d\n", err))
+			goto cleanup;
+
+		link = bpf_program__attach_raw_tracepoint(prog, "sys_enter");
+		if (CHECK(IS_ERR(link), "attach_prog", "prog '%s', err %ld\n",
+			  t->prog_name, PTR_ERR(link))) {
+			link = NULL;
+			goto cleanup;
+		}
+
+		/* trigger probe */
+		usleep(1);
+
+		bpf_link__destroy(link);
+		link = NULL;
+
+		err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &zero, &bss);
+		if (CHECK(err, "get_bss", "failed to get bss data: %d\n", err))
+			goto cleanup;
+		if (CHECK(bss.did_run == 0, "check_run",
+			  "prog '%s' didn't run?\n", t->prog_name))
+			goto cleanup;
+		if (CHECK(bss.iters != t->exp_iters, "check_iters",
+			  "prog '%s' iters: %d, expected: %d\n",
+			  t->prog_name, bss.iters, t->exp_iters))
+			goto cleanup;
+		if (CHECK(bss.sum != t->exp_sum, "check_sum",
+			  "prog '%s' sum: %d, expected: %d\n",
+			  t->prog_name, bss.sum, t->exp_sum))
+			goto cleanup;
+	}
+
+cleanup:
+	bpf_link__destroy(link);
+	bpf_object__close(obj);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_rdonly_maps.c b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
new file mode 100644
index 000000000000..52d94e8b214d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_rdonly_maps.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+static volatile const struct {
+	unsigned a[4];
+	/*
+	 * if the struct's size is multiple of 16, compiler will put it into
+	 * .rodata.cst16 section, which is not recognized by libbpf; work
+	 * around this by ensuring we don't have 16-aligned struct
+	 */
+	char _y;
+} rdonly_values = { .a = {2, 3, 4, 5} };
+
+static volatile struct {
+	unsigned did_run;
+	unsigned iters;
+	unsigned sum;
+} res;
+
+SEC("raw_tracepoint/sys_enter:skip_loop")
+int skip_loop(struct pt_regs *ctx)
+{
+	/* prevent compiler to optimize everything out */
+	unsigned * volatile p = (void *)&rdonly_values.a;
+	unsigned iters = 0, sum = 0;
+
+	/* we should never enter this loop */
+	while (*p & 1) {
+		iters++;
+		sum += *p;
+		p++;
+	}
+	res.did_run = 1;
+	res.iters = iters;
+	res.sum = sum;
+	return 0;
+}
+
+SEC("raw_tracepoint/sys_enter:part_loop")
+int part_loop(struct pt_regs *ctx)
+{
+	/* prevent compiler to optimize everything out */
+	unsigned * volatile p = (void *)&rdonly_values.a;
+	unsigned iters = 0, sum = 0;
+
+	/* validate verifier can derive loop termination */
+	while (*p < 5) {
+		iters++;
+		sum += *p;
+		p++;
+	}
+	res.did_run = 1;
+	res.iters = iters;
+	res.sum = sum;
+	return 0;
+}
+
+SEC("raw_tracepoint/sys_enter:full_loop")
+int full_loop(struct pt_regs *ctx)
+{
+	/* prevent compiler to optimize everything out */
+	unsigned * volatile p = (void *)&rdonly_values.a;
+	int i = sizeof(rdonly_values.a) / sizeof(rdonly_values.a[0]);
+	unsigned iters = 0, sum = 0;
+
+	/* validate verifier can allow full loop as well */
+	while (i > 0 ) {
+		iters++;
+		sum += *p;
+		p++;
+		i--;
+	}
+	res.did_run = 1;
+	res.iters = iters;
+	res.sum = sum;
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.17.1

