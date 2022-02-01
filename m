Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C645B4A63D7
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 19:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbiBASbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 13:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiBASbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 13:31:14 -0500
Received: from smtp-42ad.mail.infomaniak.ch (smtp-42ad.mail.infomaniak.ch [IPv6:2001:1600:3:17::42ad])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2BC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 10:31:14 -0800 (PST)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JpD5r1rqMzMqF24;
        Tue,  1 Feb 2022 19:31:12 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JpD5q5fbvzlhMBv;
        Tue,  1 Feb 2022 19:31:11 +0100 (CET)
Message-ID: <4d54e3a9-8a26-d393-3c81-b01389f76f09@digikod.net>
Date:   Tue, 1 Feb 2022 19:31:14 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-3-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 2/2] landlock: selftests for bind and connect hooks
In-Reply-To: <20220124080215.265538-3-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/01/2022 09:02, Konstantin Meskhidze wrote:
> Support 4 tests for bind and connect networks actions:

Good to see such tests!


> 1. bind() a socket with no landlock restrictions.
> 2. bind() sockets with landllock restrictions.

You can leverage the FIXTURE_VARIANT helpers to factor out this kind of 
tests (see ptrace_test.c).


> 3. connect() a socket to listening one with no landlock restricitons.
> 4. connect() sockets with landlock restrictions.

Same here, you can factor out code. I guess you could create helpers for 
client and server parts.

We also need to test with IPv4, IPv6 and the AF_UNSPEC tricks.

Please provide the kernel test coverage and explain why the uncovered 
code cannot be covered: 
https://www.kernel.org/doc/html/latest/dev-tools/gcov.html

You'll probably see that there are a multiple parts of the kernel that 
are not covered. For instance, it is important to test different 
combinations of layered network rules (see layout1/ruleset_overlap, 
layer_rule_unions, non_overlapping_accesses, 
interleaved_masked_accesses… in fs_test.c). Tests in fs_test.c are more 
complex because handling file system rules is more complex, but you can 
get some inspiration in it, especially the edge cases.

We also need to test invalid user space supplied data (see layout1/inval 
test in fs_test.c).


> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
>   .../testing/selftests/landlock/network_test.c | 346 ++++++++++++++++++
>   1 file changed, 346 insertions(+)
>   create mode 100644 tools/testing/selftests/landlock/network_test.c
> 
> diff --git a/tools/testing/selftests/landlock/network_test.c b/tools/testing/selftests/landlock/network_test.c
> new file mode 100644
> index 000000000000..9dfe37a2fb20
> --- /dev/null
> +++ b/tools/testing/selftests/landlock/network_test.c
> @@ -0,0 +1,346 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Landlock tests - Common user space base
> + *
> + * Copyright © 2017-2020 Mickaël Salaün <mic@digikod.net>
> + * Copyright © 2019-2020 ANSSI

You need to update this header with an appropriate description and the 
copyright holder (your employer).


> + */
> +
> +#define _GNU_SOURCE
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <linux/landlock.h>
> +#include <string.h>
> +#include <sys/prctl.h>
> +#include <sys/socket.h>
> +#include <sys/types.h>
> +#include <netinet/in.h>
> +#include <arpa/inet.h>

To make it determinisitic (and ease patching/diff/merging), you should 
sort all the included files (in tests and in the kernel code).


> +
> +#include "common.h"
> +
> +#define SOCK_PORT_1 3470
> +#define SOCK_PORT_2 3480
> +#define SOCK_PORT_3 3490

To avoid port collision and create a clean and stable test environement 
(to avoid flaky tests), you should create a network namespace with 
FIXTURE_SETUP, test with TEST_F_FORK (to not polute the parent process, 
and which works with test variants), and use the set_cap and clear_cap 
helpers (see fs_test.c).


> +
> +#define IP_ADDRESS "127.0.0.1"
> +
> +/* Number pending connections queue tobe hold */
> +#define BACKLOG 10
> +
> +TEST(socket_bind_no_restrictions) {
> +
> +	int sockfd;
> +	struct sockaddr_in addr;
> +	const int one = 1;
> +
> +	/* Create a socket */
> +	sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));

With a dedicated namespace, SO_REUSEADDR should not be required.


> +
> +	/* Set socket address parameters */
> +	addr.sin_family = AF_INET;
> +	addr.sin_port = htons(SOCK_PORT_1);
> +	addr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr.sin_zero), '\0', 8);
> +
> +	/* Bind the socket to IP address */
> +	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)));
> +}
> +
> +TEST(sockets_bind_with_restrictions) {
> +
> +	int sockfd_1, sockfd_2, sockfd_3;
> +	struct sockaddr_in addr_1, addr_2, addr_3;
> +	const int one = 1;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = SOCK_PORT_1,
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = SOCK_PORT_2,
> +	};
> +	struct landlock_net_service_attr net_service_3 = {
> +		.allowed_access = 0,
> +		.port = SOCK_PORT_3,
> +	};

Good to have these three different rules!


> +
> +	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +			sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allow connect and bind operations to the SOCK_PORT_1 socket "object" */

You can omit "object" but use full sentences at the third person 
(because it explains what do the next lines).


> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_1, 0));
> +	/* Allow connect and deny bind operations to the SOCK_PORT_2 socket "object" */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_2, 0));
> +	/* Empty allowed_access (i.e. deny rules) are ignored in network actions
> +	 * for SOCK_PORT_3 socket "object"
> +	 */
> +	ASSERT_EQ(-1, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_3, 0));
> +	ASSERT_EQ(ENOMSG, errno);
> +
> +	/* Enforces the ruleset. */
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Create a socket 1 */
> +	sockfd_1 = socket(AF_INET, SOCK_STREAM, 0);

Please create all FD with SOCK_CLOEXEC and also close them when not 
needed. This could also reduce the number of FD.


> +	ASSERT_LE(0, sockfd_1);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd_1, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket 1 address parameters */
> +	addr_1.sin_family = AF_INET;
> +	addr_1.sin_port = htons(SOCK_PORT_1);
> +	addr_1.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr_1.sin_zero), '\0', 8);
> +	/* Bind the socket 1 to IP address */
> +	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr  *)&addr_1, sizeof(addr_1)));
> +
> +	/* Create a socket 2 */
> +	sockfd_2 = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd_2);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd_2, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket 2 address parameters */
> +	addr_2.sin_family = AF_INET;
> +	addr_2.sin_port = htons(SOCK_PORT_2);
> +	addr_2.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr_2.sin_zero), '\0', 8);

These part could be factored out with helpers or/and test variants.


> +	/* Bind the socket 2 to IP address */
> +	ASSERT_EQ(-1, bind(sockfd_2, (struct sockaddr *)&addr_2, sizeof(addr_2)));
> +	ASSERT_EQ(EACCES, errno);
> +
> +	/* Create a socket 3 */
> +	sockfd_3 = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd_3);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd_3, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket 3 address parameters */
> +	addr_3.sin_family = AF_INET;
> +	addr_3.sin_port = htons(SOCK_PORT_3);
> +	addr_3.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr_3.sin_zero), '\0', 8);
> +	/* Bind the socket 3 to IP address */
> +	ASSERT_EQ(0, bind(sockfd_3, (struct sockaddr *)&addr_3, sizeof(addr_3)));

Why is it allowed to bind to SOCK_PORT_3 whereas net_service_3 forbids it?


> +}
> +
> +TEST(socket_connect_no_restrictions) {
> +
> +	int sockfd, new_fd;
> +	struct sockaddr_in addr;
> +	pid_t child;
> +	int status;
> +	const int one = 1;
> +
> +	/* Create a server socket */
> +	sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket address parameters */
> +	addr.sin_family = AF_INET;
> +	addr.sin_port = htons(SOCK_PORT_1);
> +	addr.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr.sin_zero), '\0', 8);
> +
> +	/* Bind the socket to IP address */
> +	ASSERT_EQ(0, bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)));
> +
> +	/* Make listening socket */
> +	ASSERT_EQ(0, listen(sockfd, BACKLOG));
> +
> +	child = fork();
> +	ASSERT_LE(0, child);
> +	if (child == 0) {
> +		int child_sockfd;
> +		struct sockaddr_in connect_addr;
> +
> +		/* Close listening socket for the child */
> +		ASSERT_EQ(0, close(sockfd));
> +		/* Create a stream client socket */
> +		child_sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +		ASSERT_LE(0, child_sockfd);
> +
> +		/* Set server's socket address parameters*/
> +		connect_addr.sin_family = AF_INET;
> +		connect_addr.sin_port = htons(SOCK_PORT_1);
> +		connect_addr.sin_addr.s_addr = htonl(INADDR_ANY);
> +		memset(&(connect_addr.sin_zero), '\0', 8);
> +
> +		/* Make connection to the listening socket */
> +		ASSERT_EQ(0, connect(child_sockfd, (struct sockaddr *)&connect_addr,
> +					   sizeof(struct sockaddr)));
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +	/* Accept connection from the child */
> +	new_fd = accept(sockfd, NULL, 0);
> +	ASSERT_LE(0, new_fd);
> +
> +	/* Close connection */
> +	ASSERT_EQ(0, close(new_fd));
> +
> +	ASSERT_EQ(child, waitpid(child, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +}
> +
> +TEST(sockets_connect_with_restrictions) {
> +
> +	int new_fd;
> +	int sockfd_1, sockfd_2;
> +	struct sockaddr_in addr_1, addr_2;
> +	pid_t child_1, child_2;
> +	int status;
> +	const int one = 1;
> +
> +	struct landlock_ruleset_attr ruleset_attr = {
> +		.handled_access_net = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				      LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +	};
> +	struct landlock_net_service_attr net_service_1 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP |
> +				  LANDLOCK_ACCESS_NET_CONNECT_TCP,
> +		.port = SOCK_PORT_1,
> +	};
> +	struct landlock_net_service_attr net_service_2 = {
> +		.allowed_access = LANDLOCK_ACCESS_NET_BIND_TCP,
> +		.port = SOCK_PORT_2,
> +	};
> +
> +	const int ruleset_fd = landlock_create_ruleset(&ruleset_attr,
> +			sizeof(ruleset_attr), 0);
> +	ASSERT_LE(0, ruleset_fd);
> +
> +	/* Allow connect and bind operations to the SOCK_PORT_1 socket "object" */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_1, 0));
> +	/* Allow connect and deny bind operations to the SOCK_PORT_2 socket "object" */
> +	ASSERT_EQ(0, landlock_add_rule(ruleset_fd, LANDLOCK_RULE_NET_SERVICE,
> +				&net_service_2, 0));
> +
> +	/* Enforces the ruleset. */
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
> +	ASSERT_EQ(0, close(ruleset_fd));
> +
> +	/* Create a server socket 1 */
> +	sockfd_1 = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd_1);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd_1, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket 1 address parameters */
> +	addr_1.sin_family = AF_INET;
> +	addr_1.sin_port = htons(SOCK_PORT_1);
> +	addr_1.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr_1.sin_zero), '\0', 8);
> +
> +	/* Bind the socket 1 to IP address */
> +	ASSERT_EQ(0, bind(sockfd_1, (struct sockaddr *)&addr_1, sizeof(addr_1)));
> +
> +	/* Make listening socket 1 */
> +	ASSERT_EQ(0, listen(sockfd_1, BACKLOG));
> +
> +	child_1 = fork();
> +	ASSERT_LE(0, child_1);
> +	if (child_1 == 0) {
> +		int child_sockfd;
> +		struct sockaddr_in connect_addr;
> +
> +		/* Close listening socket for the child */
> +		ASSERT_EQ(0, close(sockfd_1));
> +		/* Create a stream client socket */
> +		child_sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +		ASSERT_LE(0, child_sockfd);
> +
> +		/* Set server's socket 1 address parameters*/
> +		connect_addr.sin_family = AF_INET;
> +		connect_addr.sin_port = htons(SOCK_PORT_1);
> +		connect_addr.sin_addr.s_addr = htonl(INADDR_ANY);
> +		memset(&(connect_addr.sin_zero), '\0', 8);
> +
> +		/* Make connection to the listening socket 1 */
> +		ASSERT_EQ(0, connect(child_sockfd, (struct sockaddr *)&connect_addr,
> +					   sizeof(struct sockaddr)));
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +	/* Accept connection from the child 1 */
> +	new_fd = accept(sockfd_1, NULL, 0);
> +	ASSERT_LE(0, new_fd);
> +
> +	/* Close connection */
> +	ASSERT_EQ(0, close(new_fd));
> +
> +	ASSERT_EQ(child_1, waitpid(child_1, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +
> +	/* Create a server socket 2 */
> +	sockfd_2 = socket(AF_INET, SOCK_STREAM, 0);
> +	ASSERT_LE(0, sockfd_2);
> +	/* Allow reuse of local addresses */
> +	ASSERT_EQ(0, setsockopt(sockfd_2, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one)));
> +
> +	/* Set socket 2 address parameters */
> +	addr_2.sin_family = AF_INET;
> +	addr_2.sin_port = htons(SOCK_PORT_2);
> +	addr_2.sin_addr.s_addr = inet_addr(IP_ADDRESS);
> +	memset(&(addr_2.sin_zero), '\0', 8);
> +
> +	/* Bind the socket 2 to IP address */
> +	ASSERT_EQ(0, bind(sockfd_2, (struct sockaddr *)&addr_2, sizeof(addr_2)));
> +
> +	/* Make listening socket 2 */
> +	ASSERT_EQ(0, listen(sockfd_2, BACKLOG));
> +
> +	child_2 = fork();
> +	ASSERT_LE(0, child_2);
> +	if (child_2 == 0) {
> +		int child_sockfd;
> +		struct sockaddr_in connect_addr;
> +
> +		/* Close listening socket for the child */
> +		ASSERT_EQ(0, close(sockfd_2));
> +		/* Create a stream client socket */
> +		child_sockfd = socket(AF_INET, SOCK_STREAM, 0);
> +		ASSERT_LE(0, child_sockfd);
> +
> +		/* Set server's socket address parameters*/
> +		connect_addr.sin_family = AF_INET;
> +		connect_addr.sin_port = htons(SOCK_PORT_2);
> +		connect_addr.sin_addr.s_addr = htonl(INADDR_ANY);
> +		memset(&(connect_addr.sin_zero), '\0', 8);
> +
> +		/* Make connection to the listening socket */
> +		ASSERT_EQ(-1, connect(child_sockfd, (struct sockaddr *)&connect_addr,
> +					   sizeof(struct sockaddr)));
> +		ASSERT_EQ(EACCES, errno);
> +		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
> +		return;
> +	}
> +
> +	ASSERT_EQ(child_2, waitpid(child_2, &status, 0));
> +	ASSERT_EQ(1, WIFEXITED(status));
> +	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
> +}
> +
> +TEST_HARNESS_MAIN
