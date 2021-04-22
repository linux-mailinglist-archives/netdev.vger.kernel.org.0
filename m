Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003F13676FB
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 03:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhDVBqx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Apr 2021 21:46:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41832 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234162AbhDVBqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 21:46:50 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13M1jX3U025318
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:15 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 382k2uw5fc-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 18:46:15 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 21 Apr 2021 18:46:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CBEB42ED59F8; Wed, 21 Apr 2021 18:46:08 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 5/6] selftests/bpf: extend linked_vars selftests with static variables
Date:   Wed, 21 Apr 2021 18:45:55 -0700
Message-ID: <20210422014556.3451936-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422014556.3451936-1-andrii@kernel.org>
References: <20210422014556.3451936-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: b4oo_Ykz4DEUpC4jLf24SG9ZDjGohwS4
X-Proofpoint-GUID: b4oo_Ykz4DEUpC4jLf24SG9ZDjGohwS4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_08:2021-04-21,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that BPF static linker supports static variable renames and thus
non-unique static variables in BPF skeleton, add tests validating static
variables are resolved properly during multi-file static linking.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/linked_vars.c | 12 ++++++++----
 tools/testing/selftests/bpf/progs/linked_vars1.c     |  4 +++-
 tools/testing/selftests/bpf/progs/linked_vars2.c     |  4 +++-
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/linked_vars.c b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
index f3d6ba31ef99..73f3fea41230 100644
--- a/tools/testing/selftests/bpf/prog_tests/linked_vars.c
+++ b/tools/testing/selftests/bpf/prog_tests/linked_vars.c
@@ -14,8 +14,12 @@ void test_linked_vars(void)
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
 
+	skel->bss->linked_vars1__input_bss_static = 100;
 	skel->bss->input_bss1 = 1000;
+
+	skel->bss->linked_vars2__input_bss_static = 200;
 	skel->bss->input_bss2 = 2000;
+
 	skel->bss->input_bss_weak = 3000;
 
 	err = linked_vars__load(skel);
@@ -29,11 +33,11 @@ void test_linked_vars(void)
 	/* trigger */
 	syscall(SYS_getpgid);
 
-	ASSERT_EQ(skel->bss->output_bss1, 1000 + 2000 + 3000, "output_bss1");
-	ASSERT_EQ(skel->bss->output_bss2, 1000 + 2000 + 3000, "output_bss2");
+	ASSERT_EQ(skel->bss->output_bss1, 100 + 1000 + 2000 + 3000, "output_bss1");
+	ASSERT_EQ(skel->bss->output_bss2, 200 + 1000 + 2000 + 3000, "output_bss2");
 	/* 10 comes from "winner" input_data_weak in first obj file */
-	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_bss1");
-	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_bss2");
+	ASSERT_EQ(skel->bss->output_data1, 1 + 2 + 10, "output_data1");
+	ASSERT_EQ(skel->bss->output_data2, 1 + 2 + 10, "output_data2");
 	/* 10 comes from "winner" input_rodata_weak in first obj file */
 	ASSERT_EQ(skel->bss->output_rodata1, 11 + 22 + 100, "output_weak1");
 	ASSERT_EQ(skel->bss->output_rodata2, 11 + 22 + 100, "output_weak2");
diff --git a/tools/testing/selftests/bpf/progs/linked_vars1.c b/tools/testing/selftests/bpf/progs/linked_vars1.c
index bc96eff9b8c1..05c7a2739c88 100644
--- a/tools/testing/selftests/bpf/progs/linked_vars1.c
+++ b/tools/testing/selftests/bpf/progs/linked_vars1.c
@@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
 extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
 extern const void bpf_link_fops __ksym __weak;
 
+static volatile int input_bss_static = 0;
+
 int input_bss1 = 0;
 int input_data1 = 1;
 const volatile int input_rodata1 = 11;
@@ -32,7 +34,7 @@ long output_sink1 = 0;
 static __noinline int get_bss_res(void)
 {
 	/* just make sure all the relocations work against .text as well */
-	return input_bss1 + input_bss2 + input_bss_weak;
+	return input_bss_static + input_bss1 + input_bss2 + input_bss_weak;
 }
 
 SEC("raw_tp/sys_enter")
diff --git a/tools/testing/selftests/bpf/progs/linked_vars2.c b/tools/testing/selftests/bpf/progs/linked_vars2.c
index 946c0ce4f505..c390ac667150 100644
--- a/tools/testing/selftests/bpf/progs/linked_vars2.c
+++ b/tools/testing/selftests/bpf/progs/linked_vars2.c
@@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
 extern bool CONFIG_BPF_SYSCALL __kconfig;
 extern const void __start_BTF __ksym;
 
+static volatile int input_bss_static = 0;
+
 int input_bss2 = 0;
 int input_data2 = 2;
 const volatile int input_rodata2 = 22;
@@ -38,7 +40,7 @@ static __noinline int get_data_res(void)
 SEC("raw_tp/sys_enter")
 int BPF_PROG(handler2)
 {
-	output_bss2 = input_bss1 + input_bss2 + input_bss_weak;
+	output_bss2 = input_bss_static + input_bss1 + input_bss2 + input_bss_weak;
 	output_data2 = get_data_res();
 	output_rodata2 = input_rodata1 + input_rodata2 + input_rodata_weak;
 
-- 
2.30.2

