Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A871DF803
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 17:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731324AbgEWP2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 11:28:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgEWP2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 11:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2ukf+KQSooDXzKATJsVcZaVVmp8u3iGwjF+E46B8zB4=; b=bEiQ7LpPNpTm7pTo6XIi1QDUvo
        fQMeCQcMBGPCxMUuu+vQ5ZnwPD/XWfrLN5CQz6BY5MUOVJUc3j1mJ7iHiyia+YgolS6ZXfGnbbrkO
        DjFEEQx58I83y7qOexke1vyLnYLxVz63j/fZdcYh/OjOjKWgSGy0GpQB/4pDnSVwSE7Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jcW48-0034VW-Sg; Sat, 23 May 2020 17:28:00 +0200
Date:   Sat, 23 May 2020 17:28:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Message-ID: <20200523152800.GM610998@lunn.ch>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213059.1535892-4-jeremy.linton@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:30:51PM -0500, Jeremy Linton wrote:
> Lets factor out the phy id logic, and make it generic
> so that it can be used for c22 and c45.
> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  drivers/net/phy/phy_device.c | 65 +++++++++++++++++++-----------------
>  1 file changed, 35 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 7746c07b97fe..f0761fa5e40b 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -695,6 +695,29 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
>  	return 0;
>  }
>  
> +static int _get_phy_id(struct mii_bus *bus, int addr, int dev_addr,
> +		       u32 *phy_id, bool c45)

Hi Jeremy

How about read_phy_id() so you can avoid the _ prefix.

>  static bool valid_phy_id(int val)
>  {
>  	return (val > 0 && ((val & 0x1fffffff) != 0x1fffffff));
> @@ -715,17 +738,17 @@ static bool valid_phy_id(int val)
>   */
>  static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  			   struct phy_c45_device_ids *c45_ids) {
> -	int phy_reg;
> -	int i, reg_addr;
> +	int ret;
> +	int i;
>  	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>  	u32 *devs = &c45_ids->devices_in_package;
>  
>  	/* Find first non-zero Devices In package. Device zero is reserved
>  	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>  	 */
> -	for (i = 1; i < num_ids && *devs == 0; i++) {
> -		phy_reg = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> -		if (phy_reg < 0)
> +	for (i = 0; i < num_ids && *devs == 0; i++) {
> +		ret = get_phy_c45_devs_in_pkg(bus, addr, i, devs);
> +		if (ret < 0)
>  			return -EIO;

Renaming reg_addr to ret does not belong in this patch.

	 Andrew
