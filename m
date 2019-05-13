Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3AD61B4B3
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 13:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbfEMLQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 07:16:17 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:31903 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727970AbfEMLQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 07:16:17 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 3DCB23F5A;
        Mon, 13 May 2019 13:16:14 +0200 (CEST)
Received: from localhost (meh.true.cz [local])
        by meh.true.cz (OpenSMTPD) with ESMTPA id 8168cc0a;
        Mon, 13 May 2019 13:16:12 +0200 (CEST)
Date:   Mon, 13 May 2019 13:16:12 +0200
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
Message-ID: <20190513111612.GA21475@meh.true.cz>
Reply-To: Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz>
 <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
 <547abcff-103a-13b8-f42a-c0bd1d910bbc@linaro.org>
 <20190513090700.GW81826@meh.true.cz>
 <8cee0086-7459-24c7-82f9-d559527df6e6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8cee0086-7459-24c7-82f9-d559527df6e6@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 11:06:48]:

> On 13/05/2019 10:07, Petr Štetiar wrote:
> > Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 09:25:55]:
> > 
> > > My initial idea was to add compatible strings to the cell so that most of
> > > the encoding information can be derived from it. For example if the encoding
> > > representing in your example is pretty standard or vendor specific we could
> > > just do with a simple compatible like below:
> > 
> > that vendor/compatible list would be quite long[1], there are hundreds of
> 
> You are right just vendor list could be very long, but I was hoping that the
> post-processing would fall in some categories which can be used in
> compatible string.
> 
> Irrespective of which we need to have some sort of compatible string to
> enable nvmem core to know that there is some form of post processing to be
> done on the cells!. Without which there is a danger of continuing to adding
> new properties to the cell bindings which have no relation to each other.

makes sense, so something like this would be acceptable?

 eth1_addr: eth-mac-addr@18a {
     /* or rather linux,nvmem-post-process ? */
     compatible = "openwrt,nvmem-post-process";
     reg = <0x189 0x11>;
     indices = < 0 2
                 3 2
                 6 2
                 9 2
                12 2
                15 2>;
     transform = "ascii";
     increment = <1>;
     increment-at = <5>;
     result-swap;
 };

 &eth1 {
     nvmem-cells = <&eth1_addr>;
     nvmem-cell-names = "mac-address";
 };

> > was very compeling as it would kill two birds with one stone (fix outstanding
> > MTD/NVMEM OF clash as well[2]),
> 
> Changes to nvmem dt bindings have been already rejected, for this more
> discussion at: https://lore.kernel.org/patchwork/patch/936312/

I know, I've re-read this thread several times, but it's still unclear to me,
how this should be approached in order to be accepted by you and by DT
maintainers as well.

Anyway, to sum it up, from your point of view, following is fine?

 flash@0 {
    partitions {
        art: partition@ff0000 {
            nvmem_dev: nvmem-cells {
                compatible = "nvmem-cells";
                eth1_addr: eth-mac-addr@189 {
                    compatible = "openwrt,nvmem-post-process";
                    reg = <0x189 0x6>;
                    increment = <1>;
                    increment-at = <5>;
                    result-swap;
                };
            };
        };
    };
 };

 &eth1 {
    nvmem = <&nvmem_dev>;
    nvmem-cells = <&eth1_addr>;
    nvmem-cell-names = "mac-address";
 };

-- ynezz
