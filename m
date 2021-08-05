Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF7A3E0D87
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 07:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhHEFJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 01:09:26 -0400
Received: from pegase2.c-s.fr ([93.17.235.10]:49181 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231326AbhHEFJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 01:09:24 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Aug 2021 01:09:23 EDT
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4GgGqT23Mzz9sX3;
        Thu,  5 Aug 2021 07:09:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eqCKhATqXA0K; Thu,  5 Aug 2021 07:09:09 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4GgGqT0krgz9sX2;
        Thu,  5 Aug 2021 07:09:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id EDFC58B7AE;
        Thu,  5 Aug 2021 07:09:08 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id nfvDJOUxX9Z9; Thu,  5 Aug 2021 07:09:08 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 7C9878B76A;
        Thu,  5 Aug 2021 07:09:08 +0200 (CEST)
Subject: Re: [PATCH v4 07/10] net/ps3_gelic: Add new routine gelic_unmap_link
To:     Geoff Levand <geoff@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
References: <cover.1627068552.git.geoff@infradead.org>
 <024b88e07095f00bc2eabfae2f526851600ee272.1627068552.git.geoff@infradead.org>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <1a8bc554-5230-769d-c007-7f620d286a84@csgroup.eu>
Date:   Thu, 5 Aug 2021 07:09:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <024b88e07095f00bc2eabfae2f526851600ee272.1627068552.git.geoff@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 23/07/2021 à 22:31, Geoff Levand a écrit :
> Put the common code for unmaping a link into its own routine,
> gelic_unmap_link, and add some debugging checks.
> 
> Signed-off-by: Geoff Levand <geoff@infradead.org>

CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis
#31: FILE: drivers/net/ethernet/toshiba/ps3_gelic_net.c:300:
+	dma_unmap_single(dev, descr->link.cpu_addr, descr->link.size,
+		DMA_BIDIRECTIONAL);


NOTE: For some of the reported defects, checkpatch may be able to
       mechanically convert to the typical style using --fix or --fix-inplace.

Commit bcb1cb297705 ("net/ps3_gelic: Add new routine gelic_unmap_link") has style problems, please 
review.

NOTE: Ignored message types: ARCH_INCLUDE_LINUX BIT_MACRO COMPARISON_TO_NULL DT_SPLIT_BINDING_PATCH 
EMAIL_SUBJECT FILE_PATH_CHANGES GLOBAL_INITIALISERS LINE_SPACING MULTIPLE_ASSIGNMENTS



> ---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c | 23 +++++++++++++++-----
>   1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 85fc1915c8be..e55aa9fecfeb 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -288,6 +288,21 @@ void gelic_card_down(struct gelic_card *card)
>   	mutex_unlock(&card->updown_lock);
>   }
>   
> +static void gelic_unmap_link(struct device *dev, struct gelic_descr *descr)
> +{
> +	BUG_ON_DEBUG(descr->hw_regs.payload.dev_addr);
> +	BUG_ON_DEBUG(descr->hw_regs.payload.size);
> +
> +	BUG_ON_DEBUG(!descr->link.cpu_addr);
> +	BUG_ON_DEBUG(!descr->link.size);
> +
> +	dma_unmap_single(dev, descr->link.cpu_addr, descr->link.size,
> +		DMA_BIDIRECTIONAL);
> +
> +	descr->link.cpu_addr = 0;
> +	descr->link.size = 0;
> +}
> +
>   /**
>    * gelic_card_free_chain - free descriptor chain
>    * @card: card structure
> @@ -301,9 +316,7 @@ static void gelic_card_free_chain(struct gelic_card *card,
>   
>   	for (descr = descr_in; descr && descr->link.cpu_addr;
>   		descr = descr->next) {
> -		dma_unmap_single(dev, descr->link.cpu_addr, descr->link.size,
> -			DMA_BIDIRECTIONAL);
> -		descr->link.cpu_addr = 0;
> +		gelic_unmap_link(dev, descr);
>   	}
>   }
>   
> @@ -364,9 +377,7 @@ static int gelic_card_init_chain(struct gelic_card *card,
>   iommu_error:
>   	for (i--, descr--; 0 <= i; i--, descr--)
>   		if (descr->link.cpu_addr)
> -			dma_unmap_single(dev, descr->link.cpu_addr,
> -					 descr->link.size,
> -					 DMA_BIDIRECTIONAL);
> +			gelic_unmap_link(dev, descr);
>   	return -ENOMEM;
>   }
>   
> 
