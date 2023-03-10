Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D106B3387
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 02:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjCJBMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 20:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCJBMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 20:12:43 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213D57FD6B;
        Thu,  9 Mar 2023 17:12:42 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PXp1n1jCBzKmRs;
        Fri, 10 Mar 2023 09:12:29 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 10 Mar
 2023 09:12:38 +0800
Subject: Re: [PATCH net] net: ravb: Fix possible UAF bug in ravb_remove
To:     Zheng Wang <zyytlz.wz@163.com>, <s.shtylyov@omp.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hackerzheng666@gmail.com>,
        <1395428693sheep@gmail.com>, <alex000young@gmail.com>
References: <20230309100248.3831498-1-zyytlz.wz@163.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cca0b40b-d6f8-54c7-1e46-83cb62d0a2f1@huawei.com>
Date:   Fri, 10 Mar 2023 09:12:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230309100248.3831498-1-zyytlz.wz@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

On 2023/3/9 18:02, Zheng Wang wrote:
> In ravb_probe, priv->work was bound with ravb_tx_timeout_work.
> If timeout occurs, it will start the work. And if we call
> ravb_remove without finishing the work, ther may be a use

ther -> there

> after free bug on ndev.
> 
> Fix it by finishing the job before cleanup in ravb_remove.
> 
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index 0f54849a3823..07a08e72f440 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2892,6 +2892,7 @@ static int ravb_remove(struct platform_device *pdev)
>  	struct ravb_private *priv = netdev_priv(ndev);
>  	const struct ravb_hw_info *info = priv->info;
>  
> +	cancel_work_sync(&priv->work);

As your previous patch, I still do not see anything stopping
dev_watchdog() from calling dev->netdev_ops->ndo_tx_timeout
after cancel_work_sync(), maybe I missed something obvious
here?


>  	/* Stop PTP Clock driver */
>  	if (info->ccc_gac)
>  		ravb_ptp_stop(ndev);
> 
