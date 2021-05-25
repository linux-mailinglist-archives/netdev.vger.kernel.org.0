Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF38B390191
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233038AbhEYNDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:03:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232993AbhEYNDi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Bgwi0ddPG4y3izYFh7owVZ/gyl0+tfy9P5xD+jXP9VA=; b=jOxQo9c5qPbinxOWRWOHamtxp5
        u5pmNdJHl9QROZUhmfJzL4jdZiLYjyTvXAdP9co5CFhoG+asjB+xoBYtFggEW5kHpSJxWwgpUpbDc
        ZnljNr+VCj66E4JC+vKRq76sCCBJU3ERxloaH+b3pjnIGGgxfrF8j9MVUric4xk/NLIs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llWh5-006AgT-CM; Tue, 25 May 2021 15:01:59 +0200
Date:   Tue, 25 May 2021 15:01:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH 1/2] net: phy: fix yt8511 clang uninitialized variable
 warning
Message-ID: <YKz1R2+ivmRsjAoL@lunn.ch>
References: <20210525122615.3972574-1-pgwipeout@gmail.com>
 <20210525122615.3972574-2-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525122615.3972574-2-pgwipeout@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 08:26:14AM -0400, Peter Geis wrote:
> clang doesn't preinitialize variables. If phy_select_page failed and
> returned an error, phy_restore_page would be called with `ret` being
> uninitialized.
> Even though phy_restore_page won't use `ret` in this scenario,
> initialize `ret` to silence the warning.
> 
> Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> ---
>  drivers/net/phy/motorcomm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> index 796b68f4b499..5795f446c528 100644
> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -51,7 +51,7 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
>  static int yt8511_config_init(struct phy_device *phydev)
>  {
>  	unsigned int ge, fe;
> -	int ret, oldpage;
> +	int oldpage, ret = 0;

Please keep to reverse Christmas tree.

With that fixed:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
