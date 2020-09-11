Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B82662D1
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 18:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgIKQB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 12:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726571AbgIKQBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 12:01:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE1521D47;
        Fri, 11 Sep 2020 16:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599840108;
        bh=knCRXCLn75tulP2KCm2g+C+Q9K8EWK1qfV5qYyZSJGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0COrUkfB2PHDJUnjB+8NCdRzwL01JNWbSt1Yk5ZZayiwXKmkKv6OHuMU8gX/ww2cQ
         /nAfDacFWrDVbK81TvNxPU/gNfLAJiK5n7t5Z+H4bo7mQ1u6hJdISGfBbrqZToZtcW
         ybpj6vBHKOFXSlTxFPm0ZVOtxwK2BK1dKGrhSegQ=
Date:   Fri, 11 Sep 2020 09:01:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 5/7] sfc: de-indirect TSO handling
Message-ID: <20200911090146.61eb66f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <96677549-bc70-9785-aab5-b55dd15ecef6@solarflare.com>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
        <96677549-bc70-9785-aab5-b55dd15ecef6@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 21:33:11 +0100 Edward Cree wrote:
> index 078c7ec2a70e..272eb5ecb7e7 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.c
> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> @@ -38,7 +38,8 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue)
>  				    tx_queue->channel->channel -
>  				    tx_queue->efx->tx_channel_offset);
>  
> -	if (efx_mcdi_tx_init(tx_queue, false))
> +	tx_queue->tso_version = 3;
> +	if (efx_mcdi_tx_init(tx_queue))
>  		netdev_WARN(tx_queue->efx->net_dev,
>  			    "failed to initialise TXQ %d\n", tx_queue->queue);
>  }

> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -338,8 +338,18 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
>  	 * size limit.
>  	 */
>  	if (segments) {
> -		EFX_WARN_ON_ONCE_PARANOID(!tx_queue->handle_tso);
> -		rc = tx_queue->handle_tso(tx_queue, skb, &data_mapped);
> +		switch (tx_queue->tso_version) {
> +		case 1:
> +			rc = efx_enqueue_skb_tso(tx_queue, skb, &data_mapped);
> +			break;
> +		case 2:
> +			rc = efx_ef10_tx_tso_desc(tx_queue, skb, &data_mapped);
> +			break;
> +		case 0: /* No TSO on this queue, SW fallback needed */
> +		default:
> +			rc = -EINVAL;
> +			break;
> +		}

Should tso_version 3 be handled in this switch?
