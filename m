Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82391369A7E
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243770AbhDWSy4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:54:56 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55102 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243751AbhDWSyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:54:52 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIsF8l005629
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:16 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383kvnmtqk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:54:15 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:54:10 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 73BE92ED5CA8; Fri, 23 Apr 2021 11:54:09 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 5/6] selftests/bpf: extend linked_vars selftests with static variables
Date:   Fri, 23 Apr 2021 11:53:56 -0700
Message-ID: <20210423185357.1992756-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423185357.1992756-1-andrii@kernel.org>
References: <20210423185357.1992756-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: zbFSKKNkecETotJykF2xkkXqNKJySK6h
X-Proofpoint-ORIG-GUID: zbFSKKNkecETotJykF2xkkXqNKJySK6h
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230122
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
index 267166abe4c1..75dcce539ff1 100644
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
 	/* 100 comes from "winner" input_rodata_weak in first obj file */
 	ASSERT_EQ(skel->bss->output_rodata1, 11 + 22 + 100, "output_weak1");
 	ASSERT_EQ(skel->bss->output_rodata2, 11 + 22 + 100, "output_weak2");
diff --git a/tools/testing/selftests/bpf/progs/linked_vars1.c b/tools/testing/selftests/bpf/progs/linked_vars1.c
index ef9e9d0bb0ca..7d5152c066d9 100644
--- a/tools/testing/selftests/bpf/progs/linked_vars1.c
+++ b/tools/testing/selftests/bpf/progs/linked_vars1.c
@@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
 extern bool CONFIG_BPF_SYSCALL __kconfig __weak;
 extern const void bpf_link_fops __ksym __weak;
 
+static volatile int input_bss_static;
+
 int input_bss1;
 int input_data1 = 1;
 const volatile int input_rodata1 = 11;
@@ -32,7 +34,7 @@ long output_sink1;
 static __noinline int get_bss_res(void)
 {
 	/* just make sure all the relocations work against .text as well */
-	return input_bss1 + input_bss2 + input_bss_weak;
+	return input_bss_static + input_bss1 + input_bss2 + input_bss_weak;
 }
 
 SEC("raw_tp/sys_enter")
diff --git a/tools/testing/selftests/bpf/progs/linked_vars2.c b/tools/testing/selftests/bpf/progs/linked_vars2.c
index e4f5bd388a3c..fdc347a609d9 100644
--- a/tools/testing/selftests/bpf/progs/linked_vars2.c
+++ b/tools/testing/selftests/bpf/progs/linked_vars2.c
@@ -10,6 +10,8 @@ extern int LINUX_KERNEL_VERSION __kconfig;
 extern bool CONFIG_BPF_SYSCALL __kconfig;
 extern const void __start_BTF __ksym;
 
+static volatile int input_bss_static;
+
 int input_bss2;
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

