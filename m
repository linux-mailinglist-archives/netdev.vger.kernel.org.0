Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60B427F665
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgI3X7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:59:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3X7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 19:59:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNm0L-00GyzR-BM; Thu, 01 Oct 2020 01:59:25 +0200
Date:   Thu, 1 Oct 2020 01:59:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Bilsby <d.bilsby@virgin.net>
Cc:     Petko Manolov <petkan@nucleusys.com>,
        Thor Thayer <thor.thayer@linux.intel.com>,
        netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Altera TSE driver not working in 100mbps mode
Message-ID: <20200930235925.GB3996795@lunn.ch>
References: <20191127135419.7r53qw6vtp747x62@p310>
 <20191203092918.52x3dfuvnryr5kpx@carbon>
 <c8e4fc3a-0f40-45b6-d9c8-f292c3fdec9d@virgin.net>
 <20200917064239.GA40050@p310>
 <9f312748-1069-4a30-ba3f-d1de6d84e920@virgin.net>
 <20200918171440.GA1538@p310>
 <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bbd5cc3a-51a9-d46c-ef24-f0bb4d6498fe@virgin.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I now seem to be tantalisingly close to getting it working. I can see
> network packets arriving if I do a "tcpdump -i eth0" using a copper
> 10/100/1000Base-T SFP, but no packets seem to be transmitted. I'm guessing
> I've maybe messed up on the device tree entries for either the SFP config or
> maybe how it links back to the TSE. In the TSE device tree section I added
> the following as suggested by your original post:
> 
>         sfp = <&sfp_eth_b>;
> 
>         managed = “in-band-status”;
> 
> Should I have added anything for the "phy-handle", thinks it's "<0>" at the
> moment?

If you have an SFP, you don't need a phy-handle, because you don't
have a copper PHY as such, just an SFP cage. What is in the cage is
phylinks problem.

> For the SFP device tree section I added the following at the top level which
> broadly followed the "sff,sfp" document:
> 
> / {
> 
>     sfp_eth_b: sfp-eth-b {
> 
>         compatible = “sff,sfp”;
> 
>         i2c-bus = <sfp_b_i2c>;
> 
>         los-gpios = <&pca9506 10 GPIO_ACTIVE_HIGH>;
> 
>         …
> 
>     };
> 
> };
> 
> The SFP cage is connected to the "sfp_b_i2c" I2C bus, this is actually off
> an I2C mux but that I'm hoping will be handled by Linux as it has a driver
> for the MUX chip.

That should work, there are other systems like this. 

> I assume the default SFP I2C address (0x50) is used by the PhyLink
> layer so there is no need to specify that?

You say you have a copper module inserted. This does not seem to be
well specified, and how you talk to the PHY does not seem to be well
defined. PHYLINK will try to setup an MDIO bus over I2C using an I2C
address which some vendors uses, and then probe around to try to find
the PHY. Any indication in dmesg that it found it? Most seem to use a
Marvell PHY, but there are some with Broadcom.

> The LED indicators for my set up are off another I2C GPIO expander
> (PCA9506), so I used those references for the LOS, etc "gpios"
> entries. This section also has the "tx-disable-gpios" property,
> again I referenced the appropriate pin off the PCA9506, so I guess
> if I got that wrong then that could explain the failure on the Tx
> side. That said none of the LED GPIOs I hooked up seemed to light so
> maybe there is something up there.
> Any hints would be most welcome.

What does ethtool -m show? With a copper module you might not get too
much useful information.

Also, what does ethtool on the link peer show? Has auto-neg worked?
What link modes are being advertised, etc?

The subject of this email thread is:

Altera TSE driver not working in 100mbps mode

Are you doing your testing at 1G or 100Mbps? I would suggest starting
out at 1G if you can.

      Andrew
