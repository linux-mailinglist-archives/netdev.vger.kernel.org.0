Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576C1304D8F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbhAZXLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392844AbhAZTgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 14:36:32 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BEC0C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 11:35:49 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id o3so2579944pju.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 11:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=EOwlqpap9lM6pVbUtpntehXhvUdwez9yCbIIGvVOzsU=;
        b=ifxzNPN6vHIr7JcrxL6QbjrdehtaIPfPzYbPD5/3pbHaSSZ8jNktJEq1tb/BAx/bzw
         NQU3BkQr5IJWTUQxc4s6KkK9Ikn1dbr9S6ZHAb7IDmnwmTxH/be7h4A9smiV6bFLWIlu
         ouPAgNps2DbWCFVe69eR5kuazoxdjtvABmo0ipMEPEp/dcKWZ5LOyr+bXyWDzK+I9cvy
         IexRYIOt7PPIBkApaIDk9V3CN4cfRRqnhQ8eMzZ1aLfdunj3U1hZJIHRAtZLpObKTE9R
         AIoVYOkHMmLXbrl+SPzEhw/Qn2I4xR112uu0xLy6VSWp9lR1+mA12ETXfzvIELUE79IM
         dqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EOwlqpap9lM6pVbUtpntehXhvUdwez9yCbIIGvVOzsU=;
        b=JN6n+wGvkBSM5U20sOXm+RJV6FaaK9IjsbNcaCbyJw5PwFHvcN5Dr798fdQBwEsb+9
         cctlxsjJsD8CSeA5HJlBhSzkiIzCi1q3X4jX7PRfxjmT66agxvl6UZA6pZU0i5rUgbyJ
         lqEfREEj0lXQGO1U07SPn+d642TgpDSV9Ax5EuWYSy93GV1fzLeXgruyZxFdElxw7ZtK
         gKkc1DH17W7dYug1jxY7q1l0i7w9yf4Se7mEQGLxN4RCpPcCZK4c9jPCDtb08b7iMZ7C
         pkgGcwinehIxm0FsLkWvVSuTEenIBiZdhgQ1AiWEj0SCC3JAYOg5kT1UTCk3h/lS8sTu
         HtUg==
X-Gm-Message-State: AOAM530tTOQg6XQ1Ls1EF6yiVunGgkUjfxZnCEsBNqmfWv8XApvTDKRe
        eKlpF+NdD7mdnZnXHT5l781xasPpxB2c5QhBQ4SETlLDy6sRK9kx1+dZszWh6nhf0doc0VNaPBr
        h27wQYIJ+36OrsIZnvPA0SkooE98oV83Do5lgWr52IeYwfWihfEJwMg==
X-Google-Smtp-Source: ABdhPJxkoFOmjsuMAAJqLAb+PhE1s6J48ZMwrTCn3FiZ34yxEUKpJcGT9Nfw4w/TLFdyIuQM3fDhcjk=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a62:a204:0:b029:1c2:8442:e7bf with SMTP id
 m4-20020a62a2040000b02901c28442e7bfmr6324424pff.58.1611689748660; Tue, 26 Jan
 2021 11:35:48 -0800 (PST)
Date:   Tue, 26 Jan 2021 11:35:44 -0800
In-Reply-To: <20210126193544.1548503-1-sdf@google.com>
Message-Id: <20210126193544.1548503-2-sdf@google.com>
Mime-Version: 1.0
References: <20210126193544.1548503-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v4 2/2] selftests/bpf: verify that rebinding to port
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
Cc: Martin KaFai Lau <kafai@fb.com>
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

