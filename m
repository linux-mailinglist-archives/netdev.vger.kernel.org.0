Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72C06211FD4
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgGBJY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728344AbgGBJYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:48 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2424C08C5DC
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:47 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a8so21680078edy.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RiR1nb5xG4xbHIGFWpiGm8bXTqbTsatbTZIaGLEOpMY=;
        b=cUTx/+ugae7nYqgLD/ae7F5EM16IJVQ4lTcMPhp0QBpT4jlnZukZ8NW39miiBwTt2C
         /JFHzleIfQXkbWQAD1g8JijOO8bvh5ASL1tNB27jPLVewLYpiDpALpOjnNxUNwSqgcOC
         UwwwswR7glGuC9UMshalSMTCAqViYyBYXMMOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RiR1nb5xG4xbHIGFWpiGm8bXTqbTsatbTZIaGLEOpMY=;
        b=UxnJ6rzkUYHONpVGHucuaZBpO1YY1+QIeJTjfFaJjpxmA2ZOFFisFz87ekdNBq/AAm
         7U82izQXFKCo1aM0nOeIteOLO01bGKHJJ8XdO+Lq2fAWgz5jlTTBl+H3edQynl0n48a5
         FS0ZcMsvVRKKRGTYDE/NyBmme/Gc/j03pn0AgW1dMTdBomN0IS0Wr2t99krci9m5VWgT
         kTDYjRHmYWuqrHlWkc3vl68velSzDxEsAVjRMweLFM9GzkF0f5mK9R/WE2QTNTxIS31Z
         0LIEPSbmv9cAoQaTnYcmqZIP6Q7OnXJxyaixmTj7ScDP4HJfj6ar5DYHYaIMaCu0wqrP
         iUdw==
X-Gm-Message-State: AOAM533sSwWyJbVc8d+AVm0WHuImu4lE0ySsxVx7/X18qlu79JaO6lpu
        dnfenMWqgQQvkt1c/UOCzYwzKA==
X-Google-Smtp-Source: ABdhPJzvExERhBUoB7C5H0tzrcKsiEUaIYGQR6IoSCi3dCM6V+EDFA9mWo5H9EinVQ/Oh7UReedaVA==
X-Received: by 2002:a50:a45d:: with SMTP id v29mr33413207edb.284.1593681886296;
        Thu, 02 Jul 2020 02:24:46 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u2sm8989557edq.29.2020.07.02.02.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:45 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 16/16] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
Date:   Thu,  2 Jul 2020 11:24:16 +0200
Message-Id: <20200702092416.11961-17-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
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
| # ./test_progs -n 68
| #68/1 query lookup prog:OK
| #68/2 TCP IPv4 redir port:OK
| #68/3 TCP IPv4 redir addr:OK
| #68/4 TCP IPv4 redir with reuseport:OK
| #68/5 TCP IPv4 redir skip reuseport:OK
| #68/6 TCP IPv6 redir port:OK
| #68/7 TCP IPv6 redir addr:OK
| #68/8 TCP IPv4->IPv6 redir port:OK
| #68/9 TCP IPv6 redir with reuseport:OK
| #68/10 TCP IPv6 redir skip reuseport:OK
| #68/11 UDP IPv4 redir port:OK
| #68/12 UDP IPv4 redir addr:OK
| #68/13 UDP IPv4 redir with reuseport:OK
| #68/14 UDP IPv4 redir skip reuseport:OK
| #68/15 UDP IPv6 redir port:OK
| #68/16 UDP IPv6 redir addr:OK
| #68/17 UDP IPv4->IPv6 redir port:OK
| #68/18 UDP IPv6 redir and reuseport:OK
| #68/19 UDP IPv6 redir skip reuseport:OK
| #68/20 TCP IPv4 drop on lookup:OK
| #68/21 TCP IPv6 drop on lookup:OK
| #68/22 UDP IPv4 drop on lookup:OK
| #68/23 UDP IPv6 drop on lookup:OK
| #68/24 TCP IPv4 drop on reuseport:OK
| #68/25 TCP IPv6 drop on reuseport:OK
| #68/26 UDP IPv4 drop on reuseport:OK
| #68/27 TCP IPv6 drop on reuseport:OK
| #68/28 sk_assign returns EEXIST:OK
| #68/29 sk_assign honors F_REPLACE:OK
| #68/30 access ctx->sk:OK
| #68/31 sk_assign rejects TCP established:OK
| #68/32 sk_assign rejects UDP connected:OK
| #68/33 multi prog - pass, pass:OK
| #68/34 multi prog - pass, inval:OK
| #68/35 multi prog - inval, pass:OK
| #68/36 multi prog - drop, drop:OK
| #68/37 multi prog - pass, drop:OK
| #68/38 multi prog - drop, pass:OK
| #68/39 multi prog - drop, inval:OK
| #68/40 multi prog - inval, drop:OK
| #68/41 multi prog - pass, redir:OK
| #68/42 multi prog - redir, pass:OK
| #68/43 multi prog - drop, redir:OK
| #68/44 multi prog - redir, drop:OK
| #68/45 multi prog - inval, redir:OK
| #68/46 multi prog - redir, inval:OK
| #68/47 multi prog - redir, redir:OK
| #68 sk_lookup:OK
| Summary: 1/47 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - Extend tests to cover new functionality in v3:
      - multi-prog attachments (query, running, verdict precedence)
      - socket selecting for the second time with bpf_sk_assign
      - skipping over reuseport load-balancing
    
    v2:
     - Adjust for fields renames in struct bpf_sk_lookup.

 .../selftests/bpf/prog_tests/sk_lookup.c      | 1353 +++++++++++++++++
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  399 +++++
 2 files changed, 1752 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
new file mode 100644
index 000000000000..2859dc7e65b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -0,0 +1,1353 @@
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
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "cgroup_helpers.h"
+#include "test_sk_lookup_kern.skel.h"
+#include "test_progs.h"
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
+static bool is_ipv6(const char *ip)
+{
+	return !!strchr(ip, ':');
+}
+
+static int make_addr(const char *ip, int port, struct sockaddr_storage *addr)
+{
+	struct sockaddr_in6 *addr6 = (void *)addr;
+	struct sockaddr_in *addr4 = (void *)addr;
+	int ret;
+
+	errno = 0;
+	if (is_ipv6(ip)) {
+		ret = inet_pton(AF_INET6, ip, &addr6->sin6_addr);
+		if (CHECK_FAIL(ret <= 0)) {
+			log_err("failed to convert IPv6 address '%s'", ip);
+			return -1;
+		}
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(port);
+	} else {
+		ret = inet_pton(AF_INET, ip, &addr4->sin_addr);
+		if (CHECK_FAIL(ret <= 0)) {
+			log_err("failed to convert IPv4 address '%s'", ip);
+			return -1;
+		}
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(port);
+	}
+	return 0;
+}
+
+static int setup_reuseport_prog(int sock_fd, struct bpf_program *reuseport_prog)
+{
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(reuseport_prog);
+	if (prog_fd < 0) {
+		errno = -prog_fd;
+		log_err("failed to get fd for program '%s'",
+			bpf_program__name(reuseport_prog));
+		return -1;
+	}
+
+	err = setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+			 &prog_fd, sizeof(prog_fd));
+	if (CHECK_FAIL(err)) {
+		log_err("failed to ATTACH_REUSEPORT_EBPF");
+		return -1;
+	}
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
+static int make_socket_with_addr(int sotype, const char *ip, int port,
+				 struct sockaddr_storage *addr)
+{
+	struct timeval timeo = { .tv_sec = IO_TIMEOUT_SEC };
+	int err, fd;
+
+	err = make_addr(ip, port, addr);
+	if (err)
+		return -1;
+
+	fd = socket(addr->ss_family, sotype, 0);
+	if (CHECK_FAIL(fd < 0)) {
+		log_err("failed to create listen socket");
+		return -1;
+	}
+
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo, sizeof(timeo));
+	if (CHECK_FAIL(err)) {
+		log_err("failed to set SO_SNDTIMEO");
+		return -1;
+	}
+
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo, sizeof(timeo));
+	if (CHECK_FAIL(err)) {
+		log_err("failed to set SO_RCVTIMEO");
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
+	fd = make_socket_with_addr(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	/* Enabled for UDPv6 sockets for IPv4-mapped IPv6 to work. */
+	if (sotype == SOCK_DGRAM) {
+		err = setsockopt(fd, SOL_IP, IP_RECVORIGDSTADDR, &one,
+				 sizeof(one));
+		if (CHECK_FAIL(err)) {
+			log_err("failed to enable IP_RECVORIGDSTADDR");
+			goto fail;
+		}
+	}
+
+	if (sotype == SOCK_DGRAM && addr.ss_family == AF_INET6) {
+		err = setsockopt(fd, SOL_IPV6, IPV6_RECVORIGDSTADDR, &one,
+				 sizeof(one));
+		if (CHECK_FAIL(err)) {
+			log_err("failed to enable IPV6_RECVORIGDSTADDR");
+			goto fail;
+		}
+	}
+
+	if (sotype == SOCK_STREAM) {
+		err = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one,
+				 sizeof(one));
+		if (CHECK_FAIL(err)) {
+			log_err("failed to enable SO_REUSEADDR");
+			goto fail;
+		}
+	}
+
+	if (reuseport_prog) {
+		err = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &one,
+				 sizeof(one));
+		if (CHECK_FAIL(err)) {
+			log_err("failed to enable SO_REUSEPORT");
+			goto fail;
+		}
+	}
+
+	err = bind(fd, (void *)&addr, inetaddr_len(&addr));
+	if (CHECK_FAIL(err)) {
+		log_err("failed to bind listen socket");
+		goto fail;
+	}
+
+	if (sotype == SOCK_STREAM) {
+		err = listen(fd, SOMAXCONN);
+		if (CHECK_FAIL(err)) {
+			log_err("failed to listen on port %d", port);
+			goto fail;
+		}
+	}
+
+	/* Late attach reuseport prog so we can have one init path */
+	if (reuseport_prog) {
+		err = setup_reuseport_prog(fd, reuseport_prog);
+		if (err)
+			goto fail;
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
+	fd = make_socket_with_addr(sotype, ip, port, &addr);
+	if (fd < 0)
+		return -1;
+
+	err = connect(fd, (void *)&addr, inetaddr_len(&addr));
+	if (CHECK_FAIL(err)) {
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
+	if (CHECK_FAIL(n <= 0)) {
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
+	if (CHECK_FAIL(n <= 0)) {
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
+	if (CHECK_FAIL(fd < 0)) {
+		log_err("failed to accept");
+		return -1;
+	}
+
+	n = recv(fd, buf, sizeof(buf), 0);
+	if (CHECK_FAIL(n <= 0)) {
+		log_err("failed/partial recv");
+		ret = -1;
+		goto close;
+	}
+
+	n = send(fd, buf, n, 0);
+	if (CHECK_FAIL(n <= 0)) {
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
+	if (CHECK_FAIL(n <= 0)) {
+		log_err("failed to receive");
+		return -1;
+	}
+	if (CHECK_FAIL(msg.msg_flags & MSG_CTRUNC)) {
+		log_err("truncated cmsg");
+		return -1;
+	}
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
+	if (CHECK_FAIL(!dst_addr)) {
+		log_err("failed to get destination address");
+		return -1;
+	}
+
+	/* Server socket bound to IPv4-mapped IPv6 address */
+	if (src_addr->ss_family == AF_INET6 &&
+	    dst_addr->ss_family == AF_INET) {
+		v4_to_v6(dst_addr);
+	}
+
+	/* Reply from original destination address. */
+	fd = socket(dst_addr->ss_family, SOCK_DGRAM, 0);
+	if (CHECK_FAIL(fd < 0)) {
+		log_err("failed to create tx socket");
+		return -1;
+	}
+
+	ret = bind(fd, (struct sockaddr *)dst_addr, sizeof(*dst_addr));
+	if (CHECK_FAIL(ret)) {
+		log_err("failed to bind tx socket");
+		goto out;
+	}
+
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	n = sendmsg(fd, &msg, 0);
+	if (CHECK_FAIL(n <= 0)) {
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
+	if (CHECK_FAIL(net_fd < 0)) {
+		log_err("failed to open /proc/self/ns/net");
+		return NULL;
+	}
+
+	link = bpf_program__attach_netns(prog, net_fd);
+	if (CHECK_FAIL(IS_ERR(link))) {
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
+	if (CHECK_FAIL(map_fd < 0)) {
+		errno = -map_fd;
+		log_err("failed to get map FD");
+		return -1;
+	}
+
+	value = (uint64_t)sock_fd;
+	err = bpf_map_update_elem(map_fd, &index, &value, BPF_NOEXIST);
+	if (CHECK_FAIL(err)) {
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
+	if (CHECK_FAIL(link_fd < 0)) {
+		errno = -link_fd;
+		log_err("bpf_link__fd failed");
+		return 0;
+	}
+
+	err = bpf_obj_get_info_by_fd(link_fd, &info, &info_len);
+	if (CHECK_FAIL(err || info_len != sizeof(info))) {
+		log_err("bpf_obj_get_info_by_fd");
+		return 0;
+	}
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
+	if (CHECK_FAIL(net_fd < 0)) {
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
+	if (CHECK_FAIL(err)) {
+		log_err("failed to query lookup prog");
+		goto detach;
+	}
+
+	system("/home/jkbs/src/linux/tools/bpf/bpftool/bpftool link show");
+
+	errno = 0;
+	if (CHECK_FAIL(attach_flags != 0)) {
+		log_err("wrong attach_flags on query: %u", attach_flags);
+		goto detach;
+	}
+	if (CHECK_FAIL(prog_cnt != 3)) {
+		log_err("wrong program count on query: %u", prog_cnt);
+		goto detach;
+	}
+	prog_id = link_info_prog_id(link[0]);
+	if (CHECK_FAIL(prog_ids[0] != prog_id)) {
+		log_err("invalid program id on query: %u != %u",
+			prog_ids[0], prog_id);
+		goto detach;
+	}
+	prog_id = link_info_prog_id(link[1]);
+	if (CHECK_FAIL(prog_ids[1] != prog_id)) {
+		log_err("invalid program id on query: %u != %u",
+			prog_ids[1], prog_id);
+		goto detach;
+	}
+	prog_id = link_info_prog_id(link[2]);
+	if (CHECK_FAIL(prog_ids[2] != prog_id)) {
+		log_err("invalid program id on query: %u != %u",
+			prog_ids[2], prog_id);
+		goto detach;
+	}
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
+	client_fd = make_socket_with_addr(t->sotype, t->connect_to.ip,
+					  t->connect_to.port, &dst);
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
+	if (CHECK_FAIL(!err || errno != ECONNREFUSED))
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
+	client = make_socket_with_addr(t->sotype, t->connect_to.ip,
+				       t->connect_to.port, &dst);
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
+	if (CHECK_FAIL(!err || errno != ECONNREFUSED))
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
+			  struct bpf_program *lookup_prog)
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
+		server_fds[i] = make_server(SOCK_STREAM, INT_IP4, 0, NULL);
+		if (server_fds[i] < 0)
+			goto close_servers;
+
+		err = update_lookup_map(skel->maps.redir_map, i,
+					server_fds[i]);
+		if (err)
+			goto close_servers;
+	}
+
+	client_fd = make_client(SOCK_STREAM, EXT_IP4, EXT_PORT);
+	if (client_fd < 0)
+		goto close_servers;
+
+	peer_fd = accept(server_fds[SERVER_B], NULL, NULL);
+	if (CHECK_FAIL(peer_fd < 0))
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
+		run_sk_assign(skel, skel->progs.sk_assign_eexist);
+	if (test__start_subtest("sk_assign honors F_REPLACE"))
+		run_sk_assign(skel, skel->progs.sk_assign_replace_flag);
+	if (test__start_subtest("access ctx->sk"))
+		run_sk_assign(skel, skel->progs.access_ctx_sk);
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
+	CHECK_FAIL(bpf_map_update_elem(map_fd, &prog_idx, &done, BPF_ANY));
+	prog_idx = PROG2;
+	CHECK_FAIL(bpf_map_update_elem(map_fd, &prog_idx, &done, BPF_ANY));
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
+	client_fd = make_socket_with_addr(SOCK_STREAM, EXT_IP4, EXT_PORT,
+					  &dst);
+	if (client_fd < 0)
+		goto out_close_server;
+
+	err = connect(client_fd, (void *)&dst, inetaddr_len(&dst));
+	if (CHECK_FAIL(err && !t->expect_errno))
+		goto out_close_client;
+	if (CHECK_FAIL(err && t->expect_errno && errno != t->expect_errno))
+		goto out_close_client;
+
+	done = 0;
+	prog_idx = PROG1;
+	CHECK_FAIL(bpf_map_lookup_elem(map_fd, &prog_idx, &done));
+	CHECK_FAIL(!done);
+
+	done = 0;
+	prog_idx = PROG2;
+	CHECK_FAIL(bpf_map_lookup_elem(map_fd, &prog_idx, &done));
+	CHECK_FAIL(!done);
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
+			.desc		= "multi prog - pass, inval",
+			.prog1		= skel->progs.multi_prog_pass1,
+			.prog2		= skel->progs.multi_prog_inval2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "multi prog - inval, pass",
+			.prog1		= skel->progs.multi_prog_inval1,
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
+			.desc		= "multi prog - drop, inval",
+			.prog1		= skel->progs.multi_prog_drop1,
+			.prog2		= skel->progs.multi_prog_inval2,
+			.listen_at	= { EXT_IP4, EXT_PORT },
+			.expect_errno	= ECONNREFUSED,
+		},
+		{
+			.desc		= "multi prog - inval, drop",
+			.prog1		= skel->progs.multi_prog_inval1,
+			.prog2		= skel->progs.multi_prog_drop2,
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
+			.desc		= "multi prog - inval, redir",
+			.prog1		= skel->progs.multi_prog_inval1,
+			.prog2		= skel->progs.multi_prog_redir2,
+			.listen_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "multi prog - redir, inval",
+			.prog1		= skel->progs.multi_prog_redir1,
+			.prog2		= skel->progs.multi_prog_inval2,
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
+static int switch_netns(int *saved_net)
+{
+	static const char * const setup_script[] = {
+		"ip -6 addr add dev lo " EXT_IP6 "/128 nodad",
+		"ip -6 addr add dev lo " INT_IP6 "/128 nodad",
+		"ip link set dev lo up",
+		NULL,
+	};
+	const char * const *cmd;
+	int net_fd, err;
+
+	net_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(net_fd < 0)) {
+		log_err("open(/proc/self/ns/net)");
+		return -1;
+	}
+
+	err = unshare(CLONE_NEWNET);
+	if (CHECK_FAIL(err)) {
+		log_err("unshare(CLONE_NEWNET)");
+		goto close;
+	}
+
+	for (cmd = setup_script; *cmd; cmd++) {
+		err = system(*cmd);
+		if (CHECK_FAIL(err)) {
+			log_err("system(%s)", *cmd);
+			goto close;
+		}
+	}
+
+	*saved_net = net_fd;
+	return 0;
+
+close:
+	close(net_fd);
+	return -1;
+}
+
+static void restore_netns(int saved_net)
+{
+	int err;
+
+	err = setns(saved_net, CLONE_NEWNET);
+	if (CHECK_FAIL(err))
+		log_err("setns(CLONE_NEWNET)");
+
+	close(saved_net);
+}
+
+void test_sk_lookup(void)
+{
+	struct test_sk_lookup_kern *skel;
+	int err, saved_net;
+
+	err = switch_netns(&saved_net);
+	if (err)
+		return;
+
+	skel = test_sk_lookup_kern__open_and_load();
+	if (CHECK_FAIL(!skel)) {
+		errno = 0;
+		log_err("failed to open and load BPF skeleton");
+		goto restore_netns;
+	}
+
+	run_tests(skel);
+
+	test_sk_lookup_kern__destroy(skel);
+restore_netns:
+	restore_netns(saved_net);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
new file mode 100644
index 000000000000..75745898fd3b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
+#include <errno.h>
+#include <linux/bpf.h>
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
+static const __u32 DST_PORT = 7007;
+static const __u32 DST_IP4 = IP4(127, 0, 0, 1);
+static const __u32 DST_IP6[] = IP6(0xfd000000, 0x0, 0x0, 0x00000001);
+
+SEC("sk_lookup/lookup_pass")
+int lookup_pass(struct bpf_sk_lookup *ctx)
+{
+	return BPF_OK;
+}
+
+SEC("sk_lookup/lookup_drop")
+int lookup_drop(struct bpf_sk_lookup *ctx)
+{
+	return BPF_DROP;
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
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
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
+		return BPF_OK;
+	if (ctx->local_port != DST_PORT)
+		return BPF_OK;
+	if (ctx->local_ip4 != DST_IP4)
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
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
+		return BPF_OK;
+	if (ctx->local_port != DST_PORT)
+		return BPF_OK;
+	if (ctx->local_ip6[0] != DST_IP6[0] ||
+	    ctx->local_ip6[1] != DST_IP6[1] ||
+	    ctx->local_ip6[2] != DST_IP6[2] ||
+	    ctx->local_ip6[3] != DST_IP6[3])
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
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
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
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
+		return BPF_DROP;
+
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_NO_REUSEPORT);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
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
+	ret = BPF_DROP;
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
+	ret = BPF_REDIRECT; /* Success, redirect to KEY_SERVER_B */
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
+	ret = BPF_DROP;
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
+	ret = BPF_REDIRECT; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+/* Check that selected sk is accessible thru context. */
+SEC("sk_lookup/access_ctx_sk")
+int access_ctx_sk(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, ret;
+
+	ret = BPF_DROP;
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, 0);
+	if (err)
+		goto out;
+	if (sk != ctx->sk) {
+		bpf_printk("expected ctx->sk == KEY_SERVER_A\n");
+		goto out;
+	}
+	bpf_sk_release(sk);
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_B);
+	if (!sk)
+		goto out;
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_REPLACE);
+	if (err)
+		goto out;
+	if (sk != ctx->sk) {
+		bpf_printk("expected ctx->sk == KEY_SERVER_B\n");
+		goto out;
+	}
+
+	ret = BPF_REDIRECT; /* Success, redirect to KEY_SERVER_B */
+out:
+	if (sk)
+		bpf_sk_release(sk);
+	return ret;
+}
+
+/* Check that sk_assign rejects KEY_SERVER_A socket with -ESOCKNOSUPPORT */
+SEC("sk_lookup/sk_assign_esocknosupport")
+int sk_assign_esocknosupport(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err, ret;
+
+	ret = BPF_DROP;
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
+	ret = BPF_OK; /* Success, pass to regular lookup */
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
+	return BPF_OK;
+}
+
+SEC("sk_lookup/multi_prog_pass2")
+int multi_prog_pass2(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return BPF_OK;
+}
+
+SEC("sk_lookup/multi_prog_drop1")
+int multi_prog_drop1(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return BPF_DROP;
+}
+
+SEC("sk_lookup/multi_prog_drop2")
+int multi_prog_drop2(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return BPF_DROP;
+}
+
+SEC("sk_lookup/multi_prog_inval1")
+int multi_prog_inval1(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return -1;
+}
+
+SEC("sk_lookup/multi_prog_inval2")
+int multi_prog_inval2(struct bpf_sk_lookup *ctx)
+{
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return -1;
+}
+
+SEC("sk_lookup/multi_prog_redir1")
+int multi_prog_redir1(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return BPF_DROP;
+
+	err = bpf_sk_assign(ctx, sk, 0);
+	bpf_sk_release(sk);
+	if (err)
+		return BPF_DROP;
+
+	bpf_map_update_elem(&run_map, &KEY_PROG1, &PROG_DONE, BPF_ANY);
+	return BPF_REDIRECT;
+}
+
+SEC("sk_lookup/multi_prog_redir2")
+int multi_prog_redir2(struct bpf_sk_lookup *ctx)
+{
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &KEY_SERVER_A);
+	if (!sk)
+		return BPF_DROP;
+
+	err = bpf_sk_assign(ctx, sk, BPF_SK_LOOKUP_F_REPLACE);
+	bpf_sk_release(sk);
+	if (err)
+		return BPF_DROP;
+
+	bpf_map_update_elem(&run_map, &KEY_PROG2, &PROG_DONE, BPF_ANY);
+	return BPF_REDIRECT;
+}
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+__u32 _version SEC("version") = 1;
-- 
2.25.4

