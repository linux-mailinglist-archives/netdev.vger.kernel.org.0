Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415CB2CC7CF
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgLBUaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:30:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21658 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727322AbgLBUaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:30:13 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2KQEDj018586
        for <netdev@vger.kernel.org>; Wed, 2 Dec 2020 12:29:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=W3GQAXkNMOJjt+UqiahczCK20QLfWZ0GL0Q3KN8ePVg=;
 b=XuPUEPxsGSFjwSYEWcs/oC08SKxhR77fUFFQ5bw/eG7nr745zuRrtpXDlEuphVmchSUb
 frIYZ6TZIQX+LAGB8ETdslVrrpFnN6aBjGaMLepWfvTeXALZwHEObNb1KHXXeKinFZsG
 36IwGAOu5eqpt6xmRIDfenG3/NzCHMt81q4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355wgw7e0b-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:29:33 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 12:29:31 -0800
Received: by devvm3178.ftw3.facebook.com (Postfix, from userid 201728)
        id 43FE94762F194; Wed,  2 Dec 2020 12:29:26 -0800 (PST)
From:   Prankur gupta <prankgup@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 1/2] bpf: Adds support for setting window clamp
Date:   Wed, 2 Dec 2020 12:29:24 -0800
Message-ID: <20201202202925.165803-2-prankgup@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202202925.165803-1-prankgup@fb.com>
References: <20201202202925.165803-1-prankgup@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_12:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 impostorscore=0 mlxlogscore=981 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=13 priorityscore=1501 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a new bpf_setsockopt for TCP sockets, TCP_BPF_WINDOW_CLAMP,
which sets the maximum receiver window size. It will be useful for
limiting receiver window based on RTT.

Signed-off-by: Prankur gupta <prankgup@fb.com>
---
 include/net/tcp.h |  1 +
 net/core/filter.c |  3 +++
 net/ipv4/tcp.c    | 23 ++++++++++++++---------
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 4aba0f069b05..39ced5882fe3 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -406,6 +406,7 @@ void tcp_syn_ack_timeout(const struct request_sock *r=
eq);
 int tcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int non=
block,
 		int flags, int *addr_len);
 int tcp_set_rcvlowat(struct sock *sk, int val);
+int tcp_set_window_clamp(struct sock *sk, struct tcp_sock *tp, int val);
 void tcp_data_ready(struct sock *sk);
 #ifdef CONFIG_MMU
 int tcp_mmap(struct file *file, struct socket *sock,
diff --git a/net/core/filter.c b/net/core/filter.c
index 2ca5eecebacf..d6225842cfb1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4910,6 +4910,9 @@ static int _bpf_setsockopt(struct sock *sk, int lev=
el, int optname,
 				tp->notsent_lowat =3D val;
 				sk->sk_write_space(sk);
 				break;
+			case TCP_WINDOW_CLAMP:
+				ret =3D tcp_set_window_clamp(sk, tp, val);
+				break;
 			default:
 				ret =3D -EINVAL;
 			}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b2bc3d7fe9e8..312feb8fcae5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3022,6 +3022,19 @@ int tcp_sock_set_keepcnt(struct sock *sk, int val)
 }
 EXPORT_SYMBOL(tcp_sock_set_keepcnt);
=20
+int tcp_set_window_clamp(struct sock *sk, struct tcp_sock *tp, int val)
+{
+	if (!val) {
+		if (sk->sk_state !=3D TCP_CLOSE)
+			return -EINVAL;
+		tp->window_clamp =3D 0;
+	} else {
+		tp->window_clamp =3D val < SOCK_MIN_RCVBUF / 2 ?
+			SOCK_MIN_RCVBUF / 2 : val;
+	}
+	return 0;
+}
+
 /*
  *	Socket option code for TCP.
  */
@@ -3235,15 +3248,7 @@ static int do_tcp_setsockopt(struct sock *sk, int =
level, int optname,
 		break;
=20
 	case TCP_WINDOW_CLAMP:
-		if (!val) {
-			if (sk->sk_state !=3D TCP_CLOSE) {
-				err =3D -EINVAL;
-				break;
-			}
-			tp->window_clamp =3D 0;
-		} else
-			tp->window_clamp =3D val < SOCK_MIN_RCVBUF / 2 ?
-						SOCK_MIN_RCVBUF / 2 : val;
+		err =3D tcp_set_window_clamp(sk, tp, val);
 		break;
=20
 	case TCP_QUICKACK:
--=20
2.24.1

