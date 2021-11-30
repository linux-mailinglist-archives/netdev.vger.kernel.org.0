Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4DF463A2C
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbhK3Piy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhK3Piy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:38:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA7FC061574;
        Tue, 30 Nov 2021 07:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=IXNJEoicpzVF92kWs6ympCkqrZMDjVLQCkzwl3JDIg4=; b=P3tAmxuXqjs3+tf2sGl5YnuvFh
        ACoxtkfalxIvQJ+Rve9e8cfYIDK8clvxRVqkmbf/r6qsMOT+JPTAQTy+Exq6hr7xyHGHZDR58YRQD
        3dYMZ3XI6+fMXu+Eak4ZiB7w0/Cl39ixd10KASQOJmActsTxEZDP00imjskBRO58KC4nKNqvCjOvo
        FRZl0PA7BWQdTmyp1sME+YNyzj9p809XWuOSA/jQeTF69ahqkus2lJ64P3X/llr24BeEcBMIpQrcB
        kVRoygHv+X5lTXhbWMmk4cdQGZvPCGTymoro9qYVlwUHdAhBlcgPzz0byauOiN8faNuQ1dmDDXo4Q
        e+np7jGA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ms5AI-00CpTO-Nv; Tue, 30 Nov 2021 15:35:31 +0000
Message-ID: <7dda4e61-6194-ff6b-7174-747f840d748a@infradead.org>
Date:   Tue, 30 Nov 2021 07:35:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] net: natsemi: fix hw address initialization for jazz and
 xtensa
Content-Language: en-US
To:     Max Filippov <jcmvbkbc@gmail.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211130143600.31970-1-jcmvbkbc@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20211130143600.31970-1-jcmvbkbc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max,

On 11/30/21 06:36, Max Filippov wrote:
> Use eth_hw_addr_set function instead of writing the address directly to
> net_device::dev_addr.
> 
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
Looks good. Thanks.

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

> ---
>  drivers/net/ethernet/natsemi/jazzsonic.c | 6 ++++--
>  drivers/net/ethernet/natsemi/xtsonic.c   | 6 ++++--
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
> index d74a80f010c5..3f371faeb6d0 100644
> --- a/drivers/net/ethernet/natsemi/jazzsonic.c
> +++ b/drivers/net/ethernet/natsemi/jazzsonic.c
> @@ -114,6 +114,7 @@ static int sonic_probe1(struct net_device *dev)
>  	struct sonic_local *lp = netdev_priv(dev);
>  	int err = -ENODEV;
>  	int i;
> +	unsigned char addr[ETH_ALEN];
>  
>  	if (!request_mem_region(dev->base_addr, SONIC_MEM_SIZE, jazz_sonic_string))
>  		return -EBUSY;
> @@ -143,9 +144,10 @@ static int sonic_probe1(struct net_device *dev)
>  	SONIC_WRITE(SONIC_CEP,0);
>  	for (i=0; i<3; i++) {
>  		val = SONIC_READ(SONIC_CAP0-i);
> -		dev->dev_addr[i*2] = val;
> -		dev->dev_addr[i*2+1] = val >> 8;
> +		addr[i*2] = val;
> +		addr[i*2+1] = val >> 8;
>  	}
> +	eth_hw_addr_set(dev, addr);
>  
>  	lp->dma_bitmode = SONIC_BITMODE32;
>  
> diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
> index ca4686094701..7d51bcb1b918 100644
> --- a/drivers/net/ethernet/natsemi/xtsonic.c
> +++ b/drivers/net/ethernet/natsemi/xtsonic.c
> @@ -127,6 +127,7 @@ static int __init sonic_probe1(struct net_device *dev)
>  	unsigned int base_addr = dev->base_addr;
>  	int i;
>  	int err = 0;
> +	unsigned char addr[ETH_ALEN];
>  
>  	if (!request_mem_region(base_addr, 0x100, xtsonic_string))
>  		return -EBUSY;
> @@ -163,9 +164,10 @@ static int __init sonic_probe1(struct net_device *dev)
>  
>  	for (i=0; i<3; i++) {
>  		unsigned int val = SONIC_READ(SONIC_CAP0-i);
> -		dev->dev_addr[i*2] = val;
> -		dev->dev_addr[i*2+1] = val >> 8;
> +		addr[i*2] = val;
> +		addr[i*2+1] = val >> 8;
>  	}
> +	eth_hw_addr_set(dev, addr);
>  
>  	lp->dma_bitmode = SONIC_BITMODE32;
>  
> 

-- 
~Randy
