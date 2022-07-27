Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5431E581FDE
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiG0GJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiG0GJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:09:29 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D2D3FA1B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:27 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND39x023090
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UYajfNksjQ0xDGx8SLc0vrxm7yeny8R81U/q7n7S7dU=;
 b=BYPl4vnfNDlWStprmMqwsaV20wu74sKOMf28X0jtEya9vNXyilcXxReE8JuHAtUkTeA6
 bZSX9FmfVYGwtMFKkhrxx7eDUfs+PeiZSAxjdf0z4iIH53TOGEUxaIKx57ToaeWCZXs9
 5xmsfDeds9zXRnU8s88UhcNRm0TYnIEuFzM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjjnsmqj4-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:27 -0700
Received: from snc-exhub201.TheFacebook.com (2620:10d:c085:21d::7) by
 snc-exhub202.TheFacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:26 -0700
Received: from twshared22413.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:25 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 75746757CBDA; Tue, 26 Jul 2022 23:09:15 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 03/14] bpf: net: Consider optval.is_bpf before capable check in sock_setsockopt()
Date:   Tue, 26 Jul 2022 23:09:15 -0700
Message-ID: <20220727060915.2372520-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PT_wWggIz53taQtwDKgy5J8p0V85Nc5a
X-Proofpoint-GUID: PT_wWggIz53taQtwDKgy5J8p0V85Nc5a
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

When bpf program calling bpf_setsockopt(SOL_SOCKET),
it could be run in softirq and doesn't make sense to do the capable
check.  There was a similar situation in bpf_setsockopt(TCP_CONGESTION).
In commit 8d650cdedaab ("tcp: fix tcp_set_congestion_control() use from b=
pf hook")
tcp_set_congestion_control(..., cap_net_admin) was added to skip
the cap check for bpf prog.

A similar change is done in this patch for SO_MARK, SO_PRIORITY,
and SO_BINDTO{DEVICE,IFINDEX} which are the optnames allowed by
bpf_setsockopt(SOL_SOCKET).  This will allow the sock_setsockopt()
to be reused by bpf_setsockopt(SOL_SOCKET) in a latter patch.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/sock.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 61d927a5f6cb..f2c582491d5f 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -620,7 +620,7 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 c=
ookie)
 }
 EXPORT_SYMBOL(sk_dst_check);
=20
-static int sock_bindtoindex_locked(struct sock *sk, int ifindex)
+static int sock_bindtoindex_locked(struct sock *sk, int ifindex, bool ca=
p_check)
 {
 	int ret =3D -ENOPROTOOPT;
 #ifdef CONFIG_NETDEVICES
@@ -628,7 +628,8 @@ static int sock_bindtoindex_locked(struct sock *sk, i=
nt ifindex)
=20
 	/* Sorry... */
 	ret =3D -EPERM;
-	if (sk->sk_bound_dev_if && !ns_capable(net->user_ns, CAP_NET_RAW))
+	if (sk->sk_bound_dev_if && cap_check &&
+	    !ns_capable(net->user_ns, CAP_NET_RAW))
 		goto out;
=20
 	ret =3D -EINVAL;
@@ -656,7 +657,7 @@ int sock_bindtoindex(struct sock *sk, int ifindex, bo=
ol lock_sk)
=20
 	if (lock_sk)
 		lock_sock(sk);
-	ret =3D sock_bindtoindex_locked(sk, ifindex);
+	ret =3D sock_bindtoindex_locked(sk, ifindex, true);
 	if (lock_sk)
 		release_sock(sk);
=20
@@ -704,7 +705,7 @@ static int sock_setbindtodevice(struct sock *sk, sock=
ptr_t optval, int optlen)
 	}
=20
 	lock_sock_sockopt(sk, optval);
-	ret =3D sock_bindtoindex_locked(sk, index);
+	ret =3D sock_bindtoindex_locked(sk, index, !optval.is_bpf);
 	release_sock_sockopt(sk, optval);
 out:
 #endif
@@ -1166,6 +1167,7 @@ int sock_setsockopt(struct sock *sk, int level, int=
 optname,
=20
 	case SO_PRIORITY:
 		if ((val >=3D 0 && val <=3D 6) ||
+		    optval.is_bpf ||
 		    ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) ||
 		    ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 			sk->sk_priority =3D val;
@@ -1312,7 +1314,8 @@ int sock_setsockopt(struct sock *sk, int level, int=
 optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
+		if (!optval.is_bpf &&
+		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_RAW) &&
 		    !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret =3D -EPERM;
 			break;
@@ -1456,7 +1459,7 @@ int sock_setsockopt(struct sock *sk, int level, int=
 optname,
 		break;
=20
 	case SO_BINDTOIFINDEX:
-		ret =3D sock_bindtoindex_locked(sk, val);
+		ret =3D sock_bindtoindex_locked(sk, val, !optval.is_bpf);
 		break;
=20
 	case SO_BUF_LOCK:
--=20
2.30.2

