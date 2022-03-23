Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE384E4E6A
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232197AbiCWInL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiCWInJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:43:09 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BB641615;
        Wed, 23 Mar 2022 01:41:39 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KNhbw01RBz6H6mB;
        Wed, 23 Mar 2022 16:39:24 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 23 Mar 2022 09:41:36 +0100
Message-ID: <212ac1b3-b78b-4030-1f3d-f5cd1001bb7d@huawei.com>
Date:   Wed, 23 Mar 2022 11:41:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 03/15] landlock: landlock_find/insert_rule
 refactoring
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        <willemdebruijn.kernel@gmail.com>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-4-konstantin.meskhidze@huawei.com>
 <bc44f11f-0eaa-a5f6-c5dc-1d36570f1be1@digikod.net>
 <6535183b-5fad-e3a9-1350-d22122205be6@huawei.com>
 <92d498f0-c598-7413-6b7c-d19c5aec6cab@digikod.net>
 <cb30248d-a8ae-c366-2c9f-2ab0fe44cc9a@huawei.com>
 <90a20548-39f6-6e84-efb1-8ef3ad992255@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <90a20548-39f6-6e84-efb1-8ef3ad992255@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/22/2022 4:24 PM, Mickaël Salaün пишет:
> 
> On 22/03/2022 13:33, Konstantin Meskhidze wrote:
>>
>>
>> 3/18/2022 9:33 PM, Mickaël Salaün пишет:
>>>
>>> On 17/03/2022 15:29, Konstantin Meskhidze wrote:
>>>>
>>>>
>>>> 3/16/2022 11:27 AM, Mickaël Salaün пишет:
>>>>>
>>>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>>>>> A new object union added to support a socket port
>>>>>> rule type. To support it landlock_insert_rule() and
>>>>>> landlock_find_rule() were refactored. Now adding
>>>>>> or searching a rule in a ruleset depends on a
>>>>>> rule_type argument provided in refactored
>>>>>> functions mentioned above.
>>>>>>
>>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>>> ---
> 
> [...]
> 
>>>>>> @@ -156,26 +166,38 @@ static void build_check_ruleset(void)
>>>>>>    * access rights.
>>>>>>    */
>>>>>>   static int insert_rule(struct landlock_ruleset *const ruleset,
>>>>>> -        struct landlock_object *const object,
>>>>>> +        struct landlock_object *const object_ptr,
>>>>>> +        const uintptr_t object_data,
>>>
>>> Can you move rule_type here for this function and similar ones? It 
>>> makes sense to group object-related arguments.
>>
>>   Just to group them together, not putting rule_type in the end?
> 
> Yes

   Ok. Got it.
> 
> [...]
> 
>>>>>> @@ -465,20 +501,28 @@ struct landlock_ruleset 
>>>>>> *landlock_merge_ruleset(
>>>>>>    */
>>>>>>   const struct landlock_rule *landlock_find_rule(
>>>>>>           const struct landlock_ruleset *const ruleset,
>>>>>> -        const struct landlock_object *const object)
>>>>>> +        const uintptr_t object_data, const u16 rule_type)
>>>>>>   {
>>>>>>       const struct rb_node *node;
>>>>>>
>>>>>> -    if (!object)
>>>>>> +    if (!object_data)
>>>>>
>>>>> object_data can be 0. You need to add a test with such value.
>>>>>
>>>>> We need to be sure that this change cannot affect the current FS code.
>>>>
>>>>   I got it. I will refactor it.
>>>
>>> Well, 0 means a port 0, which might not be correct, but this check 
>>> should not be performed by landlock_merge_ruleset().
>>>
>>   Do you mean landlock_find_rule()?? Cause this check is not
>>   performed in landlock_merge_ruleset().
> 
> Yes, I was thinking about landlock_find_rule(). If you run your tests 
> with the patch I proposed, you'll see that one of these tests will fail 
> (when port equal 0). When creating a new network rule, 
> add_rule_net_service() should check if the port value is valid. However, 
> the above `if (!object_data)` is not correct anymore.
> 
> The remaining question is: should we need to accept 0 as a valid TCP 
> port? Can it be used? How does the kernel handle it?

  I agree that must be a check for port 0 in add_rule_net_service(), 
cause unlike most port numbers, port 0 is a reserved port in TCP/IP 
networking, meaning that it should not be used in TCP or UDP messages.
Also network traffic sent across the internet to hosts listening on port 
0 might be generated from network attackers or accidentally by 
applications programmed incorrectly.
Source: https://www.lifewire.com/port-0-in-tcp-and-udp-818145

> 
>>
>>>
>>>>>
>>>>>
>>>>>>           return NULL;
>>>>>> -    node = ruleset->root.rb_node;
>>>>>> +
>>>>>> +    switch (rule_type) {
>>>>>> +    case LANDLOCK_RULE_PATH_BENEATH:
>>>>>> +        node = ruleset->root_inode.rb_node;
>>>>>> +        break;
>>>>>> +    default:
>>>>>> +        return ERR_PTR(-EINVAL);
>>>>>
>>>>> This is a bug. There is no check for such value. You need to check 
>>>>> and update all call sites to catch such errors. Same for all new 
>>>>> use of ERR_PTR().
>>>>
>>>> Sorry, I did not get your point.
>>>> Do you mean I should check the correctness of rule_type in above 
>>>> function which calls landlock_find_rule() ??? Why can't I add such 
>>>> check here?
>>>
>>> landlock_find_rule() only returns NULL or a valid pointer, not an error.
>>
>>    What about incorrect rule_type?? Return NULL? Or final rule_checl 
>> must be in upper function?
> 
> This case should never happen anyway. You should return NULL and call 
> WARN_ON_ONCE(1) just before. The same kind of WARN_ON_ONCE(1) call 
> should be part of all switch/cases of rule_type (except the two valid 
> values of course).

  Ok. I got it. Thanks.
> .
