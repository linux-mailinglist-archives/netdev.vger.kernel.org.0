Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F22252D223
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 14:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiESMKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 08:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237708AbiESMKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 08:10:39 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74866BA541;
        Thu, 19 May 2022 05:10:37 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L3pb30NHZz6FBYc;
        Thu, 19 May 2022 20:10:23 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 19 May 2022 14:10:34 +0200
Message-ID: <5124df18-ebc0-7b9b-84d5-89e1c458bc09@huawei.com>
Date:   Thu, 19 May 2022 15:10:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v5 09/15] seltests/landlock: add tests for bind() hooks
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220516152038.39594-1-konstantin.meskhidze@huawei.com>
 <20220516152038.39594-10-konstantin.meskhidze@huawei.com>
 <eaa4cc8f-4c4a-350d-6b96-551f32156e3d@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <eaa4cc8f-4c4a-350d-6b96-551f32156e3d@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



5/17/2022 12:11 AM, Mickaël Salaün пишет:
> 
> On 16/05/2022 17:20, Konstantin Meskhidze wrote:
>> Adds selftests for bind socket action.
>> The first is with no landlock restrictions:
>>      - bind_no_restrictions_ip4;
>>      - bind_no_restrictions_ip6;
>> The second ones is with mixed landlock rules:
>>      - bind_with_restrictions_ip4;
>>      - bind_with_restrictions_ip6;
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>>
>> Changes since v3:
>> * Split commit.
>> * Add helper create_socket.
>> * Add FIXTURE_SETUP.
>>
>> Changes since v4:
>> * Adds port[MAX_SOCKET_NUM], struct sockaddr_in addr4
>> and struct sockaddr_in addr6 in FIXTURE.
>> * Refactoring FIXTURE_SETUP:
>>      - initializing self->port, self->addr4 and self->addr6.
>>      - adding network namespace.
>> * Refactoring code with self->port, self->addr4 and
>> self->addr6 variables.
>> * Adds selftests for IP6 family:
>>      - bind_no_restrictions_ip6.
>>      - bind_with_restrictions_ip6.
>> * Refactoring selftests/landlock/config
>> * Moves enforce_ruleset() into common.h
>>
>> ---
>>   tools/testing/selftests/landlock/common.h   |   9 +
>>   tools/testing/selftests/landlock/config     |   5 +-
>>   tools/testing/selftests/landlock/fs_test.c  |  10 -
>>   tools/testing/selftests/landlock/net_test.c | 237 ++++++++++++++++++++
>>   4 files changed, 250 insertions(+), 11 deletions(-)
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>>
>> diff --git a/tools/testing/selftests/landlock/common.h 
>> b/tools/testing/selftests/landlock/common.h
>> index 7ba18eb23783..c5381e641dfd 100644
>> --- a/tools/testing/selftests/landlock/common.h
>> +++ b/tools/testing/selftests/landlock/common.h
>> @@ -102,6 +102,15 @@ static inline int landlock_restrict_self(const 
>> int ruleset_fd,
>>   }
>>   #endif
>>
>> +static void enforce_ruleset(struct __test_metadata *const _metadata,
>> +        const int ruleset_fd)
>> +{
>> +    ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> +    ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0)) {
>> +        TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> +    }
>> +}
>> +
> 
> Please create a commit which moves all the needed code for all network 
> tests. I think there is only this helper though.

   Ok. I will create one additional commit for moving this helper.
   But after I have moved the helper to common.h, I got warnings while 
compiling seltests where I don't use the one (base_test and ptrace_test)

> 
> 
>>   static void _init_caps(struct __test_metadata *const _metadata, bool 
>> drop_all)
>>   {
>>       cap_t cap_p;
>> diff --git a/tools/testing/selftests/landlock/config 
>> b/tools/testing/selftests/landlock/config
>> index 0f0a65287bac..b56f3274d3f5 100644
>> --- a/tools/testing/selftests/landlock/config
>> +++ b/tools/testing/selftests/landlock/config
>> @@ -1,7 +1,10 @@
>> +CONFIG_INET=y
>> +CONFIG_IPV6=y
>> +CONFIG_NET=y
>>   CONFIG_OVERLAY_FS=y
>>   CONFIG_SECURITY_LANDLOCK=y
>>   CONFIG_SECURITY_PATH=y
>>   CONFIG_SECURITY=y
>>   CONFIG_SHMEM=y
>>   CONFIG_TMPFS_XATTR=y
>> -CONFIG_TMPFS=y
>> +CONFIG_TMPFS=y
>> \ No newline at end of file
> 
> You add whitespace changes.
> 
   OK. I will fix it. Thank you.
> 
>> diff --git a/tools/testing/selftests/landlock/fs_test.c 
>> b/tools/testing/selftests/landlock/fs_test.c
>> index 21a2ce8fa739..036dd6f8f9ea 100644
>> --- a/tools/testing/selftests/landlock/fs_test.c
>> +++ b/tools/testing/selftests/landlock/fs_test.c
>> @@ -551,16 +551,6 @@ static int create_ruleset(struct __test_metadata 
>> *const _metadata,
>>       return ruleset_fd;
>>   }
>>
>> -static void enforce_ruleset(struct __test_metadata *const _metadata,
>> -                const int ruleset_fd)
>> -{
>> -    ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
>> -    ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
>> -    {
>> -        TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
>> -    }
>> -}
>> -
>>   TEST_F_FORK(layout1, proc_nsfs)
>>   {
>>       const struct rule rules[] = {
>> diff --git a/tools/testing/selftests/landlock/net_test.c 
>> b/tools/testing/selftests/landlock/net_test.c
>> new file mode 100644
>> index 000000000000..478ef2eff559
>> --- /dev/null
>> +++ b/tools/testing/selftests/landlock/net_test.c
>> @@ -0,0 +1,237 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Landlock tests - Network
>> + *
>> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
>> + */
>> +
>> +#define _GNU_SOURCE
>> +#include <arpa/inet.h>
>> +#include <errno.h>
>> +#include <fcntl.h>
>> +#include <linux/landlock.h>
>> +#include <netinet/in.h>
>> +#include <sched.h>
>> +#include <string.h>
>> +#include <sys/prctl.h>
>> +#include <sys/socket.h>
>> +#include <sys/types.h>
>> +
>> +#include "common.h"
>> +
>> +#define MAX_SOCKET_NUM 10
>> +
>> +#define SOCK_PORT_START 3470
>> +#define SOCK_PORT_ADD 10
>> +
>> +#define IP_ADDRESS "127.0.0.1"
>> +
>> +/* Number pending connections queue to be hold */
>> +#define BACKLOG 10
> 
> "Number of pending connection queues to be hold." maybe? This is not use 
> in this patch so it shouldn't be added by this patch.
> 
   You are right. I will move it in the patch where listen() function 
appear. Thank you for noticing.
> 
>> +
>> +static int create_socket(struct __test_metadata *const _metadata,
>> +            bool ip6, bool reuse_addr)
> 
> This helper is good and I think you can improve it by leveraging test 
> variants. You could even factor out all the ipv4/ipv6 tests thanks to 
> new helpers such as bind_variant() and connect_variant(). No need to add 
> _metadata to those though. This would avoid duplicating all ipv4/ipv6 
> tests and even simplifying bind() and connect() calls. Something like this:
> 
> // rename "socket_test" to "socket" (no need to duplicate "test")
> FIXTURE_VARIANT(socket)
> {
>      const bool is_ipv4;
> };
> 
> /* clang-format off */
> FIXTURE_VARIANT_ADD(socket, ipv4) {
>      /* clang-format on */
>      .is_ipv4 = true,
> };
> 
> /* clang-format off */
> FIXTURE_VARIANT_ADD(socket, ipv6) {
>      /* clang-format on */
>      .is_ipv4 = false,
> };
> 
> static int socket_variant(const FIXTURE_VARIANT(socket) *const variant, 
> const int type)
> {
>      if (variant->is_ipv4)
>          return socket(AF_INET, type | SOCK_CLOEXEC, 0);
>      else
>          return socket(AF_INET6, type | SOCK_CLOEXEC, 0);
> }
> 
> socket_variant(variant, SOCK_STREAM);
> // this could be used to create UDP sockets too
> 
> 
> static int bind_variant(const FIXTURE_VARIANT(socket) *const variant, 
> const int sockfd, const FIXTURE_DATA(socket) *const self, const size_t 
> index)
> {
>      if (variant->is_ipv4)
>          return bind(sockfd, &self->addr4[index], 
> sizeof(self->addr4[index]));
>      else
>          return bind(sockfd, &self->addr6[index], 
> sizeof(self->addr6[index]));
> }
> 
> bind_variant(variant, sockfd, self, 0);
> 
  Ok. Thank you for this suggestion.
> 
>> +{
>> +        int sockfd;
>> +        int one = 1;
>> +
>> +        if (ip6)
>> +            sockfd = socket(AF_INET6, SOCK_STREAM | SOCK_CLOEXEC, 0);
>> +        else
>> +            sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
>> +
>> +        ASSERT_LE(0, sockfd);
>> +        /* Allows to reuse of local address */
>> +        if (reuse_addr)
>> +            ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET,
>> +                    SO_REUSEADDR, &one, sizeof(one)));
> 
> This reuse_addr part is not used in this patch and I think it would 
> simplify this helper to not add reuse_addr but to explicitely call 
> setsockopt() when required. This also enables to get rid of _metadata in 
> this helper.
> 
   Yep. You are right. I will fix it.
> 
>> +        return sockfd;
>> +}
>> +
>> +FIXTURE(socket_test) {
>> +    uint port[MAX_SOCKET_NUM];
>> +    struct sockaddr_in addr4[MAX_SOCKET_NUM];
>> +    struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
>> +};
>> +
>> +FIXTURE_SETUP(socket_test)
>> +{
>> +    int i;
>> +    /* Creates IP4 socket addresses */
>> +    for (i = 0; i < MAX_SOCKET_NUM; i++) {
> 
> Nice!
> 
>> +        self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD*i;
>> +        self->addr4[i].sin_family = AF_INET;
>> +        self->addr4[i].sin_port = htons(self->port[i]);
>> +        self->addr4[i].sin_addr.s_addr = htonl(INADDR_ANY);
> 
> Could you use the local addr (127.0.0.1) instead?

   Why cant I use INADDR_ANY here?
> 
>> +        memset(&(self->addr4[i].sin_zero), '\0', 8);
>> +    }
>> +
>> +    /* Creates IP6 socket addresses */
>> +    for (i = 0; i < MAX_SOCKET_NUM; i++) {
>> +        self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD*i;
>> +        self->addr6[i].sin6_family = AF_INET6;
>> +        self->addr6[i].sin6_port = htons(self->port[i]);
>> +        self->addr6[i].sin6_addr = in6addr_any;
> 
> ditto

   Why cant I use in6addr_any here?

> 
>> +    }
>> +
>> +    set_cap(_metadata, CAP_SYS_ADMIN);
>> +    ASSERT_EQ(0, unshare(CLONE_NEWNET));
>> +    ASSERT_EQ(0, system("ip link set dev lo up"));
> 
> If this is really required, could you avoid calling system() but set up 
> the network in C? You can strace it to see what is going on underneath.
> 
  I did check. It's a lot of code to be run under the hood (more than 
one line) and it will just will complicate the test so I suggest to 
leave just ONE line of code here.
> 
>> +    clear_cap(_metadata, CAP_SYS_ADMIN);
>> +}
>> +
>> +FIXTURE_TEARDOWN(socket_test)
>> +{ }
>> +
>> +TEST_F_FORK(socket_test, bind_no_restrictions_ip4) {
>> +
>> +    int sockfd;
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +
>> +    /* Binds a socket to port[0] */
> 
> This comment is not very useful in this context considering the below 
> line. It will be even more clear with the bind_variant() call.
> 
  Ok. I will fix it.
> 
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], 
>> sizeof(self->addr4[0])));
>> +
>> +    ASSERT_EQ(0, close(sockfd));
>> +}
>> +
>> +TEST_F_FORK(socket_test, bind_no_restrictions_ip6) {
>> +
>> +    int sockfd;
>> +
>> +    sockfd = create_socket(_metadata, true, false);
>> +    ASSERT_LE(0, sockfd);
>> +
>> +    /* Binds a socket to port[0] */
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr6[0], 
>> sizeof(self->addr6[0])));
>> +
>> +    ASSERT_EQ(0, close(sockfd));
>> +}
>> +
>> +TEST_F_FORK(socket_test, bind_with_restrictions_ip4) {
>> +
>> +    int sockfd;
>> +
>> +    struct landlock_ruleset_attr ruleset_attr = {
>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +    };
>> +    struct landlock_net_service_attr net_service_1 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .port = self->port[0],
>> +    };
>> +    struct landlock_net_service_attr net_service_2 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .port = self->port[1],
>> +    };
>> +    struct landlock_net_service_attr net_service_3 = {
>> +        .allowed_access = 0,
>> +        .port = self->port[2],
>> +    };
>> +
>> +    const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +            sizeof(ruleset_attr), 0);
>> +    ASSERT_LE(0, ruleset_fd);
>> +
>> +    /* Allows connect and bind operations to the port[0] socket. */
> 
> This comment is useful though because the below call is more complex.
> 
   So I can leave it as it's, cant I?
> 
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_1, 0));
>> +    /* Allows connect and deny bind operations to the port[1] socket. */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_2, 0));
>> +    /* Empty allowed_access (i.e. deny rules) are ignored in network 
>> actions
>> +     * for port[2] socket.
>> +     */
>> +    ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_3, 0));
>> +    ASSERT_EQ(ENOMSG, errno);
>> +
>> +    /* Enforces the ruleset. */
>> +    enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[0] */
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr4[0], 
>> sizeof(self->addr4[0])));
>> +
>> +    /* Close bounded socket*/
>> +    ASSERT_EQ(0, close(sockfd));
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[1] */
>> +    ASSERT_EQ(-1, bind(sockfd, (struct sockaddr *)&self->addr4[1], 
>> sizeof(self->addr4[1])));
>> +    ASSERT_EQ(EACCES, errno);
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[2] */
>> +    ASSERT_EQ(-1, bind(sockfd, (struct sockaddr *)&self->addr4[2], 
>> sizeof(self->addr4[2])));
>> +    ASSERT_EQ(EACCES, errno);
>> +}
>> +
>> +TEST_F_FORK(socket_test, bind_with_restrictions_ip6) {
>> +
>> +    int sockfd;
>> +
>> +    struct landlock_ruleset_attr ruleset_attr = {
>> +        .handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                      LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +    };
>> +    struct landlock_net_service_attr net_service_1 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
>> +                  LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .port = self->port[0],
>> +    };
>> +    struct landlock_net_service_attr net_service_2 = {
>> +        .allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
>> +        .port = self->port[1],
>> +    };
>> +    struct landlock_net_service_attr net_service_3 = {
>> +        .allowed_access = 0,
>> +        .port = self->port[2],
>> +    };
>> +
>> +    const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
>> +            sizeof(ruleset_attr), 0);
>> +    ASSERT_LE(0, ruleset_fd);
>> +
>> +    /* Allows connect and bind operations to the port[0] socket. */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_1, 0));
>> +    /* Allows connect and deny bind operations to the port[1] socket. */
>> +    ASSERT_EQ(0, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_2, 0));
>> +    /* Empty allowed_access (i.e. deny rules) are ignored in network 
>> actions
>> +     * for port[2] socket.
>> +     */
>> +    ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, 
>> LANDLOCK_RULE_NET_SERVICE,
>> +                &net_service_3, 0));
>> +    ASSERT_EQ(ENOMSG, errno);
>> +
>> +    /* Enforces the ruleset. */
>> +    enforce_ruleset(_metadata, ruleset_fd);
>> +
>> +    sockfd = create_socket(_metadata, true, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[0] */
>> +    ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&self->addr6[0], 
>> sizeof(self->addr6[0])));
>> +
>> +    /* Close bounded socket*/
>> +    ASSERT_EQ(0, close(sockfd));
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[1] */
>> +    ASSERT_EQ(-1, bind(sockfd, (struct sockaddr *)&self->addr6[1], 
>> sizeof(self->addr6[1])));
>> +    ASSERT_EQ(EACCES, errno);
>> +
>> +    sockfd = create_socket(_metadata, false, false);
>> +    ASSERT_LE(0, sockfd);
>> +    /* Binds a socket to port[2] */
>> +    ASSERT_EQ(-1, bind(sockfd, (struct sockaddr *)&self->addr6[2], 
>> sizeof(self->addr6[2])));
>> +    ASSERT_EQ(EACCES, errno);
>> +}
>> +TEST_HARNESS_MAIN
>> -- 
>> 2.25.1
>>
> .
