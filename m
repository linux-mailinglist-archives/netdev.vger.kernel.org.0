Return-Path: <netdev+bounces-1751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB7F6FF0BA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:55:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C512281623
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 11:55:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1393B19BCF;
	Thu, 11 May 2023 11:55:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1521FBB
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 11:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85BFC433EF;
	Thu, 11 May 2023 11:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683806126;
	bh=+kvT7/6VOO4REq/h1o93a95WwTTOkKPBCj0EgJq20Cg=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=pn/XbW64EVxVK0nIbzPa2bbd3h+UY5hyF1YUXRtDnCFRF0x/kXk4th2N/IgvigxEL
	 hosxaTpImq/bBXwY6SXmhIV9SRVbb8++fb+VQOTLoy75msLeVb/DSY93RlSC9UVb/d
	 fB+H4jEnb4gBcjT3hjtluHsNpO1w6Ub9NxkSJXSFfxt/RRyXgA2xg6DmLBY/rxoLCY
	 9EcDHKPyzDir71H3xh5pKWRaPl5qmuEqjA8W/WnGFBqZZohtMN0u1BKJZAMq15r636
	 /Epim06tujDJKgyO3zHlbaXa9xGqunohSs4yQ9BKmX2x4Gv67pv5FW8g4/yuEm7znV
	 F0LnSpyZkDdmg==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANn89iJ8Jvi2wk5fOGvkreqcUVN_qs=MJ3mYxtqUGC=jnCgLnw@mail.gmail.com>
References: <20230511093456.672221-1-atenart@kernel.org> <CANn89iJ8Jvi2wk5fOGvkreqcUVN_qs=MJ3mYxtqUGC=jnCgLnw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: tcp: make txhash use consistent for IPv4
From: Antoine Tenart <atenart@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
To: Eric Dumazet <edumazet@google.com>
Date: Thu, 11 May 2023 13:55:23 +0200
Message-ID: <168380612338.9448.16859771930497024762@kwain>

Quoting Eric Dumazet (2023-05-11 12:24:15)
> On Thu, May 11, 2023 at 11:35=E2=80=AFAM Antoine Tenart <atenart@kernel.o=
rg> wrote:
> >
> > Series is divided in two parts. First two commits make the txhash (used
> > for the skb hash in TCP) to be consistent for all IPv4/TCP packets (IPv6
> > doesn't have the same issue). Last two commits improve doc/comment
> > hash-related parts.
> >
> > One example is when using OvS with dp_hash, which uses skb->hash, to
> > select a path. We'd like packets from the same flow to be consistent, as
> > well as the hash being stable over time when using net.core.txrehash=3D=
0.
> > Same applies for kernel ECMP which also can use skb->hash.
> >
>=20
> SGTM, thanks.
>=20
> Reviewed-by: Eric Dumazet <edumazet@google.com>
>=20
> FYI while reviewing your patches, I found that I have to send this fix:
>=20
> I suggest we hold your patch series a bit before this reaches net-next tr=
ee,
> to avoid merge conflicts.

Sure, no problem. Thanks for the review!

> Bug was added in commit f6c0f5d209fa ("tcp: honor SO_PRIORITY in
> TIME_WAIT state")
>=20
>=20
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 39bda2b1066e1d607a59fb79c6305d0ca30cb28d..06d2573685ca993a3a0a89807=
f09d7b5c153cc72
> 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -829,6 +829,9 @@ static void tcp_v4_send_reset(const struct sock
> *sk, struct sk_buff *skb)
>                                    inet_twsk(sk)->tw_priority : sk->sk_pr=
iority;
>                 transmit_time =3D tcp_transmit_time(sk);
>                 xfrm_sk_clone_policy(ctl_sk, sk);
> +       } else {
> +               ctl_sk->sk_mark =3D 0;
> +               ctl_sk->sk_priority =3D 0;
>         }
>         ip_send_unicast_reply(ctl_sk,
>                               skb, &TCP_SKB_CB(skb)->header.h4.opt,
> @@ -836,7 +839,6 @@ static void tcp_v4_send_reset(const struct sock
> *sk, struct sk_buff *skb)
>                               &arg, arg.iov[0].iov_len,
>                               transmit_time);
>=20
> -       ctl_sk->sk_mark =3D 0;
>         xfrm_sk_free_policy(ctl_sk);
>         sock_net_set(ctl_sk, &init_net);
>         __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
> @@ -935,7 +937,6 @@ static void tcp_v4_send_ack(const struct sock *sk,
>                               &arg, arg.iov[0].iov_len,
>                               transmit_time);
>=20
> -       ctl_sk->sk_mark =3D 0;
>         sock_net_set(ctl_sk, &init_net);
>         __TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
>         local_bh_enable();
>

