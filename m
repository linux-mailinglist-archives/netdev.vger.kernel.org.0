Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0766394E6
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 10:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiKZJIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 04:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKZJIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 04:08:35 -0500
Received: from out199-1.us.a.mail.aliyun.com (out199-1.us.a.mail.aliyun.com [47.90.199.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFC02B1B2;
        Sat, 26 Nov 2022 01:08:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VViIOpl_1669453707;
Received: from 30.236.51.231(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VViIOpl_1669453707)
          by smtp.aliyun-inc.com;
          Sat, 26 Nov 2022 17:08:28 +0800
Message-ID: <029f80b3-1392-b307-ddbd-2db536431a23@linux.alibaba.com>
Date:   Sat, 26 Nov 2022 17:08:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v5 00/10] optimize the parallelism of SMC-R
 connections
To:     Jan Karcher <jaka@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1669218890-115854-1-git-send-email-alibuda@linux.alibaba.com>
 <c98a8f04-c696-c9e0-4d7e-bc31109a0e04@linux.alibaba.com>
 <352b1e15-3c6d-a398-3fe6-0f438e0e8406@linux.ibm.com>
 <1f87a8c2-7a47-119a-1141-250d05678546@linux.alibaba.com>
 <11182feb-0f41-e9a4-e866-8f917c745a48@linux.ibm.com>
 <4f6d8e70-b3f2-93cd-ae83-77ee733cf716@linux.alibaba.com>
 <22f468cb-106b-1797-0496-e9108773ab9d@linux.ibm.com>
Content-Language: en-US
From:   "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <22f468cb-106b-1797-0496-e9108773ab9d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/22 2:54 PM, Jan Karcher wrote:
> 
> 
> On 24/11/2022 20:53, D. Wythe wrote:
>>
>>
>> On 11/24/22 9:30 PM, Jan Karcher wrote:
>>>
>>>
>>> On 24/11/2022 09:53, D. Wythe wrote:
>>>>
>>>>
>>>> On 11/24/22 4:33 PM, Jan Karcher wrote:
>>>>>
>>>>>
>>>>> On 24/11/2022 06:55, D. Wythe wrote:
>>>>>>
>>>>>>
>>>>>> On 11/23/22 11:54 PM, D.Wythe wrote:
>>>>>>> From: "D.Wythe" <alibuda@linux.alibaba.com>
>>>>>>>
>>>>>>> This patch set attempts to optimize the parallelism of SMC-R connections,
>>>>>>> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
>>>>>>> occur after thoses optimization.
>>>>>>>
>>>>>>
>>>>>>> D. Wythe (10):
>>>>>>>    net/smc: Fix potential panic dues to unprotected
>>>>>>>      smc_llc_srv_add_link()
>>>>>>>    net/smc: fix application data exception
>>>>>>>    net/smc: fix SMC_CLC_DECL_ERR_REGRMB without smc_server_lgr_pending
>>>>>>>    net/smc: remove locks smc_client_lgr_pending and
>>>>>>>      smc_server_lgr_pending
>>>>>>>    net/smc: allow confirm/delete rkey response deliver multiplex
>>>>>>>    net/smc: make SMC_LLC_FLOW_RKEY run concurrently
>>>>>>>    net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
>>>>>>>    net/smc: use read semaphores to reduce unnecessary blocking in
>>>>>>>      smc_buf_create() & smcr_buf_unuse()
>>>>>>>    net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
>>>>>>>    net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
>>>>>>>
>>>>>>>   net/smc/af_smc.c   |  74 ++++----
>>>>>>>   net/smc/smc_core.c | 541 +++++++++++++++++++++++++++++++++++++++++++++++------
>>>>>>>   net/smc/smc_core.h |  53 +++++-
>>>>>>>   net/smc/smc_llc.c  | 285 ++++++++++++++++++++--------
>>>>>>>   net/smc/smc_llc.h  |   6 +
>>>>>>>   net/smc/smc_wr.c   |  10 -
>>>>>>>   net/smc/smc_wr.h   |  10 +
>>>>>>>   7 files changed, 801 insertions(+), 178 deletions(-)
>>>>>>>
>>>>>>
>>>>>> Hi Jan and Wenjia,
>>>>>>
>>>>>> I'm wondering whether the bug fix patches need to be put together in this series. I'm considering
>>>>>> sending these bug fix patches separately now, which may be better, in case that our patch
>>>>>> might have other problems. These bug fix patches are mainly independent, even without my other
>>>>>> patches, they may be triggered theoretically.
>>>>>
>>>>> Hi D.
>>>>>
>>>>> Wenjia and i just talked about that. For us it would be better separating the fixes and the new logic.
>>>>> If the fixes are independent feel free to post them to net.
>>>>
>>>>
>>>> Got it, I will remove those bug fix patches in the next series and send them separately.
>>>> And thanks a lot for your test, no matter what the final test results are, I will send a new series
>>>> to separate them after your test finished.
>>>
>>> Hi D.,
>>>
>>> I have some troubles applying your patches.
>>>
>>>      error: sha1 information is lacking or useless (net/smc/smc_core.c).
>>>      error: could not build fake ancestor
>>>      Patch failed at 0001 optimize the parallelism of SMC-R connections
>>>
>>> Before merging them by hand could you please send the v6 with the fixes separated and verify that you are basing on the latest net / net-next tree?
>>>
>>> That would make it easier for us to test them.
>>>
>>> Thank you
>>> - Jan
>>>
>>
>> Hi Jan,
>>
>> It's quite weird, it seems that my patch did based on the latest net-next tree.
>> And I try apply it the latest net tree, it's seems work to me too. Maybe there
>> is something wrong with the mirror I use. Can you show me the conflict described
>> in the .rej file？
> 
> Hi D.,
> 
> sorry for the delayed reply:
> I just re-tried it with path instead of git am and i think i messed it up yesterday.
> Mea culpa. With patch your changes *can* be applied to the latest net-next.
> I'm very sorry for the inconvenience. Could you still please send the v6. That way i can verify the fixes separate and we can - if the tests succeed - already apply them.
> 
> Sorry and thank you
> - Jan


Hi Jan,

I have sent the v6 with the fixes patches separated, if you have any suggestion or
advise, please let us know.

Thanks.
D. Wythe


