Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F554811A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFQLm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:42:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40640 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfFQLmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:42:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hcq22-0003pC-6x; Mon, 17 Jun 2019 13:42:38 +0200
Message-ID: <dbb32f185d2c3a654083ee0a7188379e1f88d899.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>, Dan Williams <dcbw@redhat.com>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
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
Date:   Mon, 17 Jun 2019 13:42:36 +0200
In-Reply-To: <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com> (sfid-20190612_170637_190349_3B0027EE)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <fc0d08912bc10ad089eb74034726308375279130.camel@redhat.com>
         <36bca57c999f611353fd9741c55bb2a7@codeaurora.org>
         <153fafb91267147cf22e2bf102dd822933ec823a.camel@redhat.com>
         <CAK8P3a2Y+tcL1-V57dtypWHndNT3eDJdcKj29c_v+k8o1HHQig@mail.gmail.com>
         <f4249aa5f5acdd90275eda35aa16f3cfb29d29be.camel@redhat.com>
         <CAK8P3a2nzZKtshYfomOOSYkqx5HdU15Wr9b+3va0B1euNhFOAg@mail.gmail.com>
         (sfid-20190612_170637_190349_3B0027EE)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-06-12 at 17:06 +0200, Arnd Bergmann wrote:
> On Wed, Jun 12, 2019 at 4:28 PM Dan Williams <dcbw@redhat.com> wrote:
> > On Wed, 2019-06-12 at 10:31 +0200, Arnd Bergmann wrote:
> > > On Tue, Jun 11, 2019 at 7:23 PM Dan Williams <dcbw@redhat.com> wrote:
> > 
> > I was trying to make the point that rmnet doesn't need to care about
> > how the QMAP packets get to the device itself; it can be pretty generic
> > so that it can be used by IPA/qmi_wwan/rmnet_smd/etc.
> 
> rmnet at the moment is completely generic in that regard already,
> however it is implemented as a tunnel driver talking to another
> device rather than an abstraction layer below that driver.

It doesn't really actually *do* much other than muck with the headers a
small amount, but even that isn't really much.

You can probably implement that far more efficiently on some devices
where you have a semi-decent DMA engine that at least supports S/G.

> > > I understand that the rmnet model was intended to provide a cleaner
> > > abstraction, but it's not how we normally structure subsystems in
> > > Linux, and moving to a model more like how wireless_dev works
> > > would improve both readability and performance, as you describe
> > > it, it would be more like (ignoring for now the need for multiple
> > > connections):
> > > 
> > >    ipa_dev
> > >         rmnet_dev
> > >                wwan_dev
> > >                       net_device
> > 
> > Perhaps I'm assuming too much from this diagram but this shows a 1:1
> > between wwan_dev and "lower" devices.

I guess the fuller picture would be something like

ipa_dev
	rmnet_dev
		wwan_dev
			net_device*

(i.e. with multiple net_devices)

> > What Johannes is proposing (IIRC) is something a bit looser where a
> > wwan_dev does not necessarily provide netdev itself, but is instead the
> > central point that various channels (control, data, gps, sim card, etc)
> > register with. That way the wwan_dev can provide an overall view of the
> > WWAN device to userspace, and userspace can talk to the wwan_dev to ask
> > the lower drivers (ipa, rmnet, etc) to create new channels (netdev,
> > tty, otherwise) when the control channel has told the modem firmware to
> > expect one.

Yeah, that's more what I had in mind after all our discussions (will
continue this below).

> Right, as I noted above, I simplified it a bit. We probably want to
> have multiple net_device instances for an ipa_dev, so there has
> to be a 1:n relationship instead of 1:1 at one of the intermediate
> levels, but it's not obvious which level that should be.
> 
> In theory we could even have a single net_device instance correspond
> to the ipa_dev, but then have multiple IP addresses bound to it,
> so each IP address corresponds to a channel/queue/napi_struct,
> but the user visible object remains a single device.

I don't think this latter (multiple IP addresses) works well - you want
a hardware specific header ("ETH_P_MAP") to carry the channel ID,
without looking up the IP address and all that.


But anyway, as I alluded to above, I had something like this in mind:

driver_dev
  struct device *dev (USB, PCI, ...)
  net_device NA
  net_device NB
  tty TA
 ...

(I'm cutting out the rmnet layer here for now)

while having a separate that just links all the pieces together:

wwan_device W
  ---> dev
  ---> NA
  ---> NB
  ---> TA

So the driver is still responsible for creating the netdevs (or can of
course delegate that to an "rmnet" library), but then all it also does
is register the netdevs with the WWAN core like

	wwan_add_netdev(dev, NA)

and the WWAN core would allocate the wwan_device W for this.

That way, the drivers can concentrate on providing all the necessary
bits, and - crucially - even *different* drivers can end up linking to
the same wwan_device. For example, if you have a modem that has a multi-
function USB device, then an ethernet driver might create the netdev and
a tty driver might create the control channel, but if they both agree on
using the right "struct device" instance, you can still get the correct
wwan_device out of it all.

And, in fact, some should then be

	wwan_maybe_add_netdev(dev, N)

because the ethernet driver may not know if it attached to a modem or
not, but if the control channel also attaches it's a modem for sure,
with that ethernet channel attached to it.

Additionally, I'm thinking API such as

	wwan_add(dev, &ops, opsdata)

that doesn't automatically attach any channels, but provides "ops" to
the core to create appropriate channels. I think this latter would be
something for IPA/rmnet to use, perhaps for rmnet to offer the right ops
structure.

johannes

