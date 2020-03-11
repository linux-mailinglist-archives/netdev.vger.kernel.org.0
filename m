Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C38418178A
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 13:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgCKMKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 08:10:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgCKMKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 08:10:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RGRedE7yQEY4gTaGAIkq3EmD+XbZElrK80vPnapDIPI=; b=UrOQhSD3l9KySCzVTkWXrGdcRz
        a6RfvhjpNNPjVDknvXKKbvacnMmqncrxAY4cHQhY8b3rB4mk9ienutLmQP8IJPUoa/w9qtcwnorUK
        p1KgCJnn5t52ntkvc/7QMCEfLhst1xqljxpTsx/gPnFr2IUVkMmjAlttWmlaylxi3+kQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jC0Bo-0003L7-0F; Wed, 11 Mar 2020 13:10:20 +0100
Date:   Wed, 11 Mar 2020 13:10:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, josua@solid-run.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvmdio: avoid error message for optional IRQ
Message-ID: <20200311121019.GH5932@lunn.ch>
References: <20200311024131.1289-1-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311024131.1289-1-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:41:30PM +1300, Chris Packham wrote:
> Per the dt-binding the interrupt is optional so use
> platform_get_irq_optional() instead of platform_get_irq(). Since
> commit 7723f4c5ecdb ("driver core: platform: Add an error message to
> platform_get_irq*()") platform_get_irq() produces an error message
> 
>   orion-mdio f1072004.mdio: IRQ index 0 not found
> 
> which is perfectly normal if one hasn't specified the optional property
> in the device tree.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
>  drivers/net/ethernet/marvell/mvmdio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
> index 0b9e851f3da4..d14762d93640 100644
> --- a/drivers/net/ethernet/marvell/mvmdio.c
> +++ b/drivers/net/ethernet/marvell/mvmdio.c
> @@ -347,7 +347,7 @@ static int orion_mdio_probe(struct platform_device *pdev)
>  	}
>  
>  
> -	dev->err_interrupt = platform_get_irq(pdev, 0);
> +	dev->err_interrupt = platform_get_irq_optional(pdev, 0);
>  	if (dev->err_interrupt > 0 &&
>  	    resource_size(r) < MVMDIO_ERR_INT_MASK + 4) {
>  		dev_err(&pdev->dev,

Hi Chris

This is the minimum fix. So:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

However, you could also simplify

        } else if (dev->err_interrupt == -EPROBE_DEFER) {
                ret = -EPROBE_DEFER;
                goto out_mdio;
        }


to just

        } else {
                ret = dev->err_interrupt;
                goto out_mdio;
        }

    Andrew
