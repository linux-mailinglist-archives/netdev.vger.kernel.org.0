Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AFB2B3023
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgKNT01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:26:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:53872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKNT01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 14:26:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FEF1207DE;
        Sat, 14 Nov 2020 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605381986;
        bh=vBzq4R/SyYKFpJiusG2EXsFFlVZc7qzjeYaPsRcJO2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tQox0vn39qQHtdYqfOT25ZbA7j5kfLUZIV3+HM/fXF1PurfG55rYMOOFujkSqrwLY
         poCdxHr6xLKXqYb1kgMmluT67rQDWltG9EDBvk+bI0BaiKpIyCy0Pdmlyc0Q90wABd
         mB0m75OkXHtgTMsf86qmdAYkhc96+YYE5Uyk27uA=
Date:   Sat, 14 Nov 2020 11:26:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <m.felsch@pengutronix.de>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: phy: smsc: add missed clk_disable_unprepare in
 smsc_phy_probe()
Message-ID: <20201114112625.440b52f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
References: <1605180239-1792-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 19:23:59 +0800 Zhang Changzhong wrote:
> Add the missing clk_disable_unprepare() before return from
> smsc_phy_probe() in the error handling case.
> 
> Fixes: bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/phy/smsc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index ec97669..0fc39ac 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -291,8 +291,10 @@ static int smsc_phy_probe(struct phy_device *phydev)
>  		return ret;
>  
>  	ret = clk_set_rate(priv->refclk, 50 * 1000 * 1000);
> -	if (ret)
> +	if (ret) {
> +		clk_disable_unprepare(priv->refclk);
>  		return ret;
> +	}
>  
>  	return 0;
>  }

Applied, thanks!

The code right above looks highly questionable as well:

        priv->refclk = clk_get_optional(dev, NULL);
        if (IS_ERR(priv->refclk))
                dev_err_probe(dev, PTR_ERR(priv->refclk), "Failed to request clock\n");
 
        ret = clk_prepare_enable(priv->refclk);
        if (ret)
                return ret;

I don't think clk_prepare_enable() will be too happy to see an error
pointer. This should probably be:

        priv->refclk = clk_get_optional(dev, NULL);
        if (IS_ERR(priv->refclk))
                return dev_err_probe(dev, PTR_ERR(priv->refclk), 
				      "Failed to request clock\n");
