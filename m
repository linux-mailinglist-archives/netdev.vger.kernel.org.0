Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0579D6E3A31
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDPQNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDPQND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:13:03 -0400
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBCB120
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:13:00 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwFl4g1RzMqX2b;
        Sun, 16 Apr 2023 18:12:59 +0200 (CEST)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwFk1YdPz1J8;
        Sun, 16 Apr 2023 18:12:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661579;
        bh=f4GZtXIEwE0uG55k7nQLboixs3DgPYeGFmbM2wOTcJ8=;
        h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
        b=i9SLpUFz25MF0Xa/fT+ADcfNbSt7/bOlf8C4yl6qIuCux3pV73BSdl/teD9LeZWZV
         t2hLIUJNVtfW1Y/UvQrZ3NimMU6HDIZ/HlGmub7QWKW6NLRQeohe4xSV3wOIIOcVvp
         gcvMA48VxCSBClEyY4hsBseULmFdS324WfUNf9c8=
Message-ID: <89335fdc-a9d4-5912-e766-5efd15877b62@digikod.net>
Date:   Sun, 16 Apr 2023 18:13:04 +0200
MIME-Version: 1.0
User-Agent: 
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v10 11/13] selftests/landlock: Add 10 new test suites
 dedicated to network
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-12-konstantin.meskhidze@huawei.com>
Content-Language: en-US
In-Reply-To: <20230323085226.1432550-12-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First batch of the tests review:

On 23/03/2023 09:52, Konstantin Meskhidze wrote:
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
> * bind_connect_inval_addrlen: Tests with invalid address length.
> * inval_port_format: Tests with wrong port format for ipv4/ipv6 sockets
> and with port values more than U16_MAX.
> 
> layout1:
> * with_net: Tests with network bind() socket action within
> filesystem directory access test.
> 
> Test coverage for security/landlock is 94.5% of 945 lines according
> to gcc/gcov-11.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * Fixes mixing code declaration and code.
> * Refactors FIXTURE_TEARDOWN() with clang-format.
> * Replaces struct _fixture_variant_socket with
> FIXTURE_VARIANT(socket).

I was pretty sure clang-format and checkpatch.pl were agree with 
FIXTURE_VARIANT(), but that was not the case. You'll need to get back to 
struct _fixture_variant_socket to pass both these checks, and also the 
"/* struct _fixture_variant_socket */" comments.


> * Deletes useless condition if (variant->is_sandboxed)
> in multiple locations.
> * Deletes zero_size argument in bind_variant() and
> connect_variant().
> * Adds tests for port values exceeding U16_MAX.
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
>   tools/testing/selftests/landlock/fs_test.c  |   64 +
>   tools/testing/selftests/landlock/net_test.c | 1176 +++++++++++++++++++
>   3 files changed, 1244 insertions(+)
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
> index b762b5419a89..9dfbef276e4e 100644
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
> @@ -4413,4 +4416,65 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
>   	}
>   }
> 
> +#define IP_ADDRESS "127.0.0.1"
> +
> +TEST_F_FORK(layout1, with_net)
> +{
> +	const struct rule rules[] = {
> +		{
> +			.path = dir_s1d2,
> +			.access = ACCESS_RO,
> +		},
> +		{},
> +	};
> +	int sockfd;
> +	int sock_port = 15000;
> +	struct sockaddr_in addr4;
> +
> +	struct landlock_ruleset_attr ruleset_attr_net = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = sock_port,
> +	};
> +
> +	addr4.sin_family = AF_INET;
> +	addr4.sin_port = htons(sock_port);
> +	addr4.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&addr4.sin_zero, '\0', 8);
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
> index 000000000000..d15a93c5b2c3
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -0,0 +1,1176 @@
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
> +#include <stdint.h>
> +#include <string.h>
> +#include <sys/prctl.h>
> +#include <sys/socket.h>
> +
> +#include "common.h"
> +
> +#define MAX_SOCKET_NUM 10

You can define all other constants with either "const short" or const 
char ...[]" instead of "#define" (and use lower case).


> +
> +#define SOCK_PORT_START 3470
> +#define SOCK_PORT_ADD 10
> +
> +#define IP_ADDRESS_IPV4 "127.0.0.1"

const char loopback_ipv4[] = "127.0.0.1";


> +#define IP_ADDRESS_IPV6 "::1"
> +#define SOCK_PORT 15000
> +
> +/* Number pending connections queue to be hold. */
> +#define BACKLOG 10
> +
> +const struct sockaddr addr_unspec = { .sa_family = AF_UNSPEC };

There is no need for this variable to be global.


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
> +static int create_socket_variant(const FIXTURE_VARIANT(socket) * const variant,
> +				 const int type)

socket_variant() would be more consistent with other names.


> +{
> +	if (variant->is_ipv4)
> +		return socket(AF_INET, type | SOCK_CLOEXEC, 0);
> +	else
> +		return socket(AF_INET6, type | SOCK_CLOEXEC, 0);
> +}
> +
> +static int bind_variant(const FIXTURE_VARIANT(socket) * const variant,
> +			const int sockfd,
> +			const struct _test_data_socket *const self,
> +			const size_t index)
> +{
> +	if (variant->is_ipv4)
> +		return bind(sockfd, &self->addr4[index],
> +			    sizeof(self->addr4[index]));
> +	else
> +		return bind(sockfd, &self->addr6[index],
> +			    sizeof(self->addr6[index]));
> +}
> +
> +static int connect_variant(const FIXTURE_VARIANT(socket) * const variant,
> +			   const int sockfd,
> +			   const struct _test_data_socket *const self,
> +			   const size_t index)
> +{
> +	if (variant->is_ipv4)
> +		return connect(sockfd, &self->addr4[index],
> +			       sizeof(self->addr4[index]));
> +	else
> +		return connect(sockfd, &self->addr6[index],
> +			       sizeof(self->addr6[index]));
> +}
> +
> +FIXTURE_SETUP(socket)
> +{
> +	int i;
> +
> +	/* Creates IPv4 socket addresses. */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
> +		self->addr4[i].sin_family = AF_INET;
> +		self->addr4[i].sin_port = htons(self->port[i]);
> +		self->addr4[i].sin_addr.s_addr = inet_addr(IP_ADDRESS_IPV4);
> +		memset(&(self->addr4[i].sin_zero), '\0', 8);
> +	}
> +
> +	/* Creates IPv6 socket addresses. */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
> +		self->addr6[i].sin6_family = AF_INET6;
> +		self->addr6[i].sin6_port = htons(self->port[i]);
> +		inet_pton(AF_INET6, IP_ADDRESS_IPV6,
> +			  &(self->addr6[i].sin6_addr));
> +	}
> +
> +	set_cap(_metadata, CAP_SYS_ADMIN);
> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
> +	ASSERT_EQ(0, system("ip link set dev lo up"));
> +	clear_cap(_metadata, CAP_SYS_ADMIN);
> +};
> +
> +FIXTURE_TEARDOWN(socket)
> +{
> +}
> +
> +FIXTURE(socket_standalone)
> +{
> +	uint port[MAX_SOCKET_NUM];
> +	struct sockaddr_in addr4[MAX_SOCKET_NUM];
> +	struct sockaddr_in6 addr6[MAX_SOCKET_NUM];
> +};

I think it would be better to remove the socket_standalone fixture and 
replace it with the socket one, by replacing the "is_ipv4" field with a 
"domain" field containing either AF_INET, AF_INET6 or AF_UNSPEC, and 
adapting the related variant helpers. It would require to add exceptions 
for AF_UNSPEC related operations (e.g. INADDR_ANY), but it should be 
easier to follow than the current approach. Care must be taken to not 
loose the current AF_UNSPEC specific tests which are good.


> +
> +FIXTURE_VARIANT(socket_standalone)
> +{
> +	const bool is_sandboxed;
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket_standalone, none_sandboxed) {
> +	/* clang-format on */
> +	.is_sandboxed = false,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket_standalone, sandboxed) {
> +	/* clang-format on */
> +	.is_sandboxed = true,
> +};
> +
> +FIXTURE_SETUP(socket_standalone)
> +{
> +	int i;
> +
> +	/* Creates IPv4 socket addresses. */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
> +		self->addr4[i].sin_family = AF_INET;
> +		self->addr4[i].sin_port = htons(self->port[i]);
> +		self->addr4[i].sin_addr.s_addr = inet_addr(IP_ADDRESS_IPV4);
> +		memset(&(self->addr4[i].sin_zero), '\0', 8);
> +	}
> +
> +	/* Creates IPv6 socket addresses. */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
> +		self->addr6[i].sin6_family = AF_INET6;
> +		self->addr6[i].sin6_port = htons(self->port[i]);
> +		inet_pton(AF_INET6, IP_ADDRESS_IPV6,
> +			  &(self->addr6[i].sin6_addr));
> +	}
> +
> +	set_cap(_metadata, CAP_SYS_ADMIN);
> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
> +	ASSERT_EQ(0, system("ip link set dev lo up"));
> +	clear_cap(_metadata, CAP_SYS_ADMIN);
> +};
> +
> +FIXTURE_TEARDOWN(socket_standalone)
> +{
> +}
> +
> +TEST_F_FORK(socket, bind)
> +{
> +	int sockfd;
> +

No need for this empty line, and you can include the other int variable 
in the same declaration.


> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {

Instead of net_service_1, it would be more readable to rename similar 
variables to what they do: tcp_bind_connect, tcp_connect, tcp_denied. 
Ditto for other net_service_* names.


> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = self->port[0],
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = self->port[1],
> +	};
> +	struct landlock_net_service_attr net_service_3 = {
> +		.allowed_access = 0,
> +		.port = self->port[2],
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
> +	ret = bind_variant(variant, sockfd, self, 0);
> +	ASSERT_EQ(0, ret);
> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[1]. */
> +	ret = bind_variant(variant, sockfd, self, 1);
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
> +	ret = bind_variant(variant, sockfd, self, 2);
> +	if (variant->is_sandboxed) {
> +		ASSERT_EQ(-1, ret);
> +		ASSERT_EQ(EACCES, errno);
> +	} else {
> +		ASSERT_EQ(0, ret);
> +	}
> +}
> +
> +TEST_F_FORK(socket, connect)
> +{
> +	int new_fd;

accept_fd would be more appropriate.


> +	int sockfd_1, sockfd_2;
> +	pid_t child_1, child_2;
> +	int status;
> +	int ruleset_fd, ret;

Please group similar type declarations for all these tests.


> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = self->port[0],
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		.port = self->port[1],
> +	};

Why not the same tcp_deny rule as for the bind test?


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
> +
> +		/* Enforces the ruleset. */
> +		enforce_ruleset(_metadata, ruleset_fd);
> +	}
> +
> +	/* Creates a server socket 1. */
> +	sockfd_1 = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd_1);
> +
> +	/* Binds the socket 1 to address with port[0]. */
> +	ret = bind_variant(variant, sockfd_1, self, 0);
> +	ASSERT_EQ(0, ret);
> +
> +	/* Makes listening socket 1. */
> +	ret = listen(sockfd_1, BACKLOG);
> +	ASSERT_EQ(0, ret);
> +
> +	child_1 = fork();
> +	ASSERT_LE(0, child_1);
> +	if (child_1 == 0) {
> +		int child_sockfd, ret;
> +
> +		/* Closes listening socket for the child. */
> +		ASSERT_EQ(0, close(sockfd_1));
> +		/* Creates a stream client socket. */
> +		child_sockfd = create_socket_variant(variant, SOCK_STREAM);
> +		ASSERT_LE(0, child_sockfd);
> +
> +		/* Makes connection to the listening socket with port[0]. */
> +		ret = connect_variant(variant, child_sockfd, self, 0);
> +		ASSERT_EQ(0, ret);
> +
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +	/* Accepts connection from the child 1. */
> +	new_fd = accept(sockfd_1, NULL, 0);
> +	ASSERT_LE(0, new_fd);
> +
> +	/* Closes connection. */
> +	ASSERT_EQ(0, close(new_fd));
> +
> +	/* Closes listening socket 1 for the parent. */
> +	ASSERT_EQ(0, close(sockfd_1));
> +
> +	ASSERT_EQ(child_1, waitpid(child_1, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +
> +	/* Creates a server socket 2. */
> +	sockfd_2 = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd_2);
> +
> +	/* Binds the socket 2 to address with port[1]. */
> +	ret = bind_variant(variant, sockfd_2, self, 1);
> +	ASSERT_EQ(0, ret);
> +
> +	/* Makes listening socket 2. */
> +	ret = listen(sockfd_2, BACKLOG);
> +	ASSERT_EQ(0, ret);
> +
> +	child_2 = fork();
> +	ASSERT_LE(0, child_2);
> +	if (child_2 == 0) {
> +		int child_sockfd, ret;
> +
> +		/* Closes listening socket for the child. */
> +		ASSERT_EQ(0, close(sockfd_2));
> +		/* Creates a stream client socket. */
> +		child_sockfd = create_socket_variant(variant, SOCK_STREAM);
> +		ASSERT_LE(0, child_sockfd);
> +
> +		/* Makes connection to the listening socket with port[1]. */
> +		ret = connect_variant(variant, child_sockfd, self, 1);
> +		if (variant->is_sandboxed) {
> +			ASSERT_EQ(-1, ret);
> +			ASSERT_EQ(EACCES, errno);
> +		} else {
> +			ASSERT_EQ(0, ret);
> +		}
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +
> +	if (!variant->is_sandboxed) {
> +		/* Accepts connection from the child 2. */
> +		new_fd = accept(sockfd_1, NULL, 0);
> +		ASSERT_LE(0, new_fd);
> +
> +		/* Closes connection. */
> +		ASSERT_EQ(0, close(new_fd));
> +	}
> +
> +	/* Closes listening socket 2 for the parent. */
> +	ASSERT_EQ(0, close(sockfd_2));
> +
> +	ASSERT_EQ(child_2, waitpid(child_2, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +}
> +
> +TEST_F_FORK(socket_standalone, bind_afunspec)

This should then be part of the TEST_F_FORK(socket, bind) test.


> +{
> +	int sockfd_unspec;
> +	struct sockaddr_in addr4_unspec;
> +	int ruleset_fd_net, ret;
> +
> +	struct landlock_ruleset_attr ruleset_attr_net = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = SOCK_PORT,
> +	};
> +
> +	addr4_unspec.sin_family = AF_UNSPEC;
> +	addr4_unspec.sin_port = htons(SOCK_PORT);
> +	addr4_unspec.sin_addr.s_addr = htonl(INADDR_ANY);
> +	memset(&addr4_unspec.sin_zero, '\0', 8);
> +
> +	if (variant->is_sandboxed) {
> +		/* Creates ruleset for network access. */
> +		ruleset_fd_net = landlock_create_ruleset(
> +			&ruleset_attr_net, sizeof(ruleset_attr_net), 0);
> +		ASSERT_LE(0, ruleset_fd_net);
> +
> +		/* Adds a network rule. */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd_net,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &net_service, 0));
> +
> +		enforce_ruleset(_metadata, ruleset_fd_net);
> +		ASSERT_EQ(0, close(ruleset_fd_net));
> +	}
> +
> +	sockfd_unspec = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, sockfd_unspec);
> +
> +	/* Binds a socket to port SOCK_PORT with INADDR_ANY address. */
> +	ret = bind(sockfd_unspec, &addr4_unspec, sizeof(addr4_unspec));
> +	ASSERT_EQ(0, ret);
> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd_unspec));
> +
> +	/* Changes to a specific address. */
> +	addr4_unspec.sin_addr.s_addr = inet_addr(IP_ADDRESS_IPV4);
> +
> +	sockfd_unspec = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
> +	ASSERT_LE(0, sockfd_unspec);
> +
> +	/* Binds a socket to port SOCK_PORT with the specific address. */
> +	ret = bind(sockfd_unspec, &addr4_unspec, sizeof(addr4_unspec));
> +	ASSERT_EQ(-1, ret);
> +	ASSERT_EQ(EAFNOSUPPORT, errno);
> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd_unspec));
> +}
> +
> +TEST_F_FORK(socket, connect_afunspec)
> +{
> +	int sockfd;
> +	pid_t child;
> +	int status;
> +	int ruleset_fd_1, ruleset_fd_2;
> +	int ret;
> +
> +	struct landlock_ruleset_attr ruleset_attr_1 = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +	struct landlock_ruleset_attr ruleset_attr_2 = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +	if (variant->is_sandboxed) {
> +		ruleset_fd_1 = landlock_create_ruleset(
> +			&ruleset_attr_1, sizeof(ruleset_attr_1), 0);
> +		ASSERT_LE(0, ruleset_fd_1);
> +
> +		/* Allows bind operations to the port[0] socket. */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd_1,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &net_service_1, 0));
> +
> +		/* Enforces the ruleset. */
> +		enforce_ruleset(_metadata, ruleset_fd_1);
> +	}
> +
> +	/* Creates a server socket 1. */
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +
> +	/* Binds the socket 1 to address with port[0]. */
> +	ret = bind_variant(variant, sockfd, self, 0);
> +	ASSERT_EQ(0, ret);
> +
> +	/* Makes connection to socket with port[0]. */
> +	ret = connect_variant(variant, sockfd, self, 0);
> +	ASSERT_EQ(0, ret);
> +
> +	if (variant->is_sandboxed) {
> +		ruleset_fd_2 = landlock_create_ruleset(
> +			&ruleset_attr_2, sizeof(ruleset_attr_2), 0);
> +		ASSERT_LE(0, ruleset_fd_2);
> +
> +		/* Allows connect and bind operations to the port[0] socket. */
> +		ASSERT_EQ(0, landlock_add_rule(ruleset_fd_2,
> +					       LANDLOCK_RULE_NET_SERVICE,
> +					       &net_service_2, 0));
> +
> +		/* Enforces the ruleset. */
> +		enforce_ruleset(_metadata, ruleset_fd_2);
> +	}
> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {
> +		int ret;
> +
> +		/* Child tries to disconnect already connected socket. */
> +		ret = connect(sockfd, (struct sockaddr *)&addr_unspec,
> +			      sizeof(addr_unspec));
> +		ASSERT_EQ(0, ret);
> +
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +	/* Closes listening socket 1 for the parent. */
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	ASSERT_EQ(child, waitpid(child, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +}
> +
> +TEST_F_FORK(socket, ruleset_overlap)
> +{
> +	int sockfd;
> +	int one = 1;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +
> +		.port = self->port[0],
> +	};
> +

Please don't add these extra line breaks for variable declarations.

All declarations should also be at the begening of the function, not 
interleaved with code (cf. the following tests).


> +	struct landlock_net_service_attr net_service_2 = {

Dittor for variable names.


> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +
> +		.port = self->port[0],
> +	};
> +
> +	int ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);


I'll review the skipped tests with a following email.

[...]



> +TEST_F_FORK(socket, inval_port_format)
> +{
> +	int sockfd;
> +	int ruleset_fd, ret;
> +	struct sockaddr_in addr4;
> +	int one = 1;
> +	bool little_endian = false;
> +	unsigned int i = 1;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +

Please remove these line breaks.


> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		/* Wrong port format. */
> +		.port = htons(self->port[0]),
> +	};
> +

[...]

> +
> +	/* Closes the connection*/
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	addr4.sin_family = AF_INET;
> +	addr4.sin_port = htons(UINT16_MAX);
> +	addr4.sin_addr.s_addr = htonl(INADDR_ANY);
> +	memset(&addr4.sin_zero, '\0', 8);
> +
> +	/* Creates a socket. */
> +	sockfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);

Why not create_socket_variant()? Same question for all direct socket() 
calls.


> +	ASSERT_LE(0, sockfd);
> +	/* Allows to reuse of local address. */
> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one,
> +				sizeof(one)));
> +
> +	/* Binds the socket to UINT16_MAX. */
> +	ret = bind(sockfd, &addr4, sizeof(addr4));
> +	ASSERT_EQ(0, ret);
> +
> +	/* Closes the connection*/
> +	ASSERT_EQ(0, close(sockfd));
> +}
> +TEST_HARNESS_MAIN
> --
> 2.25.1
> 
