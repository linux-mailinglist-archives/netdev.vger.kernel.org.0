Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8B930A504
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233179AbhBAKI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:08:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233141AbhBAKIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:08:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612174013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/QAkk6owe21Xxeh5fDlvcKKIXTJvkH9DBGu0Ux0QV3Y=;
        b=VAzmozJR8XvPYChz2UWUdzCrp6oxXmhH/wY/TRNhjMh/NfPXzx4gFAl6F+k0dKWGwOyU5O
        xy2Ey5dJNneiQLdK2m5ygUkn+/1NYeL8RKILSRdeuZCFH2aYqJISlmQCDhFFFhvcwzUYWI
        FNAUue5IzZowwZXK8jcryuj4LZAviHI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-WnXa72axNVaZW8MKHKz7Jw-1; Mon, 01 Feb 2021 05:06:49 -0500
X-MC-Unique: WnXa72axNVaZW8MKHKz7Jw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27878107ACF6;
        Mon,  1 Feb 2021 10:06:48 +0000 (UTC)
Received: from carbon (unknown [10.36.110.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3D5D10016F4;
        Mon,  1 Feb 2021 10:06:35 +0000 (UTC)
Date:   Mon, 1 Feb 2021 11:06:34 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toshiaki.makita1@gmail.com, lorenzo.bianconi@redhat.com,
        toke@redhat.com, Stefano Brivio <sbrivio@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] net: veth: alloc skb in bulk for
 ndo_xdp_xmit
Message-ID: <20210201110634.70be00ba@carbon>
In-Reply-To: <20210129214927.GC20729@lore-desk>
References: <415937741661ac331be09c0e59b4ff1eacfee782.1611861943.git.lorenzo@kernel.org>
        <20210129170216.6a879619@carbon>
        <20210129201728.4322bab0@carbon>
        <20210129214640.GB20729@lore-desk>
        <20210129214927.GC20729@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 22:49:27 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> On Jan 29, Lorenzo Bianconi wrote:
> > On Jan 29, Jesper Dangaard Brouer wrote: =20
> > > On Fri, 29 Jan 2021 17:02:16 +0100
> > > Jesper Dangaard Brouer <brouer@redhat.com> wrote:
> > >  =20
> > > > > +	for (i =3D 0; i < n_skb; i++) {
> > > > > +		struct sk_buff *skb =3D skbs[i];
> > > > > +
> > > > > +		memset(skb, 0, offsetof(struct sk_buff, tail));   =20
> > > >=20
> > > > It is very subtle, but the memset operation on Intel CPU translates
> > > > into a "rep stos" (repeated store) operation.  This operation need =
to
> > > > save CPU-flags (to support being interrupted) thus it is actually
> > > > expensive (and in my experience cause side effects on pipeline
> > > > efficiency).  I have a kernel module for testing memset here[1].
> > > >=20
> > > > In CPUMAP I have moved the clearing outside this loop. But via aski=
ng
> > > > the MM system to clear the memory via gfp_t flag __GFP_ZERO.  This
> > > > cause us to clear more memory 256 bytes, but it is aligned.  Above
> > > > offsetof(struct sk_buff, tail) is 188 bytes, which is unaligned mak=
ing
> > > > the rep-stos more expensive in setup time.  It is below 3-cacheline=
s,
> > > > which is actually interesting and an improvement since last I check=
ed.
> > > > I actually have to re-test with time_bench_memset[1], to know that =
is
> > > > better now. =20
> > >=20
> > > After much testing (with [1]), yes please use gfp_t flag __GFP_ZERO. =
=20
> >=20
> > I run some comparison tests using memset and __GFP_ZERO and with VETH_X=
DP_BATCH
> > set to 8 and 16. Results are pretty close so not completely sure the de=
lta is
> > just a noise:
> >=20
> > - VETH_XDP_BATCH=3D 8 + __GFP_ZERO: ~3.737Mpps
> > - VETH_XDP_BATCH=3D 16 + __GFP_ZERO: ~3.79Mpps
> > - VETH_XDP_BATCH=3D 8 + memset: ~3.766Mpps
> > - VETH_XDP_BATCH=3D 16 + __GFP_ZERO: ~3.765Mpps =20
>=20
> Sorry last line is:
>   - VETH_XDP_BATCH=3D 16 + memset: ~3.765Mpps

Thanks for doing these benchmarks.

=46rom my memset benchmarks we are looking for a 1.66 ns difference(10.463-8.=
803),
which is VERY hard to measure accurately (anything below 2 ns is
extremely hard due to OS noise).

VETH_XDP_BATCH=3D8 __GFP_ZERO (3.737Mpps) -> memset (3.766Mpps)
 - __GFP_ZERO loosing 0.029Mpps and 2.06 ns slower

VETH_XDP_BATCH=3D16 __GFP_ZERO (3.79Mpps) -> memset (3.765Mpps)
 - __GFP_ZERO gaining 0.025Mpps and 1.75 ns faster

I would say this is noise in the measurements.  Even-though batch=3D16
match the expected improvement, batch=3D8 goes in the other direction.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

