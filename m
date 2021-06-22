Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD73AFA6D
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFVBIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 21:08:46 -0400
Received: from ozlabs.org ([203.11.71.1]:47613 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhFVBIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 21:08:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G87Wj0MKbz9sT6;
        Tue, 22 Jun 2021 11:06:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1624323986;
        bh=9YjXmRPRl40v1/64q9EY5/EN6DGBD3y3fJr/d84LgUI=;
        h=Date:From:To:Cc:Subject:From;
        b=KT5V6JBBl/NKcx7AxYaR6r9sJO+QQsgmnf+QQ1uDy+jN8xVkkdiS7EAES40ND2Dvx
         zjD6OdE9sYQrwHFC/A3e1jIe8H4l1rXcFYZxV9z8iCFk7ZYDMJMHwC38VsPNoQMJFx
         JJ5X2vBrZkwbcHi3Q3mVZhyCXMwrrlG1+1FHVDDb1toOGSlyfmhGiVQ5IMDDUCYDlk
         RjYAt4H9AxbP2tHq+Z99P7a1BhEKM8jtjPJGCVh224etilpkhaKcx8vvtN1IaOiR1u
         lMZQhKORe6RXlAOkyNH+M1mf06aeR0YosrQgtJMjtXqHz5fnLIaoT715MU3LuB9+8H
         UwG3y/mQkDM6w==
Date:   Tue, 22 Jun 2021 11:06:22 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Cc:     Cong Wang <cong.wang@bytedance.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20210622110622.25f9f026@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2Q2oum8Y9H2GJuK+E75X+cp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2Q2oum8Y9H2GJuK+E75X+cp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  net/ipv4/tcp_bpf.c
  net/ipv4/udp_bpf.c
  include/linux/skmsg.h
  net/core/skmsg.c

between commit:

  9f2470fbc4cb ("skmsg: Improve udp_bpf_recvmsg() accuracy")

from the bpf tree and commit:

  c49661aa6f70 ("skmsg: Remove unused parameters of sk_msg_wait_data()")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc include/linux/skmsg.h
index e3d080c299f6,fcaa9a7996c8..000000000000
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
diff --cc net/core/skmsg.c
index 9b6160a191f8,f0b9decdf279..000000000000
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
diff --cc net/ipv4/tcp_bpf.c
index bb49b52d7be8,a80de92ea3b6..000000000000
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@@ -163,28 -163,6 +163,28 @@@ static bool tcp_bpf_stream_read(const s
  	return !empty;
  }
 =20
- static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock, int=
 flags,
- 			     long timeo, int *err)
++static int tcp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
++			     long timeo)
 +{
 +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 +	int ret =3D 0;
 +
 +	if (sk->sk_shutdown & RCV_SHUTDOWN)
 +		return 1;
 +
 +	if (!timeo)
 +		return ret;
 +
 +	add_wait_queue(sk_sleep(sk), &wait);
 +	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 +	ret =3D sk_wait_event(sk, &timeo,
 +			    !list_empty(&psock->ingress_msg) ||
 +			    !skb_queue_empty(&sk->sk_receive_queue), &wait);
 +	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 +	remove_wait_queue(sk_sleep(sk), &wait);
 +	return ret;
 +}
 +
  static int tcp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t le=
n,
  		    int nonblock, int flags, int *addr_len)
  {
@@@ -206,11 -184,11 +206,11 @@@
  msg_bytes_ready:
  	copied =3D sk_msg_recvmsg(sk, psock, msg, len, flags);
  	if (!copied) {
- 		int data, err =3D 0;
  		long timeo;
+ 		int data;
 =20
  		timeo =3D sock_rcvtimeo(sk, nonblock);
- 		data =3D tcp_msg_wait_data(sk, psock, flags, timeo, &err);
 -		data =3D sk_msg_wait_data(sk, psock, timeo);
++		data =3D tcp_msg_wait_data(sk, psock, timeo);
  		if (data) {
  			if (!sk_psock_queue_empty(psock))
  				goto msg_bytes_ready;
diff --cc net/ipv4/udp_bpf.c
index 565a70040c57,b07e4b6dda25..000000000000
--- a/net/ipv4/udp_bpf.c
+++ b/net/ipv4/udp_bpf.c
@@@ -21,45 -21,6 +21,45 @@@ static int sk_udp_recvmsg(struct sock *
  	return udp_prot.recvmsg(sk, msg, len, noblock, flags, addr_len);
  }
 =20
 +static bool udp_sk_has_data(struct sock *sk)
 +{
 +	return !skb_queue_empty(&udp_sk(sk)->reader_queue) ||
 +	       !skb_queue_empty(&sk->sk_receive_queue);
 +}
 +
 +static bool psock_has_data(struct sk_psock *psock)
 +{
 +	return !skb_queue_empty(&psock->ingress_skb) ||
 +	       !sk_psock_queue_empty(psock);
 +}
 +
 +#define udp_msg_has_data(__sk, __psock)	\
 +		({ udp_sk_has_data(__sk) || psock_has_data(__psock); })
 +
- static int udp_msg_wait_data(struct sock *sk, struct sk_psock *psock, int=
 flags,
- 			     long timeo, int *err)
++static int udp_msg_wait_data(struct sock *sk, struct sk_psock *psock,
++			     long timeo)
 +{
 +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 +	int ret =3D 0;
 +
 +	if (sk->sk_shutdown & RCV_SHUTDOWN)
 +		return 1;
 +
 +	if (!timeo)
 +		return ret;
 +
 +	add_wait_queue(sk_sleep(sk), &wait);
 +	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 +	ret =3D udp_msg_has_data(sk, psock);
 +	if (!ret) {
 +		wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
 +		ret =3D udp_msg_has_data(sk, psock);
 +	}
 +	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
 +	remove_wait_queue(sk_sleep(sk), &wait);
 +	return ret;
 +}
 +
  static int udp_bpf_recvmsg(struct sock *sk, struct msghdr *msg, size_t le=
n,
  			   int nonblock, int flags, int *addr_len)
  {
@@@ -81,13 -43,13 +81,13 @@@
  msg_bytes_ready:
  	copied =3D sk_msg_recvmsg(sk, psock, msg, len, flags);
  	if (!copied) {
- 		int data, err =3D 0;
  		long timeo;
+ 		int data;
 =20
  		timeo =3D sock_rcvtimeo(sk, nonblock);
- 		data =3D udp_msg_wait_data(sk, psock, flags, timeo, &err);
 -		data =3D sk_msg_wait_data(sk, psock, timeo);
++		data =3D udp_msg_wait_data(sk, psock, timeo);
  		if (data) {
 -			if (!sk_psock_queue_empty(psock))
 +			if (psock_has_data(psock))
  				goto msg_bytes_ready;
  			ret =3D sk_udp_recvmsg(sk, msg, len, nonblock, flags, addr_len);
  			goto out;

--Sig_/2Q2oum8Y9H2GJuK+E75X+cp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmDRN44ACgkQAVBC80lX
0GziiAf/dC8a0qkAG7lFb2nIFgVtmOQaSPyWs+NPZa6zvG+UbCrWmPMEfHB4YyVC
PRGAlz88dKL5a8Kayqt+9LwqpblHO9wgQF2jXXiKDL+fC0Gd4vwERCO4ByDVgAQB
+03OU22o6eYEeZIFoL9Fo8g3kgc78iTmZcqu1XDW0B9MDbgVTE8fxDaVdTH4VVQh
+L6FckTw6g89oyhthg4H8fH4Q+w/TD/HkhPHPsLE8LwKumhSh+9ideD7YX7B+cRJ
lsin7mLiSi0LcKaIwyQTxjhUKITSR6WUSB+IS1f3unmSPDU/KhuPxVA2cjpfADN0
BlmVR2VjA8Mk6Gd8lZfG1h/pdRa+2w==
=GlCG
-----END PGP SIGNATURE-----

--Sig_/2Q2oum8Y9H2GJuK+E75X+cp--
