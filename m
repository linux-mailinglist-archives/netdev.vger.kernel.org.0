Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276D65A9FB4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiIATQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233795AbiIATQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:16:05 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09477171E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 12:16:02 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id b9-20020a170902d50900b0016f0342a417so12446617plg.21
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 12:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=Bic35k9dElF50i4dfCFgWlyOqNUMm3ISBvJbzzjsYG8=;
        b=FGKfq35lE3MJPpEIbeb1CS+mz9M/PfcyI4YGfavgOBjBNB4pIm38pk9UKNyAI/jObY
         P4RH17apslK6TK7dYo4laV7X9Cr2SLFL5AdVA3gJG7ef0FpsFhymvp0KyP6LKx+tRcm5
         BwYvta4GzH+zc3ql4FrnzHP/GqUrHaIuXRr/Dkckf62wWQteqlq1AyFPkHsn57eplb0R
         ldKHWw4udQI9OEMPIEwkupMK9qy9NMUJlLkjQLPrXYbA4unamgo84LXXMqVKaw7uH/lt
         412qWP++wFmharTedQs5P/Rjhj5P8h+ZNflqBrmwbCVFuSQGzOsrlCU+x5joJvVFvbTV
         emAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=Bic35k9dElF50i4dfCFgWlyOqNUMm3ISBvJbzzjsYG8=;
        b=xZndoGVWs74ykeRQTfks9BJYaHb9BQo9rtdIvQWZ48Qn7wpEIiWycRPW/43YCmeqcY
         wmKv7swcltpEheuy3ki7N0spv18STl1AETXLMBn1Iyyb7cKeVdZEJ8nOc892NRo3MthX
         ArIRdipdMp+aMb7E+lyph3l1eYRq2CoVbO4Kl+pgN/wyopOQQCqRuCJm6iAuvsIVbX9p
         s72pgYwLnbd3F5+Kff/9CDIQDmpm3jOGPn2P4Fq/WX8PKa3URWX7i05krtBVSyh3sSdV
         GglBayI59rvQIs48ri2pAFscLa+JPvrgAvIwIysexQ1Pe408uoY1TDNqg0zmzVZbAqcx
         bMng==
X-Gm-Message-State: ACgBeo1MWTZ31OuADk4il/EDPQh7hSMUncOh1D9MzNtHGJLiky9aVkP8
        5IJAaJreb4jChfnoEngHKp/j3rdmKpkt8w==
X-Google-Smtp-Source: AA6agR5N36mKt8I1og54kXTx8VzbwWWNva/uS9XxEvrNjwQ4t1WWS3NKYlR6H7N73HpvDeDI71/ks52q7gWTZg==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:90a:930b:b0:1ed:5441:1fff with SMTP
 id p11-20020a17090a930b00b001ed54411fffmr660985pjo.238.1662059762264; Thu, 01
 Sep 2022 12:16:02 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:15:10 +0000
In-Reply-To: <cover.1662058674.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662058674.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <345fbce9b67e4f287a771c497e8bd1bccff50b58.1662058674.git.zhuyifei@google.com>
Subject: [PATCH bpf-next 2/2] selftests/bpf: Ensure cgroup/connect{4,6}
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
 .../selftests/bpf/prog_tests/connect_ping.c   | 318 ++++++++++++++++++
 .../selftests/bpf/progs/connect_ping.c        |  53 +++
 2 files changed, 371 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c

diff --git a/tools/testing/selftests/bpf/prog_tests/connect_ping.c b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
new file mode 100644
index 0000000000000..99b1a2f0c4921
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/connect_ping.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+/*
+ * Copyright 2022 Google LLC.
+ */
+
+#define _GNU_SOURCE
+#include <sys/mount.h>
+
+#include <test_progs.h>
+#include <cgroup_helpers.h>
+#include <network_helpers.h>
+
+#include "connect_ping.skel.h"
+
+/* 2001:db8::1 */
+#define BINDADDR_V6 { { { 0x20,0x01,0x0d,0xb8,0,0,0,0,0,0,0,0,0,0,0,1 } } }
+const struct in6_addr bindaddr_v6 = BINDADDR_V6;
+
+static bool write_sysctl(const char *sysctl, const char *value)
+{
+	int fd, err, len;
+
+	fd = open(sysctl, O_WRONLY);
+	if (!ASSERT_GE(fd, 0, "open-sysctl"))
+		return false;
+
+	len = strlen(value);
+	err = write(fd, value, len);
+	close(fd);
+	if (!ASSERT_EQ(err, len, "write-sysctl"))
+		return false;
+
+	return true;
+}
+
+static void test_ipv4(int cgroup_fd)
+{
+	struct sockaddr_in sa = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	socklen_t sa_len = sizeof(sa);
+	struct connect_ping *obj;
+	int sock_fd;
+
+	sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	obj = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "skel-load"))
+		goto close_sock;
+
+	obj->bss->do_bind = 0;
+
+	/* Attach connect v4 and connect v6 progs, connect a v4 ping socket to
+	 * localhost, assert that only v4 is called, and called exactly once,
+	 * and that the socket's bound address is original loopback address.
+	 */
+	obj->links.connect_v4_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
+		goto close_bpf_object;
+	obj->links.connect_v6_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(connect(sock_fd, (struct sockaddr *)&sa, sa_len),
+		       "connect"))
+		goto close_bpf_object;
+
+	if (!ASSERT_EQ(obj->bss->invocations_v4, 1, "invocations_v4"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->invocations_v6, 0, "invocations_v6"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->has_error, 0, "has_error"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(getsockname(sock_fd, (struct sockaddr *)&sa, &sa_len),
+		       "getsockname"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin_family, AF_INET, "sin_family"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin_addr.s_addr, htonl(INADDR_LOOPBACK), "sin_addr"))
+		goto close_bpf_object;
+
+close_bpf_object:
+	connect_ping__destroy(obj);
+close_sock:
+	close(sock_fd);
+}
+
+static void test_ipv4_bind(int cgroup_fd)
+{
+	struct sockaddr_in sa = {
+		.sin_family = AF_INET,
+		.sin_addr.s_addr = htonl(INADDR_LOOPBACK),
+	};
+	socklen_t sa_len = sizeof(sa);
+	struct connect_ping *obj;
+	int sock_fd;
+
+	sock_fd = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	obj = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "skel-load"))
+		goto close_sock;
+
+	obj->bss->do_bind = 1;
+
+	/* Attach connect v4 and connect v6 progs, connect a v4 ping socket to
+	 * localhost, assert that only v4 is called, and called exactly once,
+	 * and that the socket's bound address is address we explicitly bound.
+	 */
+	obj->links.connect_v4_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
+		goto close_bpf_object;
+	obj->links.connect_v6_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(connect(sock_fd, (struct sockaddr *)&sa, sa_len),
+		       "connect"))
+		goto close_bpf_object;
+
+	if (!ASSERT_EQ(obj->bss->invocations_v4, 1, "invocations_v4"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->invocations_v6, 0, "invocations_v6"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->has_error, 0, "has_error"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(getsockname(sock_fd, (struct sockaddr *)&sa, &sa_len),
+		       "getsockname"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin_family, AF_INET, "sin_family"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin_addr.s_addr, htonl(0x01010101), "sin_addr"))
+		goto close_bpf_object;
+
+close_bpf_object:
+	connect_ping__destroy(obj);
+close_sock:
+	close(sock_fd);
+}
+
+static void test_ipv6(int cgroup_fd)
+{
+	struct sockaddr_in6 sa = {
+		.sin6_family = AF_INET6,
+		.sin6_addr = IN6ADDR_LOOPBACK_INIT,
+	};
+	socklen_t sa_len = sizeof(sa);
+	struct connect_ping *obj;
+	int sock_fd;
+
+	sock_fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	obj = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "skel-load"))
+		goto close_sock;
+
+	obj->bss->do_bind = 0;
+
+	/* Attach connect v4 and connect v6 progs, connect a v6 ping socket to
+	 * localhost, assert that only v6 is called, and called exactly once,
+	 * and that the socket's bound address is original loopback address.
+	 */
+	obj->links.connect_v4_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
+		goto close_bpf_object;
+	obj->links.connect_v6_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(connect(sock_fd, (struct sockaddr *)&sa, sa_len),
+		       "connect"))
+		goto close_bpf_object;
+
+	if (!ASSERT_EQ(obj->bss->invocations_v4, 0, "invocations_v4"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->invocations_v6, 1, "invocations_v6"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->has_error, 0, "has_error"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(getsockname(sock_fd, (struct sockaddr *)&sa, &sa_len),
+		       "getsockname"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin6_family, AF_INET6, "sin6_family"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(memcmp(&sa.sin6_addr, &in6addr_loopback, sizeof(in6addr_loopback)),
+		       0, "sin_addr"))
+		goto close_bpf_object;
+
+close_bpf_object:
+	connect_ping__destroy(obj);
+close_sock:
+	close(sock_fd);
+}
+
+static void test_ipv6_bind(int cgroup_fd)
+{
+	struct sockaddr_in6 sa = {
+		.sin6_family = AF_INET6,
+		.sin6_addr = IN6ADDR_LOOPBACK_INIT,
+	};
+	socklen_t sa_len = sizeof(sa);
+	struct connect_ping *obj;
+	int sock_fd;
+
+	sock_fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6);
+	if (!ASSERT_GE(sock_fd, 0, "sock-create"))
+		return;
+
+	obj = connect_ping__open_and_load();
+	if (!ASSERT_OK_PTR(obj, "skel-load"))
+		goto close_sock;
+
+	obj->bss->do_bind = 1;
+
+	/* Attach connect v4 and connect v6 progs, connect a v6 ping socket to
+	 * localhost, assert that only v6 is called, and called exactly once,
+	 * and that the socket's bound address is address we explicitly bound.
+	 */
+	obj->links.connect_v4_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v4_prog, "cg-attach-v4"))
+		goto close_bpf_object;
+	obj->links.connect_v6_prog =
+		bpf_program__attach_cgroup(obj->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(obj->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(connect(sock_fd, (struct sockaddr *)&sa, sa_len),
+		       "connect"))
+		goto close_bpf_object;
+
+	if (!ASSERT_EQ(obj->bss->invocations_v4, 0, "invocations_v4"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->invocations_v6, 1, "invocations_v6"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(obj->bss->has_error, 0, "has_error"))
+		goto close_bpf_object;
+
+	if (!ASSERT_OK(getsockname(sock_fd, (struct sockaddr *)&sa, &sa_len),
+		       "getsockname"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(sa.sin6_family, AF_INET6, "sin6_family"))
+		goto close_bpf_object;
+	if (!ASSERT_EQ(memcmp(&sa.sin6_addr, &bindaddr_v6, sizeof(bindaddr_v6)),
+		       0, "sin_addr"))
+		goto close_bpf_object;
+
+close_bpf_object:
+	connect_ping__destroy(obj);
+close_sock:
+	close(sock_fd);
+}
+
+void test_connect_ping(void)
+{
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
+	if (!write_sysctl("/proc/sys/net/ipv4/ping_group_range", "0 0"))
+		goto clean_mount;
+
+	cgroup_fd = test__join_cgroup("/connect_ping");
+	if (!ASSERT_GE(cgroup_fd, 0, "cg-create"))
+		goto clean_mount;
+
+	if (test__start_subtest("ipv4"))
+		test_ipv4(cgroup_fd);
+	if (test__start_subtest("ipv4-bind"))
+		test_ipv4_bind(cgroup_fd);
+
+	if (test__start_subtest("ipv6"))
+		test_ipv6(cgroup_fd);
+	if (test__start_subtest("ipv6-bind"))
+		test_ipv6_bind(cgroup_fd);
+
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

