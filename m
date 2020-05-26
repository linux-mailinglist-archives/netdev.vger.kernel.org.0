Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42D71E2833
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbgEZRPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730370AbgEZRPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 13:15:04 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AB1C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cTD9NST4xrIqkz1g2ZmmfwH/+GPSnMSCYcyrpfe3YCA=; b=b1pziNk6pqZLSk6QXOhCPV7LW
        comPapjBGQug2HA54m9v6aM/3dGkQW0iiNmP/LHBkeASn+1Ye91f7WKKgw0gwqW94QbeoxeUBT+WV
        GTGCemoRf+Oo0UOLFR/d5ZiAXW+5TP6o5b568pCeelR9cBgrQXiGE/5Wxk1zc+XnlDH9o8xG02Bzn
        A5CA3WJjFyica0yhdU34ZRF5oLnAelgZ+8p1rI4sKfDOHiau9G5VtL7PzBPjb6M6MSW3pIguadlQ4
        bZqdQDdqOtS7Uqnzf3xGmsoVJbVCD6QwZgTP06QC2H+PncQchG8aLwe5gEI5Yc+h5LJQFq6LdR//E
        dQypH8yDA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:34870)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jddAG-0008PE-5H; Tue, 26 May 2020 18:14:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jddAE-0005ZX-WF; Tue, 26 May 2020 18:14:55 +0100
Date:   Tue, 26 May 2020 18:14:54 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/7] net: phy: add support for probing MMDs >= 8 for
 devices-in-package
Message-ID: <20200526171454.GH1551@shell.armlinux.org.uk>
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabs-0005sW-P8@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jdabs-0005sW-P8@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 03:31:16PM +0100, Russell King wrote:
> Add support for probing MMDs above 7 for a valid devices-in-package
> specifier.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phy_device.c | 39 ++++++++++++++++++++++++++++++++++--
>  include/linux/phy.h          |  2 ++
>  2 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 0d6b6ca66216..fa9164ac0f3d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -659,6 +659,28 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>  }
>  EXPORT_SYMBOL(phy_device_create);
>  
> +/* phy_c45_probe_present - checks to see if a MMD is present in the package
> + * @bus: the target MII bus
> + * @prtad: PHY package address on the MII bus
> + * @devad: PHY device (MMD) address
> + *
> + * Read the MDIO_STAT2 register, and check whether a device is responding
> + * at this address.
> + *
> + * Returns: negative error number on bus access error, zero if no device
> + * is responding, or positive if a device is present.
> + */
> +static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
> +{
> +	int stat2;
> +
> +	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
> +	if (stat2 < 0)
> +		return stat2;
> +
> +	return (stat2 & MDIO_STAT2_DEVPRST) == MDIO_STAT2_DEVPRST_VAL;
> +}
> +
>  /* get_phy_c45_devs_in_pkg - reads a MMD's devices in package registers.
>   * @bus: the target MII bus
>   * @addr: PHY address on the MII bus
> @@ -709,12 +731,25 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>  {
>  	const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
>  	u32 *devs = &c45_ids->devices_in_package;
> -	int i, phy_reg;
> +	int i, ret, phy_reg;
>  
>  	/* Find first non-zero Devices In package. Device zero is reserved
>  	 * for 802.3 c45 complied PHYs, so don't probe it at first.
>  	 */
> -	for (i = 1; i < num_ids && *devs == 0; i++) {
> +	for (i = 1; i < MDIO_MMD_NUM && *devs == 0; i++) {
> +		if (i >= 8) {
> +			/* Only probe for the devices-in-package if there
> +			 * is a PHY reporting as present here; this avoids
> +			 * picking up on PHYs that implement non-IEEE802.3
> +			 * compliant register spaces.
> +			 */
> +			ret = phy_c45_probe_present(bus, addr, i);
> +			if (ret < 0)
> +				return -EIO;
> +
> +			if (!ret)
> +				continue;
> +		}

A second look at 802.3, this can't be done for all MMDs (which becomes
visible when I look at the results from the 88x3310.)  Only MMDs 1, 2,
3, 4, 5, 30 and 31 are defined to have this register with the "Device
Present" bit pair.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
