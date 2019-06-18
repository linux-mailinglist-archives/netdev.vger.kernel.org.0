Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA44A4AA91
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 21:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfFRTDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 15:03:50 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45964 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbfFRTDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 15:03:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdJOJ-000510-0v; Tue, 18 Jun 2019 21:03:35 +0200
Message-ID: <abdfc6b3a9981bcdef40f85f5442a425ce109010.camel@sipsolutions.net>
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
Date:   Tue, 18 Jun 2019 21:03:31 +0200
In-Reply-To: <d533b708-c97a-710d-1138-3ae79107f209@linaro.org> (sfid-20190618_154530_836620_A8CD82A2)
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
         (sfid-20190618_154530_836620_A8CD82A2)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 08:45 -0500, Alex Elder wrote:

> If it had a well-defined way of creating new channels to be
> multiplexed over the connection to the modem, the IPA driver
> (rather than the rmnet driver) could present network interfaces
> for each and perform the multiplexing.  

Right. That's what I was thinking of.

I actually expect this to fare much better going forward with 5G around
the corner, since you'll want to eventually take advantage of multi-
queue TX or RSS for RX, queue size control and what not, as speeds
increase.

Because of these things I think the whole "layered netdev" approach is
actually *wrong* rather than just inconvenient.

In particular, in the Intel driver, you're going to have multiple
hardware queues, one for each ongoing session. This means that
multiplexing it over a layered netdev like rmnet or something like VLAN
(which some driver does too) actually prevents us from doing this
properly - it means we need to implement ndo_select_queue() and multiple
queues on the underlying netdev etc., and then we no longer have the
ability to use actual multi-queue. It becomes messy very very quickly.

> As I think Arnd
> suggested, this could at least partially be done with library
> code (to be shared with other "back-end" interfaces) rather
> than using a layered driver.  This applies to aggregation,
> channel flow control, and checksum offload as well.

Right.

> But I'm only familiar with IPA; I don't know whether the above
> statements make any sense for other "back-end" drivers.

I think they do, in different ways. Intel probably wouldn't have a
library - there isn't actually much of a MUX header because there are
different hardware queues for the different sessions.

> This is great.  The start of a more concrete discussion of the
> pieces that are missing...

:-)

I think I said before - it should be pretty easy to mold some code
around the API I proposed there and have something reasonably functional
soon.

> That would be nice.  I believe you're saying that (in my case)
> the IPA driver creates and owns the netdevices.

Yes.

> But I think the IPA driver would register with the WWAN core as
> a "provider," and then the WWAN core would subsequently request
> that it instantiate netdevices to represent channels on demand
> (rather than registering them).

Yeah, I guess you could call it that way.

Really there are two possible ways (and they intersect to some extent).

One is the whole multi-function device, where a single WWAN device is
composed of channels offered by actually different drivers, e.g. for a
typical USB device you might have something like cdc_ether and the
usb_wwan TTY driver. In this way, we need to "compose" the WWAN device
similarly, e.g. by using the underlying USB device "struct device"
pointer to tie it together.

The other is something like IPA or the Intel modem driver, where the
device is actually a single (e.g. PCIe) device and just has a single
driver, but that single driver offers different channels.

Now, it's not clear to me where IPA actually falls, because so far we've
been talking about the IPA driver only as providing *netdevs*, not any
control channels, so I'm not actually sure where the control channel is.

For the Intel device, however, the control channel is definitely
provided by exactly the same driver as the data channels (netdevs).

"provider" is a good word, and in fact the Intel driver would also be a
provider for a GNSS channel (TBD how to represent, a tty?), one or
multiple debug/tracing channels, data channels (netdevs), AT command
channels (mbim, ...?) (again tbd how to represent, ttys?), etc.

What I showed in the header files I posted so far was the provider only
having "data channel" ops (create/remove a netdev) but for each channel
type we either want a new method there, or we just change the method to
be something like

	int (*create_channel)(..., enum wwan_chan_type chan_type, ...);

and simply require that the channel is attached to the wwan device with
the representation-specific call (wwan_attach_netdev, wwan_attach_tty,
...).

This is a bit less comfortable because then it's difficult to know what
was actually created upon the request, so it's probably better to have
different methods for the different types of representations (like I had
- add_netdev, add_tty, ...).

Note also that I said "representation-specific", while passing a
"channel type", so for this we'd actually need a convention on what
channel type has what kind of representation, which again gets awkward.
Better to make it explicit.

(And even then, we might be able to let userspace have some control,
e.g. the driver might be able to create a debug channel as both a TTY or
something else)

johannes

