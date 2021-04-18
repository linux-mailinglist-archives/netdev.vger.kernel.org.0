Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1E53634FD
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhDRMF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:05:28 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:18080 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbhDRMF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 08:05:27 -0400
Date:   Sun, 18 Apr 2021 12:04:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1618747497; bh=S6+7IL9psNB52Dh+xGxHAd9iOltPMkvweODEzTOF5hQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=KG3PBF05MIU1gCXucaCnQQGVhDVLH3fhBBNTUS1oMKAn+2aDmw/ho2Qx5Dr7wbMWh
         N2NfBSQ9negZLZs2iVHq0T3h23lulHBS47TotCeQ3oEY3iQAF1SR4bd3fExWyb7lxk
         +2xNWOQiwpXHIvFkKtMo11ZMlAl+KHaGRhn0CSHXJ0zHe1nOmrDVNjpSThrcMDv/iZ
         EinJCF2a6+5qXHn8P8fhC12T3EXUtFuGGXeZB7dLzyVcB9zpN/cfYXJwsxJyat/yD0
         Q1lSNI2YYrC5xNyRyAwtV3iR5RUDxSEn8eMSkCLudBTN8UmhAciW/EIp1HQRQ00DVG
         Mz6WnsyEKZPOg==
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?Q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v2 bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
Message-ID: <20210418120431.6945-1-alobakin@pm.me>
In-Reply-To: <CAJ8uoz27wTWU0HhfVWkcHESfAtMXT6dj=p+JW87zm-ownDF7Ww@mail.gmail.com>
References: <CAJ8uoz2jym_AmCyMt_B32YBAEsjTNpaQF-WAJUavUe3P5_at3w@mail.gmail.com> <1618278328.0085247-1-xuanzhuo@linux.alibaba.com> <CAJ8uoz27wTWU0HhfVWkcHESfAtMXT6dj=p+JW87zm-ownDF7Ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@gmail.com>
Date: Tue, 13 Apr 2021 09:14:02 +0200

Hi!

I've finally done with a kinda comfy setup after moving to another
country and can finally continue working on patches and stuff.

> On Tue, Apr 13, 2021 at 3:49 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wr=
ote:
> >
> > On Mon, 12 Apr 2021 16:13:12 +0200, Magnus Karlsson <magnus.karlsson@gm=
ail.com> wrote:
> > > On Wed, Mar 31, 2021 at 2:27 PM Alexander Lobakin <alobakin@pm.me> wr=
ote:
> > > >
> > > > This series is based on the exceptional generic zerocopy xmit logic=
s
> > > > initially introduced by Xuan Zhuo. It extends it the way that it
> > > > could cover all the sane drivers, not only the ones that are capabl=
e
> > > > of xmitting skbs with no linear space.
> > > >
> > > > The first patch is a random while-we-are-here improvement over
> > > > full-copy path, and the second is the main course. See the individu=
al
> > > > commit messages for the details.
> > > >
> > > > The original (full-zerocopy) path is still here and still generally
> > > > faster, but for now it seems like virtio_net will remain the only
> > > > user of it, at least for a considerable period of time.
> > > >
> > > > From v1 [0]:
> > > >  - don't add a whole SMP_CACHE_BYTES because of only two bytes
> > > >    (NET_IP_ALIGN);
> > > >  - switch to zerocopy if the frame is 129 bytes or longer, not 128.
> > > >    128 still fit to kmalloc-512, while a zerocopy skb is always
> > > >    kmalloc-1024 -> can potentially be slower on this frame size.
> > > >
> > > > [0] https://lore.kernel.org/netdev/20210330231528.546284-1-alobakin=
@pm.me
> > > >
> > > > Alexander Lobakin (2):
> > > >   xsk: speed-up generic full-copy xmit
> > >
> > > I took both your patches for a spin on my machine and for the first
> > > one I do see a small but consistent drop in performance. I thought it
> > > would go the other way, but it does not so let us put this one on the
> > > shelf for now.

This is kinda strange as the solution is pretty straightforward.
But sure, if the performance dropped after this one, it should not
be considered for taking.
I might have a look at it later.

> > > >   xsk: introduce generic almost-zerocopy xmit
> > >
> > > This one wreaked havoc on my machine ;-). The performance dropped wit=
h
> > > 75% for packets larger than 128 bytes when the new scheme kicks in.
> > > Checking with perf top, it seems that we spend much more time
> > > executing the sendmsg syscall. Analyzing some more:
> > >
> > > $ sudo bpftrace -e 'kprobe:__sys_sendto { @calls =3D @calls + 1; }
> > > interval:s:1 {printf("calls/sec: %d\n", @calls); @calls =3D 0;}'
> > > Attaching 2 probes...
> > > calls/sec: 1539509 with your patch compared to
> > >
> > > calls/sec: 105796 without your patch
> > >
> > > The application spends a lot of more time trying to get the kernel to
> > > send new packets, but the kernel replies with "have not completed the
> > > outstanding ones, so come back later" =3D EAGAIN. Seems like the
> > > transmission takes longer when the skbs have fragments, but I have no=
t
> > > examined this any further. Did you get a speed-up?
> >
> > Regarding this solution, I actually tested it on my mlx5 network card, =
but the
> > performance was severely degraded, so I did not continue this solution =
later. I
> > guess it might have something to do with the physical network card. We =
can try
> > other network cards.
>
> I tried it on a third card and got a 40% degradation, so let us scrap
> this idea. It should stay optional as it is today as the (software)
> drivers that benefit from this can turn it on explicitly.

Thank you guys a lot for the testing!

I think the main reason is the DMA mapping of one additional frag
(14 bytes of MAC header, which is excessive). It can take a lot of
CPU cycles, especially when the device is behind an IOMMU, and seems
like memcpying is faster here.

Moreover, if Xuan tested it as one of the steps towards his
full-zerocopy and found it to be a bad idea, this should not
go further.
So I'm burying this.

> > links: https://www.spinics.net/lists/netdev/msg710918.html
> >
> > Thanks.
> >
> > >
> > > >  net/xdp/xsk.c | 32 ++++++++++++++++++++++----------
> > > >  1 file changed, 22 insertions(+), 10 deletions(-)
> > > >
> > > > --
> > > > Well, this is untested. I currently don't have an access to my setu=
p
> > > > and is bound by moving to another country, but as I don't know for
> > > > sure at the moment when I'll get back to work on the kernel next ti=
me,
> > > > I found it worthy to publish this now -- if any further changes wil=
l
> > > > be required when I already will be out-of-sight, maybe someone coul=
d
> > > > carry on to make a another revision and so on (I'm still here for a=
ny
> > > > questions, comments, reviews and improvements till the end of this
> > > > week).
> > > > But this *should* work with all the sane drivers. If a particular
> > > > one won't handle this, it's likely ill. Any tests are highly
> > > > appreciated. Thanks!
> > > > --
> > > > 2.31.1

Thanks,
Al

