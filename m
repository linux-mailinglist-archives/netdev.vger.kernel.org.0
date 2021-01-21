Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BBB2FDF10
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 02:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392672AbhAUBsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 20:48:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391700AbhAUBX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 20:23:26 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2FBC0613D3
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:22:46 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id g26so444130qkk.13
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 17:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=gTVMtyfMIqk/Qcfg0DT+LOQqnLSo6iYSNatYMrKII8w=;
        b=X+vaZ6GyPp6opRMiTuxQgAsJNP3bDWghgCpiSGlpchP4lavl4VMTIjwUlJX/OwQejR
         RApWwqIIPxCOkk1KS8ThFaFFePvs8QYY/OmXd3uDQmoDa73EdiSCS78tyHLenvT+gV3o
         iQu7sRCHel0uGTncrVK0wcZ7I9kgEg/2YP+uQF74FLUU7Qk6xu9vsoQeMvlKcil9Cg6v
         6PBVarNBsC/6mSWCVFsTU8LlELZgdj8VqmuLHicz+d1raLMVZHeg+8HBl0r6Qcdl9923
         iKwo/duZsOFByTqq567TVi91grqmlNsbSACfxU1InjQSzXQUHIUp3TakPIWxPUXVBnYp
         iGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gTVMtyfMIqk/Qcfg0DT+LOQqnLSo6iYSNatYMrKII8w=;
        b=fRDoxjTJ0APb/o5bkuE+9NXfopS6a73cQ9PnbOSxPUy5dUWU9qDT/ZgjjDB2HmkHa7
         5XoQYaX1VNFDZAsFD4AL9oMXh3gZdAZ9lFGnX/pmqKqkqRE11D20SjhgCQpcREv6e5Hv
         3iSeLujOoSWeqP/DXFueLiYCcNhIxp1i6XcEL9LQdNxU7Y6lLREAp6ihUrlsQxzHeens
         OXDvA98VnSklxGTm4tvq4Cu5eMKMDI2YqcyMXhust764fd+HBDnvPpsazQ9PuXS5N/aS
         OXApc/s2Ism4OFJpQ6Fb4hOZ2as6OBefTxvm44J9u6BQtTpKc9YWyxSaup8dS50NORvN
         P9kQ==
X-Gm-Message-State: AOAM5301EbannP9SemWa6LkNBAL/AJGmtwHoDTwKAZfHlVwFtlq0apmn
        unEXdU1khKpf9+IeH+rERgdUygsMWoLa0lXncYaWfRpUe2OvwEdqNevjTJ6hsuremqwRQntNbVy
        toQxD4//11m9Q3+OcCI3oU/JennPTDuP+PX+HtyAsnEQwtwT961ZpRw==
X-Google-Smtp-Source: ABdhPJwA5pJpUaIhre0IbEdJMdECr/x07XSpvAtmopj84iCGDCwsFui3hholAvzK4G5r8yWe5HDRH6s=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a0c:f843:: with SMTP id g3mr12439959qvo.20.1611192165623;
 Wed, 20 Jan 2021 17:22:45 -0800 (PST)
Date:   Wed, 20 Jan 2021 17:22:41 -0800
In-Reply-To: <20210121012241.2109147-1-sdf@google.com>
Message-Id: <20210121012241.2109147-2-sdf@google.com>
Mime-Version: 1.0
References: <20210121012241.2109147-1-sdf@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next 2/2] selftests/bpf: verify that rebinding to port <
 1024 from BPF works
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF rewrites from 111 to 111, but it still should mark the port as
"changed".
We also verify that if port isn't touched by BPF, it's still prohibited.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/bind_perm.c      | 88 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/bind_perm.c | 36 ++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bind_perm.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind_perm.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bind_perm.c b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
new file mode 100644
index 000000000000..840a04ac9042
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bind_perm.c
@@ -0,0 +1,88 @@
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
+	CHECK(errno != expected_errno, "bind", "errno %d, expected %d",
+	      errno, expected_errno);
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
+	if (CHECK(!skel, "skel-load", "errno %d", errno))
+		goto close_cgroup_fd;
+
+	skel->links.bind_v4_prog = bpf_program__attach_cgroup(skel->progs.bind_v4_prog, cgroup_fd);
+	if (CHECK(IS_ERR(skel->links.bind_v4_prog),
+		  "cg-attach", "bind4 %ld",
+		  PTR_ERR(skel->links.bind_v4_prog)))
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
index 000000000000..2194587ec806
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
+		ctx->user_port = bpf_htons(111);
+
+	return 1;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.0.284.gd98b1dd5eaa7-goog

