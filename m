Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200844ACF61
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345826AbiBHDBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345723AbiBHDBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:01:40 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55146C06109E;
        Mon,  7 Feb 2022 19:01:39 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jt73K1BW9z67klM;
        Tue,  8 Feb 2022 10:57:33 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Tue, 8 Feb 2022 04:01:35 +0100
Message-ID: <9a77fc40-4463-4344-34d0-184d427d32cf@huawei.com>
Date:   Tue, 8 Feb 2022 06:01:34 +0300
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
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <ae0fcafa-3e8d-d6f2-26a8-ae74dda8371c@digikod.net>
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



2/7/2022 3:49 PM, Mickaël Salaün пишет:
> 
> On 07/02/2022 08:11, Konstantin Meskhidze wrote:
>>
>>
>> 2/1/2022 9:31 PM, Mickaël Salaün пишет:
>>>
>>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>>> Support 4 tests for bind and connect networks actions:
>>>
>>> Good to see such tests!
>>>
>>>
>>>> 1. bind() a socket with no landlock restrictions.
>>>> 2. bind() sockets with landllock restrictions.
> 
> [...]
> 
>>>> + */
>>>> +
>>>> +#define _GNU_SOURCE
>>>> +#include <errno.h>
>>>> +#include <fcntl.h>
>>>> +#include <linux/landlock.h>
>>>> +#include <string.h>
>>>> +#include <sys/prctl.h>
>>>> +#include <sys/socket.h>
>>>> +#include <sys/types.h>
>>>> +#include <netinet/in.h>
>>>> +#include <arpa/inet.h>
>>>
>>> To make it determinisitic (and ease patching/diff/merging), you 
>>> should sort all the included files (in tests and in the kernel code).
>>
>>    Sorry. Did not get your point here. Could you explain in a bit more
>>    details please.
> 
> It will be easier to sort all the #include lines with the "sort -u" 
> command.

   Ok. I got it. Thanks.
> 
> [...]
> 
>>>> +    /* Create a socket 3 */
>>>> +    sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
>>>> +    ASSERT_LE(0, sockfd_3);
>>>> +    /* Allow reuse of local addresses */
>>>> +    ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, 
>>>> &one, sizeof(one)));
>>>> +
>>>> +    /* Set socket 3 address parameters */
>>>> +    addr_3.sin_family = AF_INET;
>>>> +    addr_3.sin_port = htons(SOCK_PORT_3);
>>>> +    addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>>> +    memset(&(addr_3.sin_zero), '\0', 8);
>>>> +    /* Bind the socket 3 to IP address */
>>>> +    ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, 
>>>> sizeof(addr_3)));
>>>
>>> Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 
>>> forbids it?
>>
>>    It's allowed cause net_service_3 has empty access field.
>>
>>     /* Empty allowed_access (i.e. deny rules) are ignored in network
>>      *  actions for SOCK_PORT_3 socket "object"
>>      */
>>      ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
>>                                      LANDLOCK_RULE_NET_SERVICE,
>>                                      &net_service_3, 0));
>>      ASSERT_EQ(ENOMSG, errno);
>>
>>    Applying this rule returns ENOMSG errno:
>>
>>    /* Informs about useless rule: empty allowed_access (i.e. deny rules)
>>     * are ignored in network actions
>>     */
>>          if (!net_service_attr.allowed_access) {
>>              err = -ENOMSG;
>>              goto out_put_ruleset;
>>          }
>>    This means binding socket 3 is not restricted.
>>    For path_beneath_attr.allowed_access = 0 there is the same logic.
> 
> I missed the ENOMSG check; the third rule has nothing to do with it. 
> However, because the ruleset handles bind and connect actions, they must 
> be denied by default. There is no rule allowing binding to SOCK_PORT_3. 
> Why is it allowed?
> 
> You can test with another SOCK_PORT_4, not covered by any rule. As for 
> SOCK_PORT_3, it must be forbidden to bind on it.

   Apllying the third rule (net_service_3.access is empty) returns ENOMSG
   error. That means a process hasn't been restricted by the third rule,
   cause during search  process in network rb_tree the process won't find
   the third rule, so binding to SOCK_PORT_3 is allowed.

   Maybe there is a misunderstanding here. You mean that if there is just
   only one network rule for a particular port has been applied to a
   process, other ports' networks actions are automatically restricted
   until they will be added into landlock newtwork rb_tree?
> .
