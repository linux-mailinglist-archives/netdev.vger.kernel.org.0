Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65C4B0A5A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiBJKPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:15:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237343AbiBJKPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:15:52 -0500
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F43CEF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 02:15:53 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JvXh33ZsdzMppR7;
        Thu, 10 Feb 2022 11:15:47 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JvXh26xQzzlhSMC;
        Thu, 10 Feb 2022 11:15:46 +0100 (CET)
Message-ID: <dc58d69f-57f2-897d-8b6a-1243817a4104@digikod.net>
Date:   Thu, 10 Feb 2022 11:16:36 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-3-konstantin.meskhidze@huawei.com>
 <4d54e3a9-8a26-d393-3c81-b01389f76f09@digikod.net>
 <ae5ca74d-ce5f-51e8-31c1-d02744ec92f8@huawei.com>
 <ae0fcafa-3e8d-d6f2-26a8-ae74dda8371c@digikod.net>
 <9a77fc40-4463-4344-34d0-184d427d32cf@huawei.com>
 <d09ac689-b1bf-86fa-4da5-3a0ade7fd552@digikod.net>
 <2aae376f-14df-2c69-204a-0de8e4b0dd74@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
In-Reply-To: <2aae376f-14df-2c69-204a-0de8e4b0dd74@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/02/2022 04:03, Konstantin Meskhidze wrote:
> 
> 
> 2/8/2022 3:17 PM, Mickaël Salaün пишет:
>>
>> On 08/02/2022 04:01, Konstantin Meskhidze wrote:
>>>
>>>
>>> 2/7/2022 3:49 PM, Mickaël Salaün пишет:
>>
>>>> [...]
>>>>
>>>>>>> +    /* Create a socket 3 */
>>>>>>> +    sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
>>>>>>> +    ASSERT_LE(0, sockfd_3);
>>>>>>> +    /* Allow reuse of local addresses */
>>>>>>> +    ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, 
>>>>>>> &one, sizeof(one)));
>>>>>>> +
>>>>>>> +    /* Set socket 3 address parameters */
>>>>>>> +    addr_3.sin_family = AF_INET;
>>>>>>> +    addr_3.sin_port = htons(SOCK_PORT_3);
>>>>>>> +    addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>>>>>> +    memset(&(addr_3.sin_zero), '\0', 8);
>>>>>>> +    /* Bind the socket 3 to IP address */
>>>>>>> +    ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, 
>>>>>>> sizeof(addr_3)));
>>>>>>
>>>>>> Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 
>>>>>> forbids it?
>>>>>
>>>>>    It's allowed cause net_service_3 has empty access field.
>>>>>
>>>>>     /* Empty allowed_access (i.e. deny rules) are ignored in network
>>>>>      *  actions for SOCK_PORT_3 socket "object"
>>>>>      */
>>>>>      ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
>>>>>                                      LANDLOCK_RULE_NET_SERVICE,
>>>>>                                      &net_service_3, 0));
>>>>>      ASSERT_EQ(ENOMSG, errno);
>>>>>
>>>>>    Applying this rule returns ENOMSG errno:
>>>>>
>>>>>    /* Informs about useless rule: empty allowed_access (i.e. deny 
>>>>> rules)
>>>>>     * are ignored in network actions
>>>>>     */
>>>>>          if (!net_service_attr.allowed_access) {
>>>>>              err = -ENOMSG;
>>>>>              goto out_put_ruleset;
>>>>>          }
>>>>>    This means binding socket 3 is not restricted.
>>>>>    For path_beneath_attr.allowed_access = 0 there is the same logic.
>>>>
>>>> I missed the ENOMSG check; the third rule has nothing to do with it. 
>>>> However, because the ruleset handles bind and connect actions, they 
>>>> must be denied by default. There is no rule allowing binding to 
>>>> SOCK_PORT_3. Why is it allowed?
>>>>
>>>> You can test with another SOCK_PORT_4, not covered by any rule. As 
>>>> for SOCK_PORT_3, it must be forbidden to bind on it.
>>>
>>>    Apllying the third rule (net_service_3.access is empty) returns 
>>> ENOMSG
>>>    error. That means a process hasn't been restricted by the third rule,
>>>    cause during search  process in network rb_tree the process won't 
>>> find
>>>    the third rule, so binding to SOCK_PORT_3 is allowed.
>>
>> Landlock is designed to deny every access rights that are handled (by 
>> a ruleset) by default. All rules added to a ruleset are exceptions to 
>> allow a subset of the handled access rights on a specific object/port.
>>
>> With the current networking code, a sandboxed process can still bind 
>> or connect to any port except, in this test, partially for two ports. 
>> This approach doesn't help to isolate a process from the network.
>    I got it. Thanks.
>>
>>>
>>>    Maybe there is a misunderstanding here. You mean that if there is 
>>> just
>>>    only one network rule for a particular port has been applied to a
>>>    process, other ports' networks actions are automatically restricted
>>>    until they will be added into landlock newtwork rb_tree?
>>
>> Right! That is how it should be.
> 
>    So it possible to check network rb_tree for emptiness before
>    every rule search caused by bind/connect hooks.

I'm not sure to understand but the rbtree macros should do the job.


>    Am I corrent that if there is a proccess with Landlcok restrictions
>    applied for the filesystem, but landlock networtk rb_tree is empty
>    that means the proccess is not isolated from the network? I suppose it
>    would be an additional test case.

If the ruleset/domain doesn't handle network actions, Landlock just 
ignores network access request (i.e. allow them). A Landlock domain 
denies handled network actions by default, but allows those that are 
identified as such in the rbtree. Some network actions can be denied 
whatever the network rbtree is empty or not. Please take a look at how 
the filesystem actions are allowed.

It is indeed a legitimate test case.
