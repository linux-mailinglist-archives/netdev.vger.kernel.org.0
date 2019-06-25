Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F655516A
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbfFYOUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 10:20:08 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:36574 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfFYOUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 10:20:08 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hfmId-0005Mb-Le; Tue, 25 Jun 2019 16:19:55 +0200
Message-ID: <efbcb3b84ff0a7d7eab875c37f3a5fa77e21d324.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>, Alex Elder <elder@linaro.org>
Cc:     Dan Williams <dcbw@redhat.com>,
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
Date:   Tue, 25 Jun 2019 16:19:54 +0200
In-Reply-To: <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com> (sfid-20190624_184119_378618_FFFDB00F)
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
         <db34aa39-6cf1-4844-1bfe-528e391c3729@linaro.org>
         <CAK8P3a1ixL9ZjYz=pWTxvMfeD89S6QxSeHt9ZCL9dkCNV5pMHQ@mail.gmail.com>
         (sfid-20190624_184119_378618_FFFDB00F)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 18:40 +0200, Arnd Bergmann wrote:
> On Mon, Jun 24, 2019 at 6:21 PM Alex Elder <elder@linaro.org> wrote:
> > On 6/18/19 2:03 PM, Johannes Berg wrote:
> > 
> > > Really there are two possible ways (and they intersect to some extent).
> > > 
> > > One is the whole multi-function device, where a single WWAN device is
> > > composed of channels offered by actually different drivers, e.g. for a
> > > typical USB device you might have something like cdc_ether and the
> > > usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
> > > similarly, e.g. by using the underlying USB device "struct device"
> > > pointer to tie it together.
> > 
> > I *think* this model makes the most sense.  But at this point
> > it would take very little to convince me otherwise...  (And then
> > I saw Arnd's message advocating the other one, unfortunately...)
> > 
> > > The other is something like IPA or the Intel modem driver, where the
> > > device is actually a single (e.g. PCIe) device and just has a single
> > > driver, but that single driver offers different channels.
> > 
> > What I don't like about this is that it's more monolithic.  It
> > seems better to have the low-level IPA or Intel modem driver (or
> > any other driver that can support communication between the AP
> > and WWAN device) present communication paths that other function-
> > specific drivers can attach to and use.
> 
> I did not understand Johannes description as two competing models
> for the same code, but rather two kinds of existing hardware that
> a new driver system would have to deal with.

Right.

> I was trying to simplify it to just having the second model, by adding
> a hack to support the first, but my view was rather unpopular so
> far, so if everyone agrees on one way to do it, don't worry about me ;-)

:-)

However, to also reply to Alex: I don't know exactly how IPA works, but
for the Intel modem at least you can't fundamentally have two drivers
for different parts of the functionality, since it's just a single piece
of hardware and you need to allocate hardware resources from a common
pool etc. So you cannot split the driver into "Intel modem control
channel driver" and "Intel modem data channel driver". In fact, it's
just a single "struct device" on the PCIe bus that you can bind to, and
only one driver can bind at a time.

So, IOW, I'm not sure I see how you'd split that up. I guess you could
if you actually do something like the "rmnet" model, and I suppose
you're free to do that for IPA if you like, but I tend to think that's
actually a burden, not a win since you just get more complex code that
needs to interact with more pieces. A single driver for a single
hardware that knows about the few types of channels seems simpler to me.

> - to answer Johannes question, my understanding is that the interface
>   between kernel and firmware/hardware for IPA has a single 'struct
>   device' that is used for both the data and the control channels,
>   rather than having a data channel and an independent control device,
>   so this falls into the same category as the Intel one (please correct
>   me on that)

That sounds about the same then, right.

Are the control channels to IPA are actually also tunnelled over the
rmnet protocol? And even if they are, perhaps they have a different
hardware queue or so? That'd be the case for Intel - different hardware
queue, same (or at least similar) protocol spoken for the DMA hardware
itself, but different contents of the messages obviously.

> - The user space being proprietary is exactly what we need to avoid
>   with the wwan subsystem. We need to be able to use the same
>   method for setting up Intel, Qualcomm, Samsung, Unisoc or
>   Hisilicon modems or anything else that hooks into the subsystem,
>   and support that in network manager as well as the Android
>   equivalent.
>   If Qualcomm wants to provide their own proprietary user space
>   solution, we can't stop them, but then that should also work on
>   all the others unless they intentionally break it. ;-)

:-)

I tend to think there's always going to be some level of specific
handling here, because e.g. the Intel modem can expose MBIM or AT
command control channels, but not much else (that'd be useful for us
anyway, since we don't know how to speak debug protocol etc.). Other
modems will expose *only* AT commands, or *only* MBIM, and yet others
may also offer QMI and then that might be preferable.

> > > and simply require that the channel is attached to the wwan device with
> > > the representation-specific call (wwan_attach_netdev, wwan_attach_tty,
> > > ...).
> > 
> > Or maybe have the WWAN device present interfaces with attributes,
> > and have drivers that are appropriate for each interface attach
> > to only the ones they recognize they support.
> 
> I think you both mean the same thing here, a structure with callback
> pointers that may or may not be filled by the driver depending on its
> capabilities.

:-)

> What we should try to avoid though is a way to add driver private
> interfaces that risk having multiple drivers create similar functionality
> in incompatible ways.

Right.

johannes

