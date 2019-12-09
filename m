Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C67117645
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLITuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:50:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53104 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726824AbfLITuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 14:50:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575921021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fixsa2GR2xD9eCWdL7rHvmJlthlJ+BIkVBQqT5TO8Yg=;
        b=AxKYyYiF6jCkPOb1eQETfYCcr1udrN7GQ9bkl0Q3zlcKNxJKxvvsSz7N78to1rYXKB9z4G
        La7ukmNrQimBClE636b9bFh5kRjZvbzAzFId3kAE6Dq+f27NGoFQguzQSR8qlrR4SFaBAU
        42rWEfgs1OYG9W4SFnExnWKi9Lh4c80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-WAsPPC5fPqG8EemL2rsMhQ-1; Mon, 09 Dec 2019 14:50:20 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89846107ACC4;
        Mon,  9 Dec 2019 19:50:18 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5475B6E412;
        Mon,  9 Dec 2019 19:50:12 +0000 (UTC)
Date:   Mon, 9 Dec 2019 20:50:10 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdl?= =?UTF-8?B?bnNlbg==?= 
        <thoiland@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
Message-ID: <20191209205010.153a9060@carbon>
In-Reply-To: <CAJ+HfNhikfpdAi3wC_s72Z-S8iMYUe7=hOBP_jNFQz++jrPgzg@mail.gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
        <20191209180008.72c98c53@carbon>
        <CAJ+HfNhikfpdAi3wC_s72Z-S8iMYUe7=hOBP_jNFQz++jrPgzg@mail.gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: WAsPPC5fPqG8EemL2rsMhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 18:45:12 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> On Mon, 9 Dec 2019 at 18:00, Jesper Dangaard Brouer <brouer@redhat.com> w=
rote:
> >
> > On Mon,  9 Dec 2019 14:55:16 +0100
> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:
> > =20
> > > Performance
> > > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > >
> > > The tests were performed using the xdp_rxq_info sample program with
> > > the following command-line:
> > >
> > > 1. XDP_DRV:
> > >   # xdp_rxq_info --dev eth0 --action XDP_DROP
> > > 2. XDP_SKB:
> > >   # xdp_rxq_info --dev eth0 -S --action XDP_DROP
> > > 3. xdp-perf, from selftests/bpf:
> > >   # test_progs -v -t xdp_perf
> > >
> > >
> > > Run with mitigations=3Dauto
> > > -------------------------
> > >
> > > Baseline:
> > > 1. 22.0 Mpps
> > > 2. 3.8 Mpps
> > > 3. 15 ns
> > >
> > > Dispatcher:
> > > 1. 29.4 Mpps (+34%)
> > > 2. 4.0 Mpps  (+5%)
> > > 3. 5 ns      (+66%) =20
> >
> > Thanks for providing these extra measurement points.  This is good
> > work.  I just want to remind people that when working at these high
> > speeds, it is easy to get amazed by a +34% improvement, but we have to
> > be careful to understand that this is saving approx 10 ns time or
> > cycles.
> >
> > In reality cycles or time saved in #2 (3.8 Mpps -> 4.0 Mpps) is larger
> > (1/3.8-1/4)*1000 =3D 13.15 ns.  Than #1 (22.0 Mpps -> 29.4 Mpps)
> > (1/22-1/29.4)*1000 =3D 11.44 ns. Test #3 keeps us honest 15 ns -> 5 ns =
=3D
> > 10 ns.  The 10 ns improvement is a big deal in XDP context, and also
> > correspond to my own experience with retpoline (approx 12 ns overhead).
> > =20
>=20
> Ok, good! :-)
>=20
> > To Bj=C3=B8rn, I would appreciate more digits on your Mpps numbers, so =
I get
> > more accuracy on my checks-and-balances I described above.  I suspect
> > the 3.8 Mpps -> 4.0 Mpps will be closer to the other numbers when we
> > get more accuracy.
> > =20
>=20
> Ok! Let me re-run them.=20

Well, I don't think you should waste your time re-running these...

It clearly shows a significant improvement.  I'm just complaining that
I didn't have enough digits to do accurate checks-and-balances, they
are close enough that I believe them.


> If you have some spare cycles, yt would be
> great if you could try it out as well on your Mellanox setup.

I'll add it to my TODO list... but no promises.


> Historically you've always been able to get more stable numbers than
> I. :-)
>=20
> > =20
> > > Dispatcher (full; walk all entries, and fallback):
> > > 1. 20.4 Mpps (-7%)
> > > 2. 3.8 Mpps
> > > 3. 18 ns     (-20%)
> > >
> > > Run with mitigations=3Doff
> > > ------------------------
> > >
> > > Baseline:
> > > 1. 29.6 Mpps
> > > 2. 4.1 Mpps
> > > 3. 5 ns
> > >
> > > Dispatcher:
> > > 1. 30.7 Mpps (+4%)
> > > 2. 4.1 Mpps
> > > 3. 5 ns =20
> >
> > While +4% sounds good, but could be measurement noise ;-)
> >
> >  (1/29.6-1/30.7)*1000 =3D 1.21 ns
> >
> > As both #3 says 5 ns.
> > =20
>=20
> True. Maybe that simply hints that we shouldn't use the dispatcher here?

No. I actually think it is worth exposing this code as much as
possible. And if it really is 1.2 ns improvement, then I'll gladly take
that as well ;-)


I think this is awesome work! -- thanks for doing this!!!
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

