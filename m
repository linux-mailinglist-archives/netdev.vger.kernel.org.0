Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA514F65E8
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiDFQtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238054AbiDFQtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:49:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFEE1E9622;
        Wed,  6 Apr 2022 07:12:07 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KYRFv5ClGz67Nl1;
        Wed,  6 Apr 2022 22:09:07 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Wed, 6 Apr 2022 16:12:04 +0200
Message-ID: <2958392e-ba3e-453e-415b-c3869523ea25@huawei.com>
Date:   Wed, 6 Apr 2022 17:12:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
 <491d6e96-4bfb-ed97-7eb8-fb18aa144d64@huawei.com>
 <6f631d7c-a2e3-20b3-997e-6b533b748767@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <6f631d7c-a2e3-20b3-997e-6b533b748767@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_DOTEDU autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



4/4/2022 12:44 PM, Mickaël Salaün пишет:
> 
> On 04/04/2022 10:28, Konstantin Meskhidze wrote:
>>
>>
>> 4/1/2022 7:52 PM, Mickaël Salaün пишет:
> 
> [...]
> 
>>>> +static int create_socket(struct __test_metadata *const _metadata)
>>>> +{
>>>> +
>>>> +        int sockfd;
>>>> +
>>>> +        sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>>> +        ASSERT_LE(0, sockfd);
>>>> +        /* Allows to reuse of local address */
>>>> +        ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, 
>>>> &one, sizeof(one)));
>>>
>>> Why is it required?
>>
>>    Without SO_REUSEADDR there is an error that a socket's port is in use.
> 
> I'm sure there is, but why is this port reused? I think this means that 
> there is an issue in the tests and that could hide potential issue with 
> the tests (and then with the kernel code). Could you investigate and 
> find the problem? This would make these tests reliable.
   The next scenario is possible here:
   "In order for a network connection to close, both ends have to send 
FIN (final) packets, which indicate they will not send any additional 
data, and both ends must ACK (acknowledge) each other's FIN packets. The 
FIN packets are initiated by the application performing a close(), a 
shutdown(), or an exit(). The ACKs are handled by the kernel after the 
close() has completed. Because of this, it is possible for the process 
to complete before the kernel has released the associated network 
resource, and this port cannot be bound to another process until the 
kernel has decided that it is done."
https://hea-www.harvard.edu/~fine/Tech/addrinuse.html.

So in this case we have busy port in network selfttest and one of the 
solution is to set SO_REUSEADDR socket option, "which explicitly allows 
a process to bind to a port which remains in TIME_WAIT (it still only 
allows a single process to be bound to that port). This is the both the 
simplest and the most effective option for reducing the "address already 
in use" error".
> 
> Without removing the need to find this issue, the next series should use 
> a network namespace per test, which will confine such issue from other 
> tests and the host.

   So there are 2 options here:
	1. Using SO_REUSEADDR option
	2. Using network namespace.

I prefer the first option - "the simplest and the most effective one"

> 
> [...]
> 
>>>> +TEST_F_FORK(socket, bind_with_restrictions) {
>>>> +
>>>> +    int sockfd_1, sockfd_2, sockfd_3;
>>>
>>> Do you really need to have 3 opened socket at the same time?
>>
>>    I just wanted to "kill two birds with one stone" in this test.
>>    It possible to split it in 3 tests and open just one socket in each 
>> one.
> 
> I wanted to point out that these three variables could be replaced with 
> only one (taking into account that successful opened socket are closed 
> before the variable is reused).
> 
> It may not be obvious if we need to split a test into multiple. The 
> rules I try to follow are:
> - use a consistent Landlock rule setup, with potentially nested rules, 
> to test specific edge cases;
> - don't tamper the context of a test (e.g. with FS topology/layout 
> modification or network used port) unless it is clearly documented and 
> easy to spot, but be careful about the dependent tests;
> - don't make tests too long unless it makes sense for a specific scenario.
> 
   Ok. I got your point here. Thanks.
> 
>>>
>>>> +
>>>> +    struct landlock_ruleset_attr ruleset_attr = {
>>>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>> +    };
>>>> +    struct landlock_net_service_attr net_service_1 = {
>>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>> +        .port = port[0],
>>>> +    };
>>>> +    struct landlock_net_service_attr net_service_2 = {
>>>> +        .allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>>> +        .port = port[1],
>>>> +    };
>>>> +    struct landlock_net_service_attr net_service_3 = {
>>>> +        .allowed_access = 0,
>>>> +        .port = port[2],
>>>> +    };
>>>> +
>>>> +    const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>>> +            sizeof(ruleset_attr), 0);
>>>> +    ASSERT_LE(0, ruleset_fd);
>>>> +
>>>> +    /* Allows connect and bind operations to the port[0] socket. */
>>>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>>>> LANDLOCK_RULE_NET_SERVICE,
>>>> +                &net_service_1, 0));
>>>> +    /* Allows connect and deny bind operations to the port[1] 
>>>> socket. */
>>>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>>>> LANDLOCK_RULE_NET_SERVICE,
>>>> +                &net_service_2, 0));
>>>> +    /* Empty allowed_access (i.e. deny rules) are ignored in 
>>>> network actions
>>>> +     * for port[2] socket.
>>>> +     */
>>>> +    ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, 
>>>> LANDLOCK_RULE_NET_SERVICE,
>>>> +                &net_service_3, 0));
>>>> +    ASSERT_EQ(ENOMSG, errno);
>>>> +
>>>> +    /* Enforces the ruleset. */
>>>> +    enforce_ruleset(_metadata, ruleset_fd);
>>>> +
>>>> +    sockfd_1 = create_socket(_metadata);
>>>> +    ASSERT_LE(0, sockfd_1);
>>>> +    /* Binds a socket to port[0] */
>>>> +    ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr  *)&addr[0], 
>>>> sizeof(addr[0])));
>>>> +
>>>> +    /* Close bounded socket*/
>>>> +    ASSERT_EQ(0, close(sockfd_1));
>>>> +
>>>> +    sockfd_2 = create_socket(_metadata);
>>>> +    ASSERT_LE(0, sockfd_2);
>>>> +    /* Binds a socket to port[1] */
>>>> +    ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr[1], 
>>>> sizeof(addr[1])));
>>>> +    ASSERT_EQ(EACCES, errno);
>>>> +
>>>> +    sockfd_3 = create_socket(_metadata);
>>>> +    ASSERT_LE(0, sockfd_3);
>>>> +    /* Binds a socket to port[2] */
>>>> +    ASSERT_EQ(-1, bind(sockfd_3, (struct sockaddr *)&addr[2], 
>>>> sizeof(addr[2])));
>>>> +    ASSERT_EQ(EACCES, errno);
>>>> +}
>>>> +TEST_HARNESS_MAIN
>>>> -- 
>>>> 2.25.1
>>>>
>>>
>>> .
> .
