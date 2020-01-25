Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC5714928D
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 02:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgAYBff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 20:35:35 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34049 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729195AbgAYBfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 20:35:34 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so2034291pgf.1;
        Fri, 24 Jan 2020 17:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6d0QvcR0leGd4wcUqGcNGh1VcTAtJHNYWWsnf4qfAso=;
        b=Yhjgbw2e8a5r0TlVh8TKKQ/fbUrWMak2zONW5BxfIcHr/m9egxKNe+wpNLsTgBzawK
         Ls6zqD/SKUju2TNKCfqYi6uIQa44C28DgnWI4W3RM6ZOZgEZSbqQNgFoeJnB9+sL5HG2
         Vq0wr8xv+dEaUF3HthYIuk17VuEuqVRw3uD8PtygN1rPSgA3+wYlktowZ3bsdpOt4mZo
         oDi+3LaUrhr98XaY4mF0mldLlFUFVT6I/kUmDuQfWRvKYFDzpLk79AhXpEDZ2MEUF8zL
         fq7NOVmatfmgT1LN9iz1CmSjiNlrEQhTy0X7jHS5sT69z8G70KtWz3ahbWspp5xbn6+g
         5++g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6d0QvcR0leGd4wcUqGcNGh1VcTAtJHNYWWsnf4qfAso=;
        b=VGeYxlZDD38aFEhW7NZYUeyqeMqGHfLkTUnmvPnfURqJlNmnN5yLLwSWRj4EfGtwNK
         9s2RHs/QUbZsS4/4S7XEPaduwlZl7SNrgWfjqEIpb3o3VPlZdLaynZagA1rF5h2GAAnC
         8L99SrK4YmRUpvoWlEV+gdVo3zG7Brcc5cB39PvgE7qeW2MclL6PxcS/1EM+Yjblfial
         jfUBvRynJ30rC/8f+VvxuXy0mOUy8HzW5YGFCq1TkCZjIQMxM5ouLMZT6IFCJzX0Ygyi
         CPY/chUcYGvWXdEGJBoDbo9qh/71i2iiba8A7bo/PsMdc64Y2Hm4QlsRaooShfoyZi9n
         omlQ==
X-Gm-Message-State: APjAAAVIOHoblRXSnogJVptTmevVk9sX+Im/U4P2aE4Ls6hhAKcTvRBn
        XUa/AZZpBZ3tmccf4Yz9+Senfjfj
X-Google-Smtp-Source: APXvYqxX7byGtZh2yK4qEWdK9zICH5Thh4YyWT/9fRYA8ci8Lo1/l/L7s3BCI8Eaul0rTai7ZEbZfQ==
X-Received: by 2002:a62:1548:: with SMTP id 69mr6058157pfv.239.1579916133829;
        Fri, 24 Jan 2020 17:35:33 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b4sm7630036pfd.18.2020.01.24.17.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 17:35:33 -0800 (PST)
Subject: Re: [PATCH net-next] net: systemport: Do not block interrupts in TX
 reclaim
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     kuba@kernel.org, edumazet@google.com,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM SYSTEMPORT ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20200124235930.640-1-f.fainelli@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <de50408a-37db-e55e-57af-54574c7b5e42@gmail.com>
Date:   Fri, 24 Jan 2020 17:35:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200124235930.640-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/20 3:59 PM, Florian Fainelli wrote:
> There is no need to disable interrupts with a spin_lock_irqsave() in
> bcm_sysport_tx_poll() since we are in softIRQ context already. Leave
> interrupts enabled, thus giving a chance for the RX interrupts to be
> processed.
> 
> This now makes bcm_sysport_tx_reclaim() equivalent to
> bcm_sysport_tx_clean(), thus remove the former, and make
> bcm_sysport_tx_reclaim_all() to use the latter.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bcmsysport.c | 30 ++++++----------------
>  1 file changed, 8 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
> index f07ac0e0af59..dfff0657ce8f 100644
> --- a/drivers/net/ethernet/broadcom/bcmsysport.c
> +++ b/drivers/net/ethernet/broadcom/bcmsysport.c
> @@ -925,26 +925,6 @@ static unsigned int __bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
>  	return pkts_compl;
>  }
>  
> -/* Locked version of the per-ring TX reclaim routine */
> -static unsigned int bcm_sysport_tx_reclaim(struct bcm_sysport_priv *priv,
> -					   struct bcm_sysport_tx_ring *ring)
> -{
> -	struct netdev_queue *txq;
> -	unsigned int released;
> -	unsigned long flags;
> -
> -	txq = netdev_get_tx_queue(priv->netdev, ring->index);
> -
> -	spin_lock_irqsave(&ring->lock, flags);
> -	released = __bcm_sysport_tx_reclaim(priv, ring);
> -	if (released)
> -		netif_tx_wake_queue(txq);
> -
> -	spin_unlock_irqrestore(&ring->lock, flags);
> -
> -	return released;
> -}
> -
>  /* Locked version of the per-ring TX reclaim, but does not wake the queue */
>  static void bcm_sysport_tx_clean(struct bcm_sysport_priv *priv,
>  				 struct bcm_sysport_tx_ring *ring)
> @@ -960,9 +940,15 @@ static int bcm_sysport_tx_poll(struct napi_struct *napi, int budget)
>  {
>  	struct bcm_sysport_tx_ring *ring =
>  		container_of(napi, struct bcm_sysport_tx_ring, napi);
> +	struct bcm_sysport_priv *priv = ring->priv;
>  	unsigned int work_done = 0;
>  
> -	work_done = bcm_sysport_tx_reclaim(ring->priv, ring);
> +	spin_lock(&ring->lock);
> +	work_done = __bcm_sysport_tx_reclaim(priv, ring);
> +	if (work_done)
> +		netif_tx_wake_queue(netdev_get_tx_queue(priv->netdev,
> +							ring->index));
> +	spin_unlock(&ring->lock);
>  
>  	if (work_done == 0) {
>  		napi_complete(napi);
> @@ -984,7 +970,7 @@ static void bcm_sysport_tx_reclaim_all(struct bcm_sysport_priv *priv)
>  	unsigned int q;
>  
>  	for (q = 0; q < priv->netdev->num_tx_queues; q++)
> -		bcm_sysport_tx_reclaim(priv, &priv->tx_rings[q]);
> +		bcm_sysport_tx_clean(priv, &priv->tx_rings[q]);
>  }
>  
>  static int bcm_sysport_poll(struct napi_struct *napi, int budget)
> 

I am a bit confused by this patch, the changelog mixes hard and soft irqs.

This driver seems to call bcm_sysport_tx_reclaim_all() from hard irq handler 
(INTRL2_0_TX_RING_FULL condition)

So it looks you need to acquire ring->lock with some _irqsave() variant when
bcm_sysport_tx_poll() is running (from BH context)

