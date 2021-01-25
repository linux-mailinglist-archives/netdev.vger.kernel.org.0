Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984423028D5
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 18:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbhAYR1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 12:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730986AbhAYR11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 12:27:27 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DACC061793
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 09:26:46 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id j78so3584897qke.11
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 09:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=j8AGqnKKRD78l3wBrmQ20U2ERtehVbx66klZw1aS8fw=;
        b=CYdJpeBXtcYzpG1EjpK+dBGBDj+xhl20ZjSiYVDFHBTlY4nlS+e0K1phYbyyZbQUC+
         DL7fceLgw58RvyP4L4g4gVzNPblbgIiUoCac0qJ1VawigxJb0yHTnL3sWbtnloPD6WP4
         DRFUNqCYiN/DADEU/BK/EGExbqUtqAwLTVFyYa8V4tMKM2AnrgCly4TTgeR8IGDBcg07
         di5vJ/uZ89eP5+5bTkq5MyzZ/cANuNlPYfxHpiZR8FjeolicGlwQ9ARTXGcsB7qXwppM
         nifKj2Ag5BZ/czT3M49R5966gT8kdLqsH3HKjc8cXSxONiELwF5gu0VSLxWzXifKdgp9
         vs4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j8AGqnKKRD78l3wBrmQ20U2ERtehVbx66klZw1aS8fw=;
        b=ddx6sTlD+/fDHR1XJgOK7smHWh0b15g9QS/AIYEGeXijLo1iGALUiYMRPLCpYcaMDD
         WWUeZjB6TG0gXE90eNLzcHbJnWHorSWqwxa6Bzfj/WyCICQJoRt4LNoQ/gn9JF7vlsog
         sLpFAzLs7zfm8EoTuHibZdY3hYxdSP2tgSEN1xY96cHlC2myP7ZND5pVNhTSPYFgCgKz
         DZhUUfSBV/BXyzWLe1ApcKId9H0NWs1TD7D/UNo5Rm8a1pFBBNwREccPDwwKcG0WKB9S
         bQiV/AHM5u9XLtm48HU3eqKSn7O1SoM6wyPh21OyGYOEf5YjcJK1HcpDMj4GtFZlcDOQ
         fiHA==
X-Gm-Message-State: AOAM531ZjBnqmu+4UB999hySUkxF287CEm/ek9Ch/bkpAcv3VYt+ARkU
        Xm9YCkB5bRxyntX9sJ3cHM+40fA0/WMaBpIvPoL2IG9qElIE13XyxaLtdGG8GCQPHh5eVtKIeCk
        7MV+D33utMJmXYpf54LwKgDQ57vaqK3vKN4WLmiVXUx5ogKqtjgU1vA==
X-Google-Smtp-Source: ABdhPJwLb8Rlc6AkymUL6JDDLL3heBNAIulj1bPeZB0401yriLCGiKY9Xh59QwS+QVmdBo9z7IfEw2o=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:fd68:: with SMTP id k8mr1746663qvs.56.1611595605132;
 Mon, 25 Jan 2021 09:26:45 -0800 (PST)
Date:   Mon, 25 Jan 2021 09:26:41 -0800
In-Reply-To: <20210125172641.3008234-1-sdf@google.com>
Message-Id: <20210125172641.3008234-2-sdf@google.com>
Mime-Version: 1.0
References: <20210125172641.3008234-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: verify that rebinding to port
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

BPF rewrites from 111 to 111, but it still should mark the port as
"changed".
We also verify that if port isn't touched by BPF, it's still prohibited.

Cc: Andrey Ignatov <rdna@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bind_perm.c      | 85 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
new file mode 100644
index 000000000000..61307d4494bf
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
@@ -0,0 +1,85 @@
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
+void try_bind(int port, int expected_errno)
+{
+	struct sockaddr_in sin = {};
+	int fd = -1;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	if (CHECK(fd < 0, "fd", "errno %d", errno))
+		goto close_socket;
+
+	sin.sin_family = AF_INET;
+	sin.sin_port = htons(port);
+
+	errno = 0;
+	bind(fd, (struct sockaddr *)&sin, sizeof(sin));
+	ASSERT_EQ(errno, expected_errno, "bind");
+
+close_socket:
+	if (fd >= 0)
+		close(fd);
+}
+
+void cap_net_bind_service(cap_flag_value_t flag)
+{
+	const cap_value_t cap_net_bind_service = CAP_NET_BIND_SERVICE;
+	cap_t caps;
+
+	caps = cap_get_proc();
+	if (CHECK(!caps, "cap_get_proc", "errno %d", errno))
+		goto free_caps;
+
+	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
+			       CAP_CLEAR),
+		  "cap_set_flag", "errno %d", errno))
+		goto free_caps;
+
+	if (CHECK(cap_set_flag(caps, CAP_EFFECTIVE, 1, &cap_net_bind_service,
+			       CAP_CLEAR),
+		  "cap_set_flag", "errno %d", errno))
+		goto free_caps;
+
+	if (CHECK(cap_set_proc(caps), "cap_set_proc", "errno %d", errno))
+		goto free_caps;
+
+free_caps:
+	if (CHECK(cap_free(caps), "cap_free", "errno %d", errno))
+		goto free_caps;
+}
+
+void test_bind_perm(void)
+{
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
+	cap_net_bind_service(CAP_CLEAR);
+	try_bind(110, EACCES);
+	try_bind(111, 0);
+	cap_net_bind_service(CAP_SET);
+
+close_skeleton:
+	bind_perm__destroy(skel);
+close_cgroup_fd:
+	close(cgroup_fd);
+}
diff --git a/tools/testing/selftests/bpf/progs/bind_perm.c b/tools/testing/selftests/bpf/progs/bind_perm.c
new file mode 100644
index 000000000000..31ae8d599796
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bind_perm.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/stddef.h>
+#include <linux/bpf.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+SEC("cgroup/bind4")
+int bind_v4_prog(struct bpf_sock_addr *ctx)
+{
+	struct bpf_sock *sk;
+	__u32 user_ip4;
+	__u16 user_port;
+
+	sk = ctx->sk;
+	if (!sk)
+		return 0;
+
+	if (sk->family != AF_INET)
+		return 0;
+
+	if (ctx->type != SOCK_STREAM)
+		return 0;
+
+	/* Rewriting to the same value should still cause
+	 * permission check to be bypassed.
+	 */
+	if (ctx->user_port == bpf_htons(111))
+		return 3;
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.0.280.ga3ce27912f-goog

