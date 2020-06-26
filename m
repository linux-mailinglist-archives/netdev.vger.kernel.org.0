Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A750720B7E0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 20:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgFZSPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 14:15:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15724 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725780AbgFZSPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 14:15:54 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QIEjYP016997
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:15:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+5gX+pClJaFpnEtzx25mq9s0SmaUpVNIkxWYhJOUFrM=;
 b=jjbj+HQ1lXA9ZrMc6d9UdOLZPcE/7YXWuSgF1bJANngB32IvlmN04TbZKCoWDSTLADdp
 XATfKmuBwcI3khZHsmETzVIaBlZfYru6t15ZfdRy99GNh584znvxplXF7C0aTst4D6t0
 2HmKeOKvbquCPL3B+xC4QEMdHpFKSBpiYp0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux1exr8r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 11:15:52 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 11:15:52 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 59D572942E38; Fri, 26 Jun 2020 10:55:14 -0700 (PDT)
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
Subject: [PATCH bpf-next 02/10] tcp: bpf: Parse BPF experimental header option
Date:   Fri, 26 Jun 2020 10:55:14 -0700
Message-ID: <20200626175514.1460570-1-kafai@fb.com>
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
 clxscore=1015 cotscore=-2147483648 spamscore=0 mlxlogscore=607 bulkscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 suspectscore=13 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006260129
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds logic to parse experimental kind 254 with 16 bit magic
0xeB9F.  The latter patch will allow bpf prog to write and parse data
under this experimental kind and magic.

A one byte bpf_hdr_opt_off is added to tcp_skb_cb by using an existing
4 byte hole.  It is only used in rx.  It stores the offset to the
bpf experimental option and will be made available to BPF prog
in a latter patch.  This offset is also stored in the saved_syn.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/request_sock.h | 1 +
 include/net/tcp.h          | 3 +++
 net/ipv4/tcp_input.c       | 6 ++++++
 net/ipv4/tcp_ipv4.c        | 1 +
 net/ipv6/tcp_ipv6.c        | 1 +
 5 files changed, 12 insertions(+)

diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index d77237ec9fb4..55297286c066 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -43,6 +43,7 @@ int inet_rtx_syn_ack(const struct sock *parent, struct =
request_sock *req);
=20
 struct saved_syn {
 	u32 network_hdrlen;
+	u32 bpf_hdr_opt_off;
 	u8 data[];
 };
=20
diff --git a/include/net/tcp.h b/include/net/tcp.h
index eab1c7d0facb..07a9dfe35242 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -191,6 +191,7 @@ void tcp_time_wait(struct sock *sk, int state, int ti=
meo);
  */
 #define TCPOPT_FASTOPEN_MAGIC	0xF989
 #define TCPOPT_SMC_MAGIC	0xE2D4C3D9
+#define TCPOPT_BPF_MAGIC	0xEB9F
=20
 /*
  *     TCP option lengths
@@ -204,6 +205,7 @@ void tcp_time_wait(struct sock *sk, int state, int ti=
meo);
 #define TCPOLEN_FASTOPEN_BASE  2
 #define TCPOLEN_EXP_FASTOPEN_BASE  4
 #define TCPOLEN_EXP_SMC_BASE   6
+#define TCPOLEN_EXP_BPF_BASE   4
=20
 /* But this is what stacks really send out. */
 #define TCPOLEN_TSTAMP_ALIGNED		12
@@ -857,6 +859,7 @@ struct tcp_skb_cb {
 			has_rxtstamp:1,	/* SKB has a RX timestamp	*/
 			unused:5;
 	__u32		ack_seq;	/* Sequence number ACK'd	*/
+	__u8            bpf_hdr_opt_off;/* offset to bpf hdr option. rx only. *=
/
 	union {
 		struct {
 			/* There is space for up to 24 bytes */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index eb0e32b2def9..640408a80b3d 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3924,6 +3924,10 @@ void tcp_parse_options(const struct net *net,
 					tcp_parse_fastopen_option(opsize -
 						TCPOLEN_EXP_FASTOPEN_BASE,
 						ptr + 2, th->syn, foc, true);
+				else if (opsize >=3D TCPOLEN_EXP_BPF_BASE &&
+					 get_unaligned_be16(ptr) =3D=3D
+					 TCPOPT_BPF_MAGIC)
+					TCP_SKB_CB(skb)->bpf_hdr_opt_off =3D (ptr - 2) - (unsigned char *)t=
h;
 				else
 					smc_parse_options(th, opt_rx, ptr,
 							  opsize);
@@ -6562,6 +6566,8 @@ static void tcp_reqsk_record_syn(const struct sock =
*sk,
 		saved_syn =3D kmalloc(len + sizeof(*saved_syn), GFP_ATOMIC);
 		if (saved_syn) {
 			saved_syn->network_hdrlen =3D skb_network_header_len(skb);
+			saved_syn->bpf_hdr_opt_off =3D
+				TCP_SKB_CB(skb)->bpf_hdr_opt_off;
 			memcpy(saved_syn->data, skb_network_header(skb), len);
 			req->saved_syn =3D saved_syn;
 		}
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ea0df9fd7618..a3535b7fe002 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1864,6 +1864,7 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, con=
st struct iphdr *iph,
 	TCP_SKB_CB(skb)->sacked	 =3D 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =3D
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
+	TCP_SKB_CB(skb)->bpf_hdr_opt_off =3D 0;
 }
=20
 /*
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f67d45ff00b4..8356d0562279 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1545,6 +1545,7 @@ static void tcp_v6_fill_cb(struct sk_buff *skb, con=
st struct ipv6hdr *hdr,
 	TCP_SKB_CB(skb)->sacked =3D 0;
 	TCP_SKB_CB(skb)->has_rxtstamp =3D
 			skb->tstamp || skb_hwtstamps(skb)->hwtstamp;
+	TCP_SKB_CB(skb)->bpf_hdr_opt_off =3D 0;
 }
=20
 INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
--=20
2.24.1

