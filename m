Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF312AC05
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 13:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLZMBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 07:01:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40518 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfLZMBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 07:01:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5f9FO2IjRXu6jiUBvxbXob0IdCuPlK4tpmU4a1BrtKg=; b=rWgcDHsfNjmGjaw6IwHYelifmr
        fj0xuVrH1RZMuSbTKnitSYFhi8p7na9PWEenybBSr5DX/hFOYl8KAbjPKRxbmRabaD/gCNMjPnNW2
        ef8wtzMjzYeXZQJ3Oz5WBfb5+R3drXTZ0xjiYLJaBhXOhbmZDXqklw5xZ4DCfZxwtJ/w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ikRpd-0001x6-Vp; Thu, 26 Dec 2019 13:01:33 +0100
Date:   Thu, 26 Dec 2019 13:01:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com,
        linus.luessing@c0d3.blue, balbes-150@yandex.ru,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ingrassia@epigenesys.com, jbrunet@baylibre.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay
 on Meson8b/8m2 SoCs
Message-ID: <20191226120133.GI1480@lunn.ch>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
 <20191225150845.GA16671@lunn.ch>
 <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
 <20191226105044.GC1480@lunn.ch>
 <CAFBinCB8YQ-tuGBixO_85NFXDdrH5keDURFgri5tFLdrAwUJKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCB8YQ-tuGBixO_85NFXDdrH5keDURFgri5tFLdrAwUJKg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> the MAC is not capable of generating an RX delay (at least as far as I know).

So that immediately means rgmii is invalid as a phy-mode, since the
documentation implies the MAC needs to add RX delay.

> it's mostly "broken" (high TX packet loss, slow TX speeds) for the two
> supported boards with an RGMII PHY (meson8b-odroidc1.dts and
> meson8m2-mxiii-plus.dts)
> examples on the many ways it was broken will follow - feel free to
> skip this part

That is actually good. If it never worked, we don't need to worry
about breaking it! We can spend our time getting this correct, and not
have to worry about backwards compatibility, etc.

> > What we normally say is make the MAC add no delays, and pass the
> > correct configuration to the PHY so it adds the delay. But due to the
> > strapping pin on the rtl8211f, we are in a bit of a grey area. I would
> > suggest the MAC adds no delay, phy-mode is set to rmgii-id, the PHY
> > driver adds TX delay in software, we assume the strapping pin is set
> > to add RX delay, and we add a big fat comment in the DT.
> >
> > For the Micrel PHY, we do the same, plus add the vendor properties to
> > configure the clock skew.
> >
> > But as i said, we are in a bit of a grey area. We can consider other
> > options, but everything needs to be self consistent, between what the
> > MAC is doing, what the PHY is doing, and what phy-mode is set to in
> > DT.

> do you think it's worth the effort to get clarification from Realtek
> on the RX delay behavior (and whether there's a register to control
> it)?

You can ask. There are also datasheet here:

http://files.pine64.org/doc/datasheet/rock64/RTL8211F-CG-Realtek.pdf
https://datasheet.lcsc.com/szlcsc/1909021205_Realtek-Semicon-RTL8211F-CG_C187932.pdf

It looks like both RX and TX delay can be controlled via
strapping. But the register for controlling the TX delay is not
documented.

> you mentioned that there was breakage earlier this year, so I'm not sure anymore
> (that leaves me thinking: asking them is still useful to get out of
> this grey area)

It was an Atheros PHY with breakage.

If we can fully control the RX and TX delays, that would be great. It
would also be useful if there was a way to determine how the PHY has
been strapped. If we cannot fully control the delays but we can find
out what delays it is using, we can check the requested configuration
against the strapped configuration, and warn if they are different.

    Andrew
