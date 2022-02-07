Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08CE4ABF24
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbiBGNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442707AbiBGMtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:49:39 -0500
Received: from smtp-bc0e.mail.infomaniak.ch (smtp-bc0e.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F5C043188
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:49:14 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JsmDS0wS1zMprtX;
        Mon,  7 Feb 2022 13:49:12 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JsmDR4wcMzlhSMP;
        Mon,  7 Feb 2022 13:49:11 +0100 (CET)
Message-ID: <ae0fcafa-3e8d-d6f2-26a8-ae74dda8371c@digikod.net>
Date:   Mon, 7 Feb 2022 13:49:51 +0100
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
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
In-Reply-To: <ae5ca74d-ce5f-51e8-31c1-d02744ec92f8@huawei.com>
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


On 07/02/2022 08:11, Konstantin Meskhidze wrote:
> 
> 
> 2/1/2022 9:31 PM, Mickaël Salaün пишет:
>>
>> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>>> Support 4 tests for bind and connect networks actions:
>>
>> Good to see such tests!
>>
>>
>>> 1. bind() a socket with no landlock restrictions.
>>> 2. bind() sockets with landllock restrictions.

[...]

>>> + */
>>> +
>>> +#define _GNU_SOURCE
>>> +#include <errno.h>
>>> +#include <fcntl.h>
>>> +#include <linux/landlock.h>
>>> +#include <string.h>
>>> +#include <sys/prctl.h>
>>> +#include <sys/socket.h>
>>> +#include <sys/types.h>
>>> +#include <netinet/in.h>
>>> +#include <arpa/inet.h>
>>
>> To make it determinisitic (and ease patching/diff/merging), you should 
>> sort all the included files (in tests and in the kernel code).
> 
>    Sorry. Did not get your point here. Could you explain in a bit more
>    details please.

It will be easier to sort all the #include lines with the "sort -u" command.

[...]

>>> +    /* Create a socket 3 */
>>> +    sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
>>> +    ASSERT_LE(0, sockfd_3);
>>> +    /* Allow reuse of local addresses */
>>> +    ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, 
>>> &one, sizeof(one)));
>>> +
>>> +    /* Set socket 3 address parameters */
>>> +    addr_3.sin_family = AF_INET;
>>> +    addr_3.sin_port = htons(SOCK_PORT_3);
>>> +    addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>> +    memset(&(addr_3.sin_zero), '\0', 8);
>>> +    /* Bind the socket 3 to IP address */
>>> +    ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, 
>>> sizeof(addr_3)));
>>
>> Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 forbids 
>> it?
> 
>    It's allowed cause net_service_3 has empty access field.
> 
>     /* Empty allowed_access (i.e. deny rules) are ignored in network
>      *  actions for SOCK_PORT_3 socket "object"
>      */
>      ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
>                                      LANDLOCK_RULE_NET_SERVICE,
>                                      &net_service_3, 0));
>      ASSERT_EQ(ENOMSG, errno);
> 
>    Applying this rule returns ENOMSG errno:
> 
>    /* Informs about useless rule: empty allowed_access (i.e. deny rules)
>     * are ignored in network actions
>     */
>          if (!net_service_attr.allowed_access) {
>              err = -ENOMSG;
>              goto out_put_ruleset;
>          }
>    This means binding socket 3 is not restricted.
>    For path_beneath_attr.allowed_access = 0 there is the same logic.

I missed the ENOMSG check; the third rule has nothing to do with it. 
However, because the ruleset handles bind and connect actions, they must 
be denied by default. There is no rule allowing binding to SOCK_PORT_3. 
Why is it allowed?

You can test with another SOCK_PORT_4, not covered by any rule. As for 
SOCK_PORT_3, it must be forbidden to bind on it.
