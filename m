Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED88929F7F
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391762AbfEXUAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:00:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391723AbfEXUAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 16:00:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1QkIUroet6jBgR0gr/usvIg2f9ynUBiY7b+7vm3ZQsg=; b=LdQ9v6vba/4NqGqlE/J25YoO0O
        uyqdqx8MIor+rRxNFjdjY+5OqGWW4zkeCWaQa8bUm0dk51I4rMi63tm3VbaJ0qHgCccXHPL/fM2WQ
        Y6+ZZoMSHXYYulcR71QjDI7BiasQEtg2YKUMUEEoQnF+JdsM8oza7Rmc/x97C/at7ucA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hUGMO-0004Hj-Sk; Fri, 24 May 2019 22:00:12 +0200
Date:   Fri, 24 May 2019 22:00:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
Subject: Re: [PATCH 4/8] ARM/net: ixp4xx: Pass ethernet physical base as
 resource
Message-ID: <20190524200012.GP21208@lunn.ch>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524162023.9115-5-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 06:20:19PM +0200, Linus Walleij wrote:
> In order to probe this ethernet interface from the device tree
> all physical MMIO regions must be passed as resources. Begin
> this rewrite by first passing the port base address as a
> resource for all platforms using this driver, remap it in
> the driver and avoid using any reference of the statically
> mapped virtual address in the driver.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-ixp4xx/fsg-setup.c         | 20 ++++++++++++++++++++
>  arch/arm/mach-ixp4xx/goramo_mlr.c        | 20 ++++++++++++++++++++
>  arch/arm/mach-ixp4xx/ixdp425-setup.c     | 20 ++++++++++++++++++++
>  arch/arm/mach-ixp4xx/nas100d-setup.c     | 10 ++++++++++
>  arch/arm/mach-ixp4xx/nslu2-setup.c       | 10 ++++++++++
>  arch/arm/mach-ixp4xx/omixp-setup.c       | 20 ++++++++++++++++++++
>  arch/arm/mach-ixp4xx/vulcan-setup.c      | 20 ++++++++++++++++++++
>  drivers/net/ethernet/xscale/ixp4xx_eth.c | 20 +++++++++++---------
>  8 files changed, 131 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
> index 648932d8d7a8..507ee3878769 100644
> --- a/arch/arm/mach-ixp4xx/fsg-setup.c
> +++ b/arch/arm/mach-ixp4xx/fsg-setup.c
> @@ -132,6 +132,22 @@ static struct platform_device fsg_leds = {
>  };
>  
>  /* Built-in 10/100 Ethernet MAC interfaces */
> +static struct resource fsg_eth_npeb_resources[] = {
> +	{
> +		.start		= IXP4XX_EthB_BASE_PHYS,
> +		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,

Hi Linus

It is a long time since i did resources. But i was always told to use
the SZ_ macros, so SZ_4K. I also think 0xfff is wrong, it should be
0x1000.

	Andrew
