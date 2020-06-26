Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5224620B7B1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgFZR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:56:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1394 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbgFZR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:56:18 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHsuDF019455
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UHFQQFqYSY8aevwSYLHh6Hobk6A4dxuODVh5qoz6O0I=;
 b=KZ8kGK6tZ2/Y2glbND15vFuJBXyR6zlf7Rs3Hq7BRSRTZVPPpECLI65lbAsaACOyuZM3
 uxcFi/BheiBqUc66daSqCV35+KPjbo+vbY+QkAyozwVAhVYaTkMPT8ycND/yQw1q9lbo
 +EXuGnq1n+jY3NfxE8gqaM/Zi2wdaQMjTSY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1exn4y-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:17 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:56:09 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id CA5942942E38; Fri, 26 Jun 2020 10:56:04 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 10/10] bpf: selftest: Add test for TCP_BPF_DELACK_MAX and TCP_BPF_RTO_MIN
Date:   Fri, 26 Jun 2020 10:56:04 -0700
Message-ID: <20200626175604.1462935-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_10:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=739 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=13 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch tests a bpf prog that parses/writes a max_delack_ms bpf header
option and also bpf_setsockopt its TCP_BPF_DELACK_MAX/TCP_BPF_RTO_MIN
accordingly.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../bpf/prog_tests/tcp_hdr_options.c          |  6 ++--
 .../bpf/progs/test_tcp_hdr_options.c          | 34 +++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
index f8daf36783f3..5a58f60d2889 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
@@ -447,11 +447,13 @@ static void simple_estab(void)
 	struct bpf_link *link;
 	struct sk_fds sk_fds;
=20
-	exp_passive_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_passive_estab_in.flags =3D OPTION_F_MAGIC | OPTION_F_MAX_DELACK_MS;
 	exp_passive_estab_in.magic =3D 0xfa;
+	exp_passive_estab_in.max_delack_ms =3D 11;
=20
-	exp_active_estab_in.flags =3D OPTION_F_MAGIC;
+	exp_active_estab_in.flags =3D OPTION_F_MAGIC | OPTION_F_MAX_DELACK_MS;
 	exp_active_estab_in.magic =3D 0xce;
+	exp_active_estab_in.max_delack_ms =3D 22;
=20
 	prepare_out();
=20
diff --git a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c b/t=
ools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
index 631181bfb4cc..eb3b3c2a21f9 100644
--- a/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
+++ b/tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
@@ -465,6 +465,24 @@ static __always_inline int handle_write_hdr_opt(stru=
ct bpf_sock_ops *skops)
 	return write_nodata_opt(skops);
 }
=20
+static __always_inline int set_delack_max(struct bpf_sock_ops *skops,
+					  __u8 max_delack_ms)
+{
+	__u32 max_delack_us =3D max_delack_ms * 1000;
+
+	return bpf_setsockopt(skops, SOL_TCP, TCP_BPF_DELACK_MAX,
+			      &max_delack_us, sizeof(max_delack_us));
+}
+
+static __always_inline int set_rto_min(struct bpf_sock_ops *skops,
+				       __u8 peer_max_delack_ms)
+{
+	__u32 min_rto_us =3D peer_max_delack_ms * 1000;
+
+	return bpf_setsockopt(skops, SOL_TCP, TCP_BPF_RTO_MIN, &min_rto_us,
+			      sizeof(min_rto_us));
+}
+
 static __always_inline int handle_active_estab(struct bpf_sock_ops *skop=
s)
 {
 	__u8 bpf_hdr_opt_off =3D skops->skb_bpf_hdr_opt_off;
@@ -505,6 +523,14 @@ static __always_inline int handle_active_estab(struc=
t bpf_sock_ops *skops)
 		/* No options will be written from now */
 		clear_hdr_cb_flags(skops);
=20
+	if (active_syn_out.max_delack_ms &&
+	    set_delack_max(skops, active_syn_out.max_delack_ms))
+		RET_CG_ERR(skops);
+
+	if (active_estab_in.max_delack_ms &&
+	    set_rto_min(skops, active_estab_in.max_delack_ms))
+		RET_CG_ERR(skops);
+
 	return CG_OK;
 }
=20
@@ -590,6 +616,14 @@ static __always_inline int handle_passive_estab(stru=
ct bpf_sock_ops *skops)
 		/* No options will be written from now */
 		clear_hdr_cb_flags(skops);
=20
+	if (passive_synack_out.max_delack_ms &&
+	    set_delack_max(skops, passive_synack_out.max_delack_ms))
+		RET_CG_ERR(skops);
+
+	if (passive_estab_in.max_delack_ms &&
+	    set_rto_min(skops, passive_estab_in.max_delack_ms))
+		RET_CG_ERR(skops);
+
 	return CG_OK;
 }
=20
--=20
2.24.1

