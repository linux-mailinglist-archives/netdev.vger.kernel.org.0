Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22074AD8CB
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbiBHNPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350361AbiBHMQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 07:16:49 -0500
X-Greylist: delayed 79199 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 04:16:48 PST
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [185.125.25.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F81C03FEC0;
        Tue,  8 Feb 2022 04:16:48 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JtMSZ5m81zMpnm7;
        Tue,  8 Feb 2022 13:16:46 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JtMSZ2T54zljTgC;
        Tue,  8 Feb 2022 13:16:46 +0100 (CET)
Message-ID: <d09ac689-b1bf-86fa-4da5-3a0ade7fd552@digikod.net>
Date:   Tue, 8 Feb 2022 13:17:27 +0100
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
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
In-Reply-To: <9a77fc40-4463-4344-34d0-184d427d32cf@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/02/2022 04:01, Konstantin Meskhidze wrote:
> 
> 
> 2/7/2022 3:49 PM, Mickaël Salaün пишет:

>> [...]
>>
>>>>> +    /* Create a socket 3 */
>>>>> +    sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
>>>>> +    ASSERT_LE(0, sockfd_3);
>>>>> +    /* Allow reuse of local addresses */
>>>>> +    ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, 
>>>>> &one, sizeof(one)));
>>>>> +
>>>>> +    /* Set socket 3 address parameters */
>>>>> +    addr_3.sin_family = AF_INET;
>>>>> +    addr_3.sin_port = htons(SOCK_PORT_3);
>>>>> +    addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>>>> +    memset(&(addr_3.sin_zero), '\0', 8);
>>>>> +    /* Bind the socket 3 to IP address */
>>>>> +    ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, 
>>>>> sizeof(addr_3)));
>>>>
>>>> Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 
>>>> forbids it?
>>>
>>>    It's allowed cause net_service_3 has empty access field.
>>>
>>>     /* Empty allowed_access (i.e. deny rules) are ignored in network
>>>      *  actions for SOCK_PORT_3 socket "object"
>>>      */
>>>      ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
>>>                                      LANDLOCK_RULE_NET_SERVICE,
>>>                                      &net_service_3, 0));
>>>      ASSERT_EQ(ENOMSG, errno);
>>>
>>>    Applying this rule returns ENOMSG errno:
>>>
>>>    /* Informs about useless rule: empty allowed_access (i.e. deny rules)
>>>     * are ignored in network actions
>>>     */
>>>          if (!net_service_attr.allowed_access) {
>>>              err = -ENOMSG;
>>>              goto out_put_ruleset;
>>>          }
>>>    This means binding socket 3 is not restricted.
>>>    For path_beneath_attr.allowed_access = 0 there is the same logic.
>>
>> I missed the ENOMSG check; the third rule has nothing to do with it. 
>> However, because the ruleset handles bind and connect actions, they 
>> must be denied by default. There is no rule allowing binding to 
>> SOCK_PORT_3. Why is it allowed?
>>
>> You can test with another SOCK_PORT_4, not covered by any rule. As for 
>> SOCK_PORT_3, it must be forbidden to bind on it.
> 
>    Apllying the third rule (net_service_3.access is empty) returns ENOMSG
>    error. That means a process hasn't been restricted by the third rule,
>    cause during search  process in network rb_tree the process won't find
>    the third rule, so binding to SOCK_PORT_3 is allowed.

Landlock is designed to deny every access rights that are handled (by a 
ruleset) by default. All rules added to a ruleset are exceptions to 
allow a subset of the handled access rights on a specific object/port.

With the current networking code, a sandboxed process can still bind or 
connect to any port except, in this test, partially for two ports. This 
approach doesn't help to isolate a process from the network.

> 
>    Maybe there is a misunderstanding here. You mean that if there is just
>    only one network rule for a particular port has been applied to a
>    process, other ports' networks actions are automatically restricted
>    until they will be added into landlock newtwork rb_tree?

Right! That is how it should be.
