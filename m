Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9AFC2A1A22
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgJaSwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbgJaSwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 14:52:34 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F13C0617A6;
        Sat, 31 Oct 2020 11:52:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so7776312pfd.3;
        Sat, 31 Oct 2020 11:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=f3XHB3RlMcyLGwFip4ZJFTv2rtDXE1qxD9+Dpv+Vw9U=;
        b=LJKcLfAqgvdLoOe7l0UpuzIxXL6aFrW4MMcWA/1EzJTcYFGur8apa5MpoaClD678JX
         1O9RdPu3PpaBiO39A4BYcj1fb7xyHnbV7fmsMyFmB/abnv0UnaQfOysWvItaoFFZDmNC
         vaoCaTta62usGb9ItxwShSRg4IQUFi+1hcxgbeK4GUYvTxWfG21qb3tkieKcHltNSMqB
         8zwdTM09sqtf/l348aPuoFEg8wAW0GlVRg8JYcmgEi+ush7MAHPgXEKUPXb1sqbI6xaj
         jDUEj5AJ+VavHk1pjZAdCl6e0zHNdGz8MiZmRojVbO/JCCC12NFBMbjU59jaNXQGHU16
         0ljw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f3XHB3RlMcyLGwFip4ZJFTv2rtDXE1qxD9+Dpv+Vw9U=;
        b=XjEJiBAi2/hh/d2gllbNheVdPJ4ZKVUupioWJRs37Ecagu2+pQW7D7ZRb3474k0s/O
         tXnv47HI6xpcK+y0e2Lj2fkpUmhaCs2/dGiCVkwhfIqIsQmYpbnVt2F7x6ZkdC7fWjmi
         nY4YNjQCA4+2RXMkWL3eGqRrAIP4Caj5XmfW1qEvbA1UXFXOy2lbcygm4dXAWbAYvfmF
         W+gIWQNfmHyyOwC00zv3Thsbz71n6P92aQ2lD1eYwd139V6n6HlV/Idtb0wNqOI78Or7
         xEJXcJ+OwE7eRrpCayUmhA3Okg5JRwp632mN2iQiQc3qRK+HWvzUWRo+ZLOgPxw1XL0u
         6TXQ==
X-Gm-Message-State: AOAM533go7EwU5TEtyozbuftBsJiNHnDjk0TroPRay/UfP34gqGGloxn
        JSK7ODUpkg6cVcSU1rK+gFc=
X-Google-Smtp-Source: ABdhPJzU2dwTyhCoPtP4Xwh2YksGRvDkiQmsrRgvQctnVF9twe7oX+UqjqgHcPQoQQnWvPWxS9FjzQ==
X-Received: by 2002:a63:f74c:: with SMTP id f12mr7043794pgk.434.1604170352205;
        Sat, 31 Oct 2020 11:52:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id z3sm9475495pfk.159.2020.10.31.11.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 11:52:31 -0700 (PDT)
Subject: [bpf-next PATCH v2 4/5] selftests/bpf: Migrate tcpbpf_user.c to use
 BPF skeleton
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Sat, 31 Oct 2020 11:52:31 -0700
Message-ID: <160417035105.2823.2453428685023319711.stgit@localhost.localdomain>
In-Reply-To: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
References: <160416890683.710453.7723265174628409401.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update tcpbpf_user.c to make use of the BPF skeleton. Doing this we can
simplify test_tcpbpf_user and reduce the overhead involved in setting up
the test.

In addition we can clean up the remaining bits such as the one remaining
CHECK_FAIL at the end of test_tcpbpf_user so that the function only makes
use of CHECK as needed.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   48 ++++++++------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index d96f4084d2f5..c7a61b0d616a 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -4,6 +4,7 @@
 #include <network_helpers.h>
 
 #include "test_tcpbpf.h"
+#include "test_tcpbpf_kern.skel.h"
 
 #define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-user-test"
@@ -133,44 +134,31 @@ static void run_test(int map_fd, int sock_map_fd)
 
 void test_tcpbpf_user(void)
 {
-	const char *file = "test_tcpbpf_kern.o";
-	int prog_fd, map_fd, sock_map_fd;
-	int error = EXIT_FAILURE;
-	struct bpf_object *obj;
+	struct test_tcpbpf_kern *skel;
+	int map_fd, sock_map_fd;
 	int cg_fd = -1;
-	int rv;
-
-	cg_fd = test__join_cgroup(CG_NAME);
-	if (cg_fd < 0)
-		goto err;
 
-	if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
-		fprintf(stderr, "FAILED: load_bpf_file failed for: %s\n", file);
-		goto err;
-	}
+	skel = test_tcpbpf_kern__open_and_load();
+	if (CHECK(!skel, "open and load skel", "failed"))
+		return;
 
-	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
-	if (rv) {
-		fprintf(stderr, "FAILED: bpf_prog_attach: %d (%s)\n",
-		       errno, strerror(errno));
-		goto err;
-	}
+	cg_fd = test__join_cgroup(CG_NAME);
+	if (CHECK(cg_fd < 0, "test__join_cgroup(" CG_NAME ")",
+		  "cg_fd:%d errno:%d", cg_fd, errno))
+		goto cleanup_skel;
 
-	map_fd = bpf_find_map(__func__, obj, "global_map");
-	if (map_fd < 0)
-		goto err;
+	map_fd = bpf_map__fd(skel->maps.global_map);
+	sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
 
-	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
-	if (sock_map_fd < 0)
-		goto err;
+	skel->links.bpf_testcb = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
+	if (ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
+		goto cleanup_namespace;
 
 	run_test(map_fd, sock_map_fd);
 
-	error = 0;
-err:
-	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
+cleanup_namespace:
 	if (cg_fd != -1)
 		close(cg_fd);
-
-	CHECK_FAIL(error);
+cleanup_skel:
+	test_tcpbpf_kern__destroy(skel);
 }


