Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6066721E2C6
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgGMWD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:03:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgGMWDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:03:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC60920890;
        Mon, 13 Jul 2020 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594677805;
        bh=N/YyzRx6PFN4ZtWqPXnSIwKQIR1UnjhVILtxnxuJVPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=flwUTacRh8OWdCsGUr0xCeSVjj8E9DjgS3CXuHsxxqsJ/Tr8onM85jLCea47RZLhz
         x+dLJa6hPdUO5cwWXrpHXSakXvxSuvohwM4zU940G8Vq6pUn5n6o6ZvUrqdI7cBW8u
         d1uRmFu2/Y4Yau+CsKN7GWR81uW4XALKfTeOOhBQ=
Date:   Mon, 13 Jul 2020 15:03:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH net-next 03/10] net: atlantic: additional per-queue
 stats
Message-ID: <20200713150323.2a924a86@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713114233.436-4-irusskikh@marvell.com>
References: <20200713114233.436-1-irusskikh@marvell.com>
        <20200713114233.436-4-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Jul 2020 14:42:26 +0300 Igor Russkikh wrote:
> From: Dmitry Bogdanov <dbogdanov@marvell.com>
> 
> This patch adds additional per-queue stats, these could
> be useful for debugging and diagnostics.
> 
> Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
> Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> index 2c96f20f6289..c31d4642d280 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
> @@ -1,7 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
> -/*
> - * aQuantia Corporation Network Driver
> - * Copyright (C) 2014-2019 aQuantia Corporation. All rights reserved
> +/* Atlantic Network Driver
> + *
> + * Copyright (C) 2014-2019 aQuantia Corporation
> + * Copyright (C) 2019-2020 Marvell International Ltd.
>   */
>  
>  /* File aq_ring.h: Declaration of functions for Rx/Tx rings. */
> @@ -93,6 +94,10 @@ struct aq_ring_stats_rx_s {
>  	u64 bytes;
>  	u64 lro_packets;
>  	u64 jumbo_packets;
> +	u64 alloc_fails;
> +	u64 skb_alloc_fails;
> +	u64 polls;
> +	u64 irqs;
>  	u64 pg_losts;
>  	u64 pg_flips;
>  	u64 pg_reuses;

> @@ -44,6 +45,7 @@ static int aq_vec_poll(struct napi_struct *napi, int budget)
>  	} else {
>  		for (i = 0U, ring = self->ring[0];
>  			self->tx_rings > i; ++i, ring = self->ring[i]) {
> +			ring[AQ_VEC_RX_ID].stats.rx.polls++;

You need to use the u64_stats_update_* infrastructure or make these
stats smaller than u64, cause on non-64bit machines where the stats
will be updated 32bit-by-32bit meaning readers can see a half-updated
counter..

>  			if (self->aq_hw_ops->hw_ring_tx_head_update) {
>  				err = self->aq_hw_ops->hw_ring_tx_head_update(
>  							self->aq_hw,
> @@ -314,6 +316,7 @@ irqreturn_t aq_vec_isr(int irq, void *private)
>  		err = -EINVAL;
>  		goto err_exit;
>  	}
> +	self->ring[0][AQ_VEC_RX_ID].stats.rx.irqs++;

Why do you need this? Every IRQ has a firing counter in
/proc/interrupts.

>  	napi_schedule(&self->napi);
>  
>  err_exit:
