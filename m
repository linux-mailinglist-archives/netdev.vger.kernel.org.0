Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF71D1E2598
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgEZPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:38:33 -0400
Received: from foss.arm.com ([217.140.110.172]:52364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728166AbgEZPic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:38:32 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 010FE30E;
        Tue, 26 May 2020 08:38:32 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C8B6C3F52E;
        Tue, 26 May 2020 08:38:31 -0700 (PDT)
Subject: Re: [PATCH RFC 3/7] net: phy: clean up PHY ID reading
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdabn-0005sO-LN@rmk-PC.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <d73f2250-d89e-b79b-5ea1-dca4c0d22c4c@arm.com>
Date:   Tue, 26 May 2020 10:38:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <E1jdabn-0005sO-LN@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/26/20 9:31 AM, Russell King wrote:
> Rearrange the code to read the PHY IDs, so we don't call get_phy_id()
> only to immediately call get_phy_c45_ids().  Move that logic into
> get_phy_device(), which results in better readability.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phy_device.c | 25 +++++++++----------------
>   1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index e04284c4ebf8..0d6b6ca66216 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -756,29 +756,18 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   }
>   
>   /**
> - * get_phy_id - reads the specified addr for its ID.
> + * get_phy_c22_id - reads the specified addr for its clause 22 ID.
>    * @bus: the target MII bus
>    * @addr: PHY address on the MII bus
>    * @phy_id: where to store the ID retrieved.
> - * @is_c45: If true the PHY uses the 802.3 clause 45 protocol
> - * @c45_ids: where to store the c45 ID information.
> - *
> - * Description: In the case of a 802.3-c22 PHY, reads the ID registers
> - *   of the PHY at @addr on the @bus, stores it in @phy_id and returns
> - *   zero on success.
> - *
> - *   In the case of a 802.3-c45 PHY, get_phy_c45_ids() is invoked, and
> - *   its return value is in turn returned.
>    *
> + * Read the 802.3 clause 22 PHY ID from the PHY at @addr on the @bus.
> + * Return the PHY ID read from the PHY in @phy_id on successful access.
>    */
> -static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
> -		      bool is_c45, struct phy_c45_device_ids *c45_ids)
> +static int get_phy_c22_id(struct mii_bus *bus, int addr, u32 *phy_id)
>   {
>   	int phy_reg;
>   
> -	if (is_c45)
> -		return get_phy_c45_ids(bus, addr, phy_id, c45_ids);
> -
>   	/* Grab the bits from PHYIR1, and put them in the upper half */
>   	phy_reg = mdiobus_read(bus, addr, MII_PHYSID1);
>   	if (phy_reg < 0) {
> @@ -817,7 +806,11 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
>   	c45_ids.devices_in_package = 0;
>   	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
>   
> -	r = get_phy_id(bus, addr, &phy_id, is_c45, &c45_ids);
> +	if (is_c45)
> +		r = get_phy_c45_ids(bus, addr, &phy_id, &c45_ids);
> +	else
> +		r = get_phy_c22_id(bus, addr, &phy_id);
> +
>   	if (r)
>   		return ERR_PTR(r);
>   
> 

I see this, and the c22 regs detection, but I don't see how your 
choosing to use the c22 regs if the 45's aren't responding. Which was 
one of the primary purposes of that other set.

