Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8A249F581
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 09:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243260AbiA1Il7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 03:41:59 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17825 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiA1Il4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 03:41:56 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlWB846Tyz9sbn;
        Fri, 28 Jan 2022 16:40:32 +0800 (CST)
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 28 Jan
 2022 16:41:49 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <houtao1@huawei.com>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: check whether s32 is sufficient for kfunc offset
Date:   Thu, 27 Jan 2022 15:15:32 +0800
Message-ID: <20220127071532.384888-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127071532.384888-1-houtao1@huawei.com>
References: <20220127071532.384888-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In add_kfunc_call(), bpf_kfunc_desc->imm with type s32 is used to
represent the offset of called kfunc from __bpf_call_base, so
add a test to ensure that the offset will not be overflowed.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 .../selftests/bpf/prog_tests/ksyms_module.c   | 72 +++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
index d490ad80eccb..ce0cd3446931 100644
--- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
+++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
@@ -6,6 +6,76 @@
 #include "test_ksyms_module.lskel.h"
 #include "test_ksyms_module.skel.h"
 
+/* Most logic comes from bpf_object__read_kallsyms_file() */
+static int test_find_func_in_kallsyms(const char *func, unsigned long *addr)
+{
+	/* Same as KSYM_NAME_LEN */
+	char sym_name[128];
+	char sym_type;
+	unsigned long sym_addr;
+	int ret, err;
+	FILE *f;
+
+	f = fopen("/proc/kallsyms", "r");
+	if (!f)
+		return -errno;
+
+	err = -ENOENT;
+	while (true) {
+		ret = fscanf(f, "%lx %c %127s%*[^\n]\n",
+			     &sym_addr, &sym_type, sym_name);
+		if (ret == EOF && feof(f))
+			break;
+
+		if (ret != 3) {
+			err = -EINVAL;
+			break;
+		}
+
+		if ((sym_type == 't' || sym_type == 'T') &&
+		    !strcmp(sym_name, func)) {
+			*addr = sym_addr;
+			err = 0;
+			break;
+		}
+	}
+
+	fclose(f);
+	return err;
+}
+
+/*
+ * Check whether or not s32 in bpf_kfunc_desc is sufficient
+ * to represent the offset between bpf_testmod_test_mod_kfunc
+ * and __bpf_call_base.
+ */
+void test_ksyms_module_valid_offset(void)
+{
+	unsigned long kfunc_addr;
+	unsigned long base_addr;
+	int used_offset;
+	long actual_offset;
+	int err;
+
+	if (!env.has_testmod) {
+		test__skip();
+		return;
+	}
+
+	err = test_find_func_in_kallsyms("bpf_testmod_test_mod_kfunc",
+					 &kfunc_addr);
+	if (!ASSERT_OK(err, "find kfunc addr"))
+		return;
+
+	err = test_find_func_in_kallsyms("__bpf_call_base", &base_addr);
+	if (!ASSERT_OK(err, "find base addr"))
+		return;
+
+	used_offset = kfunc_addr - base_addr;
+	actual_offset = kfunc_addr - base_addr;
+	ASSERT_EQ((long)used_offset, actual_offset, "kfunc offset overflowed");
+}
+
 void test_ksyms_module_lskel(void)
 {
 	struct test_ksyms_module_lskel *skel;
@@ -55,6 +125,8 @@ void test_ksyms_module_libbpf(void)
 
 void test_ksyms_module(void)
 {
+	if (test__start_subtest("valid_offset"))
+		test_ksyms_module_valid_offset();
 	if (test__start_subtest("lskel"))
 		test_ksyms_module_lskel();
 	if (test__start_subtest("libbpf"))
-- 
2.27.0

