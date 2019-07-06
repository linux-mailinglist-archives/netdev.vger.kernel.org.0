Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A3C6121B
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 18:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfGFQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 12:09:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726760AbfGFQJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 12:09:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uOP6+Pw6Os+yP1S5P/keNYqo5ALhIebG26NWcrrGP+8=; b=kKvPCk7NSlbtKnx6fg6M1XFbbl
        ogc/fytJjcbUsvrlixl2A45N0NJLNiqxqHqF5N7uSpT/kIk6eq1Dn7V/xXzXQA5EegoQEYF5t7ps9
        6iZ++4u/At3lBkECmyIQ1gwlELIZZ18bwPwdJYHzCdti0sZdVlgH9nEsfi6IjSarzcf0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjnFd-0000c6-9U; Sat, 06 Jul 2019 18:09:25 +0200
Date:   Sat, 6 Jul 2019 18:09:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/4] net: mvmdio: print warning when orion-mdio has too
 many clocks
Message-ID: <20190706160925.GI4428@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-4-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706151900.14355-4-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 05:18:59PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Print a warning when device tree specifies more than the maximum of four
> clocks supported by orion-mdio. Because reading from mdio can lock up
> the Armada 8k when a required clock is not initialized, it is important
> to notify the user when a specified clock is ignored.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
>  drivers/net/ethernet/marvell/mvmdio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
> index e17d563e97a6..89a99bf8e87b 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -326,6 +326,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  		clk_prepare_enable(dev->clk[i]);
>  	}
>  
> +	if (!IS_ERR(of_clk_get(pdev->dev.of_node, i)))
> +		dev_warn(dev, "unsupported number of clocks, limiting to the first "
> +			 __stringify(ARRAY_SIZE(dev->clk)) "\n");
> +

Hi Josua

Humm. Say getting clock 0 returned -EINVAL, or some other error code.
We break out of the loop, since such errors are being ignored. We then
hit this new code. Getting clock 1 works, and then we incorrectly
print this message.

Rather than getting the i'th clock, get ARRAY_SIZE(dev->clk)'th clock.

       Andrew
