Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C59316667
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhBJMQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbhBJMNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:13:04 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0322C061BC3
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:43 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 7so2242058wrz.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 04:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ko2o/BbXoOQINYLWQy5SvIqF+PCLP66Gm4DbDrcbqNM=;
        b=INbfSkQg1MSBCfmNYdHCKyxLjYiYcwGcPh5Atqoum9f5NufD6C8b+vdGduKpIoe3K0
         fmruz5F2fsNNtukmEbB+Zsx0Ywyswi5lPn1ecF7Q7zmfHWFUQoYD22Li6Yg6EUxhTvzj
         S3alZrS2RzHl+pogD/2sqMwxUbnPhRdizvm+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ko2o/BbXoOQINYLWQy5SvIqF+PCLP66Gm4DbDrcbqNM=;
        b=Mw/qxNBOSbyAlKy5B42uf3kb0UHBYDly3KOF3aXnpekuC8lqCnveSIWW4KcfAiTyAn
         k2wUFsmPR7BCQWSEDZsA7w9mdqYAZGHQfgYI8SU8sZkjegm4bG26ellcO4wd2Yai9H21
         iKnmib0xGbakCMYhSzMHP6oxU/6mStfADtg8P60/kjkznP8N9TyDiFFqW8TMZ312wFKD
         /zkrGKjqpwCsfbksb0RlGsRC/dBZyQo8e3TdugomPZw2N536ba18RyKtGgh+cbv0nPxt
         S//qiT1eCguhxt0yoHawmaWLf0ve3sBeW317qbCPNf7uv3hEMz+AZWrQqKdfHMLGDdIw
         6PpQ==
X-Gm-Message-State: AOAM5303u6apIJUeELSPyzA/hPYvdjjAHI793cMv0bQ4VK59bM7BvlF9
        Eo74h0I7bZh1VIsz8iZNF5Wkbg==
X-Google-Smtp-Source: ABdhPJylIINkWlSCZPDmbOuXA4zKfLnXjVImcpE9euugMX8Qa7mIZlbiIr60HYTkGaa1Uv4BQnMfvw==
X-Received: by 2002:a05:6000:1189:: with SMTP id g9mr3287526wrx.230.1612958682501;
        Wed, 10 Feb 2021 04:04:42 -0800 (PST)
Received: from antares.lan (c.3.c.9.d.d.c.e.0.a.6.8.a.9.e.c.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:ce9a:86a0:ecdd:9c3c])
        by smtp.gmail.com with ESMTPSA id j7sm2837854wrp.72.2021.02.10.04.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 04:04:42 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 4/4] tools/testing: add a selftest for SO_NETNS_COOKIE
Date:   Wed, 10 Feb 2021 12:04:25 +0000
Message-Id: <20210210120425.53438-5-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210210120425.53438-1-lmb@cloudflare.com>
References: <20210210120425.53438-1-lmb@cloudflare.com>
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
 tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)
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
index fa5fa425d148..a0f45a71a8f1 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -27,7 +27,7 @@ TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
-TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
+TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr so_netns_cookie
 TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_FILES += reuseaddr_ports_exhausted
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

