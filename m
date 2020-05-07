Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199B41C8C25
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEGN0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:26:41 -0400
Received: from foss.arm.com ([217.140.110.172]:59364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgEGN0k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 09:26:40 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 06F3C101E;
        Thu,  7 May 2020 06:26:40 -0700 (PDT)
Received: from [192.168.122.166] (unknown [10.119.48.73])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24FBF3F68F;
        Thu,  7 May 2020 06:26:39 -0700 (PDT)
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
From:   Jeremy Linton <jeremy.linton@arm.com>
Message-ID: <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
Date:   Thu, 7 May 2020 08:26:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/5/20 8:29 AM, Calvin Johnson wrote:
> Extract phy_id from compatible string. This will be used by
> fwnode_mdiobus_register_phy() to create phy device using the
> phy_id.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> ---
> 
> Changes in v3: None
> Changes in v2: None
> 
>   drivers/net/phy/phy_device.c | 21 +++++++++++++++++++++
>   include/linux/phy.h          |  5 +++++
>   2 files changed, 26 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 4204d49586cd..f4ad47f73f8d 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -662,6 +662,27 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
>   }
>   EXPORT_SYMBOL(phy_device_create);
>   
> +/* Extract the phy ID from the compatible string of the form
> + * ethernet-phy-idAAAA.BBBB.
> + */
> +int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
> +{
> +	const char *cp;
> +	unsigned int upper, lower;
> +	int ret;
> +
> +	ret = fwnode_property_read_string(fwnode, "compatible", &cp);
> +	if (!ret) {
> +		if (sscanf(cp, "ethernet-phy-id%4x.%4x",
> +			   &upper, &lower) == 2) {
> +			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +			return 0;
> +		}


Isn't the ACPI _CID() conceptually similar to the DT compatible 
property? It even appears to be getting used in a similar way to 
identify particular phy drivers in this case.


Thanks,



