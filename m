Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79811DFA44
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 20:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387867AbgEWSbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 14:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387518AbgEWSbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 14:31:14 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FAFC061A0E;
        Sat, 23 May 2020 11:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pg+aVLZCvfHq24tf8cjS0+Pqk/O0vhGg2MMQza4aLcY=; b=fTMO7vBfk4Hrnv/QnUEizJciv
        5ShLRqd2mvoCcITZcd9oP9MC3ECfyWRwwfFxtpfAuCEvFAY6UPdGOdMpcYMJ7C5Bqes/g0DALsJM7
        Cl9gSD6yy3eq3/VW63NG1ZxfAv0WJCrcKrwROzlM1r8T87GoG1tua/B9wLEbDaYvNZ1Tscm0zaqgf
        TskhRGjNrze+/C066I7cOgVbTwCU/G9y1Ja1sE/Cgm1j2Y+OdiAZkMIev4Apu4tQJj8Oh95Yb/Exl
        4I+KSe/ETMKGXqTD5tan0EDOmatVq/Ww8GnW4S8cIq9zXBzaY/1wgfb+ngyGZvSa11X+opO2sTBsd
        xwc7le0gA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33574)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jcYvF-0000Tp-Pb; Sat, 23 May 2020 19:31:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jcYvC-0002TA-E2; Sat, 23 May 2020 19:30:58 +0100
Date:   Sat, 23 May 2020 19:30:58 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        madalin.bucur@oss.nxp.com, calvin.johnson@oss.nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 03/11] net: phy: refactor c45 phy identification sequence
Message-ID: <20200523183058.GX1551@shell.armlinux.org.uk>
References: <20200522213059.1535892-1-jeremy.linton@arm.com>
 <20200522213059.1535892-4-jeremy.linton@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522213059.1535892-4-jeremy.linton@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
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
> +{
> +	int phy_reg, reg_addr;
> +
> +	int reg_base = c45 ? (MII_ADDR_C45 | dev_addr << 16) : 0;

	int phy_reg, reg_addr, reg_base;

	reg_base = c45 ? (MII_ADDR_C45 | dev_addr << 16) : 0;

I think would be preferable.

> +
> +	reg_addr =  reg_base | MII_PHYSID1;
> +	phy_reg = mdiobus_read(bus, addr, reg_addr);
> +	if (phy_reg < 0)
> +		return -EIO;
> +
> +	*phy_id = phy_reg << 16;
> +
> +	reg_addr = reg_base | MII_PHYSID2;
> +	phy_reg = mdiobus_read(bus, addr, reg_addr);
> +	if (phy_reg < 0)
> +		return -EIO;
> +	*phy_id |= phy_reg;

The line spacing seems to be a little inconsistent between the above two
register reads.

> +
> +	return 0;
> +}

So, _get_phy_id() returns either zero or -EIO.

> +
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

I feel a "reverse christmas tree" complaint brewing... yes, the original
code didn't follow it.  Maybe a tidy up while touching this code?

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
>  
>  		if ((*devs & 0x1fffffff) == 0x1fffffff) {
> @@ -752,17 +775,9 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  		if (!(c45_ids->devices_in_package & (1 << i)))
>  			continue;
>  
> -		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID1;
> -		phy_reg = mdiobus_read(bus, addr, reg_addr);
> -		if (phy_reg < 0)
> -			return -EIO;
> -		c45_ids->device_ids[i] = phy_reg << 16;
> -
> -		reg_addr = MII_ADDR_C45 | i << 16 | MII_PHYSID2;
> -		phy_reg = mdiobus_read(bus, addr, reg_addr);
> -		if (phy_reg < 0)
> -			return -EIO;
> -		c45_ids->device_ids[i] |= phy_reg;
> +		ret = _get_phy_id(bus, addr, i, &c45_ids->device_ids[i], true);
> +		if (ret < 0)
> +			return ret;

So here we can only propagate the -EIO, so this keeps the semantics.

>  	}
>  	*phy_id = 0;
>  	return 0;
> @@ -787,27 +802,17 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
>  		      bool is_c45, struct phy_c45_device_ids *c45_ids)
>  {
> -	int phy_reg;
> +	int ret;
>  
>  	if (is_c45)
>  		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
>  
> -	/* Grab the bits from PHYIR1, and put them in the upper half */
> -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
> -	if (phy_reg < 0) {
> +	ret = _get_phy_id(bus, addr, 0, phy_id, false);
> +	if (ret < 0) {
>  		/* returning -ENODEV doesn't stop bus scanning */
> -		return (phy_reg == -EIO || phy_reg == -ENODEV) ? -ENODEV : -EIO;
> +		return (ret == -EIO || ret == -ENODEV) ? -ENODEV : -EIO;

Since ret will only ever be -EIO here, this can only ever return
-ENODEV, which is a functional change in the code (probably unintended.)
Nevertheless, it's likely introducing a bug if the intention is for
some other return from mdiobus_read() to be handled differently.

>  	}
>  
> -	*phy_id = phy_reg << 16;
> -
> -	/* Grab the bits from PHYIR2, and put them in the lower half */
> -	phy_reg = mdiobus_read(bus, addr, MII_PHYSID2);
> -	if (phy_reg < 0)
> -		return -EIO;

... whereas this one always returns -EIO on any error.

So, I think you have the potential in this patch to introduce a subtle
change of behaviour, which may lead to problems - have you closely
analysed why the code was the way it was, and whether your change of
behaviour is actually valid?

> -
> -	*phy_id |= phy_reg;
> -
>  	return 0;
>  }
>  
> -- 
> 2.26.2
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
