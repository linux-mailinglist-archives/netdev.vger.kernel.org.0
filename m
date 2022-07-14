Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91385741D6
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbiGNDYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiGNDYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:24:45 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3007E25C58
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:24:42 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.218:36728.1615793929
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-110.86.5.94 (unknown [172.18.0.218])
        by chinatelecom.cn (HERMES) with SMTP id 04C9E2800DC;
        Thu, 14 Jul 2022 11:24:32 +0800 (CST)
X-189-SAVE-TO-SEND: liyonglong@chinatelecom.cn
Received: from  ([172.18.0.218])
        by app0025 with ESMTP id 8fccc205476547e4a2fdbfbcafe8463a for alexanderduyck@fb.com;
        Thu, 14 Jul 2022 11:24:35 CST
X-Transaction-ID: 8fccc205476547e4a2fdbfbcafe8463a
X-Real-From: liyonglong@chinatelecom.cn
X-Receive-IP: 172.18.0.218
X-MEDUSA-Status: 0
Sender: liyonglong@chinatelecom.cn
Subject: Re: [PATCH] net: sort queues in xps maps
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, alexanderduyck@fb.com
References: <1657679096-38572-1-git-send-email-liyonglong@chinatelecom.cn>
 <20220713190748.323cf866@kernel.org>
From:   Yonglong Li <liyonglong@chinatelecom.cn>
Message-ID: <bf741f12-0587-5870-2c59-a52c36a1d2d6@chinatelecom.cn>
Date:   Thu, 14 Jul 2022 11:24:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20220713190748.323cf866@kernel.org>
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

Hi Jakub,

Thanks for your feedback.

On 7/14/2022 10:07 AM, Jakub Kicinski wrote:
> On Wed, 13 Jul 2022 10:24:56 +0800 Yonglong Li wrote:
>> in the following case that set xps of each tx-queue with same cpu mask,
>> packets in the same tcp stream may be hash to different tx queue. Because
>> the order of queues in each xps map is not the same.
>>
>> first set each tx-queue with different cpu mask
>> echo 0 > /sys/class/net/eth0/queues/tx-0
>> echo 1 > /sys/class/net/eth0/queues/tx-1
>> echo 2 > /sys/class/net/eth0/queues/tx-2
>> echo 4 > /sys/class/net/eth0/queues/tx-3
>> and then set each tx-queue with same cpu mask
>> echo f > /sys/class/net/eth0/queues/tx-0
>> echo f > /sys/class/net/eth0/queues/tx-1
>> echo f > /sys/class/net/eth0/queues/tx-2
>> echo f > /sys/class/net/eth0/queues/tx-3
> 
> These commands look truncated.

I will refill the commands.

> 
>> at this point the order of each map queues is differnet, It will cause
>> packets in the same stream be hashed to diffetent tx queue:
>> attr_map[0].queues = [0,1,2,3]
>> attr_map[1].queues = [1,0,2,3]
>> attr_map[2].queues = [2,0,1,3]
>> attr_map[3].queues = [3,0,1,2]
>>
>> It is more reasonable that pacekts in the same stream be hashed to the same
>> tx queue when all tx queue bind with the same CPUs.
>>
>> Fixes: 537c00de1c9b ("net: Add functions netif_reset_xps_queue and netif_set_xps_queue")
> 
> I'd suggest treating this as a general improvement rather than fix,
> the kernel always behaved this way - it seems logical that sorted is
> better but whether it's a bug not to sort is not as clear cut.
> 
agree, will remove Fixes:tag in next version.

>> @@ -2654,6 +2660,13 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>>  					  skip_tc);
>>  	}
>>  
>> +	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
>> +	     j < nr_ids;) {
>> +		tci = j * num_tc + tc;
>> +		map = xmap_dereference(new_dev_maps->attr_map[tci]);
>> +		sort(map->queues, map->len, sizeof(u16), cmp_u16, NULL);
>> +	}
>> +
> 
> Can we instead make sure that expand_xps_map() maintains order?
> 
expand_xps_map() only alloc new_map and copy old map's queue to new_map.
I think it is not suitable to do it in expand_xps_map().
WDYT?

-- 
Li YongLong
