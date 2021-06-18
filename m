Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF0FC3AC900
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFRKnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:43:20 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57900 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbhFRKnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:43:19 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 15IAewBf062285;
        Fri, 18 Jun 2021 05:40:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1624012858;
        bh=1XYCKjsMbY4zECkUVkqkwMjGZnPM3/vX6YvoZjO6ubw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=eF8RxTBKkZWRnsBfiGem2qGuKE8h0HnRq+YXZnTWND9AhyVBRpBUBAc5V9+j78+6N
         /xke0Dn20xDA8cXr+LjziShEqfToePu++hCCTOsQdrjBoITG9NHXO/E1s3Cmy/oLPT
         PjEF1aBA3NXU4D/t8F6jpq8Q6qI78Lz6K9xux+sI=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 15IAewMC042210
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Jun 2021 05:40:58 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Fri, 18
 Jun 2021 05:40:57 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Fri, 18 Jun 2021 05:40:57 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 15IAest9010697;
        Fri, 18 Jun 2021 05:40:55 -0500
Subject: Re: [PATCH] net: ethernet: ti: fix netdev_queue compiling error
To:     Chen Jiahao <chenjiahao16@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <jesse.brandeburg@intel.com>, <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <heying24@huawei.com>
References: <20210617112838.143314-1-chenjiahao16@huawei.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6dbabec2-25df-7a4a-457f-d738479d36b1@ti.com>
Date:   Fri, 18 Jun 2021 13:40:50 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210617112838.143314-1-chenjiahao16@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/06/2021 14:28, Chen Jiahao wrote:
> There is a compiling error in am65-cpsw-nuss.c while not selecting
> CONFIG_BQL:
> 
> drivers/net/ethernet/ti/am65-cpsw-nuss.c: In function
> ‘am65_cpsw_nuss_ndo_host_tx_timeout’:
> drivers/net/ethernet/ti/am65-cpsw-nuss.c:353:26: error:
> ‘struct netdev_queue’ has no member named ‘dql’
>    353 |      dql_avail(&netif_txq->dql),
>        |                          ^~
> 
> This problem is solved by adding the #ifdef CONFIG_BQL directive
> where struct dql is used.
> 
> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
> Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
> ---
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index 6a67b026df0b..a0b30bb763ea 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -346,12 +346,20 @@ static void am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,
>   	tx_chn = &common->tx_chns[txqueue];
>   	trans_start = netif_txq->trans_start;
>   
> +#ifdef CONFIG_BQL
>   	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u dql_avail:%d free_desc:%zu\n",
>   		   txqueue,
>   		   netif_tx_queue_stopped(netif_txq),
>   		   jiffies_to_msecs(jiffies - trans_start),
>   		   dql_avail(&netif_txq->dql),
>   		   k3_cppi_desc_pool_avail(tx_chn->desc_pool));
> +#else
> +	netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u free_desc:%zu\n",
> +		   txqueue,
> +		   netif_tx_queue_stopped(netif_txq),
> +		   jiffies_to_msecs(jiffies - trans_start),
> +		   k3_cppi_desc_pool_avail(tx_chn->desc_pool));
> +#endif
>   
>   	if (netif_tx_queue_stopped(netif_txq)) {
>   		/* try recover if stopped by us */
> 

Seems like there is right helper available - qdisc_avail_bulklimit().

Any way, it most probably has to be solved in generic way on netdev/dql level.

-- 
Best regards,
grygorii
