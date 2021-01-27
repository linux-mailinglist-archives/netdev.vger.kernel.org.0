Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F48306436
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344528AbhA0Tff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344432AbhA0Tci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 14:32:38 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB81C061794
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:31:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c12so3319772ybf.1
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 11:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=vkhj91r1P+m963xtgGo0Ujx+DIYZAI5Z6ahaJ7HW7Nk=;
        b=qwkOa3Rs7RduAXP+M9aOuB8IK/2yfrlaWr2KJbpwV40WBSoKeR4ZbZvmBBvsdvr6CR
         QOYDSCeQo9PTrBhH0ikBkEe/3HsAd3Q4pe8Vn4tgrhWZcsqTwe9OwGzou9g+UVkMi6+4
         Ikmp6ddFNHwAAjZ1zObuWFyjw4Xq7vvu80n2JJzFmp1VO4J5fziNlcJgCFIMrm+JMIoF
         jIqdlygJBrM1UonjuCS7j+X5kBTdqdDGPBeotlr7OlfjFh1VHgdXyFtJ46Dd8KmfHDV3
         7NtAE/dCOXu7mXm6t8aLrnYPUq1FO9olyfNbmuLoVyevvcKKPlngnUfwP3NwOaeMlkB/
         xmTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vkhj91r1P+m963xtgGo0Ujx+DIYZAI5Z6ahaJ7HW7Nk=;
        b=uPVCOBmEcLQj9h40JU8dWZPBvjT2tWyKmyNp3ELACTm9oBnqA0gPEPReRrbMQn3BAA
         2dzfQSwJqLh57s1Ncr+27SzZL3EVJqD+i12aPHO6Kle9stgP5WUSX3cgwcKFvx3TsrVE
         XOif/0tWO+6lZik5M2FYeRxVO/n6Mjm12kysJlSbkKTv2ejIDp8c0aS+lIBgRTKpdp4H
         RIc8cbSMD6zX1q6DxSlulIX5NxCZUr1R6b29kYMnOlHBCbvZGpRqJeST5Bzzz3jZgTM7
         pfOYqYJbGzGZyFU3jdUtNVdXsO1mryD2WZBBOuPA+4e6cPB5F6F/eeuHhIHZM+JIBAGL
         dHsw==
X-Gm-Message-State: AOAM531WcJlA+yQqlMAMPtJj/KaenNl4gbSv52+3KgwKBAMZWD6zLuna
        NGf777Ebq+SuckxA5kyjeCfad0xu/JXNMiAVtgVDUKhD8j7/zXxERttHzKi2YtyiYWSjRUbOL62
        prrMWPFSlxCulq8x94t3izwJeWLrGOmEjbuls99vquxl8b3JAlE/YHQ==
X-Google-Smtp-Source: ABdhPJw1RyoDdW6m6KPuK7/1e2JCOi/a7P0P1a6Q8h+apGN9WCFBVJaZMa+4P2QTSFPlqwQ/5cStv5o=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a25:29c1:: with SMTP id p184mr18405912ybp.34.1611775904207;
 Wed, 27 Jan 2021 11:31:44 -0800 (PST)
Date:   Wed, 27 Jan 2021 11:31:40 -0800
In-Reply-To: <20210127193140.3170382-1-sdf@google.com>
Message-Id: <20210127193140.3170382-2-sdf@google.com>
Mime-Version: 1.0
References: <20210127193140.3170382-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v5 2/2] selftests/bpf: verify that rebinding to port
 < 1024 from BPF works
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>, Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return 3 to indicate that permission check for port 111
should be skipped.

Cc: Andrey Ignatov <rdna@fb.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bind_perm.c      | 109 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bind_perm.c |  45 ++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
new file mode 100644
index 000000000000..d0f06e40c16d
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "bind_perm.skel.h"
+
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/capability.h>
+
+static int duration;
+
+void try_bind(int family, int port, int expected_errno)
+{
+	struct sockaddr_storage addr = {};
+	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
+	int fd = -1;
+
+	fd = socket(family, SOCK_STREAM, 0);
+	if (CHECK(fd < 0, "fd", "errno %d", errno))
+		goto close_socket;
+
+	if (family == AF_INET) {
+		sin = (struct sockaddr_in *)&addr;
+		sin->sin_family = family;
+		sin->sin_port = htons(port);
+	} else {
+		sin6 = (struct sockaddr_in6 *)&addr;
+		sin6->sin6_family = family;
+		sin6->sin6_port = htons(port);
+	}
+
+	errno = 0;
+	bind(fd, (struct sockaddr *)&addr, sizeof(addr));
+	ASSERT_EQ(errno, expected_errno, "bind");
+
+close_socket:
+	if (fd >= 0)
+		close(fd);
+}
+
+bool cap_net_bind_service(cap_flag_value_t flag)
+{
+	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
+	cap_flag_value_t original_value;
+	bool was_effective = false;
+	cap_t caps;
+
+	caps = cap_get_proc();
+	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
+		goto free_caps;
+
+	if (CHECK(cap_get_flag(caps, CAP_NET_BIND_SERVICE, CAP_EFFECTIVE,
+			       &original_value),
+		  "cap_get_flag", "errno %d", errno))
+		goto free_caps;
+
+	was_effective = (original_value == CAP_SET);
+
+	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
+			       flag),
+		  "cap_set_flag", "errno %d", errno))
+		goto free_caps;
+
+	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
+		goto free_caps;
+
+free_caps:
+	CHECK(cap_free(caps), "cap_free", "errno %d", errno);
+	return was_effective;
+}
+
+void test_bind_perm(void)
+{
+	bool cap_was_effective;
+	struct bind_perm *skel;
+	int cgroup_fd;
+
+	cgroup_fd = test__join_cgroup("/bind_perm");
+	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
+		return;
+
+	skel = bind_perm__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel"))
+		goto close_cgroup_fd;
+
+	skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel, "bind_v4_prog"))
+		goto close_skeleton;
+
+	skel->links.bind_v6_prog = bpf_program__attach_cgroup(skel->progs.bind_v6_prog, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel, "bind_v6_prog"))
+		goto close_skeleton;
+
+	cap_was_effective = cap_net_bind_service(CAP_CLEAR);
+
+	try_bind(AF_INET, 110, EACCES);
+	try_bind(AF_INET6, 110, EACCES);
+
+	try_bind(AF_INET, 111, 0);
+	try_bind(AF_INET6, 111, 0);
+
+	if (cap_was_effective)
+		cap_net_bind_service(CAP_SET);
+
+close_skeleton:
+	bind_perm__destroy(skel);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c b/tools/testing/selftests/bpf/progs/bind_perm.c
new file mode 100644
index 000000000000..7bd2a027025d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind_perm.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+static __always_inline int bind_prog(struct bpf_sock_addr *ctx, int family)
+{
+	struct bpf_sock *sk;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 0;
+
+	if (sk->family != family)
+		return 0;
+
+	if (ctx->type != SOCK_STREAM)
+		return 0;
+
+	/* Return 1 OR'ed with the first bit set to indicate
+	 * that CAP_NET_BIND_SERVICE should be bypassed.
+	 */
+	if (ctx->user_port == bpf_htons(111))
+		return (1 | 2);
+
+	return 1;
+}
+
+SEC("cgroup/bind4")
+int bind_v4_prog(struct bpf_sock_addr *ctx)
+{
+	return bind_prog(ctx, AF_INET);
+}
+
+SEC("cgroup/bind6")
+int bind_v6_prog(struct bpf_sock_addr *ctx)
+{
+	return bind_prog(ctx, AF_INET6);
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.0.280.ga3ce27912f-goog

