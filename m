Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80043B499F
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 22:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhFYUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 16:07:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14312 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229831AbhFYUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 16:07:42 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15PJxHrA022848
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=D5gYKZmeoLvbMoqCkGct6o7H9L2LBkqzP4GWz9cx/MM=;
 b=nRJWp1X0KVtVDHVTqtuKEA0m84H0FNChMuAeINpZrx2Fw2K2Fi7K2m22Tcw5Qu65/vAc
 B2eHQQjYLAm4ZToGZRxGnsTPniaz3jQJh5gSrbSiMzL6c+OY7fd5kKE6VtoJBFU0COMb
 ZpXpv1m7spLTZaKOL1jEQh2snN4bi8fvVew= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39d23kequb-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 13:05:21 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 13:05:19 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 4048029422B0; Fri, 25 Jun 2021 13:05:11 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH bpf-next 4/8] tcp: seq_file: Add listening_get_first()
Date:   Fri, 25 Jun 2021 13:05:11 -0700
Message-ID: <20210625200511.726185-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625200446.723230-1-kafai@fb.com>
References: <20210625200446.723230-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 0cK7lT6QqjkaetdPgjklt5w9D08-nV6j
X-Proofpoint-ORIG-GUID: 0cK7lT6QqjkaetdPgjklt5w9D08-nV6j
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-25_07:2021-06-25,2021-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=933
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 mlxscore=0
 adultscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106250122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current listening_get_next() is overloaded by passing
NULL to the 2nd arg, like listening_get_next(seq, NULL), to
mean get_first().

This patch moves some logic from the listening_get_next() into
a new function listening_get_first().  It will be equivalent
to the current established_get_first() and established_get_next()
setup.  get_first() is to find a non empty bucket and return
the first sk.  get_next() is to find the next sk of the current
bucket and then resorts to get_first() if the current bucket is
exhausted.

The next patch is to move the listener seq_file iteration from
listening_hash (port only) to lhash2 (port+addr).
Separating out listening_get_first() from listening_get_next()
here will make the following lhash2 changes cleaner and easier to
follow.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp_ipv4.c | 59 ++++++++++++++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index ca55e87f6cc9..693bda155876 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2288,10 +2288,38 @@ static bool seq_sk_match(struct seq_file *seq, co=
nst struct sock *sk)
 		net_eq(sock_net(sk), seq_file_net(seq)));
 }
=20
-/*
- * Get next listener socket follow cur.  If cur is NULL, get first socke=
t
- * starting from bucket given in st->bucket; when st->bucket is zero the
- * very first socket in the hash table is returned.
+/* Find a non empty bucket (starting from st->bucket)
+ * and return the first sk from it.
+ */
+static void *listening_get_first(struct seq_file *seq)
+{
+	struct tcp_iter_state *st =3D seq->private;
+
+	st->offset =3D 0;
+	for (; st->bucket < INET_LHTABLE_SIZE; st->bucket++) {
+		struct inet_listen_hashbucket *ilb;
+		struct hlist_nulls_node *node;
+		struct sock *sk;
+
+		ilb =3D &tcp_hashinfo.listening_hash[st->bucket];
+		if (hlist_nulls_empty(&ilb->nulls_head))
+			continue;
+
+		spin_lock(&ilb->lock);
+		sk_nulls_for_each(sk, node, &ilb->nulls_head) {
+			if (seq_sk_match(seq, sk))
+				return sk;
+		}
+		spin_unlock(&ilb->lock);
+	}
+
+	return NULL;
+}
+
+/* Find the next sk of "cur" within the same bucket (i.e. st->bucket).
+ * If "cur" is the last one in the st->bucket,
+ * call listening_get_first() to return the first sk of the next
+ * non empty bucket.
  */
 static void *listening_get_next(struct seq_file *seq, void *cur)
 {
@@ -2300,29 +2328,20 @@ static void *listening_get_next(struct seq_file *=
seq, void *cur)
 	struct hlist_nulls_node *node;
 	struct sock *sk =3D cur;
=20
-	if (!sk) {
-get_head:
-		ilb =3D &tcp_hashinfo.listening_hash[st->bucket];
-		spin_lock(&ilb->lock);
-		sk =3D sk_nulls_head(&ilb->nulls_head);
-		st->offset =3D 0;
-		goto get_sk;
-	}
-	ilb =3D &tcp_hashinfo.listening_hash[st->bucket];
 	++st->num;
 	++st->offset;
=20
 	sk =3D sk_nulls_next(sk);
-get_sk:
+
 	sk_nulls_for_each_from(sk, node) {
 		if (seq_sk_match(seq, sk))
 			return sk;
 	}
+
+	ilb =3D &tcp_hashinfo.listening_hash[st->bucket];
 	spin_unlock(&ilb->lock);
-	st->offset =3D 0;
-	if (++st->bucket < INET_LHTABLE_SIZE)
-		goto get_head;
-	return NULL;
+	++st->bucket;
+	return listening_get_first(seq);
 }
=20
 static void *listening_get_idx(struct seq_file *seq, loff_t *pos)
@@ -2332,7 +2351,7 @@ static void *listening_get_idx(struct seq_file *seq=
, loff_t *pos)
=20
 	st->bucket =3D 0;
 	st->offset =3D 0;
-	rc =3D listening_get_next(seq, NULL);
+	rc =3D listening_get_first(seq);
=20
 	while (rc && *pos) {
 		rc =3D listening_get_next(seq, rc);
@@ -2440,7 +2459,7 @@ static void *tcp_seek_last_pos(struct seq_file *seq=
)
 		if (st->bucket >=3D INET_LHTABLE_SIZE)
 			break;
 		st->state =3D TCP_SEQ_STATE_LISTENING;
-		rc =3D listening_get_next(seq, NULL);
+		rc =3D listening_get_first(seq);
 		while (offset-- && rc && bucket =3D=3D st->bucket)
 			rc =3D listening_get_next(seq, rc);
 		if (rc)
--=20
2.30.2

