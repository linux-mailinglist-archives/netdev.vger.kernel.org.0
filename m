Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3E4466BBA
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349117AbhLBVnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349087AbhLBVnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:43:35 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57EBDC061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 13:40:12 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o20so3332915eds.10
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 13:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WkWbuNbEXp98K6ev9TQhQlZN/KCyILTBLV4Ez+Ae1wA=;
        b=MC2ZemWE7c+3TiTz//LHZhCGYHIAYaxlWnGPuXZ0k1lh37ko3JRzDrFsQc8OfQdsoj
         dgKrrWc8Ik0x1MIxybuD36Z67WIdXkkkYIgHc8MkS+bD1NyOGuoxrYIxzvgkeNQz298e
         MTd5ItIlTLtoVvD/fI5nL7ZrVyfF4PIGMDWWp1StA+/Z50vbSIW71IajpmwvM8yy8rdx
         pz+tEk/E7q0cqdOBC9vTK0mYe8LESMCz+u+6grYfPv8jLWkfLvB0A2VT6MGA2VfW9RmC
         S2gwKRsmryUrY53SBzYWz/uso1YU6j4KbppLwUOhjJ44hYOOyxbtaPBMxmGejAcBOxym
         NccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WkWbuNbEXp98K6ev9TQhQlZN/KCyILTBLV4Ez+Ae1wA=;
        b=1cUu6cA5F0pjKfxfsOFiUtomwAPhe+giagjkiTdVAOjktMRVE6fhIOYXOoS7FXQbmF
         /zix2xcP/4Nm63is2s7uaceKryvuxvYMNrhZ0l0R/v1R5oGoM8N9zb9ppTAI22yxmMsi
         Hh6MNfoGsqps9YtPdYd4SOdjecwgrj1zryylBu7psf4qfpzOE8l4PNJKclBUuG+aV2z1
         hvQIsI6ixwawBAnWREY6+zUIJ3AfL9KZkSPNH2pzditRoO1Qs9TwKQYDSv1xOvfdYJYG
         rOiP1JZrW9DETuzhCWZtjwk0Fp6NtSBunToY4cLuRZ/PtdIfLjnuj+Vzxe1rLJaDL6cE
         IowQ==
X-Gm-Message-State: AOAM5307kRO4VFue0xYXvbNkxUUwHrlv6bkJUNtSUgzI6Phj0Tr8IVVr
        aqkqbK9lc4l6krkePWrBhiQ=
X-Google-Smtp-Source: ABdhPJxKuz21wZ8CoVx2DfHexbIB5jd5WL0xggVSbjQ4qXEnUWcUtOewgFfOxqFhj9lrRfSCOxcZVw==
X-Received: by 2002:a05:6402:42d5:: with SMTP id i21mr21008504edc.373.1638481210896;
        Thu, 02 Dec 2021 13:40:10 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id t5sm600187edd.68.2021.12.02.13.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 13:40:10 -0800 (PST)
Date:   Thu, 2 Dec 2021 23:40:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/2] net: optimize skb_postpull_rcsum()
Message-ID: <20211202214009.5hm3diwom4qsbsjd@skbuf>
References: <20211124202446.2917972-1-eric.dumazet@gmail.com>
 <20211124202446.2917972-3-eric.dumazet@gmail.com>
 <20211202131040.rdxzbfwh2slhftg5@skbuf>
 <CANn89iLW4kwKf0x094epVeCaKhB4GtYgbDwE2=Fp0HnW8UdKzw@mail.gmail.com>
 <20211202162916.ieb2wn35z5h4aubh@skbuf>
 <CANn89iJEfDL_3C39Gp9eD=yPDqW4MGcVm7AyUBcTVdakS-X2dg@mail.gmail.com>
 <20211202204036.negad3mnrm2gogjd@skbuf>
 <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9eefc224988841c9b1a0b6c6eb3348b8@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 08:58:46PM +0000, David Laight wrote:
> > To me it looks like the strange part is that the checksum of the removed
> > block (printed by me as "csum_partial(start, len, 0)" inside
> > skb_postpull_rcsum()) is the same as the skb->csum itself.
> 
> If you are removing all the bytes that made the original checksum
> that will happen.
> And that might be true for the packets you are building.

Yes, I am not removing all the bytes that made up the original L2
payload csum. Let me pull up the skb_dump from my original message:

                        here is where the enetc saw the          the "start" variable (old skb->data)
                        beginning of the frame                   points here
                        v                                         v
skb headroom: 00000040: 88 80 00 0a 00 33 9d 40 f0 41 01 80 00 00 08 0f

                              OCELOT_TAG_LEN bytes into the frame,
                              the real MAC header can be found
                                    v
skb headroom: 00000050: 00 10 00 00 00 04 9f 05 f6 28 ba ae e4 b6 2c 3d
skb headroom: 00000060: 08 00
skb linear:   00000000: 45 00 00 54 27 ac 00 00 40 01 09 a8 c0 a8 64 03
                        ^
                        the skb_postpull_rcsum is called from "start"
                        pointer until the first byte prior to this one

skb linear:   00000010: c0 a8 64 01 00 00 10 e6 01 5c 00 04 49 30 a7 61
skb linear:   00000020: 00 00 00 00 3d 55 01 00 00 00 00 00 10 11 12 13
skb linear:   00000030: 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23
skb linear:   00000040: 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33
skb linear:   00000050: 34 35 36 37

So skb_postpull_rcsum() is called from "skb headroom" offset 0x4e to
offset 0x61 inclusive (0x61 - 0x4e + 1 = 20 == OCELOT_TAG_LEN).

However as I understand it, the CHECKSUM_COMPLETE of this packet is
calculated by enetc from "skb headroom" offset 0x4e and all the way
until "skb linear" offset 0x53. So there is still a good chunk of packet
to go. That's why it is still a mystery to me why the checksums would be
equal. They still are, with your change suggested below, of course, but
at least there is no splat now.

> 
> Try replacing both ~ with -.
> So replace:
> 		skb->csum = ~csum_partial(start, len, ~skb->csum);
> with:
> 		skb->csum = -csum_partial(start, len, -skb->csum);
> 
> That should geneate ~0u instead 0 (if I've got my maths right).

Indeed, replacing both one's complement operations with two's complement
seems to produce correct results (consistent with old code) in all cases
that I am testing with (ICMP, TCP, UDP). Thanks!

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
