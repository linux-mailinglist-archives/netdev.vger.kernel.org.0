Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF2F18EBE4
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 20:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCVTSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 15:18:54 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40278 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgCVTSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 15:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RIAHvjZgxomQVpQmFNUiVpDvO2IIucaa9jhgrsz8pG4=; b=saMGtVA/YKdtAqF7xH6b7rV0u
        l7FOMTkOsflESbP4bX4ej2nf+wfqjZGyiGYiIVL6d3pXfZLLcnmojQS1QcLWE5iTGK3pvVRMiRd3L
        dOBa+fxaWc4tyC7gShu+LORrP04YDnaOKsyjFZ6ZRxEAwbpMD+lxLZthMc7MbAt7Nx4DPBt5e9VRx
        SQhQlrBjLA7huji+msBOUFlvnRKGRXe58xfBzmYqGaIwuBp6KpGOE8/f6Tg/RvoCE7PgUyETbztli
        2VNWtXvD9g8IJUNyUlXYnfNVR960sgEAfkx1QGoSyIPoqJdolWa7QrI49fBFvXLWSf2CxSrTVtAQK
        HN2SXpfgw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:35850)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jG67I-0005AM-5m; Sun, 22 Mar 2020 19:18:36 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jG67E-0007yZ-4A; Sun, 22 Mar 2020 19:18:32 +0000
Date:   Sun, 22 Mar 2020 19:18:32 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, mchehab+samsung@kernel.org, corbet@lwn.net,
        gregkh@linuxfoundation.org, broonie@kernel.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5 08/10] net: phy: use phy_read_poll_timeout()
 to simplify the code
Message-ID: <20200322191832.GW25745@shell.armlinux.org.uk>
References: <20200322174943.26332-1-zhengdejin5@gmail.com>
 <20200322174943.26332-9-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322174943.26332-9-zhengdejin5@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 01:49:41AM +0800, Dejin Zheng wrote:
> use phy_read_poll_timeout() to replace the poll codes for
> simplify the code in phy_poll_reset() function.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v4 -> v5:
> 	- it can add msleep before call phy_read_poll_timeout()
> 	  to keep the code more similar. so add it.
> v3 -> v4:
> 	- drop it.
> v2 -> v3:
> 	- adapt to it after modifying the parameter order of the
> 	  newly added function
> v1 -> v2:
> 	- remove the handle of phy_read()'s return error.
> 
> 
>  drivers/net/phy/phy_device.c | 17 +++++------------
>  1 file changed, 5 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index a585faf8b844..24297ee7f626 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -1059,23 +1059,16 @@ EXPORT_SYMBOL(phy_disconnect);
>  static int phy_poll_reset(struct phy_device *phydev)
>  {
>  	/* Poll until the reset bit clears (50ms per retry == 0.6 sec) */
> -	unsigned int retries = 12;
> -	int ret;
> -
> -	do {
> -		msleep(50);
> -		ret = phy_read(phydev, MII_BMCR);
> -		if (ret < 0)
> -			return ret;
> -	} while (ret & BMCR_RESET && --retries);
> -	if (ret & BMCR_RESET)
> -		return -ETIMEDOUT;
> +	int ret, val;
>  
> +	msleep(50);
> +	ret = phy_read_poll_timeout(phydev, MII_BMCR, val, !(val & BMCR_RESET),
> +				    50000, 550000);
>  	/* Some chips (smsc911x) may still need up to another 1ms after the
>  	 * BMCR_RESET bit is cleared before they are usable.
>  	 */
>  	msleep(1);
> -	return 0;
> +	return ret;

This isn't actually equivaent behaviour.  If the read timed out, the old
code didn't wait 1ms.  Your new code does.  However, since we've waited
about 600ms already, it probably doesn't matter.

These sorts of things should be documented in the commit log, IMHO, so
it's obvious that it's been considered.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
