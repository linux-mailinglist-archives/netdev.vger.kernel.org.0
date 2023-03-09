Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ACC56B1B62
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 07:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCIGY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 01:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbjCIGYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 01:24:13 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4167B498;
        Wed,  8 Mar 2023 22:23:54 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PXJvy5cGvzSkdJ;
        Thu,  9 Mar 2023 14:20:46 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 9 Mar
 2023 14:23:52 +0800
Subject: Re: [PATCH] net: calxeda: fix race condition in xgmac_remove due to
 unfinshed work
To:     Zheng Wang <zyytlz.wz@163.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <hackerzheng666@gmail.com>,
        <1395428693sheep@gmail.com>, <alex000young@gmail.com>
References: <20230309035641.3439953-1-zyytlz.wz@163.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ec579c96-9955-f317-b37a-4f3fcd0c206e@huawei.com>
Date:   Thu, 9 Mar 2023 14:23:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230309035641.3439953-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/9 11:56, Zheng Wang wrote:
> In xgmac_probe, the priv->tx_timeout_work is bound with 
> xgmac_tx_timeout_work. In xgmac_remove, if there is an 
> unfinished work, there might be a race condition that 
> priv->base was written byte after iounmap it.
> 
> Fix it by finishing the work before cleanup.

This should go to net branch, so title should be:

 [PATCH net] net: calxeda: fix race condition in xgmac_remove due to unfinshed work

From history commit, it seems more common to use "net: calxedaxgmac" instead of
"net: calxeda", I am not sure which one is better.

Also there should be a Fixes tag for net branch, maybe:

Fixes: 8746f671ef04 ("net: calxedaxgmac: fix race between xgmac_tx_complete and xgmac_tx_err")


> 
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/net/ethernet/calxeda/xgmac.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
> index f4f87dfa9687..94c3804001e3 100644
> --- a/drivers/net/ethernet/calxeda/xgmac.c
> +++ b/drivers/net/ethernet/calxeda/xgmac.c
> @@ -1831,6 +1831,7 @@ static int xgmac_remove(struct platform_device *pdev)
>  	/* Free the IRQ lines */
>  	free_irq(ndev->irq, ndev);
>  	free_irq(priv->pmt_irq, ndev);
> +	cancel_work_sync(&priv->tx_timeout_work);

It seems the blow function need to stop the dev_watchdog() from
calling dev->netdev_ops->ndo_tx_timeout before calling
cancel_work_sync(&priv->tx_timeout_work), otherwise the
dev_watchdog() may trigger the priv->tx_timeout_work to run again.

	netif_carrier_off(ndev);
	netif_tx_disable(ndev);

>  
>  	unregister_netdev(ndev);
>  	netif_napi_del(&priv->napi);
> 
