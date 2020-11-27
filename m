Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B04A2C6C25
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 20:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgK0TsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 14:48:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbgK0Tpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 14:45:46 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E06EF2222C;
        Fri, 27 Nov 2020 19:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606504550;
        bh=CN7WnqLywT0WkIXQYyF/EnLIQ7HnDbQqgSaTlXXK8Yk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1Ula4UQlwAVruarEm+OwgFE+LUDU1WqSDrbYP8k8R5HJ0hqSGHVzCZNsYRmtI8RLU
         cbxfWKCmQppu0rvdhGelD2xOJ1mT7lfA6MYwGPAeCkntIrsq0mmkrQkEIk745BVcVA
         qdPCyhUQN2MRvs5O7BkR27vA1/mdmi/+/0HJWQ10=
Date:   Fri, 27 Nov 2020 11:15:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Niels Petter <petter@ka-long.de>
Subject: Re: [net 2/6] can: mcp251xfd: mcp251xfd_probe(): bail out if no IRQ
 was given
Message-ID: <20201127111549.7d5d50ed@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127100301.512603-3-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
        <20201127100301.512603-3-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 11:02:57 +0100 Marc Kleine-Budde wrote:
> This patch add a check to the mcp251xfd_probe() function to bail out and give
> the user a proper error message if no IRQ is specified. Otherwise the driver
> will probe just fine but ifup will fail with a meaningless "RTNETLINK answers:
> Invalid argument" error message.
> 
> Link: https://lore.kernel.org/r/20201123113522.3820052-1-mkl@pengutronix.de
> Reported-by: Niels Petter <petter@ka-long.de>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> index 9c215f7c5f81..8a39be076e14 100644
> --- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> +++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
> @@ -2738,6 +2738,10 @@ static int mcp251xfd_probe(struct spi_device *spi)
>  	u32 freq;
>  	int err;
>  
> +	if (!spi->irq)
> +		return dev_err_probe(&spi->dev, -ENXIO,
> +				     "No IRQ specified (maybe node \"interrupts-extended\" 

FWIW this looks like an abuse of dev_err_probe() to me. What's the point
of calling it with a constant err which is not EPROBE_DEFER?
