Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3A0633397
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiKVCzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiKVCzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:55:47 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F7178B2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:55:46 -0800 (PST)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NGTM12QSRzJnhG;
        Tue, 22 Nov 2022 10:52:29 +0800 (CST)
Received: from [10.67.110.176] (10.67.110.176) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 10:55:43 +0800
Subject: Re: [PATCH net] intel/igbvf: free irq on the error path in
 igbvf_request_msix()
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221120061757.264242-1-cuigaosheng1@huawei.com>
 <Y3u95fVsT/7zXQQp@boxer>
From:   cuigaosheng <cuigaosheng1@huawei.com>
Message-ID: <322f3167-d5e4-502a-ccb0-1f79ae254d3e@huawei.com>
Date:   Tue, 22 Nov 2022 10:55:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <Y3u95fVsT/7zXQQp@boxer>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.176]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> s/free_irq1/free_irq_tx ?
>
>>   
>>   	adapter->rx_ring->itr_register = E1000_EITR(vector);
>>   	adapter->rx_ring->itr_val = adapter->current_itr;
>> @@ -1083,10 +1083,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
>>   	err = request_irq(adapter->msix_entries[vector].vector,
>>   			  igbvf_msix_other, 0, netdev->name, netdev);
>>   	if (err)
>> -		goto out;
>> +		goto free_irq2;
> s/free_irq2/free_irq_rx ?
>

Thanks for taking time to review this patch, I have made a patch v2 and submit it.

link: https://patchwork.kernel.org/project/netdevbpf/patch/20221122022852.1384927-1-cuigaosheng1@huawei.com/


On 2022/11/22 2:05, Maciej Fijalkowski wrote:
> On Sun, Nov 20, 2022 at 07:17:57AM +0100, Gaosheng Cui wrote:
>> In igbvf_request_msix(), irqs have not been freed on the err path,
>> we need to free it. Fix it.
>>
>> Fixes: d4e0fe01a38a ("igbvf: add new driver to support 82576 virtual functions")
>> Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
> Hi,
>
>> ---
>>   drivers/net/ethernet/intel/igbvf/netdev.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
>> index 3a32809510fc..e212ca16df00 100644
>> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
>> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c
>> @@ -1074,7 +1074,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
>>   			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
>>   			  netdev);
>>   	if (err)
>> -		goto out;
>> +		goto free_irq1;
> s/free_irq1/free_irq_tx ?
>
>>   
>>   	adapter->rx_ring->itr_register = E1000_EITR(vector);
>>   	adapter->rx_ring->itr_val = adapter->current_itr;
>> @@ -1083,10 +1083,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
>>   	err = request_irq(adapter->msix_entries[vector].vector,
>>   			  igbvf_msix_other, 0, netdev->name, netdev);
>>   	if (err)
>> -		goto out;
>> +		goto free_irq2;
> s/free_irq2/free_irq_rx ?
>
>>   
>>   	igbvf_configure_msix(adapter);
>>   	return 0;
>> +free_irq2:
>> +	free_irq(adapter->msix_entries[--vector].vector, netdev);
>> +free_irq1:
>> +	free_irq(adapter->msix_entries[--vector].vector, netdev);
>>   out:
>>   	return err;
> Besides above suggestions, change LGTM.
>
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>
>>   }
>> -- 
>> 2.25.1
>>
> .
