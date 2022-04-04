Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55704F123F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 11:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354650AbiDDJqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 05:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354620AbiDDJqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 05:46:12 -0400
Received: from smtp-bc0a.mail.infomaniak.ch (smtp-bc0a.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913032D1DE
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 02:44:14 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KX5T56LF7zMq018;
        Mon,  4 Apr 2022 11:44:09 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4KX5T52SptzlhSMZ;
        Mon,  4 Apr 2022 11:44:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1649065449;
        bh=OhlSAblWkr8dG+GnXJuaxvKUKkxl2PETwQs54etIpSI=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=SV4Il36jAuT1J9I8Xmav0jJgt7Yt4abEHQX20JfBQzIBT1yOyGmZvSelxcXlzmTLu
         rpPQr8Gv+pesnaby2CLh7G5mqADvmfYoELhUm9o2pdh/8HXESiFBDb4kWLdjWPAhsz
         BiH9IxVGHSCniA5/mrD8ya8IwEK1z6y2VgLQtNlw=
Message-ID: <6f631d7c-a2e3-20b3-997e-6b533b748767@digikod.net>
Date:   Mon, 4 Apr 2022 11:44:32 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <20220309134459.6448-11-konstantin.meskhidze@huawei.com>
 <d3340ed0-fe61-3f00-d7ba-44ece235a319@digikod.net>
 <491d6e96-4bfb-ed97-7eb8-fb18aa144d64@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 10/15] seltest/landlock: add tests for bind() hooks
In-Reply-To: <491d6e96-4bfb-ed97-7eb8-fb18aa144d64@huawei.com>
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


On 04/04/2022 10:28, Konstantin Meskhidze wrote:
> 
> 
> 4/1/2022 7:52 PM, Mickaël Salaün пишет:

[...]

>>> +static int create_socket(struct __test_metadata *const _metadata)
>>> +{
>>> +
>>> +        int sockfd;
>>> +
>>> +        sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>> +        ASSERT_LE(0, sockfd);
>>> +        /* Allows to reuse of local address */
>>> +        ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, 
>>> &one, sizeof(one)));
>>
>> Why is it required?
> 
>    Without SO_REUSEADDR there is an error that a socket's port is in use.

I'm sure there is, but why is this port reused? I think this means that 
there is an issue in the tests and that could hide potential issue with 
the tests (and then with the kernel code). Could you investigate and 
find the problem? This would make these tests reliable.

Without removing the need to find this issue, the next series should use 
a network namespace per test, which will confine such issue from other 
tests and the host.

[...]

>>> +TEST_F_FORK(socket, bind_with_restrictions) {
>>> +
>>> +    int sockfd_1, sockfd_2, sockfd_3;
>>
>> Do you really need to have 3 opened socket at the same time?
> 
>    I just wanted to "kill two birds with one stone" in this test.
>    It possible to split it in 3 tests and open just one socket in each one.

I wanted to point out that these three variables could be replaced with 
only one (taking into account that successful opened socket are closed 
before the variable is reused).

It may not be obvious if we need to split a test into multiple. The 
rules I try to follow are:
- use a consistent Landlock rule setup, with potentially nested rules, 
to test specific edge cases;
- don't tamper the context of a test (e.g. with FS topology/layout 
modification or network used port) unless it is clearly documented and 
easy to spot, but be careful about the dependent tests;
- don't make tests too long unless it makes sense for a specific scenario.


>>
>>> +
>>> +    struct landlock_ruleset_attr ruleset_attr = {
>>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>> +    };
>>> +    struct landlock_net_service_attr net_service_1 = {
>>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>> +        .port = port[0],
>>> +    };
>>> +    struct landlock_net_service_attr net_service_2 = {
>>> +        .allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>> +        .port = port[1],
>>> +    };
>>> +    struct landlock_net_service_attr net_service_3 = {
>>> +        .allowed_access = 0,
>>> +        .port = port[2],
>>> +    };
>>> +
>>> +    const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>>> +            sizeof(ruleset_attr), 0);
>>> +    ASSERT_LE(0, ruleset_fd);
>>> +
>>> +    /* Allows connect and bind operations to the port[0] socket. */
>>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>>> LANDLOCK_RULE_NET_SERVICE,
>>> +                &net_service_1, 0));
>>> +    /* Allows connect and deny bind operations to the port[1] 
>>> socket. */
>>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>>> LANDLOCK_RULE_NET_SERVICE,
>>> +                &net_service_2, 0));
>>> +    /* Empty allowed_access (i.e. deny rules) are ignored in network 
>>> actions
>>> +     * for port[2] socket.
>>> +     */
>>> +    ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, 
>>> LANDLOCK_RULE_NET_SERVICE,
>>> +                &net_service_3, 0));
>>> +    ASSERT_EQ(ENOMSG, errno);
>>> +
>>> +    /* Enforces the ruleset. */
>>> +    enforce_ruleset(_metadata, ruleset_fd);
>>> +
>>> +    sockfd_1 = create_socket(_metadata);
>>> +    ASSERT_LE(0, sockfd_1);
>>> +    /* Binds a socket to port[0] */
>>> +    ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr  *)&addr[0], 
>>> sizeof(addr[0])));
>>> +
>>> +    /* Close bounded socket*/
>>> +    ASSERT_EQ(0, close(sockfd_1));
>>> +
>>> +    sockfd_2 = create_socket(_metadata);
>>> +    ASSERT_LE(0, sockfd_2);
>>> +    /* Binds a socket to port[1] */
>>> +    ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr[1], 
>>> sizeof(addr[1])));
>>> +    ASSERT_EQ(EACCES, errno);
>>> +
>>> +    sockfd_3 = create_socket(_metadata);
>>> +    ASSERT_LE(0, sockfd_3);
>>> +    /* Binds a socket to port[2] */
>>> +    ASSERT_EQ(-1, bind(sockfd_3, (struct sockaddr *)&addr[2], 
>>> sizeof(addr[2])));
>>> +    ASSERT_EQ(EACCES, errno);
>>> +}
>>> +TEST_HARNESS_MAIN
>>> -- 
>>> 2.25.1
>>>
>>
>> .
