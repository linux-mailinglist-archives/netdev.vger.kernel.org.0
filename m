Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17753164DEE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 19:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgBSSsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 13:48:53 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726634AbgBSSsx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 13:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lg5RewCddo/rU7+BSEcqBBC22Am10XAHrObIfp0nnpk=; b=k/IoAle40nYTEgfJ19eI6UDaQ0
        UjBSLyIKItHH98qmWLGiy1C9pcqZsfWeOjjnaiWBUNmQ1hIID8CbYp4KCNvA1KgHTVvJZ6j0qjSZ/
        e375kX4XllTp6R9DYaNxBrvCQuT+rHIWZNvQDPyHklm7LVn0elbq2fWOUx0aE6ftktPM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j4UOt-0001oN-5M; Wed, 19 Feb 2020 19:48:47 +0100
Date:   Wed, 19 Feb 2020 19:48:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, afd@ti.com
Subject: Re: [PATCH net-master] net: phy: dp83848: Add the TI TLK05/06 PHY ID
Message-ID: <20200219184847.GD3281@lunn.ch>
References: <20200219181613.5898-1-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219181613.5898-1-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 12:16:13PM -0600, Dan Murphy wrote:
> Add the TLK05/06 PHY ID to the DP83848 driver.  The TI website indicates
> that the DP83822 device is a drop in replacement for the TLK05 device
> but the TLK device does not have WoL support.  The TLK device is
> register compatible to the DP83848 and the DP83848 does not support WoL
> either.  So this PHY can be associated with the DP83848 driver.
> 
> The initial TLKx PHY ID in the driver is a legacy ID and the public data
> sheet indicates a new PHY ID.  So not to break any kernels out there
> both IDs will continue to be supported in this driver.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  drivers/net/phy/dp83848.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
> index 54c7c1b44e4d..66907cfa816a 100644
> --- a/drivers/net/phy/dp83848.c
> +++ b/drivers/net/phy/dp83848.c
> @@ -12,6 +12,7 @@
>  #define TI_DP83620_PHY_ID		0x20005ce0
>  #define NS_DP83848C_PHY_ID		0x20005c90
>  #define TLK10X_PHY_ID			0x2000a210
> +#define TLK105_06_PHY_ID		0x2000a211
>  
>  /* Registers */
>  #define DP83848_MICR			0x11 /* MII Interrupt Control Register */
> @@ -85,6 +86,7 @@ static struct mdio_device_id __maybe_unused dp83848_tbl[] = {
>  	{ NS_DP83848C_PHY_ID, 0xfffffff0 },
>  	{ TI_DP83620_PHY_ID, 0xfffffff0 },
>  	{ TLK10X_PHY_ID, 0xfffffff0 },
> +	{ TLK105_06_PHY_ID, 0xfffffff0 },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
> @@ -115,6 +117,8 @@ static struct phy_driver dp83848_driver[] = {
>  			   dp83848_config_init),
>  	DP83848_PHY_DRIVER(TLK10X_PHY_ID, "TI TLK10X 10/100 Mbps PHY",
>  			   NULL),
> +	DP83848_PHY_DRIVER(TLK105_06_PHY_ID, "TI TLK105/06 10/100 Mbps PHY",
> +			   NULL),

I'm pretty sure Andrew's comment is correct. Due to the mask, the
TLK10X_PHY_ID entry will hit.

What you can do is change the order and the mask. Put TLK105_06_PHY_ID
before TLK10X_PHY_ID and have an exact match, no mask.

       Andrew
