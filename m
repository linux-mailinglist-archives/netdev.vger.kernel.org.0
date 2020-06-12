Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EE91F7DBD
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 21:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgFLTpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 15:45:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:37902 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbgFLTpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 15:45:21 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05CJimXR007121
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 12:45:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=Qp/DEnKtEcycXYg1548mpTkaEBJQRsSgCs89Jo2VQD8=;
 b=AqVwM/JpVJGga8K8majH0MsZWC+QAPF2T1f4bw08YH7DCIBDqf/f70FIdNY0gZFJ7wbG
 obgKTPfOZZszL6LBIS6P2BCsAY7wIPdD5i5G5jWDSeU41v+aArnSzG7o7DcK1lE7W4Zn
 xH771qgRoKw7gjvMPpB1P08t6ZnsPzumZlY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31mbasshn7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 12:45:20 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 12 Jun 2020 12:45:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1B2FF2EC1E9F; Fri, 12 Jun 2020 12:45:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] libbpf: support pre-initializing .bss global variables
Date:   Fri, 12 Jun 2020 12:45:04 -0700
Message-ID: <20200612194504.557844-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-12_16:2020-06-12,2020-06-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 cotscore=-2147483648 suspectscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006120143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove invalid assumption in libbpf that .bss map doesn't have to be upda=
ted
in kernel. With addition of skeleton and memory-mapped initialization ima=
ge,
.bss doesn't have to be all zeroes when BPF map is created, because user-=
code
might have initialized those variables from user-space.

Fixes: eba9c5f498a1 ("libbpf: Refactor global data map initialization")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        |  4 --
 .../selftests/bpf/prog_tests/skeleton.c       | 45 ++++++++++++++++---
 .../selftests/bpf/progs/test_skeleton.c       | 19 ++++++--
 3 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 7f01be2b88b8..477c679ed945 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3564,10 +3564,6 @@ bpf_object__populate_internal_map(struct bpf_objec=
t *obj, struct bpf_map *map)
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, zero =3D 0;
=20
-	/* kernel already zero-initializes .bss map. */
-	if (map_type =3D=3D LIBBPF_MAP_BSS)
-		return 0;
-
 	err =3D bpf_map_update_elem(map->fd, &zero, map->mmaped, 0);
 	if (err) {
 		err =3D -errno;
diff --git a/tools/testing/selftests/bpf/prog_tests/skeleton.c b/tools/te=
sting/selftests/bpf/prog_tests/skeleton.c
index 9264a2736018..fa153cf67b1b 100644
--- a/tools/testing/selftests/bpf/prog_tests/skeleton.c
+++ b/tools/testing/selftests/bpf/prog_tests/skeleton.c
@@ -15,6 +15,8 @@ void test_skeleton(void)
 	int duration =3D 0, err;
 	struct test_skeleton* skel;
 	struct test_skeleton__bss *bss;
+	struct test_skeleton__data *data;
+	struct test_skeleton__rodata *rodata;
 	struct test_skeleton__kconfig *kcfg;
=20
 	skel =3D test_skeleton__open();
@@ -24,13 +26,45 @@ void test_skeleton(void)
 	if (CHECK(skel->kconfig, "skel_kconfig", "kconfig is mmaped()!\n"))
 		goto cleanup;
=20
+	bss =3D skel->bss;
+	data =3D skel->data;
+	rodata =3D skel->rodata;
+
+	/* validate values are pre-initialized correctly */
+	CHECK(data->in1 !=3D -1, "in1", "got %d !=3D exp %d\n", data->in1, -1);
+	CHECK(data->out1 !=3D -1, "out1", "got %d !=3D exp %d\n", data->out1, -=
1);
+	CHECK(data->in2 !=3D -1, "in2", "got %lld !=3D exp %lld\n", data->in2, =
-1LL);
+	CHECK(data->out2 !=3D -1, "out2", "got %lld !=3D exp %lld\n", data->out=
2, -1LL);
+
+	CHECK(bss->in3 !=3D 0, "in3", "got %d !=3D exp %d\n", bss->in3, 0);
+	CHECK(bss->out3 !=3D 0, "out3", "got %d !=3D exp %d\n", bss->out3, 0);
+	CHECK(bss->in4 !=3D 0, "in4", "got %lld !=3D exp %lld\n", bss->in4, 0LL=
);
+	CHECK(bss->out4 !=3D 0, "out4", "got %lld !=3D exp %lld\n", bss->out4, =
0LL);
+
+	CHECK(rodata->in6 !=3D 0, "in6", "got %d !=3D exp %d\n", rodata->in6, 0=
);
+	CHECK(bss->out6 !=3D 0, "out6", "got %d !=3D exp %d\n", bss->out6, 0);
+
+	/* validate we can pre-setup global variables, even in .bss */
+	data->in1 =3D 10;
+	data->in2 =3D 11;
+	bss->in3 =3D 12;
+	bss->in4 =3D 13;
+	rodata->in6 =3D 14;
+
 	err =3D test_skeleton__load(skel);
 	if (CHECK(err, "skel_load", "failed to load skeleton: %d\n", err))
 		goto cleanup;
=20
-	bss =3D skel->bss;
-	bss->in1 =3D 1;
-	bss->in2 =3D 2;
+	/* validate pre-setup values are still there */
+	CHECK(data->in1 !=3D 10, "in1", "got %d !=3D exp %d\n", data->in1, 10);
+	CHECK(data->in2 !=3D 11, "in2", "got %lld !=3D exp %lld\n", data->in2, =
11LL);
+	CHECK(bss->in3 !=3D 12, "in3", "got %d !=3D exp %d\n", bss->in3, 12);
+	CHECK(bss->in4 !=3D 13, "in4", "got %lld !=3D exp %lld\n", bss->in4, 13=
LL);
+	CHECK(rodata->in6 !=3D 14, "in6", "got %d !=3D exp %d\n", rodata->in6, =
14);
+
+	/* now set new values and attach to get them into outX variables */
+	data->in1 =3D 1;
+	data->in2 =3D 2;
 	bss->in3 =3D 3;
 	bss->in4 =3D 4;
 	bss->in5.a =3D 5;
@@ -44,14 +78,15 @@ void test_skeleton(void)
 	/* trigger tracepoint */
 	usleep(1);
=20
-	CHECK(bss->out1 !=3D 1, "res1", "got %d !=3D exp %d\n", bss->out1, 1);
-	CHECK(bss->out2 !=3D 2, "res2", "got %lld !=3D exp %d\n", bss->out2, 2)=
;
+	CHECK(data->out1 !=3D 1, "res1", "got %d !=3D exp %d\n", data->out1, 1)=
;
+	CHECK(data->out2 !=3D 2, "res2", "got %lld !=3D exp %d\n", data->out2, =
2);
 	CHECK(bss->out3 !=3D 3, "res3", "got %d !=3D exp %d\n", (int)bss->out3,=
 3);
 	CHECK(bss->out4 !=3D 4, "res4", "got %lld !=3D exp %d\n", bss->out4, 4)=
;
 	CHECK(bss->handler_out5.a !=3D 5, "res5", "got %d !=3D exp %d\n",
 	      bss->handler_out5.a, 5);
 	CHECK(bss->handler_out5.b !=3D 6, "res6", "got %lld !=3D exp %d\n",
 	      bss->handler_out5.b, 6);
+	CHECK(bss->out6 !=3D 14, "res7", "got %d !=3D exp %d\n", bss->out6, 14)=
;
=20
 	CHECK(bss->bpf_syscall !=3D kcfg->CONFIG_BPF_SYSCALL, "ext1",
 	      "got %d !=3D exp %d\n", bss->bpf_syscall, kcfg->CONFIG_BPF_SYSCAL=
L);
diff --git a/tools/testing/selftests/bpf/progs/test_skeleton.c b/tools/te=
sting/selftests/bpf/progs/test_skeleton.c
index de03a90f78ca..77ae86f44db5 100644
--- a/tools/testing/selftests/bpf/progs/test_skeleton.c
+++ b/tools/testing/selftests/bpf/progs/test_skeleton.c
@@ -10,16 +10,26 @@ struct s {
 	long long b;
 } __attribute__((packed));
=20
-int in1 =3D 0;
-long long in2 =3D 0;
+/* .data section */
+int in1 =3D -1;
+long long in2 =3D -1;
+
+/* .bss section */
 char in3 =3D '\0';
 long long in4 __attribute__((aligned(64))) =3D 0;
 struct s in5 =3D {};
=20
-long long out2 =3D 0;
+/* .rodata section */
+const volatile int in6 =3D 0;
+
+/* .data section */
+int out1 =3D -1;
+long long out2 =3D -1;
+
+/* .bss section */
 char out3 =3D 0;
 long long out4 =3D 0;
-int out1 =3D 0;
+int out6 =3D 0;
=20
 extern bool CONFIG_BPF_SYSCALL __kconfig;
 extern int LINUX_KERNEL_VERSION __kconfig;
@@ -36,6 +46,7 @@ int handler(const void *ctx)
 	out3 =3D in3;
 	out4 =3D in4;
 	out5 =3D in5;
+	out6 =3D in6;
=20
 	bpf_syscall =3D CONFIG_BPF_SYSCALL;
 	kern_ver =3D LINUX_KERNEL_VERSION;
--=20
2.24.1

