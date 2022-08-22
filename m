Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDFF59C4BE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbiHVRK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237175AbiHVRKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:10:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D578D12080;
        Mon, 22 Aug 2022 10:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GfKp3f5Ymjt+SyhQzhhn3iVb0y52yLjbBLoTgaA5xs4=; b=uLIU1bPiItlu2CDatqKOvToPOH
        nbgk39pNb19R5/5maF372B1mztcC+7Mjyx0KZysUxfFVvNDJz+zvwWox+cpv1B/5LWeghFG8BX2DV
        PpbEGAbKGfRcfx7aN2glwSt4K+8/tJoZOxsThRjcPJ/AurT2ZEU3tTYeOUsQzTm7OmKU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oQAvV-00EFF2-Gk; Mon, 22 Aug 2022 19:09:25 +0200
Date:   Mon, 22 Aug 2022 19:09:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net] net: phy: Warn if phy is attached when removing
Message-ID: <YwO4RdY2HT2nYXBf@lunn.ch>
References: <20220816163701.1578850-1-sean.anderson@seco.com>
 <20220819164519.2c71823e@kernel.org>
 <YwAo42QkTgD0kOqz@shell.armlinux.org.uk>
 <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b476d7b1-1221-2275-e445-6a70b3a31fe6@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In the last thread I posted this snippet:
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index a74b320f5b27..05894e1c3e59 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -27,6 +27,7 @@
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
>  #include <linux/property.h>
> +#include <linux/rtnetlink.h>
>  #include <linux/sfp.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> @@ -3111,6 +3112,13 @@ static int phy_remove(struct device *dev)
>  {
>         struct phy_device *phydev = to_phy_device(dev);
>  
> +	// I'm pretty sure this races with multiple unbinds...
> +       rtnl_lock();
> +       device_unlock(dev);
> +       dev_close(phydev->attached_dev);
> +       device_lock(dev);
> +       rtnl_unlock();
> +       WARN_ON(phydev->attached_dev);
> +
>         cancel_delayed_work_sync(&phydev->state_queue);
>  
>         mutex_lock(&phydev->lock);
> ---
> 
> Would this be acceptable? Can the locking be fixed?

Code like this should not be hidden in the PHY layer. If we decide to
go down this path it probably should be in net/core/dev.c.

I suggest you talk to the maintainers of that file, probably Eric
Dumazet, give him a clear explanation of the problem, and see what he
suggests.

	Andrew
