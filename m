Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF4C4AA3A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbfFRStA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:49:00 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45808 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729642AbfFRStA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:49:00 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdJ9q-0004lc-GY; Tue, 18 Jun 2019 20:48:38 +0200
Message-ID: <967604dd8d466a99b865649174f8b9cd34b2560e.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
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
Date:   Tue, 18 Jun 2019 20:48:33 +0200
In-Reply-To: <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org> (sfid-20190618_172042_951332_21BBC6A6)
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
         <e6ba8a9063e63506c0b88a70418d74ca4efe85cd.camel@sipsolutions.net>
         <850eed1d-0fec-c396-6e91-b5f1f8440ded@linaro.org>
         (sfid-20190618_172042_951332_21BBC6A6)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just to add to Dan's response, I think he's captured our discussions and
thoughts well.

> First, a few terms (correct or improve as you like):

Thanks for defining, we don't do that nearly often enough.

> - WWAN device is a hardware device (like IPA) that presents a
>   connection between AP and modem, and presents an interface
>   that allows the use of that connection to be managed.

Yes. But I was actually thinking of a "wwan_dev" to be a separate
structure, not *directly* owned by a single driver and used to represent
the hardware like a (hypothetical) "struct ipa_dev".

> - WWAN netdevice represents a Linux network interface, with its
>   operations and queues, etc., but implements a standardized
>   set of WWAN-specific operations.  It represents a logical
> ' channel whose data is multiplexed over the WWAN device.

I'm not sure I'd asy it has much WWAN-specific operations? But yeah, I
guess it might.

> - WWAN channel is a user space abstraction that corresponds
>   with a WWAN netdevice (but I'm not clear on all the ways
>   they differ or interact).

As Dan said, this could be a different abstraction than a netdevice,
like a TTY, etc.

> - The WWAN core is kernel code that presents abstractions
>   for WWAN devices and netdevices, so they can be managed
>   in a generic way.  It is for configuration and communication
>   and is not at all involved in the data path.
> 
> You're saying that the WWAN driver space calls wwan_add()
> to register itself as a new WWAN device.

Assuming it knows that it is in fact a WWAN device, like IPA.

> You're also saying that a WWAN device "attaches" a WWAN
> netdevice, which is basically notifying the WWAN core
> that the new netdev/channel is available for use.
> - I trust that a "tentative" attachement is necessary.  But
>   I'm not sure what makes it transition into becoming a
>   "real" one, or how that event gets communicated.

I think Dan explained this one well. This wasn't actually on my radar
until he pointed it out.

Really this only exists with USB devices that appear as multiple
functions (ethernet, tty, ...) but still represent a single WWAN device,
with each function not necessarily being aware of that since it's just a
function driver.

Hopefully at least one of the function drivers will be able to figure it
out, and then we can combine all of the functions into the WWAN device
abstraction.

[snip - Dan's explanations are great]

Dan also said:

> > I read "attach" here as simply associating an existing netdev with the
> > "parent" WWAN device. A purely Linux operation that is only book-
> > keeping and may not have any interaction with the modem. 

Now I'm replying out of thread, but yes, that's what I had in mind. What
I meant by attaching (in this case) is just that you actually mark that
it is (or might be, if tentatively attached) part of a WWAN device.

> - Are there any attributes that are only optionally supported,
>   and if so, how are the supported ones communicated?

As Dan said, good point. I hadn't really considered that for now. I sort
of know that we need it, but for the sake of simplicity decided to elide
it for now. I'm just not sure what really are needed, and netlink
attributes make adding them (and discovering the valid ones) pretty easy
in the future, when a need arises.

> - Which WWAN channel attributes must be set *before* the
>   channel is activated, and can't be changed?  Are there any
>   that can be changed dynamically?

It's a good question. I threw a "u32 pdn" in there, but I'm not actually
sure that's what you *really* need?

Maybe the modem and userspace just agree on some arbitrary "session
identifier"? Dan mentions "MUX ID" or "MBIM Session ID", maybe there
really is no good general term for this and we should just call it a
"session identifier" and agree that it depends on the control protocol
(MBIM vs. QMI vs. ...)?

> And while the whole point of this is to make things generic,
> it might be nice to have a way to implement a new feature
> before it can be "standardized".

Not sure I understand this?

FWIW, I actually came to this because we want to upstream a driver for
an Intel modem, but ... can't really make up our mind on whether or not
to use VLAN tags, something like rmnet (but we obviously cannot use
rmnet, so that'd be another vendor specific interface like rmnet), or
sysfs, or any of the other methods we have today ... :-)

johannes

