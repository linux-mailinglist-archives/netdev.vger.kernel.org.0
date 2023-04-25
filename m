Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D3F6EE197
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbjDYMFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232881AbjDYMFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:05:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EECA3AA9;
        Tue, 25 Apr 2023 05:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dWhSY0iPXmj4F77ncGHclUHy20l/c0UzrIFeDbV0o7k=; b=TgDHklzckVcxx8myf2QRmnwF4v
        glNq5YKe501d3GxXDbSuoGfZAJVA4P12LGY1ungN5ONG2y753xV+zQmxldalxA3TTm+8JYrwK56eA
        Ua024RZu0hhi6zdwK1Cz2zbCPU4kaWKafr8ZRYKh/SINN+yWTQmOUK5ka7Jk3lwMAjXY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1prHQM-00BBNp-T4; Tue, 25 Apr 2023 14:05:34 +0200
Date:   Tue, 25 Apr 2023 14:05:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
Subject: Re: [RFC PATCH 1/2] net: phy: dp83867: add w/a for packet errors
 seen with short cables
Message-ID: <f29411d2-c596-4a07-8b6a-7d6e203c25e0@lunn.ch>
References: <20230425054429.3956535-1-s-vadapalli@ti.com>
 <20230425054429.3956535-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425054429.3956535-2-s-vadapalli@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:14:28AM +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Introduce the W/A for packet errors seen with short cables (<1m) between
> two DP83867 PHYs.
> 
> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
> and soft resets as follows:
> 
> write_reg(0x001F, 0x8000); //hard reset
> write_reg(DSP_FFE_CFG, 0x0E81);
> write_reg(0x001F, 0x4000); //soft reset
> 
> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
> affect Long Cable performance.", enable the W/A by default.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html

Please set the tree in the Subject line to be net.
Please also add a Fixes: tag, probably for the patch which added this driver.




> ---
>  drivers/net/phy/dp83867.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 5821f04c69dc..ba60cf35872e 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -42,6 +42,7 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_STRAP_STS2	0x006f
>  #define DP83867_RGMIIDCTL	0x0086
> +#define DP83867_DSP_FFE_CFG	0X012C
>  #define DP83867_RXFCFG		0x0134
>  #define DP83867_RXFPMD1	0x0136
>  #define DP83867_RXFPMD2	0x0137
> @@ -934,8 +935,20 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>  
>  	usleep_range(10, 20);
>  
> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
> +	if (err < 0)
> +		return err;
> +
> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);

Maybe check the return code for errors?

      Andrew
