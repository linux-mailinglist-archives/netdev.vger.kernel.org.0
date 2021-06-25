Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED9F3B499B
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhFYUHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:07:23 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31652 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhFYUHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:07:22 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PJxa2H012186
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iYGTfo9zw+Q2bdKpFAkgkKkC4nVVQRvhm8hS4gvCfxs=;
 b=GIgaRIdbMQ0wQRJeIqySn9vyXvXkeUwivMlYmoBj9vEcpMPmRtdTcdGmSIk1Kc6Yo3Fc
 IZ5aT63s/237ldAWQvAWBZ6EzqkBs0ZxPIz+JU8nxbyPz+QvzVfs/qHj/IvlqoyaFX5B
 bLH6y6/Z1QjJnuxnv9/usFCQeE32kxhIdhA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d24nxkqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:01 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:05:00 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id B7B3729422B0; Fri, 25 Jun 2021 13:04:58 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 2/8] tcp: seq_file: Refactor net and family matching
Date:   Fri, 25 Jun 2021 13:04:58 -0700
Message-ID: <20210625200458.724177-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: sRSSzPCpU158VtgKfmFcQQGoRu_KEdqd
X-Proofpoint-ORIG-GUID: sRSSzPCpU158VtgKfmFcQQGoRu_KEdqd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 adultscore=0 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106250122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch refactors the net and family matching into
two new helpers, seq_sk_match() and seq_file_family().

seq_file_family() is in the later part of the file to prepare
the change of a following patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_ipv4.c | 68 ++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7a49427eefbf..13a8b6e8d6bc 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2277,6 +2277,17 @@ EXPORT_SYMBOL(tcp_v4_destroy_sock);
 #ifdef CONFIG_PROC_FS
 /* Proc filesystem TCP sock list dumping. */
=20
+static unsigned short seq_file_family(const struct seq_file *seq);
+
+static bool seq_sk_match(struct seq_file *seq, const struct sock *sk)
+{
+	unsigned short family =3D seq_file_family(seq);
+
+	/* AF_UNSPEC is used as a match all */
+	return ((family =3D=3D AF_UNSPEC || family =3D=3D sk->sk_family) &&
+		net_eq(sock_net(sk), seq_file_net(seq)));
+}
+
 /*
  * Get next listener socket follow cur.  If cur is NULL, get first socke=
t
  * starting from bucket given in st->bucket; when st->bucket is zero the
@@ -2284,18 +2295,11 @@ EXPORT_SYMBOL(tcp_v4_destroy_sock);
  */
 static void *listening_get_next(struct seq_file *seq, void *cur)
 {
-	struct tcp_seq_afinfo *afinfo;
 	struct tcp_iter_state *st =3D seq->private;
-	struct net *net =3D seq_file_net(seq);
 	struct inet_listen_hashbucket *ilb;
 	struct hlist_nulls_node *node;
 	struct sock *sk =3D cur;
=20
-	if (st->bpf_seq_afinfo)
-		afinfo =3D st->bpf_seq_afinfo;
-	else
-		afinfo =3D PDE_DATA(file_inode(seq->file));
-
 	if (!sk) {
 get_head:
 		ilb =3D &tcp_hashinfo.listening_hash[st->bucket];
@@ -2311,10 +2315,7 @@ static void *listening_get_next(struct seq_file *s=
eq, void *cur)
 	sk =3D sk_nulls_next(sk);
 get_sk:
 	sk_nulls_for_each_from(sk, node) {
-		if (!net_eq(sock_net(sk), net))
-			continue;
-		if (afinfo->family =3D=3D AF_UNSPEC ||
-		    sk->sk_family =3D=3D afinfo->family)
+		if (seq_sk_match(seq, sk))
 			return sk;
 	}
 	spin_unlock(&ilb->lock);
@@ -2351,15 +2352,7 @@ static inline bool empty_bucket(const struct tcp_i=
ter_state *st)
  */
 static void *established_get_first(struct seq_file *seq)
 {
-	struct tcp_seq_afinfo *afinfo;
 	struct tcp_iter_state *st =3D seq->private;
-	struct net *net =3D seq_file_net(seq);
-	void *rc =3D NULL;
-
-	if (st->bpf_seq_afinfo)
-		afinfo =3D st->bpf_seq_afinfo;
-	else
-		afinfo =3D PDE_DATA(file_inode(seq->file));
=20
 	st->offset =3D 0;
 	for (; st->bucket <=3D tcp_hashinfo.ehash_mask; ++st->bucket) {
@@ -2373,32 +2366,20 @@ static void *established_get_first(struct seq_fil=
e *seq)
=20
 		spin_lock_bh(lock);
 		sk_nulls_for_each(sk, node, &tcp_hashinfo.ehash[st->bucket].chain) {
-			if ((afinfo->family !=3D AF_UNSPEC &&
-			     sk->sk_family !=3D afinfo->family) ||
-			    !net_eq(sock_net(sk), net)) {
-				continue;
-			}
-			rc =3D sk;
-			goto out;
+			if (seq_sk_match(seq, sk))
+				return sk;
 		}
 		spin_unlock_bh(lock);
 	}
-out:
-	return rc;
+
+	return NULL;
 }
=20
 static void *established_get_next(struct seq_file *seq, void *cur)
 {
-	struct tcp_seq_afinfo *afinfo;
 	struct sock *sk =3D cur;
 	struct hlist_nulls_node *node;
 	struct tcp_iter_state *st =3D seq->private;
-	struct net *net =3D seq_file_net(seq);
-
-	if (st->bpf_seq_afinfo)
-		afinfo =3D st->bpf_seq_afinfo;
-	else
-		afinfo =3D PDE_DATA(file_inode(seq->file));
=20
 	++st->num;
 	++st->offset;
@@ -2406,9 +2387,7 @@ static void *established_get_next(struct seq_file *=
seq, void *cur)
 	sk =3D sk_nulls_next(sk);
=20
 	sk_nulls_for_each_from(sk, node) {
-		if ((afinfo->family =3D=3D AF_UNSPEC ||
-		     sk->sk_family =3D=3D afinfo->family) &&
-		    net_eq(sock_net(sk), net))
+		if (seq_sk_match(seq, sk))
 			return sk;
 	}
=20
@@ -2754,6 +2733,19 @@ static const struct seq_operations bpf_iter_tcp_se=
q_ops =3D {
 	.stop		=3D bpf_iter_tcp_seq_stop,
 };
 #endif
+static unsigned short seq_file_family(const struct seq_file *seq)
+{
+	const struct tcp_iter_state *st =3D seq->private;
+	const struct tcp_seq_afinfo *afinfo =3D st->bpf_seq_afinfo;
+
+	/* Iterated from bpf_iter.  Let the bpf prog to filter instead. */
+	if (afinfo)
+		return AF_UNSPEC;
+
+	/* Iterated from proc fs */
+	afinfo =3D PDE_DATA(file_inode(seq->file));
+	return afinfo->family;
+}
=20
 static const struct seq_operations tcp4_seq_ops =3D {
 	.show		=3D tcp4_seq_show,
--=20
2.30.2

