Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE771BCC45
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 18:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731823AbfIXQTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 12:19:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34950 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725963AbfIXQTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 12:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vJx4OSw+W8B8k4E2rJbiOozySYYyf29eZ8oUmoJKcmQ=; b=JeYq/lyNoO/HTyK24fwrGLp0HF
        GW9sM8WUJDY08ljNkyXdGGvx93Q6iodF8o5VMmsZO+b1cJraYCeX2rr6PPyMeOX/kGmWsJwAREpBc
        H0rxa1ad8isaBunQ8MriCGVrCnWBhuS7CKZITr0Y0YF4ZF7l1bKhBCgYHvMi/3Rsd1vo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iCnXP-0006Zg-P0; Tue, 24 Sep 2019 18:19:39 +0200
Date:   Tue, 24 Sep 2019 18:19:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-clk@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Tero Kristo <t-kristo@ti.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-rockchip@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/3] clk: let init callback return an error code
Message-ID: <20190924161939.GD28770@lunn.ch>
References: <20190924123954.31561-1-jbrunet@baylibre.com>
 <20190924123954.31561-3-jbrunet@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924123954.31561-3-jbrunet@baylibre.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 24, 2019 at 02:39:53PM +0200, Jerome Brunet wrote:
> If the init callback is allowed to request resources, it needs a return
> value to report the outcome of such a request.
> 
> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
> ---
> 
>  Sorry about the spam.
>  This patch change quite a few files so I have tried to Cc the
>  relevant people. Stephen, You may notice that I have added a
>  couple of the network people. You need an Ack from one of them
>  since the Amlogic G12a mdio mux has a clock which uses the .init()
>  callback

>  static void __init of_ti_clockdomain_setup(struct device_node *node)
> diff --git a/drivers/net/phy/mdio-mux-meson-g12a.c b/drivers/net/phy/mdio-mux-meson-g12a.c
> index 7a9ad54582e1..bf86c9c7a288 100644
> --- a/drivers/net/phy/mdio-mux-meson-g12a.c
> +++ b/drivers/net/phy/mdio-mux-meson-g12a.c
> @@ -123,7 +123,7 @@ static int g12a_ephy_pll_is_enabled(struct clk_hw *hw)
>  	return (val & PLL_CTL0_LOCK_DIG) ? 1 : 0;
>  }
>  
> -static void g12a_ephy_pll_init(struct clk_hw *hw)
> +static int g12a_ephy_pll_init(struct clk_hw *hw)
>  {
>  	struct g12a_ephy_pll *pll = g12a_ephy_pll_to_dev(hw);
>  
> @@ -136,6 +136,8 @@ static void g12a_ephy_pll_init(struct clk_hw *hw)
>  	writel(0x20200000, pll->base + ETH_PLL_CTL5);
>  	writel(0x0000c002, pll->base + ETH_PLL_CTL6);
>  	writel(0x00000023, pll->base + ETH_PLL_CTL7);
> +
> +	return 0;
>  }

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

It should be safe to merge this via the clk tree. You would probably
know about an possible merge conflicts, since you wrote this driver!

    Andrew
