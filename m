Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C546EFAAC
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 21:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbjDZTKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 15:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230491AbjDZTKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 15:10:20 -0400
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [IPv6:2001:1600:3:17::8faf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9A586AA
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 12:10:14 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Q67jZ4nJVzMqFhm;
        Wed, 26 Apr 2023 21:10:10 +0200 (CEST)
Received: from unknown by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Q67jY6fGvzMppwS;
        Wed, 26 Apr 2023 21:10:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1682536210;
        bh=yeNJbARILPe55mB7CG9/Gg4enw35pJDPzRdPqjbSVfA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Hjmhz39WUeKlAQWi+0deMp9pBn1FChbIcRmlE15Q9sE9NTG21qTObQSYA2lUpIx74
         +hwVGNOFPw0PN0UJ9bKUEmy/GB8/I7byfgGlxFcIxa9SO6Wfqpi3B6AvgaSoVoVz9R
         uJDC+c7bv9eCGXofDoJFR6J0LhExTor+VDUc8AME=
Message-ID: <33c1f049-12e4-f06d-54c9-b54eec779e6f@digikod.net>
Date:   Wed, 26 Apr 2023 21:10:08 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 11/13] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-12-konstantin.meskhidze@huawei.com>
 <89335fdc-a9d4-5912-e766-5efd15877b62@digikod.net>
 <6b7b5b4f-62b2-91cc-0607-94e8c9f71e23@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <6b7b5b4f-62b2-91cc-0607-94e8c9f71e23@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/04/2023 12:02, Konstantin Meskhidze (A) wrote:
> 
> 
> 4/16/2023 7:13 PM, Mickaël Salaün пишет:
>> First batch of the tests review:
>>
>> On 23/03/2023 09:52, Konstantin Meskhidze wrote:
>>> These test suites try to check edge cases for TCP sockets
>>> bind() and connect() actions.
>>>
>>> socket:
>>> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
>>> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
>>> for bind action with AF_UNSPEC socket family.
>>> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
>>> for connect action with AF_UNSPEC socket family.
>>> * ruleset_overlap: Tests with overlapping rules for one port.
>>> * ruleset_expanding: Tests with expanding rulesets in which rules are
>>> gradually added one by one, restricting sockets' connections.
>>> * inval: Tests with invalid user space supplied data:
>>>       - out of range ruleset attribute;
>>>       - unhandled allowed access;
>>>       - zero port value;
>>>       - zero access value;
>>>       - legitimate access values;
>>> * bind_connect_inval_addrlen: Tests with invalid address length.
>>> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets
>>> and with port values more than U16_MAX.
>>>
>>> layout1:
>>> * with_net: Tests with network bind() socket action within
>>> filesystem directory access test.
>>>
>>> Test coverage for security/landlock is 94.5% of 945 lines according
>>> to gcc/gcov-11.
>>>
>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>> ---
>>>
>>> Changes since v9:
>>> * Fixes mixing code declaration and code.
>>> * Refactors FIXTURE_TEARDOWN() with clang-format.
>>> * Replaces struct _fixture_variant_socket with
>>> FIXTURE_VARIANT(socket).
>>
>> I was pretty sure clang-format and checkpatch.pl were agree with
>> FIXTURE_VARIANT(), but that was not the case. You'll need to get back to
>> struct _fixture_variant_socket to pass both these checks, and also the
>> "/* struct _fixture_variant_socket */" comments.
>>
>     Ok. I will refator this part. Thanks.
>>
>>> * Deletes useless condition if (variant->is_sandboxed)
>>> in multiple locations.
>>> * Deletes zero_size argument in bind_variant() and
>>> connect_variant().
>>> * Adds tests for port values exceeding U16_MAX.
>>>
>>> Changes since v8:
>>> * Adds is_sandboxed const for FIXTURE_VARIANT(socket).
>>> * Refactors AF_UNSPEC tests.
>>> * Adds address length checking tests.
>>> * Convert ports in all tests to __be16.
>>> * Adds invalid port values tests.
>>> * Minor fixes.
>>>
>>> Changes since v7:
>>> * Squashes all selftest commits.
>>> * Adds fs test with network bind() socket action.
>>> * Minor fixes.
>>>
>>> ---
>>>    tools/testing/selftests/landlock/config     |    4 +
>>>    tools/testing/selftests/landlock/fs_test.c  |   64 +
>>>    tools/testing/selftests/landlock/net_test.c | 1176 +++++++++++++++++++
>>>    3 files changed, 1244 insertions(+)
>>>    create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>
>>> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
>>> index 0f0a65287bac..71f7e9a8a64c 100644
>>> --- a/tools/testing/selftests/landlock/config
>>> +++ b/tools/testing/selftests/landlock/config
>>> @@ -1,3 +1,7 @@
>>> +CONFIG_INET=y
>>> +CONFIG_IPV6=y
>>> +CONFIG_NET=y
>>> +CONFIG_NET_NS=y
>>>    CONFIG_OVERLAY_FS=y
>>>    CONFIG_SECURITY_LANDLOCK=y
>>>    CONFIG_SECURITY_PATH=y
>>> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
>>> index b762b5419a89..9dfbef276e4e 100644
>>> --- a/tools/testing/selftests/landlock/fs_test.c
>>> +++ b/tools/testing/selftests/landlock/fs_test.c
>>> @@ -8,8 +8,10 @@
>>>     */
>>>
>>>    #define _GNU_SOURCE
>>> +#include <arpa/inet.h>
>>>    #include <fcntl.h>
>>>    #include <linux/landlock.h>
>>> +#include <netinet/in.h>
>>>    #include <sched.h>
>>>    #include <stdio.h>
>>>    #include <string.h>
>>> @@ -17,6 +19,7 @@
>>>    #include <sys/mount.h>
>>>    #include <sys/prctl.h>
>>>    #include <sys/sendfile.h>
>>> +#include <sys/socket.h>
>>>    #include <sys/stat.h>
>>>    #include <sys/sysmacros.h>
>>>    #include <unistd.h>
>>> @@ -4413,4 +4416,65 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
>>>    	}
>>>    }
>>>
>>> +#define IP_ADDRESS "127.0.0.1"
>>> +
>>> +TEST_F_FORK(layout1, with_net)
>>> +{
>>> +	const struct rule rules[] = {
>>> +		{
>>> +			.path = dir_s1d2,
>>> +			.access = ACCESS_RO,
>>> +		},
>>> +		{},
>>> +	};
>>> +	int sockfd;
>>> +	int sock_port = 15000;
>>> +	struct sockaddr_in addr4;
>>> +
>>> +	struct landlock_ruleset_attr ruleset_attr_net = {
>>> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>>> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>>> +	};
>>> +	struct landlock_net_service_attr net_service = {
>>> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
>>> +
>>> +		.port = sock_port,
>>> +	};
>>> +
>>> +	addr4.sin_family = AF_INET;
>>> +	addr4.sin_port = htons(sock_port);
>>> +	addr4.sin_addr.s_addr = inet_addr(IP_ADDRESS);
>>> +	memset(&addr4.sin_zero, '\0', 8);
>>> +
>>> +	/* Creates ruleset for network access. */
>>> +	const int ruleset_fd_net = landlock_create_ruleset(
>>> +		&ruleset_attr_net, sizeof(ruleset_attr_net), 0);
>>> +	ASSERT_LE(0, ruleset_fd_net);
>>> +
>>> +	/* Adds a network rule. */
>>> +	ASSERT_EQ(0,
>>> +		  landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_SERVICE,
>>> +				    &net_service, 0));
>>> +
>>> +	enforce_ruleset(_metadata, ruleset_fd_net);
>>> +	ASSERT_EQ(0, close(ruleset_fd_net));
>>> +
>>> +	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
>>> +	ASSERT_LE(0, ruleset_fd);
>>> +	enforce_ruleset(_metadata, ruleset_fd);
>>> +	ASSERT_EQ(0, close(ruleset_fd));
>>> +
>>> +	/* Tests on a directory with the network rule loaded. */
>>> +	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
>>> +	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
>>> +
>>> +	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>> +	ASSERT_LE(0, sockfd);
>>> +	/* Binds a socket to port 15000. */
>>> +	ASSERT_EQ(0, bind(sockfd, &addr4, sizeof(addr4)));
>>> +
>>> +	/* Closes bounded socket. */
>>> +	ASSERT_EQ(0, close(sockfd));
>>> +}
>>> +
>>>    TEST_HARNESS_MAIN
>>> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
>>> new file mode 100644
>>> index 000000000000..d15a93c5b2c3
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/landlock/net_test.c
>>> @@ -0,0 +1,1176 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Landlock tests - Network
>>> + *
>>> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
>>> + */
>>> +
>>> +#define _GNU_SOURCE
>>> +#include <arpa/inet.h>
>>> +#include <errno.h>
>>> +#include <fcntl.h>
>>> +#include <linux/landlock.h>
>>> +#include <linux/in.h>
>>> +#include <sched.h>
>>> +#include <stdint.h>
>>> +#include <string.h>
>>> +#include <sys/prctl.h>
>>> +#include <sys/socket.h>
>>> +
>>> +#include "common.h"
>>> +
>>> +#define MAX_SOCKET_NUM 10
>>
>> You can define all other constants with either "const short" or const
>> char ...[]" instead of "#define" (and use lower case).
>>
>     Thanks for the tip.
>>
>>> +
>>> +#define SOCK_PORT_START 3470
>>> +#define SOCK_PORT_ADD 10
>>> +
>>> +#define IP_ADDRESS_IPV4 "127.0.0.1"
>>
>> const char loopback_ipv4[] = "127.0.0.1";
>>
>     Ok.
>>
>>> +#define IP_ADDRESS_IPV6 "::1"
>>> +#define SOCK_PORT 15000
>>> +
>>> +/* Number pending connections queue to be hold. */
>>> +#define BACKLOG 10
>>> +
>>> +const struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
>>
>> There is no need for this variable to be global.
> 
>     Ok. Thanks.
>>
>>
>>> +
>>> +/* Invalid attribute, out of landlock network access range. */
>>> +#define LANDLOCK_INVAL_ATTR 7
>>> +
>>> +FIXTURE(socket)
>>> +{
>>> +	uint port[MAX_SOCKET_NUM];
>>> +	struct sockaddr_in addr4[MAX_SOCKET_NUM];
>>> +	struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
>>> +};
>>> +
>>> +FIXTURE_VARIANT(socket)
>>> +{
>>> +	const bool is_ipv4;
>>> +	const bool is_sandboxed;
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket, ipv4) {
>>> +	/* clang-format on */
>>> +	.is_ipv4 = true,
>>> +	.is_sandboxed = false,
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket, ipv4_sandboxed) {
>>> +	/* clang-format on */
>>> +	.is_ipv4 = true,
>>> +	.is_sandboxed = true,
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket, ipv6) {
>>> +	/* clang-format on */
>>> +	.is_ipv4 = false,
>>> +	.is_sandboxed = false,
>>> +};
>>> +
>>> +/* clang-format off */
>>> +FIXTURE_VARIANT_ADD(socket, ipv6_sandboxed) {
>>> +	/* clang-format on */
>>> +	.is_ipv4 = false,
>>> +	.is_sandboxed = true,
>>> +};
>>> +
>>> +static int create_socket_variant(const FIXTURE_VARIANT(socket) * const variant,
>>> +				 const int type)
>>
>> socket_variant() would be more consistent with other names.
> 
>     Sorry. What do mean ".. other names" ???

I meant with other *_variant() helpers. You can rename 
create_socket_variant() to socket_variant() (i.e. original function name 
+ _variant).


>> [...]
>>
>>> +
>>> +	/* Closes the connection*/
>>> +	ASSERT_EQ(0, close(sockfd));
>>> +
>>> +	addr4.sin_family = AF_INET;
>>> +	addr4.sin_port = htons(UINT16_MAX);
>>> +	addr4.sin_addr.s_addr = htonl(INADDR_ANY);
>>> +	memset(&addr4.sin_zero, '\0', 8);
>>> +
>>> +	/* Creates a socket. */
>>> +	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>>
>> Why not create_socket_variant()? Same question for all direct socket()
>> calls.
> 
>     I thought it would be easier to add such specific tests than changing
>     create_socket_variant(), cause its needs to add more variabless in
> FIXTURE_VARIANT(socket) and makes tests' logic more tricky.

Hmm, running all variants for that would indeed not be useful. However, 
you can remove the addr* fields from the FIXTURE(socket_standalone) struct.

Because there is no teardown, you should be able to replace all 
TEST_F_FORK() with TEST_F().

BTW, the socket's `self->port` field should be an `unsigned short` type.

bind_afunspec doesn't need any fixture but only the `is_sandboxed` 
variant, so you can use TEST_F(port, bind) instead, and declare a `port` 
fixture with only a self->port data. This should also apply to 
TEST_F(port, inval).

To be consistent, you can also rename the `socket` fixture into `inet` 
because it defines a set of IP (address) properties.



>>
>>
>>> +	ASSERT_LE(0, sockfd);
>>> +	/* Allows to reuse of local address. */
>>> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
>>> +				sizeof(one)));
>>> +
>>> +	/* Binds the socket to UINT16_MAX. */
>>> +	ret = bind(sockfd, &addr4, sizeof(addr4));
>>> +	ASSERT_EQ(0, ret);
>>> +
>>> +	/* Closes the connection*/
>>> +	ASSERT_EQ(0, close(sockfd));
>>> +}

A line break here would be nice.


>>> +TEST_HARNESS_MAIN
>>> --
>>> 2.25.1
>>>
>> .
