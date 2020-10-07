Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF4C28691B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgJGUa4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Oct 2020 16:30:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47916 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727776AbgJGUa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:30:56 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 097KSiOZ017760
        for <netdev@vger.kernel.org>; Wed, 7 Oct 2020 13:30:54 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33xmypddqr-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 13:30:54 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 13:30:03 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AF5212EC7B90; Wed,  7 Oct 2020 13:29:56 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: validate libbpf's auto-sizing of LD/ST/STX instructions
Date:   Wed, 7 Oct 2020 13:29:46 -0700
Message-ID: <20201007202946.3684483-5-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201007202946.3684483-1-andrii@kernel.org>
References: <20201007202946.3684483-1-andrii@kernel.org>
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=741 spamscore=0
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=25
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

Add selftests validating libbpf's auto-resizing of load/store instructions
when used with CO-RE relocations. An explicit and manual approach with using
bpf_core_read() is also demonstrated and tested. Separate BPF program is
supposed to fail due to using signed integers of sizes that differ from
kernel's sizes.

To reliably simulate 32-bit BTF (i.e., the one with sizeof(long) ==
sizeof(void *) == 4), selftest generates its own custom BTF and passes it as
a replacement for real kernel BTF. This allows to test 32/64-bitness mix on
all architectures.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/core_autosize.c  | 225 ++++++++++++++++++
 .../selftests/bpf/progs/test_core_autosize.c  | 172 +++++++++++++
 2 files changed, 397 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_autosize.c b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
new file mode 100644
index 000000000000..981c251453d9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+#include <bpf/btf.h>
+
+/* real layout and sizes according to test's (32-bit) BTF
+ * needs to be defined before skeleton is included */
+struct test_struct___real {
+	unsigned int ptr; /* can't use `void *`, it is always 8 byte in BPF target */
+	unsigned int val2;
+	unsigned long long val1;
+	unsigned short val3;
+	unsigned char val4;
+	unsigned char _pad;
+};
+
+#include "test_core_autosize.skel.h"
+
+static int duration = 0;
+
+static struct {
+	unsigned long long ptr_samesized;
+	unsigned long long val1_samesized;
+	unsigned long long val2_samesized;
+	unsigned long long val3_samesized;
+	unsigned long long val4_samesized;
+	struct test_struct___real output_samesized;
+
+	unsigned long long ptr_downsized;
+	unsigned long long val1_downsized;
+	unsigned long long val2_downsized;
+	unsigned long long val3_downsized;
+	unsigned long long val4_downsized;
+	struct test_struct___real output_downsized;
+
+	unsigned long long ptr_probed;
+	unsigned long long val1_probed;
+	unsigned long long val2_probed;
+	unsigned long long val3_probed;
+	unsigned long long val4_probed;
+
+	unsigned long long ptr_signed;
+	unsigned long long val1_signed;
+	unsigned long long val2_signed;
+	unsigned long long val3_signed;
+	unsigned long long val4_signed;
+	struct test_struct___real output_signed;
+} out;
+
+void test_core_autosize(void)
+{
+	char btf_file[] = "/tmp/core_autosize.btf.XXXXXX";
+	int err, fd = -1, zero = 0;
+	int char_id, short_id, int_id, long_long_id, void_ptr_id, id;
+	struct test_core_autosize* skel = NULL;
+	struct bpf_object_load_attr load_attr = {};
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct btf *btf = NULL;
+	size_t written;
+	const void *raw_data;
+	__u32 raw_sz;
+	FILE *f = NULL;
+
+	btf = btf__new_empty();
+	if (!ASSERT_OK_PTR(btf, "empty_btf"))
+		return;
+	/* Emit the following struct with 32-bit pointer size:
+	 *
+	 * struct test_struct {
+	 *     void *ptr;
+	 *     unsigned long val2;
+	 *     unsigned long long val1;
+	 *     unsigned short val3;
+	 *     unsigned char val4;
+	 *     char: 8;
+	 * };
+	 *
+	 * This struct is going to be used as the "kernel BTF" for this test.
+	 * It's equivalent memory-layout-wise to test_struct__real above.
+	 */
+
+	/* force 32-bit pointer size */
+	btf__set_pointer_size(btf, 4);
+
+	char_id = btf__add_int(btf, "unsigned char", 1, 0);
+	ASSERT_EQ(char_id, 1, "char_id");
+	short_id = btf__add_int(btf, "unsigned short", 2, 0);
+	ASSERT_EQ(short_id, 2, "short_id");
+	/* "long unsigned int" of 4 byte size tells BTF that sizeof(void *) == 4 */
+	int_id = btf__add_int(btf, "long unsigned int", 4, 0);
+	ASSERT_EQ(int_id, 3, "int_id");
+	long_long_id = btf__add_int(btf, "unsigned long long", 8, 0);
+	ASSERT_EQ(long_long_id, 4, "long_long_id");
+	void_ptr_id = btf__add_ptr(btf, 0);
+	ASSERT_EQ(void_ptr_id, 5, "void_ptr_id");
+
+	id = btf__add_struct(btf, "test_struct", 20 /* bytes */);
+	ASSERT_EQ(id, 6, "struct_id");
+	err = btf__add_field(btf, "ptr", void_ptr_id, 0, 0);
+	err = err ?: btf__add_field(btf, "val2", int_id, 32, 0);
+	err = err ?: btf__add_field(btf, "val1", long_long_id, 64, 0);
+	err = err ?: btf__add_field(btf, "val3", short_id, 128, 0);
+	err = err ?: btf__add_field(btf, "val4", char_id, 144, 0);
+	ASSERT_OK(err, "struct_fields");
+
+	fd = mkstemp(btf_file);
+	if (CHECK(fd < 0, "btf_tmp", "failed to create file: %d\n", fd))
+		goto cleanup;
+	f = fdopen(fd, "w");
+	if (!ASSERT_OK_PTR(f, "btf_fdopen"))
+		goto cleanup;
+
+	raw_data = btf__get_raw_data(btf, &raw_sz);
+	if (!ASSERT_OK_PTR(raw_data, "raw_data"))
+		goto cleanup;
+	written = fwrite(raw_data, 1, raw_sz, f);
+	if (CHECK(written != raw_sz, "btf_write", "written: %zu, errno: %d\n", written, errno))
+		goto cleanup;
+	fflush(f);
+	fclose(f);
+	f = NULL;
+	close(fd);
+	fd = -1;
+
+	/* open and load BPF program with custom BTF as the kernel BTF */
+	skel = test_core_autosize__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	/* disable handle_signed() for now */
+	prog = bpf_object__find_program_by_name(skel->obj, "handle_signed");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	bpf_program__set_autoload(prog, false);
+
+	load_attr.obj = skel->obj;
+	load_attr.target_btf_path = btf_file;
+	err = bpf_object__load_xattr(&load_attr);
+	if (!ASSERT_OK(err, "prog_load"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_name(skel->obj, "handle_samesize");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_samesize = bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_samesize, "prog_attach"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_name(skel->obj, "handle_downsize");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_downsize = bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_downsize, "prog_attach"))
+		goto cleanup;
+
+	prog = bpf_object__find_program_by_name(skel->obj, "handle_probed");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_probed = bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_probed, "prog_attach"))
+		goto cleanup;
+
+	usleep(1);
+
+	bss_map = bpf_object__find_map_by_name(skel->obj, "test_cor.bss");
+	if (!ASSERT_OK_PTR(bss_map, "bss_map_find"))
+		goto cleanup;
+
+	err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &zero, (void *)&out);
+	if (!ASSERT_OK(err, "bss_lookup"))
+		goto cleanup;
+
+	ASSERT_EQ(out.ptr_samesized, 0x01020304, "ptr_samesized");
+	ASSERT_EQ(out.val1_samesized, 0x1020304050607080, "val1_samesized");
+	ASSERT_EQ(out.val2_samesized, 0x0a0b0c0d, "val2_samesized");
+	ASSERT_EQ(out.val3_samesized, 0xfeed, "val3_samesized");
+	ASSERT_EQ(out.val4_samesized, 0xb9, "val4_samesized");
+	ASSERT_EQ(out.output_samesized.ptr, 0x01020304, "ptr_samesized");
+	ASSERT_EQ(out.output_samesized.val1, 0x1020304050607080, "val1_samesized");
+	ASSERT_EQ(out.output_samesized.val2, 0x0a0b0c0d, "val2_samesized");
+	ASSERT_EQ(out.output_samesized.val3, 0xfeed, "val3_samesized");
+	ASSERT_EQ(out.output_samesized.val4, 0xb9, "val4_samesized");
+
+	ASSERT_EQ(out.ptr_downsized, 0x01020304, "ptr_downsized");
+	ASSERT_EQ(out.val1_downsized, 0x1020304050607080, "val1_downsized");
+	ASSERT_EQ(out.val2_downsized, 0x0a0b0c0d, "val2_downsized");
+	ASSERT_EQ(out.val3_downsized, 0xfeed, "val3_downsized");
+	ASSERT_EQ(out.val4_downsized, 0xb9, "val4_downsized");
+	ASSERT_EQ(out.output_downsized.ptr, 0x01020304, "ptr_downsized");
+	ASSERT_EQ(out.output_downsized.val1, 0x1020304050607080, "val1_downsized");
+	ASSERT_EQ(out.output_downsized.val2, 0x0a0b0c0d, "val2_downsized");
+	ASSERT_EQ(out.output_downsized.val3, 0xfeed, "val3_downsized");
+	ASSERT_EQ(out.output_downsized.val4, 0xb9, "val4_downsized");
+
+	ASSERT_EQ(out.ptr_probed, 0x01020304, "ptr_probed");
+	ASSERT_EQ(out.val1_probed, 0x1020304050607080, "val1_probed");
+	ASSERT_EQ(out.val2_probed, 0x0a0b0c0d, "val2_probed");
+	ASSERT_EQ(out.val3_probed, 0xfeed, "val3_probed");
+	ASSERT_EQ(out.val4_probed, 0xb9, "val4_probed");
+
+	test_core_autosize__destroy(skel);
+	skel = NULL;
+
+	/* now re-load with handle_signed() enabled, it should fail loading */
+	skel = test_core_autosize__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	load_attr.obj = skel->obj;
+	load_attr.target_btf_path = btf_file;
+	err = bpf_object__load_xattr(&load_attr);
+	if (!ASSERT_ERR(err, "bad_prog_load"))
+		goto cleanup;
+
+cleanup:
+	if (f)
+		fclose(f);
+	if (fd >= 0)
+		close(fd);
+	remove(btf_file);
+	btf__free(btf);
+	test_core_autosize__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/tools/testing/selftests/bpf/progs/test_core_autosize.c
new file mode 100644
index 000000000000..e999f2e2ea22
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") = "GPL";
+
+/* fields of exactly the same size */
+struct test_struct___samesize {
+	void *ptr;
+	unsigned long long val1;
+	unsigned int val2;
+	unsigned short val3;
+	unsigned char val4;
+} __attribute((preserve_access_index));
+
+/* unsigned fields that have to be downsized by libbpf */
+struct test_struct___downsize {
+	void *ptr;
+	unsigned long val1;
+	unsigned long val2;
+	unsigned long val3;
+	unsigned long val4;
+	/* total sz: 40 */
+} __attribute__((preserve_access_index));
+
+/* fields with signed integers of wrong size, should be rejected */
+struct test_struct___signed {
+	void *ptr;
+	long val1;
+	long val2;
+	long val3;
+	long val4;
+} __attribute((preserve_access_index));
+
+/* real layout and sizes according to test's (32-bit) BTF */
+struct test_struct___real {
+	unsigned int ptr; /* can't use `void *`, it is always 8 byte in BPF target */
+	unsigned int val2;
+	unsigned long long val1;
+	unsigned short val3;
+	unsigned char val4;
+	unsigned char _pad;
+	/* total sz: 20 */
+};
+
+struct test_struct___real input = {
+	.ptr = 0x01020304,
+	.val1 = 0x1020304050607080,
+	.val2 = 0x0a0b0c0d,
+	.val3 = 0xfeed,
+	.val4 = 0xb9,
+	._pad = 0xff, /* make sure no accidental zeros are present */
+};
+
+unsigned long long ptr_samesized = 0;
+unsigned long long val1_samesized = 0;
+unsigned long long val2_samesized = 0;
+unsigned long long val3_samesized = 0;
+unsigned long long val4_samesized = 0;
+struct test_struct___real output_samesized = {};
+
+unsigned long long ptr_downsized = 0;
+unsigned long long val1_downsized = 0;
+unsigned long long val2_downsized = 0;
+unsigned long long val3_downsized = 0;
+unsigned long long val4_downsized = 0;
+struct test_struct___real output_downsized = {};
+
+unsigned long long ptr_probed = 0;
+unsigned long long val1_probed = 0;
+unsigned long long val2_probed = 0;
+unsigned long long val3_probed = 0;
+unsigned long long val4_probed = 0;
+
+unsigned long long ptr_signed = 0;
+unsigned long long val1_signed = 0;
+unsigned long long val2_signed = 0;
+unsigned long long val3_signed = 0;
+unsigned long long val4_signed = 0;
+struct test_struct___real output_signed = {};
+
+SEC("raw_tp/sys_exit")
+int handle_samesize(void *ctx)
+{
+	struct test_struct___samesize *in = (void *)&input;
+	struct test_struct___samesize *out = (void *)&output_samesized;
+
+	ptr_samesized = (unsigned long long)in->ptr;
+	val1_samesized = in->val1;
+	val2_samesized = in->val2;
+	val3_samesized = in->val3;
+	val4_samesized = in->val4;
+
+	out->ptr = in->ptr;
+	out->val1 = in->val1;
+	out->val2 = in->val2;
+	out->val3 = in->val3;
+	out->val4 = in->val4;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int handle_downsize(void *ctx)
+{
+	struct test_struct___downsize *in = (void *)&input;
+	struct test_struct___downsize *out = (void *)&output_downsized;
+
+	ptr_downsized = (unsigned long long)in->ptr;
+	val1_downsized = in->val1;
+	val2_downsized = in->val2;
+	val3_downsized = in->val3;
+	val4_downsized = in->val4;
+
+	out->ptr = in->ptr;
+	out->val1 = in->val1;
+	out->val2 = in->val2;
+	out->val3 = in->val3;
+	out->val4 = in->val4;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_probed(void *ctx)
+{
+	struct test_struct___downsize *in = (void *)&input;
+	__u64 tmp;
+
+	tmp = 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
+	ptr_probed = tmp;
+
+	tmp = 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val1), &in->val1);
+	val1_probed = tmp;
+
+	tmp = 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val2), &in->val2);
+	val2_probed = tmp;
+
+	tmp = 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val3), &in->val3);
+	val3_probed = tmp;
+
+	tmp = 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val4), &in->val4);
+	val4_probed = tmp;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_signed(void *ctx)
+{
+	struct test_struct___signed *in = (void *)&input;
+	struct test_struct___signed *out = (void *)&output_signed;
+
+	val2_signed = in->val2;
+	val3_signed = in->val3;
+	val4_signed = in->val4;
+
+	out->val2= in->val2;
+	out->val3= in->val3;
+	out->val4= in->val4;
+
+	return 0;
+}
-- 
2.24.1

