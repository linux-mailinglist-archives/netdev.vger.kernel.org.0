Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4BC69E6D1
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 19:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBUSF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 13:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjBUSFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 13:05:49 -0500
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [84.16.66.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402F12FCFA
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 10:05:42 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PLnJh24bJzMr2ms;
        Tue, 21 Feb 2023 19:05:40 +0100 (CET)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PLnJg40qxzMsKtd;
        Tue, 21 Feb 2023 19:05:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1677002740;
        bh=PP9rFCfxyjZqFlUsV5SWnLIEOcEfsYPg98n1kGSrhSY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=X55jYJrGWQAPI6sDvi3tE67wr13NWVzE82sWkzzNF+6I4AOPoMRe0IqFnrp4BfQ1l
         VBR3ODFC5N1DrUB4ptHb2Pt+YjWm4T284iNr6sghq3JxDhIT/6ALk/yaZZzkNrLKK3
         M0zJB9gVKewD3ftFpQk8ALKAW4KYV6phQZbaZynY=
Message-ID: <fa306757-2040-415b-99a7-ba40c100638a@digikod.net>
Date:   Tue, 21 Feb 2023 19:05:38 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v9 10/12] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
 <20230116085818.165539-11-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230116085818.165539-11-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 16/01/2023 09:58, Konstantin Meskhidze wrote:
> These test suites try to check edge cases for TCP sockets
> bind() and connect() actions.
> 
> socket:
> * bind: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> * connect: Tests with non-landlocked/landlocked ipv4 and ipv6 sockets.
> * bind_afunspec: Tests with non-landlocked/landlocked restrictions
> for bind action with AF_UNSPEC socket family.
> * connect_afunspec: Tests with non-landlocked/landlocked restrictions
> for connect action with AF_UNSPEC socket family.
> * ruleset_overlap: Tests with overlapping rules for one port.
> * ruleset_expanding: Tests with expanding rulesets in which rules are
> gradually added one by one, restricting sockets' connections.
> * inval: Tests with invalid user space supplied data:
>      - out of range ruleset attribute;
>      - unhandled allowed access;
>      - zero port value;
>      - zero access value;
>      - legitimate access values;
> * bind_connect_inval_addrlen: Tests with invalid address length
> for ipv4/ipv6 sockets.
> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets.
> 
> layout1:
> * with_net: Tests with network bind() socket action within
> filesystem directory access test.
> 
> Test coverage for security/landlock is 94.1% of 946 lines according
> to gcc/gcov-11.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v8:
> * Adds is_sandboxed const for FIXTURE_VARIANT(socket).
> * Refactors AF_UNSPEC tests.
> * Adds address length checking tests.
> * Convert ports in all tests to __be16.
> * Adds invalid port values tests.
> * Minor fixes.
> 
> Changes since v7:
> * Squashes all selftest commits.
> * Adds fs test with network bind() socket action.
> * Minor fixes.
> 
> ---
>   tools/testing/selftests/landlock/config     |    4 +
>   tools/testing/selftests/landlock/fs_test.c  |   65 ++
>   tools/testing/selftests/landlock/net_test.c | 1157 +++++++++++++++++++
>   3 files changed, 1226 insertions(+)
>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> diff --git a/tools/testing/selftests/landlock/config b/tools/testing/selftests/landlock/config
> index 0f0a65287bac..71f7e9a8a64c 100644
> --- a/tools/testing/selftests/landlock/config
> +++ b/tools/testing/selftests/landlock/config
> @@ -1,3 +1,7 @@
> +CONFIG_INET=y
> +CONFIG_IPV6=y
> +CONFIG_NET=y
> +CONFIG_NET_NS=y
>   CONFIG_OVERLAY_FS=y
>   CONFIG_SECURITY_LANDLOCK=y
>   CONFIG_SECURITY_PATH=y
> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
> index b762b5419a89..5de4559c7fbb 100644
> --- a/tools/testing/selftests/landlock/fs_test.c
> +++ b/tools/testing/selftests/landlock/fs_test.c
> @@ -8,8 +8,10 @@
>    */
>   
>   #define _GNU_SOURCE
> +#include <arpa/inet.h>
>   #include <fcntl.h>
>   #include <linux/landlock.h>
> +#include <netinet/in.h>
>   #include <sched.h>
>   #include <stdio.h>
>   #include <string.h>
> @@ -17,6 +19,7 @@
>   #include <sys/mount.h>
>   #include <sys/prctl.h>
>   #include <sys/sendfile.h>
> +#include <sys/socket.h>
>   #include <sys/stat.h>
>   #include <sys/sysmacros.h>
>   #include <unistd.h>
> @@ -4413,4 +4416,66 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
>   	}
>   }
>   
> +#define IP_ADDRESS "127.0.0.1"
> +
> +TEST_F_FORK(layout1, with_net)
> +{
> +	int sockfd;
> +	int sock_port = 15000;
> +	struct sockaddr_in addr4;
> +
> +	addr4.sin_family = AF_INET;
> +	addr4.sin_port = htons(sock_port);
> +	addr4.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&addr4.sin_zero, '\0', 8);
> +
> +	const struct rule rules[] = {
> +		{
> +			.path = dir_s1d2,
> +			.access = ACCESS_RO,
> +		},
> +		{},
> +	};
> +
> +	struct landlock_ruleset_attr ruleset_attr_net = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = htons(sock_port),
> +	};
> +
> +	/* Creates ruleset for network access. */
> +	const int ruleset_fd_net = landlock_create_ruleset(
> +		&ruleset_attr_net, sizeof(ruleset_attr_net), 0);
> +	ASSERT_LE(0, ruleset_fd_net);
> +
> +	/* Adds a network rule. */
> +	ASSERT_EQ(0,
> +		  landlock_add_rule(ruleset_fd_net, LANDLOCK_RULE_NET_SERVICE,
> +				    &net_service, 0));
> +
> +	enforce_ruleset(_metadata, ruleset_fd_net);
> +	ASSERT_EQ(0, close(ruleset_fd_net));
> +
> +	const int ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
> +	ASSERT_LE(0, ruleset_fd);
> +	enforce_ruleset(_metadata, ruleset_fd);
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Tests on a directory with the network rule loaded. */
> +	ASSERT_EQ(0, test_open(dir_s1d2, O_RDONLY));
> +	ASSERT_EQ(0, test_open(file1_s1d2, O_RDONLY));
> +
> +	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port 15000. */
> +	ASSERT_EQ(0, bind(sockfd, &addr4, sizeof(addr4)));
> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd));
> +}
> +
>   TEST_HARNESS_MAIN
> diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
> new file mode 100644
> index 000000000000..b9543089a4d3
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -0,0 +1,1157 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Landlock tests - Network
> + *
> + * Copyright (C) 2022 Huawei Tech. Co., Ltd.
> + */
> +
> +#define _GNU_SOURCE
> +#include <arpa/inet.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <linux/landlock.h>
> +#include <linux/in.h>
> +#include <sched.h>
> +#include <string.h>
> +#include <sys/prctl.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +
> +#include "common.h"
> +
> +#define MAX_SOCKET_NUM 10
> +
> +#define SOCK_PORT_START 3470
> +#define SOCK_PORT_ADD 10
> +
> +#define IP_ADDRESS_IPv4 "127.0.0.1"

Please use a capital "V".

> +#define IP_ADDRESS_IPv6 "::1"

ditto


> +#define SOCK_PORT 15000
> +
> +/* Number pending connections queue to be hold. */
> +#define BACKLOG 10
> +
> +const struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };
> +
> +/* Invalid attribute, out of landlock network access range. */
> +#define LANDLOCK_INVAL_ATTR 7
> +
> +FIXTURE(socket)
> +{
> +	uint port[MAX_SOCKET_NUM];
> +	struct sockaddr_in addr4[MAX_SOCKET_NUM];
> +	struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
> +};
> +
> +/* struct _fixture_variant_socket */
> +FIXTURE_VARIANT(socket)
> +{
> +	const bool is_ipv4;
> +	const bool is_sandboxed;
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv4) {
> +	/* clang-format on */
> +	.is_ipv4 = true,
> +	.is_sandboxed = false,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv4_sandboxed) {
> +	/* clang-format on */
> +	.is_ipv4 = true,
> +	.is_sandboxed = true,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv6) {
> +	/* clang-format on */
> +	.is_ipv4 = false,
> +	.is_sandboxed = false,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv6_sandboxed) {
> +	/* clang-format on */
> +	.is_ipv4 = false,
> +	.is_sandboxed = true,
> +};
> +
> +static int
> +create_socket_variant(const struct _fixture_variant_socket *const variant,

If all "struct _fixture_variant_socket" can be replaced with 
"FIXTURE_VARIANT(socket)" while keeping clang-format and checkpatch.pl 
happy, please do it. It seems that some clang-format issues have been 
fixed. Same for _test_data and FIXTURE_DATA. Please remove the outdated 
comments about these structs (see socket_standalone, and socket variant 
definitions).


> +		      const int type)
> +{
> +	if (variant->is_ipv4)
> +		return socket(AF_INET, type | SOCK_CLOEXEC, 0);
> +	else
> +		return socket(AF_INET6, type | SOCK_CLOEXEC, 0);
> +}
> +
> +static int bind_variant(const struct _fixture_variant_socket *const variant,
> +			const int sockfd,
> +			const struct _test_data_socket *const self,
> +			const size_t index, const bool zero_size)
> +

Extra new line.

> +{
> +	if (variant->is_ipv4)
> +		return bind(sockfd, &self->addr4[index],
> +			    (zero_size ? 0 : sizeof(self->addr4[index])));

Is the zero_size really useful? Do calling bind and connect with this 
argument reaches the Landlock code (check_addrlen) or is it caught by 
the network code beforehand?


> +	else
> +		return bind(sockfd, &self->addr6[index],
> +			    (zero_size ? 0 : sizeof(self->addr6[index])));
> +}
> +
> +static int connect_variant(const struct _fixture_variant_socket *const variant,
> +			   const int sockfd,
> +			   const struct _test_data_socket *const self,
> +			   const size_t index, const bool zero_size)
> +{
> +	if (variant->is_ipv4)
> +		return connect(sockfd, &self->addr4[index],
> +			       (zero_size ? 0 : sizeof(self->addr4[index])));
> +	else
> +		return connect(sockfd, &self->addr6[index],
> +			       (zero_size ? 0 : sizeof(self->addr6[index])));
> +}


[...]

> +
> +TEST_F_FORK(socket, bind)
> +{
> +	int sockfd;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = htons(self->port[0]),
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = htons(self->port[1]),
> +	};
> +	struct landlock_net_service_attr net_service_3 = {
> +		.allowed_access = 0,
> +		.port = htons(self->port[2]),
> +	};
> +	int ruleset_fd, ret;
> +
> +	if (variant->is_sandboxed) {
> +		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +						     sizeof(ruleset_attr), 0);
> +		ASSERT_LE(0, ruleset_fd);
> +
> +		/*
> +		 * Allows connect and bind operations to the port[0]
> +		 * socket.
> +		 */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &net_service_1, 0));
> +		/*
> +		 * Allows connect and deny bind operations to the port[1]
> +		 * socket.
> +		 */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &net_service_2, 0));
> +		/*
> +		 * Empty allowed_access (i.e. deny rules) are ignored in
> +		 * network actions for port[2] socket.
> +		 */
> +		ASSERT_EQ(-1, landlock_add_rule(ruleset_fd,
> +						LANDLOCK_RULE_NET_SERVICE,
> +						&net_service_3, 0));
> +		ASSERT_EQ(ENOMSG, errno);
> +
> +		/* Enforces the ruleset. */
> +		enforce_ruleset(_metadata, ruleset_fd);
> +	}
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[0]. */
> +	ret = bind_variant(variant, sockfd, self, 0, false);
> +	if (variant->is_sandboxed) {
> +		ASSERT_EQ(0, ret);
> +	} else {
> +		ASSERT_EQ(0, ret);
> +	
The condition is useless here. Same on multiple other locations.


> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[1]. */
> +	ret = bind_variant(variant, sockfd, self, 1, false);
> +	if (variant->is_sandboxed) {
> +		ASSERT_EQ(-1, ret);
> +		ASSERT_EQ(EACCES, errno);
> +	} else {
> +		ASSERT_EQ(0, ret);
> +	}
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[2]. */
> +	ret = bind_variant(variant, sockfd, self, 2, false);
> +	if (variant->is_sandboxed) {
> +		ASSERT_EQ(-1, ret);
> +		ASSERT_EQ(EACCES, errno);
> +	} else {
> +		ASSERT_EQ(0, ret);
> +	}
> +}
