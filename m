Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAC41058F3
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 18:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfKUR7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 12:59:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11494 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUR7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 12:59:09 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALHwuii028279
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 09:59:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=ECdLI7PRMTkecmEifYeoU5ChGbGudEpoSCZqW9L/Vuc=;
 b=k1YLRw4e1gW8ilqzMlNTMQEzcQladTfOWbt3v0orYeL1di7vqG57yQMJXKpSlmvkuf7m
 cUzQd399Fk3XxEXzg/ilrezao2a5nf67QDuLx+7zlx1+JN1YkZsj1zCii89VmgiKk88b
 p0hcYeahlGaiw7/M+MIQKHE4KkvyHhw3oz8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wde15g82m-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 09:59:08 -0800
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 21 Nov 2019 09:59:04 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A2B982EC1D61; Thu, 21 Nov 2019 09:59:01 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] selftests/bpf: ensure core_reloc_kernel is reading test_progs's data only
Date:   Thu, 21 Nov 2019 09:59:00 -0800
Message-ID: <20191121175900.3486133-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_05:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=869
 malwarescore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=8
 phishscore=0 mlxscore=0 clxscore=1015 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911210153
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_core_reloc_kernel.c selftest is the only CO-RE test that reads and
returns for validation calling thread's information (pid, tgid, comm). Thus it
has to make sure that only test_prog's invocations are honored.

Fixes: df36e621418b ("selftests/bpf: add CO-RE relocs testing setup")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_reloc.c        | 16 +++++++++++-----
 .../selftests/bpf/progs/test_core_reloc_kernel.c |  4 ++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index ec9e2fdd6b89..05fe85281ff7 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -2,6 +2,7 @@
 #include <test_progs.h>
 #include "progs/core_reloc_types.h"
 #include <sys/mman.h>
+#include <sys/syscall.h>
 
 #define STRUCT_TO_CHAR_PTR(struct_name) (const char *)&(struct struct_name)
 
@@ -452,6 +453,7 @@ static struct core_reloc_test_case test_cases[] = {
 struct data {
 	char in[256];
 	char out[256];
+	uint64_t my_pid_tgid;
 };
 
 static size_t roundup_page(size_t sz)
@@ -471,9 +473,12 @@ void test_core_reloc(void)
 	struct bpf_map *data_map;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
+	uint64_t my_pid_tgid;
 	struct data *data;
 	void *mmap_data = NULL;
 
+	my_pid_tgid = getpid() | ((uint64_t)syscall(SYS_gettid) << 32);
+
 	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
 		test_case = &test_cases[i];
 		if (!test__start_subtest(test_case->case_name))
@@ -517,11 +522,6 @@ void test_core_reloc(void)
 				goto cleanup;
 		}
 
-		link = bpf_program__attach_raw_tracepoint(prog, tp_name);
-		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
-			  PTR_ERR(link)))
-			goto cleanup;
-
 		data_map = bpf_object__find_map_by_name(obj, "test_cor.bss");
 		if (CHECK(!data_map, "find_data_map", "data map not found\n"))
 			goto cleanup;
@@ -537,6 +537,12 @@ void test_core_reloc(void)
 
 		memset(mmap_data, 0, sizeof(*data));
 		memcpy(data->in, test_case->input, test_case->input_len);
+		data->my_pid_tgid = my_pid_tgid;
+
+		link = bpf_program__attach_raw_tracepoint(prog, tp_name);
+		if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n",
+			  PTR_ERR(link)))
+			goto cleanup;
 
 		/* trigger test run */
 		usleep(1);
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index a4b5e0562ed5..d2fe8f337846 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -11,6 +11,7 @@ char _license[] SEC("license") = "GPL";
 static volatile struct data {
 	char in[256];
 	char out[256];
+	uint64_t my_pid_tgid;
 } data;
 
 struct core_reloc_kernel_output {
@@ -38,6 +39,9 @@ int test_core_kernel(void *ctx)
 	uint32_t real_tgid = (uint32_t)pid_tgid;
 	int pid, tgid;
 
+	if (data.my_pid_tgid != pid_tgid)
+		return 0;
+
 	if (CORE_READ(&pid, &task->pid) ||
 	    CORE_READ(&tgid, &task->tgid))
 		return 1;
-- 
2.17.1

