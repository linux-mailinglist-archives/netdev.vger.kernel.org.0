Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316715AF884
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 01:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiIFXtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 19:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiIFXtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 19:49:10 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC2D923E0
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 16:49:08 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id m188-20020a633fc5000000b00434dccacd4aso596072pga.10
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 16:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Cr4XROECByEa8+H/8TE3CUjlmvWQzQWyMK5Hotidfy8=;
        b=mLz3eXBkZ1XuKzuEFA1hCQ1f9P++LD+lzmRhH4LjBYOSNqZH08XdV+X/y9fKZTVOkW
         dK4CPoomGdobv8SUd8sEwb7QJ6iZyLVyAHTLOc8MW3SJB+pSKxzWgJ1aCy6HRmeX77OG
         AgX27x/0Q6GyyfJU6PbC+csskMiMnuUiGjSm2IPa0LGRffZDArGUoXpIW7JAr9zvRyUr
         i5TG0Q6CV5P1OqZb0+7Lc9lpr848YiWF3rkh5DLSXJMVjjzz4b7R2lXbEa45Wcq2VekV
         nqr0xFzjDENsp8D6PwY3El+vcQk+64o+Z1WFg2atB+l63eNVYJuC6+3/M8PZwEzVLn0T
         pFtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Cr4XROECByEa8+H/8TE3CUjlmvWQzQWyMK5Hotidfy8=;
        b=3Av4u5syodlYXfCfGGy8oOp5sSlS51sZZsmPiRhaYM0cENgQ5q/MH60VJrG1PIPA4I
         o2uXQ0K+jsy5MrDoQGaULruqTWgsmpqJrTvj+tf802MB+yIbD0tVs3zoxOS3hIAuNmi6
         MduwaFnueNgOcpuMLdaJNjskidRNZONP8oGCBLZXZtKOteZFoAbcAPSVRlud80m9it1+
         oNpSeQkBKWP9NN2fTgg4/0GUJ//kW7Vdvw2zvzpkvnq7Er5wrDjU5gz8twCK6ECJaEu9
         GcrfHK7ZAa3TI8hmtSJbCFDcAp72FruMTpJA8E+EcMLqrSnKkJ/E1GhoChggOdmWSmWA
         31Uw==
X-Gm-Message-State: ACgBeo3Z2voKBNG0XKSNUeVV4atxPpxJY7POQgCnmlgmkjXxax98tDK8
        ni5udEvxbjb5BWxOFhUQBk8Bxh2j5iyQww==
X-Google-Smtp-Source: AA6agR6k+WcO2e+K5KgqMFMpr8a2NQZ00auHeE1XstkBhADMtNbphhQB0G1jNVuH5N4Ls/Nlgp2QINA/qspwWg==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:90a:318f:b0:1fa:a374:f565 with SMTP
 id j15-20020a17090a318f00b001faa374f565mr27493354pjb.146.1662508148387; Tue,
 06 Sep 2022 16:49:08 -0700 (PDT)
Date:   Tue,  6 Sep 2022 23:48:48 +0000
In-Reply-To: <cover.1662507638.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662507638.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <892e0898c1255f980da13b0c7cc77cd5642edd36.1662507638.git.zhuyifei@google.com>
Subject: [PATCH v2 bpf-next 3/3] selftests/bpf: Ensure cgroup/connect{4,6}
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
 .../selftests/bpf/prog_tests/connect_ping.c   | 177 ++++++++++++++++++
 .../selftests/bpf/progs/connect_ping.c        |  53 ++++++
 2 files changed, 230 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c

diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
new file mode 100644
index 0000000000000..ba0812a06854e
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
@@ -0,0 +1,177 @@
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
+static void subtest(int cgroup_fd, struct connect_ping *obj,
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
+	memset(obj->bss, 0, sizeof(*obj->bss));
+	obj->bss->do_bind = do_bind;
+
+	sock_fd = socket(family, SOCK_DGRAM, protocol);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	if (!ASSERT_OK(connect(sock_fd, sa, sa_len), "connect"))
+		goto close_sock;
+
+	if (!ASSERT_EQ(obj->bss->invocations_v4, family == AF_INET ? 1 : 0,
+		       "invocations_v4"))
+		goto close_sock;
+	if (!ASSERT_EQ(obj->bss->invocations_v6, family == AF_INET6 ? 1 : 0,
+		       "invocations_v6"))
+		goto close_sock;
+	if (!ASSERT_EQ(obj->bss->has_error, 0, "has_error"))
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
+	struct connect_ping *obj;
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
+	obj = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "skel-load"))
+		goto close_cgroup;
+	obj->links.connect_v4_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
+		goto close_cgroup;
+	obj->links.connect_v6_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_cgroup;
+
+	/* Connect a v4 ping socket to localhost, assert that only v4 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * original loopback address.
+	 */
+	if (test__start_subtest("ipv4"))
+		subtest(cgroup_fd, obj, AF_INET, 0);
+
+	/* Connect a v4 ping socket to localhost, assert that only v4 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * address we explicitly bound.
+	 */
+	if (test__start_subtest("ipv4-bind"))
+		subtest(cgroup_fd, obj, AF_INET, 1);
+
+	/* Connect a v6 ping socket to localhost, assert that only v6 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * original loopback address.
+	 */
+	if (test__start_subtest("ipv6"))
+		subtest(cgroup_fd, obj, AF_INET6, 0);
+
+	/* Connect a v6 ping socket to localhost, assert that only v6 is called,
+	 * and called exactly once, and that the socket's bound address is
+	 * address we explicitly bound.
+	 */
+	if (test__start_subtest("ipv6-bind"))
+		subtest(cgroup_fd, obj, AF_INET6, 1);
+
+	connect_ping__destroy(obj);
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

