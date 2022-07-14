Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8325744CB
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiGNGEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbiGNGEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:04:36 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DBA0C2F001
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:04:33 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:34888.461916110
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.94 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 9C23628009E;
        Thu, 14 Jul 2022 14:04:28 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 37afcc2a116946feaa0910030cd718e7 for alexanderduyck@fb.com;
        Thu, 14 Jul 2022 14:04:31 CST
X-Transaction-ID: 37afcc2a116946feaa0910030cd718e7
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] net: sort queues in xps maps
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com
References: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
 <20220713190748.323cf866@kernel.org>
 <bf741f12-0587-5870-2c59-a52c36a1d2d6@chinatelecom.cn>
 <20220713203203.19662c5f@kernel.org>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <e9448591-005f-c21d-892b-18ad523b362b@chinatelecom.cn>
Date:   Thu, 14 Jul 2022 14:04:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20220713203203.19662c5f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/14/2022 11:32 AM, Jakub Kicinski wrote:
> On Thu, 14 Jul 2022 11:24:31 +0800 Yonglong Li wrote:
>>>> @@ -2654,6 +2660,13 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>>>>  					  skip_tc);
>>>>  	}
>>>>  
>>>> +	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
>>>> +	     j < nr_ids;) {
>>>> +		tci = j * num_tc + tc;
>>>> +		map = xmap_dereference(new_dev_maps->attr_map[tci]);
>>>> +		sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
>>>> +	}
>>>> +  
>>>
>>> Can we instead make sure that expand_xps_map() maintains order?
>>>   
>> expand_xps_map() only alloc new_map and copy old map's queue to new_map.
>> I think it is not suitable to do it in expand_xps_map().
>> WDYT?
> 
> Oh, right, sorry for the confusion, I assumed since it reallocates that
> it also fills the entry. It probably doesn't to make sure that all
> allocations succeed before making any modifications.
> 
> Can we factor out the inside of the next loop - starting from the 
> "add tx-queue to CPU/rx-queue maps" comment into a helper? My worry is
> that __netif_set_xps_queue() is already pretty long and complicated we
> should try to move some code out rather than make it longer.
>
Ok, I will prepare a v2 patch as your suggestion.


-- 
Li YongLong
