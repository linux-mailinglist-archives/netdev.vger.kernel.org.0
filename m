Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3665989E9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345290AbiHRRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345252AbiHRRBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:01:00 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C72DCAC60
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:52 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d5so1122711wms.5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=BZ/KkwshPnqMAFI0Wk3QXC0kmGplRHjwXvozYXgAG7s=;
        b=DY6x2vi43c3UKwxxIdBXAWcY8XOs2yGrLG1onKuxvp2BZ42w+xdHn83RNBA7PURGO/
         F2drXWZ3FW/nnzh3w4DEBxG0PDTp8dFv62JRUBXoTVxiLd/kbPIdwRtl8l4S3CwnJ8+D
         dBpDJuKtNG+15Rbc4X5vh+ApvzUCelwTiOmtIcxC47+TkyaPEN3HBJkO0WAZ/1g9h2ab
         6mRSfiZjnfYqa+8VXdoo/cVsaCUxHHYPmEK33yTI+LwyzRiwC0yK8E+npLNepgX1X6zN
         ivscMOvHYmfCjAqUyodhzl3QqBpeiFmzi31gkWj9AN2P5hkKLqc0XB3LzL5gJlTLwKfr
         9O/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=BZ/KkwshPnqMAFI0Wk3QXC0kmGplRHjwXvozYXgAG7s=;
        b=yn2CTlT2mvb2BblyVJkEv3U0R9x41RN9h60GH7SOT6K0SKPscQc7XirlIKTpn70/yG
         rjdoSMsWxoBxJFsxThk01NKPU1HEWxHAlRn1spl9CmydP5BGKKXmDJeGb00fgdf93ucs
         NC2ytzeM/xE+JKkZxUwCS2+44SR17USIc/kEEqxreWt8YLCdLc4s5f6OJy4pTzs/2Ays
         XUcsRyzBtMDaaaIEYX2SIknCam6tYAB2+ic4rkuUi16N/xEjZq2pk5eRPQfpmIqS+RQL
         1eaPOzxrLmpof8mBeKRDZLRJsyBQ0S0TTX6iPVZ9d/rpg/zufHlGK6+/FJpH/9o4adGc
         QCNw==
X-Gm-Message-State: ACgBeo1F+s0ITm5nl5K5ZG9YTlnrAzwbRzTdTLGarlvaNHBZ/geL5/6C
        Ex6TAg5UJz0leUUMCGbztJ8r0Q==
X-Google-Smtp-Source: AA6agR5nz+PdufVjd+kScX5hdTE8c6RiGi8PqjeQDkYUlEReFdBD7TK/jaHHc/kqxGiJe0ZBoS4KIg==
X-Received: by 2002:a1c:2585:0:b0:3a5:2163:f33b with SMTP id l127-20020a1c2585000000b003a52163f33bmr2483555wml.189.1660842050541;
        Thu, 18 Aug 2022 10:00:50 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id be13-20020a05600c1e8d00b003a511e92abcsm2662169wmb.34.2022.08.18.10.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:00:50 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH 25/31] selftests/net: Add TCP-AO library
Date:   Thu, 18 Aug 2022 17:59:59 +0100
Message-Id: <20220818170005.747015-26-dima@arista.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220818170005.747015-1-dima@arista.com>
References: <20220818170005.747015-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide functions to create selftests dedicated to TCP-AO.
They can run in parallel, as they use temporary net namespaces.
They can be very specific to the feature being tested.
This will allow to create a lot of TCP-AO tests, without complicating
one binary with many --options and to create scenarios, that are
hard to put in bash script that uses one binary.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/tcp_ao/.gitignore |   2 +
 tools/testing/selftests/net/tcp_ao/Makefile   |  45 +++
 tools/testing/selftests/net/tcp_ao/connect.c  |  81 +++++
 .../testing/selftests/net/tcp_ao/lib/aolib.h  | 333 +++++++++++++++++
 .../selftests/net/tcp_ao/lib/netlink.c        | 341 ++++++++++++++++++
 tools/testing/selftests/net/tcp_ao/lib/proc.c | 267 ++++++++++++++
 .../testing/selftests/net/tcp_ao/lib/setup.c  | 297 +++++++++++++++
 tools/testing/selftests/net/tcp_ao/lib/sock.c | 294 +++++++++++++++
 .../testing/selftests/net/tcp_ao/lib/utils.c  |  30 ++
 10 files changed, 1691 insertions(+)
 create mode 100644 tools/testing/selftests/net/tcp_ao/.gitignore
 create mode 100644 tools/testing/selftests/net/tcp_ao/Makefile
 create mode 100644 tools/testing/selftests/net/tcp_ao/connect.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/aolib.h
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/netlink.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/proc.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/setup.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/sock.c
 create mode 100644 tools/testing/selftests/net/tcp_ao/lib/utils.c

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 10b34bb03bc1..2a3b15a13ccb 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -46,6 +46,7 @@ TARGETS += net
 TARGETS += net/af_unix
 TARGETS += net/forwarding
 TARGETS += net/mptcp
+TARGETS += net/tcp_ao
 TARGETS += netfilter
 TARGETS += nsfs
 TARGETS += pidfd
diff --git a/tools/testing/selftests/net/tcp_ao/.gitignore b/tools/testing/selftests/net/tcp_ao/.gitignore
new file mode 100644
index 000000000000..e8bb81b715b7
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/.gitignore
@@ -0,0 +1,2 @@
+*_ipv4
+*_ipv6
diff --git a/tools/testing/selftests/net/tcp_ao/Makefile b/tools/testing/selftests/net/tcp_ao/Makefile
new file mode 100644
index 000000000000..cb23d67944d7
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/Makefile
@@ -0,0 +1,45 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_BOTH_AF := connect
+
+TEST_IPV4_PROGS := $(TEST_BOTH_AF:%=%_ipv4)
+TEST_IPV6_PROGS := $(TEST_BOTH_AF:%=%_ipv6)
+
+TEST_GEN_PROGS := $(TEST_IPV4_PROGS) $(TEST_IPV6_PROGS)
+
+top_srcdir	  := ../../../../..
+KSFT_KHDR_INSTALL := 1
+include ../../lib.mk
+
+HOSTAR ?= ar
+
+# Drop it on port to linux/master with commit 8ce72dc32578
+.DEFAULT_GOAL := all
+
+LIBDIR	:= $(OUTPUT)/lib
+LIB	:= $(LIBDIR)/libaotst.a
+LDLIBS	+= $(LIB) -pthread
+LIBDEPS	:= lib/aolib.h Makefile
+
+CFLAGS	:= -Wall -O2 -g -D_GNU_SOURCE -fno-strict-aliasing
+CFLAGS	+= -I ../../../../../usr/include/ -iquote $(LIBDIR)
+CFLAGS	+= -I ../../../../include/
+
+# Library
+LIBSRC	:= setup.c netlink.c utils.c sock.c proc.c
+LIBOBJ	:= $(LIBSRC:%.c=$(LIBDIR)/%.o)
+EXTRA_CLEAN += $(LIBOBJ) $(LIB)
+
+$(LIB): $(LIBOBJ)
+	$(HOSTAR) rcs $@ $^
+
+$(LIBDIR)/%.o: ./lib/%.c $(LIBDEPS)
+	$(CC) $< $(CFLAGS) $(CPPFLAGS) -o $@ -c
+
+$(TEST_GEN_PROGS): $(LIB)
+
+$(OUTPUT)/%_ipv4: %.c
+	$(LINK.c) $^ $(LDLIBS) -o $@
+
+$(OUTPUT)/%_ipv6: %.c
+	$(LINK.c) -DIPV6_TEST $^ $(LDLIBS) -o $@
+
diff --git a/tools/testing/selftests/net/tcp_ao/connect.c b/tools/testing/selftests/net/tcp_ao/connect.c
new file mode 100644
index 000000000000..02aa50f0266c
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/connect.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Author: Dmitry Safonov <dima@arista.com> */
+#include <inttypes.h>
+#include "aolib.h"
+
+static void *server_fn(void *arg)
+{
+	int err, sk, lsk;
+	ssize_t bytes;
+
+	lsk = test_listen_socket(this_ip_addr, test_server_port, 1);
+
+	if (test_set_ao(lsk, "password", 0, this_ip_dest, -1, 100, 100))
+		test_error("setsockopt(TCP_AO)");
+	synchronize_threads();
+
+	err = test_wait_fd(lsk, TEST_TIMEOUT_SEC, 0);
+	if (!err)
+		test_error("timeouted for accept()");
+	else if (err < 0)
+		test_error("test_wait_fd()");
+
+	sk = accept(lsk, NULL, NULL);
+	if (sk < 0)
+		test_error("accept()");
+
+	synchronize_threads();
+
+	bytes = test_server_run(sk, 0, 0);
+
+	test_fail("server served: %zd", bytes);
+	return NULL;
+}
+
+static void *client_fn(void *arg)
+{
+	int sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+	uint64_t before_aogood, after_aogood;
+	const size_t nr_packets = 20;
+	struct netstat *ns_before, *ns_after;
+
+	if (sk < 0)
+		test_error("socket()");
+
+	if (test_set_ao(sk, "password", 0, this_ip_dest, -1, 100, 100))
+		test_error("setsockopt(TCP_AO)");
+
+	synchronize_threads();
+	if (test_connect_socket(sk, this_ip_dest, test_server_port) <= 0)
+		test_error("failed to connect()");
+	synchronize_threads();
+
+	ns_before = netstat_read();
+	before_aogood = netstat_get(ns_before, "TCPAOGood", NULL);
+	if (test_client_verify(sk, 100, nr_packets, TEST_TIMEOUT_SEC)) {
+		test_fail("verify failed");
+		return NULL;
+	}
+
+	ns_after = netstat_read();
+	after_aogood = netstat_get(ns_after, "TCPAOGood", NULL);
+	netstat_print_diff(ns_before, ns_after);
+	netstat_free(ns_before);
+	netstat_free(ns_after);
+
+	if (nr_packets > (after_aogood - before_aogood)) {
+		test_fail("TCPAOGood counter mismatch: %zu > (%zu - %zu)",
+				nr_packets, after_aogood, before_aogood);
+		return NULL;
+	}
+
+	test_ok("connect TCPAOGood %" PRIu64 " => %" PRIu64 ", sent %" PRIu64,
+			before_aogood, after_aogood, nr_packets);
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	test_init(1, server_fn, client_fn);
+	return 0;
+}
diff --git a/tools/testing/selftests/net/tcp_ao/lib/aolib.h b/tools/testing/selftests/net/tcp_ao/lib/aolib.h
new file mode 100644
index 000000000000..d5810fd04816
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/aolib.h
@@ -0,0 +1,333 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * TCP-AO selftest library. Provides helpers to unshare network
+ * namespaces, create veth, assign ip addresses, set routes,
+ * manipulate socket options, read network counter and etc.
+ * Author: Dmitry Safonov <dima@arista.com>
+ */
+#ifndef _AOLIB_H_
+#define _AOLIB_H_
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <linux/snmp.h>
+#include <linux/tcp.h>
+#include <netinet/in.h>
+#include <stdarg.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../../../../../include/linux/stringify.h"
+
+/* Working around ksft, see the comment in lib/setup.c */
+extern void __test_msg(const char *buf);
+extern void __test_ok(const char *buf);
+extern void __test_fail(const char *buf);
+extern void __test_error(const char *buf);
+
+__attribute__((__format__(__printf__, 2, 3)))
+static inline void __test_print(void (*fn)(const char *), const char *fmt, ...)
+{
+#define TEST_MSG_BUFFER_SIZE 4096
+	char buf[TEST_MSG_BUFFER_SIZE];
+	va_list arg;
+
+	va_start(arg, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, arg);
+	va_end(arg);
+	fn(buf);
+}
+
+#define test_print(fmt, ...)						\
+	__test_print(__test_msg, "%ld[%s:%u] " fmt "\n",		\
+		     syscall(SYS_gettid),				\
+		     __FILE__, __LINE__, ##__VA_ARGS__)
+
+#define test_ok(fmt, ...)						\
+	__test_print(__test_ok, fmt "\n", ##__VA_ARGS__)
+
+#define test_fail(fmt, ...)						\
+do {									\
+	if (errno)							\
+		__test_print(__test_fail, fmt ": %m\n", ##__VA_ARGS__);	\
+	else								\
+		__test_print(__test_fail, fmt "\n", ##__VA_ARGS__);	\
+	test_failed();							\
+} while(0)
+
+#define KSFT_FAIL  1
+#define test_error(fmt, ...)						\
+do {									\
+	if (errno)							\
+		__test_print(__test_error, "%ld[%s:%u] " fmt ": %m\n",	\
+			     syscall(SYS_gettid), __FILE__, __LINE__,	\
+			     ##__VA_ARGS__);				\
+	else								\
+		__test_print(__test_error, "%ld[%s:%u] " fmt "\n",	\
+			     syscall(SYS_gettid), __FILE__, __LINE__,	\
+			     ##__VA_ARGS__);				\
+	exit(KSFT_FAIL);						\
+} while(0)
+
+union tcp_addr {
+	struct in_addr a4;
+	struct in6_addr a6;
+};
+
+typedef void *(*thread_fn)(void*);
+extern void test_failed(void);
+extern void __test_init(unsigned int ntests, int family, unsigned prefix,
+			union tcp_addr addr1, union tcp_addr addr2,
+			thread_fn peer1, thread_fn peer2);
+
+static inline void test_init2(unsigned int ntests,
+			      thread_fn peer1, thread_fn peer2,
+			      int family, unsigned prefix,
+			      const char *addr1, const char *addr2)
+{
+	union tcp_addr taddr1, taddr2;
+
+	if (inet_pton(family, addr1, &taddr1) != 1)
+		test_error("Can't convert ip address %s", addr1);
+	if (inet_pton(family, addr2, &taddr2) != 1)
+		test_error("Can't convert ip address %s", addr2);
+
+	__test_init(ntests, family, prefix, taddr1, taddr2, peer1, peer2);
+}
+extern void test_add_destructor(void (*d)(void));
+extern void test_set_optmem(size_t value);
+
+extern const struct sockaddr_in6 addr_any6;
+extern const struct sockaddr_in addr_any4;
+
+#ifdef IPV6_TEST
+# define __TEST_CLIENT_IP(n)	("2001:db8:" __stringify(n) "::1")
+# define TEST_CLIENT_IP	__TEST_CLIENT_IP(1)
+# define TEST_WRONG_IP	"2001:db8:253::1"
+# define TEST_SERVER_IP	"2001:db8:254::1"
+# define TEST_NETWORK	"2001::"
+# define TEST_PREFIX	128
+# define TEST_FAMILY	AF_INET6
+# define SOCKADDR_ANY	addr_any6
+#else
+# define __TEST_CLIENT_IP(n)	("10.0." __stringify(n) ".1")
+# define TEST_CLIENT_IP	__TEST_CLIENT_IP(1)
+# define TEST_WRONG_IP	"10.0.253.1"
+# define TEST_SERVER_IP	"10.0.254.1"
+# define TEST_NETWORK	"10.0.0.0"
+# define TEST_PREFIX	32
+# define TEST_FAMILY	AF_INET
+# define SOCKADDR_ANY	addr_any4
+#endif
+
+static inline void test_init(unsigned int ntests,
+			     thread_fn peer1, thread_fn peer2)
+{
+	test_init2(ntests, peer1, peer2, TEST_FAMILY, TEST_PREFIX,
+			TEST_SERVER_IP, TEST_CLIENT_IP);
+}
+extern void synchronize_threads(void);
+extern void switch_ns(int fd);
+
+extern __thread union tcp_addr this_ip_addr;
+extern __thread union tcp_addr this_ip_dest;
+extern int test_family;
+
+extern void randomize_buffer(void *buf, size_t buflen);
+extern const char veth_name[];
+extern int add_veth(const char *name, int nsfda, int nsfdb);
+extern int ip_addr_add(const char *intf, int family,
+		       union tcp_addr addr, uint8_t prefix);
+extern int ip_route_add(const char *intf, int family,
+			union tcp_addr src, union tcp_addr dst);
+extern int link_set_up(const char *intf);
+
+extern const unsigned test_server_port;
+extern int test_wait_fd(int sk, time_t sec, bool write);
+extern int __test_connect_socket(int sk, void *addr, size_t addr_sz,
+				 time_t timeout);
+extern int __test_listen_socket(int backlog, void *addr, size_t addr_sz);
+
+static inline int test_listen_socket(const union tcp_addr taddr, unsigned port,
+				     int backlog)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= htons(port),
+		.sin6_addr	= taddr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= htons(port),
+		.sin_addr	= taddr.a4,
+	};
+#endif
+	return __test_listen_socket(backlog, (void *)&addr, sizeof(addr));
+}
+
+#ifndef DEFAULT_TEST_ALGO
+#define DEFAULT_TEST_ALGO	"cmac(aes128)"
+#endif
+
+#ifdef IPV6_TEST
+#define DEFAULT_TEST_PREFIX	128
+#else
+#define DEFAULT_TEST_PREFIX	32
+#endif
+
+/*
+ * Timeout on syscalls where failure is not expected.
+ * You may want to rise it if the test machine is very busy.
+ */
+#ifndef TEST_TIMEOUT_SEC
+#define TEST_TIMEOUT_SEC	5
+#endif
+
+/*
+ * Timeout on connect() where a failure is expected.
+ * If set to 0 - kernel will try to retransmit SYN number of times, set in
+ * /proc/sys/net/ipv4/tcp_syn_retries
+ * By default set to 1 to make tests pass faster on non-busy machine.
+ */
+#ifndef TEST_RETRANSMIT_SEC
+#define TEST_RETRANSMIT_SEC	1
+#endif
+
+
+static inline int _test_connect_socket(int sk, const union tcp_addr taddr,
+					unsigned port, time_t timeout)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= htons(port),
+		.sin6_addr	= taddr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= htons(port),
+		.sin_addr	= taddr.a4,
+	};
+#endif
+	return __test_connect_socket(sk, (void *)&addr, sizeof(addr), timeout);
+}
+
+static inline int test_connect_socket(int sk,
+		const union tcp_addr taddr, unsigned port)
+{
+	return _test_connect_socket(sk, taddr, port, TEST_TIMEOUT_SEC);
+}
+
+extern int test_prepare_ao_sockaddr(struct tcp_ao *ao,
+		const char *alg, uint16_t flags,
+		void *addr, size_t addr_sz, uint8_t prefix,
+		uint8_t sndid, uint8_t rcvid, uint8_t maclen,
+		uint8_t keyflags, uint8_t keylen, const char *key);
+
+static inline int test_prepare_ao(struct tcp_ao *ao,
+		const char *alg, uint16_t flags,
+		union tcp_addr in_addr, uint8_t prefix,
+		uint8_t sndid, uint8_t rcvid, uint8_t maclen,
+		uint8_t keyflags, uint8_t keylen, const char *key)
+{
+#ifdef IPV6_TEST
+	struct sockaddr_in6 addr = {
+		.sin6_family	= AF_INET6,
+		.sin6_port	= 0,
+		.sin6_addr	= in_addr.a6,
+	};
+#else
+	struct sockaddr_in addr = {
+		.sin_family	= AF_INET,
+		.sin_port	= 0,
+		.sin_addr	= in_addr.a4,
+	};
+#endif
+
+	return test_prepare_ao_sockaddr(ao, alg, flags,
+			(void *)&addr, sizeof(addr), prefix, sndid, rcvid,
+			maclen, keyflags, keylen, key);
+}
+
+static inline int test_prepare_def_ao(struct tcp_ao *ao,
+		const char *key, uint16_t flags,
+		union tcp_addr in_addr, uint8_t prefix,
+		uint8_t sndid, uint8_t rcvid)
+{
+	if (prefix > DEFAULT_TEST_PREFIX)
+		prefix = DEFAULT_TEST_PREFIX;
+
+	return test_prepare_ao(ao, DEFAULT_TEST_ALGO, flags, in_addr,
+			prefix, sndid, rcvid, 0, 0, strlen(key), key);
+}
+
+extern int test_get_one_ao(int sk, struct tcp_ao_getsockopt *out,
+			   uint16_t flags, void *addr, size_t addr_sz,
+			   uint8_t prefix, uint8_t sndid, uint8_t rcvid);
+extern int test_cmp_getsockopt_setsockopt(const struct tcp_ao *a,
+					  const struct tcp_ao_getsockopt *b);
+
+static inline int test_verify_socket_ao(int sk, struct tcp_ao *ao)
+{
+	struct tcp_ao_getsockopt tmp;
+	int err;
+
+	err = test_get_one_ao(sk, &tmp, 0, &ao->tcpa_addr,
+			sizeof(ao->tcpa_addr), ao->tcpa_prefix,
+			ao->tcpa_sndid, ao->tcpa_rcvid);
+	if (err)
+		return err;
+
+	return test_cmp_getsockopt_setsockopt(ao, &tmp);
+}
+
+static inline int test_set_ao(int sk, const char *key, uint16_t flags,
+			      union tcp_addr in_addr, uint8_t prefix,
+			      uint8_t sndid, uint8_t rcvid)
+{
+	struct tcp_ao tmp;
+	int err;
+
+	err = test_prepare_def_ao(&tmp, key, flags, in_addr,
+			prefix, sndid, rcvid);
+	if (err)
+		return err;
+
+	if (setsockopt(sk, IPPROTO_TCP, TCP_AO, &tmp, sizeof(tmp)) < 0)
+		return -errno;
+
+	return test_verify_socket_ao(sk, &tmp);
+}
+
+extern ssize_t test_server_run(int sk, ssize_t quota, time_t timeout_sec);
+extern ssize_t test_client_loop(int sk, char *buf, size_t buf_sz,
+				const size_t msg_len, time_t timeout_sec);
+extern int test_client_verify(int sk, const size_t msg_len, const size_t nr,
+			      time_t timeout_sec);
+
+struct netstat;
+extern struct netstat *netstat_read(void);
+extern void netstat_free(struct netstat *ns);
+extern void netstat_print_diff(struct netstat *nsa, struct netstat *nsb);
+extern uint64_t netstat_get(struct netstat *ns,
+			    const char *name, bool *not_found);
+
+static inline uint64_t netstat_get_one(const char *name, bool *not_found)
+{
+	struct netstat *ns = netstat_read();
+	uint64_t ret;
+
+	ret = netstat_get(ns, name, not_found);
+
+	netstat_free(ns);
+	return ret;
+}
+
+#endif /* _AOLIB_H_ */
diff --git a/tools/testing/selftests/net/tcp_ao/lib/netlink.c b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
new file mode 100644
index 000000000000..f04757c921d0
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/netlink.c
@@ -0,0 +1,341 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Original from tools/testing/selftests/net/ipsec.c */
+#include <linux/netlink.h>
+#include <linux/random.h>
+#include <linux/rtnetlink.h>
+#include <linux/veth.h>
+#include <net/if.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/socket.h>
+
+#include "aolib.h"
+
+#define MAX_PAYLOAD		2048
+
+static int netlink_sock(int *sock, uint32_t *seq_nr, int proto)
+{
+	if (*sock > 0) {
+		seq_nr++;
+		return 0;
+	}
+
+	*sock = socket(AF_NETLINK, SOCK_RAW | SOCK_CLOEXEC, proto);
+	if (*sock <= 0) {
+		test_print("socket(AF_NETLINK)");
+		return -1;
+	}
+
+	randomize_buffer(seq_nr, sizeof(*seq_nr));
+
+	return 0;
+}
+
+static int netlink_check_answer(int sock, bool quite)
+{
+	struct nlmsgerror {
+		struct nlmsghdr hdr;
+		int error;
+		struct nlmsghdr orig_msg;
+	} answer;
+
+	if (recv(sock, &answer, sizeof(answer), 0) < 0) {
+		test_print("recv()");
+		return -1;
+	} else if (answer.hdr.nlmsg_type != NLMSG_ERROR) {
+		test_print("expected NLMSG_ERROR, got %d",
+			   (int)answer.hdr.nlmsg_type);
+		return -1;
+	} else if (answer.error) {
+		if (!quite) {
+			test_print("NLMSG_ERROR: %d: %s",
+				answer.error, strerror(-answer.error));
+		}
+		return answer.error;
+	}
+
+	return 0;
+}
+
+static inline struct rtattr *rtattr_hdr(struct nlmsghdr *nh)
+{
+	return (struct rtattr *)((char *)(nh) + RTA_ALIGN((nh)->nlmsg_len));
+}
+
+static int rtattr_pack(struct nlmsghdr *nh, size_t req_sz,
+		unsigned short rta_type, const void *payload, size_t size)
+{
+	/* NLMSG_ALIGNTO == RTA_ALIGNTO, nlmsg_len already aligned */
+	struct rtattr *attr = rtattr_hdr(nh);
+	size_t nl_size = RTA_ALIGN(nh->nlmsg_len) + RTA_LENGTH(size);
+
+	if (req_sz < nl_size) {
+		test_print("req buf is too small: %zu < %zu", req_sz, nl_size);
+		return -1;
+	}
+	nh->nlmsg_len = nl_size;
+
+	attr->rta_len = RTA_LENGTH(size);
+	attr->rta_type = rta_type;
+	memcpy(RTA_DATA(attr), payload, size);
+
+	return 0;
+}
+
+static struct rtattr *_rtattr_begin(struct nlmsghdr *nh, size_t req_sz,
+		unsigned short rta_type, const void *payload, size_t size)
+{
+	struct rtattr *ret = rtattr_hdr(nh);
+
+	if (rtattr_pack(nh, req_sz, rta_type, payload, size))
+		return 0;
+
+	return ret;
+}
+
+static inline struct rtattr *rtattr_begin(struct nlmsghdr *nh, size_t req_sz,
+		unsigned short rta_type)
+{
+	return _rtattr_begin(nh, req_sz, rta_type, 0, 0);
+}
+
+static inline void rtattr_end(struct nlmsghdr *nh, struct rtattr *attr)
+{
+	char *nlmsg_end = (char *)nh + nh->nlmsg_len;
+
+	attr->rta_len = nlmsg_end - (char *)attr;
+}
+
+static int veth_pack_peerb(struct nlmsghdr *nh, size_t req_sz,
+		const char *peer, int ns)
+{
+	struct ifinfomsg pi;
+	struct rtattr *peer_attr;
+
+	memset(&pi, 0, sizeof(pi));
+	pi.ifi_family	= AF_UNSPEC;
+	pi.ifi_change	= 0xFFFFFFFF;
+
+	peer_attr = _rtattr_begin(nh, req_sz, VETH_INFO_PEER, &pi, sizeof(pi));
+	if (!peer_attr)
+		return -1;
+
+	if (rtattr_pack(nh, req_sz, IFLA_IFNAME, peer, strlen(peer)))
+		return -1;
+
+	if (rtattr_pack(nh, req_sz, IFLA_NET_NS_FD, &ns, sizeof(ns)))
+		return -1;
+
+	rtattr_end(nh, peer_attr);
+
+	return 0;
+}
+
+static int __add_veth(int sock, uint32_t seq, const char *name,
+		      int ns_a, int ns_b)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_EXCL | NLM_F_CREATE;
+	struct {
+		struct nlmsghdr		nh;
+		struct ifinfomsg	info;
+		char			attrbuf[MAX_PAYLOAD];
+	} req;
+	const char veth_type[] = "veth";
+	struct rtattr *link_info, *info_data;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_type	= RTM_NEWLINK;
+	req.nh.nlmsg_flags	= flags;
+	req.nh.nlmsg_seq	= seq;
+	req.info.ifi_family	= AF_UNSPEC;
+	req.info.ifi_change	= 0xFFFFFFFF;
+
+	if (rtattr_pack(&req.nh, sizeof(req), IFLA_IFNAME, name, strlen(name)))
+		return -1;
+
+	if (rtattr_pack(&req.nh, sizeof(req), IFLA_NET_NS_FD, &ns_a, sizeof(ns_a)))
+		return -1;
+
+	link_info = rtattr_begin(&req.nh, sizeof(req), IFLA_LINKINFO);
+	if (!link_info)
+		return -1;
+
+	if (rtattr_pack(&req.nh, sizeof(req), IFLA_INFO_KIND, veth_type, sizeof(veth_type)))
+		return -1;
+
+	info_data = rtattr_begin(&req.nh, sizeof(req), IFLA_INFO_DATA);
+	if (!info_data)
+		return -1;
+
+	if (veth_pack_peerb(&req.nh, sizeof(req), name, ns_b))
+		return -1;
+
+	rtattr_end(&req.nh, info_data);
+	rtattr_end(&req.nh, link_info);
+
+	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		test_print("send()");
+		return -1;
+	}
+	return netlink_check_answer(sock, false);
+}
+
+int add_veth(const char *name, int nsfda, int nsfdb)
+{
+	int route_sock = -1, ret;
+	uint32_t route_seq;
+
+	if (netlink_sock(&route_sock, &route_seq, NETLINK_ROUTE))
+		test_error("Failed to open netlink route socket\n");
+
+	ret = __add_veth(route_sock, route_seq++, name, nsfda, nsfdb);
+	close(route_sock);
+	return ret;
+}
+
+static int __ip_addr_add(int sock, uint32_t seq, const char *intf,
+			 int family, union tcp_addr addr, uint8_t prefix)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_EXCL | NLM_F_CREATE;
+	struct {
+		struct nlmsghdr		nh;
+		struct ifaddrmsg	info;
+		char			attrbuf[MAX_PAYLOAD];
+	} req;
+	size_t addr_len = (family == AF_INET) ? sizeof(struct in_addr) :
+						sizeof(struct in6_addr);
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_type	= RTM_NEWADDR;
+	req.nh.nlmsg_flags	= flags;
+	req.nh.nlmsg_seq	= seq;
+	req.info.ifa_family	= family;
+	req.info.ifa_prefixlen	= prefix;
+	req.info.ifa_index	= if_nametoindex(intf);
+	req.info.ifa_flags	= IFA_F_NODAD;
+
+	if (rtattr_pack(&req.nh, sizeof(req), IFA_LOCAL, &addr, addr_len))
+		return -1;
+
+	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		test_print("send()");
+		return -1;
+	}
+	return netlink_check_answer(sock, true);
+}
+
+int ip_addr_add(const char *intf, int family,
+		union tcp_addr addr, uint8_t prefix)
+{
+	int route_sock = -1, ret;
+	uint32_t route_seq;
+
+	if (netlink_sock(&route_sock, &route_seq, NETLINK_ROUTE))
+		test_error("Failed to open netlink route socket\n");
+
+	ret = __ip_addr_add(route_sock, route_seq++, intf,
+			    family, addr, prefix);
+
+	close(route_sock);
+	return ret;
+}
+
+static int __ip_route_add(int sock, uint32_t seq, const char *intf, int family,
+			  union tcp_addr src, union tcp_addr dst)
+{
+	struct {
+		struct nlmsghdr	nh;
+		struct rtmsg	rt;
+		char		attrbuf[MAX_PAYLOAD];
+	} req;
+	unsigned int index = if_nametoindex(intf);
+	size_t addr_len = (family == AF_INET) ? sizeof(struct in_addr) :
+						sizeof(struct in6_addr);
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.rt));
+	req.nh.nlmsg_type	= RTM_NEWROUTE;
+	req.nh.nlmsg_flags	= NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE;
+	req.nh.nlmsg_seq	= seq;
+	req.rt.rtm_family	= family;
+	req.rt.rtm_dst_len	= (family == AF_INET) ? 32 : 128;
+	req.rt.rtm_table	= RT_TABLE_MAIN;
+	req.rt.rtm_protocol	= RTPROT_BOOT;
+	req.rt.rtm_scope	= RT_SCOPE_UNIVERSE;
+	req.rt.rtm_type		= RTN_UNICAST;
+
+	if (rtattr_pack(&req.nh, sizeof(req), RTA_DST, &dst, addr_len))
+		return -1;
+
+	if (rtattr_pack(&req.nh, sizeof(req), RTA_PREFSRC, &src, addr_len))
+		return -1;
+
+	if (rtattr_pack(&req.nh, sizeof(req), RTA_OIF, &index, sizeof(index)))
+		return -1;
+
+	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		test_print("send()");
+		return -1;
+	}
+
+	return netlink_check_answer(sock, true);
+}
+
+int ip_route_add(const char *intf, int family,
+		 union tcp_addr src, union tcp_addr dst)
+{
+	int route_sock = -1, ret;
+	uint32_t route_seq;
+
+	if (netlink_sock(&route_sock, &route_seq, NETLINK_ROUTE))
+		test_error("Failed to open netlink route socket\n");
+
+	ret = __ip_route_add(route_sock, route_seq++, intf, family, src, dst);
+	if (ret == -EEXIST) /* ignoring */
+		ret = 0;
+
+	close(route_sock);
+	return ret;
+}
+
+static int __link_set_up(int sock, uint32_t seq, const char *intf)
+{
+	struct {
+		struct nlmsghdr		nh;
+		struct ifinfomsg	info;
+		char			attrbuf[MAX_PAYLOAD];
+	} req;
+
+	memset(&req, 0, sizeof(req));
+	req.nh.nlmsg_len	= NLMSG_LENGTH(sizeof(req.info));
+	req.nh.nlmsg_type	= RTM_NEWLINK;
+	req.nh.nlmsg_flags	= NLM_F_REQUEST | NLM_F_ACK;
+	req.nh.nlmsg_seq	= seq;
+	req.info.ifi_family	= AF_UNSPEC;
+	req.info.ifi_change	= 0xFFFFFFFF;
+	req.info.ifi_index	= if_nametoindex(intf);
+	req.info.ifi_flags	= IFF_UP;
+	req.info.ifi_change	= IFF_UP;
+
+	if (send(sock, &req, req.nh.nlmsg_len, 0) < 0) {
+		test_print("send()");
+		return -1;
+	}
+	return netlink_check_answer(sock, false);
+}
+
+int link_set_up(const char *intf)
+{
+	int route_sock = -1, ret;
+	uint32_t route_seq;
+
+	if (netlink_sock(&route_sock, &route_seq, NETLINK_ROUTE))
+		test_error("Failed to open netlink route socket\n");
+
+	ret = __link_set_up(route_sock, route_seq++, intf);
+
+	close(route_sock);
+	return ret;
+}
diff --git a/tools/testing/selftests/net/tcp_ao/lib/proc.c b/tools/testing/selftests/net/tcp_ao/lib/proc.c
new file mode 100644
index 000000000000..815bb7b5975a
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/proc.c
@@ -0,0 +1,267 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <inttypes.h>
+#include <pthread.h>
+#include <stdio.h>
+#include "../../../../../include/linux/compiler.h"
+#include "../../../../../include/linux/kernel.h"
+#include "aolib.h"
+
+struct netstat_counter {
+	uint64_t val;
+	char *name;
+};
+
+struct netstat {
+	char *header_name;
+	struct netstat *next;
+	size_t counters_nr;
+	struct netstat_counter *counters;
+};
+
+static struct netstat *lookup_type(struct netstat *ns,
+		const char *type, size_t len)
+{
+	while (ns != NULL) {
+		size_t cmp = max(len, strlen(ns->header_name));
+
+		if (!strncmp(ns->header_name, type, cmp))
+			return ns;
+		ns = ns->next;
+	}
+	return NULL;
+}
+
+static struct netstat *lookup_get(struct netstat *ns,
+				  const char *type, const size_t len)
+{
+	struct netstat *ret;
+
+	ret = lookup_type(ns, type, len);
+	if (ret != NULL)
+		return ret;
+
+	ret = malloc(sizeof(struct netstat));
+	if (!ret)
+		test_error("malloc()");
+
+	ret->header_name = strndup(type, len);
+	if (ret->header_name == NULL)
+		test_error("strndup()");
+	ret->next = ns;
+	ret->counters_nr = 0;
+	ret->counters = NULL;
+
+	return ret;
+}
+
+static struct netstat *lookup_get_column(struct netstat *ns, const char *line)
+{
+	char *column;
+
+	column = strchr(line, ':');
+	if (!column)
+		test_error("can't parse netstat file");
+
+	return lookup_get(ns, line, column - line);
+}
+
+static void netstat_read_type(FILE *fnetstat, struct netstat **dest, char *line)
+{
+	struct netstat *type = lookup_get_column(*dest, line);
+	const char *pos = line;
+	size_t i, nr_elems = 0;
+	char tmp;
+
+	while ((pos = strchr(pos, ' '))) {
+		nr_elems++;
+		pos++;
+	}
+
+	*dest = type;
+	type->counters = reallocarray(type->counters,
+				type->counters_nr + nr_elems,
+				sizeof(struct netstat_counter));
+	if (!type->counters)
+		test_error("reallocarray()");
+
+	pos = strchr(line, ' ') + 1;
+
+	if (fscanf(fnetstat, type->header_name) == EOF)
+		test_error("fscanf(%s)", type->header_name);
+	if (fread(&tmp, 1, 1, fnetstat) != 1 || tmp != ':')
+		test_error("Unexpected netstat format (%c)", tmp);
+
+	for (i = type->counters_nr; i < type->counters_nr + nr_elems; i++) {
+		struct netstat_counter *nc = &type->counters[i];
+		const char *new_pos = strchr(pos, ' ');
+		const char *fmt = " %" PRIu64;
+
+		if (new_pos == NULL)
+			new_pos = strchr(pos, '\n');
+
+		nc->name = strndup(pos, new_pos - pos);
+		if (nc->name == NULL)
+			test_error("strndup()");
+
+		if (unlikely(!strcmp(nc->name, "MaxConn")))
+			fmt = " %" PRId64; /* MaxConn is signed, RFC 2012 */
+		if (fscanf(fnetstat, fmt, &nc->val) != 1)
+			test_error("fscanf(%s)", nc->name);
+		pos = new_pos + 1;
+	}
+	type->counters_nr += nr_elems;
+
+	if (fread(&tmp, 1, 1, fnetstat) != 1 || tmp != '\n')
+		test_error("Unexpected netstat format");
+}
+
+static const char *snmp6_name = "Snmp6";
+static void snmp6_read(FILE *fnetstat, struct netstat **dest)
+{
+	struct netstat *type = lookup_get(*dest, snmp6_name, strlen(snmp6_name));
+	char *counter_name;
+	size_t i;
+
+	for (i = type->counters_nr;; i++) {
+		struct netstat_counter *nc;
+		uint64_t counter;
+
+		if (fscanf(fnetstat, "%ms", &counter_name) == EOF)
+			break;
+		if (fscanf(fnetstat, "%" PRIu64, &counter) == EOF)
+			test_error("Unexpected snmp6 format");
+		type->counters = reallocarray(type->counters, i + 1,
+					sizeof(struct netstat_counter));
+		if (!type->counters)
+			test_error("reallocarray()");
+		nc = &type->counters[i];
+		nc->name = counter_name;
+		nc->val = counter;
+	}
+	type->counters_nr = i;
+	*dest = type;
+}
+
+struct netstat *netstat_read(void)
+{
+	struct netstat *ret = 0;
+	size_t line_sz = 0;
+	char *line = NULL;
+	FILE *fnetstat;
+
+	errno = 0;
+	fnetstat = fopen("/proc/net/netstat", "r");
+	if (fnetstat == NULL)
+		test_error("failed to open /proc/net/netstat");
+
+	while (getline(&line, &line_sz, fnetstat) != -1)
+		netstat_read_type(fnetstat, &ret, line);
+	fclose(fnetstat);
+
+	errno = 0;
+	fnetstat = fopen("/proc/net/snmp", "r");
+	if (fnetstat == NULL)
+		test_error("failed to open /proc/net/snmp");
+
+	while (getline(&line, &line_sz, fnetstat) != -1)
+		netstat_read_type(fnetstat, &ret, line);
+	fclose(fnetstat);
+
+	errno = 0;
+	fnetstat = fopen("/proc/net/snmp6", "r");
+	if (fnetstat == NULL)
+		test_error("failed to open /proc/net/snmp6");
+
+	snmp6_read(fnetstat, &ret);
+	fclose(fnetstat);
+
+	free(line);
+	return ret;
+}
+
+void netstat_free(struct netstat *ns)
+{
+	while (ns != NULL) {
+		struct netstat *prev = ns;
+		size_t i;
+
+		free(ns->header_name);
+		for (i = 0; i < ns->counters_nr; i++)
+			free(ns->counters[i].name);
+		free(ns->counters);
+		ns = ns->next;
+		free(prev);
+	}
+}
+
+static void inline
+__netstat_print_diff(uint64_t a, struct netstat *nsb, size_t i)
+{
+	if (unlikely(!strcmp(nsb->header_name, "MaxConn"))) {
+		test_print("%8s %25s: %" PRId64 " => %" PRId64,
+				nsb->header_name, nsb->counters[i].name,
+				a, nsb->counters[i].val);
+		return;
+	}
+
+	test_print("%8s %25s: %" PRIu64 " => %" PRIu64, nsb->header_name,
+			nsb->counters[i].name, a, nsb->counters[i].val);
+}
+
+void netstat_print_diff(struct netstat *nsa, struct netstat *nsb)
+{
+	size_t i, j;
+
+	while (nsb != NULL) {
+		if (unlikely(strcmp(nsb->header_name, nsa->header_name))) {
+			for (i = 0; i < nsb->counters_nr; i++)
+				__netstat_print_diff(0, nsb, i);
+			nsb = nsb->next;
+			continue;
+		}
+
+		if (nsb->counters_nr < nsa->counters_nr)
+			test_error("Unexpected: some counters dissapeared!");
+
+		for (j = 0, i = 0; i < nsb->counters_nr; i++) {
+			if (strcmp(nsb->counters[i].name, nsa->counters[j].name)) {
+				__netstat_print_diff(0, nsb, i);
+				continue;
+			}
+
+			if (nsa->counters[j].val == nsb->counters[i].val) {
+				j++;
+				continue;
+			}
+
+			__netstat_print_diff(nsa->counters[j].val, nsb, i);
+			j++;
+		}
+		if (j != nsa->counters_nr)
+			test_error("Unexpected: some counters dissapeared!");
+
+		nsb = nsb->next;
+		nsa = nsa->next;
+	}
+}
+
+uint64_t netstat_get(struct netstat *ns, const char *name, bool *not_found)
+{
+	if (not_found)
+		*not_found = false;
+
+	while (ns != NULL) {
+		size_t i;
+
+		for (i = 0; i < ns->counters_nr; i++) {
+			if (!strcmp(name, ns->counters[i].name))
+				return ns->counters[i].val;
+		}
+
+		ns = ns->next;
+	}
+
+	if (not_found)
+		*not_found = true;
+	return 0;
+}
diff --git a/tools/testing/selftests/net/tcp_ao/lib/setup.c b/tools/testing/selftests/net/tcp_ao/lib/setup.c
new file mode 100644
index 000000000000..b47672a2a5c0
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/setup.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <signal.h>
+#include "aolib.h"
+
+/*
+ * Can't be included in the header: it defines static variables which
+ * will be unique to every object. Let's include it only once here.
+ */
+#include "../../../kselftest.h"
+
+/* Prevent overriding of one thread's output by another */
+static pthread_mutex_t ksft_print_lock = PTHREAD_MUTEX_INITIALIZER;
+
+void __test_msg(const char *buf)
+{
+	pthread_mutex_lock(&ksft_print_lock);
+	ksft_print_msg(buf);
+	pthread_mutex_unlock(&ksft_print_lock);
+}
+void __test_ok(const char *buf)
+{
+	pthread_mutex_lock(&ksft_print_lock);
+	ksft_test_result_pass(buf);
+	pthread_mutex_unlock(&ksft_print_lock);
+}
+void __test_fail(const char *buf)
+{
+	pthread_mutex_lock(&ksft_print_lock);
+	ksft_test_result_fail(buf);
+	pthread_mutex_unlock(&ksft_print_lock);
+}
+
+void __test_error(const char *buf)
+{
+	pthread_mutex_lock(&ksft_print_lock);
+	ksft_test_result_error(buf);
+	pthread_mutex_unlock(&ksft_print_lock);
+}
+
+static volatile int failed;
+
+void test_failed(void)
+{
+	failed = 1;
+}
+
+static void test_exit(void)
+{
+	if (failed)
+		ksft_exit_fail();
+	else
+		ksft_exit_pass();
+}
+
+struct dlist_t {
+	void (*destruct)(void);
+	struct dlist_t *next;
+};
+static struct dlist_t *destructors_list;
+
+void test_add_destructor(void (*d)(void))
+{
+	struct dlist_t *p;
+
+	p = malloc(sizeof(struct dlist_t));
+	if (p == NULL)
+		test_error("malloc() failed");
+
+	p->next = destructors_list;
+	p->destruct = d;
+	destructors_list = p;
+}
+
+static void test_destructor(void) __attribute__((destructor));
+static void test_destructor(void)
+{
+	while (destructors_list) {
+		struct dlist_t *p = destructors_list->next;
+
+		destructors_list->destruct();
+		free(destructors_list);
+		destructors_list = p;
+	}
+	test_exit();
+}
+
+static void sig_int(int signo)
+{
+	test_error("Caught SIGINT - exiting");
+}
+
+static int open_netns(void)
+{
+	const char *netns_path = "/proc/self/ns/net";
+	int fd;
+
+	fd = open(netns_path, O_RDONLY);
+	if (fd <= 0)
+		test_error("open(%s)", netns_path);
+	return fd;
+}
+
+static int unshare_open(void)
+{
+	if (unshare(CLONE_NEWNET) != 0)
+		test_error("unshare()");
+
+	return open_netns();
+}
+
+void switch_ns(int fd)
+{
+	if (setns(fd, CLONE_NEWNET))
+		test_error("setns()");
+}
+
+int switch_save_ns(int new_ns)
+{
+	int ret = open_netns();
+
+	switch_ns(new_ns);
+	return ret;
+}
+
+static int nsfd_outside	= -1;
+static int nsfd_parent	= -1;
+static int nsfd_child	= -1;
+const char veth_name[]	= "ktst-veth";
+
+static void init_namespaces(void)
+{
+	nsfd_outside = open_netns();
+	nsfd_parent = unshare_open();
+	nsfd_child = unshare_open();
+}
+
+static void link_init(const char *veth, int family, uint8_t prefix,
+		      union tcp_addr addr, union tcp_addr dest)
+{
+	if (link_set_up(veth))
+		test_error("Failed to set link up");
+	if (ip_addr_add(veth, family, addr, prefix))
+		test_error("Failed to add ip address");
+	if (ip_route_add(veth, family, addr, dest))
+		test_error("Failed to add route");
+}
+
+static unsigned nr_threads = 1;
+
+static pthread_mutex_t sync_lock = PTHREAD_MUTEX_INITIALIZER;
+static pthread_cond_t sync_cond = PTHREAD_COND_INITIALIZER;
+static volatile unsigned stage_threads[2];
+static volatile unsigned stage_nr;
+
+/* synchronize all threads in the same stage */
+void synchronize_threads(void)
+{
+	unsigned q = stage_nr;
+
+	pthread_mutex_lock(&sync_lock);
+	stage_threads[q]++;
+	if (stage_threads[q] == nr_threads) {
+		stage_nr ^= 1;
+		stage_threads[stage_nr] = 0;
+		pthread_cond_signal(&sync_cond);
+	}
+	while (stage_threads[q] < nr_threads)
+		pthread_cond_wait(&sync_cond, &sync_lock);
+	pthread_mutex_unlock(&sync_lock);
+}
+
+__thread union tcp_addr this_ip_addr;
+__thread union tcp_addr this_ip_dest;
+int test_family;
+
+struct new_pthread_arg {
+	thread_fn	func;
+	union tcp_addr	my_ip;
+	union tcp_addr	dest_ip;
+};
+static void *new_pthread_entry(void *arg)
+{
+	struct new_pthread_arg *p = arg;
+
+	this_ip_addr = p->my_ip;
+	this_ip_dest = p->dest_ip;
+	p->func(NULL); /* shouldn't return */
+	exit(KSFT_FAIL);
+}
+
+void __test_init(unsigned int ntests, int family, unsigned prefix,
+			union tcp_addr addr1, union tcp_addr addr2,
+			thread_fn peer1, thread_fn peer2)
+{
+	struct sigaction sa = {
+		.sa_handler = sig_int,
+		.sa_flags = SA_RESTART,
+	};
+	time_t seed = time(NULL);
+
+	test_family = family;
+	ksft_set_plan(ntests);
+
+	test_print("rand seed %u", (unsigned int)seed);
+	srand(seed);
+
+	sigemptyset(&sa.sa_mask);
+	if (sigaction(SIGINT, &sa, NULL))
+		test_error("Can't set SIGINT handler");
+
+	ksft_print_header();
+	init_namespaces();
+
+	if (add_veth(veth_name, nsfd_parent, nsfd_child))
+		test_error("Failed to add veth");
+
+	switch_ns(nsfd_child);
+	link_init(veth_name, family, prefix, addr2, addr1);
+	if (peer2) {
+		struct new_pthread_arg targ;
+		pthread_t t;
+
+		targ.my_ip = addr2;
+		targ.dest_ip = addr1;
+		targ.func = peer2;
+		nr_threads++;
+		if (pthread_create(&t, NULL, new_pthread_entry, &targ))
+			test_error("Failed to create pthread");
+	}
+	switch_ns(nsfd_parent);
+	link_init(veth_name, family, prefix, addr1, addr2);
+
+	this_ip_addr = addr1;
+	this_ip_dest = addr2;
+	peer1(NULL);
+	if (failed)
+		exit(KSFT_FAIL);
+	else
+		exit(KSFT_PASS);
+}
+
+/* /proc/sys/net/core/optmem_max artifically limits the amount of memory
+ * that can be allocated with sock_kmalloc() on each socket in the system.
+ * It is not virtualized, so it has to written outside test namespaces.
+ * To be nice a test will revert optmem back to the old value.
+ * Keeping it simple without any file lock, which means the tests that
+ * need to set/increase optmem value shouldn't run in parallel.
+ * Also, not re-entrant.
+ */
+static const char *optmem_file = "/proc/sys/net/core/optmem_max";
+static size_t saved_optmem;
+
+static void __test_set_optmem(size_t new, size_t *old)
+{
+	FILE *foptmem;
+	int old_ns;
+
+	old_ns = switch_save_ns(nsfd_outside);
+	foptmem = fopen(optmem_file, "r+");
+	if (!foptmem)
+		test_error("failed to open %s", optmem_file);
+
+	if (old != NULL) {
+		if (fscanf(foptmem, "%zu", old) != 1)
+			test_error("can't read from %s", optmem_file);
+		fclose(foptmem);
+		foptmem = fopen(optmem_file, "w");
+		if (!foptmem)
+			test_error("failed to open %s", optmem_file);
+	}
+
+	if (fprintf(foptmem, "%zu", new) <= 0)
+		test_error("can't write %zu to %s", new, optmem_file);
+	fclose(foptmem);
+	switch_ns(old_ns);
+}
+
+static void test_revert_optmem(void)
+{
+	if (saved_optmem == 0)
+		return;
+
+	__test_set_optmem(saved_optmem, NULL);
+}
+
+void test_set_optmem(size_t value)
+{
+	if (saved_optmem == 0) {
+		__test_set_optmem(value, &saved_optmem);
+		test_add_destructor(test_revert_optmem);
+	} else {
+		__test_set_optmem(value, NULL);
+	}
+}
diff --git a/tools/testing/selftests/net/tcp_ao/lib/sock.c b/tools/testing/selftests/net/tcp_ao/lib/sock.c
new file mode 100644
index 000000000000..c0b0ac77b644
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/sock.c
@@ -0,0 +1,294 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <alloca.h>
+#include <fcntl.h>
+#include <string.h>
+#include "../../../../../include/linux/kernel.h"
+#include "../../../../../include/linux/stringify.h"
+#include "aolib.h"
+
+const unsigned test_server_port = 7010;
+int __test_listen_socket(int backlog, void *addr, size_t addr_sz)
+{
+	int err, sk = socket(test_family, SOCK_STREAM, IPPROTO_TCP);
+	long flags;
+
+	if (sk < 0)
+		test_error("socket()");
+
+	err = setsockopt(sk, SOL_SOCKET, SO_BINDTODEVICE, veth_name,
+			 strlen(veth_name) + 1);
+	if (err < 0)
+		test_error("setsockopt(SO_BINDTODEVICE)");
+
+	if (bind(sk, (struct sockaddr *)addr, addr_sz) < 0)
+		test_error("bind()");
+
+	flags = fcntl(sk, F_GETFL);
+	if ((flags < 0) || (fcntl(sk, F_SETFL, flags | O_NONBLOCK) < 0))
+		test_error("fcntl()");
+
+	if (listen(sk, backlog))
+		test_error("listen()");
+
+	return sk;
+}
+
+int test_wait_fd(int sk, time_t sec, bool write)
+{
+	struct timeval tv = { .tv_sec = sec };
+	struct timeval *ptv = NULL;
+	fd_set fds, efds;
+	int ret;
+	socklen_t slen = sizeof(ret);
+
+	FD_ZERO(&fds);
+	FD_SET(sk, &fds);
+	FD_ZERO(&efds);
+	FD_SET(sk, &efds);
+
+	if (sec)
+		ptv = &tv;
+
+	errno = 0;
+	if (write)
+		ret = select(sk + 1, NULL, &fds, &efds, ptv);
+	else
+		ret = select(sk + 1, &fds, NULL, &efds, ptv);
+	if (ret <= 0)
+		return -errno;
+
+	if (getsockopt(sk, SOL_SOCKET, SO_ERROR, &ret, &slen) || ret)
+		return -ret;
+	return sk;
+}
+
+int __test_connect_socket(int sk, void *addr, size_t addr_sz, time_t timeout)
+{
+	long flags;
+	int err;
+
+	err = setsockopt(sk, SOL_SOCKET, SO_BINDTODEVICE, veth_name,
+			 strlen(veth_name) + 1);
+	if (err < 0)
+		test_error("setsockopt(SO_BINDTODEVICE)");
+
+	if (!timeout) {
+		err = connect(sk, addr, addr_sz);
+		if (err) {
+			err = -errno;
+			goto out;
+		}
+		return 0;
+	}
+
+	flags = fcntl(sk, F_GETFL);
+	if ((flags < 0) || (fcntl(sk, F_SETFL, flags | O_NONBLOCK) < 0))
+		test_error("fcntl()");
+
+	if (connect(sk, addr, addr_sz) < 0) {
+		if (errno != EINPROGRESS) {
+			err = -errno;
+			goto out;
+		}
+		err = test_wait_fd(sk, timeout, 1);
+		if (err <= 0)
+			goto out;
+	}
+	return sk;
+
+out:
+	close(sk);
+	return err;
+}
+
+int test_prepare_ao_sockaddr(struct tcp_ao *ao, const char *alg, uint16_t flags,
+		void *addr, size_t addr_sz, uint8_t prefix,
+		uint8_t sndid, uint8_t rcvid, uint8_t maclen,
+		uint8_t keyflags, uint8_t keylen, const char *key)
+{
+	memset(ao, 0, sizeof(struct tcp_ao));
+
+	ao->tcpa_flags		= flags;
+	ao->tcpa_prefix		= prefix;
+	ao->tcpa_sndid		= sndid;
+	ao->tcpa_rcvid		= rcvid;
+	ao->tcpa_maclen		= maclen;
+	ao->tcpa_keyflags	= keyflags;
+	ao->tcpa_keylen		= keylen;
+
+	memcpy(&ao->tcpa_addr, addr, addr_sz);
+
+	if (strlen(alg) > 64)
+		return -ENOBUFS;
+	strncpy(ao->tcpa_alg_name, alg, 64);
+
+	memcpy(ao->tcpa_key, key,
+		(TCP_AO_MAXKEYLEN < keylen) ? TCP_AO_MAXKEYLEN : keylen);
+	return 0;
+}
+
+int test_get_one_ao(int sk, struct tcp_ao_getsockopt *out, uint16_t flags,
+		void *addr, size_t addr_sz, uint8_t prefix,
+		uint8_t sndid, uint8_t rcvid)
+{
+	struct tcp_ao_getsockopt tmp = {};
+	socklen_t tmp_sz = sizeof(tmp);
+	int ret;
+
+	memcpy(&tmp.addr, addr, addr_sz);
+	tmp.prefix = prefix;
+	tmp.sndid  = sndid;
+	tmp.rcvid  = rcvid;
+	tmp.flags  = flags;
+	tmp.nkeys  = 1;
+
+	ret = getsockopt(sk, IPPROTO_TCP, TCP_AO_GET, &tmp, &tmp_sz);
+	if (ret)
+		return ret;
+	if (tmp.nkeys != 1)
+		return -ENOENT;
+	*out = tmp;
+	return 0;
+}
+
+int test_cmp_getsockopt_setsockopt(const struct tcp_ao *a,
+				   const struct tcp_ao_getsockopt *b)
+{
+	bool is_kdf_aes_128_cmac = false;
+
+	if (!strcmp("cmac(aes128)", a->tcpa_alg_name))
+		is_kdf_aes_128_cmac = (a->tcpa_keylen != 16);
+
+#define __cmp_ao(member)						\
+	if (b->member != a->tcpa_##member) {				\
+		test_fail("getsockopt(): " __stringify(member) " %u != %u",	\
+				b->member, a->tcpa_##member);		\
+		return -1;						\
+	}
+	__cmp_ao(sndid);
+	__cmp_ao(rcvid);
+	__cmp_ao(prefix);
+	__cmp_ao(keyflags);
+	if (a->tcpa_maclen) {
+		__cmp_ao(maclen);
+	} else if (b->maclen != 12) {
+		test_fail("getsockopt(): expected default maclen 12, but it's %u",
+				b->maclen);
+		return -1;
+	}
+	if (!is_kdf_aes_128_cmac) {
+		__cmp_ao(keylen);
+	} else if (b->keylen != 16) {
+		test_fail("getsockopt(): expected keylen 16 for cmac(aes128), but it's %u",
+				b->keylen);
+		return -1;
+	}
+#undef __cmp_ao
+	if (!is_kdf_aes_128_cmac && memcmp(b->key, a->tcpa_key, a->tcpa_keylen)) {
+		test_fail("getsockopt(): returned key is different `%s' != `%s'",
+				b->key, a->tcpa_key);
+		return -1;
+	}
+	if (memcmp(&b->addr, &a->tcpa_addr, sizeof(b->addr))) {
+		test_fail("getsockopt(): returned address is different");
+		return -1;
+	}
+	if (!is_kdf_aes_128_cmac && strcmp(b->alg_name, a->tcpa_alg_name)) {
+		test_fail("getsockopt(): returned algorithm is different");
+		return -1;
+	}
+	if (is_kdf_aes_128_cmac && strcmp(b->alg_name, "cmac(aes)")) {
+		test_fail("getsockopt(): returned algorithm is different");
+		return -1;
+	}
+	return 0;
+}
+
+#define TEST_BUF_SIZE 4096
+ssize_t test_server_run(int sk, ssize_t quota, time_t timeout_sec)
+{
+	ssize_t total = 0;
+
+	do {
+		char buf[TEST_BUF_SIZE];
+		ssize_t bytes, sent;
+		int ret;
+
+		ret = test_wait_fd(sk, timeout_sec, 0);
+		if (ret <= 0)
+			return ret;
+
+		bytes = recv(sk, buf, sizeof(buf), 0);
+
+		if (bytes < 0)
+			test_error("recv(): %zd", bytes);
+		if (bytes == 0)
+			break;
+
+		ret = test_wait_fd(sk, timeout_sec, 1);
+		if (ret <= 0)
+			return ret;
+
+		sent = send(sk, buf, bytes, 0);
+		if (sent == 0)
+			break;
+		if (sent != bytes)
+			test_error("send()");
+		total += bytes;
+	} while (!quota || total < quota);
+
+	return total;
+}
+
+ssize_t test_client_loop(int sk, char *buf, size_t buf_sz,
+			 const size_t msg_len, time_t timeout_sec)
+{
+	char msg[msg_len];
+	int nodelay = 1;
+	size_t i;
+
+	if (setsockopt(sk, IPPROTO_TCP, TCP_NODELAY, &nodelay, sizeof(nodelay)))
+		test_error("setsockopt(TCP_NODELAY)");
+
+	for (i = 0; i < buf_sz; i += min(msg_len, buf_sz - i)) {
+		size_t sent, bytes = min(msg_len, buf_sz - i);
+		int ret;
+
+		ret = test_wait_fd(sk, timeout_sec, 1);
+		if (ret <= 0)
+			return ret;
+
+		sent = send(sk, buf + i, bytes, 0);
+		if (sent == 0)
+			break;
+		if (sent != bytes)
+			test_error("send()");
+
+		ret = test_wait_fd(sk, timeout_sec, 0);
+		if (ret <= 0)
+			return ret;
+
+		bytes = recv(sk, msg, sizeof(msg), 0);
+		if (bytes < 0)
+			test_error("recv(): %zd", bytes);
+		if (bytes != sent)
+			test_error("recv(): %zd != %zd", bytes, sent);
+		if (memcmp(buf + i, msg, bytes) != 0) {
+			test_fail("received message differs");
+			return -1;
+		}
+	}
+	return i;
+}
+
+int test_client_verify(int sk, const size_t msg_len, const size_t nr,
+		       time_t timeout_sec)
+{
+	size_t buf_sz = msg_len * nr;
+	char *buf = alloca(buf_sz);
+
+	randomize_buffer(buf, buf_sz);
+	if (test_client_loop(sk, buf, buf_sz, msg_len, timeout_sec) != buf_sz)
+		return -1;
+	return 0;
+}
diff --git a/tools/testing/selftests/net/tcp_ao/lib/utils.c b/tools/testing/selftests/net/tcp_ao/lib/utils.c
new file mode 100644
index 000000000000..372daca525f5
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_ao/lib/utils.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+#include "aolib.h"
+#include <string.h>
+
+void randomize_buffer(void *buf, size_t buflen)
+{
+	int *p = (int *)buf;
+	size_t words = buflen / sizeof(int);
+	size_t leftover = buflen % sizeof(int);
+
+	if (!buflen)
+		return;
+
+	while (words--)
+		*p++ = rand();
+
+	if (leftover) {
+		int tmp = rand();
+
+		memcpy(buf + buflen - leftover, &tmp, leftover);
+	}
+}
+
+const struct sockaddr_in6 addr_any6 = {
+	.sin6_family	= AF_INET6,
+};
+
+const struct sockaddr_in addr_any4 = {
+	.sin_family	= AF_INET,
+};
-- 
2.37.2

