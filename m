Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5AE4AB83
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 22:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730519AbfFRUPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 16:15:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47524 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729331AbfFRUPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 16:15:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdKW4-0006Xp-Hi; Tue, 18 Jun 2019 22:15:40 +0200
Message-ID: <97cbfb3723607c95d78e25785262ae7b0acdb11c.camel@sipsolutions.net>
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
Date:   Tue, 18 Jun 2019 22:15:38 +0200
In-Reply-To: <CAK8P3a3ksrFTo2+dLB+doLeY+kPP7rYxv2O7BwvjYgK2cwCTuQ@mail.gmail.com> (sfid-20190618_220958_615605_BA64D8AA)
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
         (sfid-20190618_220958_615605_BA64D8AA)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 22:09 +0200, Arnd Bergmann wrote:
> 
> > One is the whole multi-function device, where a single WWAN device is
> > composed of channels offered by actually different drivers, e.g. for a
> > typical USB device you might have something like cdc_ether and the
> > usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
> > similarly, e.g. by using the underlying USB device "struct device"
> > pointer to tie it together.
> > 
> > The other is something like IPA or the Intel modem driver, where the
> > device is actually a single (e.g. PCIe) device and just has a single
> > driver, but that single driver offers different channels.
> 
> I would hope we can simplify this to expect only the second model,
> where you have a 'struct device' corresponding to hardware and the
> driver for it creates one wwan_device that user space talks to.

I'm not sure.

Fundamentally, we have drivers in Linux for the ethernet part, for the
TTY part, and for whatever other part might be in a given USB multi-
function device.

> Clearly the multi-function device hardware has to be handled somehow,
> but it would seem much cleaner in the long run to do that using
> a special workaround rather than putting this into the core interface.

I don't think it really makes the core interface much more complex or
difficult though, and it feels easier than writing a completely
different USB driver yet again for all these devices?

As far as I understand from Dan, sometimes they really are no different
from a generic USB TTY and a generic USB ethernet, except you know that
if those show up together it's a modem.

> E.g. have a driver that lets you create a wwan_device by passing
> netdev and a tty chardev into a configuration interface, and from that
> point on use the generic wwan abstraction.

Yeah, but where do you hang that driver? Maybe the TTY function is
actually a WWAN specific USB driver, but the ethernet is something
generic that can also work with pure ethernet USB devices, and it's
difficult to figure out how to tie those together. The modules could
load in completely different order, or even the ethernet module could
load but the TTY one doesn't because it's not configured, or vice versa.

> > Now, it's not clear to me where IPA actually falls, because so far we've
> > been talking about the IPA driver only as providing *netdevs*, not any
> > control channels, so I'm not actually sure where the control channel is.
> 
> The IPA driver today only handles the data path, because Alex removed
> the control channel. IPA is the driver that needs to talk to the hardware,
> both for data and control when finished. rmnet is a pure software construct
> that also contains both a data and control side and is designed to be
> independent of the lower hardware.

I'd actually be interested in what the control path should be like.

Is it also muxed on QMAP in the same way?

johannes

