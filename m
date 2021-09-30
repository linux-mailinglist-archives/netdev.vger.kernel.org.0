Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697F941D38F
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348332AbhI3Gqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:46:53 -0400
Received: from mga05.intel.com ([192.55.52.43]:15339 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236162AbhI3Gqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 02:46:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="310661916"
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="310661916"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 23:45:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,335,1624345200"; 
   d="scan'208";a="438747782"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 29 Sep 2021 23:45:09 -0700
Received: from linux.intel.com (vwong3-iLBPG3.png.intel.com [10.88.229.80])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id CC44E58097E;
        Wed, 29 Sep 2021 23:45:06 -0700 (PDT)
Date:   Thu, 30 Sep 2021 14:45:03 +0800
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, buytenh@marvell.com,
        afleming@freescale.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v3 2/2] phy: mdio: fix memory leak
Message-ID: <20210930064503.GA7992@linux.intel.com>
References: <f12fb1faa4eccf0f355788225335eb4309ff2599.1632982651.git.paskripkin@gmail.com>
 <5745dea4e12268a3f6b0772317f1cf0f49dab958.1632982651.git.paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5745dea4e12268a3f6b0772317f1cf0f49dab958.1632982651.git.paskripkin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 09:19:54AM +0300, Pavel Skripkin wrote:
> Syzbot reported memory leak in MDIO bus interface, the problem was in
> wrong state logic.
> 
> MDIOBUS_ALLOCATED indicates 2 states:
> 	1. Bus is only allocated
> 	2. Bus allocated and __mdiobus_register() fails, but
> 	   device_register() was called
> 
> In case of device_register() has been called we should call put_device()
> to correctly free the memory allocated for this device, but mdiobus_free()
> calls just kfree(dev) in case of MDIOBUS_ALLOCATED state
> 
> To avoid this behaviour we need to set bus->state to MDIOBUS_UNREGISTERED
> _before_ calling device_register(), because put_device() should be
> called even in case of device_register() failure.
> 
> Link: https://lore.kernel.org/netdev/YVMRWNDZDUOvQjHL@shell.armlinux.org.uk/
> Fixes: 46abc02175b3 ("phylib: give mdio buses a device tree presence")
> Reported-and-tested-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes in v3:
> 	s/==/=/
> 	Added Dan's Reviewed-by tag
> 
> Changes in v2:
> 	Removed new state, since MDIOBUS_UNREGISTERED can be used. Also, moved
> 	bus->state initialization _before_ device_register() call, because
> 	Yanfei's patch is reverted in [v2 1/2]
> 
> ---
>  drivers/net/phy/mdio_bus.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..a5f910d4a7be 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -534,6 +534,13 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	bus->dev.groups = NULL;
>  	dev_set_name(&bus->dev, "%s", bus->id);
>  
> +	/* We need to set state to MDIOBUS_UNREGISTERED to correctly realese

Typo here. s/realese/release/

> +	 * the device in mdiobus_free()
> +	 *
> +	 * State will be updated later in this function in case of success
> +	 */
> +	bus->state = MDIOBUS_UNREGISTERED;
> +
>  	err = device_register(&bus->dev);
>  	if (err) {
>  		pr_err("mii_bus %s failed to register\n", bus->id);
