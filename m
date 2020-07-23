Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F96722A43C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387521AbgGWBEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:04:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52000 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733293AbgGWBEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:04:23 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N14Mfb017674
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CPrxlS/0ouIk2smqKGzOfxgs2TdNNYIFQ5V1UC9Q4Og=;
 b=HB9cLtHfOZVefs/W3igMtqR+5lXA1gkgF4WmZGGySFIlMbfUQ6UPlDXUaMyg2jIBRYXo
 geDpcoIVTriJOIuv7oCt1S+2wIWqVdhicy+HQ7inlHr6vNjYH5kB5cc4O1A3omyd10en
 txFWBt70o/Ruq9zMrHHQZAVJdU9eXrQ9xkk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32embc3tqf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:04:22 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 18:03:54 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7AA242945AD1; Wed, 22 Jul 2020 18:03:53 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 3/9] tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt
Date:   Wed, 22 Jul 2020 18:03:53 -0700
Message-ID: <20200723010353.1907418-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723010334.1905574-1-kafai@fb.com>
References: <20200723010334.1905574-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_17:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=13
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds bpf_setsockopt(TCP_BPF_RTO_MIN) to allow bpf prog
to set the min rto of a connection.  It could be used together
with the earlier patch which has added bpf_setsockopt(TCP_BPF_DELACK_MAX)=
.

A latter seltest patch will communicate the max delay ack in a
bpf tcp header option and then the receiving side can use
bpf_setsockopt(TCP_BPF_RTO_MIN) to set a shorter rto.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_connection_sock.h | 1 +
 include/net/tcp.h                  | 2 +-
 include/uapi/linux/bpf.h           | 1 +
 net/core/filter.c                  | 7 +++++++
 net/ipv4/tcp.c                     | 2 ++
 tools/include/uapi/linux/bpf.h     | 1 +
 6 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
index 8fd5c55b6756..5fa47e495132 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -85,6 +85,7 @@ struct inet_connection_sock {
  	struct timer_list	  icsk_retransmit_timer;
  	struct timer_list	  icsk_delack_timer;
 	__u32			  icsk_rto;
+	__u32                     icsk_rto_min;
 	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
 	const struct tcp_congestion_ops *icsk_ca_ops;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 9f7f7c0c1104..b61ae1bc432f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -697,7 +697,7 @@ static inline void tcp_fast_path_check(struct sock *s=
k)
 static inline u32 tcp_rto_min(struct sock *sk)
 {
 	const struct dst_entry *dst =3D __sk_dst_get(sk);
-	u32 rto_min =3D TCP_RTO_MIN;
+	u32 rto_min =3D inet_csk(sk)->icsk_rto_min;
=20
 	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
 		rto_min =3D dst_metric_rtt(dst, RTAX_RTO_MIN);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 227a2a4b7157..efc1255dbc6a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4230,6 +4230,7 @@ enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
 	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
+	TCP_BPF_RTO_MIN		=3D 1004, /* Min delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
diff --git a/net/core/filter.c b/net/core/filter.c
index c8dae35ab5f1..04266a21229f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4488,6 +4488,13 @@ static int _bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 					return -EINVAL;
 				inet_csk(sk)->icsk_delack_max =3D timeout;
 				break;
+			case TCP_BPF_RTO_MIN:
+				timeout =3D usecs_to_jiffies(val);
+				if (timeout > TCP_RTO_MIN ||
+				    timeout < TCP_TIMEOUT_MIN)
+					return -EINVAL;
+				inet_csk(sk)->icsk_rto_min =3D timeout;
+				break;
 			case TCP_SAVE_SYN:
 				if (val < 0 || val > 1)
 					ret =3D -EINVAL;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d8076d95f6a9..38844beacc48 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -418,6 +418,7 @@ void tcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&tp->tsorted_sent_queue);
=20
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_rto_min =3D TCP_RTO_MIN;
 	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->mdev_us =3D jiffies_to_usecs(TCP_TIMEOUT_INIT);
 	minmax_reset(&tp->rtt_min, tcp_jiffies32, ~0U);
@@ -2686,6 +2687,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_backoff =3D 0;
 	icsk->icsk_probes_out =3D 0;
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_rto_min =3D TCP_RTO_MIN;
 	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->snd_ssthresh =3D TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd =3D TCP_INIT_CWND;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 227a2a4b7157..efc1255dbc6a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4230,6 +4230,7 @@ enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
 	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
+	TCP_BPF_RTO_MIN		=3D 1004, /* Min delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
--=20
2.24.1

