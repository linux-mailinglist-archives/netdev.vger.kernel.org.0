Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F75B665115
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 02:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbjAKBZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 20:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbjAKBZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 20:25:19 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBF4C19
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673400318; x=1704936318;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+a0qjHLVHB0aRY0Qc2L6EslhX/MB59IjAXhTqy/3670=;
  b=M9kbcJgIiJyraiS0MzUsImYbtijxiwER05hc5LFsLOa5w/snTvBv5t1e
   2I+sP4bvoM2wCVVs8Bmih3wIafiqSbEFbe9ZO0S8GF4/Su/reWbXxcLao
   MxayPz2L0f0A00eu75SZGtXuqqKvYfcpzs5wYQiAIEuLorGKRixdL1R15
   0=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="287126670"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 01:25:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id 1CC18A3061;
        Wed, 11 Jan 2023 01:25:13 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 11 Jan 2023 01:25:12 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Wed, 11 Jan 2023 01:25:09 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <jakub@cloudflare.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <kernel-team@cloudflare.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 2/2] selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option
Date:   Wed, 11 Jan 2023 10:25:00 +0900
Message-ID: <20230111012500.48018-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221-sockopt-port-range-v2-2-1d5f114bf627@cloudflare.com>
References: <20221221-sockopt-port-range-v2-2-1d5f114bf627@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D43UWA001.ant.amazon.com (10.43.160.44) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Tue, 10 Jan 2023 14:37:30 +0100
> Exercise IP_LOCAL_PORT_RANGE socket option in various scenarios:
> 
> 1. pass invalid values to setsockopt
> 2. pass a range outside of the per-netns port range
> 3. configure a single-port range
> 4. exhaust a configured multi-port range
> 5. check interaction with late-bind (IP_BIND_ADDRESS_NO_PORT)
> 6. set then get the per-socket port range
> 
> v1 -> v2:
>  * selftests: Instead of iterating over socket families (ip4, ip6) and types
>    (tcp, udp), generate tests for each combo from a template. This keeps the
>    code indentation level down and makes tests more granular.

We can use TEST_F(), FIXTURE_VARIANT() and FIXTURE_VARIANT_ADD() for
such cases.

e.g.) tools/testing/selftests/net/tls.c


> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/testing/selftests/net/Makefile               |   2 +
>  tools/testing/selftests/net/ip_local_port_range.c  | 439 +++++++++++++++++++++
>  tools/testing/selftests/net/ip_local_port_range.sh |   5 +
>  3 files changed, 446 insertions(+)
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 3007e98a6d64..51b0b49ecd3b 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -45,6 +45,7 @@ TEST_PROGS += arp_ndisc_untracked_subnets.sh
>  TEST_PROGS += stress_reuseport_listen.sh
>  TEST_PROGS += l2_tos_ttl_inherit.sh
>  TEST_PROGS += bind_bhash.sh
> +TEST_PROGS += ip_local_port_range.sh
>  TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
>  TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
>  TEST_GEN_FILES =  socket nettest
> @@ -75,6 +76,7 @@ TEST_GEN_PROGS += so_incoming_cpu
>  TEST_PROGS += sctp_vrf.sh
>  TEST_GEN_FILES += sctp_hello
>  TEST_GEN_FILES += csum
> +TEST_GEN_FILES += ip_local_port_range
>  
>  TEST_FILES := settings
>  
> diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
> new file mode 100644
> index 000000000000..8bbb32b47527
> --- /dev/null
> +++ b/tools/testing/selftests/net/ip_local_port_range.c
> @@ -0,0 +1,439 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +// Copyright (c) 2023 Cloudflare
> +
> +/* Test IP_LOCAL_PORT_RANGE socket option: IPv4 + IPv6, TCP + UDP.
> + *
> + * Tests assume that net.ipv4.ip_local_port_range is [40000, 49999].
> + * Don't run these directly but with ip_local_port_range.sh script.
> + */
> +
> +#ifndef TEMPLATE
> +
> +#include <fcntl.h>
> +#include <netinet/ip.h>
> +
> +#include "../kselftest_harness.h"
> +
> +#ifndef IP_LOCAL_PORT_RANGE
> +#define IP_LOCAL_PORT_RANGE 51
> +#endif
> +
> +static __u32 pack_port_range(__u16 lo, __u16 hi)
> +{
> +	return (hi << 16) | (lo << 0);
> +}
> +
> +static void unpack_port_range(__u32 range, __u16 *lo, __u16 *hi)
> +{
> +	*lo = range & 0xffff;
> +	*hi = range >> 16;
> +}
> +
> +static int get_so_domain(int fd)
> +{
> +	int domain, err;
> +	socklen_t len;
> +
> +	len = sizeof(domain);
> +	err = getsockopt(fd, SOL_SOCKET, SO_DOMAIN, &domain, &len);
> +	if (err)
> +		return -1;
> +
> +	return domain;
> +}
> +
> +static int bind_to_loopback_any_port(int fd)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_in v4;
> +		struct sockaddr_in6 v6;
> +	} addr;
> +	socklen_t addr_len;
> +
> +	memset(&addr, 0, sizeof(addr));
> +	switch (get_so_domain(fd)) {
> +	case AF_INET:
> +		addr.v4.sin_family = AF_INET;
> +		addr.v4.sin_port = htons(0);
> +		addr.v4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
> +		addr_len = sizeof(addr.v4);
> +		break;
> +	case AF_INET6:
> +		addr.v6.sin6_family = AF_INET6;
> +		addr.v6.sin6_port = htons(0);
> +		addr.v6.sin6_addr = in6addr_loopback;
> +		addr_len = sizeof(addr.v6);
> +		break;
> +	default:
> +		return -1;
> +	}
> +
> +	return bind(fd, &addr.sa, addr_len);
> +}
> +
> +static int get_sock_port(int fd)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_in v4;
> +		struct sockaddr_in6 v6;
> +	} addr;
> +	socklen_t addr_len;
> +	int err;
> +
> +	addr_len = sizeof(addr);
> +	memset(&addr, 0, sizeof(addr));
> +	err = getsockname(fd, &addr.sa, &addr_len);
> +	if (err)
> +		return -1;
> +
> +	switch (addr.sa.sa_family) {
> +	case AF_INET:
> +		return ntohs(addr.v4.sin_port);
> +	case AF_INET6:
> +		return ntohs(addr.v6.sin6_port);
> +	default:
> +		errno = EAFNOSUPPORT;
> +		return -1;
> +	}
> +}
> +
> +static int get_ip_local_port_range(int fd, __u32 *range)
> +{
> +	socklen_t len;
> +	__u32 val;
> +	int err;
> +
> +	len = sizeof(val);
> +	err = getsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val, &len);
> +	if (err)
> +		return -1;
> +
> +	*range = val;
> +	return 0;
> +}
> +
> +#else  /* TEMPLATE */
> +
> +T(invalid_option_value)
> +{
> +	__u16 val16;
> +	__u32 val32;
> +	__u64 val64;
> +	int fd, err;
> +
> +	fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +	ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +	/* Too few bytes */
> +	val16 = 40000;
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val16, sizeof(val16));
> +	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
> +	EXPECT_EQ(errno, EINVAL);
> +
> +	/* Empty range: low port > high port */
> +	val32 = pack_port_range(40222, 40111);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val32, sizeof(val32));
> +	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
> +	EXPECT_EQ(errno, EINVAL);
> +
> +	/* Too many bytes */
> +	val64 = pack_port_range(40333, 40444);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val64, sizeof(val64));
> +	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
> +	EXPECT_EQ(errno, EINVAL);
> +
> +	err = close(fd);
> +	ASSERT_TRUE(!err) TH_LOG("close failed");
> +}
> +
> +T(sock_port_range_out_of_netns_range)
> +{
> +	const struct test {
> +		__u16 range_lo;
> +		__u16 range_hi;
> +	} tests[] = {
> +		{ 30000, 39999 }, /* socket range below netns range */
> +		{ 50000, 59999 }, /* socket range above netns range */
> +	};
> +	const struct test *t;
> +
> +	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
> +		/* Bind a couple of sockets, not just one, to check
> +		 * that the range wasn't clamped to a single port from
> +		 * the netns range. That is [40000, 40000] or [49999,
> +		 * 49999], respectively for each test case.
> +		 */
> +		int fds[2], i;
> +
> +		TH_LOG("lo %5hu, hi %5hu", t->range_lo, t->range_hi);
> +
> +		for (i = 0; i < ARRAY_SIZE(fds); i++) {
> +			int fd, err, port;
> +			__u32 range;
> +
> +			fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +			ASSERT_GE(fd, 0) TH_LOG("#%d: socket failed", i);
> +
> +			range = pack_port_range(t->range_lo, t->range_hi);
> +			err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +			ASSERT_TRUE(!err) TH_LOG("#%d: setsockopt(IP_LOCAL_PORT_RANGE) failed", i);
> +
> +			err = bind_to_loopback_any_port(fd);
> +			ASSERT_TRUE(!err) TH_LOG("#%d: bind failed", i);
> +
> +			/* Check that socket port range outside of ephemeral range is ignored */
> +			port = get_sock_port(fd);
> +			ASSERT_GE(port, 40000) TH_LOG("#%d: expected port within netns range", i);
> +			ASSERT_LE(port, 49999) TH_LOG("#%d: expected port within netns range", i);
> +
> +			fds[i] = fd;
> +		}
> +
> +		for (i = 0; i < ARRAY_SIZE(fds); i++)
> +			ASSERT_TRUE(close(fds[i]) == 0) TH_LOG("#%d: close failed", i);
> +	}
> +}
> +
> +T(single_port_range)
> +{
> +	const struct test {
> +		__u16 range_lo;
> +		__u16 range_hi;
> +		__u16 expected;
> +	} tests[] = {
> +		/* single port range within ephemeral range */
> +		{ 45000, 45000, 45000 },
> +		/* first port in the ephemeral range (clamp from above) */
> +		{ 0, 40000, 40000 },
> +		/* last port in the ephemeral range (clamp from below)  */
> +		{ 49999, 0, 49999 },
> +	};
> +	const struct test *t;
> +
> +	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
> +		int fd, err, port;
> +		__u32 range;
> +
> +		TH_LOG("lo %5hu, hi %5hu, expected %5hu",
> +		       t->range_lo, t->range_hi, t->expected);
> +
> +		fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +		ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +		range = pack_port_range(t->range_lo, t->range_hi);
> +		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +		err = bind_to_loopback_any_port(fd);
> +		ASSERT_TRUE(!err) TH_LOG("bind failed");
> +
> +		port = get_sock_port(fd);
> +		ASSERT_EQ(port, t->expected) TH_LOG("unexpected local port");
> +
> +		err = close(fd);
> +		ASSERT_TRUE(!err) TH_LOG("close failed");
> +	}
> +}
> +
> +T(exhaust_8_port_range)
> +{
> +	__u8 port_set = 0;
> +	int i, fd, err;
> +	__u32 range;
> +	__u16 port;
> +	int fds[8];
> +
> +	for (i = 0; i < ARRAY_SIZE(fds); i++) {
> +		fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +		ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +		range = pack_port_range(40000, 40007);
> +		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +		err = bind_to_loopback_any_port(fd);
> +		ASSERT_TRUE(!err) TH_LOG("bind failed");
> +
> +		port = get_sock_port(fd);
> +		ASSERT_GE(port, 40000) TH_LOG("expected port within sockopt range");
> +		ASSERT_LE(port, 40007) TH_LOG("expected port within sockopt range");
> +
> +		port_set |= 1 << (port - 40000);
> +		fds[i] = fd;
> +	}
> +
> +	/* Check that all every port from the test range is in use */
> +	ASSERT_EQ(port_set, 0xff) TH_LOG("expected all ports to be busy");
> +
> +	/* Check that bind() fails because the whole range is busy */
> +	fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +	ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +	range = pack_port_range(40000, 40007);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	err = bind_to_loopback_any_port(fd);
> +	ASSERT_TRUE(err) TH_LOG("expected bind to fail");
> +	ASSERT_EQ(errno, EADDRINUSE);
> +
> +	err = close(fd);
> +	ASSERT_TRUE(!err) TH_LOG("close failed");
> +
> +	for (i = 0; i < ARRAY_SIZE(fds); i++) {
> +		err = close(fds[i]);
> +		ASSERT_TRUE(!err) TH_LOG("close failed");
> +	}
> +}
> +
> +T(late_bind)
> +{
> +	union {
> +		struct sockaddr sa;
> +		struct sockaddr_in v4;
> +		struct sockaddr_in6 v6;
> +	} addr;
> +	socklen_t addr_len;
> +	const int one = 1;
> +	int fd, err;
> +	__u32 range;
> +	__u16 port;
> +
> +	fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +	ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +	range = pack_port_range(40100, 40199);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	err = setsockopt(fd, SOL_IP, IP_BIND_ADDRESS_NO_PORT, &one, sizeof(one));
> +	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_BIND_ADDRESS_NO_PORT) failed");
> +
> +	err = bind_to_loopback_any_port(fd);
> +	ASSERT_TRUE(!err) TH_LOG("bind failed");
> +
> +	port = get_sock_port(fd);
> +	ASSERT_EQ(port, 0) TH_LOG("getsockname failed");
> +
> +	/* Invalid destination */
> +	memset(&addr, 0, sizeof(addr));
> +	switch (T_SO_DOMAIN) {
> +	case AF_INET:
> +		addr.v4.sin_family = AF_INET;
> +		addr.v4.sin_port = htons(0);
> +		addr.v4.sin_addr.s_addr = htonl(INADDR_ANY);
> +		addr_len = sizeof(addr.v4);
> +		break;
> +	case AF_INET6:
> +		addr.v6.sin6_family = AF_INET6;
> +		addr.v6.sin6_port = htons(0);
> +		addr.v6.sin6_addr = in6addr_any;
> +		addr_len = sizeof(addr.v6);
> +		break;
> +	default:
> +		ASSERT_TRUE(false) TH_LOG("unsupported socket domain");
> +	}
> +
> +	/* connect() doesn't need to succeed for late bind to happen */
> +	connect(fd, &addr.sa, addr_len);
> +
> +	port = get_sock_port(fd);
> +	ASSERT_GE(port, 40100);
> +	ASSERT_LE(port, 40199);
> +
> +	err = close(fd);
> +	ASSERT_TRUE(!err) TH_LOG("close failed");
> +}
> +
> +T(get_port_range)
> +{
> +	__u16 lo, hi;
> +	__u32 range;
> +	int fd, err;
> +
> +	fd = socket(T_SO_DOMAIN, T_SO_TYPE, 0);
> +	ASSERT_GE(fd, 0) TH_LOG("socket failed");
> +
> +	/* Get range before it will be set */
> +	err = get_ip_local_port_range(fd, &range);
> +	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	unpack_port_range(range, &lo, &hi);
> +	ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
> +	ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
> +
> +	range = pack_port_range(12345, 54321);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	/* Get range after it has been set */
> +	err = get_ip_local_port_range(fd, &range);
> +	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	unpack_port_range(range, &lo, &hi);
> +	ASSERT_EQ(lo, 12345) TH_LOG("unexpected low port");
> +	ASSERT_EQ(hi, 54321) TH_LOG("unexpected high port");
> +
> +	/* Unset the port range  */
> +	range = pack_port_range(0, 0);
> +	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
> +	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	/* Get range after it has been unset */
> +	err = get_ip_local_port_range(fd, &range);
> +	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
> +
> +	unpack_port_range(range, &lo, &hi);
> +	ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
> +	ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
> +
> +	err = close(fd);
> +	ASSERT_TRUE(!err) TH_LOG("close failed");
> +}
> +
> +#endif  /* TEMPLATE */
> +
> +#ifndef TEMPLATE
> +#define TEMPLATE
> +
> +#define T(name)			_T(name, T_SUFFIX)
> +#define _T(name, suffix)	__T(name, suffix)
> +#define __T(name, suffix)	TEST(name ## _ ## suffix)
> +
> +#define T_SUFFIX	ip4_tcp
> +#define T_SO_DOMAIN	AF_INET
> +#define T_SO_TYPE	SOCK_STREAM
> +#include __FILE__
> +#undef T_SUFFIX
> +#undef T_SO_DOMAIN
> +#undef T_SO_TYPE
> +
> +#define T_SUFFIX	ip4_udp
> +#define T_SO_DOMAIN	AF_INET
> +#define T_SO_TYPE	SOCK_DGRAM
> +#include __FILE__
> +#undef T_SUFFIX
> +#undef T_SO_DOMAIN
> +#undef T_SO_TYPE
> +
> +#define T_SUFFIX	ip6_tcp
> +#define T_SO_DOMAIN	AF_INET
> +#define T_SO_TYPE	SOCK_STREAM
> +#include __FILE__
> +#undef T_SUFFIX
> +#undef T_SO_DOMAIN
> +#undef T_SO_TYPE
> +
> +#define T_SUFFIX	ip6_udp
> +#define T_SO_DOMAIN	AF_INET
> +#define T_SO_TYPE	SOCK_DGRAM
> +#include __FILE__
> +#undef T_SUFFIX
> +#undef T_SO_DOMAIN
> +#undef T_SO_TYPE
> +
> +TEST_HARNESS_MAIN
> +
> +#endif	/* TEMPLATE */
> diff --git a/tools/testing/selftests/net/ip_local_port_range.sh b/tools/testing/selftests/net/ip_local_port_range.sh
> new file mode 100755
> index 000000000000..6c6ad346eaa0
> --- /dev/null
> +++ b/tools/testing/selftests/net/ip_local_port_range.sh
> @@ -0,0 +1,5 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./in_netns.sh \
> +  sh -c 'sysctl -q -w net.ipv4.ip_local_port_range="40000 49999" && ./ip_local_port_range'
> 
> -- 
> 2.39.0
