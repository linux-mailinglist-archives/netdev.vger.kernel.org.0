Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B64F25241B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHYXV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:21:29 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16044 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726645AbgHYXUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:20:52 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PNHJco016374
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=gHRsN4yg6VWCazPfiN3ZDsGxHrKWI0qlbo1YebDXZV0=;
 b=ZZUjbEkAvsanzKD+Z4ButmM3NXVKUGuo01SKsEvW39nds+3gCw1lmiVK6Zic4ERN2+xm
 CbmZlYNXOw9ft75XuA8/e1eRQ2Fxa+nUzbFFWf9VP4jjb08MkpHiRjU0NN44s0gghLfG
 aLkdSVa4HLUiCwvgRUZ76Us/h8BVZvSIguM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 333jv9x0tv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:52 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 16:20:50 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id A2B9620785A; Tue, 25 Aug 2020 16:20:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Udip Pant <udippant@fb.com>
Smtp-Origin-Hostname: devbig218.frc2.facebook.com
To:     Udip Pant <udippant@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Smtp-Origin-Cluster: frc2c02
Subject: [PATCH bpf-next v3 3/4] selftests/bpf: test for checking return code for the extended prog
Date:   Tue, 25 Aug 2020 16:20:02 -0700
Message-ID: <20200825232003.2877030-4-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
References: <20200825232003.2877030-1-udippant@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0
 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds test to enforce same check for the return code for the extended=
 prog
as it is enforced for the target program. It asserts failure for a
return code, which is permitted without the patch in this series, while
it is restricted after the application of this patch.

Signed-off-by: Udip Pant <udippant@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 40 +++++++++++++++++++
 .../bpf/progs/freplace_connect_v4_prog.c      | 19 +++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect_v4=
_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index 7c7168963d52..d295ca9bbf96 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -142,10 +142,50 @@ static void test_func_replace_verify(void)
 				  prog_name, false);
 }
=20
+static void test_func_replace_return_code(void)
+{
+	/*
+	 * standalone test that asserts failure to load freplace prog
+	 * because of invalid return code.
+	 */
+	struct bpf_object *obj =3D NULL, *pkt_obj;
+	int err, pkt_fd;
+	__u32 duration =3D 0;
+	const char *target_obj_file =3D "./connect4_prog.o";
+	const char *obj_file =3D "./freplace_connect_v4_prog.o";
+
+	err =3D bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
+			    &pkt_obj, &pkt_fd);
+	/* the target prog should load fine */
+	if (CHECK(err, "tgt_prog_load", "file %s err %d errno %d\n",
+		  target_obj_file, err, errno))
+		return;
+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd =3D pkt_fd,
+			   );
+
+	obj =3D bpf_object__open_file(obj_file, &opts);
+	if (CHECK(IS_ERR_OR_NULL(obj), "obj_open",
+		  "failed to open %s: %ld\n", obj_file,
+		  PTR_ERR(obj)))
+		goto close_prog;
+
+	/* It should fail to load the program */
+	err =3D bpf_object__load(obj);
+	if (CHECK(!err, "bpf_obj_load should fail", "err %d\n", err))
+		goto close_prog;
+
+close_prog:
+	if (!IS_ERR_OR_NULL(obj))
+		bpf_object__close(obj);
+	bpf_object__close(pkt_obj);
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	test_target_no_callees();
 	test_target_yes_callees();
 	test_func_replace();
 	test_func_replace_verify();
+	test_func_replace_return_code();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_connect_v4_prog.c=
 b/tools/testing/selftests/bpf/progs/freplace_connect_v4_prog.c
new file mode 100644
index 000000000000..544e5ac90461
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_connect_v4_prog.c
@@ -0,0 +1,19 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/stddef.h>
+#include <linux/ipv6.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+SEC("freplace/connect_v4_prog")
+int new_connect_v4_prog(struct bpf_sock_addr *ctx)
+{
+	// return value thats in invalid range
+	return 255;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

