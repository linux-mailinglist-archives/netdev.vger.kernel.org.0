Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6923120B7A0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgFZRzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:55:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17992 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726337AbgFZRzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:55:18 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05QHtBkc021136
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fNk8fwe90WPy8Og2xFMAGWElPpQdJ4rSphcfyurgQrs=;
 b=jnfJ5tm9m8I3y4WWXExPvN7j5K/Yn4+u93wdO+x3LOqXuZ5LLhUnlntpWJyv8/APlm2i
 a8xl2sicRQOHDNu+nkJTJGW4/hjDURhqZJpVHeYyyEA7uDQN5J1aWMOTnVbZ8KlaEU/C
 7OALsfb8h+ILZjZnVpTf6aAV9/6OpQR2UrA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0qend8-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 10:55:17 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 26 Jun 2020 10:55:14 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 24A112942E38; Fri, 26 Jun 2020 10:55:08 -0700 (PDT)
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
Subject: [PATCH bpf-next 01/10] tcp: Use a struct to represent a saved_syn
Date:   Fri, 26 Jun 2020 10:55:08 -0700
Message-ID: <20200626175508.1460345-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200626175501.1459961-1-kafai@fb.com>
References: <20200626175501.1459961-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-26_09:2020-06-26,2020-06-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=38 phishscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=534 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006260126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The total length of the saved syn packet is currently stored in
the first 4 bytes (u32) and the actual packet data is stored after that.

A latter patch will also want to store an offset (bpf_hdr_opt_off) to
a TCP header option which the bpf program will be interested in parsing.
Instead of anonymously storing this offset into the second 4 bytes,
this patch creates a struct for the existing saved_syn.
It can give a readable name to the stored lengths instead of implicitly
using the first few u32(s) to do that.

The new TCP bpf header offset (bpf_hdr_opt_off) added in a latter patch i=
s
an offset from the tcp header instead of from the network header.
It will make the bpf programming side easier.  Thus, this patch stores
the network header length instead of the total length of the syn
header.  The total length can be obtained by the
"network header len + tcp_hdrlen".  The latter patch can
then also gets the offset to the TCP bpf header option by
"network header len + bpf_hdr_opt_off".

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/tcp.h        | 11 ++++++++++-
 include/net/request_sock.h |  7 ++++++-
 net/core/filter.c          |  4 ++--
 net/ipv4/tcp.c             |  9 +++++----
 net/ipv4/tcp_input.c       | 12 ++++++------
 5 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 3bdec31ce8f4..9d50132d95e6 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -404,7 +404,7 @@ struct tcp_sock {
 	 * socket. Used to retransmit SYNACKs etc.
 	 */
 	struct request_sock __rcu *fastopen_rsk;
-	u32	*saved_syn;
+	struct saved_syn *saved_syn;
 };
=20
 enum tsq_enum {
@@ -482,6 +482,15 @@ static inline void tcp_saved_syn_free(struct tcp_soc=
k *tp)
 	tp->saved_syn =3D NULL;
 }
=20
+static inline u32 tcp_saved_syn_len(const struct saved_syn *saved_syn)
+{
+	const struct tcphdr *th;
+
+	th =3D (void *)saved_syn->data + saved_syn->network_hdrlen;
+
+	return saved_syn->network_hdrlen + __tcp_hdrlen(th);
+}
+
 struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk);
=20
 static inline u16 tcp_mss_clamp(const struct tcp_sock *tp, u16 mss)
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index cf8b33213bbc..d77237ec9fb4 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -41,6 +41,11 @@ struct request_sock_ops {
=20
 int inet_rtx_syn_ack(const struct sock *parent, struct request_sock *req=
);
=20
+struct saved_syn {
+	u32 network_hdrlen;
+	u8 data[];
+};
+
 /* struct request_sock - mini sock to represent a connection request
  */
 struct request_sock {
@@ -60,7 +65,7 @@ struct request_sock {
 	struct timer_list		rsk_timer;
 	const struct request_sock_ops	*rsk_ops;
 	struct sock			*sk;
-	u32				*saved_syn;
+	struct saved_syn		*saved_syn;
 	u32				secid;
 	u32				peer_secid;
 };
diff --git a/net/core/filter.c b/net/core/filter.c
index c796e141ea8e..19dbcc8448d8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4522,9 +4522,9 @@ static int _bpf_getsockopt(struct sock *sk, int lev=
el, int optname,
 			tp =3D tcp_sk(sk);
=20
 			if (optlen <=3D 0 || !tp->saved_syn ||
-			    optlen > tp->saved_syn[0])
+			    optlen > tcp_saved_syn_len(tp->saved_syn))
 				goto err_clear;
-			memcpy(optval, tp->saved_syn + 1, optlen);
+			memcpy(optval, tp->saved_syn->data, optlen);
 			break;
 		default:
 			goto err_clear;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index de36c91d32ea..60093a211f4d 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3805,20 +3805,21 @@ static int do_tcp_getsockopt(struct sock *sk, int=
 level,
=20
 		lock_sock(sk);
 		if (tp->saved_syn) {
-			if (len < tp->saved_syn[0]) {
-				if (put_user(tp->saved_syn[0], optlen)) {
+			if (len < tcp_saved_syn_len(tp->saved_syn)) {
+				if (put_user(tcp_saved_syn_len(tp->saved_syn),
+					     optlen)) {
 					release_sock(sk);
 					return -EFAULT;
 				}
 				release_sock(sk);
 				return -EINVAL;
 			}
-			len =3D tp->saved_syn[0];
+			len =3D tcp_saved_syn_len(tp->saved_syn);
 			if (put_user(len, optlen)) {
 				release_sock(sk);
 				return -EFAULT;
 			}
-			if (copy_to_user(optval, tp->saved_syn + 1, len)) {
+			if (copy_to_user(optval, tp->saved_syn->data, len)) {
 				release_sock(sk);
 				return -EFAULT;
 			}
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 12fda8f27b08..eb0e32b2def9 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6557,13 +6557,13 @@ static void tcp_reqsk_record_syn(const struct soc=
k *sk,
 {
 	if (tcp_sk(sk)->save_syn) {
 		u32 len =3D skb_network_header_len(skb) + tcp_hdrlen(skb);
-		u32 *copy;
+		struct saved_syn *saved_syn;
=20
-		copy =3D kmalloc(len + sizeof(u32), GFP_ATOMIC);
-		if (copy) {
-			copy[0] =3D len;
-			memcpy(&copy[1], skb_network_header(skb), len);
-			req->saved_syn =3D copy;
+		saved_syn =3D kmalloc(len + sizeof(*saved_syn), GFP_ATOMIC);
+		if (saved_syn) {
+			saved_syn->network_hdrlen =3D skb_network_header_len(skb);
+			memcpy(saved_syn->data, skb_network_header(skb), len);
+			req->saved_syn =3D saved_syn;
 		}
 	}
 }
--=20
2.24.1

