Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE9D33D0D6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhCPJ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:29:54 -0400
Received: from mail.kernel-space.org ([195.201.34.187]:43004 "EHLO
        mail.kernel-space.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236211AbhCPJ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:29:39 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 05:29:39 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel-space.org;
        s=20190913; t=1615885376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qmo5ofGZf52G4GqOGhG5vIZRek1UX+429nBUjjkbEuY=;
        b=wbqZrgtbQ0iyvlgblWUaZLbkkKDJRhmvbJR6C7n0SXq8wIVwoMDu+cxpInfeREdmxalqkh
        pdPYYA/9cZVUmOT+Mg9xSWpknwIVZ6arUymHGIkUlAtNyP38ZZcx6ZEQm6kgGk9G53IyRw
        0h3VMI7Pr9XgBWZF1bFwKiqKJo9zXrE=
Received: from [192.168.0.2] (host-79-45-237-250.retail.telecomitalia.it [79.45.237.250])
        by sysam.it (OpenSMTPD) with ESMTPSA id c66aedff (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 16 Mar 2021 09:02:55 +0000 (UTC)
Message-ID: <fc58e507-e04e-50bc-8817-2570365d96ca@kernel-space.org>
Date:   Tue, 16 Mar 2021 10:02:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:87.0) Gecko/20100101
 Thunderbird/87.0
Subject: Re: [net 05/11] can: flexcan: flexcan_chip_freeze(): fix chip freeze
 for missing bitrate
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
References: <20210316082104.4027260-1-mkl@pengutronix.de>
 <20210316082104.4027260-6-mkl@pengutronix.de>
From:   Angelo Dureghello <angelo@kernel-space.org>
In-Reply-To: <20210316082104.4027260-6-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 16/03/21 9:20 AM, Marc Kleine-Budde wrote:
> From: Angelo Dureghello <angelo@kernel-space.org>
>
> For cases when flexcan is built-in, bitrate is still not set at
> registering. So flexcan_chip_freeze() generates:
>
> [    1.860000] *** ZERO DIVIDE ***   FORMAT=4
> [    1.860000] Current process id is 1
> [    1.860000] BAD KERNEL TRAP: 00000000
> [    1.860000] PC: [<402e70c8>] flexcan_chip_freeze+0x1a/0xa8
>
> To allow chip freeze, using an hardcoded timeout when bitrate is still
> not set.
>
> Fixes: ec15e27cc890 ("can: flexcan: enable RX FIFO after FRZ/HALT valid")
> Link: https://lore.kernel.org/r/20210315231510.650593-1-angelo@kernel-space.org
> Signed-off-by: Angelo Dureghello <angelo@kernel-space.org>
> [mkl: use if instead of ? operator]
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>  drivers/net/can/flexcan.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index 134c05757a3b..57f3635ad8d7 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -697,9 +697,15 @@ static int flexcan_chip_disable(struct flexcan_priv *priv)
>  static int flexcan_chip_freeze(struct flexcan_priv *priv)
>  {
>  	struct flexcan_regs __iomem *regs = priv->regs;
> -	unsigned int timeout = 1000 * 1000 * 10 / priv->can.bittiming.bitrate;
> +	unsigned int timeout;
> +	u32 bitrate = priv->can.bittiming.bitrate;
>  	u32 reg;
>  
> +	if (bitrate)
> +		timeout = 1000 * 1000 * 10 / bitrate;
> +	else
> +		timeout = FLEXCAN_TIMEOUT_US / 10;
> +
>  	reg = priv->read(&regs->mcr);
>  	reg |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT;
>  	priv->write(reg, &regs->mcr);

?

Just curious, what's the issue with my "?" ?


Regards,
--
Angelo Dureghello
