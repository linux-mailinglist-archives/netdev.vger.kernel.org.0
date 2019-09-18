Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05A38B6710
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 17:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfIRP0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 11:26:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53102 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387466AbfIRP0s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 11:26:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rMO0GB74u208w0s9L1VnSEFBd3xoiYe5Pq/uI+rk3S0=; b=FDHL+zPdkSSTK1yefcMu++bUaV
        2MEPOKNDY4FiLOA7T1fZyniUXD93BrNkcWXoL++GKNKvn9DZbveT17bWjpEJibQD9t2ArathPRpKc
        N1AHEsHKVG0T8hJzFnrdauCIhyg+Rjm8PsmxFw3Ls01MV+zzEtm3A2TnmYi0Vk0pc82w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iAbqw-0008UG-WA; Wed, 18 Sep 2019 17:26:46 +0200
Date:   Wed, 18 Sep 2019 17:26:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Mamonov <pmamonov@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net/phy: fix DP83865 10 Mbps HDX loopback disable
 function
Message-ID: <20190918152646.GL9591@lunn.ch>
References: <20190918141931.GK9591@lunn.ch>
 <20190918144825.23285-1-pmamonov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918144825.23285-1-pmamonov@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 05:48:25PM +0300, Peter Mamonov wrote:
> According to the DP83865 datasheet "The 10 Mbps HDX loopback can be
> disabled in the expanded memory register 0x1C0.1." The driver erroneously
> used bit 0 instead of bit 1.

Hi Peter

This is version 2, not 1. Or if you want to start counting from 0, it
would be good to put v0 in your first patch :-)

It is also normal to put in the commit message what changed from the
previous version.

This is a fix. So please add a Fixes: tag, with the hash of the commit
which introduced the problem.

And since this is a fix, it should be against DaveM net tree, and you
indicate this in the subject line with [PATCH net v3].

Thanks
	Andrew

> 
> Signed-off-by: Peter Mamonov <pmamonov@gmail.com>
> ---
>  drivers/net/phy/national.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/national.c b/drivers/net/phy/national.c
> index 2addf1d3f619..3aa910b3dc89 100644
> --- a/drivers/net/phy/national.c
> +++ b/drivers/net/phy/national.c
> @@ -110,14 +110,17 @@ static void ns_giga_speed_fallback(struct phy_device *phydev, int mode)
>  
>  static void ns_10_base_t_hdx_loopack(struct phy_device *phydev, int disable)
>  {
> +	u16 lb_dis = BIT(1);
> +
>  	if (disable)
> -		ns_exp_write(phydev, 0x1c0, ns_exp_read(phydev, 0x1c0) | 1);
> +		ns_exp_write(phydev, 0x1c0,
> +			     ns_exp_read(phydev, 0x1c0) | lb_dis);
>  	else
>  		ns_exp_write(phydev, 0x1c0,
> -			     ns_exp_read(phydev, 0x1c0) & 0xfffe);
> +			     ns_exp_read(phydev, 0x1c0) & ~lb_dis);
>  
>  	pr_debug("10BASE-T HDX loopback %s\n",
> -		 (ns_exp_read(phydev, 0x1c0) & 0x0001) ? "off" : "on");
> +		 (ns_exp_read(phydev, 0x1c0) & lb_dis) ? "off" : "on");
>  }
>  
>  static int ns_config_init(struct phy_device *phydev)
> -- 
> 2.23.0
> 
