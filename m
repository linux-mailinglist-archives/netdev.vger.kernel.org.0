Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA201D8C0A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbgESANl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:13:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14808 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726280AbgESANk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:13:40 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04J09p42019079
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:13:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=R2SujLApZrrkPidFcSGRy1xMN8iFCiNxBROqersIi/E=;
 b=ptgI5c7nZTbFD/PHtCxObeB9QLA92qaHlRuZ1NFx764ImVyf9xAsfuhwY7Z9r5XAhYJm
 WPfTQ4F/4Al6bkmYHpKI/Y4jEb/XkNxUu7ytBFRtC1YEtrlbnxAa+n00XFz2X0OEdfwc
 njyXp/kW4aPKNaJsRmiD+VDZxMFYw+XVF9k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 312dpx8hgv-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:13:39 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 18 May 2020 17:13:39 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id ADCC929451D8; Mon, 18 May 2020 17:13:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Josef Bacik <jbacik@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH net] net: inet_csk: Fix so_reuseport bind-address cache in tb->fast*
Date:   Mon, 18 May 2020 17:13:34 -0700
Message-ID: <20200519001334.1584343-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-18_06:2020-05-15,2020-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 impostorscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=1 bulkscore=0 priorityscore=1501
 cotscore=-2147483648 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005190000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reu=
seport sk")
added a bind-address cache in tb->fast*.  The tb->fast* caches the addres=
s
of a sk which has successfully been binded with SO_REUSEPORT ON.  The ide=
a
is to avoid the expensive conflict search in inet_csk_bind_conflict().

There is an issue with wildcard matching where sk_reuseport_match() shoul=
d
have returned false but it is currently returning true.  It ends up
hiding bind conflict.  For example,

bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
bind("[::2]:443"); /* with    SO_REUSEPORT. Succeed. */
bind("[::]:443");  /* with    SO_REUSEPORT. Still Succeed where it should=
n't */

The last bind("[::]:443") with SO_REUSEPORT on should have failed because
it should have a conflict with the very first bind("[::1]:443") which
has SO_REUSEPORT off.  However, the address "[::2]" is cached in
tb->fast* in the second bind. In the last bind, the sk_reuseport_match()
returns true because the binding sk's wildcard addr "[::]" matches with
the "[::2]" cached in tb->fast*.

The correct bind conflict is reported by removing the second
bind such that tb->fast* cache is not involved and forces the
bind("[::]:443") to go through the inet_csk_bind_conflict():

bind("[::1]:443"); /* without SO_REUSEPORT. Succeed. */
bind("[::]:443");  /* with    SO_REUSEPORT. -EADDRINUSE */

The expected behavior for sk_reuseport_match() is, it should only allow
the "cached" tb->fast* address to be used as a wildcard match but not
the address of the binding sk.  To do that, the current
"bool match_wildcard" arg is split into
"bool match_sk1_wildcard" and "bool match_sk2_wildcard".

This change only affects the sk_reuseport_match() which is only
used by inet_csk (e.g. TCP).
The other use cases are calling inet_rcv_saddr_equal() and
this patch makes it pass the same "match_wildcard" arg twice to
the "ipv[46]_rcv_saddr_equal(..., match_wildcard, match_wildcard)".

Cc: Josef Bacik <jbacik@fb.com>
Fixes: 637bc8bbe6c0 ("inet: reset tb->fastreuseport when adding a reusepo=
rt sk")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/inet_connection_sock.c | 43 ++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_s=
ock.c
index 5f34eb951627..65c29f2bd89f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -24,17 +24,19 @@
 #include <net/addrconf.h>
=20
 #if IS_ENABLED(CONFIG_IPV6)
-/* match_wildcard =3D=3D true:  IPV6_ADDR_ANY equals to any IPv6 address=
es if IPv6
- *                          only, and any IPv4 addresses if not IPv6 onl=
y
- * match_wildcard =3D=3D false: addresses must be exactly the same, i.e.
- *                          IPV6_ADDR_ANY only equals to IPV6_ADDR_ANY,
- *                          and 0.0.0.0 equals to 0.0.0.0 only
+/* match_sk*_wildcard =3D=3D true:  IPV6_ADDR_ANY equals to any IPv6 add=
resses
+ *				if IPv6 only, and any IPv4 addresses
+ *				if not IPv6 only
+ * match_sk*_wildcard =3D=3D false: addresses must be exactly the same, =
i.e.
+ *				IPV6_ADDR_ANY only equals to IPV6_ADDR_ANY,
+ *				and 0.0.0.0 equals to 0.0.0.0 only
  */
 static bool ipv6_rcv_saddr_equal(const struct in6_addr *sk1_rcv_saddr6,
 				 const struct in6_addr *sk2_rcv_saddr6,
 				 __be32 sk1_rcv_saddr, __be32 sk2_rcv_saddr,
 				 bool sk1_ipv6only, bool sk2_ipv6only,
-				 bool match_wildcard)
+				 bool match_sk1_wildcard,
+				 bool match_sk2_wildcard)
 {
 	int addr_type =3D ipv6_addr_type(sk1_rcv_saddr6);
 	int addr_type2 =3D sk2_rcv_saddr6 ? ipv6_addr_type(sk2_rcv_saddr6) : IP=
V6_ADDR_MAPPED;
@@ -44,8 +46,8 @@ static bool ipv6_rcv_saddr_equal(const struct in6_addr =
*sk1_rcv_saddr6,
 		if (!sk2_ipv6only) {
 			if (sk1_rcv_saddr =3D=3D sk2_rcv_saddr)
 				return true;
-			if (!sk1_rcv_saddr || !sk2_rcv_saddr)
-				return match_wildcard;
+			return (match_sk1_wildcard && !sk1_rcv_saddr) ||
+				(match_sk2_wildcard && !sk2_rcv_saddr);
 		}
 		return false;
 	}
@@ -53,11 +55,11 @@ static bool ipv6_rcv_saddr_equal(const struct in6_add=
r *sk1_rcv_saddr6,
 	if (addr_type =3D=3D IPV6_ADDR_ANY && addr_type2 =3D=3D IPV6_ADDR_ANY)
 		return true;
=20
-	if (addr_type2 =3D=3D IPV6_ADDR_ANY && match_wildcard &&
+	if (addr_type2 =3D=3D IPV6_ADDR_ANY && match_sk2_wildcard &&
 	    !(sk2_ipv6only && addr_type =3D=3D IPV6_ADDR_MAPPED))
 		return true;
=20
-	if (addr_type =3D=3D IPV6_ADDR_ANY && match_wildcard &&
+	if (addr_type =3D=3D IPV6_ADDR_ANY && match_sk1_wildcard &&
 	    !(sk1_ipv6only && addr_type2 =3D=3D IPV6_ADDR_MAPPED))
 		return true;
=20
@@ -69,18 +71,19 @@ static bool ipv6_rcv_saddr_equal(const struct in6_add=
r *sk1_rcv_saddr6,
 }
 #endif
=20
-/* match_wildcard =3D=3D true:  0.0.0.0 equals to any IPv4 addresses
- * match_wildcard =3D=3D false: addresses must be exactly the same, i.e.
- *                          0.0.0.0 only equals to 0.0.0.0
+/* match_sk*_wildcard =3D=3D true:  0.0.0.0 equals to any IPv4 addresses
+ * match_sk*_wildcard =3D=3D false: addresses must be exactly the same, =
i.e.
+ *				0.0.0.0 only equals to 0.0.0.0
  */
 static bool ipv4_rcv_saddr_equal(__be32 sk1_rcv_saddr, __be32 sk2_rcv_sa=
ddr,
-				 bool sk2_ipv6only, bool match_wildcard)
+				 bool sk2_ipv6only, bool match_sk1_wildcard,
+				 bool match_sk2_wildcard)
 {
 	if (!sk2_ipv6only) {
 		if (sk1_rcv_saddr =3D=3D sk2_rcv_saddr)
 			return true;
-		if (!sk1_rcv_saddr || !sk2_rcv_saddr)
-			return match_wildcard;
+		return (match_sk1_wildcard && !sk1_rcv_saddr) ||
+			(match_sk2_wildcard && !sk2_rcv_saddr);
 	}
 	return false;
 }
@@ -96,10 +99,12 @@ bool inet_rcv_saddr_equal(const struct sock *sk, cons=
t struct sock *sk2,
 					    sk2->sk_rcv_saddr,
 					    ipv6_only_sock(sk),
 					    ipv6_only_sock(sk2),
+					    match_wildcard,
 					    match_wildcard);
 #endif
 	return ipv4_rcv_saddr_equal(sk->sk_rcv_saddr, sk2->sk_rcv_saddr,
-				    ipv6_only_sock(sk2), match_wildcard);
+				    ipv6_only_sock(sk2), match_wildcard,
+				    match_wildcard);
 }
 EXPORT_SYMBOL(inet_rcv_saddr_equal);
=20
@@ -285,10 +290,10 @@ static inline int sk_reuseport_match(struct inet_bi=
nd_bucket *tb,
 					    tb->fast_rcv_saddr,
 					    sk->sk_rcv_saddr,
 					    tb->fast_ipv6_only,
-					    ipv6_only_sock(sk), true);
+					    ipv6_only_sock(sk), true, false);
 #endif
 	return ipv4_rcv_saddr_equal(tb->fast_rcv_saddr, sk->sk_rcv_saddr,
-				    ipv6_only_sock(sk), true);
+				    ipv6_only_sock(sk), true, false);
 }
=20
 /* Obtain a reference to a local port for the given sock,
--=20
2.24.1

