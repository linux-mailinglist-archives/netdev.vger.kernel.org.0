Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B8014A4AD
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgA0NL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:26 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39802 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbgA0NLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:23 -0500
Received: by mail-lj1-f196.google.com with SMTP id o11so10606355ljc.6
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cWleYZIYblVIhn6HrxbAx1lq1Ij70GZ2QhRCyCGkiGY=;
        b=MeIK4H/BN6VHX5WeYgoGibbtPztyy6P08kXhQkW5RicFIfZUouMDEn5eS5XALdEC7w
         gGanN/pm47n+eZzkWxLzLeDG7JBlKGc5qREMhXVUn0DmWPHJ8aWYeEUHxNhxjlDPz90S
         25EzlaiVTtwW/WgxgDaj7PTMLCVIlh21uM680=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cWleYZIYblVIhn6HrxbAx1lq1Ij70GZ2QhRCyCGkiGY=;
        b=ECF4UOQVVKwZyPo2hppSgSDLq/m/WZiw93tWuwxCYLaOQcBHodzLTrKY3Y4vnMWvMz
         bDUC5cXaX7C1JLARxpHujd8mocH8Ox4qnJXHzUJ+uzMjf/sRvlOR0W/LRyLp1RkAmR2p
         WIHGP2575CRsBqMWFssuIE7AxHShnuDkCK8gtvI4L5/y9xI9oEhupVTliohyoEc/zaCq
         W8GEIpDJJFj+Dc3Kz1u1k8GsOneDdPbDR6FcgUg8fHolC8K3+4L1ZBguE3/Au+qtGGFG
         hkDyzgoeuPWZMomSdJfx6XU+VwjQFd1qPy1KwOirawpYjfxnoCpMu0X7Wujoix17MLlB
         VnBw==
X-Gm-Message-State: APjAAAXDRlJVnrdRjgbfRv8sP/y4VOaPB1hYiNJZinJNLftfnpXDzGSl
        0HsdMag0FP05r3WvBNvGaoZ0wQ==
X-Google-Smtp-Source: APXvYqyWs2rX6HnaWlRng945oSea7oOBHflhLUkFN8gtoDp5dZnXHktBBulhr4JDlzH0O7tWVojvgw==
X-Received: by 2002:a2e:b177:: with SMTP id a23mr9944416ljm.202.1580130677706;
        Mon, 27 Jan 2020 05:11:17 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n11sm8115314ljg.15.2020.01.27.05.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:17 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v6 12/12] selftests/bpf: Tests for SOCKMAP holding listening sockets
Date:   Mon, 27 Jan 2020 14:10:57 +0100
Message-Id: <20200127131057.150941-13-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that SOCKMAP can store listening sockets, user-space and BPF API is
open to a new set of potential pitfalls. Exercise the map operations (with
extra attention to code paths susceptible to races between map ops and
socket cloning), and BPF helpers that work with SOCKMAP to gain confidence
that all works as expected.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 1455 +++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |   77 +
 2 files changed, 1532 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_listen.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
new file mode 100644
index 000000000000..93c74a528cc9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -0,0 +1,1455 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+/*
+ * Test suite for SOCKMAP holding listening sockets. Covers:
+ *  1. BPF map operations - bpf_map_{update,lookup delete}_elem
+ *  2. BPF redirect helpers - bpf_{sk,msg}_redirect_map
+ *  3. BPF reuseport helper - bpf_sk_select_reuseport
+ */
+
+#include <linux/compiler.h>
+#include <errno.h>
+#include <error.h>
+#include <limits.h>
+#include <netinet/in.h>
+#include <pthread.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "bpf_util.h"
+#include "test_progs.h"
+#include "test_sockmap_listen.skel.h"
+
+#define MAX_STRERR_LEN 256
+#define MAX_TEST_NAME 80
+
+#define _FAIL(errnum, fmt...)                                                  \
+	({                                                                     \
+		error_at_line(0, (errnum), __func__, __LINE__, fmt);           \
+		CHECK_FAIL(true);                                              \
+	})
+#define FAIL(fmt...) _FAIL(0, fmt)
+#define FAIL_ERRNO(fmt...) _FAIL(errno, fmt)
+#define FAIL_LIBBPF(err, msg)                                                  \
+	({                                                                     \
+		char __buf[MAX_STRERR_LEN];                                    \
+		libbpf_strerror((err), __buf, sizeof(__buf));                  \
+		FAIL("%s: %s", (msg), __buf);                                  \
+	})
+
+/* Wrappers that fail the test on error and report it. */
+
+#define xaccept(fd, addr, len)                                                 \
+	({                                                                     \
+		int __ret = accept((fd), (addr), (len));                       \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("accept");                                  \
+		__ret;                                                         \
+	})
+
+#define xbind(fd, addr, len)                                                   \
+	({                                                                     \
+		int __ret = bind((fd), (addr), (len));                         \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("bind");                                    \
+		__ret;                                                         \
+	})
+
+#define xclose(fd)                                                             \
+	({                                                                     \
+		int __ret = close((fd));                                       \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("close");                                   \
+		__ret;                                                         \
+	})
+
+#define xconnect(fd, addr, len)                                                \
+	({                                                                     \
+		int __ret = connect((fd), (addr), (len));                      \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("connect");                                 \
+		__ret;                                                         \
+	})
+
+#define xgetsockname(fd, addr, len)                                            \
+	({                                                                     \
+		int __ret = getsockname((fd), (addr), (len));                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockname");                             \
+		__ret;                                                         \
+	})
+
+#define xgetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = getsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("getsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xlisten(fd, backlog)                                                   \
+	({                                                                     \
+		int __ret = listen((fd), (backlog));                           \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("listen");                                  \
+		__ret;                                                         \
+	})
+
+#define xsetsockopt(fd, level, name, val, len)                                 \
+	({                                                                     \
+		int __ret = setsockopt((fd), (level), (name), (val), (len));   \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("setsockopt(" #name ")");                   \
+		__ret;                                                         \
+	})
+
+#define xsocket(family, sotype, flags)                                         \
+	({                                                                     \
+		int __ret = socket(family, sotype, flags);                     \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("socket");                                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_delete_elem(fd, key)                                          \
+	({                                                                     \
+		int __ret = bpf_map_delete_elem((fd), (key));                  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("map_delete");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_lookup_elem(fd, key, val)                                     \
+	({                                                                     \
+		int __ret = bpf_map_lookup_elem((fd), (key), (val));           \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("map_lookup");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_map_update_elem(fd, key, val, flags)                              \
+	({                                                                     \
+		int __ret = bpf_map_update_elem((fd), (key), (val), (flags));  \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("map_update");                              \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_attach(prog, target, type, flags)                            \
+	({                                                                     \
+		int __ret =                                                    \
+			bpf_prog_attach((prog), (target), (type), (flags));    \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("prog_attach(" #type ")");                  \
+		__ret;                                                         \
+	})
+
+#define xbpf_prog_detach2(prog, target, type)                                  \
+	({                                                                     \
+		int __ret = bpf_prog_detach2((prog), (target), (type));        \
+		if (__ret == -1)                                               \
+			FAIL_ERRNO("prog_detach2(" #type ")");                 \
+		__ret;                                                         \
+	})
+
+#define xpthread_create(thread, attr, func, arg)                               \
+	({                                                                     \
+		int __ret = pthread_create((thread), (attr), (func), (arg));   \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_create");                          \
+		__ret;                                                         \
+	})
+
+#define xpthread_join(thread, retval)                                          \
+	({                                                                     \
+		int __ret = pthread_join((thread), (retval));                  \
+		errno = __ret;                                                 \
+		if (__ret)                                                     \
+			FAIL_ERRNO("pthread_join");                            \
+		__ret;                                                         \
+	})
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
+static int enable_reuseport(int s, int progfd)
+{
+	int err, one = 1;
+
+	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEPORT, &one, sizeof(one));
+	if (err)
+		return -1;
+	err = xsetsockopt(s, SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF, &progfd,
+			  sizeof(progfd));
+	if (err)
+		return -1;
+
+	return 0;
+}
+
+static int listen_loopback_reuseport(int family, int sotype, int progfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err, s;
+
+	init_addr_loopback(family, &addr, &len);
+
+	s = xsocket(family, sotype, 0);
+	if (s == -1)
+		return -1;
+
+	if (progfd >= 0)
+		enable_reuseport(s, progfd);
+
+	err = xbind(s, sockaddr(&addr), len);
+	if (err)
+		goto close;
+
+	err = xlisten(s, SOMAXCONN);
+	if (err)
+		goto close;
+
+	return s;
+close:
+	xclose(s);
+	return -1;
+}
+
+static int listen_loopback(int family, int sotype)
+{
+	return listen_loopback_reuseport(family, sotype, -1);
+}
+
+static void test_sockmap_insert_invalid(int family, int sotype, int mapfd)
+{
+	u32 key = 0;
+	u64 value;
+	int err;
+
+	value = -1;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EINVAL)
+		FAIL_ERRNO("map_update: expected EINVAL");
+
+	value = INT_MAX;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EBADF)
+		FAIL_ERRNO("map_update: expected EBADF");
+}
+
+static void test_sockmap_insert_opened(int family, int sotype, int mapfd)
+{
+	u32 key = 0;
+	u64 value;
+	int err, s;
+
+	s = xsocket(family, sotype, 0);
+	if (s == -1)
+		return;
+
+	errno = 0;
+	value = s;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EOPNOTSUPP)
+		FAIL_ERRNO("map_update: expected EOPNOTSUPP");
+
+	xclose(s);
+}
+
+static void test_sockmap_insert_bound(int family, int sotype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	u32 key = 0;
+	u64 value;
+	int err, s;
+
+	init_addr_loopback(family, &addr, &len);
+
+	s = xsocket(family, sotype, 0);
+	if (s == -1)
+		return;
+
+	err = xbind(s, sockaddr(&addr), len);
+	if (err)
+		goto close;
+
+	errno = 0;
+	value = s;
+	err = bpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	if (!err || errno != EOPNOTSUPP)
+		FAIL_ERRNO("map_update: expected EOPNOTSUPP");
+close:
+	xclose(s);
+}
+
+static void test_sockmap_insert_listening(int family, int sotype, int mapfd)
+{
+	u64 value;
+	u32 key;
+	int s;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xclose(s);
+}
+
+static void test_sockmap_delete_after_insert(int family, int sotype, int mapfd)
+{
+	u64 value;
+	u32 key;
+	int s;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xbpf_map_delete_elem(mapfd, &key);
+	xclose(s);
+}
+
+static void test_sockmap_delete_after_close(int family, int sotype, int mapfd)
+{
+	int err, s;
+	u64 value;
+	u32 key;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	xclose(s);
+
+	errno = 0;
+	err = bpf_map_delete_elem(mapfd, &key);
+	if (!err || errno != EINVAL)
+		FAIL_ERRNO("map_delete: expected EINVAL");
+}
+
+static void test_sockmap_lookup_after_insert(int family, int sotype, int mapfd)
+{
+	u64 cookie, value;
+	socklen_t len;
+	u32 key;
+	int s;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	len = sizeof(cookie);
+	xgetsockopt(s, SOL_SOCKET, SO_COOKIE, &cookie, &len);
+
+	xbpf_map_lookup_elem(mapfd, &key, &value);
+
+	if (value != cookie) {
+		FAIL("map_lookup: have %#llx, want %#llx",
+		     (unsigned long long)value, (unsigned long long)cookie);
+	}
+
+	xclose(s);
+}
+
+static void test_sockmap_lookup_after_delete(int family, int sotype, int mapfd)
+{
+	int err, s;
+	u64 value;
+	u32 key;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xbpf_map_delete_elem(mapfd, &key);
+
+	errno = 0;
+	err = bpf_map_lookup_elem(mapfd, &key, &value);
+	if (!err || errno != ENOENT)
+		FAIL_ERRNO("map_lookup: expected ENOENT");
+
+	xclose(s);
+}
+
+static void test_sockmap_lookup_32_bit_value(int family, int sotype, int mapfd)
+{
+	u32 key, value32;
+	int err, s;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	mapfd = bpf_create_map(BPF_MAP_TYPE_SOCKMAP, sizeof(key),
+			       sizeof(value32), 1, 0);
+	if (mapfd < 0) {
+		FAIL_ERRNO("map_create");
+		goto close;
+	}
+
+	key = 0;
+	value32 = s;
+	xbpf_map_update_elem(mapfd, &key, &value32, BPF_NOEXIST);
+
+	errno = 0;
+	err = bpf_map_lookup_elem(mapfd, &key, &value32);
+	if (!err || errno != ENOSPC)
+		FAIL_ERRNO("map_lookup: expected ENOSPC");
+
+	xclose(mapfd);
+close:
+	xclose(s);
+}
+
+static void test_sockmap_update_listening(int family, int sotype, int mapfd)
+{
+	int s1, s2;
+	u64 value;
+	u32 key;
+
+	s1 = listen_loopback(family, sotype);
+	if (s1 < 0)
+		return;
+
+	s2 = listen_loopback(family, sotype);
+	if (s2 < 0)
+		goto close_s1;
+
+	key = 0;
+	value = s1;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	value = s2;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_EXIST);
+	xclose(s2);
+close_s1:
+	xclose(s1);
+}
+
+/* Exercise the code path where we destroy child sockets that never
+ * got accept()'ed, aka orphans, when parent socket gets closed.
+ */
+static void test_sockmap_destroy_orphan_child(int family, int sotype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err, s, c;
+	u64 value;
+	u32 key;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+
+	c = xsocket(family, sotype, 0);
+	if (c == -1)
+		goto close_srv;
+
+	xconnect(c, sockaddr(&addr), len);
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+/* Perform a passive open after removing listening socket from SOCKMAP
+ * to ensure that callbacks get restored properly.
+ */
+static void test_sockmap_clone_after_delete(int family, int sotype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	socklen_t len;
+	int err, s, c;
+	u64 value;
+	u32 key;
+
+	s = listen_loopback(family, sotype);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	key = 0;
+	value = s;
+	xbpf_map_update_elem(mapfd, &key, &value, BPF_NOEXIST);
+	xbpf_map_delete_elem(mapfd, &key);
+
+	c = xsocket(family, sotype, 0);
+	if (c < 0)
+		goto close_srv;
+
+	xconnect(c, sockaddr(&addr), len);
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+/* Check that child socket that got created while parent was in a
+ * SOCKMAP, but got accept()'ed only after the parent has been removed
+ * from SOCKMAP, gets cloned without parent psock state or callbacks.
+ */
+static void test_sockmap_accept_after_delete(int family, int sotype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	const u32 zero = 0;
+	int err, s, c, p;
+	socklen_t len;
+	u64 value;
+
+	s = listen_loopback(family, sotype);
+	if (s == -1)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	value = s;
+	err = xbpf_map_update_elem(mapfd, &zero, &value, BPF_NOEXIST);
+	if (err)
+		goto close_srv;
+
+	c = xsocket(family, sotype, 0);
+	if (c == -1)
+		goto close_srv;
+
+	/* Create child while parent is in sockmap */
+	err = xconnect(c, sockaddr(&addr), len);
+	if (err)
+		goto close_cli;
+
+	/* Remove parent from sockmap */
+	err = xbpf_map_delete_elem(mapfd, &zero);
+	if (err)
+		goto close_cli;
+
+	p = xaccept(s, NULL, NULL);
+	if (p == -1)
+		goto close_cli;
+
+	/* Check that child sk_user_data is not set */
+	value = p;
+	xbpf_map_update_elem(mapfd, &zero, &value, BPF_NOEXIST);
+
+	xclose(p);
+close_cli:
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+/* Check that child socket that got created and accepted while parent
+ * was in a SOCKMAP is cloned without parent psock state or callbacks.
+ */
+static void test_sockmap_accept_before_delete(int family, int sotype, int mapfd)
+{
+	struct sockaddr_storage addr;
+	const u32 zero = 0, one = 1;
+	int err, s, c, p;
+	socklen_t len;
+	u64 value;
+
+	s = listen_loopback(family, sotype);
+	if (s == -1)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	value = s;
+	err = xbpf_map_update_elem(mapfd, &zero, &value, BPF_NOEXIST);
+	if (err)
+		goto close_srv;
+
+	c = xsocket(family, sotype, 0);
+	if (c == -1)
+		goto close_srv;
+
+	/* Create & accept child while parent is in sockmap */
+	err = xconnect(c, sockaddr(&addr), len);
+	if (err)
+		goto close_cli;
+
+	p = xaccept(s, NULL, NULL);
+	if (p == -1)
+		goto close_cli;
+
+	/* Check that child sk_user_data is not set */
+	value = p;
+	xbpf_map_update_elem(mapfd, &one, &value, BPF_NOEXIST);
+
+	xclose(p);
+close_cli:
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+struct connect_accept_ctx {
+	int sockfd;
+	unsigned int done;
+	unsigned int nr_iter;
+};
+
+static bool is_thread_done(struct connect_accept_ctx *ctx)
+{
+	return READ_ONCE(ctx->done);
+}
+
+static void *connect_accept_thread(void *arg)
+{
+	struct connect_accept_ctx *ctx = arg;
+	struct sockaddr_storage addr;
+	int family, socktype;
+	socklen_t len;
+	int err, i, s;
+
+	s = ctx->sockfd;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto done;
+
+	len = sizeof(family);
+	err = xgetsockopt(s, SOL_SOCKET, SO_DOMAIN, &family, &len);
+	if (err)
+		goto done;
+
+	len = sizeof(socktype);
+	err = xgetsockopt(s, SOL_SOCKET, SO_TYPE, &socktype, &len);
+	if (err)
+		goto done;
+
+	for (i = 0; i < ctx->nr_iter; i++) {
+		int c, p;
+
+		c = xsocket(family, socktype, 0);
+		if (c < 0)
+			break;
+
+		err = xconnect(c, (struct sockaddr *)&addr, sizeof(addr));
+		if (err) {
+			xclose(c);
+			break;
+		}
+
+		p = xaccept(s, NULL, NULL);
+		if (p < 0) {
+			xclose(c);
+			break;
+		}
+
+		xclose(p);
+		xclose(c);
+	}
+done:
+	WRITE_ONCE(ctx->done, 1);
+	return NULL;
+}
+
+static void test_sockmap_syn_recv_insert_delete(int family, int sotype,
+						int mapfd)
+{
+	struct connect_accept_ctx ctx = { 0 };
+	struct sockaddr_storage addr;
+	socklen_t len;
+	u32 zero = 0;
+	pthread_t t;
+	int err, s;
+	u64 value;
+
+	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close;
+
+	ctx.sockfd = s;
+	ctx.nr_iter = 1000;
+
+	err = xpthread_create(&t, NULL, connect_accept_thread, &ctx);
+	if (err)
+		goto close;
+
+	value = s;
+	while (!is_thread_done(&ctx)) {
+		err = xbpf_map_update_elem(mapfd, &zero, &value, BPF_NOEXIST);
+		if (err)
+			break;
+
+		err = xbpf_map_delete_elem(mapfd, &zero);
+		if (err)
+			break;
+	}
+
+	xpthread_join(t, NULL);
+close:
+	xclose(s);
+}
+
+static void *listen_thread(void *arg)
+{
+	struct sockaddr unspec = { AF_UNSPEC };
+	struct connect_accept_ctx *ctx = arg;
+	int err, i, s;
+
+	s = ctx->sockfd;
+
+	for (i = 0; i < ctx->nr_iter; i++) {
+		err = xlisten(s, 1);
+		if (err)
+			break;
+		err = xconnect(s, &unspec, sizeof(unspec));
+		if (err)
+			break;
+	}
+
+	WRITE_ONCE(ctx->done, 1);
+	return NULL;
+}
+
+static void test_sockmap_race_insert_listen(int family, int socktype, int mapfd)
+{
+	struct connect_accept_ctx ctx = { 0 };
+	const u32 zero = 0;
+	const int one = 1;
+	pthread_t t;
+	int err, s;
+	u64 value;
+
+	s = xsocket(family, socktype, 0);
+	if (s < 0)
+		return;
+
+	err = xsetsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
+	if (err)
+		goto close;
+
+	ctx.sockfd = s;
+	ctx.nr_iter = 10000;
+
+	err = pthread_create(&t, NULL, listen_thread, &ctx);
+	if (err)
+		goto close;
+
+	value = s;
+	while (!is_thread_done(&ctx)) {
+		err = bpf_map_update_elem(mapfd, &zero, &value, BPF_NOEXIST);
+		/* Expecting EOPNOTSUPP before listen() */
+		if (err && errno != EOPNOTSUPP) {
+			FAIL_ERRNO("map_update");
+			break;
+		}
+
+		err = bpf_map_delete_elem(mapfd, &zero);
+		/* Expecting EINVAL after unhash on connect(AF_UNSPEC) */
+		if (err && errno != EINVAL) {
+			FAIL_ERRNO("map_delete");
+			break;
+		}
+	}
+
+	xpthread_join(t, NULL);
+close:
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
+enum redir_mode {
+	REDIR_INGRESS,
+	REDIR_EGRESS,
+};
+
+static const char *redir_mode_str(enum redir_mode mode)
+{
+	switch (mode) {
+	case REDIR_INGRESS:
+		return "ingress";
+	case REDIR_EGRESS:
+		return "egress";
+	default:
+		return "unknown";
+	}
+}
+
+static void redir_to_connected(int family, int sotype, int sock_mapfd,
+			       int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	struct sockaddr_storage addr;
+	int s, c0, c1, p0, p1;
+	unsigned int pass;
+	socklen_t len;
+	int err, n;
+	u64 value;
+	u32 key;
+	char b;
+
+	zero_verdict_count(verd_mapfd);
+
+	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	c0 = xsocket(family, sotype, 0);
+	if (c0 < 0)
+		goto close_srv;
+	err = xconnect(c0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+
+	p0 = xaccept(s, NULL, NULL);
+	if (p0 < 0)
+		goto close_cli0;
+
+	c1 = xsocket(family, sotype, 0);
+	if (c1 < 0)
+		goto close_peer0;
+	err = xconnect(c1, sockaddr(&addr), len);
+	if (err)
+		goto close_cli1;
+
+	p1 = xaccept(s, NULL, NULL);
+	if (p1 < 0)
+		goto close_cli1;
+
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_peer1;
+
+	key = 1;
+	value = p1;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_peer1;
+
+	n = write(mode == REDIR_INGRESS ? c1 : p1, "a", 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close_peer1;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &pass);
+	if (err)
+		goto close_peer1;
+	if (pass != 1)
+		FAIL("%s: want pass count 1, have %d", log_prefix, pass);
+
+	n = read(c0, &b, 1);
+	if (n < 0)
+		FAIL_ERRNO("%s: read", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete read", log_prefix);
+
+close_peer1:
+	xclose(p1);
+close_cli1:
+	xclose(c1);
+close_peer0:
+	xclose(p0);
+close_cli0:
+	xclose(c0);
+close_srv:
+	xclose(s);
+}
+
+static void
+test_sockmap_skb_redir_to_connected(struct test_sockmap_listen *skel,
+				    int family, int sotype)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	int parser = bpf_program__fd(skel->progs.prog_skb_parser);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(skel->maps.sock_map);
+	int err;
+
+	err = xbpf_prog_attach(parser, sock_map, BPF_SK_SKB_STREAM_PARSER, 0);
+	if (err)
+		return;
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (err)
+		goto detach;
+
+	redir_to_connected(family, sotype, sock_map, verdict_map,
+			   REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_STREAM_VERDICT);
+detach:
+	xbpf_prog_detach2(parser, sock_map, BPF_SK_SKB_STREAM_PARSER);
+}
+
+static void
+test_sockmap_msg_redir_to_connected(struct test_sockmap_listen *skel,
+				    int family, int sotype)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(skel->maps.sock_map);
+	int err;
+
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_MSG_VERDICT, 0);
+	if (err)
+		return;
+
+	redir_to_connected(family, sotype, sock_map, verdict_map, REDIR_EGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_MSG_VERDICT);
+}
+
+static void redir_to_listening(int family, int sotype, int sock_mapfd,
+			       int verd_mapfd, enum redir_mode mode)
+{
+	const char *log_prefix = redir_mode_str(mode);
+	struct sockaddr_storage addr;
+	int s, c, p, err, n;
+	unsigned int drop;
+	socklen_t len;
+	u64 value;
+	u32 key;
+
+	zero_verdict_count(verd_mapfd);
+
+	s = listen_loopback(family, sotype | SOCK_NONBLOCK);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	c = xsocket(family, sotype, 0);
+	if (c < 0)
+		goto close_srv;
+	err = xconnect(c, sockaddr(&addr), len);
+	if (err)
+		goto close_cli;
+
+	p = xaccept(s, NULL, NULL);
+	if (p < 0)
+		goto close_cli;
+
+	key = 0;
+	value = s;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_peer;
+
+	key = 1;
+	value = p;
+	err = xbpf_map_update_elem(sock_mapfd, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_peer;
+
+	n = write(mode == REDIR_INGRESS ? c : p, "a", 1);
+	if (n < 0 && errno != EACCES)
+		FAIL_ERRNO("%s: write", log_prefix);
+	if (n == 0)
+		FAIL("%s: incomplete write", log_prefix);
+	if (n < 1)
+		goto close_peer;
+
+	key = SK_DROP;
+	err = xbpf_map_lookup_elem(verd_mapfd, &key, &drop);
+	if (err)
+		goto close_peer;
+	if (drop != 1)
+		FAIL("%s: want drop count 1, have %d", log_prefix, drop);
+
+close_peer:
+	xclose(p);
+close_cli:
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+static void
+test_sockmap_skb_redir_to_listening(struct test_sockmap_listen *skel,
+				    int family, int sotype)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	int parser = bpf_program__fd(skel->progs.prog_skb_parser);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(skel->maps.sock_map);
+	int err;
+
+	err = xbpf_prog_attach(parser, sock_map, BPF_SK_SKB_STREAM_PARSER, 0);
+	if (err)
+		return;
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (err)
+		goto detach;
+
+	redir_to_listening(family, sotype, sock_map, verdict_map,
+			   REDIR_INGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_STREAM_VERDICT);
+detach:
+	xbpf_prog_detach2(parser, sock_map, BPF_SK_SKB_STREAM_PARSER);
+}
+
+static void
+test_sockmap_msg_redir_to_listening(struct test_sockmap_listen *skel,
+				    int family, int sotype)
+{
+	int verdict = bpf_program__fd(skel->progs.prog_msg_verdict);
+	int verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	int sock_map = bpf_map__fd(skel->maps.sock_map);
+	int err;
+
+	err = xbpf_prog_attach(verdict, sock_map, BPF_SK_MSG_VERDICT, 0);
+	if (err)
+		return;
+
+	redir_to_listening(family, sotype, sock_map, verdict_map, REDIR_EGRESS);
+
+	xbpf_prog_detach2(verdict, sock_map, BPF_SK_MSG_VERDICT);
+}
+
+static void test_sockmap_reuseport_select_listening(int family, int sotype,
+						    int sock_map, int verd_map,
+						    int reuseport_prog)
+{
+	struct sockaddr_storage addr;
+	unsigned int pass;
+	int s, c, p, err;
+	socklen_t len;
+	u64 value;
+	u32 key;
+
+	zero_verdict_count(verd_map);
+
+	s = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	if (s < 0)
+		return;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	key = 0;
+	value = s;
+	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_srv;
+
+	c = xsocket(family, sotype, 0);
+	if (c < 0)
+		goto close_srv;
+	err = xconnect(c, sockaddr(&addr), len);
+	if (err)
+		goto close_cli;
+
+	p = xaccept(s, NULL, NULL);
+	if (p < 0)
+		goto close_cli;
+
+	key = SK_PASS;
+	err = xbpf_map_lookup_elem(verd_map, &key, &pass);
+	if (err)
+		goto close_peer;
+	if (pass != 1)
+		FAIL("want pass count 1, have %d", pass);
+
+close_peer:
+	xclose(p);
+close_cli:
+	xclose(c);
+close_srv:
+	xclose(s);
+}
+
+static void test_sockmap_reuseport_select_connected(int family, int sotype,
+						    int sock_map, int verd_map,
+						    int reuseport_prog)
+{
+	struct sockaddr_storage addr;
+	int s, c0, c1, p0, err;
+	unsigned int drop;
+	socklen_t len;
+	u64 value;
+	u32 key;
+
+	zero_verdict_count(verd_map);
+
+	s = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	if (s < 0)
+		return;
+
+	/* Populate sock_map[0] to avoid ENOENT on first connection */
+	key = 0;
+	value = s;
+	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_srv;
+
+	len = sizeof(addr);
+	err = xgetsockname(s, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv;
+
+	c0 = xsocket(family, sotype, 0);
+	if (c0 < 0)
+		goto close_srv;
+
+	err = xconnect(c0, sockaddr(&addr), len);
+	if (err)
+		goto close_cli0;
+
+	p0 = xaccept(s, NULL, NULL);
+	if (err)
+		goto close_cli0;
+
+	/* Update sock_map[0] to redirect to a connected socket */
+	key = 0;
+	value = p0;
+	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_EXIST);
+	if (err)
+		goto close_peer0;
+
+	c1 = xsocket(family, sotype, 0);
+	if (c1 < 0)
+		goto close_peer0;
+
+	errno = 0;
+	err = connect(c1, sockaddr(&addr), len);
+	if (!err || errno != ECONNREFUSED)
+		FAIL_ERRNO("connect: expected ECONNREFUSED");
+
+	key = SK_DROP;
+	err = xbpf_map_lookup_elem(verd_map, &key, &drop);
+	if (err)
+		goto close_cli1;
+	if (drop != 1)
+		FAIL("want drop count 1, have %d", drop);
+
+close_cli1:
+	xclose(c1);
+close_peer0:
+	xclose(p0);
+close_cli0:
+	xclose(c0);
+close_srv:
+	xclose(s);
+}
+
+/* Check that redirecting across reuseport groups is not allowed. */
+static void test_sockmap_reuseport_mixed_groups(int family, int sotype,
+						int sock_map, int verd_map,
+						int reuseport_prog)
+{
+	struct sockaddr_storage addr;
+	int s1, s2, c, err;
+	unsigned int drop;
+	socklen_t len;
+	u64 value;
+	u32 key;
+
+	zero_verdict_count(verd_map);
+
+	/* Create two listeners, each in its own reuseport group */
+	s1 = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	if (s1 < 0)
+		return;
+
+	s2 = listen_loopback_reuseport(family, sotype, reuseport_prog);
+	if (s2 < 0)
+		goto close_srv1;
+
+	key = 0;
+	value = s1;
+	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+	if (err)
+		goto close_srv2;
+
+	key = 1;
+	value = s2;
+	err = xbpf_map_update_elem(sock_map, &key, &value, BPF_NOEXIST);
+
+	/* Connect to s2, reuseport BPF selects s1 via sock_map[0] */
+	len = sizeof(addr);
+	err = xgetsockname(s2, sockaddr(&addr), &len);
+	if (err)
+		goto close_srv2;
+
+	c = xsocket(family, sotype, 0);
+	if (c < 0)
+		goto close_srv2;
+
+	err = connect(c, sockaddr(&addr), len);
+	if (err && errno != ECONNREFUSED) {
+		FAIL_ERRNO("connect: expected ECONNREFUSED");
+		goto close_cli;
+	}
+
+	/* Expect drop, can't redirect outside of reuseport group */
+	key = SK_DROP;
+	err = xbpf_map_lookup_elem(verd_map, &key, &drop);
+	if (err)
+		goto close_cli;
+	if (drop != 1)
+		FAIL("want drop count 1, have %d", drop);
+
+close_cli:
+	xclose(c);
+close_srv2:
+	xclose(s2);
+close_srv1:
+	xclose(s1);
+}
+
+#define TEST(fn)                                                               \
+	{                                                                      \
+		fn, #fn                                                        \
+	}
+
+static void cleanup_sockmap_ops(int mapfd)
+{
+	int err;
+	u32 key;
+
+	for (key = 0; key < 2; key++) {
+		err = bpf_map_delete_elem(mapfd, &key);
+		if (err && errno != EINVAL)
+			FAIL_ERRNO("map_delete");
+	}
+}
+
+static const char *family_str(sa_family_t family)
+{
+	switch (family) {
+	case AF_INET:
+		return "IPv4";
+	case AF_INET6:
+		return "IPv6";
+	default:
+		return "unknown";
+	}
+}
+
+static void test_sockmap_ops(struct test_sockmap_listen *skel, int family,
+			     int sotype)
+{
+	const struct op_test {
+		void (*fn)(int family, int sotype, int sock_map);
+		const char *name;
+	} tests[] = {
+		/* insert */
+		TEST(test_sockmap_insert_invalid),
+		TEST(test_sockmap_insert_opened),
+		TEST(test_sockmap_insert_bound),
+		TEST(test_sockmap_insert_listening),
+		/* delete */
+		TEST(test_sockmap_delete_after_insert),
+		TEST(test_sockmap_delete_after_close),
+		/* lookup */
+		TEST(test_sockmap_lookup_after_insert),
+		TEST(test_sockmap_lookup_after_delete),
+		TEST(test_sockmap_lookup_32_bit_value),
+		/* update */
+		TEST(test_sockmap_update_listening),
+		/* races with insert/delete */
+		TEST(test_sockmap_destroy_orphan_child),
+		TEST(test_sockmap_syn_recv_insert_delete),
+		TEST(test_sockmap_race_insert_listen),
+		/* child clone */
+		TEST(test_sockmap_clone_after_delete),
+		TEST(test_sockmap_accept_after_delete),
+		TEST(test_sockmap_accept_before_delete),
+	};
+	const struct op_test *t;
+	char s[MAX_TEST_NAME];
+	int sock_map;
+
+	sock_map = bpf_map__fd(skel->maps.sock_map);
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		snprintf(s, sizeof(s), "%s %s", family_str(family), t->name);
+
+		if (!test__start_subtest(s))
+			continue;
+
+		t->fn(family, sotype, sock_map);
+		cleanup_sockmap_ops(sock_map);
+	}
+}
+
+static void test_sockmap_redir(struct test_sockmap_listen *skel, int family,
+			       int sotype)
+{
+	const struct redir_test {
+		void (*fn)(struct test_sockmap_listen *skel, int family,
+			   int sotype);
+		const char *name;
+	} tests[] = {
+		TEST(test_sockmap_skb_redir_to_connected),
+		TEST(test_sockmap_skb_redir_to_listening),
+		TEST(test_sockmap_msg_redir_to_connected),
+		TEST(test_sockmap_msg_redir_to_listening),
+	};
+	const struct redir_test *t;
+	char s[MAX_TEST_NAME];
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		snprintf(s, sizeof(s), "%s %s", family_str(family), t->name);
+
+		if (!test__start_subtest(s))
+			continue;
+
+		t->fn(skel, family, sotype);
+	}
+}
+
+static void test_sockmap_reuseport(struct test_sockmap_listen *skel, int family,
+				   int sotype)
+{
+	const struct reuseport_test {
+		void (*fn)(int family, int sotype, int sock_map,
+			   int verdict_map, int reuseport_prog);
+		const char *name;
+	} tests[] = {
+		TEST(test_sockmap_reuseport_select_listening),
+		TEST(test_sockmap_reuseport_select_connected),
+		TEST(test_sockmap_reuseport_mixed_groups),
+	};
+	int sock_map, verdict_map, reuseport_prog;
+	const struct reuseport_test *t;
+	char s[MAX_TEST_NAME];
+
+	sock_map = bpf_map__fd(skel->maps.sock_map);
+	verdict_map = bpf_map__fd(skel->maps.verdict_map);
+	reuseport_prog = bpf_program__fd(skel->progs.prog_reuseport);
+
+	for (t = tests; t < tests + ARRAY_SIZE(tests); t++) {
+		snprintf(s, sizeof(s), "%s %s", family_str(family), t->name);
+
+		if (!test__start_subtest(s))
+			continue;
+
+		t->fn(family, sotype, sock_map, verdict_map, reuseport_prog);
+	}
+}
+
+static void run_tests(struct test_sockmap_listen *skel, int family)
+{
+	test_sockmap_ops(skel, family, SOCK_STREAM);
+	test_sockmap_redir(skel, family, SOCK_STREAM);
+	test_sockmap_reuseport(skel, family, SOCK_STREAM);
+}
+
+void test_sockmap_listen(void)
+{
+	struct test_sockmap_listen *skel;
+
+	skel = test_sockmap_listen__open_and_load();
+	if (!skel) {
+		FAIL("skeleton open/load failed");
+		return;
+	}
+
+	run_tests(skel, AF_INET);
+	run_tests(skel, AF_INET6);
+
+	test_sockmap_listen__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_sockmap_listen.c b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
new file mode 100644
index 000000000000..807f4857b975
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_sockmap_listen.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+
+#include <errno.h>
+#include <linux/bpf.h>
+
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SOCKMAP);
+	__uint(max_entries, 2);
+	__type(key, __u32);
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
+	verdict = err ? SK_DROP : SK_PASS;
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
-- 
2.24.1

