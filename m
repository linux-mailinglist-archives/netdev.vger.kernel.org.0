Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62B3252412
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 01:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgHYXVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 19:21:05 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10556 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726804AbgHYXU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 19:20:58 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07PNHKuu028295
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=HgzqjB5ACMQJ2wKbBOxw1UrrEi03bKtksEwZ/GfWJPA=;
 b=SaVF08fiLwawS+4d8TAKY8afEW0pOD61fe4CmOC70DRkzrpgENMwSm29WyaoNBn/SagA
 60wlbcU0fRudFTf2YTLCXxta0BlEtecAszx6yayz+KQ3N0tmAkuse1x81aW8DWvPBKkk
 ZhmD/sfpEuE7ibrPZd0bY2FjMo66VZG6HsI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 332y1j98bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 16:20:56 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 16:20:56 -0700
Received: by devbig218.frc2.facebook.com (Postfix, from userid 116055)
        id C637E20785A; Tue, 25 Aug 2020 16:20:52 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 4/4] selftests/bpf: test for map update access from within EXT programs
Date:   Tue, 25 Aug 2020 16:20:03 -0700
Message-ID: <20200825232003.2877030-5-udippant@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200825232003.2877030-1-udippant@fb.com>
References: <20200825232003.2877030-1-udippant@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_10:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds further tests to ensure access permissions and restrictions
are applied properly for some map types such as sock-map.
It also adds another negative tests to assert static functions cannot be
replaced. In the 'unreliable' mode it still fails with error 'tracing pro=
gs
cannot use bpf_spin_lock yet' with the change in the verifier

Signed-off-by: Udip Pant <udippant@fb.com>
---
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 33 +++++++++++++--
 .../bpf/progs/freplace_attach_probe.c         | 40 +++++++++++++++++++
 .../bpf/progs/freplace_cls_redirect.c         | 34 ++++++++++++++++
 3 files changed, 104 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_attach_pro=
be.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_cls_redire=
ct.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/too=
ls/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
index d295ca9bbf96..a550dab9ba7a 100644
--- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
+++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
@@ -142,7 +142,20 @@ static void test_func_replace_verify(void)
 				  prog_name, false);
 }
=20
-static void test_func_replace_return_code(void)
+static void test_func_sockmap_update(void)
+{
+	const char *prog_name[] =3D {
+		"freplace/cls_redirect",
+	};
+	test_fexit_bpf2bpf_common("./freplace_cls_redirect.o",
+				  "./test_cls_redirect.o",
+				  ARRAY_SIZE(prog_name),
+				  prog_name, false);
+}
+
+static void test_obj_load_failure_common(const char *obj_file,
+					  const char *target_obj_file)
+
 {
 	/*
 	 * standalone test that asserts failure to load freplace prog
@@ -151,8 +164,6 @@ static void test_func_replace_return_code(void)
 	struct bpf_object *obj =3D NULL, *pkt_obj;
 	int err, pkt_fd;
 	__u32 duration =3D 0;
-	const char *target_obj_file =3D "./connect4_prog.o";
-	const char *obj_file =3D "./freplace_connect_v4_prog.o";
=20
 	err =3D bpf_prog_load(target_obj_file, BPF_PROG_TYPE_UNSPEC,
 			    &pkt_obj, &pkt_fd);
@@ -181,11 +192,27 @@ static void test_func_replace_return_code(void)
 	bpf_object__close(pkt_obj);
 }
=20
+static void test_func_replace_return_code(void)
+{
+	/* test invalid return code in the replaced program */
+	test_obj_load_failure_common("./freplace_connect_v4_prog.o",
+				     "./connect4_prog.o");
+}
+
+static void test_func_map_prog_compatibility(void)
+{
+	/* test with spin lock map value in the replaced program */
+	test_obj_load_failure_common("./freplace_attach_probe.o",
+				     "./test_attach_probe.o");
+}
+
 void test_fexit_bpf2bpf(void)
 {
 	test_target_no_callees();
 	test_target_yes_callees();
 	test_func_replace();
 	test_func_replace_verify();
+	test_func_sockmap_update();
 	test_func_replace_return_code();
+	test_func_map_prog_compatibility();
 }
diff --git a/tools/testing/selftests/bpf/progs/freplace_attach_probe.c b/=
tools/testing/selftests/bpf/progs/freplace_attach_probe.c
new file mode 100644
index 000000000000..bb2a77c5b62b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_attach_probe.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/ptrace.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define VAR_NUM 2
+
+struct hmap_elem {
+	struct bpf_spin_lock lock;
+	int var[VAR_NUM];
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct hmap_elem);
+} hash_map SEC(".maps");
+
+SEC("freplace/handle_kprobe")
+int new_handle_kprobe(struct pt_regs *ctx)
+{
+	struct hmap_elem zero =3D {}, *val;
+	int key =3D 0;
+
+	val =3D bpf_map_lookup_elem(&hash_map, &key);
+	if (!val)
+		return 1;
+	/* spin_lock in hash map */
+	bpf_spin_lock(&val->lock);
+	val->var[0] =3D 99;
+	bpf_spin_unlock(&val->lock);
+
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/freplace_cls_redirect.c b/=
tools/testing/selftests/bpf/progs/freplace_cls_redirect.c
new file mode 100644
index 000000000000..68a5a9db928a
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/freplace_cls_redirect.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Facebook
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <linux/pkt_cls.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_helpers.h>
+
+struct bpf_map_def SEC("maps") sock_map =3D {
+	.type =3D BPF_MAP_TYPE_SOCKMAP,
+	.key_size =3D sizeof(int),
+	.value_size =3D sizeof(int),
+	.max_entries =3D 2,
+};
+
+SEC("freplace/cls_redirect")
+int freplace_cls_redirect_test(struct __sk_buff *skb)
+{
+	int ret =3D 0;
+	const int zero =3D 0;
+	struct bpf_sock *sk;
+
+	sk =3D bpf_map_lookup_elem(&sock_map, &zero);
+	if (!sk)
+		return TC_ACT_SHOT;
+
+	ret =3D bpf_map_update_elem(&sock_map, &zero, sk, 0);
+	bpf_sk_release(sk);
+
+	return ret =3D=3D 0 ? TC_ACT_OK : TC_ACT_SHOT;
+}
+
+char _license[] SEC("license") =3D "GPL";
--=20
2.24.1

