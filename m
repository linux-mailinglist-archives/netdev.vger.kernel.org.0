Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A724B210420
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgGAGpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:45:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31444 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727983AbgGAGpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:45:50 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0616fCGS027042
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=st9dicXue3nwPwPszDUQv4oirfmRwPAKDRm+vyeM0+A=;
 b=kbbMI/Cz2jbjkLW4EQukuV67JLVG+tc9duJXRY2JLYFdqXKoewQBDercYeWTwVvlPuMy
 mYk1khQJftaikWUs+GhvhD5AmJZFM+RvVenH2fz67rFaiE+qNwymQo1YA0KQtD6RqmEh
 ERL2/Bwdwn4t3aSDcrJbYB90OwfcuJ2DfwA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 320ampthnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:48 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 23:45:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B34542EC3A2B; Tue, 30 Jun 2020 23:45:37 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] tools/bpftool: strip away modifiers from global variables
Date:   Tue, 30 Jun 2020 23:45:26 -0700
Message-ID: <20200701064527.3158178-5-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200701064527.3158178-1-andriin@fb.com>
References: <20200701064527.3158178-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_03:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=829 spamscore=0 malwarescore=0 suspectscore=8
 cotscore=-2147483648 impostorscore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reliably remove all the type modifiers from global variable definitions,
including cases of inner field const modifiers and arrays of const values=
.

Also modify one of selftests to ensure that const volatile struct doesn't
prevent user-space from modifying .rodata variable.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c                           | 13 ++++---------
 tools/testing/selftests/bpf/prog_tests/skeleton.c |  6 +++---
 tools/testing/selftests/bpf/progs/test_skeleton.c |  6 ++++--
 3 files changed, 11 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 10de76b296ba..2a13114896c2 100644
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
@@ -126,13 +126,6 @@ static int codegen_datasec_def(struct bpf_object *ob=
j,
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
@@ -176,12 +169,14 @@ static int codegen_datasec_def(struct bpf_object *o=
bj,
=20
 static int codegen_datasecs(struct bpf_object *obj, const char *obj_name=
)
 {
+	/* strip out const/volatile/restrict modifiers for datasecs */
+	DECLARE_LIBBPF_OPTS(btf_dump_opts, opts, .strip_mods =3D true);
 	struct btf *btf =3D bpf_object__btf(obj);
 	int n =3D btf__get_nr_types(btf);
 	struct btf_dump *d;
 	int i, err =3D 0;
=20
-	d =3D btf_dump__new(btf, NULL, NULL, codegen_btf_dump_printf);
+	d =3D btf_dump__new(btf, NULL, &opts, codegen_btf_dump_printf);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
=20
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

