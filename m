Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965BE277CAA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgIYAE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8132 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbgIYAE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:57 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08ONxCeC003947
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jlRJDZPCDhd7iJE/yUs6wpqsQn5szgCtC6/P60RE2VE=;
 b=FyqHfASDRssHHsaHpEH0iG3kIiCaRV16D3u7rvozld0fXbANzv/YySZFOsBc374XPQoX
 nFbvqMTESvcyxc55VOqnmnQtKH3dkzbwNyGOS9p6Es6vOQyD0sg5UOOGnECOay5W9h5S
 VYTKcg9sk/BWFl5oOYlKzth3QwLlN7HcNVk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4msxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:55 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:55 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 815CA2946606; Thu, 24 Sep 2020 17:04:46 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 11/13] bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test
Date:   Thu, 24 Sep 2020 17:04:46 -0700
Message-ID: <20200925000446.3858975-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=675
 priorityscore=1501 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=15 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test uses bpf_skc_to_tcp_sock() to get a kernel tcp_sock ptr "ktp".
Access the ktp->lsndtime and also pass ktp to bpf_sk_storage_get().

It also exercises the bpf_sk_cgroup_id() and bpf_sk_ancestor_cgroup_id()
with the "ktp".  To do that, a parent cgroup and a child cgroup are
created.  The bpf prog is attached to the child cgroup.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/sock_fields.c    | 40 +++++++++++++++----
 .../selftests/bpf/progs/test_sock_fields.c    | 24 ++++++++++-
 2 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools=
/testing/selftests/bpf/prog_tests/sock_fields.c
index eea8b96bb1be..66e83b8fc69d 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -29,7 +29,8 @@ struct bpf_spinlock_cnt {
 	__u32 cnt;
 };
=20
-#define TEST_CGROUP "/test-bpf-sock-fields"
+#define PARENT_CGROUP	"/test-bpf-sock-fields"
+#define CHILD_CGROUP	"/test-bpf-sock-fields/child"
 #define DATA "Hello BPF!"
 #define DATA_LEN sizeof(DATA)
=20
@@ -37,6 +38,8 @@ static struct sockaddr_in6 srv_sa6, cli_sa6;
 static int sk_pkt_out_cnt10_fd;
 struct test_sock_fields *skel;
 static int sk_pkt_out_cnt_fd;
+static __u64 parent_cg_id;
+static __u64 child_cg_id;
 static int linum_map_fd;
 static __u32 duration;
=20
@@ -142,6 +145,8 @@ static void check_result(void)
 	      "srv_sk", "Unexpected. Check srv_sk output. egress_linum:%u\n",
 	      egress_linum);
=20
+	CHECK(!skel->bss->lsndtime, "srv_tp", "Unexpected lsndtime:0\n");
+
 	CHECK(cli_sk.state =3D=3D 10 ||
 	      !cli_sk.state ||
 	      cli_sk.family !=3D AF_INET6 ||
@@ -178,6 +183,14 @@ static void check_result(void)
 	      cli_tp.bytes_received < 2 * DATA_LEN,
 	      "cli_tp", "Unexpected. Check cli_tp output. egress_linum:%u\n",
 	      egress_linum);
+
+	CHECK(skel->bss->parent_cg_id !=3D parent_cg_id,
+	      "parent_cg_id", "%zu !=3D %zu\n",
+	      (size_t)skel->bss->parent_cg_id, (size_t)parent_cg_id);
+
+	CHECK(skel->bss->child_cg_id !=3D child_cg_id,
+	      "child_cg_id", "%zu !=3D %zu\n",
+	       (size_t)skel->bss->child_cg_id, (size_t)child_cg_id);
 }
=20
 static void check_sk_pkt_out_cnt(int accept_fd, int cli_fd)
@@ -319,25 +332,35 @@ static void test(void)
 void test_sock_fields(void)
 {
 	struct bpf_link *egress_link =3D NULL, *ingress_link =3D NULL;
-	int cgroup_fd;
+	int parent_cg_fd =3D -1, child_cg_fd =3D -1;
=20
 	/* Create a cgroup, get fd, and join it */
-	cgroup_fd =3D test__join_cgroup(TEST_CGROUP);
-	if (CHECK_FAIL(cgroup_fd < 0))
+	parent_cg_fd =3D test__join_cgroup(PARENT_CGROUP);
+	if (CHECK_FAIL(parent_cg_fd < 0))
 		return;
+	parent_cg_id =3D get_cgroup_id(PARENT_CGROUP);
+	if (CHECK_FAIL(!parent_cg_id))
+		goto done;
+
+	child_cg_fd =3D test__join_cgroup(CHILD_CGROUP);
+	if (CHECK_FAIL(child_cg_fd < 0))
+		goto done;
+	child_cg_id =3D get_cgroup_id(CHILD_CGROUP);
+	if (CHECK_FAIL(!child_cg_id))
+		goto done;
=20
 	skel =3D test_sock_fields__open_and_load();
 	if (CHECK(!skel, "test_sock_fields__open_and_load", "failed\n"))
 		goto done;
=20
 	egress_link =3D bpf_program__attach_cgroup(skel->progs.egress_read_sock=
_fields,
-						 cgroup_fd);
+						 child_cg_fd);
 	if (CHECK(IS_ERR(egress_link), "attach_cgroup(egress)", "err:%ld\n",
 		  PTR_ERR(egress_link)))
 		goto done;
=20
 	ingress_link =3D bpf_program__attach_cgroup(skel->progs.ingress_read_so=
ck_fields,
-						  cgroup_fd);
+						  child_cg_fd);
 	if (CHECK(IS_ERR(ingress_link), "attach_cgroup(ingress)", "err:%ld\n",
 		  PTR_ERR(ingress_link)))
 		goto done;
@@ -352,5 +375,8 @@ void test_sock_fields(void)
 	bpf_link__destroy(egress_link);
 	bpf_link__destroy(ingress_link);
 	test_sock_fields__destroy(skel);
-	close(cgroup_fd);
+	if (child_cg_fd !=3D -1)
+		close(child_cg_fd);
+	if (parent_cg_fd !=3D -1)
+		close(parent_cg_fd);
 }
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools=
/testing/selftests/bpf/progs/test_sock_fields.c
index 370e33a858db..81b57b9aaaea 100644
--- a/tools/testing/selftests/bpf/progs/test_sock_fields.c
+++ b/tools/testing/selftests/bpf/progs/test_sock_fields.c
@@ -7,6 +7,7 @@
=20
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
+#include "bpf_tcp_helpers.h"
=20
 enum bpf_linum_array_idx {
 	EGRESS_LINUM_IDX,
@@ -47,6 +48,9 @@ struct bpf_tcp_sock srv_tp =3D {};
 struct bpf_sock listen_sk =3D {};
 struct bpf_sock srv_sk =3D {};
 struct bpf_sock cli_sk =3D {};
+__u64 parent_cg_id =3D 0;
+__u64 child_cg_id =3D 0;
+__u64 lsndtime =3D 0;
=20
 static bool is_loopback6(__u32 *a6)
 {
@@ -121,6 +125,7 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	struct bpf_tcp_sock *tp, *tp_ret;
 	struct bpf_sock *sk, *sk_ret;
 	__u32 linum, linum_idx;
+	struct tcp_sock *ktp;
=20
 	linum_idx =3D EGRESS_LINUM_IDX;
=20
@@ -165,9 +170,24 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	tpcpy(tp_ret, tp);
=20
 	if (sk_ret =3D=3D &srv_sk) {
+		ktp =3D bpf_skc_to_tcp_sock(sk);
+
+		if (!ktp)
+			RET_LOG();
+
+		lsndtime =3D ktp->lsndtime;
+
+		child_cg_id =3D bpf_sk_cgroup_id(ktp);
+		if (!child_cg_id)
+			RET_LOG();
+
+		parent_cg_id =3D bpf_sk_ancestor_cgroup_id(ktp, 2);
+		if (!parent_cg_id)
+			RET_LOG();
+
 		/* The userspace has created it for srv sk */
-		pkt_out_cnt =3D bpf_sk_storage_get(&sk_pkt_out_cnt, sk, 0, 0);
-		pkt_out_cnt10 =3D bpf_sk_storage_get(&sk_pkt_out_cnt10, sk,
+		pkt_out_cnt =3D bpf_sk_storage_get(&sk_pkt_out_cnt, ktp, 0, 0);
+		pkt_out_cnt10 =3D bpf_sk_storage_get(&sk_pkt_out_cnt10, ktp,
 						   0, 0);
 	} else {
 		pkt_out_cnt =3D bpf_sk_storage_get(&sk_pkt_out_cnt, sk,
--=20
2.24.1

