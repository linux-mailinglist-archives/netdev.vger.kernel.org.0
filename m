Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D9A63E7F6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 03:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiLAClM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 21:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLAClL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 21:41:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A0F292A18
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 18:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Z119mBHaDUIx022QrJyyWWTx8egNlcqNB0hI0mHimos=; b=r1RMdjUI2ZoHFprdi6+FSev6BB
        9iMLW+lpSuX/2yXjDkWQ7sWOBcVgXbLbUXDEApxrjDD95f78mnElzSPw+LNMxed4spO6/yMXC2ZEr
        x5A/Vm2pp7u5cKInlF12fyQ5lgg/5S0P5F1Gt7mGNuihdCBDnzeyrssVHk5swKmLPFs0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0ZVY-0041Vs-Bv; Thu, 01 Dec 2022 03:41:04 +0100
Date:   Thu, 1 Dec 2022 03:41:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ioana.ciornei@nxp.com,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com,
        zengheng4@huawei.com
Subject: Re: [PATCH net] net: mdiobus: remove unneccessary
 fwnode_handle_put() in the error path
Message-ID: <Y4gUQC+Gh4b/lr5f@lunn.ch>
References: <20221130091759.682841-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130091759.682841-1-yangyingliang@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 05:17:59PM +0800, Yang Yingliang wrote:
> If phy_device_register() or fwnode_mdiobus_phy_device_register()
> fail, phy_device_free() is called, the device refcount is decreased
> to 0, then fwnode_handle_put() is called in phy_device_release(),
> so the fwnode_handle_put() in the error path can be removed to avoid
> double put.
> 
> Fixes: cdde1560118f ("net: mdiobus: fix unbalanced node reference count")
> Reported-by: Zeng Heng <zengheng4@huawei.com>
> Tested-by: Zeng Heng <zengheng4@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/mdio/fwnode_mdio.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> index eb344f6d4a7b..e584abda585b 100644
> --- a/drivers/net/mdio/fwnode_mdio.c
> +++ b/drivers/net/mdio/fwnode_mdio.c
> @@ -97,10 +97,8 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
>  	 * register it
>  	 */
>  	rc = phy_device_register(phy);
> -	if (rc) {
> -		fwnode_handle_put(child);
> +	if (rc)
>  		return rc;
> -	}

The current code is:

        /* Associate the fwnode with the device structure so it
         * can be looked up later
         */
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

The fwnode_handle_put(child) balances the earlier
fwnode_handle_get(child).

The code will look wrong without this balance. Please find a better
fix which actually looks correct.

    Andrew
