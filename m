Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FB61611D6
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgBQMPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:15:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35079 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbgBQMPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:15:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so18228952wmb.0
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 04:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xYV6Qpe3aUou6pR5XJDjaGXpWzFDz2Y3/ja4J0yl6Zc=;
        b=DGL1YEojBUF9qM8evqupcMGVhy9lhg49e9++vkcjA3jgPCNfcUM86Vsb5cr6DasgMQ
         mT2wwG6dj1xsR5G4aF6LLxgwP/h7s8Nb7V1NzUQ+qLclyShkSxB3ePg3eHPz9Emfp/Yc
         QGa/J1ZlW7Tx6Pcfg58JveNi6xh0lU3XgJL3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xYV6Qpe3aUou6pR5XJDjaGXpWzFDz2Y3/ja4J0yl6Zc=;
        b=UHuB7EGenL7MLMz7h012incVt8mxXHKqxFmRxnKuCT+IlZDxVoV+nv1jX+HW7ttz6B
         pEvMaBCyb0hPZ9XkDVX8uUAdtMK1/SEol/hrHCRoAUrRPPj0XV30klIjOqr6/tqubUXr
         neYhTu1TLAmAE7+1MhWEAf7a8kx7MJ8OdO35bzottlxuCPkR4vlHCfuISE1JeM1J7fG5
         qCa/KmIqiFwT5hpluDMHkrW7DoVnIKyojEYTa6uGM8w0cySyEY7K0THggSBq1JXYlHIQ
         pG4A12Q8NJl86IZu24qHidfvixZj9YjTeU7av/WJ9w5HmuvWw8xm4Jv84zv/1tzVqu0q
         to8g==
X-Gm-Message-State: APjAAAXsb0frodYnWbT0tOlFfF1Kz2HPpcHzZVuKswP5a3Nwv1AvBj5l
        uUavCqVxk2t0Yi22o8MhU5n6mw==
X-Google-Smtp-Source: APXvYqzEmXKobvaVlgQsugkTEr5Y7y7JCRNXJ1KuT9EuP4nyDqpD06Ey1IGUI15pGfrKsuID45zozg==
X-Received: by 2002:a1c:de55:: with SMTP id v82mr21895172wmg.48.1581941737760;
        Mon, 17 Feb 2020 04:15:37 -0800 (PST)
Received: from cloudflare.com ([88.157.168.82])
        by smtp.gmail.com with ESMTPSA id o15sm690316wra.83.2020.02.17.04.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 04:15:37 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [PATCH bpf-next 3/3] selftests/bpf: Test unhashing kTLS socket after removing from map
Date:   Mon, 17 Feb 2020 12:15:30 +0000
Message-Id: <20200217121530.754315-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200217121530.754315-1-jakub@cloudflare.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a TCP socket gets inserted into a sockmap, its sk_prot callbacks get
replaced with tcp_bpf callbacks built from regular tcp callbacks. If TLS
gets enabled on the same socket, sk_prot callbacks get replaced once again,
this time with kTLS callbacks built from tcp_bpf callbacks.

Now, we allow removing a socket from a sockmap that has kTLS enabled. After
removal, socket remains with kTLS configured. This is where things things
get tricky.

Since the socket has a set of sk_prot callbacks that are a mix of kTLS and
tcp_bpf callbacks, we need to restore just the tcp_bpf callbacks to the
original ones. At the moment, it comes down to the the unhash operation.

We had a regression recently because tcp_bpf callbacks were not cleared in
this particular scenario of removing a kTLS socket from a sockmap. It got
fixed in commit 4da6a196f93b ("bpf: Sockmap/tls, during free we may call
tcp_bpf_unhash() in loop").

Add a test that triggers the regression so that we don't reintroduce it in
the future.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 .../selftests/bpf/prog_tests/sockmap_ktls.c   | 123 ++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
new file mode 100644
index 000000000000..589b50c91b96
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_ktls.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2020 Cloudflare
+/*
+ * Tests for sockmap/sockhash holding kTLS sockets.
+ */
+
+#include "test_progs.h"
+
+#define MAX_TEST_NAME 80
+
+static int tcp_server(int family)
+{
+	int err, s;
+
+	s = socket(family, SOCK_STREAM, 0);
+	if (CHECK_FAIL(s == -1)) {
+		perror("socket");
+		return -1;
+	}
+
+	err = listen(s, SOMAXCONN);
+	if (CHECK_FAIL(err)) {
+		perror("listen");
+		return -1;
+	}
+
+	return s;
+}
+
+static int disconnect(int fd)
+{
+	struct sockaddr unspec = { AF_UNSPEC };
+
+	return connect(fd, &unspec, sizeof(unspec));
+}
+
+/* Disconnect (unhash) a kTLS socket after removing it from sockmap. */
+static void test_sockmap_ktls_disconnect_after_delete(int family, int map)
+{
+	struct sockaddr_storage addr = {0};
+	socklen_t len = sizeof(addr);
+	int err, cli, srv, zero = 0;
+
+	srv = tcp_server(family);
+	if (srv == -1)
+		return;
+
+	err = getsockname(srv, (struct sockaddr *)&addr, &len);
+	if (CHECK_FAIL(err)) {
+		perror("getsockopt");
+		goto close_srv;
+	}
+
+	cli = socket(family, SOCK_STREAM, 0);
+	if (CHECK_FAIL(cli == -1)) {
+		perror("socket");
+		goto close_srv;
+	}
+
+	err = connect(cli, (struct sockaddr *)&addr, len);
+	if (CHECK_FAIL(err)) {
+		perror("connect");
+		goto close_cli;
+	}
+
+	err = bpf_map_update_elem(map, &zero, &cli, 0);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_update_elem");
+		goto close_cli;
+	}
+
+	err = setsockopt(cli, IPPROTO_TCP, TCP_ULP, "tls", strlen("tls"));
+	if (CHECK_FAIL(err)) {
+		perror("setsockopt(TCP_ULP)");
+		goto close_cli;
+	}
+
+	err = bpf_map_delete_elem(map, &zero);
+	if (CHECK_FAIL(err)) {
+		perror("bpf_map_delete_elem");
+		goto close_cli;
+	}
+
+	err = disconnect(cli);
+	if (CHECK_FAIL(err))
+		perror("disconnect");
+
+close_cli:
+	close(cli);
+close_srv:
+	close(srv);
+}
+
+static void run_tests(int family, enum bpf_map_type map_type)
+{
+	char test_name[MAX_TEST_NAME];
+	int map;
+
+	map = bpf_create_map(map_type, sizeof(int), sizeof(int), 1, 0);
+	if (CHECK_FAIL(map == -1)) {
+		perror("bpf_map_create");
+		return;
+	}
+
+	snprintf(test_name, MAX_TEST_NAME,
+		 "sockmap_ktls disconnect_after_delete %s %s",
+		 family == AF_INET ? "IPv4" : "IPv6",
+		 map_type == BPF_MAP_TYPE_SOCKMAP ? "SOCKMAP" : "SOCKHASH");
+	if (!test__start_subtest(test_name))
+		return;
+
+	test_sockmap_ktls_disconnect_after_delete(family, map);
+
+	close(map);
+}
+
+void test_sockmap_ktls(void)
+{
+	run_tests(AF_INET, BPF_MAP_TYPE_SOCKMAP);
+	run_tests(AF_INET, BPF_MAP_TYPE_SOCKHASH);
+	run_tests(AF_INET6, BPF_MAP_TYPE_SOCKMAP);
+	run_tests(AF_INET6, BPF_MAP_TYPE_SOCKHASH);
+}
-- 
2.24.1

