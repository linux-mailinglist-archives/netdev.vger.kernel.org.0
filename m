Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F41E3AE4A5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 10:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFUIVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 04:21:19 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5058 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhFUIVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 04:21:15 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G7j3M1VvFzXjHK;
        Mon, 21 Jun 2021 16:13:51 +0800 (CST)
Received: from dggpemm500016.china.huawei.com (7.185.36.25) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 16:18:53 +0800
Received: from [10.67.108.248] (10.67.108.248) by
 dggpemm500016.china.huawei.com (7.185.36.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 21 Jun 2021 16:18:53 +0800
Subject: Re: [PATCH] net: ethernet: ti: fix netdev_queue compiling error
To:     Grygorii Strashko <grygorii.strashko@ti.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <jesse.brandeburg@intel.com>, <vigneshr@ti.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <heying24@huawei.com>
References: <20210617112838.143314-1-chenjiahao16@huawei.com>
 <6dbabec2-25df-7a4a-457f-d738479d36b1@ti.com>
From:   "chenjiahao (C)" <chenjiahao16@huawei.com>
Message-ID: <e04de1c9-2852-674b-be24-158fcd1e5919@huawei.com>
Date:   Mon, 21 Jun 2021 16:18:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <6dbabec2-25df-7a4a-457f-d738479d36b1@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.108.248]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for the review. But still I have a little question in the helper
you just mentioned:

static inline int qdisc_avail_bulklimit(const struct netdev_queue *txq)
{
#ifdef CONFIG_BQL
	/* Non-BQL migrated drivers will return 0, too. */
	return dql_avail(&txq->dql);
#else
	return 0;
#endif
}

In the snippet above, if CONFIG_BQL is not set, 0 will be simply 
returned and get printed. Should we distinguish this case, or just let 
it be?

Sincerely,
Jiahao Chen

在 2021/6/18 18:40, Grygorii Strashko 写道:
> 
> 
> On 17/06/2021 14:28, Chen Jiahao wrote:
>> There is a compiling error in am65-cpsw-nuss.c while not selecting
>> CONFIG_BQL:
>>
>> drivers/net/ethernet/ti/am65-cpsw-nuss.c: In function
>> ‘am65_cpsw_nuss_ndo_host_tx_timeout’:
>> drivers/net/ethernet/ti/am65-cpsw-nuss.c:353:26: error:
>> ‘struct netdev_queue’ has no member named ‘dql’
>>    353 |      dql_avail(&netif_txq->dql),
>>        |                          ^~
>>
>> This problem is solved by adding the #ifdef CONFIG_BQL directive
>> where struct dql is used.
>>
>> Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit 
>> eth subsystem driver")
>> Signed-off-by: Chen Jiahao <chenjiahao16@huawei.com>
>> ---
>>   drivers/net/ethernet/ti/am65-cpsw-nuss.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c 
>> b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> index 6a67b026df0b..a0b30bb763ea 100644
>> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
>> @@ -346,12 +346,20 @@ static void 
>> am65_cpsw_nuss_ndo_host_tx_timeout(struct net_device *ndev,
>>       tx_chn = &common->tx_chns[txqueue];
>>       trans_start = netif_txq->trans_start;
>> +#ifdef CONFIG_BQL
>>       netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u dql_avail:%d 
>> free_desc:%zu\n",
>>              txqueue,
>>              netif_tx_queue_stopped(netif_txq),
>>              jiffies_to_msecs(jiffies - trans_start),
>>              dql_avail(&netif_txq->dql),
>>              k3_cppi_desc_pool_avail(tx_chn->desc_pool));
>> +#else
>> +    netdev_err(ndev, "txq:%d DRV_XOFF:%d tmo:%u free_desc:%zu\n",
>> +           txqueue,
>> +           netif_tx_queue_stopped(netif_txq),
>> +           jiffies_to_msecs(jiffies - trans_start),
>> +           k3_cppi_desc_pool_avail(tx_chn->desc_pool));
>> +#endif
>>       if (netif_tx_queue_stopped(netif_txq)) {
>>           /* try recover if stopped by us */
>>
> 
> Seems like there is right helper available - qdisc_avail_bulklimit().
> 
> Any way, it most probably has to be solved in generic way on netdev/dql 
> level.
> 



