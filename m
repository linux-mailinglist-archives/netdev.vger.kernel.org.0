Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E57337B1C1
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEKWx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:53:26 -0400
Received: from mout.gmx.net ([212.227.17.22]:53849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhEKWxY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 18:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1620773528;
        bh=WU24ziIMsl5MJ0jHEeI5AdeNfm5oYBKylyPjn0cY/t8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=bx43Fhry+8Nk2nqMoVXI08mdZ1GX8jqF0qEVb4Py0pWKqgzf9ORlNDcbGzl/hPLLq
         ETD5MlBqqV2szDFfOLFEDJz/6lWmgRRL+Rzs67MOq2c2kOStgtVI5FKBWm5G4j/jC9
         pJbCtH2FnkoAy70Ore0GfqKIhbh+HiEk4viHhSn0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [89.247.255.239] ([89.247.255.239]) by web-mail.gmx.net
 (3c-app-gmx-bs06.server.lan [172.19.170.55]) (via HTTP); Wed, 12 May 2021
 00:52:08 +0200
MIME-Version: 1.0
Message-ID: <trinity-e6ae9efa-9afb-4326-84c0-f3609b9b8168-1620773528307@3c-app-gmx-bs06>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     kuba@kernel.org
Cc:     mkl@pengutronix.de, socketcan@hartkopp.net, davem@davemloft.net,
        netdev@vger.kernel.org, cascardo@canonical.com
Subject: [PATCH] can: isotp: prevent race between isotp_bind and
 isotp_setsockopt
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 12 May 2021 00:52:08 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:sceUbZNMBGye06dcafCKqUqZRaP5UlOxKHU8/Aa6RyLNrPy94yY2gAMFROvdtv+OSidyG
 CMFlHUfKIKEcBJIrPl8HgY8h45ETOiCkJ5kOxcD2eSm9VtgK2NCImNkT52GdSCWocZJ8pOx9Czt3
 WEn3NA7WCYQFVM/iYX1cFQJwjywJD3eC6byPXi5k6+TXusH6DDKO/CGucselHmuGD4ZDBntCKe5b
 mTq6AIM25YIeiQRcK+2+9xb6eLr5SxB7OHzgLFK7XcBZv2ijXsf7E7n2yZet8E9MUUWLr2DzhGeC
 p8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8KNI88Fr9AQ=:W6eeYZWMSNB/wa7kW1/MAR
 twCPbqUygj1JZzQpgTvbgoe+OxIYj30PSxaM6WxujKnXke6RQddIiUB6kZybVLzalecs5Nt2S
 n23Ox/awtcX7HOpy9qpNsyzqoS8IsbGPx7o5mWZKtnqoNTwl8sXfuZDvXDjc5Caw5URm2F44W
 IlaSNgL7k93/SfUd27BsrlLPVsIdKJMPni+pb0Od+cMHlh8z1WdiDX8nUTJlY/pFKiBuB8qaA
 k9A3YW3IU6fckP5hVzzeTinEh7J8BK+garQH0vFgmMjTiiH1k8n/uREcNBRk46+rfnV1iB+zA
 +1k9DelnPm9tY2dseY6FAROdnNsZAtgMOHXGF4Qu2GeghHywn0pqlLSgOqhf8xl8vYmpdJFP0
 HCqe1sDctZgYUz/nDeooyBlYmNNOQ6s05Cim0U+RQQs8YEl+M5f4EO1bvyEVyZPIeDUTDCCuf
 zEYtkNVtMoRCojb3xTh5yAvpVgYPvcCIerGeiqPyWjdzCTFB2FW7LXGv2ixA3XGzycnKNVgCi
 MYgVl6JQpLb/BvhwP1L9DsJ6QJmfffP9g7mUxTztLB4m8sOuLVM66M6ZeB0U773CuG9q4LPIq
 OhJ2TzXECKWvw7TStTN57qIcfzoDOYh4gl6Clg9S56zD2q5f4YpxuJiLbBqADCf5W7THZGiKw
 eO1ZFXg7PyHfRsSRQx+egeZ0YpNxBfd5XHa6LI3sa0N2FCiT9chIiFkk53l+wi90L3ap1S8/9
 pP+oEfXoz5ga0ThC9bKtAyKwCsNu0BQM9VjSxoRy827C4hwqGHI9K770VJADqODOXLoJTRRvk
 KCOc14nrxgsOv7gY3BuC1UXDtqWRSjaoU4r71Lb+msKyvY3FQldv0ICmw4PaPv1wiAW8HkxDf
 XKgq4Iny2nWoTNx9xhTMQw60krzv2D9ixq2bbGrvv++Ytu328442gfza25qP1y
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>
Date: Wed, 12 May 2021 00:43:54 +0200
Subject: [PATCH] can: isotp: prevent race between isotp_bind and isotp_set=
sockopt

A race condition was found in isotp_setsockopt() which allows to
change socket options after the socket was bound.
For the specific case of SF_BROADCAST support, this might lead to possible
use-after-free because can_rx_unregister() is not called.

Checking for the flag under the socket lock in isotp_bind()
and taking the lock in isotp_setsockopt() fixes the issue.

Fixes: 921ca574cd38 ("can: isotp: add SF_BROADCAST support for functional =
addressing")
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
=2D--
 net/can/isotp.c | 49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 15ea1234d457..6cc05940d0b7 100644
=2D-- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1059,27 +1059,31 @@ static int isotp_bind(struct socket *sock, struct =
sockaddr *uaddr, int len)
 	if (len < CAN_REQUIRED_SIZE(struct sockaddr_can, can_addr.tp))
 		return -EINVAL;

+	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
+		return -EADDRNOTAVAIL;
+
+	if (!addr->can_ifindex)
+		return -ENODEV;
+
+	lock_sock(sk);
+
 	/* do not register frame reception for functional addressing */
 	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
 		do_rx_reg =3D 0;

 	/* do not validate rx address for functional addressing */
 	if (do_rx_reg) {
-		if (addr->can_addr.tp.rx_id =3D=3D addr->can_addr.tp.tx_id)
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id =3D=3D addr->can_addr.tp.tx_id) {
+			err =3D -EADDRNOTAVAIL;
+			goto out;
+		}

-		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-			return -EADDRNOTAVAIL;
+		if (addr->can_addr.tp.rx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG)) {
+			err =3D -EADDRNOTAVAIL;
+			goto out;
+		}
 	}

-	if (addr->can_addr.tp.tx_id & (CAN_ERR_FLAG | CAN_RTR_FLAG))
-		return -EADDRNOTAVAIL;
-
-	if (!addr->can_ifindex)
-		return -ENODEV;
-
-	lock_sock(sk);
-
 	if (so->bound && addr->can_ifindex =3D=3D so->ifindex &&
 	    addr->can_addr.tp.rx_id =3D=3D so->rxid &&
 	    addr->can_addr.tp.tx_id =3D=3D so->txid)
@@ -1161,16 +1165,13 @@ static int isotp_getname(struct socket *sock, stru=
ct sockaddr *uaddr, int peer)
 	return sizeof(*addr);
 }

-static int isotp_setsockopt(struct socket *sock, int level, int optname,
+static int isotp_setsockopt_locked(struct socket *sock, int level, int op=
tname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk =3D sock->sk;
 	struct isotp_sock *so =3D isotp_sk(sk);
 	int ret =3D 0;

-	if (level !=3D SOL_CAN_ISOTP)
-		return -EINVAL;
-
 	if (so->bound)
 		return -EISCONN;

@@ -1245,6 +1246,22 @@ static int isotp_setsockopt(struct socket *sock, in=
t level, int optname,
 	return ret;
 }

+static int isotp_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk =3D sock->sk;
+	int ret;
+
+	if (level !=3D SOL_CAN_ISOTP)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret =3D isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {
=2D-
2.27.0
