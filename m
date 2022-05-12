Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9DD52415C
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349551AbiELAGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349558AbiELAF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:05:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FF4205EF
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:57 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwbse026711
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8DvZwCD47P0Qi9dwQiXwCoMFs6VuITL1ENBPqyHRdMw=;
 b=WuH4tmkAu1NxypEMN3Whk3EigBnAEj0kIdhOCe1R++kpEO6tmIrpTQ8IGUJZkL5Jho2z
 5UfG8zsJ7FEXmnWUkUcLghQ7ybeP2o+wMkFQ0f53EUgvfFqpSptxmKLi3JpWbXFE0d3u
 kFK4Hbg9+CWCxA4kq9j0YLzRMKEU0fHZPng= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g054exxew-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:56 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:05:54 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 883224AD2442; Wed, 11 May 2022 17:05:52 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/4] net: inet: Remove count from inet_listen_hashbucket
Date:   Wed, 11 May 2022 17:05:52 -0700
Message-ID: <20220512000552.189036-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220512000546.188616-1-kafai@fb.com>
References: <20220512000546.188616-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: LquILhkwatOI6Bx1ICk4OvY5quJplq8G
X-Proofpoint-GUID: LquILhkwatOI6Bx1ICk4OvY5quJplq8G
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

After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an addre=
ss")
and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"=
),
the count is no longer used.  This patch removes it.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/inet_hashtables.h | 1 -
 net/ipv4/inet_hashtables.c    | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.=
h
index 98e1ec1a14f0..103fc7a30e60 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -111,7 +111,6 @@ struct inet_bind_hashbucket {
 #define LISTENING_NULLS_BASE (1U << 29)
 struct inet_listen_hashbucket {
 	spinlock_t		lock;
-	unsigned int		count;
 	union {
 		struct hlist_head	head;
 		struct hlist_nulls_head	nulls_head;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index a5d57fa679ca..968b15cc0a18 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -209,7 +209,6 @@ static void inet_hash2(struct inet_hashinfo *h, struc=
t sock *sk)
 	else
 		hlist_add_head_rcu(&inet_csk(sk)->icsk_listen_portaddr_node,
 				   &ilb2->head);
-	ilb2->count++;
 	spin_unlock(&ilb2->lock);
 }
=20
@@ -225,7 +224,6 @@ static void inet_unhash2(struct inet_hashinfo *h, str=
uct sock *sk)
=20
 	spin_lock(&ilb2->lock);
 	hlist_del_init_rcu(&inet_csk(sk)->icsk_listen_portaddr_node);
-	ilb2->count--;
 	spin_unlock(&ilb2->lock);
 }
=20
@@ -657,7 +655,6 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	else
 		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	inet_hash2(hashinfo, sk);
-	ilb->count++;
 	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
@@ -689,7 +686,6 @@ static void __inet_unhash(struct sock *sk, struct ine=
t_listen_hashbucket *ilb)
 		struct inet_hashinfo *hashinfo =3D sk->sk_prot->h.hashinfo;
=20
 		inet_unhash2(hashinfo, sk);
-		ilb->count--;
 	}
 	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
@@ -882,7 +878,6 @@ void inet_hashinfo_init(struct inet_hashinfo *h)
 		spin_lock_init(&h->listening_hash[i].lock);
 		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
 				      i + LISTENING_NULLS_BASE);
-		h->listening_hash[i].count =3D 0;
 	}
=20
 	h->lhash2 =3D NULL;
@@ -896,7 +891,6 @@ static void init_hashinfo_lhash2(struct inet_hashinfo=
 *h)
 	for (i =3D 0; i <=3D h->lhash2_mask; i++) {
 		spin_lock_init(&h->lhash2[i].lock);
 		INIT_HLIST_HEAD(&h->lhash2[i].head);
-		h->lhash2[i].count =3D 0;
 	}
 }
=20
--=20
2.30.2

