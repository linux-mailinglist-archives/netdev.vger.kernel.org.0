Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551584AE7B2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 04:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbiBIDIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 22:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235988AbiBIDFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 22:05:09 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F29C03E944;
        Tue,  8 Feb 2022 19:04:02 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jtl3Z0bt8z682M0;
        Wed,  9 Feb 2022 10:59:54 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 9 Feb 2022 04:03:59 +0100
Message-ID: <2aae376f-14df-2c69-204a-0de8e4b0dd74@huawei.com>
Date:   Wed, 9 Feb 2022 06:03:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-3-konstantin.meskhidze@huawei.com>
 <4d54e3a9-8a26-d393-3c81-b01389f76f09@digikod.net>
 <ae5ca74d-ce5f-51e8-31c1-d02744ec92f8@huawei.com>
 <ae0fcafa-3e8d-d6f2-26a8-ae74dda8371c@digikod.net>
 <9a77fc40-4463-4344-34d0-184d427d32cf@huawei.com>
 <d09ac689-b1bf-86fa-4da5-3a0ade7fd552@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <d09ac689-b1bf-86fa-4da5-3a0ade7fd552@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/8/2022 3:17 PM, Mickaël Salaün пишет:
> 
> On 08/02/2022 04:01, Konstantin Meskhidze wrote:
>>
>>
>> 2/7/2022 3:49 PM, Mickaël Salaün пишет:
> 
>>> [...]
>>>
>>>>>> +    /* Create a socket 3 */
>>>>>> +    sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
>>>>>> +    ASSERT_LE(0, sockfd_3);
>>>>>> +    /* Allow reuse of local addresses */
>>>>>> +    ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, 
>>>>>> &one, sizeof(one)));
>>>>>> +
>>>>>> +    /* Set socket 3 address parameters */
>>>>>> +    addr_3.sin_family = AF_INET;
>>>>>> +    addr_3.sin_port = htons(SOCK_PORT_3);
>>>>>> +    addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>>>>> +    memset(&(addr_3.sin_zero), '\0', 8);
>>>>>> +    /* Bind the socket 3 to IP address */
>>>>>> +    ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, 
>>>>>> sizeof(addr_3)));
>>>>>
>>>>> Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 
>>>>> forbids it?
>>>>
>>>>    It's allowed cause net_service_3 has empty access field.
>>>>
>>>>     /* Empty allowed_access (i.e. deny rules) are ignored in network
>>>>      *  actions for SOCK_PORT_3 socket "object"
>>>>      */
>>>>      ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
>>>>                                      LANDLOCK_RULE_NET_SERVICE,
>>>>                                      &net_service_3, 0));
>>>>      ASSERT_EQ(ENOMSG, errno);
>>>>
>>>>    Applying this rule returns ENOMSG errno:
>>>>
>>>>    /* Informs about useless rule: empty allowed_access (i.e. deny 
>>>> rules)
>>>>     * are ignored in network actions
>>>>     */
>>>>          if (!net_service_attr.allowed_access) {
>>>>              err = -ENOMSG;
>>>>              goto out_put_ruleset;
>>>>          }
>>>>    This means binding socket 3 is not restricted.
>>>>    For path_beneath_attr.allowed_access = 0 there is the same logic.
>>>
>>> I missed the ENOMSG check; the third rule has nothing to do with it. 
>>> However, because the ruleset handles bind and connect actions, they 
>>> must be denied by default. There is no rule allowing binding to 
>>> SOCK_PORT_3. Why is it allowed?
>>>
>>> You can test with another SOCK_PORT_4, not covered by any rule. As 
>>> for SOCK_PORT_3, it must be forbidden to bind on it.
>>
>>    Apllying the third rule (net_service_3.access is empty) returns ENOMSG
>>    error. That means a process hasn't been restricted by the third rule,
>>    cause during search  process in network rb_tree the process won't find
>>    the third rule, so binding to SOCK_PORT_3 is allowed.
> 
> Landlock is designed to deny every access rights that are handled (by a 
> ruleset) by default. All rules added to a ruleset are exceptions to 
> allow a subset of the handled access rights on a specific object/port.
> 
> With the current networking code, a sandboxed process can still bind or 
> connect to any port except, in this test, partially for two ports. This 
> approach doesn't help to isolate a process from the network.
   I got it. Thanks.
> 
>>
>>    Maybe there is a misunderstanding here. You mean that if there is just
>>    only one network rule for a particular port has been applied to a
>>    process, other ports' networks actions are automatically restricted
>>    until they will be added into landlock newtwork rb_tree?
> 
> Right! That is how it should be.

   So it possible to check network rb_tree for emptiness before
   every rule search caused by bind/connect hooks.
   Am I corrent that if there is a proccess with Landlcok restrictions
   applied for the filesystem, but landlock networtk rb_tree is empty
   that means the proccess is not isolated from the network? I suppose it
   would be an additional test case.
> .
