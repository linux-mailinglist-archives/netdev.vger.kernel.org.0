Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7D661207
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfGFPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 11:54:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfGFPyb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Jul 2019 11:54:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4OhYEfYRO5YkwBNrseWLCg9lFFE1VTQ7G8ZQPvXZtB8=; b=5E3AmYXM6z+AACoMcwAW+K7+03
        a2SXTmJ693NY/8yukGTxxLvQBkzrbTDhO/4Xymv7vqXCXKgQRzxYcp2DSmmtP2+vl+dpDt8z2AtsJ
        CTUAMzgwzc4zg94uJFpf2NT9D6D5aw39aBP6HQFgqTzPSbnNqbL5HDc2DFIqr7mwgHzA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjn1A-0000R9-BN; Sat, 06 Jul 2019 17:54:28 +0200
Date:   Sat, 6 Jul 2019 17:54:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     josua@solid-run.com
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/4] net: mvmdio: defer probe of orion-mdio if a clock is
 not ready
Message-ID: <20190706155428.GG4428@lunn.ch>
References: <20190706151900.14355-1-josua@solid-run.com>
 <20190706151900.14355-5-josua@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706151900.14355-5-josua@solid-run.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 06, 2019 at 05:19:00PM +0200, josua@solid-run.com wrote:
> From: Josua Mayer <josua@solid-run.com>
> 
> Defer probing of the orion-mdio interface when enabling of either of the
> clocks defer probing.

Hi Josua

I'm having trouble parsing that sentence.

How about:

Defer probing of the orion-mdio interface when getting a clock returns
EPROBE_DEFER.

Otherwise:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew




 This avoids locking up the Armada 8k SoC when mdio
> is used before all clocks have been enabled.
> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
>  drivers/net/ethernet/marvell/mvmdio.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
> index 89a99bf8e87b..1034013426ad 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -321,6 +321,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  
>  	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
>  		dev->clk[i] = of_clk_get(pdev->dev.of_node, i);
> +		if (dev->clk[i] == PTR_ERR(-EPROBE_DEFER)) {
> +			ret = -EPROBE_DEFER;
> +			goto out_clk;
> +		}
>  		if (IS_ERR(dev->clk[i]))
>  			break;
>  		clk_prepare_enable(dev->clk[i]);
> @@ -366,6 +370,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  	if (dev->err_interrupt > 0)
>  		writel(0, dev->regs + MVMDIO_ERR_INT_MASK);
>  
> +out_clk:
>  	for (i = 0; i < ARRAY_SIZE(dev->clk); i++) {
>  		if (IS_ERR(dev->clk[i]))
>  			break;
> -- 
> 2.16.4
> 
