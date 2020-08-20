Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B8824C05B
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 16:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgHTOPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 10:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbgHTOOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 10:14:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05F0C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 07:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=mQK0PV8q5idV0XX6fhY4VWi9DyG5jwAl2RUTsutORcc=; b=KbcFAF0QL3PvP6Oyr8iCvb7v11
        GLNMoktjbFfUgETNhA979N9w4TgZwiyuJGdvNC+btrKkrOTcY98WEnzgWqC9U4sOcOLlQECga7fQs
        mYnqQSQ3RoQinH0X0OiPoo4A7dwlfkLX9HMVxVNOoGBiz/GMl4iBKk4kbWHS7sK5WN976Ly47KSjF
        iKUOUV7Fd9RAvT2UsAxT8g6F2nKfE3IGLItqlYlRzeuYldDj+opkE8B33/8LVV+ccFFvcywA+AV58
        bf2qqRmYt10AM68rm+06CVPjyRRX/6RXjhEXFbzlrpiRPR9Z6KlGJLEFsq6ZlNB6EJjIumczKaOBF
        YHtlWdcA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8lL2-0000nl-Mi; Thu, 20 Aug 2020 14:14:48 +0000
Subject: Re: [PATCH net] sfc: fix build warnings on 32-bit
To:     Edward Cree <ecree@solarflare.com>,
        linux-net-drivers@solarflare.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <187ef73f-09ed-8c45-540f-85fb1714e887@solarflare.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4ed50317-2334-0bea-33ce-836d61d14715@infradead.org>
Date:   Thu, 20 Aug 2020 07:14:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <187ef73f-09ed-8c45-540f-85fb1714e887@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20 3:47 AM, Edward Cree wrote:
> Truncation of DMA_BIT_MASK to 32-bit dma_addr_t is semantically safe,
>  but the compiler was warning because it was happening implicitly.
> Insert explicit casts to suppress the warnings.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Edward Cree <ecree@solarflare.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/ethernet/sfc/ef100.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef100.c b/drivers/net/ethernet/sfc/ef100.c
> index 9729983f4840..c54b7f8243f3 100644
> --- a/drivers/net/ethernet/sfc/ef100.c
> +++ b/drivers/net/ethernet/sfc/ef100.c
> @@ -142,7 +142,7 @@ static int ef100_pci_parse_continue_entry(struct efx_nic *efx, int entry_locatio
>  
>  		/* Temporarily map new BAR. */
>  		rc = efx_init_io(efx, bar,
> -				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
> +				 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>  				 pci_resource_len(efx->pci_dev, bar));
>  		if (rc) {
>  			netif_err(efx, probe, efx->net_dev,
> @@ -160,7 +160,7 @@ static int ef100_pci_parse_continue_entry(struct efx_nic *efx, int entry_locatio
>  
>  		/* Put old BAR back. */
>  		rc = efx_init_io(efx, previous_bar,
> -				 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
> +				 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>  				 pci_resource_len(efx->pci_dev, previous_bar));
>  		if (rc) {
>  			netif_err(efx, probe, efx->net_dev,
> @@ -334,7 +334,7 @@ static int ef100_pci_parse_xilinx_cap(struct efx_nic *efx, int vndr_cap,
>  
>  	/* Temporarily map BAR. */
>  	rc = efx_init_io(efx, bar,
> -			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
> +			 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>  			 pci_resource_len(efx->pci_dev, bar));
>  	if (rc) {
>  		netif_err(efx, probe, efx->net_dev,
> @@ -495,7 +495,7 @@ static int ef100_pci_probe(struct pci_dev *pci_dev,
>  
>  	/* Set up basic I/O (BAR mappings etc) */
>  	rc = efx_init_io(efx, fcw.bar,
> -			 DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
> +			 (dma_addr_t)DMA_BIT_MASK(ESF_GZ_TX_SEND_ADDR_WIDTH),
>  			 pci_resource_len(efx->pci_dev, fcw.bar));
>  	if (rc)
>  		goto fail;
> 


-- 
~Randy

