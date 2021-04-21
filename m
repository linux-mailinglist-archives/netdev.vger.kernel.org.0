Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB78A366766
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbhDUI7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235313AbhDUI7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 04:59:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB79661442;
        Wed, 21 Apr 2021 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618995518;
        bh=64KJf6xIhQSnl3PhQoQ0a9YdaBe+gMwA8Np6LwW1+/4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KspKrNpocGC+THW2FQf8l/RTxYj9VsuAMN9o6fRqaCIHROlddiUnVoGVbSJevcK8P
         t9Ih4ay4gNZRHVDqglHOGunFJvorx346JxWj8TRSdxkGT0Mx+bIg6kSOy9/tw6wrli
         AyoCGd/Aj4lwDeEU4D5FwKzcgcMb/8X46RKGEXUG2g1sE3gyPvvaBF9LVNzp8ElJtH
         nxpWNiCTcCzxZsHmOA3b5MzE1AlJaFRQLBbGl79XxBJRzbOZ0HNJnsSBV2Azw6FIoW
         hMQ03qhaDP19GOcFUHxal2wg+Dsk2MwLLe7C5x4sfsipcA0LcpO/cD4GZh1Ilzc8Wj
         Fofb7CfADu1kg==
Received: by mail-wm1-f41.google.com with SMTP id y124-20020a1c32820000b029010c93864955so813562wmy.5;
        Wed, 21 Apr 2021 01:58:38 -0700 (PDT)
X-Gm-Message-State: AOAM531Kp2AXW+HY9HLB32geyZ/Va+EPyrxSSOZWhgjWMVsNx6Rt2fVK
        c+cGX8VWgxHhaUFtsVR+y4V+oS3IPsrXJ65rjbo=
X-Google-Smtp-Source: ABdhPJzfODrhPhGfivkqeugtVvYFeuZiRdEx50xM7G3CMPJPgDkMCFmpfx3SbcIBA3tmKParqz5KGFeTEwP9bSV2emc=
X-Received: by 2002:a05:600c:2282:: with SMTP id 2mr8921317wmf.84.1618995517297;
 Wed, 21 Apr 2021 01:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210416230724.2519198-1-willy@infradead.org> <20210416230724.2519198-2-willy@infradead.org>
 <20210417024522.GP2531743@casper.infradead.org> <9f99b0a0-f1c1-f3b0-5f84-3a4bfc711725@synopsys.com>
 <20210420031029.GI2531743@casper.infradead.org> <CAK8P3a0KUwf1Z0bHiUaHC2nHztevkxg5_FBSzHddNeSsBayWUA@mail.gmail.com>
 <8d0fce1c-be7c-1c9b-bf5c-0c531db496ac@synopsys.com> <CAK8P3a3rzz1gfNLoGC8aZJiAC-tgZYD6P8pQsoEfgCAmQK=FAw@mail.gmail.com>
 <5c41d562589b497ca3c1047e0e18b3a1@AcuMS.aculab.com>
In-Reply-To: <5c41d562589b497ca3c1047e0e18b3a1@AcuMS.aculab.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 21 Apr 2021 10:58:18 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2GN9HVwSjfsXaYVO29zeUNB1hQENRw1K0DXCLdt-M-qA@mail.gmail.com>
Message-ID: <CAK8P3a2GN9HVwSjfsXaYVO29zeUNB1hQENRw1K0DXCLdt-M-qA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: Fix struct page layout on 32-bit systems
To:     David Laight <David.Laight@aculab.com>
Cc:     Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Matthew Wilcox <willy@infradead.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "hch@lst.de" <hch@lst.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 10:43 AM David Laight <David.Laight@aculab.com> wrote:
> From: Arnd Bergmann Sent: 20 April 2021 22:20
> > On Tue, Apr 20, 2021 at 11:14 PM Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> > > On 4/20/21 12:07 AM, Arnd Bergmann wrote:
> >
> > > >
> > > > which means that half the 32-bit architectures do this. This may
> > > > cause more problems when arc and/or microblaze want to support
> > > > 64-bit kernels and compat mode in the future on their latest hardware,
> > > > as that means duplicating the x86 specific hacks we have for compat.
> > > >
> > > > What is alignof(u64) on 64-bit arc?
> > >
> > > $ echo 'int a = __alignof__(long long);' | arc64-linux-gnu-gcc -xc -
> > > -Wall -S -o - | grep -A1 a: | tail -n 1 | cut -f 3
> > > 8
> >
> > Ok, good.
>
> That test doesn't prove anything.
> Try running on x86:
> $ echo 'int a = __alignof__(long long);' | gcc -xc - -Wall -S -o - -m32
> a:
>         .long   8

Right, I had wondered about that one after I sent the email.

> Using '__alignof__(struct {long long x;})' does give the expected 4.
>
> __alignof__() returns the preferred alignment, not the enforced
> alignmnet - go figure.

I checked the others as well now, and i386 is the only one that
changed here: m68k still has '2', while arc/csky/h8300/microblaze/
nios2/or1k/sh/i386 all have '4' and the rest have '8'.

     Arnd
