Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77544490B62
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 16:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240468AbiAQPbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 10:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbiAQPbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 10:31:41 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9EBC061574
        for <netdev@vger.kernel.org>; Mon, 17 Jan 2022 07:31:41 -0800 (PST)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 6A1242E122C;
        Mon, 17 Jan 2022 18:31:38 +0300 (MSK)
Received: from myt6-81d8ab6a9f9d.qloud-c.yandex.net (myt6-81d8ab6a9f9d.qloud-c.yandex.net [2a02:6b8:c12:520a:0:640:81d8:ab6a])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id LcEUaqS2OL-VbLuw4S7;
        Mon, 17 Jan 2022 18:31:38 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1642433498; bh=8X7PZokn8LkHwxEgVM1BVQPe6AQ/Oc0frGYhRp5CekA=;
        h=Message-Id:References:Date:Subject:Cc:To:In-Reply-To:From;
        b=CdSL0eSZtfMwEHwou40+GjvZL0NlETfdJX/QDGi/gz9aVlziAVytnxV9oXO0F6rLl
         9KMsZgtEkqnNGw5pdBF8QV9l7zdIMXBQbthSnUQKfNemGoYjv3D7/lpxM1ahvb47vz
         AzmNNH5FtvfD9LxbsO6uLBczBRCPGDxz7eKDHrq4=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from smtpclient.apple (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:39d6:dbc7:816e:cad5])
        by myt6-81d8ab6a9f9d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id fLH6ksHfQu-VbPKZaU6;
        Mon, 17 Jan 2022 18:31:37 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [RFC PATCH v3 net-next 4/4] tcp: change SYN ACK retransmit
 behaviour to account for rehash
From:   Akhmat Karakotov <hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-5-hmukos@yandex-team.ru>
Date:   Mon, 17 Jan 2022 18:31:37 +0300
Cc:     edumazet@google.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander Azimov <mitradir@yandex-team.ru>,
        tom@herbertland.com, zeil@yandex-team.ru, davem@davemloft.net
Content-Transfer-Encoding: quoted-printable
Message-Id: <614E2777-315B-4C47-94B8-F6E9D6F3E4B5@yandex-team.ru>
References: <20211025203521.13507-1-hmukos@yandex-team.ru>
 <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-5-hmukos@yandex-team.ru>
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear David, We got the patch reviewed couple of weeks ago, please let us =
know what further steps are required before merge. Thanks, Akhmat.

> On Dec 6, 2021, at 22:11, Akhmat Karakotov <hmukos@yandex-team.ru> =
wrote:
>=20
> Disabling rehash behavior did not affect SYN ACK retransmits because =
hash
> was forcefully changed bypassing the sk_rethink_hash function. This =
patch
> adds a condition which checks for rehash mode before resetting hash.
>=20
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
> net/core/sock.c       | 3 ++-
> net/ipv4/tcp_output.c | 4 +++-
> 2 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/sock.c b/net/core/sock.c
> index daace0d10156..f2515f657974 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1372,7 +1372,8 @@ int sock_setsockopt(struct socket *sock, int =
level, int optname,
> ret =3D -EINVAL;
> break;
> }
> - sk->sk_txrehash =3D (u8)val;
> + /* Paired with READ_ONCE() in tcp_rtx_synack() */
> + WRITE_ONCE(sk->sk_txrehash, (u8)val);
> break;
>=20
> default:
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 6d72f3ea48c4..bbb5f68b947a 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -4108,7 +4108,9 @@ int tcp_rtx_synack(const struct sock *sk, struct =
request_sock *req)
> struct flowi fl;
> int res;
>=20
> - tcp_rsk(req)->txhash =3D net_tx_rndhash();
> + /* Paired with WRITE_ONCE() in sock_setsockopt() */
> + if (READ_ONCE(sk->sk_txrehash) =3D=3D SOCK_TXREHASH_ENABLED)
> + tcp_rsk(req)->txhash =3D net_tx_rndhash();
> res =3D af_ops->send_synack(sk, NULL, &fl, req, NULL, =
TCP_SYNACK_NORMAL,
>  NULL);
> if (!res) {
> --=20
> 2.17.1
>=20

