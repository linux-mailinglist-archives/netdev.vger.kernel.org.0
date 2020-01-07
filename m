Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B145313270A
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 14:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgAGNGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 08:06:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51502 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727834AbgAGNGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 08:06:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578402361;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S5wrsc6cj3lu0uim+5og1UonIhX7VGhgfArIyUdi8+w=;
        b=JIS2+MNbcwzdPf94WuQKUdZRPzktrgWfS1EEcJxBeN1LRk5oTAvnJ4Yr7T57aV4mWPdKWv
        SClssnjxd97o5Qj8NuBLEJuUnOzWCq+wNXqFE6aLN7GKa6kOA1XgvYeBDB1JgrXvwV+CMx
        UUOv9iIfhxkg+nOmjt+uZbix9EPQCkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-fm3HPNk3Mymljxl49UolJw-1; Tue, 07 Jan 2020 08:05:56 -0500
X-MC-Unique: fm3HPNk3Mymljxl49UolJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ABF0E801E72;
        Tue,  7 Jan 2020 13:05:54 +0000 (UTC)
Received: from carbon (ovpn-200-37.brq.redhat.com [10.40.200.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 68E7F7DB56;
        Tue,  7 Jan 2020 13:05:45 +0000 (UTC)
Date:   Tue, 7 Jan 2020 14:05:44 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 0/8] Simplify
 xdp_do_redirect_map()/xdp_do_flush_map() and XDP maps
Message-ID: <20200107140544.6b860e28@carbon>
In-Reply-To: <87zhezik3o.fsf@toke.dk>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
        <CAADnVQL1x8AJmCOjesA_6Z3XprFVEdWgbREfpn3CC-XO8k4PDA@mail.gmail.com>
        <20191220084651.6dacb941@carbon>
        <20191220102615.45fe022d@carbon>
        <87mubn2st4.fsf@toke.dk>
        <CAJ+HfNhLDi1MJAughKFCVUjSvdOfPUcbvO9=RXmXQBS6Q3mv3w@mail.gmail.com>
        <87zhezik3o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jan 2020 12:25:47 +0100
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>=20
> > On Fri, 20 Dec 2019 at 11:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote: =20
> >>
> >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> >> =20
> > [...] =20
> >> > I have now went over the entire patchset, and everything look perfec=
t,
> >> > I will go as far as saying it is brilliant.  We previously had the
> >> > issue, that using different redirect maps in a BPF-prog would cause =
the
> >> > bulking effect to be reduced, as map_to_flush cause previous map to =
get
> >> > flushed. This is now solved :-) =20
> >>
> >> Another thing that occurred to me while thinking about this: Now that =
we
> >> have a single flush list, is there any reason we couldn't move the
> >> devmap xdp_bulk_queue into struct net_device? That way it could also be
> >> used for the non-map variant of bpf_redirect()?
> >> =20
> >
> > Indeed! (At least I don't see any blockers...) =20
>=20
> Cool, that's what I thought. Maybe I'll give that a shot, then, unless
> you beat me to it ;)
=20
Generally sounds like a good idea.

It this only for devmap xdp_bulk_queue?

Some gotchas off the top of my head.

The cpumap also have a struct xdp_bulk_queue, which have a different
layout. (sidenote: due to BTF we likely want rename that).

If you want to generalize this across all redirect maps type. You
should know, that it was on purpose that I designed the bulking to be
map specific, because that allowed each map to control its own optimal
bulking.  E.g. devmap does 16 frames bulking, cpumap does 8 frames (as
it matches sending 1 cacheline into underlying ptr_ring), xskmap does
64 AFAIK (which could hurt-latency, but that is another discussion).

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

