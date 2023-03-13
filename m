Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F0A6B6D09
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 02:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCMBWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 21:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCMBWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 21:22:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719636085;
        Sun, 12 Mar 2023 18:22:32 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PZf2Z432vz17KSQ;
        Mon, 13 Mar 2023 09:19:34 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Mon, 13 Mar
 2023 09:22:07 +0800
Subject: Re: [PATCH net v2] net: calxedaxgmac: fix race condition in
 xgmac_remove due to unfinished work
To:     Zheng Wang <zyytlz.wz@163.com>, <davem@davemloft.net>
CC:     <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <mkl@pengutronix.de>, <j.neuschaefer@gmx.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hackerzheng666@gmail.com>, <1395428693sheep@gmail.com>,
        <alex000young@gmail.com>
References: <20230311180404.4007176-1-zyytlz.wz@163.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6f0dc4f0-8a1a-9512-01f8-71b0ce6024ea@huawei.com>
Date:   Mon, 13 Mar 2023 09:22:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230311180404.4007176-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/12 2:04, Zheng Wang wrote:
> In xgmac_probe, the priv->tx_timeout_work is bound with
> xgmac_tx_timeout_work. In xgmac_remove, if there is an
> unfinished work, there might be a race condition that
> priv->base was written byte after iounmap it.
> 
> Fix it by finishing the work before cleanup.
> 
> Fixes: 8746f671ef04 ("net: calxedaxgmac: fix race between xgmac_tx_complete and xgmac_tx_err")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>


LGTM.
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>

> ---
> v2:
> - fix typo,add Fixes label and stop dev_watchdog so that it will handle no more timeout work suggested by Yunsheng Lin
> ---
>  drivers/net/ethernet/calxeda/xgmac.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
> index f4f87dfa9687..f0880538f6f3 100644
> --- a/drivers/net/ethernet/calxeda/xgmac.c
> +++ b/drivers/net/ethernet/calxeda/xgmac.c
> @@ -1832,6 +1832,10 @@ static int xgmac_remove(struct platform_device *pdev)
>  	free_irq(ndev->irq, ndev);
>  	free_irq(priv->pmt_irq, ndev);
>  
> +	netif_carrier_off(ndev);
> +	netif_tx_disable(ndev);
> +	cancel_work_sync(&priv->tx_timeout_work);
> +
>  	unregister_netdev(ndev);
>  	netif_napi_del(&priv->napi);
>  
> 
