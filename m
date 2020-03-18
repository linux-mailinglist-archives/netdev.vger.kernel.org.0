Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CDB18A6E4
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgCRVXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:23:22 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:42291 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgCRVXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 17:23:22 -0400
Received: by mail-il1-f193.google.com with SMTP id p2so232037ile.9;
        Wed, 18 Mar 2020 14:23:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4DobP8Ph4M483KSHS2xL3BwO/0GChASXSjrLTPBUYck=;
        b=N4yvk9P/GV+Vmr7QJY3Zlq0fxR/+gNw1r0MzOi6cU78xNZdiLmBr6UD8ioT8x+eHzy
         WIO9ijofHE5C1Yw7DQAmnN3RFkHKb3Q5gHnk6ccotCzWMMp+spR+S+4l3tds7KW3rKSx
         M5EfCWEjYhgagTm0UAuT9NMRGyngGgrw68BWb6CEXYZDlXdYJxbWBNxACDA1UvidGfUC
         b8fTzzgRCF8Knm79+EYWXUg8ldWrutZwfRk5WhMnY/46gObqeZ13gonOSNQDBW0/w7ou
         XTcflAU5tx+YMJzfhi5Lp3SKuqKAChGFu8a67XBTkKC8/bKA3CZtzO8Oj2SOibZeizYP
         duVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4DobP8Ph4M483KSHS2xL3BwO/0GChASXSjrLTPBUYck=;
        b=hakI1tasS6znEuvtopFblALDlUoTsjB7Zs/QcAGDHUaL/YMFCG78JVcsSTBK5u3rjR
         Qqy0n4TjEw07Qc8qTUhPMlTIc+NTv2hA8MEIa3tFIcBjfcgRFVr4a1JelHR1BUxkM0V4
         e5v/LubNwuwNLEjYM43TyV/BZKcj+eHqWqgFJ7ji7EcTf6Tyhp1oGaA/B/o+9LEzXGZ/
         ovglrNkVonbWYG9TLciQlkl7bthCc+E7AQpEH5mhybPz3BtCh34UB+0/rrVrKEhxviJH
         Yx5N89/JO5GjM+9T39+Sln8bMUG8Z/DLtFG534b3fEJllNx8lZoabZ/DvjhKEFKt3uAA
         xPcw==
X-Gm-Message-State: ANhLgQ3lijYb5E+mLc0xUQYedMSbp0jkkv08sXvMySrYefr8m4+nmU/g
        kXN4TIg2Xl5g8h1HbCNLnYnlOLjo7fLycr83XlQ=
X-Google-Smtp-Source: ADFU+vsDaE6sp5Uoj2tvcJH5EhlXOWhUUuf4Zt6mP4ZjssD7SN9tDbKBY4xtr0CVk73M6HjWbnw6MKOPV+ZClHRPilw=
X-Received: by 2002:a92:358b:: with SMTP id c11mr98235ilf.64.1584566601106;
 Wed, 18 Mar 2020 14:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
 <158446617307.702578.17057660405507953624.stgit@firesoul> <20200318200300.GA18295@ranger.igk.intel.com>
In-Reply-To: <20200318200300.GA18295@ranger.igk.intel.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 18 Mar 2020 14:23:09 -0700
Message-ID: <CAKgT0UeV7OHsu=E11QVrQ-HvUe83-ZL2Mo+CKg5Bw4v8REEoew@mail.gmail.com>
Subject: Re: [PATCH RFC v1 05/15] ixgbe: add XDP frame size to driver
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 1:04 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Tue, Mar 17, 2020 at 06:29:33PM +0100, Jesper Dangaard Brouer wrote:
> > The ixgbe driver uses different memory models depending on PAGE_SIZE at
> > compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
> > normal MTU frame size is 2048 bytes (and headroom 192 bytes).
>
> To be clear the 2048 is the size of buffer given to HW and we slice it up
> in a following way:
> - 192 bytes dedicated for headroom
> - 1500 is max allowed MTU for this setup
> - 320 bytes for tailroom (skb shinfo)
>
> In case you go with higher MTU then 3K buffer would be used and it would
> came from order1 page and we still do the half split. Just FYI all of this
> is for PAGE_SIZE == 4k and L1$ size == 64.

True, but for most people this is the most common case since these are
the standard for x86.

> > For PAGE_SIZE larger than 4K, driver advance its rx_buffer->page_offset
> > with the frame size "truesize".
>
> Alex, couldn't we base the truesize here somehow on ixgbe_rx_bufsz() since
> these are the sizes that we are passing to hw? I must admit I haven't been
> in touch with systems with PAGE_SIZE > 4K.

With a page size greater than 4K we can actually get many more uses
out of a page by using the frame size to determine the truesize of the
packet. The truesize is the memory footprint currently being held by
the packet. So once the packet is filled we just have to add the
headroom and tailroom to whatever the hardware wrote instead of having
to use what we gave to the hardware. That gives us better efficiency,
if we used ixgbe_rx_bufsz() we would penalize small packets and that
in turn would likely hurt performance.

> >
> > When driver enable XDP it uses build_skb() which provides the necessary
> > tailroom for XDP-redirect.
>
> We still allow to load XDP prog when ring is not using build_skb(). I have
> a feeling that we should drop this case now.
>
> Alex/John/Bjorn WDYT?

The comment Jesper had about using using build_skb() when XDP is in
use is incorrect. The two are not correlated. The underlying buffer is
the same, however we drop the headroom and tailroom if we are in
_RX_LEGACY mode. We default to build_skb and the option of switching
to legacy Rx is controlled via the device private flags.

However with that said the change itself is mostly harmless, and
likely helps to resolve issues that would be seen if somebody were to
enable XDP while having the RX_LEGACY flag set.

> >
> > When XDP frame size doesn't depend on RX packet size (4K case), then
> > xdp.frame_sz can be updated once outside the main NAPI loop.
> >
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   17 +++++++++++++++++
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   18 ++++++++++--------
> >  2 files changed, 27 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > index 2833e4f041ce..943b643b6ed8 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
> > @@ -417,6 +417,23 @@ static inline unsigned int ixgbe_rx_pg_order(struct ixgbe_ring *ring)
> >  }
> >  #define ixgbe_rx_pg_size(_ring) (PAGE_SIZE << ixgbe_rx_pg_order(_ring))
> >
> > +static inline unsigned int ixgbe_rx_frame_truesize(struct ixgbe_ring *rx_ring,
> > +                                                unsigned int size)
> > +{
> > +     unsigned int truesize;
> > +
> > +#if (PAGE_SIZE < 8192)
> > +     truesize = ixgbe_rx_pg_size(rx_ring) / 2; /* Must be power-of-2 */
> > +#else
> > +     /* Notice XDP must use build_skb() mode */
> > +     truesize = ring_uses_build_skb(rx_ring) ?
> > +             SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
> > +             SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> > +             SKB_DATA_ALIGN(size);
> > +#endif
> > +     return truesize;
> > +}
> > +
> >  #define IXGBE_ITR_ADAPTIVE_MIN_INC   2
> >  #define IXGBE_ITR_ADAPTIVE_MIN_USECS 10
> >  #define IXGBE_ITR_ADAPTIVE_MAX_USECS 126
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index ea6834bae04c..f505ed8c9dc1 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -2248,16 +2248,10 @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
> >                                struct ixgbe_rx_buffer *rx_buffer,
> >                                unsigned int size)
> >  {
> > +     unsigned int truesize = ixgbe_rx_frame_truesize(rx_ring, size);
> >  #if (PAGE_SIZE < 8192)
> > -     unsigned int truesize = ixgbe_rx_pg_size(rx_ring) / 2;
> > -
> >       rx_buffer->page_offset ^= truesize;
> >  #else
> > -     unsigned int truesize = ring_uses_build_skb(rx_ring) ?
> > -                             SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
> > -                             SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
> > -                             SKB_DATA_ALIGN(size);
> > -
> >       rx_buffer->page_offset += truesize;
> >  #endif
> >  }
> > @@ -2291,6 +2285,11 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
> >
> >       xdp.rxq = &rx_ring->xdp_rxq;
> >
> > +     /* Frame size depend on rx_ring setup when PAGE_SIZE=4K */
> > +#if (PAGE_SIZE < 8192)
> > +     xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, 0);
> > +#endif
> > +
> >       while (likely(total_rx_packets < budget)) {
> >               union ixgbe_adv_rx_desc *rx_desc;
> >               struct ixgbe_rx_buffer *rx_buffer;
> > @@ -2324,7 +2323,10 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
> >                       xdp.data_hard_start = xdp.data -
> >                                             ixgbe_rx_offset(rx_ring);
> >                       xdp.data_end = xdp.data + size;
> > -
> > +#if (PAGE_SIZE > 4096)
> > +                     /* At larger PAGE_SIZE, frame_sz depend on size */
> > +                     xdp.frame_sz = ixgbe_rx_frame_truesize(rx_ring, size);
> > +#endif
> >                       skb = ixgbe_run_xdp(adapter, rx_ring, &xdp);
> >               }
> >
> >
> >
