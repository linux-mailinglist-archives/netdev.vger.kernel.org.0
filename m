Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A811C710D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgEFMzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728812AbgEFMzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:44 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E1AC061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:43 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x4so2487456wmj.1
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wwrb+ggig85Lbce7LjoCjuL+gizkbZ61dA0vTOGxaVw=;
        b=R1rm0ZUKZtbzXwUfxToobPgD7U3mkxBoB7QikpLltnL0Aa5YnNeiMXndJxEeCznvUm
         u0b0uoRnzBF/gq6NgAG+Vn8ZJX3UDAQxhWL5P4ZJ7eBHX61dUCJDV1IYtQvVHdkJza+N
         u5ft41XcKth4HfHCz0J1NHjcl/EHO8L1dFOZk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wwrb+ggig85Lbce7LjoCjuL+gizkbZ61dA0vTOGxaVw=;
        b=IqfZF7te498GAF8ICX9u5tbX0gjPsGcJXfFKjPlLDvi9izJhppz2TwcxecH4f5QSb6
         gOTdGxHNzoR/DfLbe2Zg90pVzBQA9H58PhertnI+217k/Te61yLH0fbBtT85lPtmBdZJ
         9b4VBWaLXaNOxpTv3psN++HzUrwrvxF41j76M1ePtHYT+xE0Ctaou44c0IGi8K06wGe7
         LopgQ++9VfSwvio5Pw7PoZCJXyY+4TDfXPIOT9qvqZc+5Ldj7SkLRClIhgumXjh4Hp/R
         dYVQIfLmleqfLcvlvfIHkQhkAsKQq7jMmO5b50M5n7bBGpIjVpt2RjVIJntaWRfCIiVi
         PIcw==
X-Gm-Message-State: AGi0Puae5Kh5aIW075kM+7++dnLh3ETtfkaIrzzhTFbFf+nC0CO01kzb
        NOG9x1hlqLwdr+vU5mVhSZTqMFuRYXk=
X-Google-Smtp-Source: APiQypJDZQLxUVtO+/SAwYklI1q55ri09cur0wtzcU7P3rGNZ0m6nZNXvpQxNePk/228v6CY5skjVQ==
X-Received: by 2002:a1c:e1c1:: with SMTP id y184mr4386623wmg.143.1588769741263;
        Wed, 06 May 2020 05:55:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 92sm2610611wrm.71.2020.05.06.05.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:40 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 17/17] selftests/bpf: Tests for BPF_SK_LOOKUP attach point
Date:   Wed,  6 May 2020 14:55:13 +0200
Message-Id: <20200506125514.1020829-18-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests to test_progs that exercise:

 - attaching/detaching/querying sk_lookup program,
 - overriding socket lookup result for TCP/UDP with BPF sk_lookup by
   a) selecting a socket fetched from a SOCKMAP, or
   b) failing the lookup with no match.

Tests cover two special cases:

 - selecting an IPv6 socket (non v6-only) to receive an IPv4 packet,
 - using BPF sk_lookup together with BPF sk_reuseport program.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sk_lookup.c      | 999 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_lookup_kern.c | 162 +++
 2 files changed, 1161 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
new file mode 100644
index 000000000000..96765b156f6f
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -0,0 +1,999 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+/*
+ * Test BPF attach point for INET socket lookup (BPF_SK_LOOKUP).
+ *
+ * Tests exercise:
+ *
+ * 1. attaching/detaching/querying BPF sk_lookup program,
+ * 2. overriding socket lookup result by:
+ *    a) selecting a listening (TCP) or receiving (UDP) socket,
+ *    b) failing the lookup with no match.
+ *
+ * Special cases covered are:
+ * - selecting an IPv6 socket (non v6-only) to receive an IPv4 packet,
+ * - using BPF sk_lookup together with BPF sk_reuseport program.
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
+enum {
+	SERVER_A = 0,
+	SERVER_B = 1,
+	MAX_SERVERS,
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
+	struct inet_addr send_to;
+	struct inet_addr recv_at;
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
+static int attach_lookup_prog(struct bpf_program *prog)
+{
+	const char *prog_name = bpf_program__name(prog);
+	enum bpf_attach_type attach_type;
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(prog_fd < 0)) {
+		errno = -prog_fd;
+		log_err("failed to get fd for program '%s'", prog_name);
+		return -1;
+	}
+
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	err = bpf_prog_attach(prog_fd, -1 /* target fd */, attach_type, 0);
+	if (CHECK_FAIL(err)) {
+		log_err("failed to attach program '%s'", prog_name);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int detach_lookup_prog(struct bpf_program *prog)
+{
+	const char *prog_name = bpf_program__name(prog);
+	enum bpf_attach_type attach_type;
+	int err, prog_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (CHECK_FAIL(prog_fd < 0)) {
+		errno = -prog_fd;
+		log_err("failed to get fd for program '%s'", prog_name);
+		return -1;
+	}
+
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	err = bpf_prog_detach2(prog_fd, -1 /* attachable fd */, attach_type);
+	if (CHECK_FAIL(err)) {
+		log_err("failed to detach program '%s'", prog_name);
+		return -1;
+	}
+
+	return 0;
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
+static void query_lookup_prog(struct test_sk_lookup_kern *skel)
+{
+	struct bpf_program *lookup_prog = skel->progs.lookup_pass;
+	enum bpf_attach_type attach_type;
+	__u32 attach_flags = 0;
+	__u32 prog_ids[1] = { 0 };
+	__u32 prog_cnt = 1;
+	int net_fd = -1;
+	int err;
+
+	net_fd = open("/proc/self/ns/net", O_RDONLY);
+	if (CHECK_FAIL(net_fd < 0)) {
+		log_err("failed to open /proc/self/ns/net");
+		return;
+	}
+
+	err = attach_lookup_prog(lookup_prog);
+	if (err)
+		goto close;
+
+	attach_type = bpf_program__get_expected_attach_type(lookup_prog);
+	err = bpf_prog_query(net_fd, attach_type, 0 /* query flags */,
+			     &attach_flags, prog_ids, &prog_cnt);
+	if (CHECK_FAIL(err)) {
+		log_err("failed to query lookup prog");
+		goto detach;
+	}
+
+	errno = 0;
+	if (CHECK_FAIL(attach_flags != 0)) {
+		log_err("wrong attach_flags on query: %u", attach_flags);
+		goto detach;
+	}
+	if (CHECK_FAIL(prog_cnt != 1)) {
+		log_err("wrong program count on query: %u", prog_cnt);
+		goto detach;
+	}
+	if (CHECK_FAIL(prog_ids[0] == 0)) {
+		log_err("invalid program id on query: %u", prog_ids[0]);
+		goto detach;
+	}
+
+detach:
+	detach_lookup_prog(lookup_prog);
+close:
+	close(net_fd);
+}
+
+static void run_lookup_prog(const struct test *t)
+{
+	int client_fd, server_fds[MAX_SERVERS] = { -1 };
+	int i, err, server_idx;
+
+	err = attach_lookup_prog(t->lookup_prog);
+	if (err)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++) {
+		server_fds[i] = make_server(t->sotype, t->recv_at.ip,
+					    t->recv_at.port, t->reuseport_prog);
+		if (server_fds[i] < 0)
+			goto close;
+
+		err = update_lookup_map(t->sock_map, i, server_fds[i]);
+		if (err)
+			goto detach;
+
+		/* want just one server for non-reuseport test */
+		if (!t->reuseport_prog)
+			break;
+	}
+
+	client_fd = make_client(t->sotype, t->send_to.ip, t->send_to.port);
+	if (client_fd < 0)
+		goto close;
+
+	/* reuseport prog always selects server B */
+	server_idx = t->reuseport_prog ? SERVER_B : SERVER_A;
+
+	if (t->sotype == SOCK_STREAM)
+		tcp_echo_test(client_fd, server_fds[server_idx]);
+	else
+		udp_echo_test(client_fd, server_fds[server_idx]);
+
+	close(client_fd);
+close:
+	for (i = 0; i < ARRAY_SIZE(server_fds); i++)
+		close(server_fds[i]);
+detach:
+	detach_lookup_prog(t->lookup_prog);
+}
+
+static void test_override_lookup(struct test_sk_lookup_kern *skel)
+{
+	const struct test tests[] = {
+		{
+			.desc		= "TCP IPv4 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { EXT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4 redir addr",
+			.lookup_prog	= skel->progs.redir_ip4,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4 redir and reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, INT_PORT },
+			.reuseport_prog	= skel->progs.select_sock_b,
+		},
+		{
+			.desc		= "TCP IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { EXT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 redir addr",
+			.lookup_prog	= skel->progs.redir_ip6,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv4->IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.recv_at	= { INT_IP4_V6, INT_PORT },
+			.send_to	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 redir and reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, INT_PORT },
+			.reuseport_prog	= skel->progs.select_sock_b,
+		},
+		{
+			.desc		= "UDP IPv4 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { EXT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 redir addr",
+			.lookup_prog	= skel->progs.redir_ip4,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 redir and reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, INT_PORT },
+			.reuseport_prog	= skel->progs.select_sock_b,
+		},
+		{
+			.desc		= "UDP IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { EXT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 redir addr",
+			.lookup_prog	= skel->progs.redir_ip6,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4->IPv6 redir port",
+			.lookup_prog	= skel->progs.redir_port,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.recv_at	= { INT_IP4_V6, INT_PORT },
+			.send_to	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 redir and reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, INT_PORT },
+			.reuseport_prog	= skel->progs.select_sock_b,
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
+	struct sockaddr_storage dst = { 0 };
+	int client_fd, server_fd, err;
+	ssize_t n;
+
+	if (attach_lookup_prog(t->lookup_prog))
+		return;
+
+	server_fd = make_server(t->sotype, t->recv_at.ip, t->recv_at.port,
+				t->reuseport_prog);
+	if (server_fd < 0)
+		goto detach;
+
+	client_fd = make_socket_with_addr(t->sotype, t->send_to.ip,
+					  t->send_to.port, &dst);
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
+	detach_lookup_prog(t->lookup_prog);
+}
+
+static void test_drop_on_lookup(struct test_sk_lookup_kern *skel)
+{
+	const struct test tests[] = {
+		{
+			.desc		= "TCP IPv4 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { EXT_IP6, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { EXT_IP4, EXT_PORT },
+		},
+		{
+			.desc		= "UDP IPv6 drop on lookup",
+			.lookup_prog	= skel->progs.lookup_drop,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { EXT_IP6, INT_PORT },
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
+	ssize_t n;
+
+	if (attach_lookup_prog(t->lookup_prog))
+		return;
+
+	server1 = make_server(t->sotype, t->recv_at.ip, t->recv_at.port,
+			      t->reuseport_prog);
+	if (server1 < 0)
+		goto detach;
+
+	err = update_lookup_map(t->sock_map, SERVER_A, server1);
+	if (err)
+		goto detach;
+
+	/* second server on destination address we should never reach */
+	server2 = make_server(t->sotype, t->send_to.ip, t->send_to.port,
+			      NULL /* reuseport prog */);
+	if (server2 < 0)
+		goto close_srv1;
+
+	client = make_socket_with_addr(t->sotype, t->send_to.ip,
+				       t->send_to.port, &dst);
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
+	detach_lookup_prog(t->lookup_prog);
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
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, INT_PORT },
+		},
+		{
+			.desc		= "UDP IPv4 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_DGRAM,
+			.send_to	= { EXT_IP4, EXT_PORT },
+			.recv_at	= { INT_IP4, INT_PORT },
+		},
+		{
+			.desc		= "TCP IPv6 drop on reuseport",
+			.lookup_prog	= skel->progs.select_sock_a,
+			.reuseport_prog	= skel->progs.reuseport_drop,
+			.sock_map	= skel->maps.redir_map,
+			.sotype		= SOCK_STREAM,
+			.send_to	= { EXT_IP6, EXT_PORT },
+			.recv_at	= { INT_IP6, INT_PORT },
+		},
+
+	};
+	const struct test *t;
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		if (test__start_subtest(t->desc))
+			drop_on_reuseport(t);
+	}
+}
+
+static void run_tests(struct test_sk_lookup_kern *skel)
+{
+	if (test__start_subtest("query lookup prog"))
+		query_lookup_prog(skel);
+	test_override_lookup(skel);
+	test_drop_on_lookup(skel);
+	test_drop_on_reuseport(skel);
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
index 000000000000..4ad7c6842487
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup_kern.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
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
+enum {
+	SERVER_A = 0,
+	SERVER_B = 1,
+};
+
+enum {
+	NO_FLAGS = 0,
+};
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
+	__u32 key = SERVER_A;
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->dst_port != DST_PORT)
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &key);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, NO_FLAGS);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
+}
+
+/* Redirect packets destined for DST_IP4 address to socket at redir_map[0]. */
+SEC("sk_lookup/redir_ip4")
+int redir_ip4(struct bpf_sk_lookup *ctx)
+{
+	__u32 key = SERVER_A;
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->family != AF_INET)
+		return BPF_OK;
+	if (ctx->dst_port != DST_PORT)
+		return BPF_OK;
+	if (ctx->dst_ip4 != DST_IP4)
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &key);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, NO_FLAGS);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
+}
+
+/* Redirect packets destined for DST_IP6 address to socket at redir_map[0]. */
+SEC("sk_lookup/redir_ip6")
+int redir_ip6(struct bpf_sk_lookup *ctx)
+{
+	__u32 key = SERVER_A;
+	struct bpf_sock *sk;
+	int err;
+
+	if (ctx->family != AF_INET6)
+		return BPF_OK;
+	if (ctx->dst_port != DST_PORT)
+		return BPF_OK;
+	if (ctx->dst_ip6[0] != DST_IP6[0] ||
+	    ctx->dst_ip6[1] != DST_IP6[1] ||
+	    ctx->dst_ip6[2] != DST_IP6[2] ||
+	    ctx->dst_ip6[3] != DST_IP6[3])
+		return BPF_OK;
+
+	sk = bpf_map_lookup_elem(&redir_map, &key);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, NO_FLAGS);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
+}
+
+SEC("sk_lookup/select_sock_a")
+int select_sock_a(struct bpf_sk_lookup *ctx)
+{
+	__u32 key = SERVER_A;
+	struct bpf_sock *sk;
+	int err;
+
+	sk = bpf_map_lookup_elem(&redir_map, &key);
+	if (!sk)
+		return BPF_OK;
+
+	err = bpf_sk_assign(ctx, sk, NO_FLAGS);
+	bpf_sk_release(sk);
+	return err ? BPF_DROP : BPF_REDIRECT;
+}
+
+SEC("sk_reuseport/select_sock_b")
+int select_sock_b(struct sk_reuseport_md *ctx)
+{
+	__u32 key = SERVER_B;
+	int err;
+
+	err = bpf_sk_select_reuseport(ctx, &redir_map, &key, NO_FLAGS);
+	return err ? SK_DROP : SK_PASS;
+}
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+__u32 _version SEC("version") = 1;
-- 
2.25.3

