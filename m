Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C120229F97
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 20:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732683AbgGVSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 14:50:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54904 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732614AbgGVSuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 14:50:05 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MIZLsP000877
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:50:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QY55+UbF/xtf+2MmgvqigbzrblDS0mIsEVAT15F/aio=;
 b=aDQppVVuTUsazjnKqJAauJyG6JxaUPuSaGoa/a0Z/WGhOkqQhv1pm/AfXmvOP5t3UpAA
 E5leOMlvLvaC7Ongk7Q5ooLsvOpSB9NtbRVBbnCBRsWiy5OZMfK3mOR9FZVin+3Dxzus
 bnZXKGOiXhLEgkRuPXfpajTkOli9llWohi0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32esyure26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 11:50:04 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 11:50:02 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E65993704B5A; Wed, 22 Jul 2020 11:50:00 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v2 13/13] selftests/bpf: add a test for out of bound rdonly buf access
Date:   Wed, 22 Jul 2020 11:50:00 -0700
Message-ID: <20200722185000.3778318-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200722184945.3777103-1-yhs@fb.com>
References: <20200722184945.3777103-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_10:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 suspectscore=8 impostorscore=0 mlxlogscore=928 phishscore=0 spamscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007220119
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the bpf program contains out of bound access w.r.t. a
particular map key/value size, the verification will be
still okay, e.g., it will be accepted by verifier. But
it will be rejected during link_create time. A test
is added here to ensure link_create failure did happen
if out of bound access happened.
  $ ./test_progs -n 4
  ...
  #4/23 rdonly-buf-out-of-bound:OK
  ...

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 22 ++++++++++++
 .../selftests/bpf/progs/bpf_iter_test_kern5.c | 35 +++++++++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern5=
.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index ffbbeb9fa268..d95de80b1851 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -20,6 +20,7 @@
 #include "bpf_iter_bpf_array_map.skel.h"
 #include "bpf_iter_bpf_percpu_array_map.skel.h"
 #include "bpf_iter_bpf_sk_storage_map.skel.h"
+#include "bpf_iter_test_kern5.skel.h"
=20
 static int duration;
=20
@@ -865,6 +866,25 @@ static void test_bpf_sk_storage_map(void)
 	bpf_iter_bpf_sk_storage_map__destroy(skel);
 }
=20
+static void test_rdonly_buf_out_of_bound(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_iter_test_kern5 *skel;
+	struct bpf_link *link;
+
+	skel =3D bpf_iter_test_kern5__open_and_load();
+	if (CHECK(!skel, "bpf_iter_test_kern5__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	opts.map_fd =3D bpf_map__fd(skel->maps.hashmap1);
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts)=
;
+	if (CHECK(!IS_ERR(link), "attach_iter", "unexpected success\n"))
+		bpf_link__destroy(link);
+
+	bpf_iter_test_kern5__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -911,4 +931,6 @@ void test_bpf_iter(void)
 		test_bpf_percpu_array_map();
 	if (test__start_subtest("bpf_sk_storage_map"))
 		test_bpf_sk_storage_map();
+	if (test__start_subtest("rdonly-buf-out-of-bound"))
+		test_rdonly_buf_out_of_bound();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern5.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern5.c
new file mode 100644
index 000000000000..e3a7575e81d2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern5.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct key_t {
+	int a;
+	int b;
+	int c;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 3);
+	__type(key, struct key_t);
+	__type(value, __u64);
+} hashmap1 SEC(".maps");
+
+__u32 key_sum =3D 0;
+
+SEC("iter/bpf_map_elem")
+int dump_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
+{
+	void *key =3D ctx->key;
+
+	if (key =3D=3D (void *)0)
+		return 0;
+
+	/* out of bound access w.r.t. hashmap1 */
+	key_sum +=3D *(__u32 *)(key + sizeof(struct key_t));
+	return 0;
+}
--=20
2.24.1

