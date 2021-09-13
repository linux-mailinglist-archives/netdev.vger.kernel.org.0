Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D748408339
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 05:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhIMD5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 23:57:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238543AbhIMD5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 23:57:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.0.43) with SMTP id 18CNiE0n022329
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=zUIh0pgQr6d8sYL83QthyDO3tfaUDgBqcBsB2wYBLfs=;
 b=AnoI73lbLDHJrohLxqPG/fN+Q5juwfYba3gbKWxB8cTwM3yCFQjVwwZawBuCCuM96AeW
 vEUJCIHtHUq6l7PFXc0a2J1Ug1Gz13BPRr/Glwbs4ZFviBXV2Oz8X9zEi7erPKjhb0TO
 7WZgh5UUh0nZ1yoKFj/nZVzcjfC3hbvo+pU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3b1sqrs1nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 20:56:25 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Sun, 12 Sep 2021 20:56:24 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 7394968234AE; Sun, 12 Sep 2021 20:56:19 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v5 bpf-next 2/9] selftests/bpf: stop using bpf_program__load
Date:   Sun, 12 Sep 2021 20:56:02 -0700
Message-ID: <20210913035609.160722-3-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913035609.160722-1-davemarchevsky@fb.com>
References: <20210913035609.160722-1-davemarchevsky@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: YIOD4N74eVCHOxB4wehal-EmJG2PGbQk
X-Proofpoint-GUID: YIOD4N74eVCHOxB4wehal-EmJG2PGbQk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_02,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 suspectscore=0 clxscore=1015 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130025
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_program__load is not supposed to be used directly. Replace it with
bpf_object__ APIs for the reference_tracking prog_test, which is the
last offender in bpf selftests.

Some additional complexity is added for this test, namely the use of one
bpf_object to iterate through progs, while a second bpf_object is
created and opened/closed to test actual loading of progs. This is
because the test was doing bpf_program__load then __unload to test
loading of individual progs and same semantics with
bpf_object__load/__unload result in failure to load an __unload-ed obj.

Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../bpf/prog_tests/reference_tracking.c       | 39 +++++++++++++++----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c =
b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
index 4e91f4d6466c..ded2dc8ddd79 100644
--- a/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
+++ b/tools/testing/selftests/bpf/prog_tests/reference_tracking.c
@@ -1,6 +1,21 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
=20
+static void toggle_object_autoload_progs(const struct bpf_object *obj,
+					 const char *title_load)
+{
+	struct bpf_program *prog;
+
+	bpf_object__for_each_program(prog, obj) {
+		const char *title =3D bpf_program__section_name(prog);
+
+		if (!strcmp(title_load, title))
+			bpf_program__set_autoload(prog, true);
+		else
+			bpf_program__set_autoload(prog, false);
+	}
+}
+
 void test_reference_tracking(void)
 {
 	const char *file =3D "test_sk_lookup_kern.o";
@@ -9,21 +24,21 @@ void test_reference_tracking(void)
 		.object_name =3D obj_name,
 		.relaxed_maps =3D true,
 	);
-	struct bpf_object *obj;
+	struct bpf_object *obj_iter, *obj =3D NULL;
 	struct bpf_program *prog;
 	__u32 duration =3D 0;
 	int err =3D 0;
=20
-	obj =3D bpf_object__open_file(file, &open_opts);
-	if (!ASSERT_OK_PTR(obj, "obj_open_file"))
+	obj_iter =3D bpf_object__open_file(file, &open_opts);
+	if (!ASSERT_OK_PTR(obj_iter, "obj_iter_open_file"))
 		return;
=20
-	if (CHECK(strcmp(bpf_object__name(obj), obj_name), "obj_name",
+	if (CHECK(strcmp(bpf_object__name(obj_iter), obj_name), "obj_name",
 		  "wrong obj name '%s', expected '%s'\n",
-		  bpf_object__name(obj), obj_name))
+		  bpf_object__name(obj_iter), obj_name))
 		goto cleanup;
=20
-	bpf_object__for_each_program(prog, obj) {
+	bpf_object__for_each_program(prog, obj_iter) {
 		const char *title;
=20
 		/* Ignore .text sections */
@@ -34,19 +49,27 @@ void test_reference_tracking(void)
 		if (!test__start_subtest(title))
 			continue;
=20
+		obj =3D bpf_object__open_file(file, &open_opts);
+		if (!ASSERT_OK_PTR(obj, "obj_open_file"))
+			goto cleanup;
+
+		toggle_object_autoload_progs(obj, title);
 		/* Expect verifier failure if test name has 'err' */
 		if (strstr(title, "err_") !=3D NULL) {
 			libbpf_print_fn_t old_print_fn;
=20
 			old_print_fn =3D libbpf_set_print(NULL);
-			err =3D !bpf_program__load(prog, "GPL", 0);
+			err =3D !bpf_object__load(obj);
 			libbpf_set_print(old_print_fn);
 		} else {
-			err =3D bpf_program__load(prog, "GPL", 0);
+			err =3D bpf_object__load(obj);
 		}
 		CHECK(err, title, "\n");
+		bpf_object__close(obj);
+		obj =3D NULL;
 	}
=20
 cleanup:
 	bpf_object__close(obj);
+	bpf_object__close(obj_iter);
 }
--=20
2.30.2

