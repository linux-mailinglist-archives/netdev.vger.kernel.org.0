Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF17607916
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiJUOBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiJUOBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:01:30 -0400
X-Greylist: delayed 908 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 21 Oct 2022 07:01:25 PDT
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1A11DEC02;
        Fri, 21 Oct 2022 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vR9tuJLMZg0cMd3jQGnOxd3F/CrROjT+eEFqWGMwYQw=; b=AYNxB7zZPHCxzQl8NpX/bHuNQp
        4jTepzz/MKMcCl9REv7QPur/g0V2/IqfhFRT1vsvGBGJ4WwV/Tz57Dbws4L+AISxwKrq+Yv5NShQQ
        z3GeJ5IT5Sgfa3k8MFrSUQY4LeSvsoubXdHpknc9gTwTFYlvOHzDrmM8mtfaLhqmb6LA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1olsaN-000F41-RP; Fri, 21 Oct 2022 16:01:19 +0200
Date:   Fri, 21 Oct 2022 16:01:19 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lxu@maxlinear.com,
        hkallweit1@gmail.com, pabeni@redhat.com, edumazet@google.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        Ian.Saturley@microchip.com
Subject: Re: [PATCH net-next] net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set
 driver for GPY211 chips
Message-ID: <Y1KmL7vTunvbw1/U@lunn.ch>
References: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021100305.6576-1-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void gpy_update_mdix(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, PHY_CTL1);
> +	if (ret < 0) {
> +		phydev_err(phydev, "Error: MDIO register access failed: %d\n",
> +			   ret);
> +		return;
> +	}

> @@ -413,6 +490,8 @@ static void gpy_update_interface(struct phy_device *phydev)
>  
>  	if (phydev->speed == SPEED_2500 || phydev->speed == SPEED_1000)
>  		genphy_read_master_slave(phydev);
> +
> +	gpy_update_mdix(phydev);

Do you know why gpy_update_interface() is a void function? It is
called from gpy_read_status() which does return error codes. And it
seems like gpy_read_status() would benefit from returning -EINVAL, etc.

      Andrew
