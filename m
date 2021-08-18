Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79643F021E
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhHRK7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbhHRK7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 06:59:11 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DADEC0613D9;
        Wed, 18 Aug 2021 03:58:37 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id m26so1734130pff.3;
        Wed, 18 Aug 2021 03:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5ARDh7zwSb2X5RObytIAU8QGeSNvl46IYM6BIWZuQHU=;
        b=kgz0j3/ZG5layIgNAKSLvmcq9bWDXQP5wO8sD43K3y9/ZGRmQQAERtK2A9qODJ1jI7
         PFjFK0c5msANswvgIHnLeZV39qsLJWn32SOLkpFgeq9IcOGGxP1I7cPTaegGXeQjL8YN
         ChdGueOimURrUxVDboS+9KgDIeInZ18njgbeyJvoTmIx3STEn7viX79Pf5AgqobNLlqD
         g+kC4H5RiRTCxB2aZcyfr6Me0rRVmbdOuYSqI65F1fBk33ICF2wdof57wZ+B8VcTSPpO
         S0AWzBgyMyPOC4Qj2uFmGTp+tnrfgVa8cYU+3oJpBel2e8eCuBL6skVwUkKZ16jlLuR7
         sueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5ARDh7zwSb2X5RObytIAU8QGeSNvl46IYM6BIWZuQHU=;
        b=nAVPqsxSdieOPhPaB+jNSuE87QEvY7Bf3h0IhbtEMuaPUZasFHvCmCvAZWJcw01HKd
         FpOB9MOgly6Rm/0PxfK6AbFWrV0aFAXxf3LJPgFinq8t+D3CGMBDxLYQxNVjS5RB7IYQ
         U7Bwpr7YTj0jtPg+YIy5VQIh1rSNNWnolxLI9KAzjyxfk663YCRsvxoJPzCaYH4fYXxG
         6b7bxwycSy6z/TYfIceYVEl6kHRcuDg475i5hHbhr7ynpspJtuZEdAsNCB/3EoHCHqzE
         QffcRZAVgx75/j1ZeJU5Q4zRYZ0nw2cfGnpPiZ4SkKJY7kQusgfiyKotKyBobIgS7Pfe
         ARGQ==
X-Gm-Message-State: AOAM531Ruc9J1NeAS3kPvThduEGG7B2OGcLugAPTTc03V0JchXSLdWbf
        BLjfH+RZhdqaOrIXb0MDK1M=
X-Google-Smtp-Source: ABdhPJw9BpE+Hvns4NnirXV/b/Mn11VgwyMngLva03K9N8cnsYeEB/iBdB4SI3dih+eaj48zaStnYg==
X-Received: by 2002:a63:1a65:: with SMTP id a37mr8432809pgm.338.1629284316963;
        Wed, 18 Aug 2021 03:58:36 -0700 (PDT)
Received: from IRVINGLIU-MB0.tencent.com ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id b190sm7099440pgc.91.2021.08.18.03.58.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 03:58:36 -0700 (PDT)
From:   Xu Liu <liuxu623@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xu Liu <liuxu623@gmail.com>
Subject: [PATCH bpf-next v2 2/2] selftests/bpf: Test for get_netns_cookie
Date:   Wed, 18 Aug 2021 18:58:20 +0800
Message-Id: <20210818105820.91894-3-liuxu623@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210818105820.91894-1-liuxu623@gmail.com>
References: <20210818105820.91894-1-liuxu623@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test to use get_netns_cookie() from BPF_PROG_TYPE_SOCK_OPS.

Signed-off-by: Xu Liu <liuxu623@gmail.com>
---
 .../selftests/bpf/prog_tests/netns_cookie.c   | 61 +++++++++++++++++++
 .../selftests/bpf/progs/netns_cookie_prog.c   | 39 ++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netns_cookie.c
 create mode 100644 tools/testing/selftests/bpf/progs/netns_cookie_prog.c

diff --git a/tools/testing/selftests/bpf/prog_tests/netns_cookie.c b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
new file mode 100644
index 000000000000..6f3cd472fb65
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/netns_cookie.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "netns_cookie_prog.skel.h"
+#include "network_helpers.h"
+
+#ifndef SO_NETNS_COOKIE
+#define SO_NETNS_COOKIE 71
+#endif
+
+static int duration;
+
+void test_netns_cookie(void)
+{
+	int server_fd = 0, client_fd = 0, cgroup_fd = 0, err = 0, val = 0;
+	struct netns_cookie_prog *skel;
+	uint64_t cookie_expected_value;
+	socklen_t vallen = sizeof(cookie_expected_value);
+
+	skel = netns_cookie_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_open"))
+		return;
+
+	cgroup_fd = test__join_cgroup("/netns_cookie");
+	if (CHECK(cgroup_fd < 0, "join_cgroup", "cgroup creation failed\n"))
+		goto out;
+
+	skel->links.get_netns_cookie_sockops = bpf_program__attach_cgroup(
+		skel->progs.get_netns_cookie_sockops, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.get_netns_cookie_sockops, "prog_attach"))
+		goto close_cgroup_fd;
+
+	server_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (CHECK(server_fd < 0, "start_server", "errno %d\n", errno))
+		goto close_cgroup_fd;
+
+	client_fd = connect_to_fd(server_fd, 0);
+	if (CHECK(client_fd < 0, "connect_to_fd", "errno %d\n", errno))
+		goto close_server_fd;
+
+	err = bpf_map_lookup_elem(bpf_map__fd(skel->maps.netns_cookies),
+				&client_fd, &val);
+	if (!ASSERT_OK(err, "map_lookup(socket_cookies)"))
+		goto close_client_fd;
+
+	err = getsockopt(client_fd, SOL_SOCKET, SO_NETNS_COOKIE,
+				&cookie_expected_value, &vallen);
+	if (!ASSERT_OK(err, "getsockopt)"))
+		goto close_client_fd;
+
+	ASSERT_EQ(val, cookie_expected_value, "cookie_value");
+
+close_client_fd:
+	close(client_fd);
+close_server_fd:
+	close(server_fd);
+close_cgroup_fd:
+	close(cgroup_fd);
+out:
+	netns_cookie_prog__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/netns_cookie_prog.c b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
new file mode 100644
index 000000000000..4ed8d75aa299
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/netns_cookie_prog.c
@@ -0,0 +1,39 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+
+#define AF_INET6 10
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} netns_cookies SEC(".maps");
+
+SEC("sockops")
+int get_netns_cookie_sockops(struct bpf_sock_ops *ctx)
+{
+	struct bpf_sock *sk = ctx->sk;
+	int *cookie;
+
+	if (ctx->family != AF_INET6)
+		return 1;
+
+	if (ctx->op != BPF_SOCK_OPS_TCP_CONNECT_CB)
+		return 1;
+
+	if (!sk)
+		return 1;
+
+	cookie = bpf_sk_storage_get(&netns_cookies, sk, 0,
+				BPF_SK_STORAGE_GET_F_CREATE);
+	if (!cookie)
+		return 1;
+
+	*cookie = bpf_get_netns_cookie(ctx);
+
+	return 1;
+}
-- 
2.28.0

