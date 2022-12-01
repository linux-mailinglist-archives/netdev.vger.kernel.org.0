Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616F463F40C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiLAPeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231926AbiLAPeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:34:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BD41F609
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 07:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uAcMI4pUjQZdj+7GJDwPDViDFFgAlrMB9ggD2yfXkGI=; b=rFp6Ke+Danz/eEZ1xIOX8G3ugn
        /rtFT5fnFu7q2YKkymDzLCZXOgXIHj3W5Ov1zEGNfClf6Gmgz0k6owsq8TWFeuuYJDPLXlDCcUL04
        RCsvZuNm4W8ObzbB1YyN85esJtQklMZcXna7I6f5CS+g1new8tBGidZiBIcGQJilIkLU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0lYx-0044cI-Dg; Thu, 01 Dec 2022 16:33:23 +0100
Date:   Thu, 1 Dec 2022 16:33:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ioana.ciornei@nxp.com,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com,
        zengheng4@huawei.com
Subject: Re: [PATCH net v2] net: mdiobus: fix double put fwnode in the error
 path
Message-ID: <Y4jJQ3iKkico/xFX@lunn.ch>
References: <20221201033838.1938765-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201033838.1938765-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 11:38:38AM +0800, Yang Yingliang wrote:
> If phy_device_register() or fwnode_mdiobus_phy_device_register()
> fail, phy_device_free() is called, the device refcount is decreased
> to 0, then fwnode_handle_put() will be called in phy_device_release(),
> but in the error path, fwnode_handle_put() has already been called,
> so set fwnode to NULL after fwnode_handle_put() in the error path to
> avoid double put.
> 
> Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
> Reported-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>   Don't remove fwnode_handle_put() in the error path,
>   set fwnode to NULL avoid double put.
> ---
>  drivers/net/mdio/fwnode_mdio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index eb344f6d4a7b..9df618577712 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -99,6 +99,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  	rc = phy_device_register(phy);
>  	if (rc) {
>  		fwnode_handle_put(child);
> +		device_set_node(&phy->mdio.dev, NULL);
>  		return rc;
>  	}

This looks better, it is balanced. But i would argue the order is
wrong.

	fwnode_handle_get(child);
	device_set_node(&phy->mdio.dev, child);

	/* All data is now stored in the phy struct;
	 * register it
	 */
	rc = phy_device_register(phy);
	if (rc) {
		fwnode_handle_put(child);
		return rc;
	}

In general you undo stuff in the opposite order to which you did
it. So device_set_node() first, then fwnode_handle_put(). Otherwise
you have a potential race condition.

    Andrew
