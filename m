Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEF23486B3
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbhCYBx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:53:27 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11704 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236207AbhCYBw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 21:52:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12P1oFsR003248
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/yuvTB6+Aj3e72JYrgW12M1+/D8BgrcZz2gBV/6qg/s=;
 b=JbANfjx5/5PbmTIrR0sPrbhpkjXGIu5IIqBPTZzzOI+FK3OJHdlS2iu+UP/oAunpUz7R
 Bc17KuIwXZey15LUw3iWEFq+76E+m31j+BtB97wtq2pW8iYvhFc7H6fpGnFmcBxqGSnJ
 acfxdmmqqy7rpaq1fKbYuBHG++EjqQnYWOQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37fnsxh6cc-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 18:52:58 -0700
Received: from intmgw002.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 18:52:57 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 922F129429DE; Wed, 24 Mar 2021 18:52:46 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf-next 13/14] bpf: selftests: bpf_cubic and bpf_dctcp calling kernel functions
Date:   Wed, 24 Mar 2021 18:52:46 -0700
Message-ID: <20210325015246.1551062-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325015124.1543397-1-kafai@fb.com>
References: <20210325015124.1543397-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-24_14:2021-03-24,2021-03-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 priorityscore=1501
 spamscore=0 mlxlogscore=809 bulkscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the bpf implementation of tcp_slow_start()
and tcp_cong_avoid_ai().  Instead, it directly uses the kernel
implementation.

It also replaces the bpf_cubic_undo_cwnd implementation by directly
calling tcp_reno_undo_cwnd().  bpf_dctcp also directly calls
tcp_reno_cong_avoid() instead.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/bpf_tcp_helpers.h | 29 ++-----------------
 tools/testing/selftests/bpf/progs/bpf_cubic.c |  6 ++--
 tools/testing/selftests/bpf/progs/bpf_dctcp.c | 22 ++++----------
 3 files changed, 11 insertions(+), 46 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testin=
g/selftests/bpf/bpf_tcp_helpers.h
index 91f0fac632f4..029589c008c9 100644
--- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
@@ -187,16 +187,6 @@ struct tcp_congestion_ops {
 	typeof(y) __y =3D (y);			\
 	__x =3D=3D 0 ? __y : ((__y =3D=3D 0) ? __x : min(__x, __y)); })
=20
-static __always_inline __u32 tcp_slow_start(struct tcp_sock *tp, __u32 a=
cked)
-{
-	__u32 cwnd =3D min(tp->snd_cwnd + acked, tp->snd_ssthresh);
-
-	acked -=3D cwnd - tp->snd_cwnd;
-	tp->snd_cwnd =3D min(cwnd, tp->snd_cwnd_clamp);
-
-	return acked;
-}
-
 static __always_inline bool tcp_in_slow_start(const struct tcp_sock *tp)
 {
 	return tp->snd_cwnd < tp->snd_ssthresh;
@@ -213,22 +203,7 @@ static __always_inline bool tcp_is_cwnd_limited(cons=
t struct sock *sk)
 	return !!BPF_CORE_READ_BITFIELD(tp, is_cwnd_limited);
 }
=20
-static __always_inline void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32=
 w, __u32 acked)
-{
-	/* If credits accumulated at a higher w, apply them gently now. */
-	if (tp->snd_cwnd_cnt >=3D w) {
-		tp->snd_cwnd_cnt =3D 0;
-		tp->snd_cwnd++;
-	}
-
-	tp->snd_cwnd_cnt +=3D acked;
-	if (tp->snd_cwnd_cnt >=3D w) {
-		__u32 delta =3D tp->snd_cwnd_cnt / w;
-
-		tp->snd_cwnd_cnt -=3D delta * w;
-		tp->snd_cwnd +=3D delta;
-	}
-	tp->snd_cwnd =3D min(tp->snd_cwnd, tp->snd_cwnd_clamp);
-}
+extern __u32 tcp_slow_start(struct tcp_sock *tp, __u32 acked) __ksym;
+extern void tcp_cong_avoid_ai(struct tcp_sock *tp, __u32 w, __u32 acked)=
 __ksym;
=20
 #endif
diff --git a/tools/testing/selftests/bpf/progs/bpf_cubic.c b/tools/testin=
g/selftests/bpf/progs/bpf_cubic.c
index 33c4d2bded64..f62df4d023f9 100644
--- a/tools/testing/selftests/bpf/progs/bpf_cubic.c
+++ b/tools/testing/selftests/bpf/progs/bpf_cubic.c
@@ -525,11 +525,11 @@ void BPF_STRUCT_OPS(bpf_cubic_acked, struct sock *s=
k,
 		hystart_update(sk, delay);
 }
=20
+extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
+
 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
 {
-	const struct tcp_sock *tp =3D tcp_sk(sk);
-
-	return max(tp->snd_cwnd, tp->prior_cwnd);
+	return tcp_reno_undo_cwnd(sk);
 }
=20
 SEC(".struct_ops")
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testin=
g/selftests/bpf/progs/bpf_dctcp.c
index 4dc1a967776a..fd42247da8b4 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -194,22 +194,12 @@ __u32 BPF_PROG(dctcp_cwnd_undo, struct sock *sk)
 	return max(tcp_sk(sk)->snd_cwnd, ca->loss_cwnd);
 }
=20
-SEC("struct_ops/tcp_reno_cong_avoid")
-void BPF_PROG(tcp_reno_cong_avoid, struct sock *sk, __u32 ack, __u32 ack=
ed)
-{
-	struct tcp_sock *tp =3D tcp_sk(sk);
-
-	if (!tcp_is_cwnd_limited(sk))
-		return;
+extern void tcp_reno_cong_avoid(struct sock *sk, __u32 ack, __u32 acked)=
 __ksym;
=20
-	/* In "safe" area, increase. */
-	if (tcp_in_slow_start(tp)) {
-		acked =3D tcp_slow_start(tp, acked);
-		if (!acked)
-			return;
-	}
-	/* In dangerous area, increase slowly. */
-	tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+SEC("struct_ops/dctcp_reno_cong_avoid")
+void BPF_PROG(dctcp_cong_avoid, struct sock *sk, __u32 ack, __u32 acked)
+{
+	tcp_reno_cong_avoid(sk, ack, acked);
 }
=20
 SEC(".struct_ops")
@@ -226,7 +216,7 @@ struct tcp_congestion_ops dctcp =3D {
 	.in_ack_event   =3D (void *)dctcp_update_alpha,
 	.cwnd_event	=3D (void *)dctcp_cwnd_event,
 	.ssthresh	=3D (void *)dctcp_ssthresh,
-	.cong_avoid	=3D (void *)tcp_reno_cong_avoid,
+	.cong_avoid	=3D (void *)dctcp_cong_avoid,
 	.undo_cwnd	=3D (void *)dctcp_cwnd_undo,
 	.set_state	=3D (void *)dctcp_state,
 	.flags		=3D TCP_CONG_NEEDS_ECN,
--=20
2.30.2

