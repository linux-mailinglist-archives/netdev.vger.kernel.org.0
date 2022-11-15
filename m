Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D836299F2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiKONUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiKONUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:20:49 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F894DEC6;
        Tue, 15 Nov 2022 05:20:48 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBRcp5bD8zRpKR;
        Tue, 15 Nov 2022 21:20:26 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 21:20:45 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 21:20:44 +0800
Subject: Re: [PATCH net] net: nixge: fix potential memory leak in
 nixge_start_xmit()
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Moritz Fischer <mdf@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1668416136-33530-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3IbBCioK1Clt/3a@electric-eye.fr.zoreil.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <21641ba0-3ce1-c409-b513-1bbbaeccaa51@huawei.com>
Date:   Tue, 15 Nov 2022 21:20:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <Y3IbBCioK1Clt/3a@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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

On 2022/11/14 18:40, Francois Romieu wrote:
> Zhang Changzhong <zhangchangzhong@huawei.com> :
>> The nixge_start_xmit() returns NETDEV_TX_OK but does not free skb on two
>> error handling cases, which can lead to memory leak.
>>
>> To fix this, return NETDEV_TX_BUSY in case of nixge_check_tx_bd_space()
>> fails and add dev_kfree_skb_any() in case of dma_map_single() fails.
> 
> This patch merge two unrelated changes. Please split.
> 
>> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
>> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
>> ---
>>  drivers/net/ethernet/ni/nixge.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
>> index 19d043b593cc..b9091f9bbc77 100644
>> --- a/drivers/net/ethernet/ni/nixge.c
>> +++ b/drivers/net/ethernet/ni/nixge.c
>> @@ -521,13 +521,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>>  	if (nixge_check_tx_bd_space(priv, num_frag)) {
>>  		if (!netif_queue_stopped(ndev))
>>  			netif_stop_queue(ndev);
>> -		return NETDEV_TX_OK;
>> +		return NETDEV_TX_BUSY;
>>  	}
> 
> The driver should probably check the available room before returning
> from hard_start_xmit and turn the check above unlikely().
> 
> Btw there is no lock and the Tx completion is irq driven: the driver
> is racy. :o(
> 

Hi Francois,

Thanks for you review. I'll make v2 according to your suggestion.

Changzhong
