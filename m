Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC265280BFE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbgJBBe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:34:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387496AbgJBBe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:34:59 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0921XmOM021667
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:34:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=kIhPsKrnD3I9p4BU9zl7IiH3mpRakd6i+R4asnxg5Rg=;
 b=VLebKJQflpLjQaKvLpiXKY7rrIQnw0jq5dlJbzyHBYmm1V7RgZeU+Kkk+0PPwzg54/Qg
 cNg85d6+pN4aqzehDSjlya4VaffgzTYPy8Iu/BstIpbaa5YMKOd6o9BWQ5il3VL1cAIL
 noOCRKIsNnaaE3FlGQEmKTmeRXKiVlQjve4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 33w05n7tk8-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:34:58 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:34:56 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id F1F682945DB0; Thu,  1 Oct 2020 18:34:54 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next 2/2] bpf: selftest: Ensure the child sk inherited all bpf_sock_ops_cb_flags
Date:   Thu, 1 Oct 2020 18:34:54 -0700
Message-ID: <20201002013454.2542367-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201002013442.2541568-1-kafai@fb.com>
References: <20201002013442.2541568-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 priorityscore=1501 mlxlogscore=337 impostorscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020006
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test to ensure the child sk inherited everything
from the bpf_sock_ops_cb_flags of the listen sk:
1. Sets one more cb_flags (BPF_SOCK_OPS_STATE_CB_FLAG) to the listen sk
   in test_tcp_hdr_options.c
2. Saves the skops->bpf_sock_ops_cb_flags when handling the newly
   established passive connection
3. CHECK() it is the same as the listen sk

This also covers the fastopen case as the existing test_tcp_hdr_options.c
does.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/tcp_hdr_options.c       | 12 ++++++++++++
 .../selftests/bpf/progs/test_misc_tcp_hdr_options.c  |  4 ++--
 .../selftests/bpf/progs/test_tcp_hdr_options.c       |  7 +++++--
 tools/testing/selftests/bpf/test_tcp_hdr_options.h   |  5 +++--
 4 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index 24ba0d21b641..c86e67214a9e 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -264,9 +264,19 @@ static int check_error_linum(const struct sk_fds *sk=
_fds)
=20
 static void check_hdr_and_close_fds(struct sk_fds *sk_fds)
 {
+	const __u32 expected_inherit_cb_flags =3D
+		BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
+		BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG |
+		BPF_SOCK_OPS_STATE_CB_FLAG;
+
 	if (sk_fds_shutdown(sk_fds))
 		goto check_linum;
=20
+	if (CHECK(expected_inherit_cb_flags !=3D skel->bss->inherit_cb_flags,
+		  "Unexpected inherit_cb_flags", "0x%x !=3D 0x%x\n",
+		  skel->bss->inherit_cb_flags, expected_inherit_cb_flags))
+		goto check_linum;
+
 	if (check_hdr_stg(&exp_passive_hdr_stg, sk_fds->passive_fd,
 			  "passive_hdr_stg"))
 		goto check_linum;
@@ -321,6 +331,8 @@ static void reset_test(void)
 	memset(&skel->bss->active_estab_in, 0, optsize);
 	memset(&skel->bss->active_fin_in, 0, optsize);
=20
+	skel->bss->inherit_cb_flags =3D 0;
+
 	skel->data->test_kind =3D TCPOPT_EXP;
 	skel->data->test_magic =3D 0xeB9F;
=20
diff --git a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.=
c b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
index 3a216d1d0226..72ec0178f653 100644
--- a/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_options.c
@@ -304,10 +304,10 @@ int misc_estab(struct bpf_sock_ops *skops)
 		passive_lport_n =3D __bpf_htons(passive_lport_h);
 		bpf_setsockopt(skops, SOL_TCP, TCP_SAVE_SYN,
 			       &true_val, sizeof(true_val));
-		set_hdr_cb_flags(skops);
+		set_hdr_cb_flags(skops, 0);
 		break;
 	case BPF_SOCK_OPS_TCP_CONNECT_CB:
-		set_hdr_cb_flags(skops);
+		set_hdr_cb_flags(skops, 0);
 		break;
 	case BPF_SOCK_OPS_PARSE_HDR_OPT_CB:
 		return handle_parse_hdr(skops);
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
index 9197a23df3da..678bd0fad29e 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
@@ -21,6 +21,7 @@
=20
 __u8 test_kind =3D TCPOPT_EXP;
 __u16 test_magic =3D 0xeB9F;
+__u32 inherit_cb_flags =3D 0;
=20
 struct bpf_test_option passive_synack_out =3D {};
 struct bpf_test_option passive_fin_out	=3D {};
@@ -467,6 +468,8 @@ static int handle_passive_estab(struct bpf_sock_ops *=
skops)
 	struct tcphdr *th;
 	int err;
=20
+	inherit_cb_flags =3D skops->bpf_sock_ops_cb_flags;
+
 	err =3D load_option(skops, &passive_estab_in, true);
 	if (err =3D=3D -ENOENT) {
 		/* saved_syn is not found. It was in syncookie mode.
@@ -600,10 +603,10 @@ int estab(struct bpf_sock_ops *skops)
 	case BPF_SOCK_OPS_TCP_LISTEN_CB:
 		bpf_setsockopt(skops, SOL_TCP, TCP_SAVE_SYN,
 			       &true_val, sizeof(true_val));
-		set_hdr_cb_flags(skops);
+		set_hdr_cb_flags(skops, BPF_SOCK_OPS_STATE_CB_FLAG);
 		break;
 	case BPF_SOCK_OPS_TCP_CONNECT_CB:
-		set_hdr_cb_flags(skops);
+		set_hdr_cb_flags(skops, 0);
 		break;
 	case BPF_SOCK_OPS_PARSE_HDR_OPT_CB:
 		return handle_parse_hdr(skops);
diff --git a/tools/testing/selftests/bpf/test_tcp_hdr_options.h b/tools/t=
esting/selftests/bpf/test_tcp_hdr_options.h
index 78a8cf9eab42..6118e3ab61fc 100644
--- a/tools/testing/selftests/bpf/test_tcp_hdr_options.h
+++ b/tools/testing/selftests/bpf/test_tcp_hdr_options.h
@@ -110,12 +110,13 @@ static inline void clear_hdr_cb_flags(struct bpf_so=
ck_ops *skops)
 				    BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG));
 }
=20
-static inline void set_hdr_cb_flags(struct bpf_sock_ops *skops)
+static inline void set_hdr_cb_flags(struct bpf_sock_ops *skops, __u32 ex=
tra)
 {
 	bpf_sock_ops_cb_flags_set(skops,
 				  skops->bpf_sock_ops_cb_flags |
 				  BPF_SOCK_OPS_PARSE_UNKNOWN_HDR_OPT_CB_FLAG |
-				  BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG);
+				  BPF_SOCK_OPS_WRITE_HDR_OPT_CB_FLAG |
+				  extra);
 }
 static inline void
 clear_parse_all_hdr_cb_flags(struct bpf_sock_ops *skops)
--=20
2.24.1

