Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F242B8929
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKSAtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:49:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgKSAtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:49:16 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B11EE246B2;
        Thu, 19 Nov 2020 00:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605746955;
        bh=IRFC16mum/ZyjCJCIjUUxatulzNAKFBXEt4TcpckxG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lK5xTuJCgaOkr8mlTw5x0BLbKZctRsPH/oxz9HYtDnVsjzwf5OpR/O54LR0hZMu+L
         uS6ZvRasnII7aiESJ1apQoi2uzXUwKWYo1iLX+SLWjBAtq1Ye3pWidtxPnIV5msB94
         6Rm/phElVoPi6Tohh054oClS3vRugplXM56vzb2E=
Date:   Wed, 18 Nov 2020 16:49:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net] net/tls: missing received data after fast remote close
Message-ID: <20201118164913.3b8a34f3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <12e61d3c-cc7d-71a7-f3be-4b796986a4d5@novek.ru>
References: <1605440628-1283-1-git-send-email-vfedorenko@novek.ru>
        <20201117143847.2040f609@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <71f25f4d-a92c-8c56-da34-9d6f7f808c18@novek.ru>
        <20201117175344.2a29859a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <33ede124-583b-4bdd-621b-638bbca1a6c8@novek.ru>
        <20201118082336.6513c6c0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <3c3f9b9d-0fef-fb62-25f8-c9f17ec43a69@novek.ru>
        <20201118153931.43898a9a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <12e61d3c-cc7d-71a7-f3be-4b796986a4d5@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 00:26:52 +0000 Vadim Fedorenko wrote:
> > Damn, you may be seeing some problem I'm missing again ;) Running
> > __unparse can be opportunistic, if it doesn't parse anything that's
> > fine. I was thinking:
> >
> > diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> > index 95ab5545a931..6478bd968506 100644
> > --- a/net/tls/tls_sw.c
> > +++ b/net/tls/tls_sw.c
> > @@ -1295,6 +1295,10 @@ static struct sk_buff *tls_wait_data(struct sock=
 *sk, struct sk_psock *psock,
> >                          return NULL;
> >                  }
> >  =20
> > +               __strp_unpause(&ctx->strp);
> > +               if (ctx->recv_pkt)
> > +                       return ctx->recv_pkt;
> > +
> >                  if (sk->sk_shutdown & RCV_SHUTDOWN)
> >                          return NULL;
> >  =20
> > Optionally it would be nice if unparse cancelled the work if it managed
> > to parse the record out. =20
> Oh, simple and fine solution. But is it better to unpause parser conditio=
nally when
> there is something in the socket queue? Otherwise this call will be just =
wasting
> cycles. Maybe like this:
>=20
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 2fe9e2c..97c5f6e 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1295,6 +1295,12 @@ static struct sk_buff *tls_wait_data(struct sock *=
sk,=20
> struct sk_psock *psock,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return N=
ULL;
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 }
>=20
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 if (!skb_queue_empty(&sk->sk_receive_queue)) {
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __strp_unpause=
(&ctx->strp);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ctx->recv_=
pkt)
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return ctx->recv_pkt;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 }
> +
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (sk->sk_shutdown & RCV_SHUTDOWN)
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return N=
ULL;
>=20

LGTM!
