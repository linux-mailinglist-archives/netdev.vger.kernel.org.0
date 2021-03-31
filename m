Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3AC834FFDB
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhCaMCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:02:06 -0400
Received: from mail-40134.protonmail.ch ([185.70.40.134]:51775 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235026AbhCaMBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:01:35 -0400
Date:   Wed, 31 Mar 2021 12:01:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1617192093; bh=z8CUaRMV+W1DdXAmNRPxHigof0va9uxxc3ghbazANQw=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=lZ9Y2+Rx9IMXJGyzGR1r8fCec6Hg5fzSGRUVXr+KqhJO2JmCyO/h1DrmLR0u3kV8E
         8NbVOmjwBLwIxjYnWpeoSXgfZ8meMiqtFXZmSq4Sp9WeHtTG7uknH02cIha4dUxCEO
         s5xMMYX9SFqoKZs/1n+t+DSs22IvE1dQrKRXpX45sUI7rLQ4To1kqPgaH0fcuKb77S
         Ir/QdFpJRPFPW6RYkq4Hs+yLKhiUEEFGMkttnRr3kCTUQ6Tsi7Dn6xOuA5v+PH09yU
         WFPNnfLn2C19CgASzQoNrNSLUdSq2k1vyduxgsvlM9mORR+llDW8xiTZpzlrXgABad
         Uhfl9AhYp5zUw==
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
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
Subject: Re: [PATCH bpf-next 0/2] xsk: introduce generic almost-zerocopy xmit
Message-ID: <20210331120116.2671-1-alobakin@pm.me>
In-Reply-To: <CAJ8uoz2UNABjfpvHOopzvRfW4RJGSS2P=0MUZRkyg-e+S1OdHA@mail.gmail.com>
References: <20210330231528.546284-1-alobakin@pm.me> <CAJ8uoz2UNABjfpvHOopzvRfW4RJGSS2P=0MUZRkyg-e+S1OdHA@mail.gmail.com>
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
Date: Wed, 31 Mar 2021 11:44:45 +0200

> On Wed, Mar 31, 2021 at 1:17 AM Alexander Lobakin <alobakin@pm.me> wrote:
> >
> > This series is based on the exceptional generic zerocopy xmit logics
> > initially introduced by Xuan Zhuo. It extends it the way that it
> > could cover all the sane drivers, not only the ones that are capable
> > of xmitting skbs with no linear space.
> >
> > The first patch is a random while-we-are-here improvement over
> > full-copy path, and the second is the main course. See the individual
> > commit messages for the details.
> >
> > The original (full-zerocopy) path is still here and still generally
> > faster, but for now it seems like virtio_net will remain the only
> > user of it, at least for a considerable period of time.
> >
> > Alexander Lobakin (2):
> >   xsk: speed-up generic full-copy xmit
> >   xsk: introduce generic almost-zerocopy xmit
> >
> >  net/xdp/xsk.c | 33 +++++++++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
> >
> > --
> > Well, this is untested. I currently don't have an access to my setup
> > and is bound by moving to another country, but as I don't know for
> > sure at the moment when I'll get back to work on the kernel next time,
> > I found it worthy to publish this now -- if any further changes will
> > be required when I already will be out-of-sight, maybe someone could
> > carry on to make a another revision and so on (I'm still here for any
> > questions, comments, reviews and improvements till the end of this
> > week).
> > But this *should* work with all the sane drivers. If a particular
> > one won't handle this, it's likely ill.
>
> Thanks Alexander. I will take your patches for a spin on a couple of
> NICs and get back to you, though it will be next week due to holidays
> where I am based.

Thanks a lot! Any tests will be much appreciated.
I'll publish v2 in a moment though, want to drop a couple of
micro-optimizations.

> > --
> > 2.31.1

Al

