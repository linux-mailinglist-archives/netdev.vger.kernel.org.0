Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAEC5B2A0A
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiIHXQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiIHXQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:16:26 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8013BBFA9B
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 16:16:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id v18-20020a17090a899200b00200a2c60f3aso2181767pjn.5
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 16:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=zz2v3pzyW66Zc+jXSlJ3rYl7T0V9QeWpVe+1jRgrufI=;
        b=CZX2YHZLbbFRnW9OQGvTh/rA0bFixDp/yBQHj6ZJy+QOrxd59lhX1Avhn8LCclixYO
         +UUtiKcmQLK3LHaNz57Fpkff97HWMxqojScqf6LuW1IHZ++AMaOw3YTqw7FQAtnrkfYa
         sAusItMaYRsGAiZY7g3jN3v+Da/rL9Bvk6+FIvq31BkGBtzY4EG20qJl5SbboGVRVTIX
         9epQcuMYqK+wLdNAJ2b14Eyeyj9mLqLhJVRXw0YLYgly1p2SAqXtUjVm0bH801KNOC32
         9twNeIZCPdAFSo4+GkhL68WFhpbL4BCew7l9K4PS+BxCx+nbVq9vriRnaDMO47ccuYkB
         qm0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=zz2v3pzyW66Zc+jXSlJ3rYl7T0V9QeWpVe+1jRgrufI=;
        b=QBhRrtOB9cNkzJ1+X2uP5E91grC1JdrjYrNjlHluut63kO4UXOXV/jMxzqfNc4BMi9
         R9LGA1s7NW5qtZSAIM0SkoCVeHRAUlabWChFSDOSwYNuVycZ8Kepl7W3ZbUShgmcOYqu
         G1iD6FwPOI32WgQZayr4xKoSBDIWKfQQzKsEsHySgjtXF2RR/vNYWLj1xmm5vfwan11x
         MIh6QomLeAesNM5VOPX4RWvwFbeqquolaLq6VwIzVWvLfxgjYHa08EWpaHzlSq5dNrR0
         aIQkga0UwtAWsYl+G9G0xdQHPOTEhh9K29bWefM1zyxK2jFAx2IN82jJTHecq85ASImk
         FI3Q==
X-Gm-Message-State: ACgBeo3vlwPzNc69oORSrgyM3mpgdX7Y9aRj39KVkNgu53gaj0c5LBxM
        yofWLXIguWb/g2vYuFI2BR4bkxhceh0B4g==
X-Google-Smtp-Source: AA6agR4TdA08QvC9IGKZrcEjFSK70ESxgvUO89Qg3kj8UleIA7bTCCyD0uc0soqY00KgFl0qfqBJUqA67EgCJA==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:902:c40f:b0:175:3c1e:8493 with SMTP
 id k15-20020a170902c40f00b001753c1e8493mr10565484plk.19.1662678983902; Thu,
 08 Sep 2022 16:16:23 -0700 (PDT)
Date:   Thu,  8 Sep 2022 23:16:15 +0000
In-Reply-To: <cover.1662678623.git.zhuyifei@google.com>
Mime-Version: 1.0
References: <cover.1662678623.git.zhuyifei@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <97288b66a44c984cb5514ca7390ca0cf9c30275f.1662678623.git.zhuyifei@google.com>
Subject: [PATCH v3 bpf-next 3/3] selftests/bpf: Ensure cgroup/connect{4,6}
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
index 0000000000000..e6031e060feae
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
+		goto close_cgroup;
+	skel->links.connect_v6_prog =
+		bpf_program__attach_cgroup(skel->progs.connect_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.connect_v6_prog, "cg-attach-v6"))
+		goto close_cgroup;
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

