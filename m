Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F18581FD6
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiG0GJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbiG0GJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:09:09 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79ED3FA0B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:08 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QND46A005163
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9MTYNo4YZsw9yi69NoNQIlU/M5aVblUYD9ww+V4slBs=;
 b=YR96TdFKlATzOSumbE132pLFjeLX19y9Rubkqi/TyL131Ue9K14BCJuicxzvsGlvOrNn
 6eCQEg2FegWX4qXvJypjQMZtxAtYRBndP8VChNI6DSsoWX3qWcDc4CL+/sujhe0rj79m
 PPnkJ89twxn6sNK9LfEbVu4Wrm6bA2iPBpQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hjhxaw32d-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:09:08 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 23:09:07 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id DB345757CB54; Tue, 26 Jul 2022 23:09:02 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking sock ptr to sk ptr
Date:   Tue, 26 Jul 2022 23:09:02 -0700
Message-ID: <20220727060902.2370689-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220727060856.2370358-1-kafai@fb.com>
References: <20220727060856.2370358-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xbkuGCwJ4YFEDSrRiSyLXtRvHr0qGwJj
X-Proofpoint-GUID: xbkuGCwJ4YFEDSrRiSyLXtRvHr0qGwJj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A latter patch refactors bpf_setsockopt(SOL_SOCKET) with the
sock_setsockopt() to avoid code duplication and code
drift between the two duplicates.

The current sock_setsockopt() takes sock ptr as the argument.
The very first thing of this function is to get back the sk ptr
by 'sk =3D sock->sk'.

bpf_setsockopt() could be called when the sk does not have
a userspace owner.  Meaning sk->sk_socket is NULL.  For example,
when a passive tcp connection has just been established.  Thus,
it cannot use the sock_setsockopt(sk->sk_socket) or else it will
pass a NULL sock ptr.

All existing callers have both sock->sk and sk->sk_socket pointer.
Thus, this patch changes the sock_setsockopt() to take a sk ptr
instead of the sock ptr.  The bpf_setsockopt() only allows
optnames that do not require a sock ptr.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 drivers/nvme/host/tcp.c  |  2 +-
 fs/ksmbd/transport_tcp.c |  2 +-
 include/net/sock.h       |  2 +-
 net/core/sock.c          |  4 ++--
 net/mptcp/sockopt.c      | 12 ++++++------
 net/socket.c             |  2 +-
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7a9e6ffa2342..60e14cc39e49 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1555,7 +1555,7 @@ static int nvme_tcp_alloc_queue(struct nvme_ctrl *n=
ctrl,
 		char *iface =3D nctrl->opts->host_iface;
 		sockptr_t optval =3D KERNEL_SOCKPTR(iface);
=20
-		ret =3D sock_setsockopt(queue->sock, SOL_SOCKET, SO_BINDTODEVICE,
+		ret =3D sock_setsockopt(queue->sock->sk, SOL_SOCKET, SO_BINDTODEVICE,
 				      optval, strlen(iface));
 		if (ret) {
 			dev_err(nctrl->device,
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 143bba4e4db8..982eed2dd575 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -420,7 +420,7 @@ static int create_socket(struct interface *iface)
 	ksmbd_tcp_nodelay(ksmbd_socket);
 	ksmbd_tcp_reuseaddr(ksmbd_socket);
=20
-	ret =3D sock_setsockopt(ksmbd_socket,
+	ret =3D sock_setsockopt(ksmbd_socket->sk,
 			      SOL_SOCKET,
 			      SO_BINDTODEVICE,
 			      KERNEL_SOCKPTR(iface->name),
diff --git a/include/net/sock.h b/include/net/sock.h
index f7ad1a7705e9..9e2539dcc293 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1795,7 +1795,7 @@ void sock_pfree(struct sk_buff *skb);
 #define sock_edemux sock_efree
 #endif
=20
-int sock_setsockopt(struct socket *sock, int level, int op,
+int sock_setsockopt(struct sock *sk, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
=20
 int sock_getsockopt(struct socket *sock, int level, int op,
diff --git a/net/core/sock.c b/net/core/sock.c
index 4cb957d934a2..18bb4f269cf1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1041,12 +1041,12 @@ static int sock_reserve_memory(struct sock *sk, i=
nt bytes)
  *	at the socket level. Everything here is generic.
  */
=20
-int sock_setsockopt(struct socket *sock, int level, int optname,
+int sock_setsockopt(struct sock *sk, int level, int optname,
 		    sockptr_t optval, unsigned int optlen)
 {
 	struct so_timestamping timestamping;
+	struct socket *sock =3D sk->sk_socket;
 	struct sock_txtime sk_txtime;
-	struct sock *sk =3D sock->sk;
 	int val;
 	int valbool;
 	struct linger ling;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index 423d3826ca1e..5684499b4d39 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -124,7 +124,7 @@ static int mptcp_sol_socket_intval(struct mptcp_sock =
*msk, int optname, int val)
 	struct sock *sk =3D (struct sock *)msk;
 	int ret;
=20
-	ret =3D sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+	ret =3D sock_setsockopt(sk, SOL_SOCKET, optname,
 			      optval, sizeof(val));
 	if (ret)
 		return ret;
@@ -149,7 +149,7 @@ static int mptcp_setsockopt_sol_socket_tstamp(struct =
mptcp_sock *msk, int optnam
 	struct sock *sk =3D (struct sock *)msk;
 	int ret;
=20
-	ret =3D sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+	ret =3D sock_setsockopt(sk, SOL_SOCKET, optname,
 			      optval, sizeof(val));
 	if (ret)
 		return ret;
@@ -225,7 +225,7 @@ static int mptcp_setsockopt_sol_socket_timestamping(s=
truct mptcp_sock *msk,
 		return -EINVAL;
 	}
=20
-	ret =3D sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname,
+	ret =3D sock_setsockopt(sk, SOL_SOCKET, optname,
 			      KERNEL_SOCKPTR(&timestamping),
 			      sizeof(timestamping));
 	if (ret)
@@ -262,7 +262,7 @@ static int mptcp_setsockopt_sol_socket_linger(struct =
mptcp_sock *msk, sockptr_t
 		return -EFAULT;
=20
 	kopt =3D KERNEL_SOCKPTR(&ling);
-	ret =3D sock_setsockopt(sk->sk_socket, SOL_SOCKET, SO_LINGER, kopt, siz=
eof(ling));
+	ret =3D sock_setsockopt(sk, SOL_SOCKET, SO_LINGER, kopt, sizeof(ling));
 	if (ret)
 		return ret;
=20
@@ -306,7 +306,7 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_s=
ock *msk, int optname,
 			return -EINVAL;
 		}
=20
-		ret =3D sock_setsockopt(ssock, SOL_SOCKET, optname, optval, optlen);
+		ret =3D sock_setsockopt(ssock->sk, SOL_SOCKET, optname, optval, optlen=
);
 		if (ret =3D=3D 0) {
 			if (optname =3D=3D SO_REUSEPORT)
 				sk->sk_reuseport =3D ssock->sk->sk_reuseport;
@@ -349,7 +349,7 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_s=
ock *msk, int optname,
 	case SO_PREFER_BUSY_POLL:
 	case SO_BUSY_POLL_BUDGET:
 		/* No need to copy: only relevant for msk */
-		return sock_setsockopt(sk->sk_socket, SOL_SOCKET, optname, optval, opt=
len);
+		return sock_setsockopt(sk, SOL_SOCKET, optname, optval, optlen);
 	case SO_NO_CHECK:
 	case SO_DONTROUTE:
 	case SO_BROADCAST:
diff --git a/net/socket.c b/net/socket.c
index b6bd4cf44d3f..c6911d613ae2 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2245,7 +2245,7 @@ int __sys_setsockopt(int fd, int level, int optname=
, char __user *user_optval,
 	if (kernel_optval)
 		optval =3D KERNEL_SOCKPTR(kernel_optval);
 	if (level =3D=3D SOL_SOCKET && !sock_use_custom_sol_socket(sock))
-		err =3D sock_setsockopt(sock, level, optname, optval, optlen);
+		err =3D sock_setsockopt(sock->sk, level, optname, optval, optlen);
 	else if (unlikely(!sock->ops->setsockopt))
 		err =3D -EOPNOTSUPP;
 	else
--=20
2.30.2

