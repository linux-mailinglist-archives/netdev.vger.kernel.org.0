Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96417268CD6
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgINOGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:06:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43512 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgINOGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 10:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600092355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gk334R4fsCr7dqDGBhPvWiWKV1+Q1rVGII2Qq9VR9CA=;
        b=Lb0Oqr3fokGZofHROm2q8vNLN6lCErhi655vT6MNFk+GmZg1/Zf/35UypQoYQi9wUDvesU
        UbNSxRJbppbNunLomHB8zivY6PBItdfKacxk1Bi7oKtHUZL45wmB6a88TNYaEyXjAgLelJ
        7vygU45wJ3E0DDBHLiUoiAyi1uT14Uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-bNoGctgNNfauZhcH7Qy-Lg-1; Mon, 14 Sep 2020 10:05:49 -0400
X-MC-Unique: bNoGctgNNfauZhcH7Qy-Lg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A8C21800D42;
        Mon, 14 Sep 2020 14:05:48 +0000 (UTC)
Received: from carbon (unknown [10.40.208.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 149E35DA85;
        Mon, 14 Sep 2020 14:05:39 +0000 (UTC)
Date:   Mon, 14 Sep 2020 16:05:38 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] bpf: don't check against device MTU in
 __bpf_skb_max_len
Message-ID: <20200914160538.2bd51893@carbon>
In-Reply-To: <CANP3RGfjUOoVH152VHLXL3y7mBsF+sUCqEZgGAMdeb9_r_Z-Bw@mail.gmail.com>
References: <159921182827.1260200.9699352760916903781.stgit@firesoul>
        <20200904163947.20839d7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200907160757.1f249256@carbon>
        <CANP3RGfjUOoVH152VHLXL3y7mBsF+sUCqEZgGAMdeb9_r_Z-Bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Maze,

Thanks for getting back to me, I appreciate that a lot.
More inline below:

On Thu, 10 Sep 2020 13:00:12 -0700
Maciej =C5=BBenczykowski <maze@google.com> wrote:

> All recent Android R common kernels are currently carrying the
> following divergence from upstream:
>=20
> https://android.googlesource.com/kernel/common/+/194a1bf09a7958551a9e2dc9=
47bdfe3f8be8eca8%5E%21/
>=20
> static u32 __bpf_skb_max_len(const struct sk_buff *skb)
>  {
> - return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -  SKB_MAX_ALLOC;
> + if (skb_at_tc_ingress(skb) || !skb->dev)
> + return SKB_MAX_ALLOC;
> + return skb->dev->mtu + skb->dev->hard_header_len;
>  }

Thanks for sharing that Android now have this out-of-tree patch. I'm
obviously annoyed that this was not upstreamed, as it hurts both you
and me, but we do live in an imperfect world ;)


> There wasn't agreement on how to handle this upstream because some
> folks thought this check was useful...
> Myself - I'm not entirely certain...
> I'd like to be able to test for (something like) this, yes, but the
> way it's done now is kind of pointless...
> It breaks for gso packets anyway - it's not true that a gso packet can
> just ignore the mtu check, you do actually need to check individual
> gso segments are sufficiently small...
> You need to check against the right interface, which again in the
> presence of bpf redirect it currently utterly fails.

I agree that the current check is done against the wrong interface.

> Checking on receive just doesn't seem useful, so what if I want to
> increase packet size that arrives at the stack?

It seems very practical to allow increase packet size of received
packet, also for local netstack deliver.  (e.g allowing to add encap
headers, without being limited to RX device MTU).


> I also don't understand where SKB_MAX_ALLOC even comes from... skb's
> on lo/veth can be 64KB not SKB_MAX_ALLOC (which ifirc is 16KB).

It was John that added the 16KiB SKB_MAX_ALLOC limit...
Why this value John?


> I think maybe there's now sufficient access to skb->len &
> gso_segs/size to implement this in bpf instead of relying on the
> kernel checking it???
> But that might be slow...
>=20
> It sounded like it was trending towards some sort of larger scale refacto=
ring.
>=20
> I haven't had the opportunity to take another look at this since then.
> I'm not at all sure what would break if we just utterly deleted these
> pkt too big > mtu checks.

I'm looking at the code, and TC-ingress redirect to TC-egress and
following code into driver (ixgbe) it does look like we don't have
anything that limit/check the MTU before sending it out the driver (and
the specific driver also didn't limit this).

Thus, I think this patch is not enough on its own.  We/I likely need to
move the MTU check (instead of simply removing it), but based on the
egress device, and not the ingress device.  I will look more into this.


> In general in my experience bpf poorly handles gso and mtu and this is
> an area in need of improvement.
> I've been planning to get around to this, but am currently busy with a
> bazillion other higher priority things :-(
>
> Like trying to figure out whether XDP is even usable with real world
> hardware limitations (currently the answer is still leaning towards
> no, though there was some slightly positive news in the past few
> days).

Getting XDP support in all the different Android drivers seems like an
impossible task.  And you don't want to use generic-XDP, because it
will very likely cause a SKB re-allocation and copy of the data.

I think TC-BPF will likely be the better choice in the Android ecosystem.


> And whether we can even reach our performance goals with
> jit'ed bpf... or do we need to just write it in kernel C... :-(

My experience is that Jit'ed BPF code is super fast, also for the ARM
64-bit experiments:

 https://github.com/xdp-project/xdp-project/tree/master/areas/arm64

--Jesper

=20
> On Mon, Sep 7, 2020 at 7:08 AM Jesper Dangaard Brouer <brouer@redhat.com>=
 wrote:
> >
> > On Fri, 4 Sep 2020 16:39:47 -0700
> > Jakub Kicinski <kuba@kernel.org> wrote:
> > =20
> > > On Fri, 04 Sep 2020 11:30:28 +0200 Jesper Dangaard Brouer wrote: =20
> > > > @@ -3211,8 +3211,7 @@ static int bpf_skb_net_shrink(struct sk_buff =
*skb, u32 off, u32 len_diff,
> > > >
> > > >  static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> > > >  {
> > > > -   return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> > > > -                     SKB_MAX_ALLOC;
> > > > +   return SKB_MAX_ALLOC;
> > > >  }
> > > >
> > > >  BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_di=
ff,
> > > > =20
> > >
> > > Looks familiar:
> > > https://lore.kernel.org/netdev/20200420231427.63894-1-zenczykowski@gm=
ail.com/
> > > =20
> >
> > Great to see that others have proposed same fix before.  Unfortunately
> > it seems that the thread have died, and no patch got applied to
> > address this.  (Cc. Maze since he was "mull this over a bit more"...)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

