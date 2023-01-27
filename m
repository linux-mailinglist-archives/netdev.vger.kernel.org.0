Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00F667ED55
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234197AbjA0SWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:22:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbjA0SWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:22:05 -0500
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [IPv6:2001:1600:4:17::8fac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5F713A
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 10:22:04 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4P3Qs70cMgzMrKjv;
        Fri, 27 Jan 2023 19:22:03 +0100 (CET)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4P3Qs62JxwzMqRTG;
        Fri, 27 Jan 2023 19:22:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1674843722;
        bh=mbU1ZCTAJKgGA0HVCsd8RhnkbptpgGkUzNoNdAFWErk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=S5quP2KXbpiMOFnxYVBjWYQ3y7WKU49VNSVtVbJ2idyrXmNYGlPRwIZ051yNDaf2B
         Kg/5ULPbNpe5sQS3lfLlqs9e6Wov5ahf54vauMXw3EmuuCVdfPiunob9RTfuPgw7ls
         tOqs1WluKkBXXz8wk5A66twKt4NZVKiHaLSmNXoM=
Message-ID: <68f26cf2-f382-4d31-c80f-22392a85376f@digikod.net>
Date:   Fri, 27 Jan 2023 19:22:01 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 12/12] landlock: Document Landlock's network support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>,
        =?UTF-8?Q?G=c3=bcnther_Noack?= <gnoack3000@gmail.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-13-konstantin.meskhidze@huawei.com>
 <Y8xwLvDbhKPG8JqY@galopp> <eb33371b-551e-ae6c-d7e3-a3101644b7ec@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <eb33371b-551e-ae6c-d7e3-a3101644b7ec@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/01/2023 10:38, Konstantin Meskhidze (A) wrote:
> 
> 
> 1/22/2023 2:07 AM, Günther Noack пишет:

[...]

>>> @@ -143,10 +157,24 @@ for the ruleset creation, by filtering access rights according to the Landlock
>>>   ABI version.  In this example, this is not required because all of the requested
>>>   ``allowed_access`` rights are already available in ABI 1.
>>>   
>>> -We now have a ruleset with one rule allowing read access to ``/usr`` while
>>> -denying all other handled accesses for the filesystem.  The next step is to
>>> -restrict the current thread from gaining more privileges (e.g. thanks to a SUID
>>> -binary).
>>> +For network access-control, we can add a set of rules that allow to use a port
>>> +number for a specific action. All ports values must be defined in network byte
>>> +order.
>>
>> What is the point of asking user space to convert this to network byte
>> order? It seems to me that the kernel would be able to convert it to
>> network byte order very easily internally and in a single place -- why
>> ask all of the users to deal with that complexity? Am I overlooking
>> something?
> 
>    I had a discussion about this issue with Mickaёl.
>    Please check these threads:
>    1.
> https://lore.kernel.org/netdev/49391484-7401-e7c7-d909-3bd6bd024731@digikod.net/
>    2.
> https://lore.kernel.org/netdev/1ed20e34-c252-b849-ab92-78c82901c979@huawei.com/

I'm definitely not sure if this is the right solution, or if there is 
one. The rationale is to make it close to the current (POSIX) API. We 
didn't get many opinion about that but I'd really like to have a 
discussion about port endianness for this Landlock API.

I looked at some code (e.g. see [1]) and it seems that using htons() 
might make application patching more complex after all. What do you 
think? Is there some network (syscall) API that don't use this convention?

[1] https://github.com/landlock-lsm/tuto-lighttpd

>>
>>> +
>>> +.. code-block:: c
>>> +
>>> +    struct landlock_net_service_attr net_service = {
>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>> +        .port = htons(8080),
>>> +    };
>>
>> This is a more high-level comment:
>>
>> The notion of a 16-bit "port" seems to be specific to TCP and UDP --
>> how do you envision this struct to evolve if other protocols need to
>> be supported in the future?
> 
>     When TCP restrictions land into Linux, we need to think about UDP
> support. Then other protocols will be on the road. Anyway you are right
> this struct will be evolving in long term, but I don't have a particular
> envision now. Thanks for the question - we need to think about it.
>>
>> Should this struct and the associated constants have "TCP" in its
>> name, and other protocols use a separate struct in the future?

Other protocols such as AF_VSOCK uses a 32-bit port. We could use a 
32-bits port field or ever a 64-bit one. The later could make more sense 
because each field would eventually be aligned on 64-bit. Picking a 
16-bit value was to help developers (and compilers/linters) with the 
"correct" type (for TCP).

If we think about protocols other than TCP and UDP (e.g. AF_VSOCK), it 
could make sense to have a dedicated attr struct specifying other 
properties (e.g. CID). Anyway, the API is flexible but it would be nice 
to not mess with it too much. What do you think?


>>
>>> +
>>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>> +                            &net_service, 0);
>>> +
>>> +The next step is to restrict the current thread from gaining more privileges
>>> +(e.g. thanks to a SUID binary). We now have a ruleset with the first rule allowing
>>            ^^^^^^
>>            "through" a SUID binary? "thanks to" sounds like it's desired
>>            to do that, while we're actually trying to prevent it here?
> 
>     This is Mickaёl's part. Let's ask his opinion here.
> 
>     Mickaёl, any thoughts?

Yep, "through" looks better.
