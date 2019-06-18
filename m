Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF454A162
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfFRNBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:01:10 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45932 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729082AbfFRNBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:01:03 -0400
Received: by mail-lj1-f193.google.com with SMTP id m23so13000224lje.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hZWgEgmc11ENYoI9BHlzBKPxk6UgBo+lQ/4f+sYMwjE=;
        b=FXg2jF1ZjE53xidOTjwY7TJo7aXGKQLl+mmnvSGwFNN9umuGwExmBk5EcBaARhVgOh
         sH8K9OV8K9IzZo2PUpI7XfAoYawxoRWeaVz+ysK+Z/HaI5QOsRvyj2RNK34qZqFushRu
         MSC32X5ArLZB26MfYzfYhZFXVp34ZXqtQsMEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hZWgEgmc11ENYoI9BHlzBKPxk6UgBo+lQ/4f+sYMwjE=;
        b=Npx7cdlP2UHcN+VpRqmkj9+qtq372yYcKVkYtKkzVeGIxyAptRBSIN9YBd6+FaaGOz
         9pUSwZi1vbFBG9wRDU/62qQ5sK7e+kQ/aIfhDTAVg5r6TVdFecmTwIjnIOafnup9V6wx
         cZjP0s59KRKBCrvzSIyiMwmEcerokklT2w11WRtA7E8HfXifElC2sA7LgU7S+AtEBCrU
         t2INC8RI32yLEYYf81pHOvzF1PJ9KfPeLSAHnCrM4vlj5xKOzv9d+5uuUPJwBxZl0VT0
         2fz94KgpPRKhKz4IS3NcSYhKj6WLBSQS4ZoOgJ5dor39vGKIR6tDJ7tC1kX0ZWo8lDhb
         9D0Q==
X-Gm-Message-State: APjAAAWGN+1YyGLFdFcE2q5s0tomEZCb231VHDtfaHj/bTzEziUrW5uV
        z7k4hlm3zYSrUgvPwkx3cs6RngY7Q3pang==
X-Google-Smtp-Source: APXvYqy6lfbLu6tx+tQe4cbuyad592opkIvAzSDwg6ZMrHZ1UXDg84oPDqTDcCKXJXVOjU3O6sAkmQ==
X-Received: by 2002:a05:651c:87:: with SMTP id 7mr45713819ljq.184.1560862860111;
        Tue, 18 Jun 2019 06:01:00 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id e12sm2181291lfb.66.2019.06.18.06.00.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:59 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com
Subject: [RFC bpf-next 6/7] bpf: Test destination address remapping with inet_lookup
Date:   Tue, 18 Jun 2019 15:00:49 +0200
Message-Id: <20190618130050.8344-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check if destination IP address and/or port remapping happens when an
inet_lookup program is attached to the net namespace.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   6 +-
 .../selftests/bpf/progs/inet_lookup_prog.c    |  68 +++
 .../testing/selftests/bpf/test_inet_lookup.c  | 392 ++++++++++++++++++
 .../testing/selftests/bpf/test_inet_lookup.sh |  35 ++
 5 files changed, 500 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/inet_lookup_prog.c
 create mode 100644 tools/testing/selftests/bpf/test_inet_lookup.c
 create mode 100755 tools/testing/selftests/bpf/test_inet_lookup.sh

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 7470327edcfe..c1492cb188e5 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,3 +39,4 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
+test_inet_lookup
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index ae5c3e576c2f..aa68dc091888 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -61,7 +61,8 @@ TEST_PROGS := test_kmod.sh \
 	test_tcp_check_syncookie.sh \
 	test_tc_tunnel.sh \
 	test_tc_edt.sh \
-	test_xdping.sh
+	test_xdping.sh \
+	test_inet_lookup.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
@@ -70,7 +71,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
-	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user
+	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
+	test_inet_lookup
 
 include ../lib.mk
 
diff --git a/tools/testing/selftests/bpf/progs/inet_lookup_prog.c b/tools/testing/selftests/bpf/progs/inet_lookup_prog.c
new file mode 100644
index 000000000000..5f3d2b1f94eb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/inet_lookup_prog.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <sys/socket.h>
+
+#include "bpf_endian.h"
+#include "bpf_helpers.h"
+
+#define IP4(a, b, c, d)	((__u32)(		\
+	((__u32)((a) & (__u32)0xffUL) << 24) |	\
+	((__u32)((b) & (__u32)0xffUL) << 16) |	\
+	((__u32)((c) & (__u32)0xffUL) <<  8) |	\
+	((__u32)((d) & (__u32)0xffUL) <<  0)))
+
+static const __u32 CONNECT_PORT = 7007;
+static const __u32 LISTEN_PORT  = 8008;
+
+static const __u32 CONNECT_IP4 = IP4(127, 0, 0, 1);
+static const __u32 LISTEN_IP4  = IP4(127, 0, 0, 2);
+
+/* Remap destination port CONNECT_PORT -> LISTEN_PORT. */
+SEC("inet_lookup/remap_port")
+int inet4_remap_port(struct bpf_inet_lookup *ctx)
+{
+	if (ctx->local_port != CONNECT_PORT)
+		return BPF_OK;
+
+	ctx->local_port = LISTEN_PORT;
+	return BPF_REDIRECT;
+}
+
+/* Remap destination IP CONNECT_IP4 -> LISTEN_IP4. */
+SEC("inet_lookup/remap_ip4")
+int inet4_remap_ip(struct bpf_inet_lookup *ctx)
+{
+	if (ctx->family != AF_INET)
+		return BPF_OK;
+	if (ctx->local_port != CONNECT_PORT)
+		return BPF_OK;
+	if (ctx->local_ip4 != bpf_htonl(CONNECT_IP4))
+		return BPF_OK;
+
+	ctx->local_ip4 = bpf_htonl(LISTEN_IP4);
+	return BPF_REDIRECT;
+}
+
+/* Remap destination IP CONNECT_IP6 -> LISTEN_IP6. */
+SEC("inet_lookup/remap_ip6")
+int inet6_remap_ip(struct bpf_inet_lookup *ctx)
+{
+	if (ctx->family != AF_INET6)
+		return BPF_OK;
+	if (ctx->local_port != CONNECT_PORT)
+		return BPF_OK;
+	if (ctx->local_ip6[0] != bpf_htonl(0xfd000000) ||
+	    ctx->local_ip6[1] != bpf_htonl(0x00000000) ||
+	    ctx->local_ip6[2] != bpf_htonl(0x00000000) ||
+	    ctx->local_ip6[3] != bpf_htonl(0x00000001))
+		return BPF_OK;
+
+	ctx->local_ip6[0] = bpf_htonl(0xfd000000);
+	ctx->local_ip6[1] = bpf_htonl(0x00000000);
+	ctx->local_ip6[2] = bpf_htonl(0x00000000);
+	ctx->local_ip6[3] = bpf_htonl(0x00000002);
+	return BPF_REDIRECT;
+}
+
+char _license[] SEC("license") = "GPL";
+__u32 _version SEC("version") = 1;
diff --git a/tools/testing/selftests/bpf/test_inet_lookup.c b/tools/testing/selftests/bpf/test_inet_lookup.c
new file mode 100644
index 000000000000..d4e440655252
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_inet_lookup.c
@@ -0,0 +1,392 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Echo test with the server not receiving at the same IP:port as the
+ * client sends the request to. Use BPF inet_lookup program to remap
+ * IP/port on socket lookup and direct the packets to the server.
+ */
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <stdio.h>
+#include <unistd.h>
+
+#include <bpf/libbpf.h>
+#include <bpf/bpf.h>
+
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+
+#define BPF_FILE	"./inet_lookup_prog.o"
+#define MAX_ERROR_LEN	256
+
+#define EXT_IP4		"127.0.0.1"
+#define INT_IP4		"127.0.0.2"
+#define EXT_IP6		"fd00::1"
+#define INT_IP6		"fd00::2"
+#define EXT_PORT	7007
+#define INT_PORT	8008
+
+struct inet_addr {
+	const char *ip;
+	unsigned short port;
+};
+
+struct test {
+	const char *desc;
+	const char *bpf_prog;
+
+	struct {
+		int family;
+		int type;
+	} socket;
+
+	struct inet_addr recv_at;
+	struct inet_addr send_to;
+};
+
+static const struct test tests[] = {
+	{
+		.desc		= "TCP IPv4 remap port",
+		.bpf_prog	= "inet_lookup/remap_port",
+		.socket		= { AF_INET, SOCK_STREAM },
+		.recv_at	= { EXT_IP4, INT_PORT },
+		.send_to	= { EXT_IP4, EXT_PORT },
+	},
+	{
+		.desc		= "TCP IPv4 remap IP",
+		.bpf_prog	= "inet_lookup/remap_ip4",
+		.socket		= { AF_INET, SOCK_STREAM },
+		.recv_at	= { INT_IP4, EXT_PORT },
+		.send_to	= { EXT_IP4, EXT_PORT },
+	},
+	{
+		.desc		= "TCP IPv6 remap port",
+		.bpf_prog	= "inet_lookup/remap_port",
+		.socket		= { AF_INET6, SOCK_STREAM },
+		.recv_at	= { EXT_IP6, INT_PORT },
+		.send_to	= { EXT_IP6, EXT_PORT },
+	},
+	{
+		.desc		= "TCP IPv6 remap IP",
+		.bpf_prog	= "inet_lookup/remap_ip6",
+		.socket		= { AF_INET6, SOCK_STREAM },
+		.recv_at	= { INT_IP6, EXT_PORT },
+		.send_to	= { EXT_IP6, EXT_PORT },
+	},
+	{
+		.desc		= "UDP IPv4 remap port",
+		.bpf_prog	= "inet_lookup/remap_port",
+		.socket		= { AF_INET, SOCK_DGRAM },
+		.recv_at	= { EXT_IP4, INT_PORT },
+		.send_to	= { EXT_IP4, EXT_PORT },
+	},
+	{
+		.desc		= "UDP IPv4 remap IP",
+		.bpf_prog	= "inet_lookup/remap_ip4",
+		.socket		= { AF_INET, SOCK_DGRAM },
+		.recv_at	= { INT_IP4, EXT_PORT },
+		.send_to	= { EXT_IP4, EXT_PORT },
+	},
+	{
+		.desc		= "UDP IPv6 remap port",
+		.bpf_prog	= "inet_lookup/remap_port",
+		.socket		= { AF_INET6, SOCK_DGRAM },
+		.recv_at	= { EXT_IP6, INT_PORT },
+		.send_to	= { EXT_IP6, EXT_PORT },
+	},
+	{
+		.desc		= "UDP IPv6 remap IP",
+		.bpf_prog	= "inet_lookup/remap_ip6",
+		.socket		= { AF_INET6, SOCK_DGRAM },
+		.recv_at	= { INT_IP6, EXT_PORT },
+		.send_to	= { EXT_IP6, EXT_PORT },
+	},
+};
+
+static void make_addr(int family, const char *ip, int port,
+		      struct sockaddr_storage *ss, int *sz)
+{
+	struct sockaddr_in *addr4;
+	struct sockaddr_in6 *addr6;
+
+	switch (family) {
+	case AF_INET:
+		addr4 = (struct sockaddr_in *)ss;
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(port);
+		if (!inet_pton(AF_INET, ip, &addr4->sin_addr))
+			error(1, errno, "inet_pton failed: %s", ip);
+		*sz = sizeof(*addr4);
+		break;
+	case AF_INET6:
+		addr6 = (struct sockaddr_in6 *)ss;
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(port);
+		if (!inet_pton(AF_INET6, ip, &addr6->sin6_addr))
+			error(1, errno, "inet_pton failed: %s", ip);
+		*sz = sizeof(*addr6);
+		break;
+	default:
+		error(1, 0, "unsupported family %d", family);
+	}
+}
+
+static int make_server(int family, int type, const char *ip, int port)
+{
+	struct sockaddr_storage ss = {0};
+	int fd, opt, sz;
+
+	make_addr(family, ip, port, &ss, &sz);
+
+	fd = socket(family, type, 0);
+	if (fd < 0)
+		error(1, errno, "failed to create listen socket");
+
+	opt = 1;
+	if (setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &opt, sizeof(opt)))
+		error(1, errno, "failed to set SO_REUSEPORT");
+	if (family == AF_INET && type == SOCK_DGRAM) {
+		if (setsockopt(fd, SOL_IP, IP_RECVORIGDSTADDR,
+			       &opt, sizeof(opt)))
+			error(1, errno, "failed to set IP_RECVORIGDSTADDR");
+	}
+	if (family == AF_INET6 && type == SOCK_DGRAM) {
+		if (setsockopt(fd, SOL_IPV6, IPV6_RECVORIGDSTADDR,
+			       &opt, sizeof(opt)))
+			error(1, errno, "failed to set IPV6_RECVORIGDSTADDR");
+	}
+
+	if (bind(fd, (struct sockaddr *)&ss, sz))
+		error(1, errno, "failed to bind listen socket");
+
+	if (type == SOCK_STREAM && listen(fd, 1))
+		error(1, errno, "failed to listen on port %d", port);
+
+	return fd;
+}
+
+static int make_client(int family, int type, const char *ip, int port)
+{
+	struct sockaddr_storage ss = {0};
+	struct sockaddr *sa;
+	int fd, sz;
+
+	make_addr(family, ip, port, &ss, &sz);
+	sa = (struct sockaddr *)&ss;
+
+	fd = socket(family, type, 0);
+	if (fd < 0)
+		error(1, errno, "failed to create socket");
+
+	if (connect(fd, sa, sz))
+		error(1, errno, "failed to connect socket");
+
+	return fd;
+}
+
+static void send_byte(int fd)
+{
+	if (send(fd, "a", 1, 0) < 1)
+		error(1, errno, "failed to send message");
+}
+
+static void recv_byte(int fd)
+{
+	char buf[1];
+
+	if (recv(fd, buf, sizeof(buf), 0) < 1)
+		error(1, errno, "failed to receive message");
+}
+
+static void tcp_recv_send(int server_fd)
+{
+	char buf[1];
+	size_t len;
+	ssize_t n;
+	int fd;
+
+	fd = accept(server_fd, NULL, NULL);
+	if (fd < 0)
+		error(1, errno, "failed to accept");
+
+	len = sizeof(buf);
+	n = recv(fd, buf, len, 0);
+	if (n < 0)
+		error(1, errno, "failed to receive");
+	if (n < len)
+		error(1, 0, "partial receive");
+
+	n = send(fd, buf, len, 0);
+	if (n < 0)
+		error(1, errno, "failed to send");
+	if (n < len)
+		error(1, 0, "partial send");
+
+	close(fd);
+}
+
+static void udp_recv_send(int server_fd)
+{
+	char cmsg_buf[CMSG_SPACE(sizeof(struct sockaddr_storage))];
+	struct sockaddr_storage *dst_addr = NULL;
+	struct sockaddr_storage src_addr;
+	struct msghdr msg = { 0 };
+	struct iovec iov = { 0 };
+	struct cmsghdr *cm;
+	char buf[1];
+	ssize_t n;
+	int fd;
+
+	iov.iov_base = buf;
+	iov.iov_len = sizeof(buf);
+
+	msg.msg_name = &src_addr;
+	msg.msg_namelen = sizeof(src_addr);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cmsg_buf;
+	msg.msg_controllen = sizeof(cmsg_buf);
+
+	n = recvmsg(server_fd, &msg, 0);
+	if (n < 0)
+		error(1, errno, "failed to receive");
+	if (n < sizeof(buf))
+		error(1, 0, "partial receive");
+	if (msg.msg_flags & MSG_CTRUNC)
+		error(1, errno, "truncated cmsg");
+
+	for (cm = CMSG_FIRSTHDR(&msg); cm; cm = CMSG_NXTHDR(&msg, cm)) {
+		if ((cm->cmsg_level == SOL_IP &&
+		     cm->cmsg_type == IP_ORIGDSTADDR) ||
+		    (cm->cmsg_level == SOL_IPV6 &&
+		     cm->cmsg_type == IPV6_ORIGDSTADDR)) {
+			dst_addr = (struct sockaddr_storage *)CMSG_DATA(cm);
+			break;
+		}
+		error(0, 0, "ignored cmsg at level %d type %d",
+		      cm->cmsg_level, cm->cmsg_type);
+	}
+	if (!dst_addr)
+		error(1, 0, "failed to get destination address");
+
+	/* Reply from original destination address. */
+	fd = socket(dst_addr->ss_family, SOCK_DGRAM, 0);
+	if (fd < 0)
+		error(1, errno, "failed to create socket");
+
+	if (bind(fd, (struct sockaddr *)dst_addr, sizeof(*dst_addr)))
+		error(1, errno, "failed to bind socket");
+
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	n = sendmsg(fd, &msg, 0);
+	if (n < 0)
+		error(1, errno, "failed to send");
+	if (n < sizeof(buf))
+		error(1, 0, "partial send");
+
+	close(fd);
+}
+
+static void tcp_echo(int client_fd, int server_fd)
+{
+	send_byte(client_fd);
+	tcp_recv_send(server_fd);
+	recv_byte(client_fd);
+}
+
+static void udp_echo(int client_fd, int server_fd)
+{
+	send_byte(client_fd);
+	udp_recv_send(server_fd);
+	recv_byte(client_fd);
+}
+
+static struct bpf_object *load_progs(void)
+{
+	char buf[MAX_ERROR_LEN];
+	struct bpf_object *obj;
+	int prog_fd;
+	int err;
+
+	err = bpf_prog_load(BPF_FILE, BPF_PROG_TYPE_UNSPEC, &obj, &prog_fd);
+	if (err) {
+		libbpf_strerror(err, buf, ARRAY_SIZE(buf));
+		error(1, 0, "failed to open bpf file: %s", buf);
+	}
+
+	return obj;
+}
+
+static void attach_prog(struct bpf_object *obj, const char *sec)
+{
+	enum bpf_attach_type attach_type;
+	struct bpf_program *prog;
+	char buf[MAX_ERROR_LEN];
+	int target_fd = -1;
+	int prog_fd;
+	int err;
+
+	prog = bpf_object__find_program_by_title(obj, sec);
+	err = libbpf_get_error(prog);
+	if (err) {
+		libbpf_strerror(err, buf, ARRAY_SIZE(buf));
+		error(1, 0, "failed to find section \"%s\": %s", sec, buf);
+	}
+
+	err = libbpf_attach_type_by_name(sec, &attach_type);
+	if (err) {
+		libbpf_strerror(err, buf, ARRAY_SIZE(buf));
+		error(1, 0, "failed to identify attach type: %s", buf);
+	}
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0)
+		error(1, errno, "failed to get prog fd");
+
+	err = bpf_prog_detach(target_fd, attach_type);
+	if (err && err != -EPERM)
+		error(1, -err, "failed to detach prog");
+
+	err = bpf_prog_attach(prog_fd, target_fd, attach_type, 0);
+	if (err)
+		error(1, -err, "failed to attach prog");
+}
+
+static void run_test(const struct test *t, struct bpf_object *obj)
+{
+	int client_fd, server_fd;
+
+	fprintf(stderr, "%s\n", t->desc);
+	attach_prog(obj, t->bpf_prog);
+
+	server_fd = make_server(t->socket.family, t->socket.type,
+				t->recv_at.ip, t->recv_at.port);
+	client_fd = make_client(t->socket.family, t->socket.type,
+				t->send_to.ip, t->send_to.port);
+
+	if (t->socket.type == SOCK_STREAM)
+		tcp_echo(client_fd, server_fd);
+	else
+		udp_echo(client_fd, server_fd);
+
+	close(client_fd);
+	close(server_fd);
+}
+
+int main(void)
+{
+	struct bpf_object *obj;
+	const struct test *t;
+
+	obj = load_progs();
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++)
+		run_test(t, obj);
+
+	bpf_object__unload(obj);
+
+	fprintf(stderr, "PASS\n");
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/test_inet_lookup.sh b/tools/testing/selftests/bpf/test_inet_lookup.sh
new file mode 100755
index 000000000000..5efb42fbdf59
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_inet_lookup.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [[ $EUID -ne 0 ]]; then
+        echo "This script must be run as root"
+        echo "FAIL"
+        exit 1
+fi
+
+# Run the script in a dedicated network namespace.
+if [[ -z $(ip netns identify $$) ]]; then
+        ../net/in_netns.sh "$0" "$@"
+        exit $?
+fi
+
+readonly IP6_1="fd00::1"
+readonly IP6_2="fd00::2"
+
+setup()
+{
+        ip -6 addr add ${IP6_1}/128 dev lo
+        ip -6 addr add ${IP6_2}/128 dev lo
+}
+
+cleanup()
+{
+        ip -6 addr del ${IP6_1}/128 dev lo
+        ip -6 addr del ${IP6_2}/128 dev lo
+}
+
+trap cleanup EXIT
+setup
+
+./test_inet_lookup
+exit $?
-- 
2.20.1

