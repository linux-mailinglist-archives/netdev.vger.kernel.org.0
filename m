Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57BAB266297
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgIKPyR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 11:54:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgIKPyA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 11:54:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6193A208E4;
        Fri, 11 Sep 2020 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599839640;
        bh=8OSd4E6z24e9edLGIs1zihX3IlpbXRmdW8xMzW+nbEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SSyNSTeqLyB4i+JZz5xQhRb8dQZrDmTExIj2JWUSv3+fmDn5Ou9f1FnTdkC2XuKke
         T5CPFKA2dmOshVsx3i6L4XffiaIKzy0j3Jx30y/ldZhCCkpqe6KWpv6KD3pImGZrRW
         QQg+UkV+JzsA0hOTs+q24Nb/ZTciZnalX0WrnYZQ=
Date:   Fri, 11 Sep 2020 08:53:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/7] sfc: decouple TXQ type from label
Message-ID: <20200911085358.5fdd3f23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6fc83ee8-6b6c-c2ea-ca81-659b6ef25569@solarflare.com>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
        <6fc83ee8-6b6c-c2ea-ca81-659b6ef25569@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 21:31:29 +0100 Edward Cree wrote:
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index 48d91b26f1a2..b0a08d9f4773 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -527,6 +527,12 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
>  	}
>  
>  	tx_queue = efx_get_tx_queue(efx, index, type);
> +	if (WARN_ON(!tx_queue))

_ONCE

> +		/* We don't have a TXQ of the right type.
> +		 * This should never happen, as we don't advertise offload
> +		 * features unless we can support them.
> +		 */
> +		return NETDEV_TX_BUSY;

You should probably drop this packet, right? Next time qdisc calls the
driver it's unlikely to find a queue it needs.

>  	return __efx_enqueue_skb(tx_queue, skb);
>  }

