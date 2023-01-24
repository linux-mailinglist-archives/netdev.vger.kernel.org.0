Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA32867995D
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjAXNhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXNhC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:37:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229A5C154
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:37:00 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id hw16so38983495ejc.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 05:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UQDabh4jvNhko2uGbQ844mLYaNxuCW8WALGDa2l1IUM=;
        b=Lk2hvJGL5kt3KZgHgftYuLti2JVl/FGmV1hW8Y8fxHLbb14MAp6nKTvWDKOlgVzSb4
         j5nbBDKD0XHH/idLhpHABPwpzQkg5f+cwbAshBYwaRLncx6TFz4fXX6cs8TCRA6b6Ic6
         GnJfjEUpTTKrg0Suqgj5BRUb/T3sysI7sZrgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQDabh4jvNhko2uGbQ844mLYaNxuCW8WALGDa2l1IUM=;
        b=31ukQPNcHWoT8ia6euNmwJUU+2ZYYxfsSZjcoTEGBn0A44mARIvN3bU81LcW/5usyh
         UJEub2aIl6If21nqFXVVo2cgEXOoo0nEINg6WMRpvbZylea6h3RFXYXtR/4yfsrF6xQa
         12GQ9rz3/9myGdNpErIsYu5Jrfg+yy46FYl0YvgEs52QWgm57BgsQMPV0l2TojkQv3dH
         LtjjCDMd1Ag1tkeabSALRs4xXaSdqgswaqvqILvjn8xIGcoFkaHvFjQl2p6iBdwMaeyg
         fFUcS7cz30d/+gjDfeIryrf8a+s5O4zFU3QvIA476/il02Vop1iRyGX6tUCTSaFSYl3F
         +eNA==
X-Gm-Message-State: AFqh2kqMy+7M/fBJLIH1aaZg3DXYVbmcflcESVZp5C72B14bryEnJNOp
        fDPVDldt1lRmRxj7yLAZj7nJwQ==
X-Google-Smtp-Source: AMrXdXs2WoIpt+2JWAWJvSMwdBT1vMesyifVqW2cY0fL7lS1RHT1UBDJN8acqWlY2nT1ShZUnTGU6A==
X-Received: by 2002:a17:907:d401:b0:872:1b27:1a43 with SMTP id vi1-20020a170907d40100b008721b271a43mr32564127ejc.31.1674567418489;
        Tue, 24 Jan 2023 05:36:58 -0800 (PST)
Received: from cloudflare.com (79.184.123.123.ipv4.supernova.orange.pl. [79.184.123.123])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7cc0a000000b00495c3573b36sm1056724edt.32.2023.01.24.05.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 05:36:58 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
Date:   Tue, 24 Jan 2023 14:36:44 +0100
Subject: [PATCH net-next v6 2/2] selftests/net: Cover the IP_LOCAL_PORT_RANGE
 socket option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221221-sockopt-port-range-v6-2-be255cc0e51f@cloudflare.com>
References: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
In-Reply-To: <20221221-sockopt-port-range-v6-0-be255cc0e51f@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>,
        Leon Romanovsky <leon@kernel.org>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
X-Mailer: b4 0.11.0
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

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
v2 -> v3:
 * Switch from CPP-based templates to FIXTURE_VARIANT. (Kuniyuki)
 * Cover SOCK_STREAM/IPPROTO_SCTP where possible.

v1 -> v2:
 * selftests: Instead of iterating over socket families (ip4, ip6) and
   types (tcp, udp), generate tests for each combo from a template. This
   keeps the code indentation level down and makes tests more granular.
---
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/ip_local_port_range.c  | 447 +++++++++++++++++++++
 tools/testing/selftests/net/ip_local_port_range.sh |   5 +
 3 files changed, 454 insertions(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 47314f0b3006..951bd5342bc6 100644
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
@@ -76,6 +77,7 @@ TEST_PROGS += sctp_vrf.sh
 TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
+TEST_GEN_FILES += ip_local_port_range
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
new file mode 100644
index 000000000000..75e3fdacdf73
--- /dev/null
+++ b/tools/testing/selftests/net/ip_local_port_range.c
@@ -0,0 +1,447 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2023 Cloudflare
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
+FIXTURE(ip_local_port_range) {};
+
+FIXTURE_SETUP(ip_local_port_range)
+{
+}
+
+FIXTURE_TEARDOWN(ip_local_port_range)
+{
+}
+
+FIXTURE_VARIANT(ip_local_port_range) {
+	int so_domain;
+	int so_type;
+	int so_protocol;
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip4_tcp) {
+	.so_domain	= AF_INET,
+	.so_type	= SOCK_STREAM,
+	.so_protocol	= 0,
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip4_udp) {
+	.so_domain	= AF_INET,
+	.so_type	= SOCK_DGRAM,
+	.so_protocol	= 0,
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip4_stcp) {
+	.so_domain	= AF_INET,
+	.so_type	= SOCK_STREAM,
+	.so_protocol	= IPPROTO_SCTP,
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip6_tcp) {
+	.so_domain	= AF_INET6,
+	.so_type	= SOCK_STREAM,
+	.so_protocol	= 0,
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip6_udp) {
+	.so_domain	= AF_INET6,
+	.so_type	= SOCK_DGRAM,
+	.so_protocol	= 0,
+};
+
+FIXTURE_VARIANT_ADD(ip_local_port_range, ip6_stcp) {
+	.so_domain	= AF_INET6,
+	.so_type	= SOCK_STREAM,
+	.so_protocol	= IPPROTO_SCTP,
+};
+
+TEST_F(ip_local_port_range, invalid_option_value)
+{
+	__u16 val16;
+	__u32 val32;
+	__u64 val64;
+	int fd, err;
+
+	fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+	ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+	/* Too few bytes */
+	val16 = 40000;
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val16, sizeof(val16));
+	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+	EXPECT_EQ(errno, EINVAL);
+
+	/* Empty range: low port > high port */
+	val32 = pack_port_range(40222, 40111);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val32, sizeof(val32));
+	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+	EXPECT_EQ(errno, EINVAL);
+
+	/* Too many bytes */
+	val64 = pack_port_range(40333, 40444);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &val64, sizeof(val64));
+	EXPECT_TRUE(err) TH_LOG("expected setsockopt(IP_LOCAL_PORT_RANGE) to fail");
+	EXPECT_EQ(errno, EINVAL);
+
+	err = close(fd);
+	ASSERT_TRUE(!err) TH_LOG("close failed");
+}
+
+TEST_F(ip_local_port_range, port_range_out_of_netns_range)
+{
+	const struct test {
+		__u16 range_lo;
+		__u16 range_hi;
+	} tests[] = {
+		{ 30000, 39999 }, /* socket range below netns range */
+		{ 50000, 59999 }, /* socket range above netns range */
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		/* Bind a couple of sockets, not just one, to check
+		 * that the range wasn't clamped to a single port from
+		 * the netns range. That is [40000, 40000] or [49999,
+		 * 49999], respectively for each test case.
+		 */
+		int fds[2], i;
+
+		TH_LOG("lo %5hu, hi %5hu", t->range_lo, t->range_hi);
+
+		for (i = 0; i < ARRAY_SIZE(fds); i++) {
+			int fd, err, port;
+			__u32 range;
+
+			fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+			ASSERT_GE(fd, 0) TH_LOG("#%d: socket failed", i);
+
+			range = pack_port_range(t->range_lo, t->range_hi);
+			err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+			ASSERT_TRUE(!err) TH_LOG("#%d: setsockopt(IP_LOCAL_PORT_RANGE) failed", i);
+
+			err = bind_to_loopback_any_port(fd);
+			ASSERT_TRUE(!err) TH_LOG("#%d: bind failed", i);
+
+			/* Check that socket port range outside of ephemeral range is ignored */
+			port = get_sock_port(fd);
+			ASSERT_GE(port, 40000) TH_LOG("#%d: expected port within netns range", i);
+			ASSERT_LE(port, 49999) TH_LOG("#%d: expected port within netns range", i);
+
+			fds[i] = fd;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(fds); i++)
+			ASSERT_TRUE(close(fds[i]) == 0) TH_LOG("#%d: close failed", i);
+	}
+}
+
+TEST_F(ip_local_port_range, single_port_range)
+{
+	const struct test {
+		__u16 range_lo;
+		__u16 range_hi;
+		__u16 expected;
+	} tests[] = {
+		/* single port range within ephemeral range */
+		{ 45000, 45000, 45000 },
+		/* first port in the ephemeral range (clamp from above) */
+		{ 0, 40000, 40000 },
+		/* last port in the ephemeral range (clamp from below)  */
+		{ 49999, 0, 49999 },
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		int fd, err, port;
+		__u32 range;
+
+		TH_LOG("lo %5hu, hi %5hu, expected %5hu",
+		       t->range_lo, t->range_hi, t->expected);
+
+		fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		range = pack_port_range(t->range_lo, t->range_hi);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		err = bind_to_loopback_any_port(fd);
+		ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+		port = get_sock_port(fd);
+		ASSERT_EQ(port, t->expected) TH_LOG("unexpected local port");
+
+		err = close(fd);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST_F(ip_local_port_range, exhaust_8_port_range)
+{
+	__u8 port_set = 0;
+	int i, fd, err;
+	__u32 range;
+	__u16 port;
+	int fds[8];
+
+	for (i = 0; i < ARRAY_SIZE(fds); i++) {
+		fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+		ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+		range = pack_port_range(40000, 40007);
+		err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+		ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+		err = bind_to_loopback_any_port(fd);
+		ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+		port = get_sock_port(fd);
+		ASSERT_GE(port, 40000) TH_LOG("expected port within sockopt range");
+		ASSERT_LE(port, 40007) TH_LOG("expected port within sockopt range");
+
+		port_set |= 1 << (port - 40000);
+		fds[i] = fd;
+	}
+
+	/* Check that all every port from the test range is in use */
+	ASSERT_EQ(port_set, 0xff) TH_LOG("expected all ports to be busy");
+
+	/* Check that bind() fails because the whole range is busy */
+	fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+	ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+	range = pack_port_range(40000, 40007);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	err = bind_to_loopback_any_port(fd);
+	ASSERT_TRUE(err) TH_LOG("expected bind to fail");
+	ASSERT_EQ(errno, EADDRINUSE);
+
+	err = close(fd);
+	ASSERT_TRUE(!err) TH_LOG("close failed");
+
+	for (i = 0; i < ARRAY_SIZE(fds); i++) {
+		err = close(fds[i]);
+		ASSERT_TRUE(!err) TH_LOG("close failed");
+	}
+}
+
+TEST_F(ip_local_port_range, late_bind)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_in v4;
+		struct sockaddr_in6 v6;
+	} addr;
+	socklen_t addr_len;
+	const int one = 1;
+	int fd, err;
+	__u32 range;
+	__u16 port;
+
+	if (variant->so_protocol == IPPROTO_SCTP)
+		SKIP(return, "SCTP doesn't support IP_BIND_ADDRESS_NO_PORT");
+
+	fd = socket(variant->so_domain, variant->so_type, 0);
+	ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+	range = pack_port_range(40100, 40199);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	err = setsockopt(fd, SOL_IP, IP_BIND_ADDRESS_NO_PORT, &one, sizeof(one));
+	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_BIND_ADDRESS_NO_PORT) failed");
+
+	err = bind_to_loopback_any_port(fd);
+	ASSERT_TRUE(!err) TH_LOG("bind failed");
+
+	port = get_sock_port(fd);
+	ASSERT_EQ(port, 0) TH_LOG("getsockname failed");
+
+	/* Invalid destination */
+	memset(&addr, 0, sizeof(addr));
+	switch (variant->so_domain) {
+	case AF_INET:
+		addr.v4.sin_family = AF_INET;
+		addr.v4.sin_port = htons(0);
+		addr.v4.sin_addr.s_addr = htonl(INADDR_ANY);
+		addr_len = sizeof(addr.v4);
+		break;
+	case AF_INET6:
+		addr.v6.sin6_family = AF_INET6;
+		addr.v6.sin6_port = htons(0);
+		addr.v6.sin6_addr = in6addr_any;
+		addr_len = sizeof(addr.v6);
+		break;
+	default:
+		ASSERT_TRUE(false) TH_LOG("unsupported socket domain");
+	}
+
+	/* connect() doesn't need to succeed for late bind to happen */
+	connect(fd, &addr.sa, addr_len);
+
+	port = get_sock_port(fd);
+	ASSERT_GE(port, 40100);
+	ASSERT_LE(port, 40199);
+
+	err = close(fd);
+	ASSERT_TRUE(!err) TH_LOG("close failed");
+}
+
+TEST_F(ip_local_port_range, get_port_range)
+{
+	__u16 lo, hi;
+	__u32 range;
+	int fd, err;
+
+	fd = socket(variant->so_domain, variant->so_type, variant->so_protocol);
+	ASSERT_GE(fd, 0) TH_LOG("socket failed");
+
+	/* Get range before it will be set */
+	err = get_ip_local_port_range(fd, &range);
+	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	unpack_port_range(range, &lo, &hi);
+	ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
+	ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
+
+	range = pack_port_range(12345, 54321);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	/* Get range after it has been set */
+	err = get_ip_local_port_range(fd, &range);
+	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	unpack_port_range(range, &lo, &hi);
+	ASSERT_EQ(lo, 12345) TH_LOG("unexpected low port");
+	ASSERT_EQ(hi, 54321) TH_LOG("unexpected high port");
+
+	/* Unset the port range  */
+	range = pack_port_range(0, 0);
+	err = setsockopt(fd, SOL_IP, IP_LOCAL_PORT_RANGE, &range, sizeof(range));
+	ASSERT_TRUE(!err) TH_LOG("setsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	/* Get range after it has been unset */
+	err = get_ip_local_port_range(fd, &range);
+	ASSERT_TRUE(!err) TH_LOG("getsockopt(IP_LOCAL_PORT_RANGE) failed");
+
+	unpack_port_range(range, &lo, &hi);
+	ASSERT_EQ(lo, 0) TH_LOG("unexpected low port");
+	ASSERT_EQ(hi, 0) TH_LOG("unexpected high port");
+
+	err = close(fd);
+	ASSERT_TRUE(!err) TH_LOG("close failed");
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
2.39.0
