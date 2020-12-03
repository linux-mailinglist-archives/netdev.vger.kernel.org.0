Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7860B2CE012
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 21:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbgLCUuM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 3 Dec 2020 15:50:12 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62382 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727406AbgLCUuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 15:50:12 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B3Kf1YM027602
        for <netdev@vger.kernel.org>; Thu, 3 Dec 2020 12:49:31 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 356xfqv240-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 12:49:31 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Dec 2020 12:48:26 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B8E282ECA8BF; Thu,  3 Dec 2020 12:48:23 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v6 bpf-next 13/14] selftests/bpf: add tp_btf CO-RE reloc test for modules
Date:   Thu, 3 Dec 2020 12:46:33 -0800
Message-ID: <20201203204634.1325171-14-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201203204634.1325171-1-andrii@kernel.org>
References: <20201203204634.1325171-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-03_12:2020-12-03,2020-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=940 mlxscore=0 clxscore=1015
 impostorscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012030121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add another CO-RE relocation test for kernel module relocations. This time for
tp_btf with direct memory reads.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     |  3 +-
 .../bpf/progs/test_core_reloc_module.c        | 32 ++++++++++++++++++-
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index bb980848cd77..06eb956ff7bb 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -514,7 +514,8 @@ static struct core_reloc_test_case test_cases[] = {
 	},
 
 	/* validate we can find kernel module BTF types for relocs/attach */
-	MODULES_CASE("module", "raw_tp/bpf_testmod_test_read", "bpf_testmod_test_read"),
+	MODULES_CASE("module_probed", "raw_tp/bpf_testmod_test_read", "bpf_testmod_test_read"),
+	MODULES_CASE("module_direct", "tp_btf/bpf_testmod_test_read", NULL),
 
 	/* validate BPF program can use multiple flavors to match against
 	 * single target BTF type
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
index d1840c1a9d36..56363959f7b0 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_module.c
@@ -36,7 +36,7 @@ struct core_reloc_module_output {
 };
 
 SEC("raw_tp/bpf_testmod_test_read")
-int BPF_PROG(test_core_module,
+int BPF_PROG(test_core_module_probed,
 	     struct task_struct *task,
 	     struct bpf_testmod_test_read_ctx *read_ctx)
 {
@@ -64,3 +64,33 @@ int BPF_PROG(test_core_module,
 
 	return 0;
 }
+
+SEC("tp_btf/bpf_testmod_test_read")
+int BPF_PROG(test_core_module_direct,
+	     struct task_struct *task,
+	     struct bpf_testmod_test_read_ctx *read_ctx)
+{
+	struct core_reloc_module_output *out = (void *)&data.out;
+	__u64 pid_tgid = bpf_get_current_pid_tgid();
+	__u32 real_tgid = (__u32)(pid_tgid >> 32);
+	__u32 real_pid = (__u32)pid_tgid;
+
+	if (data.my_pid_tgid != pid_tgid)
+		return 0;
+
+	if (task->pid != real_pid || task->tgid != real_tgid)
+		return 0;
+
+	out->len = read_ctx->len;
+	out->off = read_ctx->off;
+
+	out->read_ctx_sz = bpf_core_type_size(struct bpf_testmod_test_read_ctx);
+	out->read_ctx_exists = bpf_core_type_exists(struct bpf_testmod_test_read_ctx);
+	out->buf_exists = bpf_core_field_exists(read_ctx->buf);
+	out->off_exists = bpf_core_field_exists(read_ctx->off);
+	out->len_exists = bpf_core_field_exists(read_ctx->len);
+
+	out->comm_len = BPF_CORE_READ_STR_INTO(&out->comm, task, comm);
+
+	return 0;
+}
-- 
2.24.1

