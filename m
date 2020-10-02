Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A293280BD6
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgJBBJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:09:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18340 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387511AbgJBBJa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:09:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0920oEjM025108
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:09:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nfpINll7u7o3miDvuYPXpSI/5kpQpKrznMS9b2mtsTo=;
 b=NfdZHor0XLT2d3tpPOzbKK05fBhXOIR8LL1X2mBpn67fuLSZ2bQq+IUXfQnHLg65yKnC
 mMFVYvb3jSI4FGsIY31+xS9hmyph8czCzvsUUCP07JoBqoZEiTmcyge3cIuGvagM6z9E
 sw4VxqvrQ0OtmGpttUaNXNWJDxfwgboBe8c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 33w01t7rdv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:09:27 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:09:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0E8AF2EC789D; Thu,  1 Oct 2020 18:09:21 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: validate libbpf's auto-sizing of LD/ST/STX instructions
Date:   Thu, 1 Oct 2020 18:06:33 -0700
Message-ID: <20201002010633.3706122-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201002010633.3706122-1-andriin@fb.com>
References: <20201002010633.3706122-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 phishscore=0 mlxlogscore=706 mlxscore=0
 suspectscore=25 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests validating libbpf's auto-resizing of load/store instruction=
s
when used with CO-RE relocations. An explicit and manual approach with us=
ing
bpf_core_read() is also demonstrated and tested. Separate BPF program is
supposed to fail due to using signed integers of sizes that differ from
kernel's sizes.

To reliably simulate 32-bit BTF (i.e., the one with sizeof(long) =3D=3D
sizeof(void *) =3D=3D 4), selftest generates its own custom BTF and passe=
s it as
a replacement for real kernel BTF. This allows to test 32/64-bitness mix =
on
all architectures.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/core_autosize.c  | 199 ++++++++++++++++++
 .../selftests/bpf/progs/test_core_autosize.c  | 148 +++++++++++++
 2 files changed, 347 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.=
c

diff --git a/tools/testing/selftests/bpf/prog_tests/core_autosize.c b/too=
ls/testing/selftests/bpf/prog_tests/core_autosize.c
new file mode 100644
index 000000000000..2155c12bd83e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/core_autosize.c
@@ -0,0 +1,199 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+
+#include <test_progs.h>
+#include "test_core_autosize.skel.h"
+#include <bpf/btf.h>
+
+static int duration =3D 0;
+
+static struct {
+	unsigned long long ptr_samesized;
+	unsigned long long val1_samesized;
+	unsigned long long val2_samesized;
+	unsigned long long val3_samesized;
+	unsigned long long val4_samesized;
+
+	unsigned long long ptr_downsized;
+	unsigned long long val1_downsized;
+	unsigned long long val2_downsized;
+	unsigned long long val3_downsized;
+	unsigned long long val4_downsized;
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
+} out;
+
+void test_core_autosize(void)
+{
+	char btf_file[] =3D "/tmp/core_autosize.btf.XXXXXX";
+	int err, fd =3D -1, zero =3D 0;
+	int char_id, short_id, int_id, long_long_id, void_ptr_id, id;
+	struct test_core_autosize* skel =3D NULL;
+	struct bpf_object_load_attr load_attr =3D {};
+	struct bpf_program *prog;
+	struct bpf_map *bss_map;
+	struct btf *btf =3D NULL;
+	size_t written;
+	const void *raw_data;
+	__u32 raw_sz;
+	FILE *f =3D NULL;
+
+	btf =3D btf__new_empty();
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
+	 */
+
+	/* force 32-bit pointer size */
+	btf__set_pointer_size(btf, 4);
+
+	char_id =3D btf__add_int(btf, "unsigned char", 1, 0);
+	ASSERT_EQ(char_id, 1, "char_id");
+	short_id =3D btf__add_int(btf, "unsigned short", 2, 0);
+	ASSERT_EQ(short_id, 2, "short_id");
+	/* "long unsigned int" of 4 byte size tells BTF that sizeof(void *) =3D=
=3D 4 */
+	int_id =3D btf__add_int(btf, "long unsigned int", 4, 0);
+	ASSERT_EQ(int_id, 3, "int_id");
+	long_long_id =3D btf__add_int(btf, "unsigned long long", 8, 0);
+	ASSERT_EQ(long_long_id, 4, "long_long_id");
+	void_ptr_id =3D btf__add_ptr(btf, 0);
+	ASSERT_EQ(void_ptr_id, 5, "void_ptr_id");
+
+	id =3D btf__add_struct(btf, "test_struct", 20 /* bytes */);
+	ASSERT_EQ(id, 6, "struct_id");
+	err =3D btf__add_field(btf, "ptr", void_ptr_id, 0, 0);
+	err =3D err ?: btf__add_field(btf, "val2", int_id, 32, 0);
+	err =3D err ?: btf__add_field(btf, "val1", long_long_id, 64, 0);
+	err =3D err ?: btf__add_field(btf, "val3", short_id, 128, 0);
+	err =3D err ?: btf__add_field(btf, "val4", char_id, 144, 0);
+	ASSERT_OK(err, "struct_fields");
+
+	fd =3D mkstemp(btf_file);
+	if (CHECK(fd < 0, "btf_tmp", "failed to create file: %d\n", fd))
+		goto cleanup;
+	f =3D fdopen(fd, "w");
+	if (!ASSERT_OK_PTR(f, "btf_fdopen"))
+		goto cleanup;
+
+	raw_data =3D btf__get_raw_data(btf, &raw_sz);
+	if (!ASSERT_OK_PTR(raw_data, "raw_data"))
+		goto cleanup;
+	written =3D fwrite(raw_data, 1, raw_sz, f);
+	if (CHECK(written !=3D raw_sz, "btf_write", "written: %zu, errno: %d\n"=
, written, errno))
+		goto cleanup;
+	fflush(f);
+	fclose(f);
+	f =3D NULL;
+	close(fd);
+	fd =3D -1;
+
+	/* open and load BPF program with custom BTF as the kernel BTF */
+	skel =3D test_core_autosize__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	/* disable handle_signed() for now */
+	prog =3D bpf_object__find_program_by_name(skel->obj, "handle_signed");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	bpf_program__set_autoload(prog, false);
+
+	load_attr.obj =3D skel->obj;
+	load_attr.target_btf_path =3D btf_file;
+	err =3D bpf_object__load_xattr(&load_attr);
+	if (!ASSERT_OK(err, "prog_load"))
+		goto cleanup;
+
+	prog =3D bpf_object__find_program_by_name(skel->obj, "handle_samesize")=
;
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_samesize =3D bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_samesize, "prog_attach"))
+		goto cleanup;
+
+	prog =3D bpf_object__find_program_by_name(skel->obj, "handle_downsize")=
;
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_downsize =3D bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_downsize, "prog_attach"))
+		goto cleanup;
+
+	prog =3D bpf_object__find_program_by_name(skel->obj, "handle_probed");
+	if (!ASSERT_OK_PTR(prog, "prog_find"))
+		goto cleanup;
+	skel->links.handle_probed =3D bpf_program__attach(prog);
+	if (!ASSERT_OK_PTR(skel->links.handle_probed, "prog_attach"))
+		goto cleanup;
+
+	usleep(1);
+
+	bss_map =3D bpf_object__find_map_by_name(skel->obj, "test_cor.bss");
+	if (!ASSERT_OK_PTR(bss_map, "bss_map_find"))
+		goto cleanup;
+
+	err =3D bpf_map_lookup_elem(bpf_map__fd(bss_map), &zero, (void *)&out);
+	if (!ASSERT_OK(err, "bss_lookup"))
+		goto cleanup;
+
+	ASSERT_EQ(out.ptr_samesized, 0x01020304, "ptr_samesized");
+	ASSERT_EQ(out.val1_samesized, 0x1020304050607080, "val1_samesized");
+	ASSERT_EQ(out.val2_samesized, 0x0a0b0c0d, "val2_samesized");
+	ASSERT_EQ(out.val3_samesized, 0xfeed, "val3_samesized");
+	ASSERT_EQ(out.val4_samesized, 0xb9, "val4_samesized");
+
+	ASSERT_EQ(out.ptr_downsized, 0x01020304, "ptr_downsized");
+	ASSERT_EQ(out.val1_downsized, 0x1020304050607080, "val1_downsized");
+	ASSERT_EQ(out.val2_downsized, 0x0a0b0c0d, "val2_downsized");
+	ASSERT_EQ(out.val3_downsized, 0xfeed, "val3_downsized");
+	ASSERT_EQ(out.val4_downsized, 0xb9, "val4_downsized");
+
+	ASSERT_EQ(out.ptr_probed, 0x01020304, "ptr_probed");
+	ASSERT_EQ(out.val1_probed, 0x1020304050607080, "val1_probed");
+	ASSERT_EQ(out.val2_probed, 0x0a0b0c0d, "val2_probed");
+	ASSERT_EQ(out.val3_probed, 0xfeed, "val3_probed");
+	ASSERT_EQ(out.val4_probed, 0xb9, "val4_probed");
+
+	test_core_autosize__destroy(skel);
+	skel =3D NULL;
+
+	/* now re-load with handle_signed() enabled, it should fail loading */
+	skel =3D test_core_autosize__open();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	load_attr.obj =3D skel->obj;
+	load_attr.target_btf_path =3D btf_file;
+	err =3D bpf_object__load_xattr(&load_attr);
+	if (!ASSERT_ERR(err, "bad_prog_load"))
+		goto cleanup;
+
+cleanup:
+	if (f)
+		fclose(f);
+	if (fd >=3D 0)
+		close(fd);
+	remove(btf_file);
+	btf__free(btf);
+	test_core_autosize__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_core_autosize.c b/too=
ls/testing/selftests/bpf/progs/test_core_autosize.c
new file mode 100644
index 000000000000..1afeae83da1d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_core_autosize.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Facebook
+
+#include <linux/bpf.h>
+#include <stdint.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+char _license[] SEC("license") =3D "GPL";
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
+struct {
+	unsigned int ptr; /* can't use `void *`, it is always 8 byte in BPF tar=
get */
+	unsigned int val2;
+	unsigned long long val1;
+	unsigned short val3;
+	unsigned char val4;
+	unsigned char _pad;
+	/* total sz: 20 */
+} input =3D {
+	.ptr =3D 0x01020304,
+	.val1 =3D 0x1020304050607080,
+	.val2 =3D 0x0a0b0c0d,
+	.val3 =3D 0xfeed,
+	.val4 =3D 0xb9,
+	._pad =3D 0xff, /* make sure no accidental zeros are present */
+};
+
+unsigned long long ptr_samesized =3D 0;
+unsigned long long val1_samesized =3D 0;
+unsigned long long val2_samesized =3D 0;
+unsigned long long val3_samesized =3D 0;
+unsigned long long val4_samesized =3D 0;
+
+unsigned long long ptr_downsized =3D 0;
+unsigned long long val1_downsized =3D 0;
+unsigned long long val2_downsized =3D 0;
+unsigned long long val3_downsized =3D 0;
+unsigned long long val4_downsized =3D 0;
+
+unsigned long long ptr_probed =3D 0;
+unsigned long long val1_probed =3D 0;
+unsigned long long val2_probed =3D 0;
+unsigned long long val3_probed =3D 0;
+unsigned long long val4_probed =3D 0;
+
+unsigned long long ptr_signed =3D 0;
+unsigned long long val1_signed =3D 0;
+unsigned long long val2_signed =3D 0;
+unsigned long long val3_signed =3D 0;
+unsigned long long val4_signed =3D 0;
+
+SEC("raw_tp/sys_exit")
+int handle_samesize(void *ctx)
+{
+	struct test_struct___samesize *in =3D (void *)&input;
+
+	ptr_samesized =3D (unsigned long long)in->ptr;
+	val1_samesized =3D in->val1;
+	val2_samesized =3D in->val2;
+	val3_samesized =3D in->val3;
+	val4_samesized =3D in->val4;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_exit")
+int handle_downsize(void *ctx)
+{
+	struct test_struct___downsize *in =3D (void *)&input;
+
+	ptr_downsized =3D (unsigned long long)in->ptr;
+	val1_downsized =3D in->val1;
+	val2_downsized =3D in->val2;
+	val3_downsized =3D in->val3;
+	val4_downsized =3D in->val4;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_probed(void *ctx)
+{
+	struct test_struct___downsize *in =3D (void *)&input;
+	__u64 tmp;
+
+	tmp =3D 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->ptr), &in->ptr);
+	ptr_probed =3D tmp;
+
+	tmp =3D 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val1), &in->val1);
+	val1_probed =3D tmp;
+
+	tmp =3D 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val2), &in->val2);
+	val2_probed =3D tmp;
+
+	tmp =3D 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val3), &in->val3);
+	val3_probed =3D tmp;
+
+	tmp =3D 0;
+	bpf_core_read(&tmp, bpf_core_field_size(in->val4), &in->val4);
+	val4_probed =3D tmp;
+
+	return 0;
+}
+
+SEC("raw_tp/sys_enter")
+int handle_signed(void *ctx)
+{
+	struct test_struct___signed *in =3D (void *)&input;
+
+	val2_signed =3D in->val2;
+	val3_signed =3D in->val3;
+	val4_signed =3D in->val4;
+
+	return 0;
+}
--=20
2.24.1

