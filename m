Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C0D62BCD2
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbiKPMAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:00:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiKPMAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:00:23 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E9C1181E;
        Wed, 16 Nov 2022 03:52:37 -0800 (PST)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NC1Xc21q1zqSMs;
        Wed, 16 Nov 2022 19:48:48 +0800 (CST)
Received: from dggpeml500006.china.huawei.com (7.185.36.76) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 19:52:36 +0800
Received: from [10.174.178.240] (10.174.178.240) by
 dggpeml500006.china.huawei.com (7.185.36.76) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 16 Nov 2022 19:52:35 +0800
Subject: Re: [PATCH net v2 3/3] net: nixge: fix tx queue handling
To:     Francois Romieu <romieu@fr.zoreil.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <mdf@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1668525024-38409-1-git-send-email-zhangchangzhong@huawei.com>
 <1668525024-38409-4-git-send-email-zhangchangzhong@huawei.com>
 <Y3Qa/fjjMhctsE5w@electric-eye.fr.zoreil.com>
 <c476086a-14ce-6e47-8183-def31d569ec6@huawei.com>
 <Y3S7LpbVaTRdKmLl@electric-eye.fr.zoreil.com>
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
Message-ID: <01c16617-aaf0-3a2e-1498-a9a75ae242af@huawei.com>
Date:   Wed, 16 Nov 2022 19:52:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <Y3S7LpbVaTRdKmLl@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.240]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

On 2022/11/16 18:27, Francois Romieu wrote:
> Zhang Changzhong <zhangchangzhong@huawei.com> :
>> On 2022/11/16 7:04, Francois Romieu wrote:
>>> Zhang Changzhong <zhangchangzhong@huawei.com> :
> [...]
>>>> diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
>>>> index 91b7ebc..3776a03 100644
>>>> --- a/drivers/net/ethernet/ni/nixge.c
>>>> +++ b/drivers/net/ethernet/ni/nixge.c
>>> [...]
>>>>  static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>>>> @@ -518,10 +523,15 @@ static netdev_tx_t nixge_start_xmit(struct sk_buff *skb,
>>>>  	cur_p = &priv->tx_bd_v[priv->tx_bd_tail];
>>>>  	tx_skb = &priv->tx_skb[priv->tx_bd_tail];
>>>>  
>>>> -	if (nixge_check_tx_bd_space(priv, num_frag + 1)) {
>>>> -		if (!netif_queue_stopped(ndev))
>>>> -			netif_stop_queue(ndev);
>>>> -		return NETDEV_TX_OK;
>>>> +	if (unlikely(nixge_check_tx_bd_space(priv, num_frag + 1))) {
>>>> +		/* Should not happen as last start_xmit call should have
>>>> +		 * checked for sufficient space and queue should only be
>>>> +		 * woken when sufficient space is available.
>>>> +		 */
>>>
>>> Almost. IRQ triggering after nixge_start_xmit::netif_stop_queue and
>>> before nixge_start_xmit::smp_mb may wrongly wake queue.
>>>
>>
>> I don't know what you mean by "wronly wake queue". The queue is woken
>> only when there is sufficient for next packet.
> 
> Between nixge_start_xmit::netif_stop_queue and nixge_start_xmit::smp_mb,
> "next" packet is current packet in hard_start_xmit. However said current
> packet may not be accounted for in the IRQ context transmit completion
> handler.
> 
> [nixge_start_xmit]
> 
>         ++priv->tx_bd_tail;
>         priv->tx_bd_tail %= TX_BD_NUM;
> 
> 	/* Stop queue if next transmit may not have space */
> 	if (nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1)) {
>                 netif_stop_queue(ndev);
> 
> Which value does [nixge_start_xmit_done] read as priv->tx_bd_tail at
> this point ? The value set a few lines above or some older value ?
> 
> 		/* Matches barrier in nixge_start_xmit_done */
> 		smp_mb();
> 
> 		/* Space might have just been freed - check again */
> 		if (!nixge_check_tx_bd_space(priv, MAX_SKB_FRAGS + 1))
> 			netif_wake_queue(ndev);
> 	}
> 

Got it! Thanks a lot for your detailed explanation.

Best Regards,
Changzhong
