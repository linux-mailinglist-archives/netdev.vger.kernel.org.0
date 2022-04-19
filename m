Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CEA506C7F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243062AbiDSMfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiDSMfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:35:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA97422500;
        Tue, 19 Apr 2022 05:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LXAU4p3dgxIGDfB6x6wqmrNe9zcGvWYFDnEwJiHYyd0=; b=4ZGphubJ8lGK9Yz+FHjsdHZJu3
        ic2duJUn9kZMe2bZnZsOINjHfsFetkjM+QPb3pJ/hlUpw9X6fSSrKfdnDrA1y41EBu7FpnSa/okR5
        Y13/z1RZnS1DfFJSBb7X8dnuKRMawXp7GHtiX7/LM85Dnq26R1Z9XANVpyphQ8kG2Dnw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngn1u-00GUp4-9t; Tue, 19 Apr 2022 14:32:26 +0200
Date:   Tue, 19 Apr 2022 14:32:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        richardcochran@gmail.com
Subject: Re: [RFC PATCH net-next 1/2] net: phy: Add phy latency adjustment
 support in phy framework.
Message-ID: <Yl6r2mOlszx1I+fv@lunn.ch>
References: <20220419083704.48573-1-horatiu.vultur@microchip.com>
 <20220419083704.48573-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419083704.48573-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:37:03AM +0200, Horatiu Vultur wrote:
> Add adjustment support for latency for the phy using sysfs.
> This is used to adjust the latency of the phy based on link mode
> and direction.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../ABI/testing/sysfs-class-net-phydev        | 10 ++++
>  drivers/net/phy/phy_device.c                  | 58 +++++++++++++++++++
>  include/linux/phy.h                           |  9 +++
>  3 files changed, 77 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documentation/ABI/testing/sysfs-class-net-phydev
> index ac722dd5e694..a99bbfeddb6f 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
> @@ -63,3 +63,13 @@ Description:
>  		only used internally by the kernel and their placement are
>  		not meant to be stable across kernel versions. This is intended
>  		for facilitating the debugging of PHY drivers.
> +
> +What:		/sys/class/mdio_bus/<bus>/<device>/adjust_latency
> +Date:		April 2022
> +KernelVersion:	5.19
> +Contact:	netdev@vger.kernel.org
> +Description:
> +		This file adjusts the latency in the PHY. To set value,
> +		write three integers into the file: interface mode, RX latency,
> +		TX latency. When the file is read, it returns the supported
> +		interface modes and the latency values.

https://lwn.net/Articles/378884/

	The key design goal relating to attribute files is the
	stipulation - almost a mantra - of "one file, one value" or
	sometimes "one item per file". The idea here is that each
	attribute file should contain precisely one value. If multiple
	values are needed, then multiple files should be used.

You also need to specify units in the documentation.

> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8406ac739def..80bf04ca0e02 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -529,6 +529,48 @@ static ssize_t phy_dev_flags_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(phy_dev_flags);
>  
> +static ssize_t adjust_latency_show(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct phy_device *phydev = to_phy_device(dev);
> +	ssize_t count = 0;
> +	int err, i;
> +	s32 rx, tx;
> +
> +	for (i = 0; i < __ETHTOOL_LINK_MODE_MASK_NBITS; ++i) {
> +		err = phydev->drv->get_adj_latency(phydev, i, &rx, &tx);
> +		if (err == -EINVAL)

-EOPNOTSUPP seems more likley than EINVAL.

> +			continue;
> +
> +		count += sprintf(&buf[count], "%d rx: %d, tx: %d\n", i, rx, tx);

Link modes as a number? Can you tell me off the top of you head what
link mode 42 is?

Also, if phydev->drv->get_adj_latency() returns any other error, it is
likely rx and tx contain rubbish, yet you still add them to the
output.

> @@ -932,6 +932,15 @@ struct phy_driver {
>  	int (*get_sqi)(struct phy_device *dev);
>  	/** @get_sqi_max: Get the maximum signal quality indication */
>  	int (*get_sqi_max)(struct phy_device *dev);
> +	/** @set_adj_latency: Set the latency values of the PHY */
> +	int (*set_adj_latency)(struct phy_device *dev,
> +			       enum ethtool_link_mode_bit_indices link_mode,
> +			       s32 rx, s32 tx);
> +	/** @get_latency: Get the latency values of the PHY */
> +	int (*get_adj_latency)(struct phy_device *dev,
> +			       enum ethtool_link_mode_bit_indices link_mode,
> +			       s32 *rx, s32 *tx);

You need to clearly document the return value here, that -EINVAL (or
maybe -EOPNOTUSPP) has special meaning. I would also document the
units, and what is supposed to happen if the stamper already has a
hard coded offset.

     Andrew
