Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8704FB0E
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 12:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFWKND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 06:13:03 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43636 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbfFWKNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 06:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ge3SY9labvAxE4Yy2J2jXFLMiCj48qKbZn4VIaVWNWk=; b=c6ORLuCvwylMf7lS7gWuZTe9Z
        ykpKX6JD6FLvJbiRcfvzKRx2d7NB57YMkdzigkEmEXZw1ONKUzFNENnY/3b1x8HYG/ARzFuDVDipw
        kpCXtGlSRTNghKvGhKWHhLckjfynTM9pl3ccQuTGzjdR12o4MpTyysX1vUGcBIfjYGMmyu8sZ4YvM
        WywCPiq/N20VzO5wlmyz8pJnt63l+wzZR5ljJWt4jTmNtFf8kYocVDyBMufgj4xwSiwnfDXKbOhE7
        cdcTHAWOLddUbtL8Gfyvp7j/nFDUZtl61r4LHhseRQq89XgxixhL+/LE4WpKJZFWMzyn2oe/JjA8v
        B9n5di/eA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59908)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hezUU-0000iC-1F; Sun, 23 Jun 2019 11:12:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hezUT-0004wn-1u; Sun, 23 Jun 2019 11:12:53 +0100
Date:   Sun, 23 Jun 2019 11:12:52 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Parshuram Thombare <pthombar@cadence.com>
Cc:     andrew@lunn.ch, nicolas.ferre@microchip.com, davem@davemloft.net,
        f.fainelli@gmail.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, rafalc@cadence.com,
        aniljoy@cadence.com, piotrs@cadence.com
Subject: Re: [PATCH v4 3/5] net: macb: add support for c45 PHY
Message-ID: <20190623101252.olfxbls3phgxttcb@shell.armlinux.org.uk>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
 <1561281797-13796-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561281797-13796-1-git-send-email-pthombar@cadence.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 10:23:17AM +0100, Parshuram Thombare wrote:
> This patch modify MDIO read/write functions to support
> communication with C45 PHY.

Which Clause 45 PHY are you using?

> 
> Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 15 ++++--
>  drivers/net/ethernet/cadence/macb_main.c | 61 +++++++++++++++++++-----
>  2 files changed, 61 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 6d268283c318..330da702b946 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -642,10 +642,17 @@
>  #define GEM_CLK_DIV96				5
>  
>  /* Constants for MAN register */
> -#define MACB_MAN_SOF				1
> -#define MACB_MAN_WRITE				1
> -#define MACB_MAN_READ				2
> -#define MACB_MAN_CODE				2
> +#define MACB_MAN_C22_SOF                        1
> +#define MACB_MAN_C22_WRITE                      1
> +#define MACB_MAN_C22_READ                       2
> +#define MACB_MAN_C22_CODE                       2
> +
> +#define MACB_MAN_C45_SOF                        0
> +#define MACB_MAN_C45_ADDR                       0
> +#define MACB_MAN_C45_WRITE                      1
> +#define MACB_MAN_C45_POST_READ_INCR             2
> +#define MACB_MAN_C45_READ                       3
> +#define MACB_MAN_C45_CODE                       2
>  
>  /* Capability mask bits */
>  #define MACB_CAPS_ISR_CLEAR_ON_WRITE		BIT(0)
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 10d18b2cef31..94145e460e6e 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -341,11 +341,30 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  	if (status < 0)
>  		goto mdio_read_exit;
>  
> -	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
> -			      | MACB_BF(RW, MACB_MAN_READ)
> -			      | MACB_BF(PHYA, mii_id)
> -			      | MACB_BF(REGA, regnum)
> -			      | MACB_BF(CODE, MACB_MAN_CODE)));
> +	if (regnum & MII_ADDR_C45) {
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
> +			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
> +			    | MACB_BF(PHYA, mii_id)
> +			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
> +			    | MACB_BF(DATA, regnum & 0xFFFF)
> +			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
> +
> +		status = macb_mdio_wait_for_idle(bp);
> +		if (status < 0)
> +			goto mdio_read_exit;
> +
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
> +			    | MACB_BF(RW, MACB_MAN_C45_READ)
> +			    | MACB_BF(PHYA, mii_id)
> +			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
> +			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
> +	} else {
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
> +				| MACB_BF(RW, MACB_MAN_C22_READ)
> +				| MACB_BF(PHYA, mii_id)
> +				| MACB_BF(REGA, regnum)
> +				| MACB_BF(CODE, MACB_MAN_C22_CODE)));
> +	}
>  
>  	status = macb_mdio_wait_for_idle(bp);
>  	if (status < 0)
> @@ -374,12 +393,32 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>  	if (status < 0)
>  		goto mdio_write_exit;
>  
> -	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_SOF)
> -			      | MACB_BF(RW, MACB_MAN_WRITE)
> -			      | MACB_BF(PHYA, mii_id)
> -			      | MACB_BF(REGA, regnum)
> -			      | MACB_BF(CODE, MACB_MAN_CODE)
> -			      | MACB_BF(DATA, value)));
> +	if (regnum & MII_ADDR_C45) {
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
> +			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
> +			    | MACB_BF(PHYA, mii_id)
> +			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
> +			    | MACB_BF(DATA, regnum & 0xFFFF)
> +			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
> +
> +		status = macb_mdio_wait_for_idle(bp);
> +		if (status < 0)
> +			goto mdio_write_exit;
> +
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
> +			    | MACB_BF(RW, MACB_MAN_C45_WRITE)
> +			    | MACB_BF(PHYA, mii_id)
> +			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
> +			    | MACB_BF(CODE, MACB_MAN_C45_CODE)
> +			    | MACB_BF(DATA, value)));
> +	} else {
> +		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
> +				| MACB_BF(RW, MACB_MAN_C22_WRITE)
> +				| MACB_BF(PHYA, mii_id)
> +				| MACB_BF(REGA, regnum)
> +				| MACB_BF(CODE, MACB_MAN_C22_CODE)
> +				| MACB_BF(DATA, value)));
> +	}
>  
>  	status = macb_mdio_wait_for_idle(bp);
>  	if (status < 0)
> -- 
> 2.17.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
