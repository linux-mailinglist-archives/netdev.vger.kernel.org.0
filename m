Return-Path: <netdev+bounces-4417-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C2D70CA2D
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:00:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0843F2810BD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D370171CD;
	Mon, 22 May 2023 20:00:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97B3171BB
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22C05C433D2;
	Mon, 22 May 2023 20:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684785651;
	bh=ekm02Nq7Y+tqQ7NAjiVfSTxDpTsJhS+SYqbRxSQUg6E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oJk5FNT0u3LqtZs/5wAfSJIk6KiBMDlXg761Z2uD0vBvPAHy6mjTdZquU7uqVS26R
	 ip7Okol/rrgUPzlXV2+fkcQo6wCl3+T+yauITs5hleUREc49UvPHW2oGVfeJhPVCNL
	 80kZIO0cReb/VETXRxRuCQOxuZ3ErXi7hmkdrGT9aooBYsCpKiC4tYoMLalgIWASbD
	 sqPd1vOgmdIJ+f6VttGIY8BOsCSDwbH8JSi5MUIKk99MIDWsAYSDyQ4xn1LVm+FprJ
	 t+vheft+08382qYLiXb5C8H/hNCj7MT5TZQwyKUTd4ScscUC83AulTW508j7kbufjU
	 Fxhk1zBcv1CUg==
Date: Mon, 22 May 2023 13:00:50 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: Simon Horman <simon.horman@corigine.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Alexander Aring
 <alex.aring@gmail.com>, David Lebrun <david.lebrun@uclouvain.be>,
 netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 1/3] ipv6: exthdrs: fix potential use-after-free in
 ipv6_rpl_srh_rcv()
Message-ID: <20230522130050.6fa160f6@kernel.org>
In-Reply-To: <CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
References: <20230517213118.3389898-1-edumazet@google.com>
	<20230517213118.3389898-2-edumazet@google.com>
	<ZGZavH7hxiq/pkF8@corigine.com>
	<CANn89iJofjC=aqSu6X9itW8VQXTSFUOiAmBB2Zzuw-6kqTnwzA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 21 May 2023 20:22:16 +0200 Eric Dumazet wrote:
> On Thu, May 18, 2023 at 7:05=E2=80=AFPM Simon Horman <simon.horman@corigi=
ne.com> wrote:
> > Not far below this line there is a call to pskb_pull():
> >
> >                 if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
> >                         int offset =3D (hdr->hdrlen + 1) << 3;
> >
> >                         skb_postpull_rcsum(skb, skb_network_header(skb),
> >                                            skb_network_header_len(skb));
> >
> >                         if (!pskb_pull(skb, offset)) {
> >                                 kfree_skb(skb);
> >                                 return -1;
> >                         }
> >                         skb_postpull_rcsum(skb, skb_transport_header(sk=
b),
> >                                            offset);
> >
> > Should hdr be reloaded after the call to pskb_pull() too? =20
>=20
> I do not think so, because @hdr is not used between this pskb_pull()
> and the return -1:
>=20
>        if (hdr->nexthdr =3D=3D NEXTHDR_IPV6) {
>             int offset =3D (hdr->hdrlen + 1) << 3;
>=20
>             skb_postpull_rcsum(skb, skb_network_header(skb),
>                        skb_network_header_len(skb));
>=20
>             if (!pskb_pull(skb, offset)) {
>                 kfree_skb(skb);
>                 return -1;
>             }
>             skb_postpull_rcsum(skb, skb_transport_header(skb),
>                        offset);
>=20
>             skb_reset_network_header(skb);
>             skb_reset_transport_header(skb);
>             skb->encapsulation =3D 0;
>=20
>             __skb_tunnel_rx(skb, skb->dev, net);
>=20
>             netif_rx(skb);
>             return -1;
>         }

Hum, there's very similar code in ipv6_srh_rcv() (a different function
but with a very similar name) which calls pskb_pull() and then checks
if hdr->nexthdr is v4. I'm guessing that's the one Simon was referring
to.

