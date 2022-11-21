Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA06631815
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 02:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiKUBFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 20:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiKUBFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 20:05:45 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650C81C922
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 17:05:44 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NFpyW1yN7zFqSH;
        Mon, 21 Nov 2022 09:02:27 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:05:40 +0800
Message-ID: <081368e4-2608-1023-0e30-3ce9c59e1b1e@huawei.com>
Date:   Mon, 21 Nov 2022 09:05:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] net: ll_temac: stop phy when request_irq() failed in
 temac_open()
To:     <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <michal.simek@xilinx.com>, <harini.katakam@amd.com>,
        <xuhaoyue1@hisilicon.com>, <huangjunxian6@hisilicon.com>,
        <wangqing@vivo.com>, <chenhao288@hisilicon.com>,
        <yangyingliang@huawei.com>, <trix@redhat.com>,
        <afleming@freescale.com>, <grant.likely@secretlab.ca>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221121010658.106749-1-shaozhengchao@huawei.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <20221121010658.106749-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry to interrupt, please ignore this patch.

On 2022/11/21 9:06, Zhengchao Shao wrote:
> When request_irq() failed in temac_open(), phy is not stopped. Compiled
> test only.
> 
> Fixes: 92744989533c ("net: add Xilinx ll_temac device driver")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>   drivers/net/ethernet/xilinx/ll_temac_main.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
> index 1066420d6a83..2b61fa2c04a2 100644
> --- a/drivers/net/ethernet/xilinx/ll_temac_main.c
> +++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
> @@ -1193,8 +1193,10 @@ static int temac_open(struct net_device *ndev)
>    err_rx_irq:
>   	free_irq(lp->tx_irq, ndev);
>    err_tx_irq:
> -	if (phydev)
> +	if (phydev) {
> +		phy_stop(phydev);
>   		phy_disconnect(phydev);
> +	}
>   	dev_err(lp->dev, "request_irq() failed\n");
>   	return rc;
>   }
> @@ -1211,8 +1213,10 @@ static int temac_stop(struct net_device *ndev)
>   	free_irq(lp->tx_irq, ndev);
>   	free_irq(lp->rx_irq, ndev);
>   
> -	if (phydev)
> +	if (phydev) {
> +		phy_stop(phydev);
>   		phy_disconnect(phydev);
> +	}
>   
>   	temac_dma_bd_release(ndev);
>   
