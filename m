Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDBA4ABF5
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfFRUjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:39:40 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47828 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbfFRUjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:39:40 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdKt4-0006wN-US; Tue, 18 Jun 2019 22:39:27 +0200
Message-ID: <54a5acb6cf26ebc6447f8ebcbdcb8e0eed693ab3.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alex Elder <elder@linaro.org>, Dan Williams <dcbw@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        abhishek.esse@gmail.com, Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Date:   Tue, 18 Jun 2019 22:39:24 +0200
In-Reply-To: <CAK8P3a29+JKbDdS9ikhgaKa-AJ1qd1sDMTAfzivGh5wN4VL88A@mail.gmail.com> (sfid-20190618_223407_865082_9D7B2E70)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
         <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
         <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
         <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
         <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
         <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
         <d533b708-c97a-710d-1138-3ae79107f209@linaro.org>
         <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
         <CAK8P3a3ksrFTo2+dLB+doLeY+kPP7rYxv2O7BwvjYgK2cwCTuQ@mail.gmail.com>
         <97cbfb3723607c95d78e25785262ae7b0acdb11c.camel@sipsolutions.net>
         <CAK8P3a29+JKbDdS9ikhgaKa-AJ1qd1sDMTAfzivGh5wN4VL88A@mail.gmail.com>
         (sfid-20190618_223407_865082_9D7B2E70)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 22:33 +0200, Arnd Bergmann wrote:

> > Yeah, but where do you hang that driver? Maybe the TTY function is
> > actually a WWAN specific USB driver, but the ethernet is something
> > generic that can also work with pure ethernet USB devices, and it's
> > difficult to figure out how to tie those together. The modules could
> > load in completely different order, or even the ethernet module could
> > load but the TTY one doesn't because it's not configured, or vice versa.
> 
> That was more or less my point: The current drivers exist, but don't
> lean themselves to fitting into a new framework, so maybe the best
> answer is not to try fitting them.
> 
> To clarify: I'm not suggesting to write new USB drivers for these at all,
> but instead keep three parts that are completely unaware of each other
> a)  a regular netdevice driver
> b)  a regular tty driver
> c)  the new wwan subsystem that expects a device to be created
>     from a hardware driver but knows nothing of a) and b)
> 
> To connect these together, we need one glue driver that implements
> the wwan_device and talks to a) and b) as the hardware. There are
> many ways to do that. One way would be to add a tty ldisc driver.
> A small user space helper opens the chardev, sets the ldisc
> and then uses an ldisc specific ioctl command to create a wwan
> device by passing an identifier of the netdevice and then exits.
> From that point on, you have a wwan device like any other.

Well, ok. I don't think it'd really work that way ("passing an
identifier of the netdevice") because you could have multiple
netdevices, but I see what you mean in principle.

It seems to me though that this is far more complex than what I'm
proposing? What I'm proposing there doesn't even need any userspace
involvement, as long as all the pieces are in the different sub-drivers, 
they'd fall out automatically.

And realistically, the wwan_device falls out anyway at some point, the
only question is if we really make one specific driver be the "owner" of
it. I'm suggesting that we don't, and just make its lifetime depend on
the links to parts it has (unless something like IPA actually wants to
be an owner).

johannes

