Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAC31FC61
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 16:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBSPqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 10:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhBSPq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 10:46:29 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA4EC0617A7
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:44:14 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id a207so8072081wmd.1
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 07:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+r5nIbn7SC0nctyFfGqm8+YsIS188S6/wSNE2V/0k+8=;
        b=EzTsXuQ/kssa4Z+WC9pz8o8hG3Kt5SiMRRxE7a5Uh7P7+/u/NSn4fh4lT/qDHKmqnG
         QL6hHC7t9gstDI2sfBubtH42AQBQFFV+S6BPJBJxP6zcTxmaUKnZViyD8I8B2gNf13SE
         5VghQ+dCaf6phYpIm/8DhpjEFkadFYsQ/01vE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+r5nIbn7SC0nctyFfGqm8+YsIS188S6/wSNE2V/0k+8=;
        b=m3GkaQxkDajqC1cjL/0iuAQSPdABH0b6UL4R4le/k8al9pDxE8eLcTW0row4uYf08d
         qe4kSv2PdYfuR8NGWwgr55spIjBralFKj4FX6iHHoFChJKg+SBAHz1l7zm2rX1riaMAT
         +dwWsv0MxZ7fO14NJUiEip/mBX7OU4+WqTauRpJ3IAzcBmSmBe0bBPFoMJygtDESL9Iu
         VOVVAGadvx8OzdJl2ZFhm7VVq1hq/REoqZwK4YoDrJAyOe5ThEwb0shbErog4+NnhO2U
         hhcJeSJ0mTTsyHTZmiACRS733Jdpd1Dx4VcclJw+GIaRVbgp8NJ78Vk38U3oPNTM7Zug
         oaJw==
X-Gm-Message-State: AOAM532grhOth6o/6Kg6A4Ux8U2xYUw55ZSG6zrFpNUc1VZBwfIzqprJ
        FOYDUQuLeG/LepAv72LPkM8tvw==
X-Google-Smtp-Source: ABdhPJzQ/QrN3V5Vk2Nl5jQxhyGxMg3wBwHQEh7q/65C4emdWvqhqkeQJLDlOz3/jUQUwBOFnoq2yg==
X-Received: by 2002:a1c:2d87:: with SMTP id t129mr8720098wmt.121.1613749453431;
        Fri, 19 Feb 2021 07:44:13 -0800 (PST)
Received: from antares.lan (b.3.5.8.9.a.e.c.e.a.6.2.c.1.9.b.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:b91c:26ae:cea9:853b])
        by smtp.gmail.com with ESMTPSA id v204sm12321929wmg.38.2021.02.19.07.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 07:44:13 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     eric.dumazet@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v3 4/4] tools/testing: add a selftest for SO_NETNS_COOKIE
Date:   Fri, 19 Feb 2021 15:43:30 +0000
Message-Id: <20210219154330.93615-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210219154330.93615-1-lmb@cloudflare.com>
References: <20210219154330.93615-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure that SO_NETNS_COOKIE returns a non-zero value, and
that sockets from different namespaces have a distinct cookie
value.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  2 +-
 tools/testing/selftests/net/config            |  1 +
 tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
 4 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/so_netns_cookie.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 61ae899cfc17..19deb9cdf72f 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -30,3 +30,4 @@ hwtstamp_config
 rxtimestamp
 timestamping
 txtimestamp
+so_netns_cookie
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 25f198bec0b2..91bb372f5ba5 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -28,7 +28,7 @@ TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
-TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
+TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr so_netns_cookie
 TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_FILES += reuseaddr_ports_exhausted
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 614d5477365a..6f905b53904f 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -1,4 +1,5 @@
 CONFIG_USER_NS=y
+CONFIG_NET_NS=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_TEST_BPF=m
 CONFIG_NUMA=y
diff --git a/tools/testing/selftests/net/so_netns_cookie.c b/tools/testing/selftests/net/so_netns_cookie.c
new file mode 100644
index 000000000000..b39e87e967cd
--- /dev/null
+++ b/tools/testing/selftests/net/so_netns_cookie.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#ifndef SO_NETNS_COOKIE
+#define SO_NETNS_COOKIE 71
+#endif
+
+#define pr_err(fmt, ...) \
+	({ \
+		fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+			__func__, __LINE__, ##__VA_ARGS__); \
+		1; \
+	})
+
+int main(int argc, char *argvp[])
+{
+	uint64_t cookie1, cookie2;
+	socklen_t vallen;
+	int sock1, sock2;
+
+	sock1 = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock1 < 0)
+		return pr_err("Unable to create TCP socket");
+
+	vallen = sizeof(cookie1);
+	if (getsockopt(sock1, SOL_SOCKET, SO_NETNS_COOKIE, &cookie1, &vallen) != 0)
+		return pr_err("getsockopt(SOL_SOCKET, SO_NETNS_COOKIE)");
+
+	if (!cookie1)
+		return pr_err("SO_NETNS_COOKIE returned zero cookie");
+
+	if (unshare(CLONE_NEWNET))
+		return pr_err("unshare");
+
+	sock2 = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock2 < 0)
+		return pr_err("Unable to create TCP socket");
+
+	vallen = sizeof(cookie2);
+	if (getsockopt(sock2, SOL_SOCKET, SO_NETNS_COOKIE, &cookie2, &vallen) != 0)
+		return pr_err("getsockopt(SOL_SOCKET, SO_NETNS_COOKIE)");
+
+	if (!cookie2)
+		return pr_err("SO_NETNS_COOKIE returned zero cookie");
+
+	if (cookie1 == cookie2)
+		return pr_err("SO_NETNS_COOKIE returned identical cookies for distinct ns");
+
+	close(sock1);
+	close(sock2);
+	return 0;
+}
-- 
2.27.0

