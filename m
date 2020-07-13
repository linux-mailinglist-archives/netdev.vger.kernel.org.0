Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA3621E392
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 01:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGMXZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 19:25:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36828 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726356AbgGMXZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 19:25:03 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06DNKaER019149
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:25:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=a/eqtSLjPpof28HW6O/K0A0q8XFB+yRskLA59OiOEbk=;
 b=MnqZNGvavZs7Vr33igH6T1AEibyWy2B34KZHw74awpAt8itbQ+628RbhvXU3TvlxE6YW
 n7D8opJukgN70rtrA5uL3yXl3mJjM22I7sAWZ0IqKUu06R5Ual/jUUB2ixLS5fGGxQDw
 fco01HVULGZTkdq6ta8cd+anWS5fnKmR+vE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 327axn2beu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 16:25:02 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 16:24:58 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4078D2EC4105; Mon, 13 Jul 2020 16:24:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/2] tools/bpftool: strip away modifiers from global variables
Date:   Mon, 13 Jul 2020 16:24:09 -0700
Message-ID: <20200713232409.3062144-3-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200713232409.3062144-1-andriin@fb.com>
References: <20200713232409.3062144-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-13_17:2020-07-13,2020-07-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 suspectscore=8 phishscore=0 malwarescore=0 spamscore=0
 mlxlogscore=982 lowpriorityscore=0 adultscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007130170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reliably remove all the type modifiers from read-only (.rodata) global
variable definitions, including cases of inner field const modifiers and
arrays of const values.

Also modify one of selftests to ensure that const volatile struct doesn't
prevent user-space from modifying .rodata variable.

Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c                       | 23 ++++++++-----------
 tools/lib/bpf/btf.h                           |  2 +-
 .../selftests/bpf/prog_tests/skeleton.c       |  6 ++---
 .../selftests/bpf/progs/test_skeleton.c       |  6 +++--
 4 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 10de76b296ba..b59d26e89367 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -88,7 +88,7 @@ static const char *get_map_ident(const struct bpf_map *=
map)
 		return NULL;
 }
=20
-static void codegen_btf_dump_printf(void *ct, const char *fmt, va_list a=
rgs)
+static void codegen_btf_dump_printf(void *ctx, const char *fmt, va_list =
args)
 {
 	vprintf(fmt, args);
 }
@@ -104,17 +104,20 @@ static int codegen_datasec_def(struct bpf_object *o=
bj,
 	int i, err, off =3D 0, pad_cnt =3D 0, vlen =3D btf_vlen(sec);
 	const char *sec_ident;
 	char var_ident[256];
+	bool strip_mods =3D false;
=20
-	if (strcmp(sec_name, ".data") =3D=3D 0)
+	if (strcmp(sec_name, ".data") =3D=3D 0) {
 		sec_ident =3D "data";
-	else if (strcmp(sec_name, ".bss") =3D=3D 0)
+	} else if (strcmp(sec_name, ".bss") =3D=3D 0) {
 		sec_ident =3D "bss";
-	else if (strcmp(sec_name, ".rodata") =3D=3D 0)
+	} else if (strcmp(sec_name, ".rodata") =3D=3D 0) {
 		sec_ident =3D "rodata";
-	else if (strcmp(sec_name, ".kconfig") =3D=3D 0)
+		strip_mods =3D true;
+	} else if (strcmp(sec_name, ".kconfig") =3D=3D 0) {
 		sec_ident =3D "kconfig";
-	else
+	} else {
 		return 0;
+	}
=20
 	printf("	struct %s__%s {\n", obj_name, sec_ident);
 	for (i =3D 0; i < vlen; i++, sec_var++) {
@@ -123,16 +126,10 @@ static int codegen_datasec_def(struct bpf_object *o=
bj,
 		DECLARE_LIBBPF_OPTS(btf_dump_emit_type_decl_opts, opts,
 			.field_name =3D var_ident,
 			.indent_level =3D 2,
+			.strip_mods =3D strip_mods,
 		);
 		int need_off =3D sec_var->offset, align_off, align;
 		__u32 var_type_id =3D var->type;
-		const struct btf_type *t;
-
-		t =3D btf__type_by_id(btf, var_type_id);
-		while (btf_is_mod(t)) {
-			var_type_id =3D t->type;
-			t =3D btf__type_by_id(btf, var_type_id);
-		}
=20
 		if (off > need_off) {
 			p_err("Something is wrong for %s's variable #%d: need offset %d, alre=
ady at %d.\n",
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index be98dd75b791..7f003bbeb35e 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -146,7 +146,7 @@ struct btf_dump_emit_type_decl_opts {
 	/* strip all the const/volatile/restrict mods */
 	bool strip_mods;
 };
-#define btf_dump_emit_type_decl_opts__last_field indent_level
+#define btf_dump_emit_type_decl_opts__last_field strip_mods
=20
 LIBBPF_API int
 btf_dump__emit_type_decl(struct btf_dump *d, __u32 id,
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/te=
sting/selftests/bpf/prog_tests/skeleton.c
index fa153cf67b1b..fe87b77af459 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -41,7 +41,7 @@ void test_skeleton(void)
 	CHECK(bss->in4 !=3D 0, "in4", "got %lld !=3D exp %lld\n", bss->in4, 0LL=
);
 	CHECK(bss->out4 !=3D 0, "out4", "got %lld !=3D exp %lld\n", bss->out4, =
0LL);
=20
-	CHECK(rodata->in6 !=3D 0, "in6", "got %d !=3D exp %d\n", rodata->in6, 0=
);
+	CHECK(rodata->in.in6 !=3D 0, "in6", "got %d !=3D exp %d\n", rodata->in.=
in6, 0);
 	CHECK(bss->out6 !=3D 0, "out6", "got %d !=3D exp %d\n", bss->out6, 0);
=20
 	/* validate we can pre-setup global variables, even in .bss */
@@ -49,7 +49,7 @@ void test_skeleton(void)
 	data->in2 =3D 11;
 	bss->in3 =3D 12;
 	bss->in4 =3D 13;
-	rodata->in6 =3D 14;
+	rodata->in.in6 =3D 14;
=20
 	err =3D test_skeleton__load(skel);
 	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
@@ -60,7 +60,7 @@ void test_skeleton(void)
 	CHECK(data->in2 !=3D 11, "in2", "got %lld !=3D exp %lld\n", data->in2, =
11LL);
 	CHECK(bss->in3 !=3D 12, "in3", "got %d !=3D exp %d\n", bss->in3, 12);
 	CHECK(bss->in4 !=3D 13, "in4", "got %lld !=3D exp %lld\n", bss->in4, 13=
LL);
-	CHECK(rodata->in6 !=3D 14, "in6", "got %d !=3D exp %d\n", rodata->in6, =
14);
+	CHECK(rodata->in.in6 !=3D 14, "in6", "got %d !=3D exp %d\n", rodata->in=
.in6, 14);
=20
 	/* now set new values and attach to get them into outX variables */
 	data->in1 =3D 1;
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/te=
sting/selftests/bpf/progs/test_skeleton.c
index 77ae86f44db5..374ccef704e1 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -20,7 +20,9 @@ long long in4 __attribute__((aligned(64))) =3D 0;
 struct s in5 =3D {};
=20
 /* .rodata section */
-const volatile int in6 =3D 0;
+const volatile struct {
+	const int in6;
+} in =3D {};
=20
 /* .data section */
 int out1 =3D -1;
@@ -46,7 +48,7 @@ int handler(const void *ctx)
 	out3 =3D in3;
 	out4 =3D in4;
 	out5 =3D in5;
-	out6 =3D in6;
+	out6 =3D in.in6;
=20
 	bpf_syscall =3D CONFIG_BPF_SYSCALL;
 	kern_ver =3D LINUX_KERNEL_VERSION;
--=20
2.24.1

