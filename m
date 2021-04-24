Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E554E369FEB
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 09:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhDXHC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 03:02:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhDXHC2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 03:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619247709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8XLwy8kqxeYQ9e51ZlWT1aEPp0xe58DQ+7TgxaQsEAI=;
        b=Z+vUkJZM5EcYTV09Yvf9N6X6HcFhc/SkkU1JIBJYzMPwlzWPcPmcjN34wzNp941D8CzMlG
        uCYjDIIfSxWD9FZywf8iKQduuHUT1oXNvBWdX7h600ZT/wdakHc97D8XOwbdm03XpAlEAH
        4HD25GEt0hTkJQwoQI7dDuO1lHxdjxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-VJTHMsaAN4O8n2Q0HH7i0Q-1; Sat, 24 Apr 2021 03:01:47 -0400
X-MC-Unique: VJTHMsaAN4O8n2Q0HH7i0Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6CB38026B1;
        Sat, 24 Apr 2021 07:01:44 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A13B710027A5;
        Sat, 24 Apr 2021 07:01:30 +0000 (UTC)
Date:   Sat, 24 Apr 2021 09:01:29 +0200
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
Message-ID: <20210424090129.1b8fe377@carbon>
In-Reply-To: <20210424010925.GG3465@Leo-laptop-t470s>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
        <20210422071454.2023282-3-liuhangbin@gmail.com>
        <20210422185332.3199ca2e@carbon>
        <87a6pqfb9x.fsf@toke.dk>
        <20210423185429.126492d0@carbon>
        <20210424010925.GG3465@Leo-laptop-t470s>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 09:09:25 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> On Fri, Apr 23, 2021 at 06:54:29PM +0200, Jesper Dangaard Brouer wrote:
> > On Thu, 22 Apr 2021 20:02:18 +0200
> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
> >  =20
> > > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > >  =20
> > > > On Thu, 22 Apr 2021 15:14:52 +0800
> > > > Hangbin Liu <liuhangbin@gmail.com> wrote:
> > > >   =20
> > > >> diff --git a/net/core/filter.c b/net/core/filter.c
> > > >> index cae56d08a670..afec192c3b21 100644
> > > >> --- a/net/core/filter.c
> > > >> +++ b/net/core/filter.c   =20
> > > > [...]   =20
> > > >>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> > > >>  		    struct bpf_prog *xdp_prog)
> > > >>  {
> > > >> @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, =
struct xdp_buff *xdp,
> > > >>  	enum bpf_map_type map_type =3D ri->map_type;
> > > >>  	void *fwd =3D ri->tgt_value;
> > > >>  	u32 map_id =3D ri->map_id;
> > > >> +	struct bpf_map *map;
> > > >>  	int err;
> > > >> =20
> > > >>  	ri->map_id =3D 0; /* Valid map id idr range: [1,INT_MAX[ */
> > > >> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev,=
 struct xdp_buff *xdp,
> > > >>  	case BPF_MAP_TYPE_DEVMAP:
> > > >>  		fallthrough;
> > > >>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> > > >> -		err =3D dev_map_enqueue(fwd, xdp, dev);
> > > >> +		map =3D xchg(&ri->map, NULL);   =20
> > > >
> > > > Hmm, this looks dangerous for performance to have on this fast-path.
> > > > The xchg call can be expensive, AFAIK this is an atomic operation. =
  =20
> > >=20
> > > Ugh, you're right. That's my bad, I suggested replacing the
> > > READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange is
> > > what it's doing, but I failed to consider the performance implications
> > > of the atomic operation. Sorry about that, Hangbin! I guess this shou=
ld
> > > be changed to:
> > >=20
> > > +		map =3D READ_ONCE(ri->map);
> > > +		if (map) {
> > > +			WRITE_ONCE(ri->map, NULL);
> > > +			err =3D dev_map_enqueue_multi(xdp, dev, map,
> > > +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> > > +		} else {
> > > +			err =3D dev_map_enqueue(fwd, xdp, dev);
> > > +		} =20
> >=20
> > This is highly sensitive fast-path code, as you saw Bj=C3=B8rn have been
> > hunting nanosec in this area.  The above code implicitly have "map" as
> > the likely option, which I don't think it is. =20
>=20
> Hi Jesper,
>=20
> From the performance data, there is only a slightly impact. Do we still n=
eed
> to block the whole patch on this? Or if you have a better solution?

I'm basically just asking you to add an unlikely() annotation:

	map =3D READ_ONCE(ri->map);
	if (unlikely(map)) {
		WRITE_ONCE(ri->map, NULL);
		err =3D dev_map_enqueue_multi(xdp, dev, map, [...]

For XDP, performance is the single most important factor!  You say your
performance data, there is only a slightly impact, there must be ZERO
impact (when your added features is not in use).

You data:
 Version          | Test                                | Generic | Native
 5.12 rc4         | redirect_map        i40e->i40e      |    1.9M |  9.6M
 5.12 rc4 + patch | redirect_map        i40e->i40e      |    1.9M |  9.3M

The performance difference 9.6M -> 9.3M is a slowdown of 3.36 nanosec.
Bj=C3=B8rn and others have been working really hard to optimize the code and
remove down to 1.5 nanosec overheads.  Thus, introducing 3.36 nanosec
added overhead to the fast-path is significant.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

