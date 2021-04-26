Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B9436B07B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 11:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhDZJYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 05:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41351 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232103AbhDZJYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 05:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619429008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNwDXTMHR5xSsbdj83YsrR/X8gyfJkCkZcm5vtKcoOM=;
        b=ftxgKRXao57Ov2mXIc1b6hsD/6QYtczNPblxNrXyFKX48OyFT1AVlUyFF44jZNzbDwXymf
        KtdrX1NGBoV2fFg6IXZi2TGj+hHXRCjj7C71cEfunYySNAQ8X1/ooruM1ZNWj5UcBRPp2P
        EPslwEkbvchWTOZqnRkKv/V8qWMzdzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-o2QUL4IBMAu4_4lC9RJnXg-1; Mon, 26 Apr 2021 05:23:26 -0400
X-MC-Unique: o2QUL4IBMAu4_4lC9RJnXg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CC1783DD25;
        Mon, 26 Apr 2021 09:23:24 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C759459454;
        Mon, 26 Apr 2021 09:23:09 +0000 (UTC)
Date:   Mon, 26 Apr 2021 11:23:08 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        brouer@redhat.com
Subject: Re: [PATCHv9 bpf-next 2/4] xdp: extend xdp_redirect_map with
 broadcast support
Message-ID: <20210426112308.580cf98e@carbon>
In-Reply-To: <20210426060117.GN3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
        <20210422071454.2023282-3-liuhangbin@gmail.com>
        <20210422185332.3199ca2e@carbon>
        <87a6pqfb9x.fsf@toke.dk>
        <20210423185429.126492d0@carbon>
        <20210424010925.GG3465@Leo-laptop-t470s>
        <20210424090129.1b8fe377@carbon>
        <20210426060117.GN3465@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Apr 2021 14:01:17 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Sat, Apr 24, 2021 at 09:01:29AM +0200, Jesper Dangaard Brouer wrote:
> > > > > >> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *=
dev, struct xdp_buff *xdp,
> > > > > >>  	case BPF_MAP_TYPE_DEVMAP:
> > > > > >>  		fallthrough;
> > > > > >>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > > > > >> -		err =3D dev_map_enqueue(fwd, xdp, dev);
> > > > > >> +		map =3D xchg(&ri->map, NULL);     =20
> > > > > >
> > > > > > Hmm, this looks dangerous for performance to have on this fast-=
path.
> > > > > > The xchg call can be expensive, AFAIK this is an atomic operati=
on.     =20
> > > > >=20
> > > > > Ugh, you're right. That's my bad, I suggested replacing the
> > > > > READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange=
 is
> > > > > what it's doing, but I failed to consider the performance implica=
tions
> > > > > of the atomic operation. Sorry about that, Hangbin! I guess this =
should
> > > > > be changed to:
> > > > >=20
> > > > > +		map =3D READ_ONCE(ri->map);
> > > > > +		if (map) {
> > > > > +			WRITE_ONCE(ri->map, NULL);
> > > > > +			err =3D dev_map_enqueue_multi(xdp, dev, map,
> > > > > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > > > > +		} else {
> > > > > +			err =3D dev_map_enqueue(fwd, xdp, dev);
> > > > > +		}   =20
> > > >=20
> > > > This is highly sensitive fast-path code, as you saw Bj=C3=B8rn have=
 been
> > > > hunting nanosec in this area.  The above code implicitly have "map"=
 as
> > > > the likely option, which I don't think it is.   =20
> > >=20
> > > Hi Jesper,
> > >=20
> > > From the performance data, there is only a slightly impact. Do we sti=
ll need
> > > to block the whole patch on this? Or if you have a better solution? =
=20
> >=20
> > I'm basically just asking you to add an unlikely() annotation:
> >=20
> > 	map =3D READ_ONCE(ri->map);
> > 	if (unlikely(map)) {
> > 		WRITE_ONCE(ri->map, NULL);
> > 		err =3D dev_map_enqueue_multi(xdp, dev, map, [...]
> >=20
> > For XDP, performance is the single most important factor!  You say your
> > performance data, there is only a slightly impact, there must be ZERO
> > impact (when your added features is not in use).
> >=20
> > You data:
> >  Version          | Test                                | Generic | Nat=
ive
> >  5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.=
6M
> >  5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.=
3M
> >=20
> > The performance difference 9.6M -> 9.3M is a slowdown of 3.36 nanosec.
> > Bj=C3=B8rn and others have been working really hard to optimize the cod=
e and
> > remove down to 1.5 nanosec overheads.  Thus, introducing 3.36 nanosec
> > added overhead to the fast-path is significant. =20
>=20
> I re-check the performance data. The data
> > Version          | Test                                | Generic | Nati=
ve
> > 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
> > 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3=
M =20
>=20
> is done on version 5.
>=20
> Today I re-did the test, on version 10, with xchg() changed to
> READ_ONCE/WRITE_ONCE. Here is the new data (Generic path data was omitted
> as there is no change)
>=20
> Version          | Test                                | Generic | Native
> 5.12 rc4         | redirect_map        i40e->i40e      |  9.7M
> 5.12 rc4         | redirect_map        i40e->veth      | 11.8M
>=20
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M

Great to see the baseline redirect_map (i40e->i40e) have almost no
impact, only 1.07 ns ((1/9.7-1/9.6)*1000), which is what we want to
see.  (It might be zero as measurements can fluctuate when diff is
below 2ns)


> 5.12 rc4 + patch | redirect_map        i40e->veth      | 11.6M

What XDP program are you running on the inner veth?

> 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.5M

I'm very surprised to see redirect_map multi being so fast (9.5M vs.
9.6M normal map-redir).  I was expecting to see larger overhead, as the
code dev_map_enqueue_clone() would clone the packet in xdpf_clone() via
allocating a new page (dev_alloc_page) and then doing a memcpy().

Looking closer at this patchset, I realize that the test
'redirect_map-multi' is testing an optimization, and will never call
dev_map_enqueue_clone() + xdpf_clone().  IMHO trying to optimize
'redirect_map-multi' to be just as fast as base 'redirect_map' doesn't
make much sense.  If the 'broadcast' call only send a single packet,
then there isn't any reason to call the 'multi' variant.

Does the 'selftests/bpf' make sure to activate the code path that does
cloning?

> 5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.5M
> 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.9M
>=20
> And after add unlikely() in the check path, the new data looks like
>=20
> Version          | Test                                | Native
> 5.12 rc4 + patch | redirect_map        i40e->i40e      |  9.6M
> 5.12 rc4 + patch | redirect_map        i40e->veth      | 11.7M
> 5.12 rc4 + patch | redirect_map multi  i40e->i40e      |  9.4M
> 5.12 rc4 + patch | redirect_map multi  i40e->veth      | 11.4M
> 5.12 rc4 + patch | redirect_map multi  i40e->mlx4+veth |  3.8M
>=20
> So with unlikely(), the redirect_map is a slightly up, while redirect_map
> broadcast has a little drawback. But for the total data it looks this time
> there is no much gap compared with no this patch for redirect_map.
>=20
> Do you think we still need the unlikely() in check path?

Yes.  The call to redirect_map multi is allowed (and expected) to be
slower, because when using it to broadcast packets we expect that
dev_map_enqueue_clone() + xdpf_clone() will get activated, which will
be the dominating overhead.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

