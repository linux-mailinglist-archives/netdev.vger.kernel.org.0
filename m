Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACB4310DDE
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhBEOsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:48:17 -0500
Received: from mout.gmx.net ([212.227.17.22]:33675 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhBEOl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612541948;
        bh=2GjMesMOyGtDfApPBjPbE+ALZNIhHcKxH9rOzdzfNTQ=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Vw0flNjgDBO/jlaRxbUoSyAfN4XKs0+/VEMmV6BJtxBWJvJIjly3n0/LA2sSybyox
         HzQAx5/la1k6Nzn1GoQD26ujE0cIdHT4TNsAa1UiCMV60ZEiKjcniJzSr1fUnJU9qM
         8I5RkFVC2k7Dvxovu8LE3rbHvWEZB4hg8EFEyjxY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [87.123.206.138] ([87.123.206.138]) by web-mail.gmx.net
 (3c-app-gmx-bap12.server.lan [172.19.172.82]) (via HTTP); Fri, 5 Feb 2021
 15:32:02 +0100
MIME-Version: 1.0
Message-ID: <trinity-f8e0937a-cf0e-4d80-a76e-d9a958ba3ef1-1612535522360@3c-app-gmx-bap12>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     sgarzare@redhat.com, kuba@kernel.org, alex.popov@linux.com,
        eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net/vmw_vsock: improve locking in vsock_connect_timeout()
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 5 Feb 2021 15:32:02 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:wX5SceQyz5mb/yxhKEfgZhkhGFkUQ1Mxj0jDNKXRXJs/PSf5AKxGUd+pF5XTH32mClXb5
 /ZArT9CgEQla2a6tiYIB8i9CxSZ+ah0kiGGnsAOVFC6MzVxBIGgt0mtbbfR4xtfO4EzubEN1Ct+B
 BsW4lR4rWDLGRHkPL3vQk1dAAwrkhWyBqRTn2XrP17p2MBPyhRLrgTBAU9J6NKtGnusBo2bcZUal
 qOR2xG9Vgd3jojjNknvq15VhC4PpcMYBFHqsDzBTY7wJjW6uZakKwBx7wjdXmE/wxNC4cL0CBbAZ
 dE=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:iyYwQZcSYGo=:fnTTZ23pE6SXDO+Z+7Vj/t
 EJlIb/Ch3ZE5KgTM//3dOmQymdHg48mORHSGMVVbROgn6Dr6KArpWNiafLJvxEOdXEDfIm+Fl
 WraP1bb/x/0zUgI+1MHzbVSrjvK29ugjBb7aR2I4hwxUUL+IJuaNjZhffjIUUQIUGylQ+6gpo
 /aUUBf34UtWF9yhn3e3mRImnzaJE8gLSKyNToQWPrVe/DLMhHQ9wPFye820ZW3rUwAxPV7gFj
 2N3tCpa65s4a7cXJErV8dvauFpGFaKMGtLA1OKq/x4h9e8l3zNC3zZASz6Y/lz5JEQwqFuiqN
 G7FoPOwDQaJyXnyFy+VfsjQ/YvfSRCLUXHtD/70Pb4PNMQHemBoYkquV1cJ6wSNDKYEBAFLid
 6Hh4DOUGkhHxKNiSAWrd+Xr7c/qI+Hn8/oOZ7z/pY/Z+hI+h64ub1Y4Io3+E3oCnenoeCkqxO
 /atOm2J2Stb22WbBNThpAAaQVrc1bxOgmuqNZhCydbMzafOgHY484xY2ZaYvNOoeS8PUhciDt
 g4Ezi2H20zyYqFUQz9i99dUBa8FjUlbHSUsHM0zWoG1BHgONv/lhCSgMhH/nwpAVSUxfrkbX2
 OUYS8MYROk8wI=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>
Date: Fri, 5 Feb 2021 13:14:05 +0100
Subject: [PATCH] net/vmw_vsock: improve locking in vsock_connect_timeout()

A possible locking issue in vsock_connect_timeout() was recognized by
Eric Dumazet which might cause a null pointer dereference in
vsock_transport_cancel_pkt(). This patch assures that
vsock_transport_cancel_pkt() will be called within the lock, so a race
condition won't occur which could result in vsk->transport to be set to NU=
LL.

Fixes: 380feae0def7 ("vsock: cancel packets when failing to connect")
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
=2D--
 net/vmw_vsock/af_vsock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 6894f21dc147..ad7dd9d93b5b 100644
=2D-- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
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
