Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3F320B7AC
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgFZR4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:56:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726469AbgFZR4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:56:02 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHsYat010044
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=x9+g55k1QE3JMJ1MSBZfXQgh+V/wM36C3TVhv6OzQtM=;
 b=GAnaiBGmYGqCbBMZLH2EKsDLkqlxbQoP0UBACJ8qHzZsRgKAJNMJiIrtYZznjVIc2B9P
 tCFWyP+GWJljAME3CIZlWWVjJ22iWcxc+Wq0MdxmzUES/8dAUqKSrX9cNizUfx2tP0y2
 b9eRBGk0nzK1qnSWFEYxEln66wzFTkNlnNE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31vdptjfra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:56:02 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:56:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 842D32942E38; Fri, 26 Jun 2020 10:55:58 -0700 (PDT)
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
Subject: [PATCH bpf-next 09/10] tcp: bpf: Add TCP_BPF_DELACK_MAX and TCP_BPF_RTO_MIN to bpf_setsockopt
Date:   Fri, 26 Jun 2020 10:55:58 -0700
Message-ID: <20200626175558.1462731-1-kafai@fb.com>
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
 mlxlogscore=999 cotscore=-2147483648 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 adultscore=0 priorityscore=1501 suspectscore=13
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260126
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
bpf_setsockopt(TCP_BPF_RTO_MIN).  A latter patch will use it
like this in a test as an example.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_connection_sock.h |  2 ++
 include/net/tcp.h                  |  2 +-
 include/uapi/linux/bpf.h           |  2 ++
 net/core/filter.c                  | 15 +++++++++++++++
 net/ipv4/tcp.c                     |  4 ++++
 net/ipv4/tcp_output.c              |  2 ++
 tools/include/uapi/linux/bpf.h     |  2 ++
 7 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connec=
tion_sock.h
index e5b388f5fa20..43d45864e5f0 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -93,6 +93,8 @@ struct inet_connection_sock {
  	struct timer_list	  icsk_retransmit_timer;
  	struct timer_list	  icsk_delack_timer;
 	__u32			  icsk_rto;
+	__u32                     icsk_rto_min;
+	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e93ef2d324f3..8a682d678971 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -703,7 +703,7 @@ static inline void tcp_fast_path_check(struct sock *s=
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
index 479b83d05811..2ccc81548eef 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4299,6 +4299,8 @@ enum {
 	 *	    is not saved by TCP_SAVE_SYN.
 	 */
 	TCP_BPF_SYN_HDR_OPT	=3D 1003,
+	TCP_BPF_DELACK_MAX	=3D 1004, /* Max delay ack in usecs */
+	TCP_BPF_RTO_MIN		=3D 1005, /* Min delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
diff --git a/net/core/filter.c b/net/core/filter.c
index 5784f1bede2f..4b80934e6876 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4431,6 +4431,7 @@ static int _bpf_setsockopt(struct sock *sk, int lev=
el, int optname,
 		} else {
 			struct inet_connection_sock *icsk =3D inet_csk(sk);
 			struct tcp_sock *tp =3D tcp_sk(sk);
+			unsigned long timeout;
=20
 			if (optlen !=3D sizeof(int))
 				return -EINVAL;
@@ -4452,6 +4453,20 @@ static int _bpf_setsockopt(struct sock *sk, int le=
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
index 60093a211f4d..02be3e2a2fdb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -418,6 +418,8 @@ void tcp_init_sock(struct sock *sk)
 	INIT_LIST_HEAD(&tp->tsorted_sent_queue);
=20
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_rto_min =3D TCP_RTO_MIN;
+	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->mdev_us =3D jiffies_to_usecs(TCP_TIMEOUT_INIT);
 	minmax_reset(&tp->rtt_min, tcp_jiffies32, ~0U);
=20
@@ -2685,6 +2687,8 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_backoff =3D 0;
 	icsk->icsk_probes_out =3D 0;
 	icsk->icsk_rto =3D TCP_TIMEOUT_INIT;
+	icsk->icsk_rto_min =3D TCP_RTO_MIN;
+	icsk->icsk_delack_max =3D TCP_DELACK_MAX;
 	tp->snd_ssthresh =3D TCP_INFINITE_SSTHRESH;
 	tp->snd_cwnd =3D TCP_INIT_CWND;
 	tp->snd_cwnd_cnt =3D 0;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a78a29980e1f..db872a2a01c6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3899,6 +3899,8 @@ void tcp_send_delayed_ack(struct sock *sk)
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
index 479b83d05811..2ccc81548eef 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4299,6 +4299,8 @@ enum {
 	 *	    is not saved by TCP_SAVE_SYN.
 	 */
 	TCP_BPF_SYN_HDR_OPT	=3D 1003,
+	TCP_BPF_DELACK_MAX	=3D 1004, /* Max delay ack in usecs */
+	TCP_BPF_RTO_MIN		=3D 1005, /* Min delay ack in usecs */
 };
=20
 struct bpf_perf_event_value {
--=20
2.24.1

