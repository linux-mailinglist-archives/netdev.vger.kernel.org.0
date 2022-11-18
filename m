Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F52662F411
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241358AbiKRLyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKRLyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:54:09 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16A7922F4;
        Fri, 18 Nov 2022 03:54:08 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NDFV76ZPVzFqLR;
        Fri, 18 Nov 2022 19:50:55 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 19:54:06 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 19:54:01 +0800
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
To:     Leon Romanovsky <leon@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YctdnKDDvikQcl@unreal> <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
 <Y3YxlxPIiw43QiKE@unreal> <Y3dNP6iEj2YyEwqJ@gmail.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <7620babe-4b73-0c58-9c6c-4ac3ec01f9a0@huawei.com>
Date:   Fri, 18 Nov 2022 19:53:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <Y3dNP6iEj2YyEwqJ@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500006.china.huawei.com (7.185.36.76)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/18 17:15, Martin Habets wrote:
> On Thu, Nov 17, 2022 at 03:05:27PM +0200, Leon Romanovsky wrote:
>> On Thu, Nov 17, 2022 at 08:41:52PM +0800, Zhang Changzhong wrote:
>>>
>>>
>>> On 2022/11/17 19:36, Leon Romanovsky wrote:
>>>> On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
>>>>> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
>>>>> in error handling case, add dev_kfree_skb_any() to fix it.
>>>>>
>>>>> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
>>>>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>>>>> ---
>>>>>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
>>>>>  1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
>>>>> index 88fa295..ddcc325 100644
>>>>> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
>>>>> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
>>>>> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
>>>>>  		   skb->len, skb->data_len, channel->channel);
>>>>>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
>>>>>  		netif_stop_queue(net_dev);
>>>>> +		dev_kfree_skb_any(skb);
>>>>>  		goto err;
>>>>>  	}
>>>>
>>>> ef100 doesn't release in __ef100_enqueue_skb() either. SKB shouldn't be
>>>> NULL or ERR at this stage.
>>>
>>> SKB shouldn't be NULL or ERR, so it can be freed. But this code looks weird.
>>
>> Please take a look __ef100_enqueue_skb() and see if it frees SKB on
>> error or not. If not, please fix it.
> 
> That function looks ok to me, but I appreciate the extra eyes on it.
> 

I've looked at this function and it seems every error handling path frees the skb.

Thanks,
Changzhong


> Martin
> 
>> Thanks
>>
>>>
>>>>
>>>> diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
>>>> index 29ffaf35559d..426706b91d02 100644
>>>> --- a/drivers/net/ethernet/sfc/ef100_tx.c
>>>> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
>>>> @@ -497,7 +497,7 @@ int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
>>>>
>>>>  err:
>>>>         efx_enqueue_unwind(tx_queue, old_insert_count);
>>>> -       if (!IS_ERR_OR_NULL(skb))
>>>> +       if (rc)
>>>>                 dev_kfree_skb_any(skb);
>>>>
>>>>         /* If we're not expecting another transmit and we had something to push
>>>>
>>>>
>>>>>  
>>>>> -- 
>>>>> 2.9.5
>>>>>
>>>> .
>>>>
> .
> 
