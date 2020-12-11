Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281B02D8173
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405184AbgLKV7q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Dec 2020 16:59:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405129AbgLKV7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:59:19 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 0BBLoiqm012833
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:36 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 35bqd4gs3d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:36 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 13:58:35 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D4C9D2EC8ED7; Fri, 11 Dec 2020 13:58:31 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: add set_attach_target() API selftest for module target
Date:   Fri, 11 Dec 2020 13:58:25 -0800
Message-ID: <20201211215825.3646154-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201211215825.3646154-1-andrii@kernel.org>
References: <20201211215825.3646154-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_09:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=964
 suspectscore=8 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012110144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test for bpf_program__set_attach_target() API, validating it can find
kernel module fentry target.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/module_attach.c  | 11 ++++++++++-
 .../testing/selftests/bpf/progs/test_module_attach.c  | 11 +++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
index 4b65e9918764..50796b651f72 100644
--- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
@@ -28,10 +28,18 @@ void test_module_attach(void)
 	struct test_module_attach__bss *bss;
 	int err;
 
-	skel = test_module_attach__open_and_load();
+	skel = test_module_attach__open();
 	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
 		return;
 
+	err = bpf_program__set_attach_target(skel->progs.handle_fentry_manual,
+					     0, "bpf_testmod_test_read");
+	ASSERT_OK(err, "set_attach_target");
+
+	err = test_module_attach__load(skel);
+	if (CHECK(err, "skel_load", "failed to load skeleton\n"))
+		return;
+
 	bss = skel->bss;
 
 	err = test_module_attach__attach(skel);
@@ -44,6 +52,7 @@ void test_module_attach(void)
 	ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
 	ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
 	ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
+	ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
 	ASSERT_EQ(bss->fexit_read_sz, READ_SZ, "fexit");
 	ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
 	ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
index b563563df172..efd1e287ac17 100644
--- a/tools/testing/selftests/bpf/progs/test_module_attach.c
+++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
@@ -38,6 +38,17 @@ int BPF_PROG(handle_fentry,
 	return 0;
 }
 
+__u32 fentry_manual_read_sz = 0;
+
+SEC("fentry/placeholder")
+int BPF_PROG(handle_fentry_manual,
+	     struct file *file, struct kobject *kobj,
+	     struct bin_attribute *bin_attr, char *buf, loff_t off, size_t len)
+{
+	fentry_manual_read_sz = len;
+	return 0;
+}
+
 __u32 fexit_read_sz = 0;
 int fexit_ret = 0;
 
-- 
2.24.1

