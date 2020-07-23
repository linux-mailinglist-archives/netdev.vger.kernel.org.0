Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1826C22A432
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgGWBDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:03:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387482AbgGWBDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:03:51 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06N11AA8027810
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:03:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QDcZGjcRcN8iU6kjcqNhTgCk0rKCr0rU1R6fsst3OEQ=;
 b=O8DOSFZ4/qlXKOkSbCyEDbT0Lma04VnBiLf+hLY8iwoOXk4XgcdJPQ0QbbhJraZQuDBc
 R/FQTTRYPNE2MtC3datpI7XiO6Xs2tXZU/lCpaWIamYIQ+4Vzeo0wJajWA7smMdoiLGk
 2kNQaqtgc3ipC8qGBQgSZJCtgy7PiuLPcUA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32etbg1t9b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 18:03:51 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 18:03:50 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 3FA052945AD1; Wed, 22 Jul 2020 18:03:47 -0700 (PDT)
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
Subject: [PATCH v2 bpf-next 2/9] tcp: bpf: Add TCP_BPF_DELACK_MAX setsockopt
Date:   Wed, 22 Jul 2020 18:03:47 -0700
Message-ID: <20200723010347.1906800-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723010334.1905574-1-kafai@fb.com>
References: <20200723010334.1905574-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_17:2020-07-22,2020-07-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=13 clxscore=1015 bulkscore=0 phishscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007230005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change is mostly from an internal patch and adapts it from sysctl
config to the bpf_setsockopt setup.

The bpf_prog can set the max delay ack by using
bpf_setsockopt(TCP_BPF_DELACK_MAX).  This max delay ack can be communicat=
ed
to its peer through bpf header option.  The receiving peer can then use
this max delay ack and set a potentially lower rto by using
bpf_setsockopt(TCP_BPF_RTO_MIN) which will be introduced
in the next patch.

Another latter seltest patch will also use it like the above to show
how to write and parse bpf tcp header option.

Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_connection_sock.h | 1 +
 include/uapi/linux/bpf.h           | 1 +
 net/core/filter.c                  | 8 ++++++++
 net/ipv4/tcp.c                     | 2 ++
 net/ipv4/tcp_output.c              | 2 ++
 tools/include/uapi/linux/bpf.h     | 1 +
 6 files changed, 15 insertions(+)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
index 157c60cca0ca..8fd5c55b6756 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -85,6 +85,7 @@ struct inet_connection_sock {
  	struct timer_list	  icsk_retransmit_timer;
  	struct timer_list	  icsk_delack_timer;
 	__u32			  icsk_rto;
+	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54d0c886e3ba..227a2a4b7157 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4229,6 +4229,7 @@ enum {
 enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
+	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
diff --git a/net/core/filter.c b/net/core/filter.c
index 04c4d89d56c3..c8dae35ab5f1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4459,6 +4459,7 @@ static int _bpf_setsockopt(struct sock *sk, int lev=
el, int optname,
 		} else {
 			struct inet_connection_sock *icsk =3D inet_csk(sk);
 			struct tcp_sock *tp =3D tcp_sk(sk);
+			unsigned long timeout;
=20
 			if (optlen !=3D sizeof(int))
 				return -EINVAL;
@@ -4480,6 +4481,13 @@ static int _bpf_setsockopt(struct sock *sk, int le=
vel, int optname,
 					tp->snd_ssthresh =3D val;
 				}
 				break;
+			case TCP_BPF_DELACK_MAX:
+				timeout =3D usecs_to_jiffies(val);
+				if (timeout > TCP_DELACK_MAX ||
+				    timeout < TCP_TIMEOUT_MIN)
+					return -EINVAL;
+				inet_csk(sk)->icsk_delack_max =3D timeout;
+				break;
 			case TCP_SAVE_SYN:
 				if (val < 0 || val > 1)
 					ret =3D -EINVAL;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 123100057890..d8076d95f6a9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -418,6 +418,7 @@ void tcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&tp->tsorted_sent_queue);
=20
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->mdev_us =3D jiffies_to_usecs(TCP_TIMEOUT_INIT);
 	minmax_reset(&tp->rtt_min, tcp_jiffies32, ~0U);
=20
@@ -2685,6 +2686,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_backoff =3D 0;
 	icsk->icsk_probes_out =3D 0;
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->snd_ssthresh =3D TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd =3D TCP_INIT_CWND;
 	tp->snd_cwnd_cnt =3D 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index dc0117013ba5..4595dd495f6f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3738,6 +3738,8 @@ void tcp_send_delayed_ack(struct sock *sk)
 		ato =3D min(ato, max_ato);
 	}
=20
+	ato =3D min_t(u32, ato, inet_csk(sk)->icsk_delack_max);
+
 	/* Stay within the limit we were given */
 	timeout =3D jiffies + ato;
=20
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 54d0c886e3ba..227a2a4b7157 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4229,6 +4229,7 @@ enum {
 enum {
 	TCP_BPF_IW		=3D 1001,	/* Set TCP initial congestion window */
 	TCP_BPF_SNDCWND_CLAMP	=3D 1002,	/* Set sndcwnd_clamp */
+	TCP_BPF_DELACK_MAX	=3D 1003, /* Max delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
--=20
2.24.1

