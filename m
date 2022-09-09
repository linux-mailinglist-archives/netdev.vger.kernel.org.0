Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C185B2B33
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 02:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiIIAuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 20:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiIIAuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 20:50:12 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912416E2D1
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 17:50:10 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g63-20020a636b42000000b004305794e112so71734pgc.20
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 17:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=l60jWrvXFLVlPq9d3zDJ2MhW7oGs+fbSrMuq9s9CgZg=;
        b=CvBkV0ztDXgs2xh9vA2CluEStssd+e9Xqs4Niu1+4NW0EHHOUzLFkEWRI48DIVpkhG
         WsNQorp1RijR2KARGqxfYCAJ02+s4WQ7XtFcKWUzb/0VrnkZ23aiT2QvbyXKUR/cPUzv
         Mg41ZHGci1lVPdrk9e3vqZLyjFDKexiLt0qUikbcr1n4J1gFg6OHNsgdmEz2iXo8ifZt
         28riNXzZhW4Tw6e9HmdQdt6i9dJ0lwMsHi/gKkh8Ww1lIWuLXtcWQmN8JRUzSoH0Lqwe
         6YnhgRAtenjD87+QXtEqvlL6dvhN1cwtk5qSvfOwZZy/pN3Yo9P0s781YWs2BE8oozsm
         61fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=l60jWrvXFLVlPq9d3zDJ2MhW7oGs+fbSrMuq9s9CgZg=;
        b=af57MqGnBg+ZiZXKFYIMMzvV0jF1I51umMbSYIEvtq9f11aRLNe+fbRir9WjDOUN8U
         AEU5OA01C7iT2aeXUn9KCbqCRgukbLJoekSYG87PY/JlUf/oxtYcHc0XY1NGyXshxiu2
         CqunODhG3oIsf9eavM4Htt7T1fAxseP+dGV7xvwNorcVzWdSRoqbGYxDaNcaPI3ykTYk
         vJjo89TLjgS9iVHEQjDTEZYxvLNtlgNvNbvVgcSVr16V7LSXGLCmy75FH04puVyqH31h
         425QXOkdWnUEbZlMOaYxI+dBcCtZs4DtKvHvVfkERXOBPkJnX1UR6bRHi6YFKN8PGaXI
         /rTw==
X-Gm-Message-State: ACgBeo1rQDXll5eoV5GOnyV3euNwL2TsrWG9B9DeT54dyFjQzFAqU10D
        gbr9qNjff9yOBAiDrp7JV8KVC6Qp5czX+g==
X-Google-Smtp-Source: AA6agR4Ve/X84141oui0wI1gWlO17d+J53KnzBvefiBI4P2AAMsXv2LQX9g2yZRO93bDV2PnhVERSxzT4z3uJQ==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a05:6a00:b86:b0:53a:8a00:6ecb with SMTP
 id g6-20020a056a000b8600b0053a8a006ecbmr11438160pfj.56.1662684610137; Thu, 08
 Sep 2022 17:50:10 -0700 (PDT)
Date:   Fri,  9 Sep 2022 00:49:41 +0000
In-Reply-To: <cover.1662682323.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662682323.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <086b227c1b97f4e94193e58aae7576d0261b68a4.1662682323.git.zhuyifei@google.com>
Subject: [PATCH v4 bpf-next 3/3] selftests/bpf: Ensure cgroup/connect{4,6}
 programs can bind unpriv ICMP ping
From:   YiFei Zhu <zhuyifei@google.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This tests that when an unprivileged ICMP ping socket connects,
the hooks are actually invoked. We also ensure that if the hook does
not call bpf_bind(), the bound address is unmodified, and if the
hook calls bpf_bind(), the bound address is exactly what we provided
to the helper.

A new netns is used to enable ping_group_range in the test without
affecting ouside of the test, because by default, not even root is
permitted to use unprivileged ICMP ping...

Signed-off-by: YiFei Zhu <zhuyifei@google.com>
---
 .../selftests/bpf/prog_tests/connect_ping.c   | 178 ++++++++++++++++++
 .../selftests/bpf/progs/connect_ping.c        |  53 ++++++
 2 files changed, 231 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c

diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
new file mode 100644
index 0000000000000..289218c2216c3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright 2022 Google LLC.
+ */
+
+#define _GNU_SOURCE
+#include <sys/mount.h>
+
+#include "test_progs.h"
+#include "cgroup_helpers.h"
+#include "network_helpers.h"
+
+#include "connect_ping.skel.h"
+
+/* 2001:db8::1 */
+#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
+static const struct in6_addr bindaddr_v6 = BINDADDR_V6;
+
+static void subtest(int cgroup_fd, struct connect_ping *skel,
+		    int family, int do_bind)
+{
+	struct sockaddr_in sa4 = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	struct sockaddr_in6 sa6 = {
+		.sin6_family = AF_INET6,
+		.sin6_addr = IN6ADDR_LOOPBACK_INIT,
+	};
+	struct sockaddr *sa;
+	socklen_t sa_len;
+	int protocol;
+	int sock_fd;
+
+	switch (family) {
+	case AF_INET:
+		sa = (struct sockaddr *)&sa4;
+		sa_len = sizeof(sa4);
+		protocol = IPPROTO_ICMP;
+		break;
+	case AF_INET6:
+		sa = (struct sockaddr *)&sa6;
+		sa_len = sizeof(sa6);
+		protocol = IPPROTO_ICMPV6;
+		break;
+	}
+
+	memset(skel->bss, 0, sizeof(*skel->bss));
+	skel->bss->do_bind = do_bind;
+
+	sock_fd = socket(family, SOCK_DGRAM, protocol);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	if (!ASSERT_OK(connect(sock_fd, sa, sa_len), "connect"))
+		goto close_sock;
+
+	if (!ASSERT_EQ(skel->bss->invocations_v4, family == AF_INET ? 1 : 0,
+		       "invocations_v4"))
+		goto close_sock;
+	if (!ASSERT_EQ(skel->bss->invocations_v6, family == AF_INET6 ? 1 : 0,
+		       "invocations_v6"))
+		goto close_sock;
+	if (!ASSERT_EQ(skel->bss->has_error, 0, "has_error"))
+		goto close_sock;
+
+	if (!ASSERT_OK(getsockname(sock_fd, sa, &sa_len),
+		       "getsockname"))
+		goto close_sock;
+
+	switch (family) {
+	case AF_INET:
+		if (!ASSERT_EQ(sa4.sin_family, family, "sin_family"))
+			goto close_sock;
+		if (!ASSERT_EQ(sa4.sin_addr.s_addr,
+			       htonl(do_bind ? 0x01010101 : INADDR_LOOPBACK),
+			       "sin_addr"))
+			goto close_sock;
+		break;
+	case AF_INET6:
+		if (!ASSERT_EQ(sa6.sin6_family, AF_INET6, "sin6_family"))
+			goto close_sock;
+		if (!ASSERT_EQ(memcmp(&sa6.sin6_addr,
+				      do_bind ? &bindaddr_v6 : &in6addr_loopback,
+				      sizeof(sa6.sin6_addr)),
+			       0, "sin6_addr"))
+			goto close_sock;
+		break;
+	}
+
+close_sock:
+	close(sock_fd);
+}
+
+void test_connect_ping(void)
+{
+	struct connect_ping *skel;
+	int cgroup_fd;
+
+	if (!ASSERT_OK(unshare(CLONE_NEWNET | CLONE_NEWNS), "unshare"))
+		return;
+
+	/* overmount sysfs, and making original sysfs private so overmount
+	 * does not propagate to other mntns.
+	 */
+	if (!ASSERT_OK(mount("none", "/sys", NULL, MS_PRIVATE, NULL),
+		       "remount-private-sys"))
+		return;
+	if (!ASSERT_OK(mount("sysfs", "/sys", "sysfs", 0, NULL),
+		       "mount-sys"))
+		return;
+	if (!ASSERT_OK(mount("bpffs", "/sys/fs/bpf", "bpf", 0, NULL),
+		       "mount-bpf"))
+		goto clean_mount;
+
+	if (!ASSERT_OK(system("ip link set dev lo up"), "lo-up"))
+		goto clean_mount;
+	if (!ASSERT_OK(system("ip addr add 1.1.1.1 dev lo"), "lo-addr-v4"))
+		goto clean_mount;
+	if (!ASSERT_OK(system("ip -6 addr add 2001:db8::1 dev lo"), "lo-addr-v6"))
+		goto clean_mount;
+	if (write_sysctl("/proc/sys/net/ipv4/ping_group_range", "0 0"))
+		goto clean_mount;
+
+	cgroup_fd = test__join_cgroup("/connect_ping");
+	if (!ASSERT_GE(cgroup_fd, 0, "cg-create"))
+		goto clean_mount;
+
+	skel = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel-load"))
+		goto close_cgroup;
+	skel->links.connect_v4_prog =
+		bpf_program__attach_cgroup(skel->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.connect_v4_prog, "cg-attach-v4"))
+		goto skel_destroy;
+	skel->links.connect_v6_prog =
+		bpf_program__attach_cgroup(skel->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.connect_v6_prog, "cg-attach-v6"))
+		goto skel_destroy;
+
+	/* Connect a v4 ping socket to localhost, assert that only v4 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * original loopback address.
+	 */
+	if (test__start_subtest("ipv4"))
+		subtest(cgroup_fd, skel, AF_INET, 0);
+
+	/* Connect a v4 ping socket to localhost, assert that only v4 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * address we explicitly bound.
+	 */
+	if (test__start_subtest("ipv4-bind"))
+		subtest(cgroup_fd, skel, AF_INET, 1);
+
+	/* Connect a v6 ping socket to localhost, assert that only v6 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * original loopback address.
+	 */
+	if (test__start_subtest("ipv6"))
+		subtest(cgroup_fd, skel, AF_INET6, 0);
+
+	/* Connect a v6 ping socket to localhost, assert that only v6 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * address we explicitly bound.
+	 */
+	if (test__start_subtest("ipv6-bind"))
+		subtest(cgroup_fd, skel, AF_INET6, 1);
+
+skel_destroy:
+	connect_ping__destroy(skel);
+
+close_cgroup:
+	close(cgroup_fd);
+
+clean_mount:
+	umount2("/sys", MNT_DETACH);
+}
diff --git a/tools/testing/selftests/bpf/progs/connect_ping.c b/tools/testing/selftests/bpf/progs/connect_ping.c
new file mode 100644
index 0000000000000..60178192b672f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/connect_ping.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright 2022 Google LLC.
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <netinet/in.h>
+#include <sys/socket.h>
+
+/* 2001:db8::1 */
+#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
+
+__u32 do_bind = 0;
+__u32 has_error = 0;
+__u32 invocations_v4 = 0;
+__u32 invocations_v6 = 0;
+
+SEC("cgroup/connect4")
+int connect_v4_prog(struct bpf_sock_addr *ctx)
+{
+	struct sockaddr_in sa = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = bpf_htonl(0x01010101),
+	};
+
+	__sync_fetch_and_add(&invocations_v4, 1);
+
+	if (do_bind && bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)))
+		has_error = 1;
+
+	return 1;
+}
+
+SEC("cgroup/connect6")
+int connect_v6_prog(struct bpf_sock_addr *ctx)
+{
+	struct sockaddr_in6 sa = {
+		.sin6_family = AF_INET6,
+		.sin6_addr = BINDADDR_V6,
+	};
+
+	__sync_fetch_and_add(&invocations_v6, 1);
+
+	if (do_bind && bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)))
+		has_error = 1;
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.37.2.789.g6183377224-goog

