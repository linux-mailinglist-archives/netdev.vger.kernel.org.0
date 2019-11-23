Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC81107E2B
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 12:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfKWLIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 06:08:11 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36535 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfKWLII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 06:08:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id k15so10295064lja.3
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 03:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MbojPUtkT/QUY0WfHCnvFCZicDk08eeXOWvvchENNvY=;
        b=aAzD3YpbpOs3Ws8sm4yHYzEheORt4MYt0qMo1//ldz8PdIB9kHY2vd3aBQlUNeSu22
         sjE0Ea7U+p8l2y3Tmhj5Yg/S6e7+Ph+X+Vyj9kHgzS/Z2GvvRtgNHU5bTkGCTdhkDG1z
         ecPycQBcKIBUfyKXLbJtEoKo/HUanJLOdzZ1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MbojPUtkT/QUY0WfHCnvFCZicDk08eeXOWvvchENNvY=;
        b=B9H9AaAdFFDzmYpJsRDK5coRErgqw8Lr5vKzzt+0LKFCqYeMOYpTqjY9q7qzPNlaYs
         827STKMqIGwyw9t58J1Y56PKdYmq/x7h9XIT5hxAwr/FEaWLrrX9rJMqiGkN9SzzJZKi
         91B2NNGjmEMvqe1OfB9NY3thTT5PqzqZeBiO08CUy0kQD6oooATWggRPTnH+CRf8+LyM
         lnJvWbkbKjBS6MMLz4Eh4pqd0M/HUqPmDvVmYWIrA7dN0SJEajmy5P+UVN6rHUg4R9xN
         Vly8nQmkhZBd5xwVI+q7loPDbwyhPY3OCE9mi2quzpV283oWY/kd2amGw6fN9DCok5My
         h0uA==
X-Gm-Message-State: APjAAAXKLzGI+9WmIUYRtnAHeclScLPj+Qjv8HLlV1FpVq5WbEBPXzaj
        Pb+5HPEckItSv0hTWaOKGTowNw==
X-Google-Smtp-Source: APXvYqzezpeYcSHmme/JLF+12xoDj1LU4hct/V3rhgTwuEd0RHRRt9RyzlwoZpBinVSgmeccEU8Ehw==
X-Received: by 2002:a2e:7e0b:: with SMTP id z11mr15443710ljc.45.1574507285323;
        Sat, 23 Nov 2019 03:08:05 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d17sm676460lja.27.2019.11.23.03.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 03:08:04 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next 8/8] selftests/bpf: Tests for SOCKMAP holding listening sockets
Date:   Sat, 23 Nov 2019 12:07:51 +0100
Message-Id: <20191123110751.6729-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191123110751.6729-1-jakub@cloudflare.com>
References: <20191123110751.6729-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that SOCKMAP can store listening sockets, its user-space and BPF API
is open to a new set of potential pitfalls. Exercise the map operations,
code paths that trigger overridden socket callbacks, and BPF helpers
that work with SOCKMAP to gain confidence that all works as expected.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../bpf/progs/test_sockmap_listen_kern.c      |  75 ++
 .../selftests/bpf/test_sockmap_listen.c       | 820 ++++++++++++++++++
 4 files changed, 897 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen_kern.c
 create mode 100644 tools/testing/selftests/bpf/test_sockmap_listen.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4865116b96c7..94e335b3f677 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,3 +39,4 @@ test_btf_dump
 xdping
 /no_alu32
 /bpf_gcc
+test_sockmap_listen
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 51d16837b6ca..bacb80a208e3 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -30,7 +30,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap \
-	test_cgroup_attach test_progs-no_alu32
+	test_cgroup_attach test_progs-no_alu32 test_sockmap_listen
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen_kern.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen_kern.c
new file mode 100644
index 000000000000..16d00de67be1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen_kern.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, __u64);
+} sock_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 2);
+	__type(key, int);
+	__type(value, unsigned int);
+} verdict_map SEC(".maps");
+
+SEC("sk_skb/stream_parser")
+int prog_skb_parser(struct __sk_buff *skb)
+{
+	return skb->len;
+}
+
+SEC("sk_skb/stream_verdict")
+int prog_skb_verdict(struct __sk_buff *skb)
+{
+	unsigned int *count;
+	int verdict;
+
+	verdict = bpf_sk_redirect_map(skb, &sock_map, 0, 0);
+
+	count = bpf_map_lookup_elem(&verdict_map, &verdict);
+	if (count)
+		(*count)++;
+
+	return verdict;
+}
+
+SEC("sk_msg")
+int prog_msg_verdict(struct sk_msg_md *msg)
+{
+	unsigned int *count;
+	int verdict;
+
+	verdict = bpf_msg_redirect_map(msg, &sock_map, 0, 0);
+
+	count = bpf_map_lookup_elem(&verdict_map, &verdict);
+	if (count)
+		(*count)++;
+
+	return verdict;
+}
+
+SEC("sk_reuseport")
+int prog_reuseport(struct sk_reuseport_md *reuse)
+{
+	unsigned int *count;
+	int err, verdict;
+	int key = 0;
+
+	err = bpf_sk_select_reuseport(reuse, &sock_map, &key, 0);
+	verdict = (!err || err == -ENOENT) ? SK_PASS : SK_DROP;
+
+	count = bpf_map_lookup_elem(&verdict_map, &verdict);
+	if (count)
+		(*count)++;
+
+	return verdict;
+}
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_sockmap_listen.c b/tools/testing/selftests/bpf/test_sockmap_listen.c
new file mode 100644
index 000000000000..81ac4e319c5e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_sockmap_listen.c
@@ -0,0 +1,820 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Set of tests for SOCKMAP holding listening sockets covering:
+ *  - map operations,
+ *  - tcp_bpf socket callback overrides,
+ *  - BPF redirect helpers that work with SOCKMAP,
+ *  - BPF reuseport helper.
+ */
+
+#include <errno.h>
+#include <error.h>
+#include <limits.h>
+#include <netinet/ip.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define FAIL(fmt...) \
+	error_at_line(1, 0, __func__, __LINE__, fmt)
+#define FAIL_SYS(fmt...) \
+	error_at_line(1, errno, __func__, __LINE__, fmt)
+#define FAIL_LIBBPF(err, buf, str) ({					\
+	libbpf_strerror(err, buf, sizeof(buf));				\
+	FAIL(str ": %s", buf);						\
+})
+
+/* Fail-fast syscall wrappers */
+
+#define xsocket(domain, type, proto) ({					\
+	int __fd = socket(domain, type, proto);				\
+	if (__fd == -1)							\
+		FAIL_SYS("socket");					\
+	__fd;								\
+})
+
+#define xbind(fd, addr, len) ({						\
+	int __ret = bind(fd, addr, len);				\
+	if (__ret == -1)						\
+		FAIL_SYS("bind");					\
+	__ret;								\
+})
+
+#define xlisten(fd, backlog) ({						\
+	int __ret = listen(fd, backlog);				\
+	if (__ret == -1)						\
+		FAIL_SYS("listen");					\
+	__ret;								\
+})
+
+#define xgetsockname(fd, addr, len) ({					\
+	int __ret = getsockname(fd, addr, len);				\
+	if (__ret == -1)						\
+		FAIL_SYS("getsockname");				\
+	__ret;								\
+})
+
+#define xgetsockopt(fd, level, name, val, len) ({			\
+	int __ret = getsockopt(fd, level, name, val, len);		\
+	if (__ret == -1)						\
+		FAIL_SYS("getsockopt(" #name ")");			\
+	__ret;								\
+})
+
+#define xsetsockopt(fd, level, name, val, len) ({			\
+	int __ret = setsockopt(fd, level, name, val, len);		\
+	if (__ret == -1)						\
+		FAIL_SYS("setsockopt(" #name ")");			\
+	__ret;								\
+})
+
+#define xconnect(fd, addr, len) ({					\
+	int __ret = connect(fd, addr, len);				\
+	if (__ret == -1)						\
+		FAIL_SYS("connect");					\
+	__ret;								\
+})
+
+#define xaccept(fd, addr, len) ({					\
+	int __ret = accept(fd, addr, len);				\
+	if (__ret == -1)						\
+		FAIL_SYS("accept");					\
+	__ret;								\
+})
+
+#define xclose(fd) ({							\
+	int __ret = close(fd);						\
+	if (__ret == -1)						\
+		FAIL_SYS("close");					\
+	__ret;								\
+})
+
+#define xbpf_map_update_elem(fd, key, val, flags) ({			\
+	int __ret = bpf_map_update_elem(fd, key, val, flags);		\
+	if (__ret == -1)						\
+		FAIL_SYS("map_update");					\
+	__ret;								\
+})
+
+#define xbpf_map_delete_elem(fd, key) ({				\
+	int __ret = bpf_map_delete_elem(fd, key);			\
+	if (__ret == -1)						\
+		FAIL_SYS("map_delete");					\
+	__ret;								\
+})
+
+#define xbpf_map_lookup_elem(fd, key, val) ({				\
+	int __ret = bpf_map_lookup_elem(fd, key, val);			\
+	if (__ret == -1)						\
+		FAIL_SYS("map_lookup");					\
+	__ret;								\
+})
+
+#define xbpf_prog_attach(prog, target_fd, type, flags) ({		\
+	int __ret = bpf_prog_attach(prog, target_fd, type, flags);	\
+	if (__ret == -1)						\
+		FAIL_SYS("prog_attach(" #type ")");			\
+	__ret;								\
+})
+
+#define xbpf_prog_detach2(prog, target_fd, type) ({			\
+	int __ret = bpf_prog_detach2(prog, target_fd, type);		\
+	if (__ret == -1)						\
+		FAIL_SYS("prog_detach2(" #type ")");			\
+	__ret;								\
+})
+
+#define BPF_OBJECT_FILE "test_sockmap_listen_kern.o"
+#define MAX_STRERR_LEN 256
+#define ON_TX false
+#define ON_RX true
+
+/* Same order as in BPF object file. */
+enum {
+	SOCK_MAP = 0,
+	VERDICT_MAP,
+	MAX_MAP
+};
+
+enum {
+	SKB_PARSER_PROG = 0,
+	SKB_VERDICT_PROG,
+	MSG_VERDICT_PROG,
+	REUSEPORT_PROG,
+	MAX_PROG
+};
+
+static void init_addr_loopback4(struct sockaddr_storage *ss, socklen_t *len)
+{
+	struct sockaddr_in *addr4 = memset(ss, 0, sizeof(*ss));
+
+	addr4->sin_family = AF_INET;
+	addr4->sin_port = 0;
+	addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	*len = sizeof(*addr4);
+}
+
+static void init_addr_loopback6(struct sockaddr_storage *ss, socklen_t *len)
+{
+	struct sockaddr_in6 *addr6 = memset(ss, 0, sizeof(*ss));
+
+	addr6->sin6_family = AF_INET6;
+	addr6->sin6_port = 0;
+	addr6->sin6_addr = in6addr_loopback;
+	*len = sizeof(*addr6);
+}
+
+static void init_addr_loopback(int family, struct sockaddr_storage *ss,
+			       socklen_t *len)
+{
+	switch (family) {
+	case AF_INET:
+		init_addr_loopback4(ss, len);
+		return;
+	case AF_INET6:
+		init_addr_loopback6(ss, len);
+		return;
+	default:
+		FAIL("unsupported address family %d", family);
+	}
+}
+
+static inline struct sockaddr *sockaddr(struct sockaddr_storage *ss)
+{
+	return (struct sockaddr *)ss;
+}
+
+static void test_sockmap_insert_invalid(int mapfd)
+{
+	u32 key = 0;
+	u64 value;
+	int err;
+
+	value = -1;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EINVAL)
+		FAIL_SYS("map_update: expected EINVAL");
+
+	value = INT_MAX;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EBADF)
+		FAIL_SYS("map_update: expected EBADF");
+}
+
+static void test_sockmap_insert_opened(int family, int socktype, int mapfd)
+{
+	u32 key = 0;
+	u64 value;
+	int err, s;
+
+	s = xsocket(family, socktype, 0);
+
+	errno = 0;
+	value = s;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EINVAL)
+		FAIL_SYS("map_update: expected EINVAL");
+	xclose(s);
+}
+
+static void test_sockmap_insert_bound(int family, int socktype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int err, s;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+
+	errno = 0;
+	value = s;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EINVAL)
+		FAIL_SYS("map_update: expected EINVAL");
+	xclose(s);
+}
+
+static void test_sockmap_insert_listening(int family, int socktype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int s;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xclose(s);
+}
+
+static void test_sockmap_delete_after_insert(int family, int socktype,
+					     int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int s;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xclose(s);
+}
+
+static void test_sockmap_delete_after_close(int family, int socktype,
+					    int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	int err, s;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	xclose(s);
+	errno = 0;
+	err = bpf_map_delete_elem(mapfd, &key);
+	if (!err || errno != EINVAL)
+		FAIL_SYS("map_update: expected EINVAL");
+}
+
+static void test_sockmap_lookup_after_insert(int family, int socktype,
+					     int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u64 cookie, value;
+	const int key = 0;
+	socklen_t len;
+	int s;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	len = sizeof(cookie);
+	xgetsockopt(s, SOL_SOCKET, SO_COOKIE, &cookie, &len);
+
+	xbpf_map_lookup_elem(mapfd, &key, &value);
+	if (value != cookie) {
+		FAIL("map_lookup: have %#llx, want %#llx",
+		     (unsigned long long)value,
+		     (unsigned long long)cookie);
+	}
+	xclose(s);
+}
+
+static void test_sockmap_lookup_after_delete(int family, int socktype,
+					     int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	int err, s;
+	u64 value;
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xbpf_map_delete_elem(mapfd, &key);
+
+	errno = 0;
+	err = bpf_map_lookup_elem(mapfd, &key, &value);
+	if (!err || errno != ENOENT)
+		FAIL_SYS("map_lookup: expected ENOENT");
+	xclose(s);
+}
+
+static void test_sockmap_lookup_32_bit_value(int family, int socktype)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	int err, mapfd, s;
+	u32 key, value;
+
+	mapfd = bpf_create_map(BPF_MAP_TYPE_SOCKMAP,
+			       sizeof(key), sizeof(value), 1, 0);
+	if (mapfd == -1)
+		FAIL_SYS("map_create");
+
+	s = xsocket(family, socktype, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xlisten(s, 1);
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	errno = 0;
+	err = bpf_map_lookup_elem(mapfd, &key, &value);
+	if (!err || errno != ENOSPC)
+		FAIL_SYS("map_lookup: expected ENOSPC");
+
+	xclose(s);
+	xclose(mapfd);
+}
+
+static void test_sockmap_update_listening(int family, int socktype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int s1, s2;
+
+	init_addr_loopback(family, &addr, &addrlen);
+
+	s1 = xsocket(family, socktype, 0);
+	xbind(s1, (struct sockaddr *)&addr, addrlen);
+	xlisten(s1, 1);
+
+	s2 = xsocket(family, socktype, 0);
+	xbind(s2, (struct sockaddr *)&addr, addrlen);
+	xlisten(s2, 1);
+
+	value = s1;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	value = s2;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_EXIST);
+
+	xclose(s1);
+	xclose(s2);
+}
+
+/*
+ * Exercise the code path where we destroy child sockets that never
+ * got accept()'ed, aka orphans, when parent socket gets closed.
+ */
+static void test_sockmap_destroy_orphan_child(int family, int socktype,
+					      int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int s, c;
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xgetsockname(s, (struct sockaddr *)&addr, &addrlen);
+	xlisten(s, 1);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	c = xsocket(family, socktype, 0);
+	xconnect(c, (struct sockaddr *)&addr, addrlen);
+
+	xclose(c);
+	xclose(s);
+}
+
+/*
+ * Exercise the listening socket SYN receive callback after removing
+ * it from SOCKMAP to ensure that callbacks get restored properly.
+ */
+static void test_sockmap_syn_recv_after_delete(int family, int socktype,
+					       int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	u32 key = 0;
+	u64 value;
+	int s, c;
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	init_addr_loopback(family, &addr, &addrlen);
+	xbind(s, (struct sockaddr *)&addr, addrlen);
+	xgetsockname(s, (struct sockaddr *)&addr, &addrlen);
+	xlisten(s, 128);
+
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xbpf_map_delete_elem(mapfd, &key);
+
+	c = xsocket(family, socktype, 0);
+	xconnect(c, (struct sockaddr *)&addr, addrlen);
+
+	xclose(c);
+	xclose(s);
+}
+
+static void zero_verdict_count(int mapfd)
+{
+	unsigned int zero = 0;
+	int key;
+
+	key = SK_DROP;
+	xbpf_map_update_elem(mapfd, &key, &zero, BPF_ANY);
+	key = SK_PASS;
+	xbpf_map_update_elem(mapfd, &key, &zero, BPF_ANY);
+}
+
+static void redir_to_connected(int family, int socktype, int sock_mapfd,
+			       int verd_mapfd, bool on_rx)
+{
+	const char *test_name = on_rx ? "rx" : "tx";
+	struct sockaddr_storage addr;
+	int s, c0, c1, p0, p1;
+	unsigned int pass;
+	socklen_t addrlen;
+	u64 value;
+	u32 key;
+	char b;
+	int n;
+
+	init_addr_loopback(family, &addr, &addrlen);
+	zero_verdict_count(verd_mapfd);
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	xbind(s, sockaddr(&addr), addrlen);
+	xgetsockname(s, sockaddr(&addr), &addrlen);
+	xlisten(s, 1);
+
+	c0 = xsocket(family, socktype, 0);
+	xconnect(c0, sockaddr(&addr), addrlen);
+	p0 = xaccept(s, NULL, NULL);
+
+	c1 = xsocket(family, socktype, 0);
+	xconnect(c1, sockaddr(&addr), addrlen);
+	p1 = xaccept(s, NULL, NULL);
+
+	key = 0;
+	value = p0;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	key = 1;
+	value = p1;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+
+	n = write(on_rx ? c1 : p1, "a", 1);
+	if (n < 0)
+		FAIL_SYS("%s: write", test_name);
+
+	key = SK_PASS;
+	xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", test_name, pass);
+
+	n = read(c0, &b, 1);
+	if (n < 0)
+		FAIL_SYS("%s: read", test_name);
+
+	xclose(s);
+	xclose(c0);
+	xclose(c1);
+	xclose(p0);
+	xclose(p1);
+}
+
+static void test_sockmap_skb_redir_to_connected(int family, int socktype,
+						int sock_mapfd, int verd_mapfd,
+						int parser_fd, int verdict_fd)
+{
+	xbpf_prog_attach(parser_fd, sock_mapfd, BPF_SK_SKB_STREAM_PARSER, 0);
+	xbpf_prog_attach(verdict_fd, sock_mapfd, BPF_SK_SKB_STREAM_VERDICT, 0);
+	redir_to_connected(family, socktype, sock_mapfd, verd_mapfd, ON_RX);
+	xbpf_prog_detach2(parser_fd, sock_mapfd, BPF_SK_SKB_STREAM_PARSER);
+	xbpf_prog_detach2(verdict_fd, sock_mapfd, BPF_SK_SKB_STREAM_VERDICT);
+}
+
+static void redir_to_listening(int family, int socktype, int sock_mapfd,
+			       int verd_mapfd, bool on_rx)
+{
+	const char *test_name = on_rx ? "rx" : "tx";
+	struct sockaddr_storage addr;
+	unsigned int drop;
+	socklen_t addrlen;
+	int s, c, p;
+	u64 value;
+	u32 key;
+
+	init_addr_loopback(family, &addr, &addrlen);
+	zero_verdict_count(verd_mapfd);
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	xbind(s, sockaddr(&addr), addrlen);
+	xgetsockname(s, sockaddr(&addr), &addrlen);
+	xlisten(s, 1);
+
+	c = xsocket(family, socktype, 0);
+	xconnect(c, sockaddr(&addr), addrlen);
+	p = xaccept(s, NULL, NULL);
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	key = 1;
+	value = p;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+
+	write(on_rx ? c : p, "a", 1);
+
+	key = SK_DROP;
+	xbpf_map_lookup_elem(verd_mapfd, &key, &drop);
+	if (drop != 1)
+		FAIL("%s: want drop count 1, have %d", test_name, drop);
+
+	xclose(s);
+	xclose(c);
+	xclose(p);
+}
+
+static void test_sockmap_skb_redir_to_listening(int family, int socktype,
+						int sock_mapfd, int verd_mapfd,
+						int parser_fd, int verdict_fd)
+{
+	xbpf_prog_attach(parser_fd, sock_mapfd, BPF_SK_SKB_STREAM_PARSER, 0);
+	xbpf_prog_attach(verdict_fd, sock_mapfd, BPF_SK_SKB_STREAM_VERDICT, 0);
+	redir_to_listening(family, socktype, sock_mapfd, verd_mapfd, ON_RX);
+	xbpf_prog_detach2(parser_fd, sock_mapfd, BPF_SK_SKB_STREAM_PARSER);
+	xbpf_prog_detach2(verdict_fd, sock_mapfd, BPF_SK_SKB_STREAM_VERDICT);
+}
+
+static void test_sockmap_msg_redir_to_connected(int family, int socktype,
+						int sock_mapfd, int verd_mapfd,
+						int verdict_fd)
+{
+	xbpf_prog_attach(verdict_fd, sock_mapfd, BPF_SK_MSG_VERDICT, 0);
+	redir_to_connected(family, socktype, sock_mapfd, verd_mapfd, ON_TX);
+	xbpf_prog_detach2(verdict_fd, sock_mapfd, BPF_SK_MSG_VERDICT);
+}
+
+static void test_sockmap_msg_redir_to_listening(int family, int socktype,
+						int sock_mapfd, int verd_mapfd,
+						int verdict_fd)
+{
+	xbpf_prog_attach(verdict_fd, sock_mapfd, BPF_SK_MSG_VERDICT, 0);
+	redir_to_listening(family, socktype, sock_mapfd, verd_mapfd, ON_TX);
+	xbpf_prog_detach2(verdict_fd, sock_mapfd, BPF_SK_MSG_VERDICT);
+}
+
+static void test_sockmap_reuseport_select_listening(int family, int socktype,
+						    int sock_mapfd,
+						    int verd_mapfd,
+						    int reuseport_fd)
+{
+	struct sockaddr_storage addr;
+	unsigned int pass;
+	socklen_t addrlen;
+	int one = 1;
+	int s, c, p;
+	u64 value;
+	u32 key;
+
+	init_addr_loopback(family, &addr, &addrlen);
+	zero_verdict_count(verd_mapfd);
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+		    &reuseport_fd, sizeof(reuseport_fd));
+	xbind(s, sockaddr(&addr), addrlen);
+	xgetsockname(s, sockaddr(&addr), &addrlen);
+	xlisten(s, 1);
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+
+	c = xsocket(family, socktype, 0);
+	xconnect(c, sockaddr(&addr), addrlen);
+	p = xaccept(s, NULL, NULL);
+
+	key = SK_PASS;
+	xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (pass != 1)
+		FAIL("want drop count 1, have %d", pass);
+
+	xclose(s);
+	xclose(c);
+	xclose(p);
+}
+
+static void test_sockmap_reuseport_select_connected(int family, int socktype,
+						    int sock_mapfd,
+						    int verd_mapfd,
+						    int reuseport_fd)
+{
+	struct sockaddr_storage addr;
+	int s, c0, c1, p;
+	unsigned int drop;
+	socklen_t addrlen;
+	int err, one = 1;
+	u64 value;
+	u32 key;
+
+	init_addr_loopback(family, &addr, &addrlen);
+	zero_verdict_count(verd_mapfd);
+
+	s = xsocket(family, socktype | SOCK_NONBLOCK, 0);
+	xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+		    &reuseport_fd, sizeof(reuseport_fd));
+	xbind(s, sockaddr(&addr), addrlen);
+	xgetsockname(s, sockaddr(&addr), &addrlen);
+	xlisten(s, 1);
+
+	c0 = xsocket(family, socktype, 0);
+	xconnect(c0, sockaddr(&addr), addrlen);
+	p = xaccept(s, NULL, NULL);
+
+	key = 0;
+	value = p;
+	xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+
+	c1 = xsocket(family, socktype, 0);
+	errno = 0;
+	err = connect(c1, sockaddr(&addr), addrlen);
+	if (!err || errno != ECONNREFUSED)
+		FAIL_SYS("connect: expected ECONNREFUSED");
+
+	key = SK_DROP;
+	xbpf_map_lookup_elem(verd_mapfd, &key, &drop);
+	if (drop != 1)
+		FAIL("want drop count 1, have %d", drop);
+
+	xclose(s);
+	xclose(c0);
+	xclose(c1);
+	xclose(p);
+}
+
+static void run_tests(int family, int socktype, int *maps, int *progs)
+{
+	/* Test SOCKMAP map operations */
+	test_sockmap_insert_invalid(maps[SOCK_MAP]);
+	test_sockmap_insert_opened(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_insert_bound(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_insert_listening(family, socktype, maps[SOCK_MAP]);
+
+	test_sockmap_delete_after_insert(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_delete_after_close(family, socktype, maps[SOCK_MAP]);
+
+	test_sockmap_lookup_after_insert(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_lookup_after_delete(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_lookup_32_bit_value(family, socktype);
+
+	test_sockmap_update_listening(family, socktype, maps[SOCK_MAP]);
+
+	/* Test overridden socket callbacks */
+	test_sockmap_destroy_orphan_child(family, socktype, maps[SOCK_MAP]);
+	test_sockmap_syn_recv_after_delete(family, socktype, maps[SOCK_MAP]);
+
+	/* Test redirect with SOCKMAP */
+	test_sockmap_skb_redir_to_connected(family, socktype,
+					    maps[SOCK_MAP], maps[VERDICT_MAP],
+					    progs[SKB_PARSER_PROG],
+					    progs[SKB_VERDICT_PROG]);
+	test_sockmap_skb_redir_to_listening(family, socktype,
+					    maps[SOCK_MAP], maps[VERDICT_MAP],
+					    progs[SKB_PARSER_PROG],
+					    progs[SKB_VERDICT_PROG]);
+	test_sockmap_msg_redir_to_connected(family, socktype,
+					    maps[SOCK_MAP], maps[VERDICT_MAP],
+					    progs[MSG_VERDICT_PROG]);
+	test_sockmap_msg_redir_to_listening(family, socktype,
+					    maps[SOCK_MAP], maps[VERDICT_MAP],
+					    progs[MSG_VERDICT_PROG]);
+
+	/* Test reuseport with SOCKMAP */
+	test_sockmap_reuseport_select_listening(family, socktype,
+						maps[SOCK_MAP],
+						maps[VERDICT_MAP],
+						progs[REUSEPORT_PROG]);
+	test_sockmap_reuseport_select_connected(family, socktype,
+						maps[SOCK_MAP],
+						maps[VERDICT_MAP],
+						progs[REUSEPORT_PROG]);
+}
+
+static struct bpf_object *load_bpf_object(const char *obj_path, int *maps,
+					  size_t n_maps, int *progs,
+					  size_t n_progs)
+{
+	char buf[MAX_STRERR_LEN];
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	long err;
+	int i;
+
+	obj = bpf_object__open(obj_path);
+	err = libbpf_get_error(obj);
+	if (err)
+		FAIL_LIBBPF(err, buf, "object open");
+
+	err = bpf_object__load(obj);
+	if (err)
+		FAIL_LIBBPF(err, buf, "object load");
+
+	i = 0;
+	bpf_object__for_each_map(map, obj) {
+		if (i < n_maps)
+			maps[i] = bpf_map__fd(map);
+		i++;
+	}
+
+	i = 0;
+	bpf_object__for_each_program(prog, obj) {
+		if (i < n_progs)
+			progs[i] = bpf_program__fd(prog);
+		i++;
+	}
+
+	return obj;
+}
+
+static void unload_bpf_object(struct bpf_object *obj)
+{
+	char buf[MAX_STRERR_LEN];
+	long err;
+
+	err = bpf_object__unload(obj);
+	if (err) {
+		libbpf_strerror(err, buf, sizeof(buf));
+		FAIL("object unload: %s", buf);
+	}
+}
+
+int main(void)
+{
+	struct bpf_object *obj;
+	int maps[MAX_MAP];
+	int progs[MAX_PROG];
+
+	obj = load_bpf_object(BPF_OBJECT_FILE, maps, MAX_MAP, progs, MAX_PROG);
+	run_tests(AF_INET, SOCK_STREAM, maps, progs);
+	run_tests(AF_INET6, SOCK_STREAM, maps, progs);
+	unload_bpf_object(obj);
+
+	printf("PASS\n");
+	return 0;
+}
-- 
2.20.1

