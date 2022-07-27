Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B75581FEB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiG0GKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiG0GK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:10:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DE51035
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:25 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND3GB005118
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=L7/Ct8dJb4Le+DgrGi94W6ApfbmILzSfMfxX97vXqrM=;
 b=JhQx8Lfuwy/DcJ4IW6R/ApwLIkdzdQ5mcnnrRsdPmLDQn4Wiav87/2wFJ1LIlIt1xtMD
 8Li/cX1MCRMXU76CDAiH9O0XdrlDcb+IkXyGRknh8SBya6Zy6Ex/wi5DGanA1RHR5cgr
 +n9LNnMln7aNdzGUZpraVPTB+emHsLXOELY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxaw36v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:10:25 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:10:23 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 6F99C757CFB0; Tue, 26 Jul 2022 23:10:12 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 12/14] bpf: Change bpf_setsockopt(SOL_IPV6) to reuse do_ipv6_setsockopt()
Date:   Tue, 26 Jul 2022 23:10:12 -0700
Message-ID: <20220727061012.2380506-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: UUXVjjQpUp_EOqFCoUiSKz_QLw4_ufAe
X-Proofpoint-GUID: UUXVjjQpUp_EOqFCoUiSKz_QLw4_ufAe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the prep work in the previous patches,
this patch removes the dup code from bpf_setsockopt(SOL_IPV6)
and reuses the implementation in do_ipv6_setsockopt().

ipv6 could be compiled as a module.  Like how other codes solved it
with stubs in ipv6_stubs.h, this patch adds the do_ipv6_setsockopt
to the ipv6_bpf_stub.

The current bpf_setsockopt(IPV6_TCLASS) does not take the
INET_ECN_MASK into the account for tcp.  The
do_ipv6_setsockopt(IPV6_TCLASS) will handle it correctly.

The existing optname white-list is refactored into a new
function sol_ipv6_setsockopt().

After this last SOL_IPV6 dup code removal, the __bpf_setsockopt()
is simplified enough that the extra "{ }" around the if statement
can be removed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/net/ipv6.h       |  2 ++
 include/net/ipv6_stubs.h |  2 ++
 net/core/filter.c        | 57 +++++++++++++++++++---------------------
 net/ipv6/af_inet6.c      |  1 +
 net/ipv6/ipv6_sockglue.c |  4 +--
 5 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index de9dcc5652c4..c110d9032083 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1156,6 +1156,8 @@ struct in6_addr *fl6_update_dst(struct flowi6 *fl6,
  */
 DECLARE_STATIC_KEY_FALSE(ip6_min_hopcount);
=20
+int do_ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_=
t optval,
+		       unsigned int optlen);
 int ipv6_setsockopt(struct sock *sk, int level, int optname, sockptr_t o=
ptval,
 		    unsigned int optlen);
 int ipv6_getsockopt(struct sock *sk, int level, int optname,
diff --git a/include/net/ipv6_stubs.h b/include/net/ipv6_stubs.h
index 45e0339be6fa..8692698b01cf 100644
--- a/include/net/ipv6_stubs.h
+++ b/include/net/ipv6_stubs.h
@@ -81,6 +81,8 @@ struct ipv6_bpf_stub {
 				     const struct in6_addr *daddr, __be16 dport,
 				     int dif, int sdif, struct udp_table *tbl,
 				     struct sk_buff *skb);
+	int (*ipv6_setsockopt)(struct sock *sk, int level, int optname,
+			       sockptr_t optval, unsigned int optlen);
 };
 extern const struct ipv6_bpf_stub *ipv6_bpf_stub __read_mostly;
=20
diff --git a/net/core/filter.c b/net/core/filter.c
index 67c87d7acb23..7b510e009bb3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5142,45 +5142,42 @@ static int sol_ip_setsockopt(struct sock *sk, int=
 optname,
 				KERNEL_SOCKPTR_BPF(optval), optlen);
 }
=20
+static int sol_ipv6_setsockopt(struct sock *sk, int optname,
+			       char *optval, int optlen)
+{
+	if (sk->sk_family !=3D AF_INET6)
+		return -EINVAL;
+
+	switch (optname) {
+	case IPV6_TCLASS:
+		if (optlen !=3D sizeof(int))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ipv6_bpf_stub->ipv6_setsockopt(sk, SOL_IPV6, optname,
+					      KERNEL_SOCKPTR_BPF(optval),
+					      optlen);
+}
+
 static int __bpf_setsockopt(struct sock *sk, int level, int optname,
 			    char *optval, int optlen)
 {
-	int val, ret =3D 0;
-
 	if (!sk_fullsock(sk))
 		return -EINVAL;
=20
-	if (level =3D=3D SOL_SOCKET) {
+	if (level =3D=3D SOL_SOCKET)
 		return sol_socket_setsockopt(sk, optname, optval, optlen);
-	} else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_IP) {
+	else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_IP)
 		return sol_ip_setsockopt(sk, optname, optval, optlen);
-	} else if (IS_ENABLED(CONFIG_IPV6) && level =3D=3D SOL_IPV6) {
-		if (optlen !=3D sizeof(int) || sk->sk_family !=3D AF_INET6)
-			return -EINVAL;
-
-		val =3D *((int *)optval);
-		/* Only some options are supported */
-		switch (optname) {
-		case IPV6_TCLASS:
-			if (val < -1 || val > 0xff) {
-				ret =3D -EINVAL;
-			} else {
-				struct ipv6_pinfo *np =3D inet6_sk(sk);
-
-				if (val =3D=3D -1)
-					val =3D 0;
-				np->tclass =3D val;
-			}
-			break;
-		default:
-			ret =3D -EINVAL;
-		}
-	} else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP) {
+	else if (IS_ENABLED(CONFIG_IPV6) && level =3D=3D SOL_IPV6)
+		return sol_ipv6_setsockopt(sk, optname, optval, optlen);
+	else if (IS_ENABLED(CONFIG_INET) && level =3D=3D SOL_TCP)
 		return sol_tcp_setsockopt(sk, optname, optval, optlen);
-	} else {
-		ret =3D -EINVAL;
-	}
-	return ret;
+
+	return -EINVAL;
 }
=20
 static int _bpf_setsockopt(struct sock *sk, int level, int optname,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2ce0c44d0081..cadc97852787 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1057,6 +1057,7 @@ static const struct ipv6_stub ipv6_stub_impl =3D {
 static const struct ipv6_bpf_stub ipv6_bpf_stub_impl =3D {
 	.inet6_bind =3D __inet6_bind,
 	.udp6_lib_lookup =3D __udp6_lib_lookup,
+	.ipv6_setsockopt =3D do_ipv6_setsockopt,
 };
=20
 static int __init inet6_init(void)
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 4559f02ab4a8..0eef5a11dc3c 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -391,8 +391,8 @@ static int ipv6_set_opt_hdr(struct sock *sk, int optn=
ame, sockptr_t optval,
 	return err;
 }
=20
-static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
-		   sockptr_t optval, unsigned int optlen)
+int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
+		       sockptr_t optval, unsigned int optlen)
 {
 	struct ipv6_pinfo *np =3D inet6_sk(sk);
 	struct net *net =3D sock_net(sk);
--=20
2.30.2

