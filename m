Return-Path: <netdev+bounces-3431-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBD67071C7
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 21:16:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 895F81C20EEE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780C034CE4;
	Wed, 17 May 2023 19:16:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A3131F05;
	Wed, 17 May 2023 19:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671BBC433EF;
	Wed, 17 May 2023 19:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684350994;
	bh=ZoTW81Zq40rpS9EpFuQuPgbIxlOeh6ivM85BvnFwJgE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OFdJPJjxuPZU0xBg3dVjwpLNpuW9Ab/u4QupElnJz/oXFKYsU1vPVQE9zlBRExkmb
	 syByIUFetq1/8DVsKGYJKsEazhodxfO3sRMAq/NaEcAbly0IxYA86tNbVZf+LIa8HX
	 /iv9jfhvhc2+wKF8uvPCYjPFpSyaUiUiVi/QL8FoHyMJ3xV1UwBrtHEwQTYe10AIT3
	 j7bXn3pSiymDMub7XDE54L3w7+22Ago6n3Ib77fwLEws2nbw9R2A6N0atEy9NhX1zf
	 +u3au7SEP0/3jG9c3I+egVlNeoUD0PxzOG/Gcq1h+tBxmIxhg+sc7fiE0J8WboCE3U
	 fHgeiL0RJfGcw==
From: Mat Martineau <martineau@kernel.org>
Date: Wed, 17 May 2023 12:16:14 -0700
Subject: [PATCH net-next 1/5] inet: factor out locked section of
 inet_accept() in a new helper
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230516-send-net-next-20220516-v1-1-e91822b7b6e0@kernel.org>
References: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
In-Reply-To: <20230516-send-net-next-20220516-v1-0-e91822b7b6e0@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Matthieu Baerts <matthieu.baerts@tessares.net>
Cc: netdev@vger.kernel.org, mptcp@lists.linux.dev, 
 Mat Martineau <martineau@kernel.org>
X-Mailer: b4 0.12.2

From: Paolo Abeni <pabeni@redhat.com>

No functional changes intended. The new helper will be used
by the MPTCP protocol in the next patch to avoid duplicating
a few LoC.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <martineau@kernel.org>
---
 include/net/inet_common.h |  2 ++
 net/ipv4/af_inet.c        | 32 +++++++++++++++++---------------
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index cec453c18f1d..77f4b0ef5b92 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -31,6 +31,8 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags);
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
+void __inet_accept(struct socket *sock, struct socket *newsock,
+		   struct sock *newsk);
 int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index c4aab3aacbd8..946650036c7f 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -730,6 +730,20 @@ int inet_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL(inet_stream_connect);
 
+void __inet_accept(struct socket *sock, struct socket *newsock, struct sock *newsk)
+{
+	sock_rps_record_flow(newsk);
+	WARN_ON(!((1 << newsk->sk_state) &
+		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
+		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
+
+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
+	sock_graft(newsk, newsock);
+
+	newsock->state = SS_CONNECTED;
+}
+
 /*
  *	Accept a pending connection. The TCP layer now gives BSD semantics.
  */
@@ -743,24 +757,12 @@ int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 	/* IPV6_ADDRFORM can change sk->sk_prot under us. */
 	sk2 = READ_ONCE(sk1->sk_prot)->accept(sk1, flags, &err, kern);
 	if (!sk2)
-		goto do_err;
+		return err;
 
 	lock_sock(sk2);
-
-	sock_rps_record_flow(sk2);
-	WARN_ON(!((1 << sk2->sk_state) &
-		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
-		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
-
-	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
-		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
-	sock_graft(sk2, newsock);
-
-	newsock->state = SS_CONNECTED;
-	err = 0;
+	__inet_accept(sock, newsock, sk2);
 	release_sock(sk2);
-do_err:
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(inet_accept);
 

-- 
2.40.1


