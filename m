Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C322859F3
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 09:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgJGHyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 03:54:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726041AbgJGHyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 03:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602057242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mA7iF1FIYyYfmzKBPd290C0pBsQJJgx9qGVGQfhXlYg=;
        b=N3QobZ5efEujUSPJ8HDkF+UWlhQ2dUxStqt+EldE4vxfmBfFxuG7TQ+LzA6iUd/FKEW6Ue
        ZpAWxahvlNkZnFbC/M6vUqq9mAqDpU+k/WQ8nynfjLnW4BPGTTqVj6VpaJFrocxNgwSxOY
        BAqRNt1zfX1qSPtuLK7nVTrwoPXaNJw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-7m-jn1DPNFaXchlK0gB17A-1; Wed, 07 Oct 2020 03:53:58 -0400
X-MC-Unique: 7m-jn1DPNFaXchlK0gB17A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20523802B7E;
        Wed,  7 Oct 2020 07:53:57 +0000 (UTC)
Received: from carbon (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67FF255770;
        Wed,  7 Oct 2020 07:53:50 +0000 (UTC)
Date:   Wed, 7 Oct 2020 09:53:48 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Shaun Crampton <shaun@tigera.io>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next V1 3/6] bpf: add BPF-helper for reading MTU
 from net_device via ifindex
Message-ID: <20201007095348.4fb25dfc@carbon>
In-Reply-To: <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com>
References: <160200013701.719143.12665708317930272219.stgit@firesoul>
        <160200018165.719143.3249298786187115149.stgit@firesoul>
        <20201006183302.337a9502@carbon>
        <20201006181858.6003de94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANP3RGe3S4eF=xVkQ22o=sxtW991jmNfq-bVtbKQQaszsLNZSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Oct 2020 18:24:28 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> On Tue, Oct 6, 2020 at 6:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 6 Oct 2020 18:33:02 +0200 Jesper Dangaard Brouer wrote: =20
> > > > +static const struct bpf_func_proto bpf_xdp_mtu_lookup_proto =3D {
> > > > +   .func           =3D bpf_xdp_mtu_lookup,
> > > > +   .gpl_only       =3D true,
> > > > +   .ret_type       =3D RET_INTEGER,
> > > > +   .arg1_type      =3D ARG_PTR_TO_CTX,
> > > > +   .arg2_type      =3D ARG_ANYTHING,
> > > > +   .arg3_type      =3D ARG_ANYTHING,
> > > > +};
> > > > +
> > > > + =20
> >
> > FWIW
> >
> > CHECK: Please don't use multiple blank lines
> > #112: FILE: net/core/filter.c:5566: =20
>=20
> FYI: It would be nice to have a similar function to return a device's
> L2 header size (ie. 14 for ethernet) and/or hwtype.
>=20
> Also, should this be restricted to gpl only?

That is mostly because I copy-pasted it from the fib lookup helper,
which with good reason is GPL.  I would prefer it to be GPL, but given
how simple it is I shouldn't.  Maybe I could argue that my new mtu_check
could be GPL as it does more work.

> [I'm not actually sure, I'm actually fed up with non-gpl code atm, and
> wouldn't be against all bpf code needing to be gpl'ed...]

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

