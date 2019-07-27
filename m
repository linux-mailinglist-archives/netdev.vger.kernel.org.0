Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA64A77A66
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 17:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387834AbfG0PwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 11:52:00 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40484 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387673AbfG0PwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 11:52:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=orpSxrgqkjyYfy62gqgc39Rpdg5jN1pzB34JWPd5VEM=; b=w92EBui61TThL+PUdyvmmx5j8
        XDi6OGq99u4fwUtRWw+xoE/1uwb74nqFXVtgHVD2csrXHZls6+pJX4OyaQ1xQQ2Y+rx8rqBDgWAps
        nAleWSNrnI4aKhj5LqbwYzVAx/bhvvb/o0QCmpvRpwFcWy6X+RBXPS3F+61wAZB/3ez+WHpNucR1M
        /bFCgEwSDGowP6SOyOp0cIEegS8yRUOILoUTPzPlNNr0sshdA/aAfWbjqOCmU/qZkNwxD5bhXUQqk
        OtTuj08JOWsA2Jn2ovmg8RdQT7H6rD2Z7wLf4SIYUakfd1gTq79oGSlXyJR+2n9pRFiy5yzPzu852
        NUGsZnKNQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:45224)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hrOz9-0004O7-Rv; Sat, 27 Jul 2019 16:51:52 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hrOz7-0007rS-6F; Sat, 27 Jul 2019 16:51:49 +0100
Date:   Sat, 27 Jul 2019 16:51:49 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: Fix flow control for fixed-link
Message-ID: <20190727155149.GS1330@shell.armlinux.org.uk>
References: <20190727094011.14024-1-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190727094011.14024-1-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 27, 2019 at 11:40:11AM +0200, René van Dorst wrote:
> In phylink_parse_fixedlink() the pl->link_config.advertising bits are AND
> with pl->supported, pl->supported is zeroed and only the speed/duplex
> modes and MII bits are set.
> So pl->link_config.advertising always loses the flow control/pause bits.
> 
> By setting Pause and Asym_Pause bits in pl->supported, the flow control
> work again when devicetree "pause" is set in fixes-link node and the MAC
> advertise that is supports pause.
> 
> Results with this patch.
> 
> Legend:
> - DT = 'Pause' is set in the fixed-link in devicetree.
> - validate() = ‘Yes’ means phylink_set(mask, Pause) is set in the
>   validate().
> - flow = results reported my link is Up line.
> 
> +-----+------------+-------+
> | DT  | validate() | flow  |
> +-----+------------+-------+
> | Yes | Yes        | rx/tx |
> | No  | Yes        | off   |
> | Yes | No         | off   |
> +-----+------------+-------+
> 
> Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
> Signed-off-by: René van Dorst <opensource@vdorst.com>

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>

Thanks.

> ---
>  drivers/net/phy/phylink.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 5d0af041b8f9..a6aebaa14338 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -216,6 +216,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
>  			       pl->supported, true);
>  	linkmode_zero(pl->supported);
>  	phylink_set(pl->supported, MII);
> +	phylink_set(pl->supported, Pause);
> +	phylink_set(pl->supported, Asym_Pause);
>  	if (s) {
>  		__set_bit(s->bit, pl->supported);
>  	} else {
> -- 
> 2.20.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
