Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5A152415F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349584AbiELAGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349552AbiELAGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:06:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDF722526
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:03 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwcF4026802
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=S6DG+/zvGub2XdMc11RTfMLwOYMjX/NagI+AZx/ajcE=;
 b=pGcqqK7fSa9+yE5w9ab/FqLKve7Hs7MQHv/Tn1ZiP67aSKqw+0/VKO2Kk0GQCrDl0gUL
 dJ8DfIQIdhw5rrPD3e5LybRsZ0J2Qtq1EsbOqf3jsXccEx/3RzAs4NFJcRPPefD/SQbw
 ALl/BSQfUOElr5rOqU+82dYnXfXOhmGAokU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g054exxf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:06:03 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub202.TheFacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:06:02 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:06:02 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id D17CF4AD2470; Wed, 11 May 2022 17:05:58 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/4] net: inet: Open code inet_hash2 and inet_unhash2
Date:   Wed, 11 May 2022 17:05:58 -0700
Message-ID: <20220512000558.189457-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
References: <20220512000546.188616-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: -RwLhwHCEabzQtspBREoysWAlQCgPVXm
X-Proofpoint-GUID: -RwLhwHCEabzQtspBREoysWAlQCgPVXm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch folds lhash2 related functions into __inet_hash and
inet_unhash.  This will make the removal of the listening_hash
in a latter patch easier to review.

First, this patch folds inet_hash2 into __inet_hash.

For unhash, the current call sequence is like
inet_unhash() =3D> __inet_unhash() =3D> inet_unhash2().
The specific testing cases in __inet_unhash() are mostly related
to TCP_LISTEN sk and its caller inet_unhash() already has
the TCP_LISTEN test, so this patch folds both __inet_unhash() and
inet_unhash2() into inet_unhash().

Note that all listening_hash users also have lhash2 initialized,
so the !h->lhash2 check is no longer needed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/inet_hashtables.c | 88 ++++++++++++++------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 968b15cc0a18..4b00fcb9088d 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -193,40 +193,6 @@ inet_lhash2_bucket_sk(struct inet_hashinfo *h, struc=
t sock *sk)
 	return inet_lhash2_bucket(h, hash);
 }
=20
-static void inet_hash2(struct inet_hashinfo *h, struct sock *sk)
-{
-	struct inet_listen_hashbucket *ilb2;
-
-	if (!h->lhash2)
-		return;
-
-	ilb2 =3D inet_lhash2_bucket_sk(h, sk);
-
-	spin_lock(&ilb2->lock);
-	if (sk->sk_reuseport && sk->sk_family =3D=3D AF_INET6)
-		hlist_add_tail_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
-				   &ilb2->head);
-	else
-		hlist_add_head_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
-				   &ilb2->head);
-	spin_unlock(&ilb2->lock);
-}
-
-static void inet_unhash2(struct inet_hashinfo *h, struct sock *sk)
-{
-	struct inet_listen_hashbucket *ilb2;
-
-	if (!h->lhash2 ||
-	    WARN_ON_ONCE(hlist_unhashed(&inet_csk(sk)->icsk_listen_portaddr_nod=
e)))
-		return;
-
-	ilb2 =3D inet_lhash2_bucket_sk(h, sk);
-
-	spin_lock(&ilb2->lock);
-	hlist_del_init_rcu(&inet_csk(sk)->icsk_listen_portaddr_node);
-	spin_unlock(&ilb2->lock);
-}
-
 static inline int compute_score(struct sock *sk, struct net *net,
 				const unsigned short hnum, const __be32 daddr,
 				const int dif, const int sdif)
@@ -631,6 +597,7 @@ static int inet_reuseport_add_sock(struct sock *sk,
 int __inet_hash(struct sock *sk, struct sock *osk)
 {
 	struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
+	struct inet_listen_hashbucket *ilb2;
 	struct inet_listen_hashbucket *ilb;
 	int err =3D 0;
=20
@@ -642,22 +609,29 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	}
 	WARN_ON(!sk_unhashed(sk));
 	ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
+	ilb2 =3D inet_lhash2_bucket_sk(hashinfo, sk);
=20
 	spin_lock(&ilb->lock);
+	spin_lock(&ilb2->lock);
 	if (sk->sk_reuseport) {
 		err =3D inet_reuseport_add_sock(sk, ilb);
 		if (err)
 			goto unlock;
 	}
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
-		sk->sk_family =3D=3D AF_INET6)
+		sk->sk_family =3D=3D AF_INET6) {
+		hlist_add_tail_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
+				   &ilb2->head);
 		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
-	else
+	} else {
+		hlist_add_head_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
+				   &ilb2->head);
 		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
-	inet_hash2(hashinfo, sk);
+	}
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
+	spin_unlock(&ilb2->lock);
 	spin_unlock(&ilb->lock);
=20
 	return err;
@@ -675,22 +649,6 @@ int inet_hash(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_hash);
=20
-static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket=
 *ilb)
-{
-	if (sk_unhashed(sk))
-		return;
-
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_stop_listen_sock(sk);
-	if (ilb) {
-		struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
-
-		inet_unhash2(hashinfo, sk);
-	}
-	__sk_nulls_del_node_init_rcu(sk);
-	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-}
-
 void inet_unhash(struct sock *sk)
 {
 	struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
@@ -699,20 +657,40 @@ void inet_unhash(struct sock *sk)
 		return;
=20
 	if (sk->sk_state =3D=3D TCP_LISTEN) {
+		struct inet_listen_hashbucket *ilb2;
 		struct inet_listen_hashbucket *ilb;
=20
 		ilb =3D &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
+		ilb2 =3D inet_lhash2_bucket_sk(hashinfo, sk);
 		/* Don't disable bottom halves while acquiring the lock to
 		 * avoid circular locking dependency on PREEMPT_RT.
 		 */
 		spin_lock(&ilb->lock);
-		__inet_unhash(sk, ilb);
+		spin_lock(&ilb2->lock);
+		if (sk_unhashed(sk)) {
+			spin_unlock(&ilb2->lock);
+			spin_unlock(&ilb->lock);
+			return;
+		}
+
+		if (rcu_access_pointer(sk->sk_reuseport_cb))
+			reuseport_stop_listen_sock(sk);
+
+		hlist_del_init_rcu(&inet_csk(sk)->icsk_listen_portaddr_node);
+		__sk_nulls_del_node_init_rcu(sk);
+		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+		spin_unlock(&ilb2->lock);
 		spin_unlock(&ilb->lock);
 	} else {
 		spinlock_t *lock =3D inet_ehash_lockp(hashinfo, sk->sk_hash);
=20
 		spin_lock_bh(lock);
-		__inet_unhash(sk, NULL);
+		if (sk_unhashed(sk)) {
+			spin_unlock_bh(lock);
+			return;
+		}
+		__sk_nulls_del_node_init_rcu(sk);
+		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
 		spin_unlock_bh(lock);
 	}
 }
--=20
2.30.2

