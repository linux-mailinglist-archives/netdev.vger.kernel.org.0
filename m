Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7FA4AD1D1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 07:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345819AbiBHGyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 01:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239613AbiBHGyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 01:54:54 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64549C0401EF;
        Mon,  7 Feb 2022 22:54:52 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JtDDG57vmzZdch;
        Tue,  8 Feb 2022 14:50:38 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 8 Feb
 2022 14:54:49 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>
Subject: [PATCH bpf-next v5] selftests/bpf: do not export subtest as standalone test
Date:   Tue, 8 Feb 2022 14:54:44 +0800
Message-ID: <20220208065444.648778-1-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two subtests in ksyms_module.c are not qualified as static, so these
subtests are exported as standalone tests in tests.h and lead to
confusion for the output of "./test_progs -t ksyms_module".

By using the following command:

  grep "^void \(serial_\)\?test_[a-zA-Z0-9_]\+(\(void\)\?)" \
      tools/testing/selftests/bpf/prog_tests/*.c | \
	awk -F : '{print $1}' | sort | uniq -c | awk '$1 != 1'

find out that other tests also have the similar problem, so fix
these tests by marking subtests in these tests as static.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v5:
 * keep the only subtest in xdp_adjust_frags.c to follow
   the naming convention for test

v4: https://lore.kernel.org/bpf/20220206043107.18549-1-houtao1@huawei.com
 * rebased on bpf-next

v3: https://lore.kernel.org/bpf/20220130092917.14544-1-hotforest@gmail.com
  * add a new patch to unexport unnecessary subtests

v2: https://lore.kernel.org/bpf/20220127071532.384888-1-houtao1@huawei.com
  * add a test to check whether imm will be overflowed for kfunc call

v1: https://lore.kernel.org/bpf/20220119144942.305568-1-houtao1@huawei.com
---
 tools/testing/selftests/bpf/prog_tests/ksyms_module.c      | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c  | 2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c   | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c | 4 ++--
 tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index ecc58c9e7631..a1ebac70ec29 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -6,7 +6,7 @@
 #include "test_ksyms_module.lskel.h"
 #include "test_ksyms_module.skel.h"
 
-void test_ksyms_module_lskel(void)
+static void test_ksyms_module_lskel(void)
 {
 	struct test_ksyms_module_lskel *skel;
 	int err;
@@ -33,7 +33,7 @@ void test_ksyms_module_lskel(void)
 	test_ksyms_module_lskel__destroy(skel);
 }
 
-void test_ksyms_module_libbpf(void)
+static void test_ksyms_module_libbpf(void)
 {
 	struct test_ksyms_module *skel;
 	int err;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
index 134d0ac32f59..d18e6f343c48 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
@@ -2,7 +2,7 @@
 #include <test_progs.h>
 #include <network_helpers.h>
 
-void test_xdp_update_frags(void)
+static void test_xdp_update_frags(void)
 {
 	const char *file = "./test_xdp_update_frags.o";
 	struct bpf_program *prog;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
index 528a8c387720..21ceac24e174 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
@@ -133,7 +133,7 @@ static void test_xdp_adjust_tail_grow2(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_shrink(void)
+static void test_xdp_adjust_frags_tail_shrink(void)
 {
 	const char *file = "./test_xdp_adjust_tail_shrink.o";
 	__u32 exp_size;
@@ -200,7 +200,7 @@ void test_xdp_adjust_frags_tail_shrink(void)
 	bpf_object__close(obj);
 }
 
-void test_xdp_adjust_frags_tail_grow(void)
+static void test_xdp_adjust_frags_tail_grow(void)
 {
 	const char *file = "./test_xdp_adjust_tail_grow.o";
 	__u32 exp_size;
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
index b353e1f3acb5..f775a1613833 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_cpumap_attach.c
@@ -8,7 +8,7 @@
 
 #define IFINDEX_LO	1
 
-void test_xdp_with_cpumap_helpers(void)
+static void test_xdp_with_cpumap_helpers(void)
 {
 	struct test_xdp_with_cpumap_helpers *skel;
 	struct bpf_prog_info info = {};
@@ -68,7 +68,7 @@ void test_xdp_with_cpumap_helpers(void)
 	test_xdp_with_cpumap_helpers__destroy(skel);
 }
 
-void test_xdp_with_cpumap_frags_helpers(void)
+static void test_xdp_with_cpumap_frags_helpers(void)
 {
 	struct test_xdp_with_cpumap_frags_helpers *skel;
 	struct bpf_prog_info info = {};
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
index 463a72fc3e70..ead40016c324 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_devmap_attach.c
@@ -81,7 +81,7 @@ static void test_neg_xdp_devmap_helpers(void)
 	}
 }
 
-void test_xdp_with_devmap_frags_helpers(void)
+static void test_xdp_with_devmap_frags_helpers(void)
 {
 	struct test_xdp_with_devmap_frags_helpers *skel;
 	struct bpf_prog_info info = {};
-- 
2.27.0

