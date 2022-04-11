Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3473E4FC218
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 18:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348471AbiDKQW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 12:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345135AbiDKQWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 12:22:54 -0400
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 476B03056E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 09:20:39 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KcYxJ5NbbzMqDZS;
        Mon, 11 Apr 2022 18:20:36 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KcYxJ1khzzljsTB;
        Mon, 11 Apr 2022 18:20:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649694036;
        bh=G0sWXxQMDnEVTFfV95ip/q9mAhMhv4uhCDtyPMWfKPs=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=CTyvjW61W3Br/ep0FWCfj9Dq0xvVa6keMIMtjxQk5vnX8l4YqyXlwXyAtR8IUit/N
         9r1bsnJn9kBLDn+HQ0UlCPvh1kSfFPbxEQfVjaOe1ng2Bu7wyIgnRoVv43b3u59Uu0
         ZiEc2djdVOLDXrG0hlGjdoaHxH3NQ4TqL3n11PQA=
Message-ID: <6f9d82ed-081e-a6e4-5876-6af7db180ba1@digikod.net>
Date:   Mon, 11 Apr 2022 18:20:51 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-9-konstantin.meskhidze@huawei.com>
 <06f9ca1f-6e92-9d71-4097-e43b2f77b937@digikod.net>
 <8e279be2-5092-ad34-2f8d-ca77ee5a10fd@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 08/15] landlock: add support network rules
In-Reply-To: <8e279be2-5092-ad34-2f8d-ca77ee5a10fd@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/04/2022 15:44, Konstantin Meskhidze wrote:
> 
> 
> 4/8/2022 7:30 PM, Mickaël Salaün пишет:

[...]


>>>   struct landlock_ruleset *landlock_create_ruleset(const struct 
>>> landlock_access_mask *access_mask_set)
>>>   {
>>>       struct landlock_ruleset *new_ruleset;
>>>
>>>       /* Informs about useless ruleset. */
>>> -    if (!access_mask_set->fs)
>>> +    if (!access_mask_set->fs && !access_mask_set->net)
>>>           return ERR_PTR(-ENOMSG);
>>>       new_ruleset = create_ruleset(1);
>>> -    if (!IS_ERR(new_ruleset))
>>
>> This is better:
>>
>> if (IS_ERR(new_ruleset))
>>      return new_ruleset;
>> if (access_mask_set->fs)
>> ...
> 
>    I dont get this condition. Do you mean that we return new_ruleset
> anyway no matter what the masks's values are? So its possible to have 0 
> masks values, is't it?

No, the logic is correct but it would be simpler to exit as soon as 
there is a ruleset error, you don't need to duplicate 
"IS_ERR(new_ruleset) &&":

if (IS_ERR(new_ruleset))
	return new_ruleset;
if (access_mask_set->fs)
	landlock_set_fs_access_mask(new_ruleset, access_mask_set, 0);
if (access_mask_set->net)
	landlock_set_net_access_mask(new_ruleset, access_mask_set, 0);
return new_ruleset;

