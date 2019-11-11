Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74A8AF6CD0
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 03:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbfKKCdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 21:33:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59590 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfKKCdB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 21:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0gk5JpqASg8bcLIxIJ4kjpyHSqpkm2lPRGxNCUB5uAE=; b=rcn2b3VrcS7YhQbm7sQSIvFhwx
        bVZ7JGry3NxqUiI9C7CGfgGNNUaHl4SVt+GHSz6cZMYKFD4w6UJiKg7b4Y5ldOI71rf6AOBtwJ2V5
        3w04RZ5DI2EdKLilGCS8Q9Y5eC1jbFgaaDNYfnpnqTByaWUQzUvXKa4PMyFJM8aQCJa8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTzVf-0000IA-57; Mon, 11 Nov 2019 03:32:55 +0100
Date:   Mon, 11 Nov 2019 03:32:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Olof Johansson <olof@lixom.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: mdio-octeon: Fix pointer/integer casts
Message-ID: <20191111023255.GY25889@lunn.ch>
References: <20191111004211.96425-1-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111004211.96425-1-olof@lixom.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 04:42:11PM -0800, Olof Johansson wrote:
> Fixes a bunch of these warnings on arm allmodconfig:
> 
> In file included from /build/drivers/net/phy/mdio-cavium.c:11:
> /build/drivers/net/phy/mdio-cavium.c: In function 'cavium_mdiobus_set_mode':
> /build/drivers/net/phy/mdio-cavium.h:114:37: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>   114 | #define oct_mdio_readq(addr)  readq((void *)addr)
>       |                                     ^
> /build/drivers/net/phy/mdio-cavium.c:21:16: note: in expansion of macro 'oct_mdio_readq'
>    21 |  smi_clk.u64 = oct_mdio_readq(p->register_base + SMI_CLK);
>       |                ^~~~~~~~~~~~~~
> 
> Fixes: 171a9bae68c7 ("staging/octeon: Allow test build on !MIPS")
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/net/phy/mdio-cavium.h  | 14 +++++++-------
>  drivers/net/phy/mdio-octeon.c  |  5 ++---
>  drivers/net/phy/mdio-thunder.c |  2 +-
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-cavium.h b/drivers/net/phy/mdio-cavium.h
> index b7f89ad27465f..1cf81f0bc585f 100644
> --- a/drivers/net/phy/mdio-cavium.h
> +++ b/drivers/net/phy/mdio-cavium.h
> @@ -90,7 +90,7 @@ union cvmx_smix_wr_dat {
>  
>  struct cavium_mdiobus {
>  	struct mii_bus *mii_bus;
> -	u64 register_base;
> +	void __iomem *register_base;
>  	enum cavium_mdiobus_mode mode;
>  };
>  
> @@ -98,20 +98,20 @@ struct cavium_mdiobus {
>  
>  #include <asm/octeon/octeon.h>
>  
> -static inline void oct_mdio_writeq(u64 val, u64 addr)
> +static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
>  {
> -	cvmx_write_csr(addr, val);
> +	cvmx_write_csr((u64)addr, val);
>  }

Hi Olof

Humm. The warning goes away, but is it really any better?

Did you try also changing the stub function in
drivers/staging/octeon/octeon-stubs.h so it takes void __iomem?  Or
did that cause a lot more warnings from other places?

Thanks
     Andrew
