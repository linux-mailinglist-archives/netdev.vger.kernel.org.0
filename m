Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC68A64D27
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 22:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbfGJUER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 16:04:17 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44932 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbfGJUER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 16:04:17 -0400
Received: by mail-qk1-f193.google.com with SMTP id d79so2918319qke.11
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 13:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3X+PjbR5ihWHqnoz8x+f5cGh0rUvMPAzh6aNHO3rqyc=;
        b=s//qS0hMZYlaQKMozvaanq7wIIoYsOvriJ2yf3VlwIL8we/2itDeUw+VBo+Dy5avM/
         8n6tbarUllDyFl66SM4jGGbcdddh/YMpaH2GPlH6MiD8QmQVWFHnlJm+M2iajmRU0Wrm
         pngWROrca8yKlsLPk1TCzSlQyjJmc3CsoxCr0g3/B0oUCpNomAs4jOunCyQKOd6NTjeB
         KEOE1+aY/dCe8hMNoSzw4HjLIRUERbBOZIJtOn0wONLjEAL7SRJFgLgn7jvhHzBfwdL9
         xU3JC49fgDByRBYnSfVfmwk4XMTcvEuFBJsShnr9yMXA1vVAyf1ziQt8MS6H5PvuNxr3
         3N6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3X+PjbR5ihWHqnoz8x+f5cGh0rUvMPAzh6aNHO3rqyc=;
        b=LfXvuxLSOywuyXf4IGFdbP/Rq0kZsYxsByOK+tJSSjuSjRmwh47p2vS6UhG/0BnXKL
         Au/A7X0r/R3stG4thf8dc/bF4+KE0zQKm707craKp2qoNBlCQMWV52yPd3I7gj5q+R3o
         Qv6etLDicanJlsXABiyAKkbOTPHK0ftEf08fLed8VWqwVeqP1JZwj98lgAhLM8NsKQkL
         J6uwpKSZN0IM597DOTilqEO9tlLyyb7UbYu7JpGnXqzor2mwLFJRBtoi+au82lu41ZIx
         WroPqofAchHINWWVw3ZOpGhtdYUwx5gdKfj/RG2rIxcmgN1H5e5Ns3akv8ZaPEABCi+J
         gaNg==
X-Gm-Message-State: APjAAAXxTtfBa+P8x3nkUVUO5D4Rqma1+grLUfJT9hYWVzcm4TcNgq1P
        I5+JHHoj6p4eJGg4BoEBKjfosw==
X-Google-Smtp-Source: APXvYqw8aLKHWDkk56Mk9SRRS+o28NhFgiCSrBSqCVeu2fleZaVpL3chIJkHqWiVHx4fIcm6o7ECJw==
X-Received: by 2002:a37:f90f:: with SMTP id l15mr24468224qkj.480.1562789056483;
        Wed, 10 Jul 2019 13:04:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d31sm1830794qta.39.2019.07.10.13.04.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 13:04:16 -0700 (PDT)
Date:   Wed, 10 Jul 2019 13:04:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 2/6] bpf: tls fix transition through disconnect
 with close
Message-ID: <20190710130411.08c54ddd@cakuba.netronome.com>
In-Reply-To: <20190710123417.2157a459@cakuba.netronome.com>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
        <156261324561.31108.14410711674221391677.stgit@ubuntu3-kvm1>
        <20190709194525.0d4c15a6@cakuba.netronome.com>
        <5d255dececd33_1b7a2aec940d65b45@john-XPS-13-9370.notmuch>
        <20190710123417.2157a459@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jul 2019 12:34:17 -0700, Jakub Kicinski wrote:
> > > > +		if (sk->sk_prot->unhash)
> > > > +			sk->sk_prot->unhash(sk);
> > > > +	}
> > > > +
> > > > +	ctx =3D tls_get_ctx(sk);
> > > > +	if (ctx->tx_conf =3D=3D TLS_SW || ctx->rx_conf =3D=3D TLS_SW)
> > > > +		tls_sk_proto_cleanup(sk, ctx, timeo);

Do we still need to hook into unhash? With patch 6 in place perhaps we
can just do disconnect =F0=9F=A5=BA

cleanup is going to kick off TX but also:

	if (unlikely(sk->sk_write_pending) &&
	    !wait_on_pending_writer(sk, &timeo))
		tls_handle_open_record(sk, 0);

Are we guaranteed that sk_write_pending is 0?  Otherwise
wait_on_pending_writer is hiding yet another release_sock() :(

> > > > +	icsk->icsk_ulp_data =3D NULL;   =20
> > >=20
> > > I think close only starts checking if ctx is NULL in patch 6.
> > > Looks like some chunks of ctx checking/clearing got spread to
> > > patch 1 and some to patch 6.   =20
> >=20
> > Yeah, I thought the patches were easier to read this way but
> > maybe not. Could add something in the commit log. =20
>=20
> Ack! Let me try to get a full grip of patches 2 and 6 and come back=20
> to this.
>=20
> > > > +	tls_ctx_free_wq(ctx);
> > > > +
> > > > +	if (ctx->unhash)
> > > > +		ctx->unhash(sk);
> > > > +}
> > > > +
> > > >  static void tls_sk_proto_close(struct sock *sk, long timeout)
> > > >  {
> > > >  	struct tls_context *ctx =3D tls_get_ctx(sk);   =20

