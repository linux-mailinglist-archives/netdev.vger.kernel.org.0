Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6D12D0FCB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgLGL4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:56:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27355 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726188AbgLGL4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607342115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RFxHsnImOflCZF1OXAJjc3KHnp1DAGQjdGBQW7WJyfU=;
        b=LuP/ePgV/hGQBHOlSCsifpzeB9KwibV67RYuL4Ffhx6bL9E5tILwtaFuQCqZwinsk5uXel
        ei95uFk0j3LSi90DdswigNhVnp8E9L9WMbli3MdFwQ3M+BZPFf3k1vGXH6/XKsiU5NV+O4
        c7I5PcFhE3Phnt7Agk6lHbCd/VEax3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-1vbLW6_MOg2laIdy23Kp7w-1; Mon, 07 Dec 2020 06:55:11 -0500
X-MC-Unique: 1vbLW6_MOg2laIdy23Kp7w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADB8F801FDB;
        Mon,  7 Dec 2020 11:55:08 +0000 (UTC)
Received: from carbon (unknown [10.36.110.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A50C60C4D;
        Mon,  7 Dec 2020 11:54:55 +0000 (UTC)
Date:   Mon, 7 Dec 2020 12:54:54 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>, brouer@redhat.com,
        Saeed Mahameed <saeed@kernel.org>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201207125454.3883d315@carbon>
In-Reply-To: <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204102901.109709-2-marekx.majtyka@intel.com>
        <878sad933c.fsf@toke.dk>
        <20201204124618.GA23696@ranger.igk.intel.com>
        <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
        <87pn3p7aiv.fsf@toke.dk>
        <eb305a4f-c189-6b32-f718-6e709ef0fa55@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 23:19:55 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 12/4/20 6:20 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Daniel Borkmann <daniel@iogearbox.net> writes: =20
> [...]
> >> We tried to standardize on a minimum guaranteed amount, but unfortunat=
ely not
> >> everyone seems to implement it, but I think it would be very useful to=
 query
> >> this from application side, for example, consider that an app inserts =
a BPF
> >> prog at XDP doing custom encap shortly before XDP_TX so it would be us=
eful to
> >> know which of the different encaps it implements are realistically pos=
sible on
> >> the underlying XDP supported dev. =20
> >=20
> > How many distinct values are there in reality? Enough to express this in
> > a few flags (XDP_HEADROOM_128, XDP_HEADROOM_192, etc?), or does it need
> > an additional field to get the exact value? If we implement the latter
> > we also run the risk of people actually implementing all sorts of weird
> > values, whereas if we constrain it to a few distinct values it's easier
> > to push back against adding new values (as it'll be obvious from the
> > addition of new flags). =20
>=20
> It's not everywhere straight forward to determine unfortunately, see also=
 [0,1]
> as some data points where Jesper looked into in the past, so in some case=
s it
> might differ depending on the build/runtime config..
>=20
>    [0] https://lore.kernel.org/bpf/158945314698.97035.5286827951225578467=
.stgit@firesoul/
>    [1] https://lore.kernel.org/bpf/158945346494.97035.1280940041456606181=
5.stgit@firesoul/

Yes, unfortunately drivers have already gotten creative in this area,
and variations have sneaked in.  I remember that we were forced to
allow SFC driver to use 128 bytes headroom, to avoid a memory
corruption. I tried hard to have the minimum 192 bytes as it is 3
cachelines, but I failed to enforce this.

It might be valuable to expose info on the drivers headroom size, as
this will allow end-users to take advantage of this (instead of having
to use the lowest common headroom) and up-front in userspace rejecting
to load on e.g. SFC that have this annoying limitation.

BUT thinking about what the drivers headroom size MEANS to userspace,
I'm not sure it is wise to give this info to userspace.  The
XDP-headroom is used for several kernel internal things, that limit the
available space for growing packet-headroom.  E.g. (1) xdp_frame is
something that we likely need to grow (even-though I'm pushing back),
E.g. (2) metadata area which Saeed is looking to populate from driver
code (also reduce packet-headroom for encap-headers).  So, userspace
cannot use the XDP-headroom size to much...

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

