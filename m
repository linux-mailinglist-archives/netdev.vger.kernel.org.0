Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72DA812ABBA
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 11:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfLZKu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 05:50:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40428 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725954AbfLZKu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 05:50:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WWQCvAOj9VPIiUVGyfQ33Wwo9TwBrEqStTy3iF0TRKI=; b=5ENSPtWuCLATBd8/kwa0/36DDH
        LgALFZw7cT3ojHPLSyxbRZynys24RXrvRE+4Hoa9l1gxwiTtzjWZ7v1ndSEl+oCZqWVHzg6NgsDfy
        toS1nInW/8n8kzoXlBewdmyw3zos4MOsbNjS5iw3G9T8kM6A4qeCczP0Bcz7SHQsSvNg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ikQj6-00013d-GX; Thu, 26 Dec 2019 11:50:44 +0100
Date:   Thu, 26 Dec 2019 11:50:44 +0100
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
Message-ID: <20191226105044.GC1480@lunn.ch>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
 <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
 <20191225150845.GA16671@lunn.ch>
 <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFBinCA4X1e5_5nBiHmNiB40uJyr9Nm1b2VkF9NqM+wb7-1xmw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >       # RX and TX delays are added by the MAC when required
> >       - rgmii
> >
> >       # RGMII with internal RX and TX delays provided by the PHY,
> >       # the MAC should not add the RX or TX delays in this case
> >       - rgmii-id
> >
> >       # RGMII with internal RX delay provided by the PHY, the MAC
> >       # should not add an RX delay in this case
> >       - rgmii-rxid
> >
> >       # RGMII with internal TX delay provided by the PHY, the MAC
> >       # should not add an TX delay in this case
> >       - rgmii-txid
> >
> > So ideally, you want the MAC to add no delay at all, and then use the
> > correct phy-mode so the PHY adds the correct delay. This gives you the
> > most flexibility in terms of PHY and PCB design. This does however
> > require that the PHY implements the delay, which not all do.
> these boards (with RGMII PHY) that I am aware of are using an RTL8211F
> PHY which implements a 2ns PHY TX delay

We need to be careful here...

Earlier this year we got into a mess with a PHY driver wrongly
implemented these delays. DT contained 'rgmii', but the PHY driver
actually implemented rgmii-id'. Boards worked, because they actually
needed rgmii-id. But then came along a board which really did need
rgmii. We took the decision, maybe the wrong decision, to fix the PHY
driver, and fixup DT files as we found boards which had the incorrect
setting. We broke a lot of boards for a while and caused lots of
people pain.

You might have something which works, but i want to be sure it is
actually correct, not two bugs cancelling each other out.

You say the RTL8211F PHY implements a 2ns PHY TX delay. So in DT, do
you have the phy-mode of 'rgmii-txid'? That would be the correct
setting to say that the PHY provides only the TX delay.

> however, the 3.10 vendor kernel also supports Micrel RGMII (and RMII)
> PHYs where I don't know if they implement a (configurable) TX delay.
> 
> > Looking at patches 2 and 3, the phy-mode is set to rgmii. What you
> > might actually need to do is set this to rgmii-txid, or maybe
> > rgmii-id, once you have the MAC not inserting any delay.
> please let us split this discussion:
> 1) I believe that this patch is still correct and required whenever
> the MAC *has to* generate the TX delay (one use-case could be the
> Micrel PHYs I mentioned above)

I think this patch splits into two parts. One is getting a 25MHz
clock. That part i can agree with straight away. The second part is
setting a 2ns TX delay. This we need to be careful of. What is the MAC
actually doing after this patch? What is the configured RX delay? Does
the driver explicitly configure the RX delay? To what?

If you look at the definitions above, if the phy-mode is rgmii, the
MAC is responsible for both RX and TX delay. 

> 2) the correct phy-mode and where the TX delay is being generated. I
> have tried "rgmii-txid" on my own Odroid-C1 and it's working fine
> there. however, it's the only board with RGMII PHY that I have from
> this generation of SoCs (and other testers are typically rare for this
> platform, because it's an older SoC). so my idea was to use the same
> settings as the 3.10 vendor kernel because these seem to be the "known
> working" ones.

Vendor kernels have the alternative of 'vendor crap' for a good
reason. Just because it works does not mean it is correct.

> what do you think about 2)? my main concern is that this *could* break
> Ethernet on other people's boards.
> on the other hand I have no idea how likely that actually is.

From what i understand, Ethernet is already broken? Or is it broken on
just some boards?

Looking at the function rtl8211f_config_init(), that PHY driver can
only control TX delays. RX delays are controlled by a strapping pin.

The Micrel PHY driver can also control its clock skew, but it does it
in an odd way, not via the phy-mode, but via additional
properties. See the binding document.

What we normally say is make the MAC add no delays, and pass the
correct configuration to the PHY so it adds the delay. But due to the
strapping pin on the rtl8211f, we are in a bit of a grey area. I would
suggest the MAC adds no delay, phy-mode is set to rmgii-id, the PHY
driver adds TX delay in software, we assume the strapping pin is set
to add RX delay, and we add a big fat comment in the DT.

For the Micrel PHY, we do the same, plus add the vendor properties to
configure the clock skew.

But as i said, we are in a bit of a grey area. We can consider other
options, but everything needs to be self consistent, between what the
MAC is doing, what the PHY is doing, and what phy-mode is set to in
DT.

    Andrew
