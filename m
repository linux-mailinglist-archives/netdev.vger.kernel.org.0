Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C1D5B5F33
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 19:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiILRXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 13:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiILRXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 13:23:11 -0400
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DA51C907
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 10:23:09 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4MRD2L3DSvzMrnVZ;
        Mon, 12 Sep 2022 19:23:06 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4MRD2K6JKHzMpnPn;
        Mon, 12 Sep 2022 19:23:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1663003386;
        bh=4FBd1IoaV+3XY+eO9iORD5SniGxOC2pyRwufe9Y/NIk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=V4f0W2dGaiOnZyQfitxqFUNp64cQPGDOAtVEa10ByW4NiPwV1AOReyIj7tT0pWL44
         yjE4RU90+7n6VqNRJo9phQESKtIqdmLJVERuKaSL3ymQRst9O+R9qvP5ErR4lEEwlW
         42THwiwqCJjrjehDJWaRReSc2O3vOqdb7kxYhCZY=
Message-ID: <cff40d68-b942-d557-9dda-526542a51f84@digikod.net>
Date:   Mon, 12 Sep 2022 19:23:05 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v7 18/18] landlock: Document Landlock's network support
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, anton.sirazetdinov@huawei.com
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
 <20220829170401.834298-19-konstantin.meskhidze@huawei.com>
 <9f354862-2bc3-39ea-92fd-53803d9bbc21@digikod.net>
 <7026ab20-588d-26b6-bc68-316cb7c785a4@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <7026ab20-588d-26b6-bc68-316cb7c785a4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/09/2022 23:14, Konstantin Meskhidze (A) wrote:
> 
> 
> 9/6/2022 11:12 AM, Mickaël Salaün пишет:
>>
>> On 29/08/2022 19:04, Konstantin Meskhidze wrote:

[...]

>>> @@ -129,6 +138,24 @@ descriptor.
>>>        }
>>>        err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_PATH_BENEATH,
>>>                                &path_beneath, 0);
>>> +
>>> +It may also be required to create rules following the same logic as explained
>>> +for the ruleset creation, by filtering access rights according to the Landlock
>>> +ABI version.  In this example, this is not required because all of the requested
>>> +`allowed_access` rights are already available in ABI 1.
>>
>> This paragraph should not be moved. Furthermore, this hunk remove error
>> handling…
> 
>     Ok. Got it.
>>
>>
>>> +
>>> +For network part we can add number of rules containing a port number and actions
>>> +that a process is allowed to do for certian ports.
>>> +
>>> +.. code-block:: c
>>> +
>>> +    struct landlock_net_service_attr net_service = {
>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>> +        .port = 8080,
>>> +    };
>>> +
>>> +    err = landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
>>> +                            &net_service, 0);
>>>        close(path_beneath.parent_fd);
>>>        if (err) {
>>>            perror("Failed to update ruleset");
>>> @@ -136,13 +163,9 @@ descriptor.
>>>            return 1;
>>>        }
>>>
>>> -It may also be required to create rules following the same logic as explained
>>> -for the ruleset creation, by filtering access rights according to the Landlock
>>> -ABI version.  In this example, this is not required because all of the requested
>>> -`allowed_access` rights are already available in ABI 1.
>>> -
>>
>> Please add similar standalone code + explanation sections for network here.
>>
>     Is added section for network not enough?

Take a look at the generated HTML documentation. Add a dedicated 
code-block section + explanation instead of inserting the network doc 
between FS doc parts and introducing issue in the example.
