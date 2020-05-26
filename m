Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26EC1E258F
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgEZPfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:35:48 -0400
Received: from foss.arm.com ([217.140.110.172]:52316 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbgEZPfr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 11:35:47 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E064F30E;
        Tue, 26 May 2020 08:35:46 -0700 (PDT)
Received: from [192.168.122.166] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD3283F52E;
        Tue, 26 May 2020 08:35:46 -0700 (PDT)
Subject: Re: [PATCH RFC 7/7] net: phy: read MMD ID from all present MMDs
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
References: <20200526142948.GY1551@shell.armlinux.org.uk>
 <E1jdac8-0005tC-3o@rmk-PC.armlinux.org.uk>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <5bce099a-1bbe-d3ee-7cc1-50ff5e8e25ca@arm.com>
Date:   Tue, 26 May 2020 10:35:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <E1jdac8-0005tC-3o@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/26/20 9:31 AM, Russell King wrote:
> Expand the device_ids[] array to allow all MMD IDs to be read rather
> than just the first 8 MMDs, but only read the ID if the MDIO_STAT2
> register reports that a device really is present here for these new
> devices to maintain compatibility with our current behaviour.
> 
> 88X3310 PHY vendor MMDs do are marked as present in the
> devices_in_package, but do not contain IEE 802.3 compatible register
> sets in their lower space.  This avoids reading incorrect values as MMD
> identifiers.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> ---
>   drivers/net/phy/phy_device.c | 14 ++++++++++++++
>   include/linux/phy.h          |  2 +-
>   2 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1c948bbf4fa0..92742c7be80f 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -773,6 +773,20 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr, u32 *phy_id,
>   		if (!(devs_in_pkg & (1 << i)))
>   			continue;
>   
> +		if (i >= 8) {
> +			/* Only probe the MMD ID for MMDs >= 8 if they report
> +			 * that they are present. We have at least one PHY that
> +			 * reports MMD presence in devs_in_pkg, but does not
> +			 * contain valid IEEE 802.3 ID registers in some MMDs.
> +			 */
> +			ret = phy_c45_probe_present(bus, addr, i);
> +			if (ret < 0)
> +				return ret;
> +
> +			if (!ret)
> +				continue;
> +		}
> +
>   		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
>   		if (phy_reg < 0)
>   			return -EIO;
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 0d41c710339a..3325dd8fb9ac 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -361,7 +361,7 @@ enum phy_state {
>   struct phy_c45_device_ids {
>   	u32 devices_in_package;
>   	u32 mmds_present;
> -	u32 device_ids[8];
> +	u32 device_ids[MDIO_MMD_NUM];

You have a array overflow/invalid access if you don't do this earlier in 
4/7.


>   };
>   
>   struct macsec_context;
> 

