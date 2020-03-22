Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A369318E9BC
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgCVPhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:37:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50326 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgCVPhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:37:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2onCqIcc3JF4Rkct2eyxjN9xBx7pmz24s+lxRPXhiYE=; b=b2S0ec00q/gcNeKzWmh7n+6pBZ
        9BcqShjiDxzxQ/Rzd7NsHIU/63eAVMfgE2hfC/4d7RkQ47XV1FVC4a8sBjYWHRoI9asopjwoNMvGK
        RvLUC9v+z0aBaPDorkmnE5i7KTrQskPBa9m5dTaNRpecX7eAM/qVVUgfXS5W3t3Tv5gQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG2ep-0000Zh-Vk; Sun, 22 Mar 2020 16:36:59 +0100
Date:   Sun, 22 Mar 2020 16:36:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 6/9] net: phy: marvell10g: use
 phy_read_mmd_poll_timeout() to simplify the code
Message-ID: <20200322153659.GO11481@lunn.ch>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-7-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322065555.17742-7-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -241,22 +241,17 @@ static int mv3310_power_up(struct phy_device *phydev)
>  
>  static int mv3310_reset(struct phy_device *phydev, u32 unit)
>  {
> -	int retries, val, err;
> +	int val, err;
>  
>  	err = phy_modify_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1,
>  			     MDIO_CTRL1_RESET, MDIO_CTRL1_RESET);
>  	if (err < 0)
>  		return err;
>  
> -	retries = 20;
> -	do {
> -		msleep(5);
> -		val = phy_read_mmd(phydev, MDIO_MMD_PCS, unit + MDIO_CTRL1);
> -		if (val < 0)
> -			return val;
> -	} while (val & MDIO_CTRL1_RESET && --retries);

This is another example of the sleep happening first. To keep the code
more similar, you probably should add an msleep(5) before calling
phy_read_mmd_poll_timeout().

	Andrew
