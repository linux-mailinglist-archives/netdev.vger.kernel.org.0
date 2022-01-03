Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303D0483066
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 12:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiACLSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 06:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiACLSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 06:18:20 -0500
Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [IPv6:2001:1600:3:17::190b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F04C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 03:18:20 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JSCsh2xRmzMqtF9;
        Mon,  3 Jan 2022 12:18:16 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JSCsg72DpzljsWP;
        Mon,  3 Jan 2022 12:18:15 +0100 (CET)
Message-ID: <a1a17348-61f3-9524-c76a-513422ed0332@digikod.net>
Date:   Mon, 3 Jan 2022 12:23:20 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20211228115212.703084-1-konstantin.meskhidze@huawei.com>
 <d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net>
 <02806c8e-e255-232b-1722-65ea1dba2948@huawei.com>
 <bdbae25f-5136-8905-ca64-03314b125a40@digikod.net>
 <174f2bef-f005-c29a-1ef7-7eea96516b10@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
In-Reply-To: <174f2bef-f005-c29a-1ef7-7eea96516b10@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/12/2021 10:50, Konstantin Meskhidze wrote:
> 12/31/2021 2:26 AM, Mickaël Salaün wrote:

[...]

>>>>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>>>>> index ec72b9262bf3..a335c475965c 100644
>>>>> --- a/security/landlock/ruleset.c
>>>>> +++ b/security/landlock/ruleset.c
>>>>> @@ -27,9 +27,24 @@
>>>>>   static struct landlock_ruleset *create_ruleset(const u32 num_layers)
>>>>>   {
>>>>>       struct landlock_ruleset *new_ruleset;
>>>>> +    u16 row, col, rules_types_num;
>>>>> +
>>>>> +    new_ruleset = kzalloc(sizeof *new_ruleset +
>>>>> +                  sizeof *(new_ruleset->access_masks),
>>>>
>>>> sizeof(access_masks) is 0.
>>>
>>> Actually sizeof *(new_ruleset->access_masks) is 8.
>>> It's a 64 bit pointer to u16 array[]. I checked this
>>> 2D FAM array implementation in a standalone test.
>>
>> Yes, this gives the size of the pointed element, but I wanted to point 
>> out that access_masks doesn't have a size (actually a sizeof() call on 
>> it would failed). This kzalloc() only allocates one element in the 
>> array. What happen when there is more than one layer?
> 
> Here kzalloc() only allocates a pointer to the array;
> The whole array is allocated here:
> 
> rules_types_num = LANDLOCK_RULE_TYPE_NUM;
>      /* Initializes access_mask array for multiple rule types.
>       * Double array semantic is used convenience:
>       * access_mask[rule_type][num_layer].
>       */
>      for (row = 0; row < rules_types_num; row++) {
>          new_ruleset->access_masks[row] = kzalloc(sizeof
>                      *(new_ruleset->access_masks[row]),
>                      GFP_KERNEL_ACCOUNT);
>          for (col = 0; col < num_layers; col++)
>              new_ruleset->access_masks[row][col] = 0;
> 
> If it's needed more the one layer, the code above supports creating
> array of LANDLOCK_RULE_TYPE_NUM*num_layer size (see create_ruleset() 
> function)

Indeed, this should work, but using a 1D array is less complex and 
enables to easily allocate the whole struct+array on contiguous memory.

[...]

>>
>> BTW, you should test with the latest kernel (i.e. latest Linus's tag).
>>
> I thought it was not even important what kernel version to use.
> So I started with the first one with Landlock support. Anyway in future
> it would be easy to rebase landlock network branch or cherry-pick all 
> necessary commits to the latest Linus's tag.

For this patch it should be straightforward because the updated part 
didn't change, but it may not always be the case. Anyway, we always work 
on up-to-date code.
