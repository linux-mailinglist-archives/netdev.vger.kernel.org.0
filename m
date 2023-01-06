Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4118865FF09
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjAFKhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbjAFKhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:37:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7FD6C28A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:37:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v30so1691064edb.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 02:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mipcc5MufqCxFvtx1A9Osqfo2DYN60zWBd75DM224sQ=;
        b=eDNZ6KUJWI2h91Mz5pxv0r3iOhcIeoedo2rmfKTfCMdWqoL1Hu7QmS+8MeoNCQHkzN
         0StQ6NMvvi7GpnUX8+5xQFJMv2p6sNHnRIkm6uaL2+kgrm9XoF7MclOJ4jmq5IlPeooH
         bgE5JKcrPF1litOGqwttsGkXeWb6XjMbKa6W0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mipcc5MufqCxFvtx1A9Osqfo2DYN60zWBd75DM224sQ=;
        b=GAPNdvH+Nw2rbqZtjuxd35T7aQpjdXY9fXkOO1F5s2Ml9kul1JhOdjRy+gChu5YMBo
         RscjGoJPwISMHvg/108sEFI2th1T+tfqhdkO+BBsC3yYBfSoUpwNfEcXs8qY+mr3XqPD
         1Okk7yeApxu4KLz3hIIHOS2e5i31bUd0fnZq7tB0Wz7bkx3R90Mncb0RVfLQOI1byjh6
         IKSZzbyrtn3wy4OOXgEHGl7YGYpM/7uSWqVNKce14AfEDh5/K8WYtjgguFeCI2vU1rw2
         XsN3PW2AC3nYrmmC7rxpX6RzLYsPBSja7zhQmg6bp+Ec/0cd6R64o5qOimlRBRcGXbU/
         7EaQ==
X-Gm-Message-State: AFqh2krMM6orrfHjlxojOCkzmtpvXOhViI4kUBgdnF5vT8GRKKmApInM
        Ll/vOTxrfHjMSia66+NL1/WLybH+NsoE1D4m
X-Google-Smtp-Source: AMrXdXtpBafDNVu1GbWkdpaPBcd3ShpwyzXwQNGZktgtM4PeFAQotZoY4pE5DBXsGtlG4ntlhOJl0Q==
X-Received: by 2002:a05:6402:320e:b0:48e:c3f0:1b1b with SMTP id g14-20020a056402320e00b0048ec3f01b1bmr11816423eda.41.1673001464079;
        Fri, 06 Jan 2023 02:37:44 -0800 (PST)
Received: from cloudflare.com (79.184.146.66.ipv4.supernova.orange.pl. [79.184.146.66])
        by smtp.gmail.com with ESMTPSA id n11-20020a170906118b00b0081bfd407ad0sm274426eja.135.2023.01.06.02.37.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 02:37:43 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel-team@cloudflare.com
Subject: [PATCH net-next 2/2] selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option
Date:   Fri,  6 Jan 2023 11:37:38 +0100
Message-Id: <20221221-sockopt-port-range-v1-2-e2b094b60ffd@cloudflare.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com>
References: <20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Exercise IP_LOCAL_PORT_RANGE socket option in various scenarios:

1. pass invalid values to setsockopt
2. pass a range outside of the per-netns port range
3. configure a single-port range
4. exhaust a configured multi-port range
5. check interaction with late-bind (IP_BIND_ADDRESS_NO_PORT)
6. set then get the per-socket port range

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/ip_local_port_range.c  | 439 +++++++++++++++++++++
 tools/testing/selftests/net/ip_local_port_range.sh |   5 +
 3 files changed, 446 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3007e98a6d64..51b0b49ecd3b 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -45,6 +45,7 @@ TEST_PROGS += arp_ndisc_untracked_subnets.sh
 TEST_PROGS += stress_reuseport_listen.sh
 TEST_PROGS += l2_tos_ttl_inherit.sh
 TEST_PROGS += bind_bhash.sh
+TEST_PROGS += ip_local_port_range.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
@@ -75,6 +76,7 @@ TEST_GEN_PROGS += so_incoming_cpu
 TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
+TEST_GEN_FILES += ip_local_port_range
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
new file mode 100644
index 000000000000..272b0cb9fc57
--- /dev/null
+++ b/tools/testing/selftests/net/ip_local_port_range.c
@@ -0,0 +1,439 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2022 Cloudflare
+
+/* Test IP_LOCAL_PORT_RANGE socket option: IPv4 + IPv6, TCP + UDP.
+ *
+ * Tests assume that net.ipv4.ip_local_port_range is [40000, 49999].
+ * Don't run these directly but with ip_local_port_range.sh script.
+ */
+
+#include <fcntl.h>
+#include <netinet/ip.h>
+
+#include "../kselftest_harness.h"
+
+#ifndef IP_LOCAL_PORT_RANGE
+#define IP_LOCAL_PORT_RANGE 51
+#endif
+
+static __u32 pack_port_range(__u16 lo, __u16 hi)
+{
+	return (hi << 16) | (lo << 0);
+}
+
+static void unpack_port_range(__u32 range, __u16 *lo, __u16 *hi)
+{
+	*lo = range & 0xffff;
+	*hi = range >> 16;
+}
+
+static int get_so_domain(int fd)
+{
+	int domain, err;
+	socklen_t len;
+
+	len = sizeof(domain);
+	err = getsockopt(fd, SOL_SOCKET, SO_DOMAIN, &domain, &len);
+	if (err)
+		return -1;
+
+	return domain;
+}
+
+static int bind_to_loopback_any_port(int fd)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_in v4;
+		struct sockaddr_in6 v6;
+	} addr;
+	socklen_t addr_len;
+
+	memset(&addr, 0, sizeof(addr));
+	switch (get_so_domain(fd)) {
+	case AF_INET:
+		addr.v4.sin_family = AF_INET;
+		addr.v4.sin_port = htons(0);
+		addr.v4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		addr_len = sizeof(addr.v4);
+		break;
+	case AF_INET6:
+		addr.v6.sin6_family = AF_INET6;
+		addr.v6.sin6_port = htons(0);
+		addr.v6.sin6_addr = in6addr_loopback;
+		addr_len = sizeof(addr.v6);
+		break;
+	default:
+		return -1;
+	}
+
+	return bind(fd, &addr.sa, addr_len);
+}
+
+static int get_sock_port(int fd)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_in v4;
+		struct sockaddr_in6 v6;
+	} addr;
+	socklen_t addr_len;
+	int err;
+
+	addr_len = sizeof(addr);
+	memset(&addr, 0, sizeof(addr));
+	err = getsockname(fd, &addr.sa, &addr_len);
+	if (err)
+		return -1;
+
+	switch (addr.sa.sa_family) {
+	case AF_INET:
+		return ntohs(addr.v4.sin_port);
+	case AF_INET6:
+		return ntohs(addr.v6.sin6_port);
+	default:
+		errno = EAFNOSUPPORT;
+		return -1;
+	}
+}
+
+static int get_ip_local_port_range(int fd, __u32 *range)
+{
+	socklen_t len;
+	__u32 val;
+	int err;
+
+	len = sizeof(val);
+	err = getsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val, &len);
+	if (err)
+		return -1;
+
+	*range = val;
+	return 0;
+}
+
+static const char *so_domain_to_str(int domain)
+{
+	switch (domain) {
+	case AF_INET:
+		return "ip4";
+	case AF_INET6:
+		return "ip6";
+	default:
+		__builtin_unreachable();
+	}
+}
+
+static const char *so_type_to_str(int type)
+{
+	switch (type) {
+	case SOCK_STREAM:
+		return "tcp";
+	case SOCK_DGRAM:
+		return "udp";
+	default:
+		__builtin_unreachable();
+	}
+}
+
+const struct socket_kind {
+	int domain;
+	int type;
+} socket_matrix[] = {
+	{ AF_INET, SOCK_STREAM },
+	{ AF_INET, SOCK_DGRAM },
+	{ AF_INET6, SOCK_STREAM },
+	{ AF_INET6, SOCK_DGRAM },
+};
+
+#define for_each_socket_kind(sk) \
+	for ((sk) = socket_matrix; \
+	     (sk) < socket_matrix + ARRAY_SIZE(socket_matrix) && log_socket_kind((sk)); \
+	     (sk)++)
+
+#define log_socket_kind(sk)			       \
+	({					       \
+		TH_LOG("%s/%s",			       \
+		       so_domain_to_str((sk)->domain), \
+		       so_type_to_str((sk)->type));    \
+		true;				       \
+	})
+
+TEST(invalid_option_value)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		__u16 val16;
+		__u32 val32;
+		__u64 val64;
+		int fd, err;
+
+		fd = socket(sk->domain, sk->type, 0);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		/* Too few bytes */
+		val16 = 40000;
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val16, sizeof(val16));
+		EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+		EXPECT_EQ(errno, EINVAL);
+
+		/* Empty range: low port > high port */
+		val32 = pack_port_range(40222, 40111);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val32, sizeof(val32));
+		EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+		EXPECT_EQ(errno, EINVAL);
+
+		/* Too many bytes */
+		val64 = pack_port_range(40333, 40444);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val64, sizeof(val64));
+		EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+		EXPECT_EQ(errno, EINVAL);
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST(sock_port_range_out_of_netns_range)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		int fd, err, port;
+		__u32 range;
+
+		fd = socket(sk->domain, sk->type, 0);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		range = pack_port_range(50000, 50111);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		err = bind_to_loopback_any_port(fd);
+		ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+		/* Check that socket port range outside of ephemeral range is ignored */
+		port = get_sock_port(fd);
+		ASSERT_GE(port, 40000) TH_LOG("expected port within ephemeral range");
+		ASSERT_LE(port, 49999) TH_LOG("expected port within ephemeral range");
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST(single_port_range)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		struct test {
+			__u16 range_lo;
+			__u16 range_hi;
+			__u16 expected;
+		} tests[] = {
+			/* single port range within ephemeral range */
+			{ 45000, 45000, 45000 },
+			/* first port in the ephemeral range (clamp from above) */
+			{ 0, 40000, 40000 },
+			/* last port in the ephemeral range (clamp from below)  */
+			{ 49999, 0, 49999 },
+		};
+		struct test *t;
+
+		for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+			int fd, err, port;
+			__u32 range;
+
+			TH_LOG("lo %5hu, hi %5hu, expected %5hu",
+			       t->range_lo, t->range_hi, t->expected);
+
+			fd = socket(sk->domain, sk->type, 0);
+			ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+			range = pack_port_range(t->range_lo, t->range_hi);
+			err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+			ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+			err = bind_to_loopback_any_port(fd);
+			ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+			port = get_sock_port(fd);
+			ASSERT_EQ(port, t->expected) TH_LOG("unexpected local port");
+
+			err = close(fd);
+			ASSERT_TRUE(!err) TH_LOG("close failed");
+		}
+	}
+}
+
+TEST(exhaust_8_port_range)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		__u8 port_set = 0;
+		int i, fd, err;
+		__u32 range;
+		__u16 port;
+		int fds[8];
+
+		for (i = 0; i < ARRAY_SIZE(fds); i++) {
+			fd = socket(sk->domain, sk->type, 0);
+			ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+			range = pack_port_range(40000, 40007);
+			err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+			ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+			err = bind_to_loopback_any_port(fd);
+			ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+			port = get_sock_port(fd);
+			ASSERT_GE(port, 40000) TH_LOG("expected port within sockopt range");
+			ASSERT_LE(port, 40007) TH_LOG("expected port within sockopt range");
+
+			port_set |= 1 << (port - 40000);
+			fds[i] = fd;
+		}
+
+		/* Check that all every port from the test range is in use */
+		ASSERT_EQ(port_set, 0xff) TH_LOG("expected all ports to be busy");
+
+		/* Check that bind() fails because the whole range is busy */
+		fd = socket(sk->domain, sk->type, 0);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		range = pack_port_range(40000, 40007);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		err = bind_to_loopback_any_port(fd);
+		ASSERT_TRUE(err) TH_LOG("expected bind to fail");
+		ASSERT_EQ(errno, EADDRINUSE);
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+
+		for (i = 0; i < ARRAY_SIZE(fds); i++) {
+			err = close(fds[i]);
+			ASSERT_TRUE(!err) TH_LOG("close failed");
+		}
+	}
+}
+
+TEST(late_bind)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		union {
+			struct sockaddr sa;
+			struct sockaddr_in v4;
+			struct sockaddr_in6 v6;
+		} addr;
+		socklen_t addr_len;
+		const int one = 1;
+		int fd, err;
+		__u32 range;
+		__u16 port;
+
+		fd = socket(sk->domain, sk->type, 0);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		range = pack_port_range(40100, 40199);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		err = setsockopt(fd, SOL_IP, IP_BIND_ADDRESS_NO_PORT, &one, sizeof(one));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_BIND_ADDRESS_NO_PORT) failed");
+
+		err = bind_to_loopback_any_port(fd);
+		ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+		port = get_sock_port(fd);
+		ASSERT_EQ(port, 0) TH_LOG("getsockname failed");
+
+		/* Invalid destination */
+		memset(&addr, 0, sizeof(addr));
+		switch (sk->domain) {
+		case AF_INET:
+			addr.v4.sin_family = AF_INET;
+			addr.v4.sin_port = htons(0);
+			addr.v4.sin_addr.s_addr = htonl(INADDR_ANY);
+			addr_len = sizeof(addr.v4);
+			break;
+		case AF_INET6:
+			addr.v6.sin6_family = AF_INET6;
+			addr.v6.sin6_port = htons(0);
+			addr.v6.sin6_addr = in6addr_any;
+			addr_len = sizeof(addr.v6);
+			break;
+		default:
+			ASSERT_TRUE(false) TH_LOG("unsupported socket domain");
+		}
+
+		/* connect() doesn't need to succeed for late bind to happen */
+		connect(fd, &addr.sa, addr_len);
+
+		port = get_sock_port(fd);
+		ASSERT_GE(port, 40100);
+		ASSERT_LE(port, 40199);
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST(get_port_range)
+{
+	const struct socket_kind *sk;
+
+	for_each_socket_kind(sk) {
+		__u16 lo, hi;
+		__u32 range;
+		int fd, err;
+
+		fd = socket(sk->domain, sk->type, 0);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		/* Get range before it will be set */
+		err = get_ip_local_port_range(fd, &range);
+		ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		unpack_port_range(range, &lo, &hi);
+		ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
+		ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
+
+		range = pack_port_range(12345, 54321);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		/* Get range after it has been set */
+		err = get_ip_local_port_range(fd, &range);
+		ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		unpack_port_range(range, &lo, &hi);
+		ASSERT_EQ(lo, 12345) TH_LOG("unexpected low port");
+		ASSERT_EQ(hi, 54321) TH_LOG("unexpected high port");
+
+		/* Unset the port range  */
+		range = pack_port_range(0, 0);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		/* Get range after it has been unset */
+		err = get_ip_local_port_range(fd, &range);
+		ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		unpack_port_range(range, &lo, &hi);
+		ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
+		ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/net/ip_local_port_range.sh b/tools/testing/selftests/net/ip_local_port_range.sh
new file mode 100755
index 000000000000..6c6ad346eaa0
--- /dev/null
+++ b/tools/testing/selftests/net/ip_local_port_range.sh
@@ -0,0 +1,5 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+./in_netns.sh \
+  sh -c 'sysctl -q -w net.ipv4.ip_local_port_range="40000 49999" && ./ip_local_port_range'

-- 
2.38.1
