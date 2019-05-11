Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8D61A83A
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 17:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfEKPZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 11:25:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60821 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728603AbfEKPZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 May 2019 11:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3BwmdeMdAB1QS2VFa71ZMNYPI8SNnkly5a4EC48lPb0=; b=KWhQrHExqVzN/YtgXR/QWdcynY
        LaWIhpXEXv+NFZkl5AbFbQWt8ADbQdrEmUnt4m9EYvXIV7TguX/yvxk9dJArcsl3MrocVzoPVnIpy
        pQmsPRqGq02vJNj6w8fHFFOntCB2a30kEdhCs6Wh9RkMwY0tLB7YmJb7k56rvFNDoxJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hPTsF-0003fk-Jw; Sat, 11 May 2019 17:25:19 +0200
Date:   Sat, 11 May 2019 17:25:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vicente Bergas <vicencb@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190511152519.GG4889@lunn.ch>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <20190511150819.GF4889@lunn.ch>
 <fce7258a-b033-4d39-8ad1-4e56917166c5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fce7258a-b033-4d39-8ad1-4e56917166c5@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Andrew,
> it is configured as in the vanilla kernel:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi#n191
> ,that is,
> phy-mode = "rgmii";
> There are also these configuration items:
> tx_delay = <0x28>;
> rx_delay = <0x11>;
> 
> Instead of going the trial-and-error way, please, can you suggest a
> probably good configuration?

I just found the same.

Interestingly, the device tree binding says:

Optional properties:
 - tx_delay: Delay value for TXD timing. Range value is 0~0x7F, 0x30 as default.
 - rx_delay: Delay value for RXD timing. Range value is 0~0x7F, 0x10 as default.

So it is not using quite the default values. But there is no
documentation about what these values mean. Given the difference of
0x20, it could be this is adding the needed TX delay, but not the RX
delay?

So you could try:

rgmii-rxid

And it is not clear what RX and TX mean, so also try

rgmii-txid.

in case they are swapped.

   Andrew



