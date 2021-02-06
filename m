Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB72311FEB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 21:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBFU34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 15:29:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFU3x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 15:29:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36E4A64E30;
        Sat,  6 Feb 2021 20:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612643352;
        bh=kDLcY8sD0IsCZZz2x8JxOV0KRuv8s438+DsX30K6S+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WR/u8o/Aiv5OpLAgsnwv4zU80PNeewbrp2C/K3CRw5aIIxGUzOAMUeFDj9e+QRepB
         SXZ9/f3Fd5eh2t5V6NXrtMJLvrz04rmJqjJCJ0L9C4Mb04RP6KPhYSZyFjc8LoDgdG
         tD2EVyk+/HcJTVOQ7qdFeyxXnhy1yPjffZUI2H/fDOtD/awyzAiyQrcmuFFiYOBs5s
         9RaqpXSNGJZ55LBNKe4BSbpPhtz9JI5pa4FwUA/d4yhUOKmmeaQRV3zsbhejyPsuh/
         JiRENPrpQ33n1eO10Sh3uPWmAQm7Z+rls5Zd5gH2+7xgtPwWHQcw4yxYE/REiGV9E5
         Ae74lo5il9ZQQ==
Date:   Sat, 6 Feb 2021 12:29:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: Re: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Message-ID: <20210206122911.5037db4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210204112144.24163-4-qiangqing.zhang@nxp.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-4-qiangqing.zhang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Feb 2021 19:21:42 +0800 Joakim Zhang wrote:
> Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
> dma_alloc_coherent will return both the virtual address and physical
> address. AFAIK, virt_to_phys could not convert virtual address to
> physical address, for which memory is allocated by dma_alloc_coherent.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>

What does this patch fix? Theoretically incorrect value in a debug dump
or are you actually observing incorrect behavior?

> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> index c6540b003b43..6f951adc5f90 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> @@ -402,7 +402,8 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
>  	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
>  }
>  
> -static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
> +static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
> +				dma_addr_t dma_rx_phy, unsigned int desc_size)
>  {
>  	struct dma_desc *p = (struct dma_desc *)head;
>  	int i;
> @@ -410,8 +411,8 @@ static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
>  	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
>  
>  	for (i = 0; i < size; i++) {
> -		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
> -			i, (unsigned int)virt_to_phys(p),
> +		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
> +			i, (unsigned long long)(dma_rx_phy + i * desc_size),
>  			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
>  			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
>  		p++;

Why do you pass the desc_size in? The virt memory pointer is incremented
by sizeof(*p) surely

	dma_addr + i * sizeof(*p) 

would work correctly? Also please use the correct print format for
dma_addr_t, you shouldn't have to cast.
