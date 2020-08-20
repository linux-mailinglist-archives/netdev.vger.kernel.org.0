Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E293824C610
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 21:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgHTTBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 15:01:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38068 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728005AbgHTTBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 15:01:33 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07KIxZN7022045
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VkKpc32CmSVk3dL75W9HH6zZJ1B77FZXq7v4m+xfnkY=;
 b=QwW5ftfOs+6tbjD4ljFqyguhEO7Q138ll9iCMFx2o7YXL7eRqYyjpA9IzxyImpTmFqSZ
 wBFfiPE0S3J7sryTAAoor3O5AV5wKcswyxfaoiOy0JzfwtyNrNqxAcB2QSOfKsyHCzuo
 bfHY/Xfk5jh0wMRtr/33R7+RApLvJrG4X/U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 331crbd4af-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 12:01:31 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 12:01:25 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AA4D52945825; Thu, 20 Aug 2020 12:01:23 -0700 (PDT)
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
Subject: [PATCH v5 bpf-next 12/12] tcp: bpf: Optionally store mac header in TCP_SAVE_SYN
Date:   Thu, 20 Aug 2020 12:01:23 -0700
Message-ID: <20200820190123.2886935-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820190008.2883500-1-kafai@fb.com>
References: <20200820190008.2883500-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_03:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 mlxlogscore=952 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is adapted from Eric's patch in an earlier discussion [1].

The TCP_SAVE_SYN currently only stores the network header and
tcp header.  This patch allows it to optionally store
the mac header also if the setsockopt's optval is 2.

It requires one more bit for the "save_syn" bit field in tcp_sock.
This patch achieves this by moving the syn_smc bit next to the is_mptcp.
The syn_smc is currently used with the TCP experimental option.  Since
syn_smc is only used when CONFIG_SMC is enabled, this patch also puts
the "IS_ENABLED(CONFIG_SMC)" around it like the is_mptcp did
with "IS_ENABLED(CONFIG_MPTCP)".

The mac_hdrlen is also stored in the "struct saved_syn"
to allow a quick offset from the bpf prog if it chooses to start
getting from the network header or the tcp header.

[1]: https://lore.kernel.org/netdev/CANn89iLJNWh6bkH7DNhy_kmcAexuUCccqERq=
e7z2QsvPhGrYPQ@mail.gmail.com/

Suggested-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/tcp.h            | 13 ++++++++-----
 include/net/request_sock.h     |  1 +
 include/uapi/linux/bpf.h       |  1 +
 net/core/filter.c              | 27 ++++++++++++++++++++++-----
 net/ipv4/tcp.c                 |  3 ++-
 net/ipv4/tcp_input.c           | 14 +++++++++++++-
 tools/include/uapi/linux/bpf.h |  1 +
 7 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 29d166263ae7..56ff2952edaf 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -239,14 +239,13 @@ struct tcp_sock {
 		repair      : 1,
 		frto        : 1;/* F-RTO (RFC5682) activated in CA_Loss */
 	u8	repair_queue;
-	u8	syn_data:1,	/* SYN includes data */
+	u8	save_syn:2,	/* Save headers of SYN packet */
+		syn_data:1,	/* SYN includes data */
 		syn_fastopen:1,	/* SYN includes Fast Open option */
 		syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
 		syn_fastopen_ch:1, /* Active TFO re-enabling probe */
 		syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
-		save_syn:1,	/* Save headers of SYN packet */
-		is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
-		syn_smc:1;	/* SYN includes SMC */
+		is_cwnd_limited:1;/* forward progress limited by snd_cwnd? */
 	u32	tlp_high_seq;	/* snd_nxt at the time of TLP */
=20
 	u32	tcp_tx_delay;	/* delay (in usec) added to TX packets */
@@ -393,6 +392,9 @@ struct tcp_sock {
 #if IS_ENABLED(CONFIG_MPTCP)
 	bool	is_mptcp;
 #endif
+#if IS_ENABLED(CONFIG_SMC)
+	bool	syn_smc;	/* SYN includes SMC */
+#endif
=20
 #ifdef CONFIG_TCP_MD5SIG
 /* TCP AF-Specific parts; only used by MD5 Signature support so far */
@@ -488,7 +490,8 @@ static inline void tcp_saved_syn_free(struct tcp_sock=
 *tp)
=20
 static inline u32 tcp_saved_syn_len(const struct saved_syn *saved_syn)
 {
-	return saved_syn->network_hdrlen + saved_syn->tcp_hdrlen;
+	return saved_syn->mac_hdrlen + saved_syn->network_hdrlen +
+		saved_syn->tcp_hdrlen;
 }
=20
 struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 7d9ed99a77bd..29e41ff3ec93 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -42,6 +42,7 @@ struct request_sock_ops {
 int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req=
);
=20
 struct saved_syn {
+	u32 mac_hdrlen;
 	u32 network_hdrlen;
 	u32 tcp_hdrlen;
 	u8 data[];
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 277b145bf7c3..38f6da373b5d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4533,6 +4533,7 @@ enum {
 	 */
 	TCP_BPF_SYN		=3D 1005, /* Copy the TCP header */
 	TCP_BPF_SYN_IP		=3D 1006, /* Copy the IP[46] and TCP header */
+	TCP_BPF_SYN_MAC         =3D 1007, /* Copy the MAC, IP[46], and TCP head=
er */
 };
=20
 enum {
diff --git a/net/core/filter.c b/net/core/filter.c
index ab5603d5b62a..47eef9a0be6a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4682,11 +4682,16 @@ static int bpf_sock_ops_get_syn(struct bpf_sock_o=
ps_kern *bpf_sock,
 		if (optname =3D=3D TCP_BPF_SYN) {
 			hdr_start =3D syn_skb->data;
 			ret =3D tcp_hdrlen(syn_skb);
-		} else {
-			/* optname =3D=3D TCP_BPF_SYN_IP */
+		} else if (optname =3D=3D TCP_BPF_SYN_IP) {
 			hdr_start =3D skb_network_header(syn_skb);
 			ret =3D skb_network_header_len(syn_skb) +
 				tcp_hdrlen(syn_skb);
+		} else {
+			/* optname =3D=3D TCP_BPF_SYN_MAC */
+			hdr_start =3D skb_mac_header(syn_skb);
+			ret =3D skb_mac_header_len(syn_skb) +
+				skb_network_header_len(syn_skb) +
+				tcp_hdrlen(syn_skb);
 		}
 	} else {
 		struct sock *sk =3D bpf_sock->sk;
@@ -4706,12 +4711,24 @@ static int bpf_sock_ops_get_syn(struct bpf_sock_o=
ps_kern *bpf_sock,
=20
 		if (optname =3D=3D TCP_BPF_SYN) {
 			hdr_start =3D saved_syn->data +
+				saved_syn->mac_hdrlen +
 				saved_syn->network_hdrlen;
 			ret =3D saved_syn->tcp_hdrlen;
+		} else if (optname =3D=3D TCP_BPF_SYN_IP) {
+			hdr_start =3D saved_syn->data +
+				saved_syn->mac_hdrlen;
+			ret =3D saved_syn->network_hdrlen +
+				saved_syn->tcp_hdrlen;
 		} else {
-			/* optname =3D=3D TCP_BPF_SYN_IP */
+			/* optname =3D=3D TCP_BPF_SYN_MAC */
+
+			/* TCP_SAVE_SYN may not have saved the mac hdr */
+			if (!saved_syn->mac_hdrlen)
+				return -ENOENT;
+
 			hdr_start =3D saved_syn->data;
-			ret =3D saved_syn->network_hdrlen +
+			ret =3D saved_syn->mac_hdrlen +
+				saved_syn->network_hdrlen +
 				saved_syn->tcp_hdrlen;
 		}
 	}
@@ -4724,7 +4741,7 @@ BPF_CALL_5(bpf_sock_ops_getsockopt, struct bpf_sock=
_ops_kern *, bpf_sock,
 	   int, level, int, optname, char *, optval, int, optlen)
 {
 	if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP &&
-	    optname >=3D TCP_BPF_SYN && optname <=3D TCP_BPF_SYN_IP) {
+	    optname >=3D TCP_BPF_SYN && optname <=3D TCP_BPF_SYN_MAC) {
 		int ret, copy_len =3D 0;
 		const u8 *start;
=20
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6075cb091a20..57a568875539 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3211,7 +3211,8 @@ static int do_tcp_setsockopt(struct sock *sk, int l=
evel, int optname,
 		break;
=20
 	case TCP_SAVE_SYN:
-		if (val < 0 || val > 1)
+		/* 0: disable, 1: enable, 2: start from ether_header */
+		if (val < 0 || val > 2)
 			err =3D -EINVAL;
 		else
 			tp->save_syn =3D val;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 319cc7fd5117..4337841faeff 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6676,13 +6676,25 @@ static void tcp_reqsk_record_syn(const struct soc=
k *sk,
 	if (tcp_sk(sk)->save_syn) {
 		u32 len =3D skb_network_header_len(skb) + tcp_hdrlen(skb);
 		struct saved_syn *saved_syn;
+		u32 mac_hdrlen;
+		void *base;
+
+		if (tcp_sk(sk)->save_syn =3D=3D 2) {  /* Save full header. */
+			base =3D skb_mac_header(skb);
+			mac_hdrlen =3D skb_mac_header_len(skb);
+			len +=3D mac_hdrlen;
+		} else {
+			base =3D skb_network_header(skb);
+			mac_hdrlen =3D 0;
+		}
=20
 		saved_syn =3D kmalloc(struct_size(saved_syn, data, len),
 				    GFP_ATOMIC);
 		if (saved_syn) {
+			saved_syn->mac_hdrlen =3D mac_hdrlen;
 			saved_syn->network_hdrlen =3D skb_network_header_len(skb);
 			saved_syn->tcp_hdrlen =3D tcp_hdrlen(skb);
-			memcpy(saved_syn->data, skb_network_header(skb), len);
+			memcpy(saved_syn->data, base, len);
 			req->saved_syn =3D saved_syn;
 		}
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
index 277b145bf7c3..38f6da373b5d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4533,6 +4533,7 @@ enum {
 	 */
 	TCP_BPF_SYN		=3D 1005, /* Copy the TCP header */
 	TCP_BPF_SYN_IP		=3D 1006, /* Copy the IP[46] and TCP header */
+	TCP_BPF_SYN_MAC         =3D 1007, /* Copy the MAC, IP[46], and TCP head=
er */
 };
=20
 enum {
--=20
2.24.1

