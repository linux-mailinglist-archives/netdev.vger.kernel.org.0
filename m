Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF038211337
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 21:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgGATFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 15:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgGATFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 15:05:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02A8A20702;
        Wed,  1 Jul 2020 19:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593630339;
        bh=ytWFFPodPd2V2jake26qrl9K1G+M8w6Nt+ZsNZhQszg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ziMWFsFaMafhBmyDmkBqh5BGEpU7VJkdEC7O871qxlpdy0XeBYvMrO6JYuEFPIWa+
         LcdgMsljGHMTMbWz2rh6TL1y2pXYtuCVf4WZeXb/mJPJrL3/QE5NfhKmG9Y/Q2qTq+
         9hkg5nYWwDfTyCjFkvQldnT2H4/qZexikmK8RCDg=
Date:   Wed, 1 Jul 2020 12:05:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 06/15] sfc: commonise
 netif_set_real_num[tr]x_queues calls
Message-ID: <20200701120537.0b36322a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f58eb18e-8b7a-5b79-be31-ec794f3262e1@solarflare.com>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
        <f58eb18e-8b7a-5b79-be31-ec794f3262e1@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Jul 2020 15:53:15 +0100 Edward Cree wrote:
> Signed-off-by: Edward Cree <ecree@solarflare.com>
> ---
>  drivers/net/ethernet/sfc/efx.c          | 3 ---
>  drivers/net/ethernet/sfc/efx_channels.c | 4 ++++
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
> index f4173f855438..9f659cc34252 100644
> --- a/drivers/net/ethernet/sfc/efx.c
> +++ b/drivers/net/ethernet/sfc/efx.c
> @@ -336,9 +336,6 @@ static int efx_probe_nic(struct efx_nic *efx)
>  				    sizeof(efx->rss_context.rx_hash_key));
>  	efx_set_default_rx_indir_table(efx, &efx->rss_context);
>  
> -	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
> -	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
> -
>  	/* Initialise the interrupt moderation settings */
>  	efx->irq_mod_step_us = DIV_ROUND_UP(efx->timer_quantum_ns, 1000);
>  	efx_init_irq_moderation(efx, tx_irq_mod_usec, rx_irq_mod_usec, true,
> diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
> index 41bf18f2b081..dd6ee60b66a0 100644
> --- a/drivers/net/ethernet/sfc/efx_channels.c
> +++ b/drivers/net/ethernet/sfc/efx_channels.c
> @@ -894,6 +894,10 @@ int efx_set_channels(struct efx_nic *efx)
>  			}
>  		}
>  	}
> +
> +	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
> +	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);

For a third time in last 7 days - these can fail :)

I know you're just moving them, but perhaps worth cleaning this up..
