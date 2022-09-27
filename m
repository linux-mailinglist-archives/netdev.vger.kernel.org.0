Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80E85EB63E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiI0A0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiI0AZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:25:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3062E9C8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:25:56 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28QKCeIX009830
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:25:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=0axA60q8uks+GoYmmcfTjrZagQVRfRn+7Kvswkch9HA=;
 b=BAGNs+Em5ECrAd3pjXPTRQYvTzMYsd7f5f0z158ZmIIALDzh1afElXQI+L8SdvCRsrW8
 Ru5pjL7CQoWCh9uLAe2HRI89zrctZCsS0wMdw29V23dARt55TanYU4ylQVsIoTjNrk0S
 0M2c5erHt6+VAQmiWEkSEcSXXuMf/Qw8twk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3jswjuqknq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:25:55 -0700
Received: from twshared10425.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 17:25:55 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 79CDC9C0E928; Mon, 26 Sep 2022 17:25:44 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH net-next] net: Fix incorrect address comparison when searching for a bind2 bucket
Date:   Mon, 26 Sep 2022 17:25:44 -0700
Message-ID: <20220927002544.3381205-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: NhzuqZMuL1-lGl9v9Y3DW2KNjSVaEIma
X-Proofpoint-ORIG-GUID: NhzuqZMuL1-lGl9v9Y3DW2KNjSVaEIma
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_11,2022-09-22_02,2022-06-22_01
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

The v6_rcv_saddr and rcv_saddr are inside a union in the
'struct inet_bind2_bucket'.  When searching a bucket by following the
bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only using
the sk->sk_family and there is no way to check if the inet_bind2_bucket
has a v6 or v4 address in the union.  This leads to an uninit-value
KMSAN report in [0] and also potentially incorrect matches.

This patch fixes it by adding a family member to the inet_bind2_bucket
and then tests 'sk->sk_family !=3D tb->family' before matching
the sk's address to the tb's address.

Cc: Joanne Koong <joannelkoong@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Fixes: 28044fc1d495 ("net: Add a bhash2 table hashed by port and address"=
)
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 include/net/inet_hashtables.h |  3 +++
 net/ipv4/inet_hashtables.c    | 10 ++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.=
h
index 9121ccab1fa1..3af1e927247d 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -95,6 +95,9 @@ struct inet_bind2_bucket {
 	possible_net_t		ib_net;
 	int			l3mdev;
 	unsigned short		port;
+#if IS_ENABLED(CONFIG_IPV6)
+	unsigned short		family;
+#endif
 	union {
 #if IS_ENABLED(CONFIG_IPV6)
 		struct in6_addr		v6_rcv_saddr;
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 74e64aad5114..49db8c597eea 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -109,6 +109,7 @@ static void inet_bind2_bucket_init(struct inet_bind2_=
bucket *tb,
 	tb->l3mdev    =3D l3mdev;
 	tb->port      =3D port;
 #if IS_ENABLED(CONFIG_IPV6)
+	tb->family    =3D sk->sk_family;
 	if (sk->sk_family =3D=3D AF_INET6)
 		tb->v6_rcv_saddr =3D sk->sk_v6_rcv_saddr;
 	else
@@ -146,6 +147,9 @@ static bool inet_bind2_bucket_addr_match(const struct=
 inet_bind2_bucket *tb2,
 					 const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family !=3D tb2->family)
+		return false;
+
 	if (sk->sk_family =3D=3D AF_INET6)
 		return ipv6_addr_equal(&tb2->v6_rcv_saddr,
 				       &sk->sk_v6_rcv_saddr);
@@ -791,6 +795,9 @@ static bool inet_bind2_bucket_match(const struct inet=
_bind2_bucket *tb,
 				    int l3mdev, const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family !=3D tb->family)
+		return false;
+
 	if (sk->sk_family =3D=3D AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
 			tb->l3mdev =3D=3D l3mdev &&
@@ -807,6 +814,9 @@ bool inet_bind2_bucket_match_addr_any(const struct in=
et_bind2_bucket *tb, const
 #if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr addr_any =3D {};
=20
+	if (sk->sk_family !=3D tb->family)
+		return false;
+
 	if (sk->sk_family =3D=3D AF_INET6)
 		return net_eq(ib2_net(tb), net) && tb->port =3D=3D port &&
 			tb->l3mdev =3D=3D l3mdev &&
--=20
2.30.2

