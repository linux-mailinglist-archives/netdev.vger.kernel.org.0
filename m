Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB2330FF4F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 22:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBDVaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 16:30:25 -0500
Received: from mout.gmx.net ([212.227.17.20]:56825 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhBDVaY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 16:30:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612474128;
        bh=5ccFS/qGcWaPtOtW+cFqga5nG89nyxGT3fl7/64mRug=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=DAvb5dDWDV6mQGGMr6MD5wEmozG46MvpSH2axsMNnQH8xSITriSz2e15Y3PVg/d4p
         78JWt/CDaPFJdh3kb8gCwTeIHHFvzfISutrM8QB4wEu11R5EVYxYEbX/dnH9OoiSyK
         6JCEb5rhngPGUYNZbx7gi6bpzZVuo7S1P9JjAH1Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [89.247.255.205] ([89.247.255.205]) by web-mail.gmx.net
 (3c-app-gmx-bap39.server.lan [172.19.172.109]) (via HTTP); Thu, 4 Feb 2021
 22:28:47 +0100
MIME-Version: 1.0
Message-ID: <trinity-64b93de7-52ac-4127-a29a-1a6dbbb7aeb6-1612474127915@3c-app-gmx-bap39>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     Stefano Garzarella <sgarzare@redhat.com>, alex.popov@linux.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve locking
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 4 Feb 2021 22:28:47 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:MjAhw9BAf3W3lL0ssB9gjrKP5cuRcvNySE9VMNYg5PQCDDUf5GjVe5hfBBjhShxbBl3pd
 D23ta1sJ5thUnahVzJpVp04ulsxAstIEyppRipzIKHcrH1JfPYv3tuu+IT51rIQJHDKDdKd/6axq
 D/VnApTyhrWjnLF0A7q6MKXQzrPtM3eaXvXq2CKEexVfSl9Ij46Mh9ZM1cA4jQVZnILZAfpQUWtw
 MrpDbVEmnq+UwWnwrw8wAhrzL3RLwq3Oq6moKn5gmc3DENCyNGYPbIFVaqeAHCa4W6svjr9qbAZQ
 Tc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:g1m1Hn1uDD4=:wmm9/vB/gc16myoaqEO5tX
 jMObfPlUcVaOml64IyxmaiRNYfswbpsP7QrS1FvOffwno0N+hvM2ZN5SXuvHKVkS9eZKC6e2Q
 w7zz0c7+0kRFp4TcvJwI3YLFyGA7fuyHNTgyvhFj6FK31QVR5iAQFbuFeHf5GTImQdPf8S3gu
 UA3fOf9dXJMqUH5PYDgg5GPl2u46krDHNk6Kb4K2NV2mf67WJWNB4pOWOIJe7C/ShuHaYTHYC
 kA9s6UDIRQPIs1O6Gp5xAXCSYDBuwAHmmZnWAlh2piL7lcO1QxUHrpTeFM6fYFX5oIBBOxsFz
 qxYhwRSTplwKsXYu6kE7LiioSvG2jBR7dr6COFZw0eUWxolCK2D8xbTi8Hc4l98Drit6F7Qzp
 3KuExx96lHO5yYskNE6c8EqWfbGfvqm4lRIwrRDWVnCBICvOvHjcTzNtjPgkcwbuCZ/Tl2Lo+
 aInYPtg1Gi4AVNNLyhjr1E+akUNaejQZWD9o+GeVno7TYH0qn3KfDgaSmBZhersDuH3IxogXl
 Vim96aD0/IdopZmWiaUtrbRCektkIC+A7tUi6xg/G+r3b56Jjc3W+MxsaTJcKlMpXVONhBMPy
 GIEkljRhUHVfw=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>
Date: Thu, 4 Feb 2021 18:49:24 +0100
Subject: [PATCH] net/vmw_vsock: fix NULL pointer deref and improve locking

In vsock_stream_connect(), a thread will enter schedule_timeout().
While being scheduled out, another thread can enter vsock_stream_connect()=
 as
well and set vsk->transport to NULL. In case a signal was sent, the first
thread can leave schedule_timeout() and vsock_transport_cancel_pkt() will =
be
called right after. Inside vsock_transport_cancel_pkt(), a null dereferenc=
e
will happen on transport->cancel_pkt.

The patch also features improved locking inside vsock_connect_timeout().

Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
=2D--
 net/vmw_vsock/af_vsock.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3b480ed0953a..ea7b9d208724 100644
=2D-- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1233,7 +1233,7 @@ static int vsock_transport_cancel_pkt(struct vsock_s=
ock *vsk)
 {
 	const struct vsock_transport *transport =3D vsk->transport;

-	if (!transport->cancel_pkt)
+	if (!transport || !transport->cancel_pkt)
 		return -EOPNOTSUPP;

 	return transport->cancel_pkt(vsk);
@@ -1243,7 +1243,6 @@ static void vsock_connect_timeout(struct work_struct=
 *work)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
-	int cancel =3D 0;

 	vsk =3D container_of(work, struct vsock_sock, connect_work.work);
 	sk =3D sk_vsock(vsk);
@@ -1254,11 +1253,9 @@ static void vsock_connect_timeout(struct work_struc=
t *work)
 		sk->sk_state =3D TCP_CLOSE;
 		sk->sk_err =3D ETIMEDOUT;
 		sk->sk_error_report(sk);
-		cancel =3D 1;
+		vsock_transport_cancel_pkt(vsk);
 	}
 	release_sock(sk);
-	if (cancel)
-		vsock_transport_cancel_pkt(vsk);

 	sock_put(sk);
 }
=2D-
2.30.0
