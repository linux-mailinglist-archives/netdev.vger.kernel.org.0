Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA2918DB3F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgCTWhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:37:45 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:41859 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgCTWhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 18:37:45 -0400
Received: by mail-il1-f194.google.com with SMTP id l14so7146490ilj.8;
        Fri, 20 Mar 2020 15:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mv3aJeyhuEku1/wFNlvhM4zQ3A1VS2RgclSf1FwrTqI=;
        b=pvnjPaEtV/PqdY0ggPFY2FuNiWcvJem452JCtxLdM7a5gFHFpHjzAAVcNfWPfjGQ3Y
         rwndnEUs50UCDx7pty8Eu8rpDb2u/nAF0upT1CpAvzfLOKqu892BZspwhf/0yYIPrqES
         BaY/OWUhfUNd4VkGxIUqreOZGrHpYLmL/bfywQSq2aUDNscd2kEjUPus/sscJdfNKYfM
         2D8wyT/Imq3mzAxzB9EralHJ043mm8ufGZCtJqwoOktLF254V+ysDKthRUK9C2lEnzeD
         /pBovSi4lN7BpleFzDtk+BkfWYpATNl0ILHe4t0Orj4vQgRl7uJPW9sz5GfxsCSKS/YF
         1EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mv3aJeyhuEku1/wFNlvhM4zQ3A1VS2RgclSf1FwrTqI=;
        b=L9IWlWVYQnZ+oIcAa2XAo3v5fd2vKNnhwMMVJrUKyzUg6D8w+soN/x7hesWo4BI6sC
         zoSDJOMQV3YUqXolvSSTRu5VXFaH7dtFfYkFuBe4UwLHphChe53qQXr+5pR7l1H/FW6m
         bGuQYR8Hvuiu5+Kf334e6mdTMMXngndBeaNipuTUxwzYHwKPEVyBkxL7kvswmRahkR3B
         90/5lBH0GopmHE8U8iP6FmqKqETPDWz4kRks1LOeTEf3cg2DiaGHGOaD1NK49rXcRKfq
         YxC363PjbyioporiiXZRM5Fz/T50XrItEJ7LQv5wuQMlR+S//mo3i7/jrYfqdvj3ujiM
         /Vig==
X-Gm-Message-State: ANhLgQ1cV3XefgUw8yz9U2doHP6HVWGkSESSa/eRg6vcEaSt8xl/IKOG
        5Awil/k02UvOhhswAxK073k1AgEwd/4fAO9Almc=
X-Google-Smtp-Source: ADFU+vtWUHgwpGisFSSssTICwbFcd4JZH208sJCp5ZNFIJwTyhBeZRxqO9maSbzEBkrhBUCSJPepgPYbJxAhY6rH1O8=
X-Received: by 2002:a92:8f91:: with SMTP id r17mr9583538ilk.97.1584743864027;
 Fri, 20 Mar 2020 15:37:44 -0700 (PDT)
MIME-Version: 1.0
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
 <158446617307.702578.17057660405507953624.stgit@firesoul> <20200318200300.GA18295@ranger.igk.intel.com>
 <CAKgT0UeV7OHsu=E11QVrQ-HvUe83-ZL2Mo+CKg5Bw4v8REEoew@mail.gmail.com> <20200320224437.10ef858c@carbon>
In-Reply-To: <20200320224437.10ef858c@carbon>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 20 Mar 2020 15:37:33 -0700
Message-ID: <CAKgT0Uc=ML2jWkmN=d_UuJJoEeeLitT8LZtak93ULc60=nC0Gg@mail.gmail.com>
Subject: Re: [PATCH RFC v1 05/15] ixgbe: add XDP frame size to driver
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
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

On Fri, Mar 20, 2020 at 2:44 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 18 Mar 2020 14:23:09 -0700
> Alexander Duyck <alexander.duyck@gmail.com> wrote:
>
> > On Wed, Mar 18, 2020 at 1:04 PM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > On Tue, Mar 17, 2020 at 06:29:33PM +0100, Jesper Dangaard Brouer wrote:
> > > > The ixgbe driver uses different memory models depending on PAGE_SIZE at
> > > > compile time. For PAGE_SIZE 4K it uses page splitting, meaning for
> > > > normal MTU frame size is 2048 bytes (and headroom 192 bytes).
> > >
> > > To be clear the 2048 is the size of buffer given to HW and we slice it up
> > > in a following way:
> > > - 192 bytes dedicated for headroom
> > > - 1500 is max allowed MTU for this setup
> > > - 320 bytes for tailroom (skb shinfo)
> > >
> > > In case you go with higher MTU then 3K buffer would be used and it would
> > > came from order1 page and we still do the half split. Just FYI all of this
> > > is for PAGE_SIZE == 4k and L1$ size == 64.
> >
> > True, but for most people this is the most common case since these are
> > the standard for x86.
> >
> > > > For PAGE_SIZE larger than 4K, driver advance its rx_buffer->page_offset
> > > > with the frame size "truesize".
> > >
> > > Alex, couldn't we base the truesize here somehow on ixgbe_rx_bufsz() since
> > > these are the sizes that we are passing to hw? I must admit I haven't been
> > > in touch with systems with PAGE_SIZE > 4K.
> >
> > With a page size greater than 4K we can actually get many more uses
> > out of a page by using the frame size to determine the truesize of the
> > packet. The truesize is the memory footprint currently being held by
> > the packet. So once the packet is filled we just have to add the
> > headroom and tailroom to whatever the hardware wrote instead of having
> > to use what we gave to the hardware. That gives us better efficiency,
> > if we used ixgbe_rx_bufsz() we would penalize small packets and that
> > in turn would likely hurt performance.
> >
> > > >
> > > > When driver enable XDP it uses build_skb() which provides the necessary
> > > > tailroom for XDP-redirect.
> > >
> > > We still allow to load XDP prog when ring is not using build_skb(). I have
> > > a feeling that we should drop this case now.
> > >
> > > Alex/John/Bjorn WDYT?
> >
> > The comment Jesper had about using using build_skb() when XDP is in
> > use is incorrect. The two are not correlated. The underlying buffer is
> > the same, however we drop the headroom and tailroom if we are in
> > _RX_LEGACY mode. We default to build_skb and the option of switching
> > to legacy Rx is controlled via the device private flags.
>
> Thanks for catching that.
>
> > However with that said the change itself is mostly harmless, and
> > likely helps to resolve issues that would be seen if somebody were to
> > enable XDP while having the RX_LEGACY flag set.
>
> So what is the path forward(?).  Are you/Intel okay with disallowing
> XDP when the RX_LEGACY flag is set?

Why would we need to disallow it? It won't work for the redirect use
case, but other use cases should work just fine. I thought with this
patch set you were correctly reporting the headroom or tailroom so
that we would either reallocate or just drop the frame if it cannot be
handled.
