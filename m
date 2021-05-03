Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CD3371DA4
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 19:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbhECRBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 13:01:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234069AbhECQ5R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:57:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91E1461176;
        Mon,  3 May 2021 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060464;
        bh=GJ7TwwZNdhpalyTS0v9ThEIBUeLJlxiXzIDExLIL4Io=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fP/kEM4vPdbXkP5KGinPqzG+3HwMtnPYhCbeK0uejBILfqskCNQVqMXfND6ZptX0r
         PY7/l72hEv6AvFotwH1oWthetWLATIXHPeEFl7ejRR/ryhvc7C4NOa8NR0yhK6xoTr
         llFtXjZCxedI4bBP0SVsHUl1vVAPsklnRFTZz18qTFN3pYnfYwT/lR1xwG7jJCVE0Z
         MkAuQE61VKXb+3jtEY1/Ma19/MDPjNgKjkSEEoxbGEtoTviLEDtMWiW86sp8RBisZa
         gtR4sUzOrw6KNDdzRnQusgfYv2rn49Pbgdm6Zd9k3e7voanT3ZCTMegGJOpSmST0XD
         DD2PKI0g4ZoMg==
Date:   Mon, 3 May 2021 22:17:32 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Kopp <thomas.kopp@microchip.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] can: mcp251xfd: fix an error pointer dereference in
 probe
Message-ID: <20210503164732.GB3958@thinkpad>
References: <YJANZf13Qxd5Mhr1@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJANZf13Qxd5Mhr1@mwanda>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 05:49:09PM +0300, Dan Carpenter wrote:
> When we converted this code to use dev_err_probe() we accidentally
> removed a return.  It means that if devm_clk_get() it will lead to
> an Oops when we call clk_get_rate() on the next line.
> 
> Fixes: cf8ee6de2543 ("can: mcp251xfd: mcp251xfd_probe(): use dev_err_probe() to simplify error handling")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

Thanks,
Mani

> ---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> index 970dc570e7a5..f122976e90da 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -2885,8 +2885,8 @@ static int mcp251xfd_probe(struct spi_device *spi)
>  
>  	clk = devm_clk_get(&spi->dev, NULL);
>  	if (IS_ERR(clk))
> -		dev_err_probe(&spi->dev, PTR_ERR(clk),
> -			      "Failed to get Oscillator (clock)!\n");
> +		return dev_err_probe(&spi->dev, PTR_ERR(clk),
> +				     "Failed to get Oscillator (clock)!\n");
>  	freq = clk_get_rate(clk);
>  
>  	/* Sanity check */
> -- 
> 2.30.2
> 
