Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB002045BA
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 02:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732099AbgFWAgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 20:36:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40438 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732085AbgFWAgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 20:36:47 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N0YCZt026930
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=v+dz7xhSejOqZYYwUNCwwDJeqy0RdXIDw+UhnWkRI2I=;
 b=MgYXZBTaWtkav7NmMf7H8t3bWVrkIMRH73yUGWRonTE/fiBBCa9QY46MyOAkeNdhuZRq
 O1EkvfOgx+/zj0536WywfFe/R3bJ5KWY1YA+bRuABclyI0YmfuuUQXei2AkWzD5zEzkb
 HtCqeFk5f44Q/ziGSKm+PnDMvSqyngiEGgs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31t2e8rdu6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 17:36:47 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Jun 2020 17:36:45 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CFE573705002; Mon, 22 Jun 2020 17:36:43 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 15/15] bpf/selftests: add tcp/udp iterator programs to selftests
Date:   Mon, 22 Jun 2020 17:36:43 -0700
Message-ID: <20200623003643.3075182-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200623003626.3072825-1-yhs@fb.com>
References: <20200623003626.3072825-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_16:2020-06-22,2020-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 suspectscore=8 bulkscore=0 cotscore=-2147483648 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006230000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added tcp{4,6} and udp{4,6} bpf programs into test_progs
selftest so that they at least can load successfully.
  $ ./test_progs -n 3
  ...
  #3/7 tcp4:OK
  #3/8 tcp6:OK
  #3/9 udp4:OK
  #3/10 udp6:OK
  ...
  #3 bpf_iter:OK
  Summary: 1/16 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 68 +++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 87c29dde1cf9..1e2e0fced6e8 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -6,6 +6,10 @@
 #include "bpf_iter_bpf_map.skel.h"
 #include "bpf_iter_task.skel.h"
 #include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_tcp4.skel.h"
+#include "bpf_iter_tcp6.skel.h"
+#include "bpf_iter_udp4.skel.h"
+#include "bpf_iter_udp6.skel.h"
 #include "bpf_iter_test_kern1.skel.h"
 #include "bpf_iter_test_kern2.skel.h"
 #include "bpf_iter_test_kern3.skel.h"
@@ -120,6 +124,62 @@ static void test_task_file(void)
 	bpf_iter_task_file__destroy(skel);
 }
=20
+static void test_tcp4(void)
+{
+	struct bpf_iter_tcp4 *skel;
+
+	skel =3D bpf_iter_tcp4__open_and_load();
+	if (CHECK(!skel, "bpf_iter_tcp4__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_tcp4);
+
+	bpf_iter_tcp4__destroy(skel);
+}
+
+static void test_tcp6(void)
+{
+	struct bpf_iter_tcp6 *skel;
+
+	skel =3D bpf_iter_tcp6__open_and_load();
+	if (CHECK(!skel, "bpf_iter_tcp6__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_tcp6);
+
+	bpf_iter_tcp6__destroy(skel);
+}
+
+static void test_udp4(void)
+{
+	struct bpf_iter_udp4 *skel;
+
+	skel =3D bpf_iter_udp4__open_and_load();
+	if (CHECK(!skel, "bpf_iter_udp4__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_udp4);
+
+	bpf_iter_udp4__destroy(skel);
+}
+
+static void test_udp6(void)
+{
+	struct bpf_iter_udp6 *skel;
+
+	skel =3D bpf_iter_udp6__open_and_load();
+	if (CHECK(!skel, "bpf_iter_udp6__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_udp6);
+
+	bpf_iter_udp6__destroy(skel);
+}
+
 /* The expected string is less than 16 bytes */
 static int do_read_with_fd(int iter_fd, const char *expected,
 			   bool read_one_char)
@@ -394,6 +454,14 @@ void test_bpf_iter(void)
 		test_task();
 	if (test__start_subtest("task_file"))
 		test_task_file();
+	if (test__start_subtest("tcp4"))
+		test_tcp4();
+	if (test__start_subtest("tcp6"))
+		test_tcp6();
+	if (test__start_subtest("udp4"))
+		test_udp4();
+	if (test__start_subtest("udp6"))
+		test_udp6();
 	if (test__start_subtest("anon"))
 		test_anon_iter(false);
 	if (test__start_subtest("anon-read-one-char"))
--=20
2.24.1

