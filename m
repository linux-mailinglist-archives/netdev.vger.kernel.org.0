Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE55BE15C
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiITJGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiITJFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:05:44 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FEA6E2DD;
        Tue, 20 Sep 2022 02:03:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VQIg0at_1663664586;
Received: from 30.221.128.170(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VQIg0at_1663664586)
          by smtp.aliyun-inc.com;
          Tue, 20 Sep 2022 17:03:07 +0800
Message-ID: <1c65b5c5-51ba-c5fc-a928-6008c55fe67c@linux.alibaba.com>
Date:   Tue, 20 Sep 2022 17:03:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 1/2] net/smc: Introduce a specific sysctl for
 TEST_LINK time
To:     dust.li@linux.alibaba.com, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1663641907-15852-1-git-send-email-guwen@linux.alibaba.com>
 <1663642434-30035-1-git-send-email-guwen@linux.alibaba.com>
 <20220920045520.GC108825@linux.alibaba.com>
 <1ad45b33-d88a-54b7-fbfa-831f58fca9d2@linux.alibaba.com>
 <20220920082153.GD108825@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20220920082153.GD108825@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.1 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/20 16:21, dust.li wrote:

> On Tue, Sep 20, 2022 at 02:23:09PM +0800, Wen Gu wrote:
>>
>>
>> On 2022/9/20 12:55, dust.li wrote:
>>
>>> On Tue, Sep 20, 2022 at 10:53:54AM +0800, Wen Gu wrote:

>>>> +++ b/net/smc/smc_llc.h
>>>> @@ -19,6 +19,7 @@
>>>>
>>>> #define SMC_LLC_WAIT_FIRST_TIME		(5 * HZ)
>>>> #define SMC_LLC_WAIT_TIME		(2 * HZ)
>>>> +#define SMC_LLC_TESTLINK_DEFAULT_TIME	30
>>>
>>> I'm wondering why we don't follow the upper to macros using (30 * HZ) ?
>>>
>> Thanks for the reivew.
>>
>> Because the value of sysctl_smcr_testlink_time is in seconds, and the value
>> of llc_testlink_time is jiffies.
>>
>> I have thought about
>> 1) using proc_dointvec_jiffies as sysctl's proc_handler just like TCP does.
>>    But proc_dointvec_jiffies has no minimum limit, value 0 makes no sense for SMC testlink.
> 
> Maybe 0 means disable the LLC TEST LINK ?
> 
> 
>> 2) using proc_dointvec_ms_jiffies_minmax as proc_handler. But millisecond interval
>>    seems expensive for SMC test link.
>>
>> So, I choose to use proc_dointvec_minmax, make sysctl_smcr_testlink_time in
>> seconds, and convert to jiffies when assigning to llc_testlink_time.
> 
> If proc_dointvec_jiffies_minmax is really the problem, maybe you can
> write your own proc handler.
> 

Oops, I didn't noticed that value 0 means disabling LLC testlink in smc_llc_link_active().

So no need to set the minimum limit and proc_dointvec_jiffies will be fine. I will send a v2 to improve it.

Thanks,
Wen Gu
