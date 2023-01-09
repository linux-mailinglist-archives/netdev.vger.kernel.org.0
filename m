Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A986625D5
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 13:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjAIMvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 07:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236733AbjAIMtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 07:49:25 -0500
Received: from smtp-42ab.mail.infomaniak.ch (smtp-42ab.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0F35F9A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 04:46:35 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4NrDGH2NgbzMrfR4;
        Mon,  9 Jan 2023 13:46:31 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4NrDGG446qz570;
        Mon,  9 Jan 2023 13:46:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1673268391;
        bh=ezo1wn4d9NkSYN5LV+l84opcixBGp5MaUENfqEsDKZg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mRWGFcK7JGIbN10CQPESNJq9j2zWI9a1PbZtNBVabZ3ouW1LXgAf8PpQstWLTuz5C
         OCe7sGL5wDEKa52fe+V6THrYRT5vRmN2Cm5IZiKD1a5+Dq2aN9D+ze8D4ijOtOruZh
         YRlsxbMX3yDenvu3xW6JQwpLALgDx3eDOkcPSgSY=
Message-ID: <5f8ed609-17bc-f8fc-4316-ceec9ad0f3b2@digikod.net>
Date:   Mon, 9 Jan 2023 13:46:29 +0100
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v8 10/12] selftests/landlock: Add 10 new test suites
 dedicated to network
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, artem.kuzin@huawei.com
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-11-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20221021152644.155136-11-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/10/2022 17:26, Konstantin Meskhidze wrote:
> These test suites try to check edge cases for TCP sockets
> bind() and connect() actions.
> 
> socket:
> * bind_no_restrictions: Tests with non-landlocked ipv4 and ipv6 sockets.
> * bind_with_restrictions: Tests with mixed landlock rules for ipv4 and
> ipv6 sockets.
> * connect_no_restrictions: Tests with non-landlocked ipv4 and ipv6 sockets.
> * connect_with_restrictions: Tests with mixed landlock rules for ipv4 and
> ipv6 sockets.
> * connect_afunspec_no_restrictions: Tests with no landlock restrictions
> allowing to disconnect already connected socket with AF_UNSPEC socket
> family.
> * connect_afunspec_with_restrictions: Tests with landlocked process
> refusing to disconnect already connected socket.
> * ruleset_overlap: Tests with overlapping rules for one port.
> * ruleset_expanding: Tests with expanding rulesets in which rules are
> gradually added one by one, restricting sockets' connections.
> * inval: Tests with invalid user space supplied data:
>      - out of range ruleset attribute;
>      - unhandled allowed access;
>      - zero port value;
>      - zero access value;
>      - legitimate access values;
> 
> layout1:
> * with_net: Tests with network bind() socket action within
> filesystem directory access test.
> 
> Test coverage for security/landlock is 94.3% of 920 lines according
> to gcc/gcov-11.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v7:
> * Squashes all selftest commits.
> * Adds fs test with network bind() socket action.
> * Minor fixes.
> 
> ---
>   security/landlock/ruleset.h                 |   2 -
>   tools/testing/selftests/landlock/config     |   4 +
>   tools/testing/selftests/landlock/fs_test.c  |  65 ++
>   tools/testing/selftests/landlock/net_test.c | 823 ++++++++++++++++++++
>   4 files changed, 892 insertions(+), 2 deletions(-)
>   create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
> index f272d2cd518c..ee1a02a404ce 100644
> --- a/security/landlock/ruleset.h
> +++ b/security/landlock/ruleset.h
> @@ -264,7 +264,6 @@ landlock_add_fs_access_mask(struct landlock_ruleset *const ruleset,
> 
>   	/* Should already be checked in sys_landlock_create_ruleset(). */
>   	WARN_ON_ONCE(fs_access_mask != fs_mask);
> -	// TODO: Add tests to check "|=" and not "="
>   	ruleset->access_masks[layer_level] |=
>   		(fs_mask << LANDLOCK_SHIFT_ACCESS_FS);
>   }
> @@ -278,7 +277,6 @@ landlock_add_net_access_mask(struct landlock_ruleset *const ruleset,
> 
>   	/* Should already be checked in sys_landlock_create_ruleset(). */
>   	WARN_ON_ONCE(net_access_mask != net_mask);
> -	// TODO: Add tests to check "|=" and not "="
>   	ruleset->access_masks[layer_level] |=
>   		(net_mask << LANDLOCK_SHIFT_ACCESS_NET);
>   }
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
> index 20c1ac8485f1..5c52da1a5a69 100644
> --- a/tools/testing/selftests/landlock/fs_test.c
> +++ b/tools/testing/selftests/landlock/fs_test.c
> @@ -8,14 +8,17 @@
>    */
> 
>   #define _GNU_SOURCE
> +#include <arpa/inet.h>
>   #include <fcntl.h>
>   #include <linux/landlock.h>
> +#include <netinet/in.h>
>   #include <sched.h>
>   #include <string.h>
>   #include <sys/capability.h>
>   #include <sys/mount.h>
>   #include <sys/prctl.h>
>   #include <sys/sendfile.h>
> +#include <sys/socket.h>
>   #include <sys/stat.h>
>   #include <sys/sysmacros.h>
>   #include <unistd.h>
> @@ -4366,4 +4369,66 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
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
> +		.port = sock_port,
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
> index 000000000000..d1548bd7ab60
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/net_test.c
> @@ -0,0 +1,823 @@
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
> +#include <netinet/in.h>
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
> +#define IP_ADDRESS "127.0.0.1"
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
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv4) {
> +	/* clang-format on */
> +	.is_ipv4 = true,
> +};
> +
> +/* clang-format off */
> +FIXTURE_VARIANT_ADD(socket, ipv6) {
> +	/* clang-format on */
> +	.is_ipv4 = false,
> +};
> +
> +static int
> +create_socket_variant(const struct _fixture_variant_socket *const variant,
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
> +static int connect_variant(const struct _fixture_variant_socket *const variant,
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
> +		self->addr4[i].sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +		memset(&(self->addr4[i].sin_zero), '\0', 8);
> +	}
> +
> +	/* Creates IPv6 socket addresses. */
> +	for (i = 0; i < MAX_SOCKET_NUM; i++) {
> +		self->port[i] = SOCK_PORT_START + SOCK_PORT_ADD * i;
> +		self->addr6[i].sin6_family = AF_INET6;
> +		self->addr6[i].sin6_port = htons(self->port[i]);
> +		inet_pton(AF_INET6, IP_ADDRESS, &(self->addr6[i].sin6_addr));
> +	}
> +
> +	set_cap(_metadata, CAP_SYS_ADMIN);
> +	ASSERT_EQ(0, unshare(CLONE_NEWNET));
> +	ASSERT_EQ(0, system("ip link set dev lo up"));
> +	clear_cap(_metadata, CAP_SYS_ADMIN);
> +}
> +
> +FIXTURE_TEARDOWN(socket)
> +{
> +}
> +
> +TEST_F_FORK(socket, bind_no_restrictions)
> +{
> +	int sockfd;
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +
> +	/* Binds a socket to port[0]. */
> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
> +
> +	ASSERT_EQ(0, close(sockfd));
> +}
> +
> +TEST_F_FORK(socket, bind_with_restrictions)
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
> +
> +	const int ruleset_fd =
> +		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allows connect and bind operations to the port[0] socket. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_1, 0));
> +	/* Allows connect and deny bind operations to the port[1] socket. */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				       &net_service_2, 0));
> +	/*
> +	 * Empty allowed_access (i.e. deny rules) are ignored in network actions
> +	 * for port[2] socket.
> +	 */
> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +					&net_service_3, 0));
> +	ASSERT_EQ(ENOMSG, errno);
> +
> +	/* Enforces the ruleset. */
> +	enforce_ruleset(_metadata, ruleset_fd);
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[0]. */
> +	ASSERT_EQ(0, bind_variant(variant, sockfd, self, 0));
> +
> +	/* Closes bounded socket. */
> +	ASSERT_EQ(0, close(sockfd));
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[1]. */
> +	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 1));
> +	ASSERT_EQ(EACCES, errno);
> +
> +	sockfd = create_socket_variant(variant, SOCK_STREAM);
> +	ASSERT_LE(0, sockfd);
> +	/* Binds a socket to port[2]. */
> +	ASSERT_EQ(-1, bind_variant(variant, sockfd, self, 2));
> +	ASSERT_EQ(EACCES, errno);

This is inconsistent with the bind_no_restrictions test. If you 
deduplicate the tests with and without restrictions (i.e. only one 
"bind" test, and another "connect"…), you can extend 
FIXTURE_VARIANT(socket) with a new const bool enforce_landlock, and 
check that in all tests to either do Landlock syscalls or not. You can 
still initialize most variable whatever Landlock should be enforced or 
not (e.g. ruleset_attr, net_service_1…) to make it easiear to read.


> +}
> +
> +TEST_F_FORK(socket, connect_no_restrictions)
