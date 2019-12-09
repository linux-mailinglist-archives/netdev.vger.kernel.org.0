Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81040116FB7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLIOzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:55:21 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35106 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfLIOzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:55:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HSD4oJJE8Lz4nTkjIjVkMKS7cpaesp40fk90klRJbjo=; b=yKx6wbV0jBSwMPa3EYrPao/zI
        ZdzVhUFU1633h+R3+OwoBEvqcksssDXzVXzagAIi0Ow7Y2BhdutdfFWveVGZEFWSI8FhsVcfvdX5/
        UYgWWfj99UVEYcPyCyQlPA6PUJJJZziwxPqpYOfqqb5akTRYY7Y+k5ZUJl7SD2US+QBw4sJtCPW6U
        Hbkkuu/DBt9ljyKoVLvXfK3Fl74EckFjofwG/HrWY3jqrMbY0zbzBZSRkCu/fFCO1ixSkkDFJ1nmg
        CugpRWoa9XhRyk46wJgi7J/+kWYlB7cojnRnZ3GcnNcLLGjzKvfWxFho2KzGgEonJvojAwSDHzYBt
        ayQNPwJbA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46512)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ieKLa-0003fs-DB; Mon, 09 Dec 2019 14:49:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ieKLX-0003js-33; Mon, 09 Dec 2019 14:49:11 +0000
Date:   Mon, 9 Dec 2019 14:49:11 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 11/14] net: phylink: delay MAC configuration for
 copper SFP modules
Message-ID: <20191209144910.GN25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
 <E1ieJhK-0004PS-4N@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieJhK-0004PS-4N@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 02:07:38PM +0000, Russell King wrote:
> Knowing whether we need to delay the MAC configuration because a module
> may have a PHY is useful to phylink to allow NBASE-T modules to work on
> systems supporting no more than 2.5G speeds.
> 
> This commit allows us to delay such configuration until after the PHY
> has been probed by recording the parsed capabilities, and if the module
> may have a PHY, doing no more until the module_start() notification is
> called.  At that point, we either have a PHY, or we don't.
> 
> We move the PHY-based setup a little later, and use the PHYs support
> capabilities rather than the EEPROM parsed capabilities to determine
> whether we can support the PHY.

...

>  	/* If this SFP module has a PHY, start the PHY now. */
> -	if (pl->phydev)
> +	if (pl->phydev) {
>  		phy_start(pl->phydev);
> -		
> -	return 0;
> +		return 0;

Sigh, fixing up a white-space warning in a preceding patch while test-
applying the patches to net-next broke this patch.

"Oh, it'll be simple, all I need to do is delete the two tabs that the
 patch added, no problem."  Yea, right.

I'll re-post shortly with a fixed set of patches.  Sorry for the noise.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
