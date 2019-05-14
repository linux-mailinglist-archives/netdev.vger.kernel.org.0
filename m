Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B2B1CE34
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 19:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfENRoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 13:44:54 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:44072 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfENRox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 13:44:53 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 015434A99;
        Tue, 14 May 2019 19:44:48 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 07473968;
        Tue, 14 May 2019 19:44:47 +0200 (CEST)
Date:   Tue, 14 May 2019 19:44:47 +0200
From:   Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
Message-ID: <20190514174447.GE93050@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
 <547abcff-103a-13b8-f42a-c0bd1d910bbc@linaro.org>
 <20190513090700.GW81826@meh.true.cz>
 <8cee0086-7459-24c7-82f9-d559527df6e6@linaro.org>
 <20190513111612.GA21475@meh.true.cz>
 <0c6cb9d4-2da1-00be-b527-5891b8b030a8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c6cb9d4-2da1-00be-b527-5891b8b030a8@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-14 16:13:22]:

> On 13/05/2019 12:16, Petr Štetiar wrote:
> > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 11:06:48]:
> > 
> > > On 13/05/2019 10:07, Petr Štetiar wrote:
> > > > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 09:25:55]:
> > > > 
> > > > > My initial idea was to add compatible strings to the cell so that most of
> > > > > the encoding information can be derived from it. For example if the encoding
> > > > > representing in your example is pretty standard or vendor specific we could
> > > > > just do with a simple compatible like below:
> > > > 
> > > > that vendor/compatible list would be quite long[1], there are hundreds of
> > > 
> > > You are right just vendor list could be very long, but I was hoping that the
> > > post-processing would fall in some categories which can be used in
> > > compatible string.
> > > 
> > > Irrespective of which we need to have some sort of compatible string to
> > > enable nvmem core to know that there is some form of post processing to be
> > > done on the cells!. Without which there is a danger of continuing to adding
> > > new properties to the cell bindings which have no relation to each other.
> > 
> > makes sense, so something like this would be acceptable?
> > 
> >   eth1_addr: eth-mac-addr@18a {
> >       /* or rather linux,nvmem-post-process ? */
> >       compatible = "openwrt,nvmem-post-process";
> 
> I don't think this would be a correct compatible string to use here.
> Before we decide on naming, I would like to understand bit more on what are
> the other possible forms of storing mac address,
> Here is what I found,
> 
> Type 1: Octets in ASCII without delimiters. (Swapped/non-Swapped)
> Type 2: Octets in ASCII with delimiters like (":", ",", ".", "-"... so on)
> (Swapped/non-Swapped)
> Type 3: Is the one which stores mac address in Type1/2 but this has to be
> incremented to be used on other instances of eth.
> 
> Did I miss anything?

Type 4: Octets as bytes/u8, swapped/non-swapped

Currently just type4-non-swapped is supported. Support for type4-swapped was
goal of this patch series.

I've simply tried to avoid using mac-address for the compatible as this
provider could be reused by other potential nvmem consumers. The question is,
how much abstracted it should be then.

> My suggestion for type1 and type2 would be something like this, as long as
> its okay with DT maintainers
> 
> eth1_addr: eth-mac-addr@18a {
> 	compatible = "ascii-mac-address";
> 	reg = <0x18a 2>, <0x192 2>, <0x196 2>, <0x200 2>, <0x304 2>, <0x306 2>;
> 	swap-mac-address;
> 	delimiter = ":";
> };

with this reg array, you don't need the delimiter property anymore, do you?

> For type 3:
>
> This sounds like very much vendor specific optimization thing which am not
> 100% sure atm.  If dt maintainers are okay, may be we can add an increment
> in the "ascii-mac-address" binding itself.
> 
> Do you think "increment-at " would ever change?

Currently there's just one such real world use case in OpenWrt tree[1].
Probably some vendor decided to increment 4th octet.

> This [1] is what I had suggested at the end, where in its possible to add
> provider node with its own custom bindings. In above example nvmem_dev would
> be a proper nvmem provider.

Ok, thanks.

1. https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob;f=target/linux/ath79/dts/ar9331_embeddedwireless_dorin.dts;h=43bec35fa2860fe4d52880ad24ff7c56f5060a0a;hb=HEAD#l109

-- ynezz
