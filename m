Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C811849500A
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344878AbiATOW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:22:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39848 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345930AbiATOWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 09:22:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A43AEB81CD9
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D52C340E0
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 14:22:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="DMY1plp3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642688551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=/h+eb+s2n9UFd7NR7CMNc0/6Skqfw/wrAf1o0e/alII=;
        b=DMY1plp3hLQ28V4Ev1eI/lLdzky5I4DqhuV25BBgnV+rdxj9rapy6uU2xAF//gJw1uqa+b
        l9FQw9GBpkkcrh2yPet+NN3BWfKo9vsdrIam5UmqtnnFKBcgSyR1rdUrxauACGyPoRV+p+
        XN2tatXs2VSr4NSyW4d3cBDwadTCPh4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4dde6450 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Thu, 20 Jan 2022 14:22:31 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id h14so18150125ybe.12
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 06:22:31 -0800 (PST)
X-Gm-Message-State: AOAM532PN+05o5qdzUrVp08ElKQJGHpxLGgYKm8BE5o4MSnlCftEjEu6
        Vq8u92K4z0mlqt8L24uAK6swgFFIDLZlOH1F4ws=
X-Google-Smtp-Source: ABdhPJyRTkV6gQxV/WasK7sBrTxSXo4RTk+mNGIecA0QTkaHN5+P9Jn6m+3AXvinA22TGIfkEMyNH9bPV+KFMh10/lc=
X-Received: by 2002:a25:ca03:: with SMTP id a3mr8395580ybg.255.1642688550296;
 Thu, 20 Jan 2022 06:22:30 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Jan 2022 15:22:19 +0100
X-Gmail-Original-Message-ID: <CAHmME9pv1x6C4TNdL6648HydD8r+txpV4hTUXOBVkrapBXH4QQ@mail.gmail.com>
Message-ID: <CAHmME9pv1x6C4TNdL6648HydD8r+txpV4hTUXOBVkrapBXH4QQ@mail.gmail.com>
Subject: pskb_expand_head always allocates in next power-of-two bucket
To:     Eric Dumazet <edumazet@google.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

I saw you played with pskb_expand_head logic recently, so thought I'd
run something by you...

I've got some test code that sets up a nested tunnel routing loop for
the absolute most pathological case. To my satisfaction, packets are
dropped after a few times through the loop. Great. But then I tried
testing on powerpc64 and noticed this wasn't happening, so I decided
to jump in and figure out what's happening.

Actually the question becomes, why are packets being dropped on other
platforms, rather than why they're not on powerpc64. Here's what my
trace is:

A packet makes its way to ip6_finish_output2, and hits:

        if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
               skb = skb_expand_head(skb, hh_len);
               if (!skb) {
                       IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
                       return -ENOMEM;
               }
       }

Each time through there, skb_expand_head is called, which then calls
into pskb_expand_head, where the fun begins.

On the way into pskb_expand_head, osize =
SKB_DATA_ALIGN(skb_end_offset(skb)) = 768, and then a new data is
allocated via size + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)),
and osize is then set to SKB_WITH_OVERHEAD(ksize(data)). On the way
out, it's then 1728. Rinse and repeat a few times and it blows up:

[    2.218080] skbuff: size in 768 out 1728
[    2.218426] skbuff: size in 1792 out 3776
[    2.218774] skbuff: size in 3840 out 7872
[    2.219123] skbuff: size in 7936 out 16064
[    2.219482] skbuff: size in 16128 out 32448
[    2.219837] skbuff: size in 32512 out 65216
[    2.220215] skbuff: size in 65280 out 130752
[    2.220608] skbuff: size in 130816 out 261824
[    2.221005] skbuff: size in 261888 out 523968
[    2.221401] skbuff: size in 524032 out 1048256
[    2.221807] skbuff: size in 1048320 out 2096832
[    2.222222] skbuff: size in 2096896 out 4193984
[    2.222618] skbuff: kmalloc_reserve failure for 4194368

As you can see, each time it's being reallocated in the next large
power-of-two allocation bucket. Something seems wrong with this. If
you do kmalloc(ksize(kmalloc(ksize(data) + n) + n)), you're always
going to bump up to the next kmalloc bucket, because you're adding to
the allocated bucket size.

I don't understand this code super well and so far I haven't had luck
poking at it. Any idea what's going on here? Is this behavior
intentional?

With regards to my routing loop, I set out to "fix" the powerpc64
behavior so it'd be like the other platforms, but now it's looking
more like the other platforms need fixing. So the loop from my test is
still an issue, but one I'll table until I understand what's happening
in pskb_expand_head better.

Thanks,
Jason
