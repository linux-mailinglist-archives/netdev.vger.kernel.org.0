Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA3675FC373
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiJLKGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJLKGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:06:05 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC46B8C13
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 03:06:02 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MnSw76nxwzMqKMY;
        Wed, 12 Oct 2022 12:05:59 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MnSw66GFkzMpqBs;
        Wed, 12 Oct 2022 12:05:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1665569159;
        bh=KAjWvw9mSr9oAoiPkX0kMgVp9E9A6YOV5FZ+ygMFbMQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZKDl9cH/EXyomx0AfDVyRU48tmsCSGjQACfRV/7rwCCNsuN+n3oztpoE5ENxXtQlW
         1J4HIRCvNNFifeAmRhB7kM+6nREAehNHlxnyXNJu/0s/2/OtVPVnH2lRmV77kL0M2/
         hde++BHguz28CscccovDpLZAJQ1c49GSQ++NlBfU=
Message-ID: <01283d8a-3319-af3c-7139-466fe22ca8e4@digikod.net>
Date:   Wed, 12 Oct 2022 12:06:01 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 02/18] landlock: refactor
 landlock_find_rule/insert_rule
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        hukeping@huawei.com, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-3-konstantin.meskhidze@huawei.com>
 <431e5311-7072-3a20-af75-d81907b22d61@digikod.net>
 <1ba8c972-1b81-dd85-c24b-83525511083e@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <1ba8c972-1b81-dd85-c24b-83525511083e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/10/2022 10:37, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:07 AM, Mickaël Salaün пишет:
>> Good to see such clean commit!
>>
>> On 29/08/2022 19:03, Konstantin Meskhidze wrote:
>>> Adds a new landlock_key union and landlock_id structure to support
>>> a socket port rule type. Refactors landlock_insert_rule() and
>>> landlock_find_rule() to support coming network modifications.
>>
>>> This patch also adds is_object_pointer() and get_root() helpers.
>>
>> Please explain a bit what these helpers do.
>>
>>
>>> Now adding or searching a rule in a ruleset depends on a landlock id
>>> argument provided in refactored functions mentioned above.
>>
>> More explanation:
>> A struct landlock_id identifies a unique entry in a ruleset: either a
>> kernel object (e.g inode) or a typed data (e.g. TCP port). There is one
>> red-black tree per key type.
>>
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>
>> Because most changes come from
>> https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f
>> and
>> https://git.kernel.org/mic/c/7d6cf40a6f81adf607ad3cc17aaa11e256beeea4
>> you can append
>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> 
>     Do I need to add Co-developed-by: Mickaël Salaün <mic@digikod.net>
>     and Signed-off-by: Mickaël Salaün <mic@digikod.net> or just
>     Co-developed-by: Mickaël Salaün <mic@digikod.net> ????
> 
>     Cause Submiting patches article says:
>     https://www.kernel.org/doc/html/latest/process/submitting-patches.html
> 
>     "...Since Co-developed-by: denotes authorship, every Co-developed-by:
> must be immediately followed by a Signed-off-by: of the associated
> co-author...."
> 
>     Is this correct signing for this patch:
> 
>     Co-developed-by: Mickaël Salaün <mic@digikod.net>
>     Signed-off-by: Mickaël Salaün <mic@digikod.net>
>     Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

Because I'll merge your patches in my tree, I'll add my Signed-off-by to 
all patches. You can then just add Co-developed-by after your 
Signed-off-by for this one and I'll add the rest.
