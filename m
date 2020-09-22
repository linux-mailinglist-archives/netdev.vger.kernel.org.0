Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B9273BD4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbgIVH2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:28:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61662 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbgIVH2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:28:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M70nKC002950
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:05:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1/UsNBtx1RcAsqptnni5aWSLE3umq/qAT7vtLkr5yQU=;
 b=eos9/f92n1stUU+gwzLsHthkq6OJ/RcSWQMszG0VXVvJuRkrZ5vMDd2k/i+WCVSo6F3Q
 pwFkGDxV/SEG1qH1jx8Gx/o9ATav8rNIh3v8AOO/51/nJvTE59n2iwUDdgFhB/VYXcRf
 FsywapMz8T/1jljuJqj5VNaf2x2+RusXBK0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33nfgkv4sg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:05:29 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:05:26 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 5955B294641C; Tue, 22 Sep 2020 00:05:18 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 11/11] bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test
Date:   Tue, 22 Sep 2020 00:05:18 -0700
Message-ID: <20200922070518.1923618-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200922070409.1914988-1-kafai@fb.com>
References: <20200922070409.1914988-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 mlxlogscore=868 clxscore=1015 mlxscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 suspectscore=15 bulkscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test uses bpf_skc_to_tcp_sock() to get a kernel tcp_sock ptr "ktp".
Access the ktp->lsndtime and also pass it to bpf_sk_storage_get().

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/sock_fields.c |  2 ++
 tools/testing/selftests/bpf/progs/test_sock_fields.c | 11 +++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools=
/testing/selftests/bpf/prog_tests/sock_fields.c
index 23d14e2d0d28..9b81600a1ef4 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -144,6 +144,8 @@ static void check_result(void)
 	      "srv_sk", "Unexpected. Check srv_sk output. egress_linum:%u\n",
 	      egress_linum);
=20
+	CHECK(!skel->bss->lsndtime, "srv_tp", "Unexpected lsndtime:0\n");
+
 	CHECK(cli_sk.state =3D=3D 10 ||
 	      !cli_sk.state ||
 	      cli_sk.family !=3D AF_INET6 ||
diff --git a/tools/testing/selftests/bpf/progs/test_sock_fields.c b/tools=
/testing/selftests/bpf/progs/test_sock_fields.c
index 370e33a858db..24fdf2b2747e 100644
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
@@ -47,6 +48,7 @@ struct bpf_tcp_sock srv_tp =3D {};
 struct bpf_sock listen_sk =3D {};
 struct bpf_sock srv_sk =3D {};
 struct bpf_sock cli_sk =3D {};
+__u64 lsndtime =3D 0;
=20
 static bool is_loopback6(__u32 *a6)
 {
@@ -121,6 +123,7 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	struct bpf_tcp_sock *tp, *tp_ret;
 	struct bpf_sock *sk, *sk_ret;
 	__u32 linum, linum_idx;
+	struct tcp_sock *ktp;
=20
 	linum_idx =3D EGRESS_LINUM_IDX;
=20
@@ -165,9 +168,13 @@ int egress_read_sock_fields(struct __sk_buff *skb)
 	tpcpy(tp_ret, tp);
=20
 	if (sk_ret =3D=3D &srv_sk) {
+		ktp =3D bpf_skc_to_tcp_sock(sk);
+		if (!ktp)
+			RET_LOG();
+		lsndtime =3D ktp->lsndtime;
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

