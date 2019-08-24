Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD8489BCB6
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 11:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfHXJWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 05:22:11 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:45454 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfHXJWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 05:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=u9kDsmGvpvy+ySdibnxbYTURZ6SqJ3ZYL88TNhJH+08=; b=BxkVzn8VPjh7EVNaF8lJqzsdg
        zlQtBsYy6mqdeQKvuta6hdh11UqgUHuutlKtwXtqBsr1KyMfrHDUC3/8BZQMYxZ5HMkT0T1uJlTZa
        3Fq89O+sCd5fzU8N+4LkDqqbqOOpKetTEm/MZHhOmONXL4e7Z09L4tuRastd6vbyQAVH01q9o2J3/
        PiY4zUjHfiI2uxA8iAmhd4MIbK3tnt/hL+Mpe0J4+NBgKAW0Vbb6Bb5BZ6f+H38zUWkYOSUK6UT+g
        BnqNw49mKpWR+BCC25NDpcxBwm9J+bN8FVA1Ocbv9Cc+tpGIwBkpCh8UlLZups1EYvuCSp/N/8dS8
        KfiH+nsyw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:53938)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i1SFD-0002C7-Ik; Sat, 24 Aug 2019 10:21:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i1SFA-0002Qx-72; Sat, 24 Aug 2019 10:21:56 +0100
Date:   Sat, 24 Aug 2019 10:21:56 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Stefan Roese <sr@denx.de>
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: mediatek: Re-add support
 SGMII
Message-ID: <20190824092156.GD13294@shell.armlinux.org.uk>
References: <20190823134516.27559-1-opensource@vdorst.com>
 <20190823134516.27559-3-opensource@vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190823134516.27559-3-opensource@vdorst.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 03:45:15PM +0200, René van Dorst wrote:
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_SGMII:
> +		phylink_set(mask, 10baseT_Half);
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Half);
> +		phylink_set(mask, 100baseT_Full);

You also want 1000baseX_Full here - the connected PHY could have a fiber
interface on it.

> +		/* fall through */
> +	case PHY_INTERFACE_MODE_TRGMII:
>  		phylink_set(mask, 1000baseT_Full);

I don't know enough about this interface type to comment whether it
should support 1000baseX_Full - if this is connected to a PHY that may
support fiber, then it ought to set it.

> +		break;
> +	case PHY_INTERFACE_MODE_2500BASEX:
> +		phylink_set(mask, 2500baseX_Full);
> +		/* fall through */
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		phylink_set(mask, 1000baseX_Full);

Both should be set.  The reasoning here is that if you have a
Fiberchannel 4Gbaud SFP plugged in and connected directly to the
MAC, it can operate at either 2500Base-X or 1000Base-X.  If we
decide to operate at 2500Base-X, then PHY_INTERFACE_MODE_2500BASEX
will be chosen.  Otherwise, PHY_INTERFACE_MODE_1000BASEX will be
used.

The user can use ethtool to control which interface mode is used
by adjusting the advertise mask and/or placing the interface in
manual mode and setting the speed directly.  This will change
the PHY_INTERFACE_MODE_xxxxBASEX (via phylink_helper_basex_speed())
between the two settings.

If we lose 2500baseX_Full when 1000Base-X is selected, the user
will not be able to go back to 2500Base-X mode.

Yes, it's a little confusing and has slightly different rules
from the other modes - partly due to phylink_helper_basex_speed().
These are the only interface modes that we dynamically switch
between depending on the settings that the user configures via
ethtool.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
