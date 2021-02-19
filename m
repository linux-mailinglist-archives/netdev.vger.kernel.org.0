Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D98031F790
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 11:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhBSKrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 05:47:11 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:46967 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhBSKrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 05:47:09 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6421F22236;
        Fri, 19 Feb 2021 11:46:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613731583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGWu/gA92sQ1ygSwtJY0iUnqCM5fRP1SF/skCVK8eYQ=;
        b=vLjspAJyDzN/tO7QcAlzXBvVMspe3KtPpoFbiKDmchHUnDLD1eUh5ArSW+V3/1kwf27NsH
        ADu8nfxADbHlveFrtb5KyKwabS9jRDkaEFhX4ScAehTKXfhKk9TykjxNlR1yYrDwrtkY5b
        dkuul0rMu0LKHeFMwrd2UxYb+6SyWn0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 19 Feb 2021 11:46:23 +0100
From:   Michael Walle <michael@walle.cc>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: phy: icplus: call phy_restore_page()
 when phy_select_page() fails
In-Reply-To: <YC+OpFGsDPXPnXM5@mwanda>
References: <YC+OpFGsDPXPnXM5@mwanda>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <b10a9b2cf171976e710c309fc82a4728@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-19 11:10, schrieb Dan Carpenter:
> The comments to phy_select_page() say that "phy_restore_page() must
> always be called after this, irrespective of success or failure of this
> call."  If we don't call phy_restore_page() then we are still holding
> the phy_lock_mdio_bus() so it eventually leads to a dead lock.
> 
> Fixes: 32ab60e53920 ("net: phy: icplus: add MDI/MDIX support for 
> IP101A/G")
> Fixes: f9bc51e6cce2 ("net: phy: icplus: fix paged register access")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Michael Walle <michael@walle.cc>

I assume, this has to go through "net" if the merge window is closed, 
no?

-michael

> ---
> v2: fix a couple other instances I missed in v1
> 
>  drivers/net/phy/icplus.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
> index 3e431737c1ba..a00a667454a9 100644
> --- a/drivers/net/phy/icplus.c
> +++ b/drivers/net/phy/icplus.c
> @@ -239,7 +239,7 @@ static int ip101a_g_config_intr_pin(struct
> phy_device *phydev)
> 
>  	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>  	if (oldpage < 0)
> -		return oldpage;
> +		goto out;
> 
>  	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
>  	switch (priv->sel_intr32) {
> @@ -314,7 +314,7 @@ static int ip101a_g_read_status(struct phy_device 
> *phydev)
> 
>  	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>  	if (oldpage < 0)
> -		return oldpage;
> +		goto out;
> 
>  	ret = __phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
>  	if (ret < 0)
> @@ -349,7 +349,8 @@ static int ip101a_g_read_status(struct phy_device 
> *phydev)
>  static int ip101a_g_config_mdix(struct phy_device *phydev)
>  {
>  	u16 ctrl = 0, ctrl2 = 0;
> -	int oldpage, ret;
> +	int oldpage;
> +	int ret = 0;
> 
>  	switch (phydev->mdix_ctrl) {
>  	case ETH_TP_MDI:
> @@ -367,7 +368,7 @@ static int ip101a_g_config_mdix(struct phy_device 
> *phydev)
> 
>  	oldpage = phy_select_page(phydev, IP101G_DEFAULT_PAGE);
>  	if (oldpage < 0)
> -		return oldpage;
> +		goto out;
> 
>  	ret = __phy_modify(phydev, IP10XX_SPEC_CTRL_STATUS,
>  			   IP101A_G_AUTO_MDIX_DIS, ctrl);

-- 
-michael
