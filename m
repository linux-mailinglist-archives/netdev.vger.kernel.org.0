Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3D5244F72
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 23:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgHNVFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 17:05:00 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33501 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgHNVFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 17:05:00 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d71ac4a4
        for <netdev@vger.kernel.org>;
        Fri, 14 Aug 2020 20:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=ICKqaHtaw6IfYyhVDwH81COKp/U=; b=sQbIFo
        R1x4PJSwvTyhHMVID/kyenWhSbp362B0b0en2cft5q1pUMZWIwyMcxoiWrD86jMr
        uHFmsc+xlnBMl0SlZ9PhXhz5cFlp2kewPfW4wpRMKr+LArL9uwfuRcBkUQXvf2zC
        w+rwD435zyqNR8fb7C7ueAjwiv0RgceE9CS3uBT89X8Cr+NcKqJn6Kwp/w6kypUn
        4G4ttUoGFJYSpYYWFokemDB4qTLEXkDw0fc2Fx5MyGZvaCVoRwXGbv4P4CR5VH5b
        6Hqwjn0czNJwFtZ1xrvlmPjcWXnrcL6xxxmt80kI4wmMVXEi+AbNX9yq8jQALRv0
        oTDNyB0tWHdE1iZw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7a380249 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Aug 2020 20:39:15 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id u126so11998812iod.12
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 14:04:57 -0700 (PDT)
X-Gm-Message-State: AOAM533a9CwBdROVHtZFg8oOrhrB2XmUZyaCXyGVmrML1sZd5hlreWc5
        KiBI1VfNMyD3t5+qOZd6+jF+dAseKEjX18CTHXQ=
X-Google-Smtp-Source: ABdhPJxTE4yoJNCkUzi11zyGvLWE5N+oAWAC6kkW1hq6o4AeACfrdKSVBXWTc4uc6A3kHReke3uw1G8HmhuC1TjcBL8=
X-Received: by 2002:a05:6638:1027:: with SMTP id n7mr4384174jan.86.1597439096982;
 Fri, 14 Aug 2020 14:04:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a92:995a:0:0:0:0:0 with HTTP; Fri, 14 Aug 2020 14:04:56
 -0700 (PDT)
In-Reply-To: <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200813195816.67222-1-Jason@zx2c4.com> <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com> <20200814083153.06b180b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Aug 2020 23:04:56 +0200
X-Gmail-Original-Message-ID: <CAHmME9rt-8Z1FJo9YSEqQHyEd1178cfizNa08BiakZYr+FR=Wg@mail.gmail.com>
Message-ID: <CAHmME9rt-8Z1FJo9YSEqQHyEd1178cfizNa08BiakZYr+FR=Wg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in generic
 skb handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/20, Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 14 Aug 2020 08:56:48 +0200 Jason A. Donenfeld wrote:
>> On Thu, Aug 13, 2020 at 11:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> > > I had originally dropped this patch, but the issue kept coming up in
>> > > user reports, so here's a v4 of it. Testing of it is still rather
>> > > slim,
>> > > but hopefully that will change in the coming days.
>> >
>> > Here an alternative patch, untested:
>>
>> Funny. But come on now... Why would we want to deprive our users of
>> system consistency?
>
> We should try for consistency between xdp and cls_bpf instead.

And still require users to reimplement their packet processing logic twice?

>
>> Doesn't it make sense to allow users to use the same code across
>> interfaces? You actually want them to rewrite their code to use a
>> totally different trigger point just because of some weird kernel
>> internals between interfaces?
>
> We're not building an abstraction over the kernel stack so that users
> won't have to worry how things work. Users need to have a minimal
> understanding of how specific hooks integrate with the stack and what
> they are for. And therefore why cls_bpf is actually more efficient to
> use in L3 tunnel case.

It's not like adding 7 lines of code constitutes adding an abstraction
layer. It's a pretty basic fix to make real things work for real
users. While you might argue that users should do something different,
you also can't deny that being able to hook up the same packet
processing to eth0, eth1, extrafancyeth2, and tun0 is a huge
convenience.

>
>> Why not make XDP more useful and more generic across interfaces? It's
>> very common for systems to be receiving packets with a heavy ethernet
>> card from the current data center, in addition to receiving packets
>> from a tunnel interface connected to a remote data center, with a need
>> to run the same XDP program on both interfaces. Why not support that
>> kind of simplicity?
>>
>> This is _actually_ something that's come up _repeatedly_. This is a
>> real world need from real users who are doing real things. Why not
>> help them?
>
> I'm sure it comes up repeatedly because we don't return any errors,
> so people waste time investigating why it doesn't work.

What? No. It comes up repeatedly because people want to reuse their
XDP processing logic with layer 3 devices. You might be right that if
we tell them to go away, maybe they will, but on the other hand, why
not make this actually work for them? It seems pretty easy to do, and
saves everyone a lot of time.

Are you worried about adding a branch to the
already-slower-and-discouraged non-hardware generic path? If so, I
wouldn't object if you wanted to put unlikely() around the branch
condition in that if statement.

Jason
