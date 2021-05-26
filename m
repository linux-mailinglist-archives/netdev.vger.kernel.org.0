Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFC3391C3E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhEZPnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbhEZPnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:43:53 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9348AC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 08:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q70he09otM5/1Xz5tUyVV1uZT8HE8Hw6OEhIzMGEJKM=; b=A0bvdv7hiCQrh0jCh9pwOWog4
        0XdpFdT8Pz3TnALgswbJGWB4sUYyNXSFkZee4Wqo6Wv2+KS9Dz0n+9jji5yjD3tjKkC8bumRa8Q6b
        CMkfUE91CyO4q6dGfKHTpl5f5tMBQaAno2VOZvZTkfrOAG/S0jmfXjdISN4wf4OWomTOGJslxvKRQ
        KK1j5I+X1HZq4os+1D5JDKJo3OdYushdFA8EYFKOktVSNNpiHNpbwE/pe3fmK2JTBxxnv8lbKdhMx
        NXQjNjBZFaHFM6Bvaw7voE8zcvuY0S1T/veBMA5ksj4zQJ8mI5UIinPsAdEEX6xMAR6ml+0i568Rl
        VPzsaRcKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44382)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1llvfn-0005sD-6a; Wed, 26 May 2021 16:42:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1llvfm-0002wK-OE; Wed, 26 May 2021 16:42:18 +0100
Date:   Wed, 26 May 2021 16:42:18 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 03/14] net: dsa: sja1105: the 0x1F0000
 SGMII "base address" is actually MDIO_MMD_VEND2
Message-ID: <20210526154218.GI30436@shell.armlinux.org.uk>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
 <20210526135535.2515123-4-vladimir.oltean@nxp.com>
 <20210526152454.GG30436@shell.armlinux.org.uk>
 <20210526153447.yjgbj5uhxxnvxvbs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526153447.yjgbj5uhxxnvxvbs@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:34:47PM +0300, Vladimir Oltean wrote:
> Hi Russell,
> 
> On Wed, May 26, 2021 at 04:24:54PM +0100, Russell King (Oracle) wrote:
> > On Wed, May 26, 2021 at 04:55:24PM +0300, Vladimir Oltean wrote:
> > > -	const struct sja1105_regs *regs = priv->info->regs;
> > > +	u64 addr = (mmd << 16) | pcs_reg;
> > 
> > What is the reason for using "u64" here. pcs_reg is 16-bits, and mmd is
> > five bits, which is well below 32 bits. So, why not u32?
> 
> The "addr" variable holds a SPI address, and in the sja1105 driver, the
> SPI addresses are universally held in u64 variables, mainly because of
> the packing() API (Documentation/core-api/packing.rst).

As you are passing it into a function, the argument of which is a u64,
the compiler will promote the u32 to a u64 by itself. I guess it
doesn't actually matter, but the current code just looks really weird.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
