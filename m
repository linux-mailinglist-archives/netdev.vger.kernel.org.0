Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E2F1DFA34
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 20:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbgEWSVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 14:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgEWSVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 14:21:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF49C061A0E;
        Sat, 23 May 2020 11:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nSUTrS+Js2HSvmnL14DjqtpgJSSsEW5R57ypchErLwg=; b=gA/uZNdkmC2JRZFCEyrK9jpf9
        5T7RYZPGGJCvZlrYXeWaE2rkNFs7Rxm5GK6RVkLbzaLW8mydeE1CEZbuADlUuMpM7dJ8ewap+itmr
        1XF2Q5oHZoQREGSDw6MLo8gKZQjkWaUbhFZtCnJK9jMmCQgBuMahSM6pSGWu8cujz+aRvb+08nYyP
        vvzq5fRnSbd38h6eaVFqrzs3trfVBnAnx0IGdTn2taGv6Hifd7yHYzAVIGN+XhsHufCy+1b4kHsdp
        Wg5YI5RZbEAzyqTEB5THomCJL3gM1d0/CNziOwZXgeS644GH+uzvywhP5zLzBP7L9FKRLwlol8Rul
        1q/3T5HNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36018)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcYlY-0000Sm-T0; Sat, 23 May 2020 19:21:05 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcYlS-0002Sz-SK; Sat, 23 May 2020 19:20:54 +0100
Date:   Sat, 23 May 2020 19:20:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/11] net: phy: Don't report success if devices weren't
 found
Message-ID: <20200523182054.GW1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-2-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213059.1535892-2-jeremy.linton@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:30:49PM -0500, Jeremy Linton wrote:
> C45 devices are to return 0 for registers they haven't
> implemented. This means in theory we can terminate the
> device search loop without finding any MMDs. In that
> case we want to immediately return indicating that
> nothing was found rather than continuing to probe
> and falling into the success state at the bottom.

This is a little confusing when you read this comment:

                        /*  If mostly Fs, there is no device there,
                         *  then let's continue to probe more, as some
                         *  10G PHYs have zero Devices In package,
                         *  e.g. Cortina CS4315/CS4340 PHY.
                         */

Since it appears to be talking about the case of a PHY where *devs will
be zero.  However, tracking down the original submission, it seems this
is not the case at all, and the comment is grossly misleading.

It seems these PHYs only report a valid data in the Devices In Package
registers for devad=0 - it has nothing to do with a zero Devices In
Package.

Can I suggest that this comment is fixed while we're changing the code
to explicitly reject this "zero Devices In package" so that it's not
confusing?

Thanks.

> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  drivers/net/phy/phy_device.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index ac2784192472..245899b58a7d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -742,6 +742,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  		}
>  	}
>  
> +	/* no reported devices */
> +	if (*devs == 0) {
> +		*phy_id = 0xffffffff;
> +		return 0;
> +	}
> +
>  	/* Now probe Device Identifiers for each device present. */
>  	for (i = 1; i < num_ids; i++) {
>  		if (!(c45_ids->devices_in_package & (1 << i)))
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
