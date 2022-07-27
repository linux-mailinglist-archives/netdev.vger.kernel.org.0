Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6311B581FDB
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiG0GJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiG0GJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:09:32 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627BA3FA26
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:31 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QNDGcZ000955
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UKIPQVu6eKMnk726mpApj3QnXSFYtxMB3wm5kiaDCTI=;
 b=Y/GyFbucYeuaY89Gr/1rYn+OtaxvRAkcYzJ0uc6auH7x9B7WeByk+x0rrlbeofwWZdAN
 pcLVKPnFyPAHIfxPbcF1gd5a/EsTJBnO1u4jMjfDmcJPWK5OAKEbAVaP8+UVfWkNncXv
 NLL5MF1Vip3rn74rktgxYbRYjWUHf/YUXEE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hj592rgq8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:30 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:29 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id BEB39757CC81; Tue, 26 Jul 2022 23:09:21 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 04/14] bpf: net: Avoid do_tcp_setsockopt() taking sk lock when called from bpf
Date:   Tue, 26 Jul 2022 23:09:21 -0700
Message-ID: <20220727060921.2373314-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IqEzap8C1wnvUaioF_taz76pivWEKbom
X-Proofpoint-GUID: IqEzap8C1wnvUaioF_taz76pivWEKbom
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

Similar to the earlier patch that avoids sock_setsockopt() from
taking sk lock when called from bpf.  This patch changes
do_tcp_setsockopt() to use the {lock,release}_sock_sockopt().

This patch also changes do_tcp_setsockopt() to check optval.is_bpf
when passing the cap_net_admin arg to
tcp_set_congestion_control(..., cap_net_admin).  It is
the same as how bpf_setsockopt(TCP_CONGESTION) is calling
tcp_set_congestion_control() now.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/tcp.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba2bdc811374..7f8d81befa8e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3462,11 +3462,12 @@ static int do_tcp_setsockopt(struct sock *sk, int=
 level, int optname,
 			return -EFAULT;
 		name[val] =3D 0;
=20
-		lock_sock(sk);
-		err =3D tcp_set_congestion_control(sk, name, true,
-						 ns_capable(sock_net(sk)->user_ns,
-							    CAP_NET_ADMIN));
-		release_sock(sk);
+		lock_sock_sockopt(sk, optval);
+		err =3D tcp_set_congestion_control(sk, name, !optval.is_bpf,
+						 optval.is_bpf ?
+						 true : ns_capable(sock_net(sk)->user_ns,
+								   CAP_NET_ADMIN));
+		release_sock_sockopt(sk, optval);
 		return err;
 	}
 	case TCP_ULP: {
@@ -3482,9 +3483,9 @@ static int do_tcp_setsockopt(struct sock *sk, int l=
evel, int optname,
 			return -EFAULT;
 		name[val] =3D 0;
=20
-		lock_sock(sk);
+		lock_sock_sockopt(sk, optval);
 		err =3D tcp_set_ulp(sk, name);
-		release_sock(sk);
+		release_sock_sockopt(sk, optval);
 		return err;
 	}
 	case TCP_FASTOPEN_KEY: {
@@ -3517,7 +3518,7 @@ static int do_tcp_setsockopt(struct sock *sk, int l=
evel, int optname,
 	if (copy_from_sockptr(&val, optval, sizeof(val)))
 		return -EFAULT;
=20
-	lock_sock(sk);
+	lock_sock_sockopt(sk, optval);
=20
 	switch (optname) {
 	case TCP_MAXSEG:
@@ -3739,7 +3740,7 @@ static int do_tcp_setsockopt(struct sock *sk, int l=
evel, int optname,
 		break;
 	}
=20
-	release_sock(sk);
+	release_sock_sockopt(sk, optval);
 	return err;
 }
=20
--=20
2.30.2

