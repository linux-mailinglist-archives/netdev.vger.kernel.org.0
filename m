Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A16116C10A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 13:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730175AbgBYMiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 07:38:54 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57950 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729411AbgBYMiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 07:38:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7il1HEPle9QWK8/fn+8p2ZW7O17syNxn3S0cD/+iqSQ=; b=mTmj8gEH/PDUSZrnwqB/k2HnS
        8MBf7jbbYVViLuW2wqdDKg9jHs8mupOQCGoz6I86x8v9A7f/8ChSVtL8Eoh2xHimayo1IuYEmqGBa
        NPn510WZTRozrgM7Q8GofRL+OZe1MDaK6eoEW/fe/mxPhrXKoFJ7eFHXTk7RrTzxncsT7nledbpG+
        CD1vAEZVCVajSsZFfPeoXwv8INm+fWQ2o6F5nGnULeqDqlXdrCrVLEUi0VIs+O4y8A1YlC8aOKpHC
        Y2ok8TmkoetW0RPg7+GbRCJzugXtMQRZ6LDT1eCgDZBxrWN15YKtcLRWUt0Wwf9UDkZHMEbjGgPth
        ZUbM9B93A==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:52570)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j6ZU4-0000tE-DH; Tue, 25 Feb 2020 12:38:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j6ZTz-0007QW-GB; Tue, 25 Feb 2020 12:38:39 +0000
Date:   Tue, 25 Feb 2020 12:38:39 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Sudheesh Mavila <sudheesh.mavila@amd.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: corrected the return value for
 genphy_check_and_restart_aneg
Message-ID: <20200225123839.GT25745@shell.armlinux.org.uk>
References: <20200225122208.6881-1-sudheesh.mavila@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225122208.6881-1-sudheesh.mavila@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 05:52:08PM +0530, Sudheesh Mavila wrote:
> When auto-negotiation is not required, return value should be zero.
> 
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>

Hi,

Thanks for spotting this problem. However, it looks like the same
problem also exists in genphy_c45_check_and_restart_aneg(). It would
be a good idea to fix both at the same time.

Thanks.

> ---
>  drivers/net/phy/phy_device.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 6a5056e0ae77..36cde3dac4c3 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1806,10 +1806,13 @@ int genphy_check_and_restart_aneg(struct phy_device *phydev, bool restart)
>  			restart = true;
>  	}
>  
> -	if (restart)
> -		ret = genphy_restart_aneg(phydev);
> +	/* Only restart aneg if we are advertising something different
> +	 * than we were before.
> +	 */
> +	if (restart > 0)
> +		return genphy_restart_aneg(phydev);
>  
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL(genphy_check_and_restart_aneg);
>  
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
