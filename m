Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD8D581FEE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiG0GKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiG0GKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:10:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8D1402DF
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:02 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND8Tl008844
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Q7ye1uvhTNm1WK39/SGxiNy6FlGNaF1cXm4Kn6i1V3M=;
 b=XskIJ089+fAg2HoROJ4X0AUx3+jz8v6hkiCqmYLEFX6t/CXjKSKRPX7XwZupH+vaIUYb
 fayGGqSzSQxFzEc1f6IfcODmgtHvkgQ/siUTMRdvGpWS3HQf7UPsCCQ9HlAzdgj0KnVn
 zEOQBX4mx554FfaKf9uNfaKi8JPs20P5x38= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjdvtphr5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:01 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub204.TheFacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:10:00 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:10:00 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 571DB757CDA8; Tue, 26 Jul 2022 23:09:53 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 09/14] bpf: Refactor bpf specific tcp optnames to a new function
Date:   Tue, 26 Jul 2022 23:09:53 -0700
Message-ID: <20220727060953.2377778-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: jBO78Io7L99InDS6wszjkeaRx8ojfL9x
X-Proofpoint-ORIG-GUID: jBO78Io7L99InDS6wszjkeaRx8ojfL9x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch moves all bpf specific tcp optnames (TCP_BPF_XXX)
to a new function bpf_sol_tcp_setsockopt().  This will make
the next patch easier to follow.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 79 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 29 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 77a9aa17a1c0..8dd195b9b860 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5049,6 +5049,52 @@ static int sol_socket_setsockopt(struct sock *sk, =
int optname,
 			       KERNEL_SOCKPTR_BPF(optval), optlen);
 }
=20
+static int bpf_sol_tcp_setsockopt(struct sock *sk, int optname,
+				  char *optval, int optlen)
+{
+	struct tcp_sock *tp =3D tcp_sk(sk);
+	unsigned long timeout;
+	int val;
+
+	if (optlen !=3D sizeof(int))
+		return -EINVAL;
+
+	val =3D *(int *)optval;
+
+	/* Only some options are supported */
+	switch (optname) {
+	case TCP_BPF_IW:
+		if (val <=3D 0 || tp->data_segs_out > tp->syn_data)
+			return -EINVAL;
+		tcp_snd_cwnd_set(tp, val);
+		break;
+	case TCP_BPF_SNDCWND_CLAMP:
+		if (val <=3D 0)
+			return -EINVAL;
+		tp->snd_cwnd_clamp =3D val;
+		tp->snd_ssthresh =3D val;
+		break;
+	case TCP_BPF_DELACK_MAX:
+		timeout =3D usecs_to_jiffies(val);
+		if (timeout > TCP_DELACK_MAX ||
+		    timeout < TCP_TIMEOUT_MIN)
+			return -EINVAL;
+		inet_csk(sk)->icsk_delack_max =3D timeout;
+		break;
+	case TCP_BPF_RTO_MIN:
+		timeout =3D usecs_to_jiffies(val);
+		if (timeout > TCP_RTO_MIN ||
+		    timeout < TCP_TIMEOUT_MIN)
+			return -EINVAL;
+		inet_csk(sk)->icsk_rto_min =3D timeout;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int __bpf_setsockopt(struct sock *sk, int level, int optname,
 			    char *optval, int optlen)
 {
@@ -5103,6 +5149,10 @@ static int __bpf_setsockopt(struct sock *sk, int l=
evel, int optname,
 		}
 	} else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP &&
 		   sk->sk_prot->setsockopt =3D=3D tcp_setsockopt) {
+		if (optname >=3D TCP_BPF_IW)
+			return bpf_sol_tcp_setsockopt(sk, optname,
+						      optval, optlen);
+
 		if (optname =3D=3D TCP_CONGESTION) {
 			char name[TCP_CA_NAME_MAX];
=20
@@ -5113,7 +5163,6 @@ static int __bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 		} else {
 			struct inet_connection_sock *icsk =3D inet_csk(sk);
 			struct tcp_sock *tp =3D tcp_sk(sk);
-			unsigned long timeout;
=20
 			if (optlen !=3D sizeof(int))
 				return -EINVAL;
@@ -5121,34 +5170,6 @@ static int __bpf_setsockopt(struct sock *sk, int l=
evel, int optname,
 			val =3D *((int *)optval);
 			/* Only some options are supported */
 			switch (optname) {
-			case TCP_BPF_IW:
-				if (val <=3D 0 || tp->data_segs_out > tp->syn_data)
-					ret =3D -EINVAL;
-				else
-					tcp_snd_cwnd_set(tp, val);
-				break;
-			case TCP_BPF_SNDCWND_CLAMP:
-				if (val <=3D 0) {
-					ret =3D -EINVAL;
-				} else {
-					tp->snd_cwnd_clamp =3D val;
-					tp->snd_ssthresh =3D val;
-				}
-				break;
-			case TCP_BPF_DELACK_MAX:
-				timeout =3D usecs_to_jiffies(val);
-				if (timeout > TCP_DELACK_MAX ||
-				    timeout < TCP_TIMEOUT_MIN)
-					return -EINVAL;
-				inet_csk(sk)->icsk_delack_max =3D timeout;
-				break;
-			case TCP_BPF_RTO_MIN:
-				timeout =3D usecs_to_jiffies(val);
-				if (timeout > TCP_RTO_MIN ||
-				    timeout < TCP_TIMEOUT_MIN)
-					return -EINVAL;
-				inet_csk(sk)->icsk_rto_min =3D timeout;
-				break;
 			case TCP_SAVE_SYN:
 				if (val < 0 || val > 1)
 					ret =3D -EINVAL;
--=20
2.30.2

