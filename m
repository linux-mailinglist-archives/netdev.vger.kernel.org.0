Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6122A269724
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgINUyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 16:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgINUyS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 16:54:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC639215A4;
        Mon, 14 Sep 2020 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600116858;
        bh=MELC8fXJnjPpbKW+nHgP/58kFeDr93rSEVZf+v7rimo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uq3M8FM47K7+8TT5U6idAc1wAA0eolQtFTl/Dh6/+LIqB47xSUs+mFTxb2cYWHaX5
         9xWVnDxPMDOBBpFazRMfSWh8zRXJ4a8Xo6eaVUKng+Lp/6RVyiS1cdOtu/UCH4WwBh
         /H3W7V6s3jfcB7dJSJd+znszxAvr1/zc6DF1ePmA=
Date:   Mon, 14 Sep 2020 13:54:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        martin.blumenstingl@googlemail.com, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 4/4] net: lantiq: Disable IRQs only if NAPI gets
 scheduled
Message-ID: <20200914135415.51161be0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200912193629.1586-5-hauke@hauke-m.de>
References: <20200912193629.1586-1-hauke@hauke-m.de>
        <20200912193629.1586-5-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Sep 2020 21:36:29 +0200 Hauke Mehrtens wrote:
> The napi_schedule() call will only schedule the NAPI if it is not
> already running. To make sure that we do not deactivate interrupts
> without scheduling NAPI only deactivate the interrupts in case NAPI also
> gets scheduled.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/ethernet/lantiq_xrx200.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index abee7d61074c..635ff3a5dcfb 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -345,10 +345,12 @@ static irqreturn_t xrx200_dma_irq(int irq, void *ptr)
>  {
>  	struct xrx200_chan *ch = ptr;
>  
> -	ltq_dma_disable_irq(&ch->dma);
> -	ltq_dma_ack_irq(&ch->dma);
> +	if (napi_schedule_prep(&ch->napi)) {
> +		__napi_schedule(&ch->napi);
> +		ltq_dma_disable_irq(&ch->dma);
> +	}
>  
> -	napi_schedule(&ch->napi);
> +	ltq_dma_ack_irq(&ch->dma);
>  
>  	return IRQ_HANDLED;
>  }

The patches look good to me, but I wonder why you don't want to always
disable the IRQ here? You're guaranteed that NAPI will get called, or it
was disabled. In both cases seems like disabling the IRQ can only help.
