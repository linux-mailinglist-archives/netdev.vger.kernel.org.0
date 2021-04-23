Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2780369776
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 18:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbhDWQzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 12:55:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59115 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231522AbhDWQzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 12:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619196898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFxz5Zzs7llrIJ0AdPOjAD3crmXIVLE/A0MxWzI0Aeg=;
        b=Kvu9SUVxn/RaKNnaxBhrXETi+pyo2jhQqaey3qaXvXTyYoVCBWzQjdIiNutqwi4Xe790eO
        nqgmC+OMZF8JcVfrfVvWgXex3u0yjA68pwFDPmaIb0eJQxqtBOkgebbOAWPLRs9hAo/n6k
        N2jO6GFLp5MbdDG8z+uCpcreA8vGbvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-zQJN5xTOOAaKRbp0h_W9Ew-1; Fri, 23 Apr 2021 12:54:56 -0400
X-MC-Unique: zQJN5xTOOAaKRbp0h_W9Ew-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FC98107ACCD;
        Fri, 23 Apr 2021 16:54:54 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E20E71992D;
        Fri, 23 Apr 2021 16:54:30 +0000 (UTC)
Date:   Fri, 23 Apr 2021 18:54:29 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
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
Message-ID: <20210423185429.126492d0@carbon>
In-Reply-To: <87a6pqfb9x.fsf@toke.dk>
References: <20210422071454.2023282-1-liuhangbin@gmail.com>
        <20210422071454.2023282-3-liuhangbin@gmail.com>
        <20210422185332.3199ca2e@carbon>
        <87a6pqfb9x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 20:02:18 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Thu, 22 Apr 2021 15:14:52 +0800
> > Hangbin Liu <liuhangbin@gmail.com> wrote:
> > =20
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index cae56d08a670..afec192c3b21 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c =20
> > [...] =20
> >>  int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
> >>  		    struct bpf_prog *xdp_prog)
> >>  {
> >> @@ -3933,6 +3950,7 @@ int xdp_do_redirect(struct net_device *dev, stru=
ct xdp_buff *xdp,
> >>  	enum bpf_map_type map_type =3D ri->map_type;
> >>  	void *fwd =3D ri->tgt_value;
> >>  	u32 map_id =3D ri->map_id;
> >> +	struct bpf_map *map;
> >>  	int err;
> >> =20
> >>  	ri->map_id =3D 0; /* Valid map id idr range: [1,INT_MAX[ */
> >> @@ -3942,7 +3960,12 @@ int xdp_do_redirect(struct net_device *dev, str=
uct xdp_buff *xdp,
> >>  	case BPF_MAP_TYPE_DEVMAP:
> >>  		fallthrough;
> >>  	case BPF_MAP_TYPE_DEVMAP_HASH:
> >> -		err =3D dev_map_enqueue(fwd, xdp, dev);
> >> +		map =3D xchg(&ri->map, NULL); =20
> >
> > Hmm, this looks dangerous for performance to have on this fast-path.
> > The xchg call can be expensive, AFAIK this is an atomic operation. =20
>=20
> Ugh, you're right. That's my bad, I suggested replacing the
> READ_ONCE()/WRITE_ONCE() pair with the xchg() because an exchange is
> what it's doing, but I failed to consider the performance implications
> of the atomic operation. Sorry about that, Hangbin! I guess this should
> be changed to:
>=20
> +		map =3D READ_ONCE(ri->map);
> +		if (map) {
> +			WRITE_ONCE(ri->map, NULL);
> +			err =3D dev_map_enqueue_multi(xdp, dev, map,
> +						    ri->flags & BPF_F_EXCLUDE_INGRESS);
> +		} else {
> +			err =3D dev_map_enqueue(fwd, xdp, dev);
> +		}

This is highly sensitive fast-path code, as you saw Bj=C3=B8rn have been
hunting nanosec in this area.  The above code implicitly have "map" as
the likely option, which I don't think it is.


> (and the same for the generic-XDP path, of course)
>=20
> -Toke
>=20

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

