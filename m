Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23564665D6
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 15:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358806AbhLBOzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 09:55:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358641AbhLBOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 09:55:22 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46896C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 06:52:00 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id f186so327934ybg.2
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 06:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eEARW4cHzJB7x5jV86ocedSL7FpHsr0vkyzSjUsyqC0=;
        b=q2XfthD/JQRcHO5xmmpFT0D8QQgRNrhvglryG9e11Xht4u//Kp1IPdf7OpL5H4p6wz
         NmK6KPS7//8fxiE0VhmCJ/1YYY0sSA2aS+gQU50NruCneHFbryZA4xSsrDXHIb37TTz8
         cQQinSpqI6j2UCg7XhcNIIt6pt5A34K5GhsF/v1NAjqT0ohSu5OVcrZ0T9MnoshqwOuU
         jFtxav8Npa+jOTfFF+4U8CLdGRR7tJkGqWl/5N8kFysl8tt8L0CWkNCLwRZnX3/UzgIc
         64wUs/WyNyT+WXImsP40D6v5AE7m9HKEZoSoMa+HoxxOQS2LZrk56SLtWT80S+lDkfyH
         qwaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eEARW4cHzJB7x5jV86ocedSL7FpHsr0vkyzSjUsyqC0=;
        b=Bk7uW+/jNGJgzR2lHxQev0SDsHjBJmL32ZjzZK6CShCa76ZuHr7jmfiwbG49zmgXQp
         h0C3mqQCj/+x9tOgiRr0KDQ4wwBJeG84ydxJXdHFNQh+cvgPJ/GxBbStzqqISunSxwzO
         TROoaAX+9EzsKaYF5B0+mH7E2m1wHwPoJcGZ8yz6oCufh4ccLtaA+LOfmJ12YJ1Dn8dG
         NJMFjBbfemUWbe2+P+vkd5m4i298IJiF/yjyt2UF0bzjvwAOA3t7EOZ9/L0BPHnaLQJY
         tY5tZRKqILed4966QhfLY5JyVyzCPjl/WjV48G/07eermkwffbMBlTGhjyYbeR193Zjs
         +1FA==
X-Gm-Message-State: AOAM532Ek5ixd9mS3ZrblSNIAO3eeDI2mtAoserr01ZP+bkHmlHI8YVi
        uS3f9mWMfMJ5GCnEV3E6CfSHy15FUicYDRlOGVJCng==
X-Google-Smtp-Source: ABdhPJwa0qPl5t+lOLT/TBQ7a2btIQhjY/2Ben0gtu16TIj+G5I265DomnvEkH5jEpRgwo8t1QUowqdEP+yqOBcpLpQ=
X-Received: by 2002:a05:6902:120e:: with SMTP id s14mr17104274ybu.277.1638456719106;
 Thu, 02 Dec 2021 06:51:59 -0800 (PST)
MIME-Version: 1.0
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com> <20211202131040.rdxzbfwh2slhftg5@skbuf>
In-Reply-To: <20211202131040.rdxzbfwh2slhftg5@skbuf>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Dec 2021 06:51:47 -0800
Message-ID: <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir

On Thu, Dec 2, 2021 at 5:10 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hello,
>
> On Wed, Nov 24, 2021 at 12:24:46PM -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Remove one pair of add/adc instructions and their dependency
> > against carry flag.
> >
> > We can leverage third argument to csum_partial():
> >
> >   X = csum_block_sub(X, csum_partial(start, len, 0), 0);
> >
> >   -->
> >
> >   X = csum_block_add(X, ~csum_partial(start, len, 0), 0);
> >
> >   -->
> >
> >   X = ~csum_partial(start, len, ~X);
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/linux/skbuff.h | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index eba256af64a577b458998845f2dc01a5ec80745a..eae4bd3237a41cc1b60b44c91fbfe21dfdd8f117 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -3485,7 +3485,11 @@ __skb_postpull_rcsum(struct sk_buff *skb, const void *start, unsigned int len,
> >  static inline void skb_postpull_rcsum(struct sk_buff *skb,
> >                                     const void *start, unsigned int len)
> >  {
> > -     __skb_postpull_rcsum(skb, start, len, 0);
> > +     if (skb->ip_summed == CHECKSUM_COMPLETE)
> > +             skb->csum = ~csum_partial(start, len, ~skb->csum);
> > +     else if (skb->ip_summed == CHECKSUM_PARTIAL &&
> > +              skb_checksum_start_offset(skb) < 0)
> > +             skb->ip_summed = CHECKSUM_NONE;
> >  }
> >
> >  static __always_inline void
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >
>
> I am seeing some errors after this patch, and I am not able to
> understand why. Specifically, __skb_gro_checksum_complete() hits this
> condition:

There were two patches, one for GRO, one for skb_postpull_rcsum()

I am a bit confused by your report. Which one is causing problems ?

>
>         wsum = skb_checksum(skb, skb_gro_offset(skb), skb_gro_len(skb), 0);
>
>         /* NAPI_GRO_CB(skb)->csum holds pseudo checksum */
>         sum = csum_fold(csum_add(NAPI_GRO_CB(skb)->csum, wsum));
>         /* See comments in __skb_checksum_complete(). */
>         if (likely(!sum)) {
>                 if (unlikely(skb->ip_summed == CHECKSUM_COMPLETE) &&
>                     !skb->csum_complete_sw)
>                         netdev_rx_csum_fault(skb->dev, skb);
>         }
>
> To test, I am using a DSA switch network interface with an IPv4 address
> and pinging through it.
>
> The idea is as follows: an enetc port is attached to a switch, and that
> switch places a frame header before the Ethernet header.
> The enetc calculates the L2 payload (actually what it perceives as L2
> payload, since it has no insight into the switch header format) checksum
> and puts it in skb->csum:
> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/freescale/enetc/enetc.c#L726
>
> Then, the switch driver packet type handler is invoked, and this strips
> that header and recalculates the checksum (then it changes skb->dev and
> this is how pinging is done through the DSA interface, but that is
> irrelevant).
> https://elixir.bootlin.com/linux/latest/source/net/dsa/tag_ocelot.c#L56
>
> There seems to be a disparity when the skb->csum is calculated by
> skb_postpull_rcsum as zero. Before, it was calculated as 0xffff.

skb->csum is 32bit, so there are about 2^16 different values for a
given Internet checksum

>
> Below is a dump added by me in skb_postpull_rcsum when the checksums
> calculated through both methods differ. I've kept the old implementation
> inside skb->csum and this is what skb_dump() sees:
>
> [   99.891524] skb csum of 20 bytes (20 to left of skb->data) using method 1: 0x0 method 2 0xffffffff, orig 0xf470
> [   99.901701] skb len=84 headroom=98 headlen=84 tailroom=1546
> [   99.901701] mac=(84,-6) net=(78,0) trans=78
> [   99.901701] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> [   99.901701] csum(0xffffffff ip_summed=2 complete_sw=0 valid=0 level=0)
> [   99.901701] hash(0x0 sw=0 l4=0) proto=0x00f8 pkttype=3 iif=7
> [   99.929916] dev name=eno2 feat=0x0x00020100001149a9
> [   99.934831] skb headroom: 00000000: 00 c0 b1 a4 ff ff 00 00 00 e0 b1 a4 ff ff 00 00
> [   99.942533] skb headroom: 00000010: 00 6f 5b 02 f8 14 ff ff 40 62 5b 02 f8 14 ff ff
> [   99.950232] skb headroom: 00000020: 21 6f 5b 02 f8 14 ff ff 00 00 00 00 00 00 00 00
> [   99.957931] skb headroom: 00000030: 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00
> [   99.965631] skb headroom: 00000040: 88 80 00 0a 00 33 9d 40 f0 41 01 80 00 00 08 0f
> [   99.973330] skb headroom: 00000050: 00 10 00 00 00 04 9f 05 f6 28 ba ae e4 b6 2c 3d
> [   99.981028] skb headroom: 00000060: 08 00
> [   99.985062] skb linear:   00000000: 45 00 00 54 27 ac 00 00 40 01 09 a8 c0 a8 64 03
> [   99.992762] skb linear:   00000010: c0 a8 64 01 00 00 10 e6 01 5c 00 04 49 30 a7 61
> [  100.000462] skb linear:   00000020: 00 00 00 00 3d 55 01 00 00 00 00 00 10 11 12 13
> [  100.008162] skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
> [  100.015862] skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> [  100.023561] skb linear:   00000050: 34 35 36 37
>
> And below is the same output as above, but annotated by me with some comments:
>
> [   99.891524] skb csum of 20 bytes (20 to left of skb->data) using method 1: 0x0 method 2 0xffffffff, orig 0xf470
> [   99.901701] skb len=84 headroom=98 headlen=84 tailroom=1546
> [   99.901701] mac=(84,-6) net=(78,0) trans=78
>                ^^^^^^^^^^^^^^^^^^^^^^
>                since the print is done from ocelot_rcv, the network and
>                transport headers haven't yet been updated
>
> [   99.901701] shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
> [   99.901701] csum(0xffffffff ip_summed=2 complete_sw=0 valid=0 level=0)
> [   99.901701] hash(0x0 sw=0 l4=0) proto=0x00f8 pkttype=3 iif=7
> [   99.929916] dev name=eno2 feat=0x0x00020100001149a9
> [   99.934831] skb headroom: 00000000: 00 c0 b1 a4 ff ff 00 00 00 e0 b1 a4 ff ff 00 00
> [   99.942533] skb headroom: 00000010: 00 6f 5b 02 f8 14 ff ff 40 62 5b 02 f8 14 ff ff
> [   99.950232] skb headroom: 00000020: 21 6f 5b 02 f8 14 ff ff 00 00 00 00 00 00 00 00
> [   99.957931] skb headroom: 00000030: 00 00 00 00 00 00 00 00 00 40 00 00 00 00 00 00
>
>                                        here is where the enetc saw the          the "start" variable (old skb->data)
>                                        beginning of the frame                   points here
>                                        v                                         v
> [   99.965631] skb headroom: 00000040: 88 80 00 0a 00 33 9d 40 f0 41 01 80 00 00 08 0f
>
>                                                    OCELOT_TAG_LEN bytes
>                                                    later is the real MAC header
>                                                    v
> [   99.973330] skb headroom: 00000050: 00 10 00 00 00 04 9f 05 f6 28 ba ae e4 b6 2c 3d
> [   99.981028] skb headroom: 00000060: 08 00
>                                        ^
>                                        the skb_postpull_rcsum is called from "start"
>                                        until the first byte prior to this one
>
> [   99.985062] skb linear:   00000000: 45 00 00 54 27 ac 00 00 40 01 09 a8 c0 a8 64 03
> [   99.992762] skb linear:   00000010: c0 a8 64 01 00 00 10 e6 01 5c 00 04 49 30 a7 61
> [  100.000462] skb linear:   00000020: 00 00 00 00 3d 55 01 00 00 00 00 00 10 11 12 13
> [  100.008162] skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
> [  100.015862] skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
> [  100.023561] skb linear:   00000050: 34 35 36 37
>
> Do you have some suggestions as to what may be wrong? Thanks.

What kind of traffic is triggering the fault ? TCP, UDP, something else ?

Do you have a stack trace to provide, because it is not clear from
where the issue is detected.

Thanks.
