Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5A21DF18
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgGMRrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730528AbgGMRr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:28 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF76CC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:27 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id z24so18956108ljn.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P0pIonZHPPxYTF/vNNO8A7E98x+1xWSHEhKlRPS9dys=;
        b=GHL/YsLoRg9DzgAsSWRMunYZ1rHiaKC0gNoYm0bfmjWRVvsnZQeU1PHGcwDEqIOUSQ
         bJBhIQGcydCDEGfBVQ7GE5qURtPdBiTWDbwhP2o2r7hS97qpszyDXwB34AkDbQY7jEEN
         RyMCTjgwo4Jb6UDbnb+4744PODIx+//J/ld4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P0pIonZHPPxYTF/vNNO8A7E98x+1xWSHEhKlRPS9dys=;
        b=m8OSO3vnU91N5+BjkqnG7wrOjUr7bA3fVY3VH4T/aofVk70VlcBmCbfPFwGY1Lv8/v
         FEiRf3HmGTqazqfUbaURqAUT20f5NDztDCmaaMF3hDfSOkHTB5kCizVuAq6UCICfcNOi
         Q4j8Rept5LKpiV+x1Y7CSy8/8Wpbg5G2OaLCN8XTnoZuVbRpdThqtWvqkW5b8+dVJzJx
         2ZeOpirQNux3qk3lnbD+1CM/JxRDZRABIbt6ytzWQ+8lrKERCwhdgR3ZsgooZIZbcH6Z
         xZG55foG/TNr0f2tng3eUqXucS6ob+aX/GaYkRxfUr9WuhTIyJE+N+0oazulZfmcNWvQ
         iowg==
X-Gm-Message-State: AOAM533nwUUP2fw7VaGxwH4alXOOEZ+dy5ktU3+IaYwurUw+M9Xrzyu1
        Z6XJy99slh1E+mujksKaeyGr4Q==
X-Google-Smtp-Source: ABdhPJxZS+jZ4td9Xk8NMh1YpqrJnXcKFfJ+zxwHklEENjtCDva+Icw8tLKNgMQZhU5wYhFiuapOoA==
X-Received: by 2002:a2e:9746:: with SMTP id f6mr436911ljj.68.1594662445812;
        Mon, 13 Jul 2020 10:47:25 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id i8sm4180729ljg.57.2020.07.13.10.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:25 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
Date:   Mon, 13 Jul 2020 19:46:54 +0200
Message-Id: <20200713174654.642628-17-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to test_progs that exercise:

 - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
 - redirecting socket lookup to a socket selected by BPF program,
 - failing a socket lookup on BPF program's request,
 - error scenarios for selecting a socket from BPF program,
 - accessing BPF program context,
 - attaching and running multiple BPF programs.

Run log:

  # ./test_progs -n 69
  #69/1 query lookup prog:OK
  #69/2 TCP IPv4 redir port:OK
  #69/3 TCP IPv4 redir addr:OK
  #69/4 TCP IPv4 redir with reuseport:OK
  #69/5 TCP IPv4 redir skip reuseport:OK
  #69/6 TCP IPv6 redir port:OK
  #69/7 TCP IPv6 redir addr:OK
  #69/8 TCP IPv4->IPv6 redir port:OK
  #69/9 TCP IPv6 redir with reuseport:OK
  #69/10 TCP IPv6 redir skip reuseport:OK
  #69/11 UDP IPv4 redir port:OK
  #69/12 UDP IPv4 redir addr:OK
  #69/13 UDP IPv4 redir with reuseport:OK
  #69/14 UDP IPv4 redir skip reuseport:OK
  #69/15 UDP IPv6 redir port:OK
  #69/16 UDP IPv6 redir addr:OK
  #69/17 UDP IPv4->IPv6 redir port:OK
  #69/18 UDP IPv6 redir and reuseport:OK
  #69/19 UDP IPv6 redir skip reuseport:OK
  #69/20 TCP IPv4 drop on lookup:OK
  #69/21 TCP IPv6 drop on lookup:OK
  #69/22 UDP IPv4 drop on lookup:OK
  #69/23 UDP IPv6 drop on lookup:OK
  #69/24 TCP IPv4 drop on reuseport:OK
  #69/25 TCP IPv6 drop on reuseport:OK
  #69/26 UDP IPv4 drop on reuseport:OK
  #69/27 TCP IPv6 drop on reuseport:OK
  #69/28 sk_assign returns EEXIST:OK
  #69/29 sk_assign honors F_REPLACE:OK
  #69/30 sk_assign accepts NULL socket:OK
  #69/31 access ctx->sk:OK
  #69/32 narrow access to ctx v4:OK
  #69/33 narrow access to ctx v6:OK
  #69/34 sk_assign rejects TCP established:OK
  #69/35 sk_assign rejects UDP connected:OK
  #69/36 multi prog - pass, pass:OK
  #69/37 multi prog - drop, drop:OK
  #69/38 multi prog - pass, drop:OK
  #69/39 multi prog - drop, pass:OK
  #69/40 multi prog - pass, redir:OK
  #69/41 multi prog - redir, pass:OK
  #69/42 multi prog - drop, redir:OK
  #69/43 multi prog - redir, drop:OK
  #69/44 multi prog - redir, redir:OK
  #69 sk_lookup:OK
  Summary: 1/44 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Remove system("bpftool ...") call left over from debugging. (Lorenz)
    - Dedup BPF code that selects a socket. (Lorenz)
    - Switch from CHECK_FAIL to CHECK macro. (Andrii)
    - Extract a network_helper that wraps inet_pton.
    - Don't restore netns now that test_progs does it.
    - Cover bpf_sk_assign(ctx, NULL) in tests.
    - Cover narrow loads in tests.
    - Cover NULL ctx->sk access attempts in tests.
    - Cover accessing IPv6 ctx fields on IPv4 lookup.
    
    v3:
    - Extend tests to cover new functionality in v3:
      - multi-prog attachments (query, running, verdict precedence)
      - socket selecting for the second time with bpf_sk_assign
      - skipping over reuseport load-balancing
    
    v2:
     - Adjust for fields renames in struct bpf_sk_lookup.

 tools/testing/selftests/bpf/network_helpers.c |   58 +-
 tools/testing/selftests/bpf/network_helpers.h |    2 +
 .../selftests/bpf/prog_tests/sk_lookup.c      | 1282 +++++++++++++++++
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  639 ++++++++
 4 files changed, 1958 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index acd08715be2e..f56655690f9b 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -73,29 +73,8 @@ int start_server(int family, int type, const char *addr_str, __u16 port,
 	socklen_t len;
 	int fd;
 
-	if (family == AF_INET) {
-		struct sockaddr_in *sin = (void *)&addr;
-
-		sin->sin_family = AF_INET;
-		sin->sin_port = htons(port);
-		if (addr_str &&
-		    inet_pton(AF_INET, addr_str, &sin->sin_addr) != 1) {
-			log_err("inet_pton(AF_INET, %s)", addr_str);
-			return -1;
-		}
-		len = sizeof(*sin);
-	} else {
-		struct sockaddr_in6 *sin6 = (void *)&addr;
-
-		sin6->sin6_family = AF_INET6;
-		sin6->sin6_port = htons(port);
-		if (addr_str &&
-		    inet_pton(AF_INET6, addr_str, &sin6->sin6_addr) != 1) {
-			log_err("inet_pton(AF_INET6, %s)", addr_str);
-			return -1;
-		}
-		len = sizeof(*sin6);
-	}
+	if (make_sockaddr(family, addr_str, port, &addr, &len))
+		return -1;
 
 	fd = socket(family, type, 0);
 	if (fd < 0) {
@@ -194,3 +173,36 @@ int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms)
 
 	return 0;
 }
+
+int make_sockaddr(int family, const char *addr_str, __u16 port,
+		  struct sockaddr_storage *addr, socklen_t *len)
+{
+	if (family == AF_INET) {
+		struct sockaddr_in *sin = (void *)addr;
+
+		sin->sin_family = AF_INET;
+		sin->sin_port = htons(port);
+		if (addr_str &&
+		    inet_pton(AF_INET, addr_str, &sin->sin_addr) != 1) {
+			log_err("inet_pton(AF_INET, %s)", addr_str);
+			return -1;
+		}
+		if (len)
+			*len = sizeof(*sin);
+		return 0;
+	} else if (family == AF_INET6) {
+		struct sockaddr_in6 *sin6 = (void *)addr;
+
+		sin6->sin6_family = AF_INET6;
+		sin6->sin6_port = htons(port);
+		if (addr_str &&
+		    inet_pton(AF_INET6, addr_str, &sin6->sin6_addr) != 1) {
+			log_err("inet_pton(AF_INET6, %s)", addr_str);
+			return -1;
+		}
+		if (len)
+			*len = sizeof(*sin6);
+		return 0;
+	}
+	return -1;
+}
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index f580e82fda58..c3728f6667e4 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -37,5 +37,7 @@ int start_server(int family, int type, const char *addr, __u16 port,
 		 int timeout_ms);
 int connect_to_fd(int server_fd, int timeout_ms);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
+int make_sockaddr(int family, const char *addr_str, __u16 port,
+		  struct sockaddr_storage *addr, socklen_t *len);
 
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
new file mode 100644
index 000000000000..992e35ee2bc8
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -0,0 +1,1282 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+/*
+ * Test BPF attach point for INET socket lookup (BPF_SK_LOOKUP).
+ *
+ * Tests exercise:
+ *  - attaching/detaching/querying programs to BPF_SK_LOOKUP hook,
+ *  - redirecting socket lookup to a socket selected by BPF program,
+ *  - failing a socket lookup on BPF program's request,
+ *  - error scenarios for selecting a socket from BPF program,
+ *  - accessing BPF program context,
+ *  - attaching and running multiple BPF programs.
+ *
+ * Tests run in a dedicated network namespace.
+ */
+
+#define _GNU_SOURCE
+#include <arpa/inet.h>
+#include <assert.h>
+#include <errno.h>
+#include <error.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+
+#include "test_progs.h"
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+#include "test_sk_lookup_kern.skel.h"
+
+/* External (address, port) pairs the client sends packets to. */
+#define EXT_IP4		"127.0.0.1"
+#define EXT_IP6		"fd00::1"
+#define EXT_PORT	7007
+
+/* Internal (address, port) pairs the server listens/receives at. */
+#define INT_IP4		"127.0.0.2"
+#define INT_IP4_V6	"::ffff:127.0.0.2"
+#define INT_IP6		"fd00::2"
+#define INT_PORT	8008
+
+#define IO_TIMEOUT_SEC	3
+
+enum server {
+	SERVER_A = 0,
+	SERVER_B = 1,
+	MAX_SERVERS,
+};
+
+enum {
+	PROG1 = 0,
+	PROG2,
+};
+
+struct inet_addr {
+	const char *ip;
+	unsigned short port;
+};
+
+struct test {
+	const char *desc;
+	struct bpf_program *lookup_prog;
+	struct bpf_program *reuseport_prog;
+	struct bpf_map *sock_map;
+	int sotype;
+	struct inet_addr connect_to;
+	struct inet_addr listen_at;
+	enum server accept_on;
+};
+
+static __u32 duration;		/* for CHECK macro */
+
+static bool is_ipv6(const char *ip)
+{
+	return !!strchr(ip, ':');
+}
+
+static int attach_reuseport(int sock_fd, struct bpf_program *reuseport_prog)
+{
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(reuseport_prog);
+	if (prog_fd < 0) {
+		errno = -prog_fd;
+		return -1;
+	}
+
+	err = setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+			 &prog_fd, sizeof(prog_fd));
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static socklen_t inetaddr_len(const struct sockaddr_storage *addr)
+{
+	return (addr->ss_family == AF_INET ? sizeof(struct sockaddr_in) :
+		addr->ss_family == AF_INET6 ? sizeof(struct sockaddr_in6) : 0);
+}
+
+static int make_socket(int sotype, const char *ip, int port,
+		       struct sockaddr_storage *addr)
+{
+	struct timeval timeo = { .tv_sec = IO_TIMEOUT_SEC };
+	int err, family, fd;
+
+	family = is_ipv6(ip) ? AF_INET6 : AF_INET;
+	err = make_sockaddr(family, ip, port, addr, NULL);
+	if (CHECK(err, "make_address", "failed\n"))
+		return -1;
+
+	fd = socket(addr->ss_family, sotype, 0);
+	if (CHECK(fd < 0, "socket", "failed\n")) {
+		log_err("failed to make socket");
+		return -1;
+	}
+
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
+	if (CHECK(err, "setsockopt(SO_SNDTIMEO)", "failed\n")) {
+		log_err("failed to set SNDTIMEO");
+		close(fd);
+		return -1;
+	}
+
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
+	if (CHECK(err, "setsockopt(SO_RCVTIMEO)", "failed\n")) {
+		log_err("failed to set RCVTIMEO");
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+static int make_server(int sotype, const char *ip, int port,
+		       struct bpf_program *reuseport_prog)
+{
+	struct sockaddr_storage addr = {0};
+	const int one = 1;
+	int err, fd = -1;
+
+	fd = make_socket(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	/* Enabled for UDPv6 sockets for IPv4-mapped IPv6 to work. */
+	if (sotype == SOCK_DGRAM) {
+		err = setsockopt(fd, SOL_IP, IP_RECVORIGDSTADDR, &one,
+				 sizeof(one));
+		if (CHECK(err, "setsockopt(IP_RECVORIGDSTADDR)", "failed\n")) {
+			log_err("failed to enable IP_RECVORIGDSTADDR");
+			goto fail;
+		}
+	}
+
+	if (sotype == SOCK_DGRAM && addr.ss_family == AF_INET6) {
+		err = setsockopt(fd, SOL_IPV6, IPV6_RECVORIGDSTADDR, &one,
+				 sizeof(one));
+		if (CHECK(err, "setsockopt(IPV6_RECVORIGDSTADDR)", "failed\n")) {
+			log_err("failed to enable IPV6_RECVORIGDSTADDR");
+			goto fail;
+		}
+	}
+
+	if (sotype == SOCK_STREAM) {
+		err = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one,
+				 sizeof(one));
+		if (CHECK(err, "setsockopt(SO_REUSEADDR)", "failed\n")) {
+			log_err("failed to enable SO_REUSEADDR");
+			goto fail;
+		}
+	}
+
+	if (reuseport_prog) {
+		err = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &one,
+				 sizeof(one));
+		if (CHECK(err, "setsockopt(SO_REUSEPORT)", "failed\n")) {
+			log_err("failed to enable SO_REUSEPORT");
+			goto fail;
+		}
+	}
+
+	err = bind(fd, (void *)&addr, inetaddr_len(&addr));
+	if (CHECK(err, "bind", "failed\n")) {
+		log_err("failed to bind listen socket");
+		goto fail;
+	}
+
+	if (sotype == SOCK_STREAM) {
+		err = listen(fd, SOMAXCONN);
+		if (CHECK(err, "make_server", "listen")) {
+			log_err("failed to listen on port %d", port);
+			goto fail;
+		}
+	}
+
+	/* Late attach reuseport prog so we can have one init path */
+	if (reuseport_prog) {
+		err = attach_reuseport(fd, reuseport_prog);
+		if (CHECK(err, "attach_reuseport", "failed\n")) {
+			log_err("failed to attach reuseport prog");
+			goto fail;
+		}
+	}
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int make_client(int sotype, const char *ip, int port)
+{
+	struct sockaddr_storage addr = {0};
+	int err, fd;
+
+	fd = make_socket(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	err = connect(fd, (void *)&addr, inetaddr_len(&addr));
+	if (CHECK(err, "make_client", "connect")) {
+		log_err("failed to connect client socket");
+		goto fail;
+	}
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+static int send_byte(int fd)
+{
+	ssize_t n;
+
+	errno = 0;
+	n = send(fd, "a", 1, 0);
+	if (CHECK(n <= 0, "send_byte", "send")) {
+		log_err("failed/partial send");
+		return -1;
+	}
+	return 0;
+}
+
+static int recv_byte(int fd)
+{
+	char buf[1];
+	ssize_t n;
+
+	n = recv(fd, buf, sizeof(buf), 0);
+	if (CHECK(n <= 0, "recv_byte", "recv")) {
+		log_err("failed/partial recv");
+		return -1;
+	}
+	return 0;
+}
+
+static int tcp_recv_send(int server_fd)
+{
+	char buf[1];
+	int ret, fd;
+	ssize_t n;
+
+	fd = accept(server_fd, NULL, NULL);
+	if (CHECK(fd < 0, "accept", "failed\n")) {
+		log_err("failed to accept");
+		return -1;
+	}
+
+	n = recv(fd, buf, sizeof(buf), 0);
+	if (CHECK(n <= 0, "recv", "failed\n")) {
+		log_err("failed/partial recv");
+		ret = -1;
+		goto close;
+	}
+
+	n = send(fd, buf, n, 0);
+	if (CHECK(n <= 0, "send", "failed\n")) {
+		log_err("failed/partial send");
+		ret = -1;
+		goto close;
+	}
+
+	ret = 0;
+close:
+	close(fd);
+	return ret;
+}
+
+static void v4_to_v6(struct sockaddr_storage *ss)
+{
+	struct sockaddr_in6 *v6 = (struct sockaddr_in6 *)ss;
+	struct sockaddr_in v4 = *(struct sockaddr_in *)ss;
+
+	v6->sin6_family = AF_INET6;
+	v6->sin6_port = v4.sin_port;
+	v6->sin6_addr.s6_addr[10] = 0xff;
+	v6->sin6_addr.s6_addr[11] = 0xff;
+	memcpy(&v6->sin6_addr.s6_addr[12], &v4.sin_addr.s_addr, 4);
+}
+
+static int udp_recv_send(int server_fd)
+{
+	char cmsg_buf[CMSG_SPACE(sizeof(struct sockaddr_storage))];
+	struct sockaddr_storage _src_addr = { 0 };
+	struct sockaddr_storage *src_addr = &_src_addr;
+	struct sockaddr_storage *dst_addr = NULL;
+	struct msghdr msg = { 0 };
+	struct iovec iov = { 0 };
+	struct cmsghdr *cm;
+	char buf[1];
+	int ret, fd;
+	ssize_t n;
+
+	iov.iov_base = buf;
+	iov.iov_len = sizeof(buf);
+
+	msg.msg_name = src_addr;
+	msg.msg_namelen = sizeof(*src_addr);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+
+	errno = 0;
+	n = recvmsg(server_fd, &msg, 0);
+	if (CHECK(n <= 0, "recvmsg", "failed\n")) {
+		log_err("failed to receive");
+		return -1;
+	}
+	if (CHECK(msg.msg_flags & MSG_CTRUNC, "recvmsg", "truncated cmsg\n"))
+		return -1;
+
+	for (cm = CMSG_FIRSTHDR(&msg); cm; cm = CMSG_NXTHDR(&msg, cm)) {
+		if ((cm->cmsg_level == SOL_IP &&
+		     cm->cmsg_type == IP_ORIGDSTADDR) ||
+		    (cm->cmsg_level == SOL_IPV6 &&
+		     cm->cmsg_type == IPV6_ORIGDSTADDR)) {
+			dst_addr = (struct sockaddr_storage *)CMSG_DATA(cm);
+			break;
+		}
+		log_err("warning: ignored cmsg at level %d type %d",
+			cm->cmsg_level, cm->cmsg_type);
+	}
+	if (CHECK(!dst_addr, "recvmsg", "missing ORIGDSTADDR\n"))
+		return -1;
+
+	/* Server socket bound to IPv4-mapped IPv6 address */
+	if (src_addr->ss_family == AF_INET6 &&
+	    dst_addr->ss_family == AF_INET) {
+		v4_to_v6(dst_addr);
+	}
+
+	/* Reply from original destination address. */
+	fd = socket(dst_addr->ss_family, SOCK_DGRAM, 0);
+	if (CHECK(fd < 0, "socket", "failed\n")) {
+		log_err("failed to create tx socket");
+		return -1;
+	}
+
+	ret = bind(fd, (struct sockaddr *)dst_addr, sizeof(*dst_addr));
+	if (CHECK(ret, "bind", "failed\n")) {
+		log_err("failed to bind tx socket");
+		goto out;
+	}
+
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	n = sendmsg(fd, &msg, 0);
+	if (CHECK(n <= 0, "sendmsg", "failed\n")) {
+		log_err("failed to send echo reply");
+		ret = -1;
+		goto out;
+	}
+
+	ret = 0;
+out:
+	close(fd);
+	return ret;
+}
+
+static int tcp_echo_test(int client_fd, int server_fd)
+{
+	int err;
+
+	err = send_byte(client_fd);
+	if (err)
+		return -1;
+	err = tcp_recv_send(server_fd);
+	if (err)
+		return -1;
+	err = recv_byte(client_fd);
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static int udp_echo_test(int client_fd, int server_fd)
+{
+	int err;
+
+	err = send_byte(client_fd);
+	if (err)
+		return -1;
+	err = udp_recv_send(server_fd);
+	if (err)
+		return -1;
+	err = recv_byte(client_fd);
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static struct bpf_link *attach_lookup_prog(struct bpf_program *prog)
+{
+	struct bpf_link *link;
+	int net_fd;
+
+	net_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK(net_fd < 0, "open", "failed\n")) {
+		log_err("failed to open /proc/self/ns/net");
+		return NULL;
+	}
+
+	link = bpf_program__attach_netns(prog, net_fd);
+	if (CHECK(IS_ERR(link), "bpf_program__attach_netns", "failed\n")) {
+		errno = -PTR_ERR(link);
+		log_err("failed to attach program '%s' to netns",
+			bpf_program__name(prog));
+		link = NULL;
+	}
+
+	close(net_fd);
+	return link;
+}
+
+static int update_lookup_map(struct bpf_map *map, int index, int sock_fd)
+{
+	int err, map_fd;
+	uint64_t value;
+
+	map_fd = bpf_map__fd(map);
+	if (CHECK(map_fd < 0, "bpf_map__fd", "failed\n")) {
+		errno = -map_fd;
+		log_err("failed to get map FD");
+		return -1;
+	}
+
+	value = (uint64_t)sock_fd;
+	err = bpf_map_update_elem(map_fd, &index, &value, BPF_NOEXIST);
+	if (CHECK(err, "bpf_map_update_elem", "failed\n")) {
+		log_err("failed to update redir_map @ %d", index);
+		return -1;
+	}
+
+	return 0;
+}
+
+static __u32 link_info_prog_id(struct bpf_link *link)
+{
+	struct bpf_link_info info = {};
+	__u32 info_len = sizeof(info);
+	int link_fd, err;
+
+	link_fd = bpf_link__fd(link);
+	if (CHECK(link_fd < 0, "bpf_link__fd", "failed\n")) {
+		errno = -link_fd;
+		log_err("bpf_link__fd failed");
+		return 0;
+	}
+
+	err = bpf_obj_get_info_by_fd(link_fd, &info, &info_len);
+	if (CHECK(err, "bpf_obj_get_info_by_fd", "failed\n")) {
+		log_err("bpf_obj_get_info_by_fd");
+		return 0;
+	}
+	if (CHECK(info_len != sizeof(info), "bpf_obj_get_info_by_fd",
+		  "unexpected info len %u\n", info_len))
+		return 0;
+
+	return info.prog_id;
+}
+
+static void query_lookup_prog(struct test_sk_lookup_kern *skel)
+{
+	struct bpf_link *link[3] = {};
+	__u32 attach_flags = 0;
+	__u32 prog_ids[3] = {};
+	__u32 prog_cnt = 3;
+	__u32 prog_id;
+	int net_fd;
+	int err;
+
+	net_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK(net_fd < 0, "open", "failed\n")) {
+		log_err("failed to open /proc/self/ns/net");
+		return;
+	}
+
+	link[0] = attach_lookup_prog(skel->progs.lookup_pass);
+	if (!link[0])
+		goto close;
+	link[1] = attach_lookup_prog(skel->progs.lookup_pass);
+	if (!link[1])
+		goto detach;
+	link[2] = attach_lookup_prog(skel->progs.lookup_drop);
+	if (!link[2])
+		goto detach;
+
+	err = bpf_prog_query(net_fd, BPF_SK_LOOKUP, 0 /* query flags */,
+			     &attach_flags, prog_ids, &prog_cnt);
+	if (CHECK(err, "bpf_prog_query", "failed\n")) {
+		log_err("failed to query lookup prog");
+		goto detach;
+	}
+
+	errno = 0;
+	if (CHECK(attach_flags != 0, "bpf_prog_query",
+		  "wrong attach_flags on query: %u", attach_flags))
+		goto detach;
+	if (CHECK(prog_cnt != 3, "bpf_prog_query",
+		  "wrong program count on query: %u", prog_cnt))
+		goto detach;
+	prog_id = link_info_prog_id(link[0]);
+	CHECK(prog_ids[0] != prog_id, "bpf_prog_query",
+	      "invalid program #0 id on query: %u != %u\n",
+	      prog_ids[0], prog_id);
+	prog_id = link_info_prog_id(link[1]);
+	CHECK(prog_ids[1] != prog_id, "bpf_prog_query",
+	      "invalid program #1 id on query: %u != %u\n",
+	      prog_ids[1], prog_id);
+	prog_id = link_info_prog_id(link[2]);
+	CHECK(prog_ids[2] != prog_id, "bpf_prog_query",
+	      "invalid program #2 id on query: %u != %u\n",
+	      prog_ids[2], prog_id);
+
+detach:
+	if (link[2])
+		bpf_link__destroy(link[2]);
+	if (link[1])
+		bpf_link__destroy(link[1]);
+	if (link[0])
+		bpf_link__destroy(link[0]);
+close:
+	close(net_fd);
+}
+
+static void run_lookup_prog(const struct test *t)
+{
+	int client_fd, server_fds[MAX_SERVERS] = { -1 };
+	struct bpf_link *lookup_link;
+	int i, err;
+
+	lookup_link = attach_lookup_prog(t->lookup_prog);
+	if (!lookup_link)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
+		server_fds[i] = make_server(t->sotype, t->listen_at.ip,
+					    t->listen_at.port,
+					    t->reuseport_prog);
+		if (server_fds[i] < 0)
+			goto close;
+
+		err = update_lookup_map(t->sock_map, i, server_fds[i]);
+		if (err)
+			goto close;
+
+		/* want just one server for non-reuseport test */
+		if (!t->reuseport_prog)
+			break;
+	}
+
+	client_fd = make_client(t->sotype, t->connect_to.ip, t->connect_to.port);
+	if (client_fd < 0)
+		goto close;
+
+	if (t->sotype == SOCK_STREAM)
+		tcp_echo_test(client_fd, server_fds[t->accept_on]);
+	else
+		udp_echo_test(client_fd, server_fds[t->accept_on]);
+
+	close(client_fd);
+close:
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
+		if (server_fds[i] != -1)
+			close(server_fds[i]);
+	}
+	bpf_link__destroy(lookup_link);
+}
+
+static void test_redirect_lookup(struct test_sk_lookup_kern *skel)
+{
+	const struct test tests[] = {
+		{
+			.desc		= "TCP IPv4 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4 redir addr",
+			.lookup_prog	= skel->progs.redir_ip4,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4 redir with reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+			.accept_on	= SERVER_B,
+		},
+		{
+			.desc		= "TCP IPv4 redir skip reuseport",
+			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+			.accept_on	= SERVER_A,
+		},
+		{
+			.desc		= "TCP IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 redir addr",
+			.lookup_prog	= skel->progs.redir_ip6,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4->IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4_V6, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 redir with reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+			.accept_on	= SERVER_B,
+		},
+		{
+			.desc		= "TCP IPv6 redir skip reuseport",
+			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+			.accept_on	= SERVER_A,
+		},
+		{
+			.desc		= "UDP IPv4 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 redir addr",
+			.lookup_prog	= skel->progs.redir_ip4,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 redir with reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+			.accept_on	= SERVER_B,
+		},
+		{
+			.desc		= "UDP IPv4 redir skip reuseport",
+			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+			.accept_on	= SERVER_A,
+		},
+		{
+			.desc		= "UDP IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 redir addr",
+			.lookup_prog	= skel->progs.redir_ip6,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4->IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.listen_at	= { INT_IP4_V6, INT_PORT },
+			.connect_to	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 redir and reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+			.accept_on	= SERVER_B,
+		},
+		{
+			.desc		= "UDP IPv6 redir skip reuseport",
+			.lookup_prog	= skel->progs.select_sock_a_no_reuseport,
+			.reuseport_prog	= skel->progs.select_sock_b,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+			.accept_on	= SERVER_A,
+		},
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (test__start_subtest(t->desc))
+			run_lookup_prog(t);
+	}
+}
+
+static void drop_on_lookup(const struct test *t)
+{
+	struct sockaddr_storage dst = {};
+	int client_fd, server_fd, err;
+	struct bpf_link *lookup_link;
+	ssize_t n;
+
+	lookup_link = attach_lookup_prog(t->lookup_prog);
+	if (!lookup_link)
+		return;
+
+	server_fd = make_server(t->sotype, t->listen_at.ip, t->listen_at.port,
+				t->reuseport_prog);
+	if (server_fd < 0)
+		goto detach;
+
+	client_fd = make_socket(t->sotype, t->connect_to.ip,
+				t->connect_to.port, &dst);
+	if (client_fd < 0)
+		goto close_srv;
+
+	err = connect(client_fd, (void *)&dst, inetaddr_len(&dst));
+	if (t->sotype == SOCK_DGRAM) {
+		err = send_byte(client_fd);
+		if (err)
+			goto close_all;
+
+		/* Read out asynchronous error */
+		n = recv(client_fd, NULL, 0, 0);
+		err = n == -1;
+	}
+	if (CHECK(!err || errno != ECONNREFUSED, "connect",
+		  "unexpected success or error\n"))
+		log_err("expected ECONNREFUSED on connect");
+
+close_all:
+	close(client_fd);
+close_srv:
+	close(server_fd);
+detach:
+	bpf_link__destroy(lookup_link);
+}
+
+static void test_drop_on_lookup(struct test_sk_lookup_kern *skel)
+{
+	const struct test tests[] = {
+		{
+			.desc		= "TCP IPv4 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { EXT_IP6, INT_PORT },
+		},
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (test__start_subtest(t->desc))
+			drop_on_lookup(t);
+	}
+}
+
+static void drop_on_reuseport(const struct test *t)
+{
+	struct sockaddr_storage dst = { 0 };
+	int client, server1, server2, err;
+	struct bpf_link *lookup_link;
+	ssize_t n;
+
+	lookup_link = attach_lookup_prog(t->lookup_prog);
+	if (!lookup_link)
+		return;
+
+	server1 = make_server(t->sotype, t->listen_at.ip, t->listen_at.port,
+			      t->reuseport_prog);
+	if (server1 < 0)
+		goto detach;
+
+	err = update_lookup_map(t->sock_map, SERVER_A, server1);
+	if (err)
+		goto detach;
+
+	/* second server on destination address we should never reach */
+	server2 = make_server(t->sotype, t->connect_to.ip, t->connect_to.port,
+			      NULL /* reuseport prog */);
+	if (server2 < 0)
+		goto close_srv1;
+
+	client = make_socket(t->sotype, t->connect_to.ip,
+			     t->connect_to.port, &dst);
+	if (client < 0)
+		goto close_srv2;
+
+	err = connect(client, (void *)&dst, inetaddr_len(&dst));
+	if (t->sotype == SOCK_DGRAM) {
+		err = send_byte(client);
+		if (err)
+			goto close_all;
+
+		/* Read out asynchronous error */
+		n = recv(client, NULL, 0, 0);
+		err = n == -1;
+	}
+	if (CHECK(!err || errno != ECONNREFUSED, "connect",
+		  "unexpected success or error\n"))
+		log_err("expected ECONNREFUSED on connect");
+
+close_all:
+	close(client);
+close_srv2:
+	close(server2);
+close_srv1:
+	close(server1);
+detach:
+	bpf_link__destroy(lookup_link);
+}
+
+static void test_drop_on_reuseport(struct test_sk_lookup_kern *skel)
+{
+	const struct test tests[] = {
+		{
+			.desc		= "TCP IPv4 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.connect_to	= { EXT_IP4, EXT_PORT },
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.connect_to	= { EXT_IP6, EXT_PORT },
+			.listen_at	= { INT_IP6, INT_PORT },
+		},
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (test__start_subtest(t->desc))
+			drop_on_reuseport(t);
+	}
+}
+
+static void run_sk_assign(struct test_sk_lookup_kern *skel,
+			  struct bpf_program *lookup_prog,
+			  const char *listen_ip, const char *connect_ip)
+{
+	int client_fd, peer_fd, server_fds[MAX_SERVERS] = { -1 };
+	struct bpf_link *lookup_link;
+	int i, err;
+
+	lookup_link = attach_lookup_prog(lookup_prog);
+	if (!lookup_link)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
+		server_fds[i] = make_server(SOCK_STREAM, listen_ip, 0, NULL);
+		if (server_fds[i] < 0)
+			goto close_servers;
+
+		err = update_lookup_map(skel->maps.redir_map, i,
+					server_fds[i]);
+		if (err)
+			goto close_servers;
+	}
+
+	client_fd = make_client(SOCK_STREAM, connect_ip, EXT_PORT);
+	if (client_fd < 0)
+		goto close_servers;
+
+	peer_fd = accept(server_fds[SERVER_B], NULL, NULL);
+	if (CHECK(peer_fd < 0, "accept", "failed\n"))
+		goto close_client;
+
+	close(peer_fd);
+close_client:
+	close(client_fd);
+close_servers:
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
+		if (server_fds[i] != -1)
+			close(server_fds[i]);
+	}
+	bpf_link__destroy(lookup_link);
+}
+
+static void run_sk_assign_v4(struct test_sk_lookup_kern *skel,
+			     struct bpf_program *lookup_prog)
+{
+	run_sk_assign(skel, lookup_prog, INT_IP4, EXT_IP4);
+}
+
+static void run_sk_assign_v6(struct test_sk_lookup_kern *skel,
+			     struct bpf_program *lookup_prog)
+{
+	run_sk_assign(skel, lookup_prog, INT_IP6, EXT_IP6);
+}
+
+static void run_sk_assign_connected(struct test_sk_lookup_kern *skel,
+				    int sotype)
+{
+	int err, client_fd, connected_fd, server_fd;
+	struct bpf_link *lookup_link;
+
+	server_fd = make_server(sotype, EXT_IP4, EXT_PORT, NULL);
+	if (server_fd < 0)
+		return;
+
+	connected_fd = make_client(sotype, EXT_IP4, EXT_PORT);
+	if (connected_fd < 0)
+		goto out_close_server;
+
+	/* Put a connected socket in redirect map */
+	err = update_lookup_map(skel->maps.redir_map, SERVER_A, connected_fd);
+	if (err)
+		goto out_close_connected;
+
+	lookup_link = attach_lookup_prog(skel->progs.sk_assign_esocknosupport);
+	if (!lookup_link)
+		goto out_close_connected;
+
+	/* Try to redirect TCP SYN / UDP packet to a connected socket */
+	client_fd = make_client(sotype, EXT_IP4, EXT_PORT);
+	if (client_fd < 0)
+		goto out_unlink_prog;
+	if (sotype == SOCK_DGRAM) {
+		send_byte(client_fd);
+		recv_byte(server_fd);
+	}
+
+	close(client_fd);
+out_unlink_prog:
+	bpf_link__destroy(lookup_link);
+out_close_connected:
+	close(connected_fd);
+out_close_server:
+	close(server_fd);
+}
+
+static void test_sk_assign_helper(struct test_sk_lookup_kern *skel)
+{
+	if (test__start_subtest("sk_assign returns EEXIST"))
+		run_sk_assign_v4(skel, skel->progs.sk_assign_eexist);
+	if (test__start_subtest("sk_assign honors F_REPLACE"))
+		run_sk_assign_v4(skel, skel->progs.sk_assign_replace_flag);
+	if (test__start_subtest("sk_assign accepts NULL socket"))
+		run_sk_assign_v4(skel, skel->progs.sk_assign_null);
+	if (test__start_subtest("access ctx->sk"))
+		run_sk_assign_v4(skel, skel->progs.access_ctx_sk);
+	if (test__start_subtest("narrow access to ctx v4"))
+		run_sk_assign_v4(skel, skel->progs.ctx_narrow_access);
+	if (test__start_subtest("narrow access to ctx v6"))
+		run_sk_assign_v6(skel, skel->progs.ctx_narrow_access);
+	if (test__start_subtest("sk_assign rejects TCP established"))
+		run_sk_assign_connected(skel, SOCK_STREAM);
+	if (test__start_subtest("sk_assign rejects UDP connected"))
+		run_sk_assign_connected(skel, SOCK_DGRAM);
+}
+
+struct test_multi_prog {
+	const char *desc;
+	struct bpf_program *prog1;
+	struct bpf_program *prog2;
+	struct bpf_map *redir_map;
+	struct bpf_map *run_map;
+	int expect_errno;
+	struct inet_addr listen_at;
+};
+
+static void run_multi_prog_lookup(const struct test_multi_prog *t)
+{
+	struct sockaddr_storage dst = {};
+	int map_fd, server_fd, client_fd;
+	struct bpf_link *link1, *link2;
+	int prog_idx, done, err;
+
+	map_fd = bpf_map__fd(t->run_map);
+
+	done = 0;
+	prog_idx = PROG1;
+	err = bpf_map_update_elem(map_fd, &prog_idx, &done, BPF_ANY);
+	if (CHECK(err, "bpf_map_update_elem", "failed\n"))
+		return;
+	prog_idx = PROG2;
+	err = bpf_map_update_elem(map_fd, &prog_idx, &done, BPF_ANY);
+	if (CHECK(err, "bpf_map_update_elem", "failed\n"))
+		return;
+
+	link1 = attach_lookup_prog(t->prog1);
+	if (!link1)
+		return;
+	link2 = attach_lookup_prog(t->prog2);
+	if (!link2)
+		goto out_unlink1;
+
+	server_fd = make_server(SOCK_STREAM, t->listen_at.ip,
+				t->listen_at.port, NULL);
+	if (server_fd < 0)
+		goto out_unlink2;
+
+	err = update_lookup_map(t->redir_map, SERVER_A, server_fd);
+	if (err)
+		goto out_close_server;
+
+	client_fd = make_socket(SOCK_STREAM, EXT_IP4, EXT_PORT, &dst);
+	if (client_fd < 0)
+		goto out_close_server;
+
+	err = connect(client_fd, (void *)&dst, inetaddr_len(&dst));
+	if (CHECK(err && !t->expect_errno, "connect",
+		  "unexpected error %d\n", errno))
+		goto out_close_client;
+	if (CHECK(err && t->expect_errno && errno != t->expect_errno,
+		  "connect", "unexpected error %d\n", errno))
+		goto out_close_client;
+
+	done = 0;
+	prog_idx = PROG1;
+	err = bpf_map_lookup_elem(map_fd, &prog_idx, &done);
+	CHECK(err, "bpf_map_lookup_elem", "failed\n");
+	CHECK(!done, "bpf_map_lookup_elem", "PROG1 !done\n");
+
+	done = 0;
+	prog_idx = PROG2;
+	err = bpf_map_lookup_elem(map_fd, &prog_idx, &done);
+	CHECK(err, "bpf_map_lookup_elem", "failed\n");
+	CHECK(!done, "bpf_map_lookup_elem", "PROG2 !done\n");
+
+out_close_client:
+	close(client_fd);
+out_close_server:
+	close(server_fd);
+out_unlink2:
+	bpf_link__destroy(link2);
+out_unlink1:
+	bpf_link__destroy(link1);
+}
+
+static void test_multi_prog_lookup(struct test_sk_lookup_kern *skel)
+{
+	struct test_multi_prog tests[] = {
+		{
+			.desc		= "multi prog - pass, pass",
+			.prog1		= skel->progs.multi_prog_pass1,
+			.prog2		= skel->progs.multi_prog_pass2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "multi prog - drop, drop",
+			.prog1		= skel->progs.multi_prog_drop1,
+			.prog2		= skel->progs.multi_prog_drop2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+			.expect_errno	= ECONNREFUSED,
+		},
+		{
+			.desc		= "multi prog - pass, drop",
+			.prog1		= skel->progs.multi_prog_pass1,
+			.prog2		= skel->progs.multi_prog_drop2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+			.expect_errno	= ECONNREFUSED,
+		},
+		{
+			.desc		= "multi prog - drop, pass",
+			.prog1		= skel->progs.multi_prog_drop1,
+			.prog2		= skel->progs.multi_prog_pass2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+			.expect_errno	= ECONNREFUSED,
+		},
+		{
+			.desc		= "multi prog - pass, redir",
+			.prog1		= skel->progs.multi_prog_pass1,
+			.prog2		= skel->progs.multi_prog_redir2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "multi prog - redir, pass",
+			.prog1		= skel->progs.multi_prog_redir1,
+			.prog2		= skel->progs.multi_prog_pass2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "multi prog - drop, redir",
+			.prog1		= skel->progs.multi_prog_drop1,
+			.prog2		= skel->progs.multi_prog_redir2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "multi prog - redir, drop",
+			.prog1		= skel->progs.multi_prog_redir1,
+			.prog2		= skel->progs.multi_prog_drop2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "multi prog - redir, redir",
+			.prog1		= skel->progs.multi_prog_redir1,
+			.prog2		= skel->progs.multi_prog_redir2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+	};
+	struct test_multi_prog *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		t->redir_map = skel->maps.redir_map;
+		t->run_map = skel->maps.run_map;
+		if (test__start_subtest(t->desc))
+			run_multi_prog_lookup(t);
+	}
+}
+
+static void run_tests(struct test_sk_lookup_kern *skel)
+{
+	if (test__start_subtest("query lookup prog"))
+		query_lookup_prog(skel);
+	test_redirect_lookup(skel);
+	test_drop_on_lookup(skel);
+	test_drop_on_reuseport(skel);
+	test_sk_assign_helper(skel);
+	test_multi_prog_lookup(skel);
+}
+
+static int switch_netns(void)
+{
+	static const char * const setup_script[] = {
+		"ip -6 addr add dev lo " EXT_IP6 "/128 nodad",
+		"ip -6 addr add dev lo " INT_IP6 "/128 nodad",
+		"ip link set dev lo up",
+		NULL,
+	};
+	const char * const *cmd;
+	int err;
+
+	err = unshare(CLONE_NEWNET);
+	if (CHECK(err, "unshare", "failed\n")) {
+		log_err("unshare(CLONE_NEWNET)");
+		return -1;
+	}
+
+	for (cmd = setup_script; *cmd; cmd++) {
+		err = system(*cmd);
+		if (CHECK(err, "system", "failed\n")) {
+			log_err("system(%s)", *cmd);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+void test_sk_lookup(void)
+{
+	struct test_sk_lookup_kern *skel;
+	int err;
+
+	err = switch_netns();
+	if (err)
+		return;
+
+	skel = test_sk_lookup_kern__open_and_load();
+	if (CHECK(!skel, "skel open_and_load", "failed\n"))
+		return;
+
+	run_tests(skel);
+
+	test_sk_lookup_kern__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
new file mode 100644
index 000000000000..b6d2ca75ac91
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -0,0 +1,639 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
+#include <errno.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <linux/bpf.h>
+#include <linux/in.h>
+#include <sys/socket.h>
+
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_helpers.h>
+
+#define IP4(a, b, c, d)					\
+	bpf_htonl((((__u32)(a) & 0xffU) << 24) |	\
+		  (((__u32)(b) & 0xffU) << 16) |	\
+		  (((__u32)(c) & 0xffU) <<  8) |	\
+		  (((__u32)(d) & 0xffU) <<  0))
+#define IP6(aaaa, bbbb, cccc, dddd)			\
+	{ bpf_htonl(aaaa), bpf_htonl(bbbb), bpf_htonl(cccc), bpf_htonl(dddd) }
+
+#define MAX_SOCKS 32
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, MAX_SOCKS);
+	__type(key, __u32);
+	__type(value, __u64);
+} redir_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, int);
+} run_map SEC(".maps");
+
+enum {
+	PROG1 = 0,
+	PROG2,
+};
+
+enum {
+	SERVER_A = 0,
+	SERVER_B,
+};
+
+/* Addressable key/value constants for convenience */
+static const int KEY_PROG1 = PROG1;
+static const int KEY_PROG2 = PROG2;
+static const int PROG_DONE = 1;
+
+static const __u32 KEY_SERVER_A = SERVER_A;
+static const __u32 KEY_SERVER_B = SERVER_B;
+
+static const __u16 DST_PORT = 7007; /* Host byte order */
+static const __u32 DST_IP4 = IP4(127, 0, 0, 1);
+static const __u32 DST_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000001);
+
+SEC("sk_lookup/lookup_pass")
+int lookup_pass(struct bpf_sk_lookup *ctx)
+{
+	return SK_PASS;
+}
+
+SEC("sk_lookup/lookup_drop")
+int lookup_drop(struct bpf_sk_lookup *ctx)
+{
+	return SK_DROP;
+}
+
+SEC("sk_reuseport/reuse_pass")
+int reuseport_pass(struct sk_reuseport_md *ctx)
+{
+	return SK_PASS;
+}
+
+SEC("sk_reuseport/reuse_drop")
+int reuseport_drop(struct sk_reuseport_md *ctx)
+{
+	return SK_DROP;
+}
+
+/* Redirect packets destined for port DST_PORT to socket at redir_map[0]. */
+SEC("sk_lookup/redir_port")
+int redir_port(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->local_port != DST_PORT)
+		return SK_PASS;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_PASS;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? SK_DROP : SK_PASS;
+}
+
+/* Redirect packets destined for DST_IP4 address to socket at redir_map[0]. */
+SEC("sk_lookup/redir_ip4")
+int redir_ip4(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->family != AF_INET)
+		return SK_PASS;
+	if (ctx->local_port != DST_PORT)
+		return SK_PASS;
+	if (ctx->local_ip4 != DST_IP4)
+		return SK_PASS;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_PASS;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? SK_DROP : SK_PASS;
+}
+
+/* Redirect packets destined for DST_IP6 address to socket at redir_map[0]. */
+SEC("sk_lookup/redir_ip6")
+int redir_ip6(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->family != AF_INET6)
+		return SK_PASS;
+	if (ctx->local_port != DST_PORT)
+		return SK_PASS;
+	if (ctx->local_ip6[0] != DST_IP6[0] ||
+	    ctx->local_ip6[1] != DST_IP6[1] ||
+	    ctx->local_ip6[2] != DST_IP6[2] ||
+	    ctx->local_ip6[3] != DST_IP6[3])
+		return SK_PASS;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_PASS;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? SK_DROP : SK_PASS;
+}
+
+SEC("sk_lookup/select_sock_a")
+int select_sock_a(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_PASS;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? SK_DROP : SK_PASS;
+}
+
+SEC("sk_lookup/select_sock_a_no_reuseport")
+int select_sock_a_no_reuseport(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_DROP;
+
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_NO_REUSEPORT);
+	bpf_sk_release(sk);
+	return err ? SK_DROP : SK_PASS;
+}
+
+SEC("sk_reuseport/select_sock_b")
+int select_sock_b(struct sk_reuseport_md *ctx)
+{
+	__u32 key = KEY_SERVER_B;
+	int err;
+
+	err = bpf_sk_select_reuseport(ctx, &redir_map, &key, 0);
+	return err ? SK_DROP : SK_PASS;
+}
+
+/* Check that bpf_sk_assign() returns -EEXIST if socket already selected. */
+SEC("sk_lookup/sk_assign_eexist")
+int sk_assign_eexist(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, ret;
+
+	ret = SK_DROP;
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, 0);
+	if (err)
+		goto out;
+	bpf_sk_release(sk);
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, 0);
+	if (err != -EEXIST) {
+		bpf_printk("sk_assign returned %d, expected %d\n",
+			   err, -EEXIST);
+		goto out;
+	}
+
+	ret = SK_PASS; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+/* Check that bpf_sk_assign(BPF_SK_LOOKUP_F_REPLACE) can override selection. */
+SEC("sk_lookup/sk_assign_replace_flag")
+int sk_assign_replace_flag(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, ret;
+
+	ret = SK_DROP;
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, 0);
+	if (err)
+		goto out;
+	bpf_sk_release(sk);
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_REPLACE);
+	if (err) {
+		bpf_printk("sk_assign returned %d, expected 0\n", err);
+		goto out;
+	}
+
+	ret = SK_PASS; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+/* Check that bpf_sk_assign(sk=NULL) is accepted. */
+SEC("sk_lookup/sk_assign_null")
+int sk_assign_null(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk = NULL;
+	int err, ret;
+
+	ret = SK_DROP;
+
+	err = bpf_sk_assign(ctx, NULL, 0);
+	if (err) {
+		bpf_printk("sk_assign returned %d, expected 0\n", err);
+		goto out;
+	}
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_REPLACE);
+	if (err) {
+		bpf_printk("sk_assign returned %d, expected 0\n", err);
+		goto out;
+	}
+
+	if (ctx->sk != sk)
+		goto out;
+	err = bpf_sk_assign(ctx, NULL, 0);
+	if (err != -EEXIST)
+		goto out;
+	err = bpf_sk_assign(ctx, NULL, BPF_SK_LOOKUP_F_REPLACE);
+	if (err)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_REPLACE);
+	if (err)
+		goto out;
+
+	ret = SK_PASS; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+/* Check that selected sk is accessible through context. */
+SEC("sk_lookup/access_ctx_sk")
+int access_ctx_sk(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk1 = NULL, *sk2 = NULL;
+	int err, ret;
+
+	ret = SK_DROP;
+
+	/* Try accessing unassigned (NULL) ctx->sk field */
+	if (ctx->sk && ctx->sk->family != AF_INET)
+		goto out;
+
+	/* Assign a value to ctx->sk */
+	sk1 = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk1)
+		goto out;
+	err = bpf_sk_assign(ctx, sk1, 0);
+	if (err)
+		goto out;
+	if (ctx->sk != sk1)
+		goto out;
+
+	/* Access ctx->sk fields */
+	if (ctx->sk->family != AF_INET ||
+	    ctx->sk->type != SOCK_STREAM ||
+	    ctx->sk->state != BPF_TCP_LISTEN)
+		goto out;
+
+	/* Reset selection */
+	err = bpf_sk_assign(ctx, NULL, BPF_SK_LOOKUP_F_REPLACE);
+	if (err)
+		goto out;
+	if (ctx->sk)
+		goto out;
+
+	/* Assign another socket */
+	sk2 = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (!sk2)
+		goto out;
+	err = bpf_sk_assign(ctx, sk2, BPF_SK_LOOKUP_F_REPLACE);
+	if (err)
+		goto out;
+	if (ctx->sk != sk2)
+		goto out;
+
+	/* Access reassigned ctx->sk fields */
+	if (ctx->sk->family != AF_INET ||
+	    ctx->sk->type != SOCK_STREAM ||
+	    ctx->sk->state != BPF_TCP_LISTEN)
+		goto out;
+
+	ret = SK_PASS; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk1)
+		bpf_sk_release(sk1);
+	if (sk2)
+		bpf_sk_release(sk2);
+	return ret;
+}
+
+/* Check narrow loads from ctx fields that support them */
+SEC("sk_lookup/ctx_narrow_access")
+int ctx_narrow_access(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, family;
+	__u16 *half;
+	__u8 *byte;
+	bool v4;
+
+	v4 = (ctx->family == AF_INET);
+
+	/* Narrow loads from family field */
+	byte = (__u8 *)&ctx->family;
+	half = (__u16 *)&ctx->family;
+	if (byte[0] != (v4 ? AF_INET : AF_INET6) ||
+	    byte[1] != 0 || byte[2] != 0 || byte[3] != 0)
+		return SK_DROP;
+	if (half[0] != (v4 ? AF_INET : AF_INET6) ||
+	    half[1] != 0)
+		return SK_DROP;
+
+	byte = (__u8 *)&ctx->protocol;
+	if (byte[0] != IPPROTO_TCP ||
+	    byte[1] != 0 || byte[2] != 0 || byte[3] != 0)
+		return SK_DROP;
+	half = (__u16 *)&ctx->protocol;
+	if (half[0] != IPPROTO_TCP ||
+	    half[1] != 0)
+		return SK_DROP;
+
+	/* Narrow loads from remote_port field. Expect non-0 value. */
+	byte = (__u8 *)&ctx->remote_port;
+	if (byte[0] == 0 && byte[1] == 0 && byte[2] == 0 && byte[3] == 0)
+		return SK_DROP;
+	half = (__u16 *)&ctx->remote_port;
+	if (half[0] == 0 && half[1] == 0)
+		return SK_DROP;
+
+	/* Narrow loads from local_port field. Expect DST_PORT. */
+	byte = (__u8 *)&ctx->local_port;
+	if (byte[0] != ((DST_PORT >> 0) & 0xff) ||
+	    byte[1] != ((DST_PORT >> 8) & 0xff) ||
+	    byte[2] != 0 || byte[3] != 0)
+		return SK_DROP;
+	half = (__u16 *)&ctx->local_port;
+	if (half[0] != DST_PORT ||
+	    half[1] != 0)
+		return SK_DROP;
+
+	/* Narrow loads from IPv4 fields */
+	if (v4) {
+		/* Expect non-0.0.0.0 in remote_ip4 */
+		byte = (__u8 *)&ctx->remote_ip4;
+		if (byte[0] == 0 && byte[1] == 0 &&
+		    byte[2] == 0 && byte[3] == 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->remote_ip4;
+		if (half[0] == 0 && half[1] == 0)
+			return SK_DROP;
+
+		/* Expect DST_IP4 in local_ip4 */
+		byte = (__u8 *)&ctx->local_ip4;
+		if (byte[0] != ((DST_IP4 >>  0) & 0xff) ||
+		    byte[1] != ((DST_IP4 >>  8) & 0xff) ||
+		    byte[2] != ((DST_IP4 >> 16) & 0xff) ||
+		    byte[3] != ((DST_IP4 >> 24) & 0xff))
+			return SK_DROP;
+		half = (__u16 *)&ctx->local_ip4;
+		if (half[0] != ((DST_IP4 >>  0) & 0xffff) ||
+		    half[1] != ((DST_IP4 >> 16) & 0xffff))
+			return SK_DROP;
+	} else {
+		/* Expect 0.0.0.0 IPs when family != AF_INET */
+		byte = (__u8 *)&ctx->remote_ip4;
+		if (byte[0] != 0 || byte[1] != 0 &&
+		    byte[2] != 0 || byte[3] != 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->remote_ip4;
+		if (half[0] != 0 || half[1] != 0)
+			return SK_DROP;
+
+		byte = (__u8 *)&ctx->local_ip4;
+		if (byte[0] != 0 || byte[1] != 0 &&
+		    byte[2] != 0 || byte[3] != 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->local_ip4;
+		if (half[0] != 0 || half[1] != 0)
+			return SK_DROP;
+	}
+
+	/* Narrow loads from IPv6 fields */
+	if (!v4) {
+		/* Expenct non-:: IP in remote_ip6 */
+		byte = (__u8 *)&ctx->remote_ip6;
+		if (byte[0] == 0 && byte[1] == 0 &&
+		    byte[2] == 0 && byte[3] == 0 &&
+		    byte[4] == 0 && byte[5] == 0 &&
+		    byte[6] == 0 && byte[7] == 0 &&
+		    byte[8] == 0 && byte[9] == 0 &&
+		    byte[10] == 0 && byte[11] == 0 &&
+		    byte[12] == 0 && byte[13] == 0 &&
+		    byte[14] == 0 && byte[15] == 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->remote_ip6;
+		if (half[0] == 0 && half[1] == 0 &&
+		    half[2] == 0 && half[3] == 0 &&
+		    half[4] == 0 && half[5] == 0 &&
+		    half[6] == 0 && half[7] == 0)
+			return SK_DROP;
+
+		/* Expect DST_IP6 in local_ip6 */
+		byte = (__u8 *)&ctx->local_ip6;
+		if (byte[0] != ((DST_IP6[0] >>  0) & 0xff) ||
+		    byte[1] != ((DST_IP6[0] >>  8) & 0xff) ||
+		    byte[2] != ((DST_IP6[0] >> 16) & 0xff) ||
+		    byte[3] != ((DST_IP6[0] >> 24) & 0xff) ||
+		    byte[4] != ((DST_IP6[1] >>  0) & 0xff) ||
+		    byte[5] != ((DST_IP6[1] >>  8) & 0xff) ||
+		    byte[6] != ((DST_IP6[1] >> 16) & 0xff) ||
+		    byte[7] != ((DST_IP6[1] >> 24) & 0xff) ||
+		    byte[8] != ((DST_IP6[2] >>  0) & 0xff) ||
+		    byte[9] != ((DST_IP6[2] >>  8) & 0xff) ||
+		    byte[10] != ((DST_IP6[2] >> 16) & 0xff) ||
+		    byte[11] != ((DST_IP6[2] >> 24) & 0xff) ||
+		    byte[12] != ((DST_IP6[3] >>  0) & 0xff) ||
+		    byte[13] != ((DST_IP6[3] >>  8) & 0xff) ||
+		    byte[14] != ((DST_IP6[3] >> 16) & 0xff) ||
+		    byte[15] != ((DST_IP6[3] >> 24) & 0xff))
+			return SK_DROP;
+		half = (__u16 *)&ctx->local_ip6;
+		if (half[0] != ((DST_IP6[0] >>  0) & 0xffff) ||
+		    half[1] != ((DST_IP6[0] >> 16) & 0xffff) ||
+		    half[2] != ((DST_IP6[1] >>  0) & 0xffff) ||
+		    half[3] != ((DST_IP6[1] >> 16) & 0xffff) ||
+		    half[4] != ((DST_IP6[2] >>  0) & 0xffff) ||
+		    half[5] != ((DST_IP6[2] >> 16) & 0xffff) ||
+		    half[6] != ((DST_IP6[3] >>  0) & 0xffff) ||
+		    half[7] != ((DST_IP6[3] >> 16) & 0xffff))
+			return SK_DROP;
+	} else {
+		/* Expect :: IPs when family != AF_INET6 */
+		byte = (__u8 *)&ctx->remote_ip6;
+		if (byte[0] != 0 || byte[1] != 0 ||
+		    byte[2] != 0 || byte[3] != 0 ||
+		    byte[4] != 0 || byte[5] != 0 ||
+		    byte[6] != 0 || byte[7] != 0 ||
+		    byte[8] != 0 || byte[9] != 0 ||
+		    byte[10] != 0 || byte[11] != 0 ||
+		    byte[12] != 0 || byte[13] != 0 ||
+		    byte[14] != 0 || byte[15] != 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->remote_ip6;
+		if (half[0] != 0 || half[1] != 0 ||
+		    half[2] != 0 || half[3] != 0 ||
+		    half[4] != 0 || half[5] != 0 ||
+		    half[6] != 0 || half[7] != 0)
+			return SK_DROP;
+
+		byte = (__u8 *)&ctx->local_ip6;
+		if (byte[0] != 0 || byte[1] != 0 ||
+		    byte[2] != 0 || byte[3] != 0 ||
+		    byte[4] != 0 || byte[5] != 0 ||
+		    byte[6] != 0 || byte[7] != 0 ||
+		    byte[8] != 0 || byte[9] != 0 ||
+		    byte[10] != 0 || byte[11] != 0 ||
+		    byte[12] != 0 || byte[13] != 0 ||
+		    byte[14] != 0 || byte[15] != 0)
+			return SK_DROP;
+		half = (__u16 *)&ctx->local_ip6;
+		if (half[0] != 0 || half[1] != 0 ||
+		    half[2] != 0 || half[3] != 0 ||
+		    half[4] != 0 || half[5] != 0 ||
+		    half[6] != 0 || half[7] != 0)
+			return SK_DROP;
+	}
+
+	/* Success, redirect to KEY_SERVER_B */
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (sk) {
+		bpf_sk_assign(ctx, sk, 0);
+		bpf_sk_release(sk);
+	}
+	return SK_PASS;
+}
+
+/* Check that sk_assign rejects SERVER_A socket with -ESOCKNOSUPPORT */
+SEC("sk_lookup/sk_assign_esocknosupport")
+int sk_assign_esocknosupport(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, ret;
+
+	ret = SK_DROP;
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		goto out;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	if (err != -ESOCKTNOSUPPORT) {
+		bpf_printk("sk_assign returned %d, expected %d\n",
+			   err, -ESOCKTNOSUPPORT);
+		goto out;
+	}
+
+	ret = SK_PASS; /* Success, pass to regular lookup */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+SEC("sk_lookup/multi_prog_pass1")
+int multi_prog_pass1(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return SK_PASS;
+}
+
+SEC("sk_lookup/multi_prog_pass2")
+int multi_prog_pass2(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return SK_PASS;
+}
+
+SEC("sk_lookup/multi_prog_drop1")
+int multi_prog_drop1(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return SK_DROP;
+}
+
+SEC("sk_lookup/multi_prog_drop2")
+int multi_prog_drop2(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return SK_DROP;
+}
+
+static __always_inline int select_server_a(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return SK_DROP;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	if (err)
+		return SK_DROP;
+
+	return SK_PASS;
+}
+
+SEC("sk_lookup/multi_prog_redir1")
+int multi_prog_redir1(struct bpf_sk_lookup *ctx)
+{
+	int ret;
+
+	ret = select_server_a(ctx);
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return SK_PASS;
+}
+
+SEC("sk_lookup/multi_prog_redir2")
+int multi_prog_redir2(struct bpf_sk_lookup *ctx)
+{
+	int ret;
+
+	ret = select_server_a(ctx);
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return SK_PASS;
+}
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+__u32 _version SEC("version") = 1;
-- 
2.25.4

