Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E887627DCAA
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 01:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbgI2X3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 19:29:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55716 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729049AbgI2X3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 19:29:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08TNPsgk031553
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:29:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=c+EFj3NWpdkScaXrtMX/Ov0RQNvpiK8KcQ9md5jLi7c=;
 b=JuEO3aD6c22IBk+iFyl1bo7Ssy+eKN8DcFvwrEv4CQzkN65O0K4p3hrB14usHhNX9a7h
 AdwOMKVGEVbRnqJK3O/mA+PNQbsonm3youSipYQBSdxpr27TVMceDZ3b69uuZRavMQa1
 +jSxZ6w0EZjUs9Pm883iwH/RPlUui8h5uUo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33t3cpg2nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 16:29:03 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Sep 2020 16:29:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D44BC2EC77D1; Tue, 29 Sep 2020 16:28:54 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next 4/4] selftests/bpf: test "incremental" btf_dump in C format
Date:   Tue, 29 Sep 2020 16:28:43 -0700
Message-ID: <20200929232843.1249318-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200929232843.1249318-1-andriin@fb.com>
References: <20200929232843.1249318-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-29_14:2020-09-29,2020-09-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 mlxlogscore=638
 suspectscore=25 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009290198
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test validating that btf_dump works fine with BTFs that are modified =
and
incrementally generated.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/btf_dump.c       | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/te=
sting/selftests/bpf/prog_tests/btf_dump.c
index 39fb81d9daeb..c60091ee8a21 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -129,6 +129,109 @@ static int test_btf_dump_case(int n, struct btf_dum=
p_test_case *t)
 	return err;
 }
=20
+static char *dump_buf;
+static size_t dump_buf_sz;
+static FILE *dump_buf_file;
+
+void test_btf_dump_incremental(void)
+{
+	struct btf *btf =3D NULL;
+	struct btf_dump *d =3D NULL;
+	struct btf_dump_opts opts;
+	int id, err, i;
+
+	dump_buf_file =3D open_memstream(&dump_buf, &dump_buf_sz);
+	if (!ASSERT_OK_PTR(dump_buf_file, "dump_memstream"))
+		return;
+	btf =3D btf__new_empty();
+	if (!ASSERT_OK_PTR(btf, "new_empty"))
+		goto err_out;
+	opts.ctx =3D dump_buf_file;
+	d =3D btf_dump__new(btf, NULL, &opts, btf_dump_printf);
+	if (!ASSERT_OK(libbpf_get_error(d), "btf_dump__new"))
+		goto err_out;
+
+	/* First, generate BTF corresponding to the following C code:
+	 *
+	 * enum { VAL =3D 1 };
+	 *
+	 * struct s { int x; };
+	 *
+	 */
+	id =3D btf__add_enum(btf, NULL, 4);
+	ASSERT_EQ(id, 1, "enum_id");
+	err =3D btf__add_enum_value(btf, "VAL", 1);
+	ASSERT_OK(err, "enum_val_ok");
+
+	id =3D btf__add_int(btf, "int", 4, BTF_INT_SIGNED);
+	ASSERT_EQ(id, 2, "int_id");
+
+	id =3D btf__add_struct(btf, "s", 4);
+	ASSERT_EQ(id, 3, "struct_id");
+	err =3D btf__add_field(btf, "x", 2, 0, 0);
+	ASSERT_OK(err, "field_ok");
+
+	for (i =3D 1; i <=3D btf__get_nr_types(btf); i++) {
+		err =3D btf_dump__dump_type(d, i);
+		ASSERT_OK(err, "dump_type_ok");
+	}
+
+	fflush(dump_buf_file);
+	dump_buf[dump_buf_sz] =3D 0; /* some libc implementations don't do this=
 */
+	ASSERT_STREQ(dump_buf,
+"enum {\n"
+"	VAL =3D 1,\n"
+"};\n"
+"\n"
+"struct s {\n"
+"	int x;\n"
+"};\n\n", "c_dump1");
+
+	/* Now, after dumping original BTF, append another struct that embeds
+	 * anonymous enum. It also has a name conflict with the first struct:
+	 *
+	 * struct s___2 {
+	 *     enum { VAL___2 =3D 1 } x;
+	 *     struct s s;
+	 * };
+	 *
+	 * This will test that btf_dump'er maintains internal state properly.
+	 * Note that VAL___2 enum value. It's because we've already emitted
+	 * that enum as a global anonymous enum, so btf_dump will ensure that
+	 * enum values don't conflict;
+	 *
+	 */
+	fseek(dump_buf_file, 0, SEEK_SET);
+
+	id =3D btf__add_struct(btf, "s", 4);
+	ASSERT_EQ(id, 4, "struct_id");
+	err =3D btf__add_field(btf, "x", 1, 0, 0);
+	ASSERT_OK(err, "field_ok");
+	err =3D btf__add_field(btf, "s", 3, 32, 0);
+	ASSERT_OK(err, "field_ok");
+
+	for (i =3D 1; i <=3D btf__get_nr_types(btf); i++) {
+		err =3D btf_dump__dump_type(d, i);
+		ASSERT_OK(err, "dump_type_ok");
+	}
+
+	fflush(dump_buf_file);
+	dump_buf[dump_buf_sz] =3D 0; /* some libc implementations don't do this=
 */
+	ASSERT_STREQ(dump_buf,
+"struct s___2 {\n"
+"	enum {\n"
+"		VAL___2 =3D 1,\n"
+"	} x;\n"
+"	struct s s;\n"
+"};\n\n" , "c_dump1");
+
+err_out:
+	fclose(dump_buf_file);
+	free(dump_buf);
+	btf_dump__free(d);
+	btf__free(btf);
+}
+
 void test_btf_dump() {
 	int i;
=20
@@ -140,4 +243,6 @@ void test_btf_dump() {
=20
 		test_btf_dump_case(i, &btf_dump_test_cases[i]);
 	}
+	if (test__start_subtest("btf_dump: incremental"))
+		test_btf_dump_incremental();
 }
--=20
2.24.1

