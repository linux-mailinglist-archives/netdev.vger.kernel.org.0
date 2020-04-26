Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318D71B90DD
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgDZObq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 10:31:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36414 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgDZObp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 10:31:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1GhCekYAwCZJWAXEoZbxjlpjUYTXP2zjlx17YYGeNXA=; b=Yk3z+HgI0iDmaNAMt+ntL04Vz1
        8bxAz4JfTsRu35VANqTRwBh3Nyd0SGez6Owj+1S3RwoG6QkiAO/A5ARFXjDSB2y3gDAlhcFtl0pQp
        yXPn9c5bIHJmqy3P+9AcKXTOi+xZjzGTz0U4nOaajbHj2vIMYp1vKiyX2zz9INmg/gF4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSiJQ-004xq4-Ek; Sun, 26 Apr 2020 16:31:16 +0200
Date:   Sun, 26 Apr 2020 16:31:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lan743x: Added fixed_phy support
Message-ID: <20200426143116.GC1140627@lunn.ch>
References: <rberg@berg-solutions.de>
 <20200425234320.32588-1-rberg@berg-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425234320.32588-1-rberg@berg-solutions.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 01:43:18AM +0200, Roelof Berg wrote:
> +# All the following symbols are dependent on LAN743X - do not repeat
> +# that for each of the symbols.
> +if LAN743X
> +
> +choice LAN743x_MII_MODE
> +	prompt "MII operation mode"
> +	default LAN743x_MII_MODE_DEFAULT
> +	depends on LAN743X
> +	help
> +	 Defines the R/G/MII operation mode of the MAC of lan743.
> +
> +config LAN743x_MII_MODE_DEFAULT
> +	bool "Device default"
> +	help
> +	 The existing internal device configuration, which may have come from
> +	 EEPROM or OTP, will remain unchanged.
> +
> +config LAN743x_MII_MODE_RGMII
> +	bool "RGMII"
> +	help
> +	 RGMII (Reduced GMII) will be enabled when the driver is loaded.
> +
> +config LAN743x_MII_MODE_GMII
> +	bool "G/MII"
> +	help
> +	 GMII (in case of 100 mbit) or MII (in case of 10 mbit) will be enabled when
> +	 the driver is loaded.
> +
> +endchoice

Hi Roelof

You should not be putting this sort of configuration into Kconfig. You
want one kernel to be able to drive all LAN743x instances. Think of a
Debian kernel, etc.

So what are you trying to achieve here? What is the big picture?

You have a PCI device with a LAN743x connected to an Ethernet switch?
You need the MII interface between the LAN743x and the switch to be
configured to some specific speed? But you only want to do this for
your device. How can you identify your device? Do you set the PCI
vendor/device IDs to something unique?

You can add to the end of lan743x_pcidev_tbl[] your vendor/device
ID. In the probe function you can detect your own vendor/product ID
and then configure things as you need. 

    Andrew
