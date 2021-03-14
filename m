Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150B933A2AB
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 05:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbhCNEg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 23:36:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234142AbhCNEgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Mar 2021 23:36:48 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lLIUS-00AngM-UY; Sun, 14 Mar 2021 05:36:32 +0100
Date:   Sun, 14 Mar 2021 05:36:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
Message-ID: <YE2S0MW62lVF/psk@lunn.ch>
References: <cover.1615423279.git.cristian.ciocaltea@gmail.com>
 <158d63db7d17d87b01f723433e0ddc1fa24377a8.1615423279.git.cristian.ciocaltea@gmail.com>
 <YEwO33TR7ENHuMaY@lunn.ch>
 <20210314011324.GA991090@BV030612LT>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210314011324.GA991090@BV030612LT>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +	if (phy->interface != PHY_INTERFACE_MODE_RMII) {
> > > +		netdev_err(netdev, "unsupported phy mode: %s\n",
> > > +			   phy_modes(phy->interface));
> > > +		phy_disconnect(phy);
> > > +		netdev->phydev = NULL;
> > > +		return -EINVAL;
> > > +	}
> > 
> > It looks like the MAC only supports symmetric pause. So you should
> > call phy_set_sym_pause() to let the PHY know this.
> 
> I did not find any reference related to the supported pause types,
> is this normally dependant on the PHY interface mode?

There is a MAC / PHY split there. The PHY is responsible for the
negotiation for what each end can do. But it is the MAC which actually
implements pause. The MAC needs to listen to pause frames and not send
out data frames when the link peer indicates pause. And the MAC needs
to send a pause frames when its receive buffers are full. The code you
have in this MAC driver seems to indicate the MAC only supports
symmetric pause. Hence you need to configure the PHY to only auto-neg
symmetric pause.

> > > +	ret = crypto_skcipher_encrypt(req);
> > > +	if (ret) {
> > > +		dev_err(dev, "failed to encrypt S/N: %d\n", ret);
> > > +		goto err_free_tfm;
> > > +	}
> > > +
> > > +	netdev->dev_addr[0] = 0xF4;
> > > +	netdev->dev_addr[1] = 0x4E;
> > > +	netdev->dev_addr[2] = 0xFD;
> > 
> > 0xF4 has the locally administered bit 0. So this is a true OUI. Who
> > does it belong to? Ah!
> > 
> > F4:4E:FD Actions Semiconductor Co.,Ltd.(Cayman Islands)
> > 
> > Which makes sense. But is there any sort of agreement this is allowed?
> > It is going to cause problems if they are giving out these MAC
> > addresses in a controlled way.
> 
> Unfortunately this is another undocumented logic taken from the vendor
> code. I have already disabled it from being built by default, although,
> personally, I prefer to have it enabled in order to get a stable MAC
> address instead of using a randomly generated one or manually providing
> it via DT.
> 
> Just for clarification, I did not have any agreement or preliminary
> discussion with the vendor. This is just a personal initiative to
> improve the Owl SoC support in the mainline kernel.
> 
> > Maybe it would be better to set bit 1 of byte 0? And then you can use
> > 5 bytes from enc_sn, not just 4.
> 
> I included the MAC generation feature in the driver to be fully
> compatible with the original implementation, but I'm open for changes
> if it raises concerns and compatibility is less important.

This is not a simple question to answer. If the vendor driver does
this, then the vendor can never assign MAC addresses in a controlled
way, unless they have a good idea how the algorithm turns serial
numbers into MAC addresses, and they can avoid MAC addresses for
serial numbers already issued.

But should the Linux kernel do the same? If all you want is a stable
MAC address, my personal preference would be to set the locally
administered bit, and fill the other 5 bytes from the hash
algorithm. You then have a stable MAC addresses, but you clearly
indicate it is not guaranteed to by globally unique, and you do not
need to worry about what the vendor is doing.

> > Otherwise, this look a new clean driver.
> 
> Well, I tried to do my best, given my limited experience as a self-taught
> kernel developer. Hopefully reviewing my code will not cause too many
> headaches! :)

This is actually above average for a self-taught kernel
developer. Well done.

	   Andrew
