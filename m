Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FFA2A5726
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgKCVgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732773AbgKCVfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:35:14 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4AEC0613D1;
        Tue,  3 Nov 2020 13:35:14 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id x20so16721630qkn.1;
        Tue, 03 Nov 2020 13:35:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=o5G8Jb+LPfgEOmZTDFgJ/ZdqODvld3Xzcpw0P0t3ARY=;
        b=ft15CtGhs13oFVW6h1V9efPx3qTHRLijdFn06XC5z9mqnvbwQyAyjtKF5WVFLF5aD/
         oi6ML1KFFgRnjSdx0cFNjgMUS+WlHuuM4un2OLzW2ssncsnvnyTvpodxUn+5K4WowFtG
         W/VdwopOnAPLRYSJI3GvbjG9u3tlsX9CmYCGmxnPTjed1F0bfENwMbqJ4pv5cLa2KpLP
         MYmY2mv8neXsKupeJfTrS5NIHHVyuE60ambuJbskEAriUuUim4awz6zdSBQaY9AL3Yaq
         vfUm36S2GHaYLHynp+bGlqRdIUg1RUrwSM3bMYzcl292IcsVIF1SDG+ZnF1NBlW6lUR0
         V0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=o5G8Jb+LPfgEOmZTDFgJ/ZdqODvld3Xzcpw0P0t3ARY=;
        b=cARo1eA3EiFtRVe6mnLIvKGcdzcucZHSQ/5gPfxFsSAQsmoXr812ruBQwGOsOk9mZd
         wwn0OloysIzwp0p92YSBS3lBal7KI136FNtcFF+ABzX4vaRTHyOsX1qz4PlARpCncetb
         Sr87hxeXG50THjYTAEwFemVastI0IacPO/VARaNwmoMX9i+LS45Kx32CUVmST2w1tcVX
         6Y957NHZO34cB9gt6RmZf8pwhfBBDhB68wEfdyyCnBhHJO9Q/iOcvACViV6hBa7ClzLi
         W2Dg/ePLnUiRKPgEbo+XUA9LV2ijc02cq7hucE7baKpo8YCMPrwC+s0LYajoZG4FoUdd
         VNdw==
X-Gm-Message-State: AOAM533FTgGqU1yfh3rNkKJxqL0wummH52o1mutEhQYISME8JrUEwuNn
        Q+kH9xd1KP1hvG+1TwCsoYY=
X-Google-Smtp-Source: ABdhPJz97+XGaigkjYANl3AVu1Mmm38hA5iFL75Qq1mn7uxxtRFC0DUDIoCPw1V4EuCsurtCgCp3Gg==
X-Received: by 2002:a37:de02:: with SMTP id h2mr19789669qkj.99.1604439313840;
        Tue, 03 Nov 2020 13:35:13 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id b14sm11729383qkn.123.2020.11.03.13.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:35:13 -0800 (PST)
Subject: [bpf-next PATCH v3 4/5] selftests/bpf: Migrate tcpbpf_user.c to use
 BPF skeleton
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        john.fastabend@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org, edumazet@google.com, brakmo@fb.com,
        andrii.nakryiko@gmail.com, alexanderduyck@fb.com
Date:   Tue, 03 Nov 2020 13:35:11 -0800
Message-ID: <160443931155.1086697.17869006617113525162.stgit@localhost.localdomain>
In-Reply-To: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
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

Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |   41 +++++++-------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
index 22c359871af6..bef81648797a 100644
--- a/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
@@ -3,6 +3,7 @@
 #include <network_helpers.h>
 
 #include "test_tcpbpf.h"
+#include "test_tcpbpf_kern.skel.h"
 
 #define LO_ADDR6 "::1"
 #define CG_NAME "/tcpbpf-user-test"
@@ -130,44 +131,30 @@ static void run_test(int map_fd, int sock_map_fd)
 
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
 
-	cg_fd = test__join_cgroup(CG_NAME);
-	if (cg_fd < 0)
-		goto err;
-
-	if (bpf_prog_load(file, BPF_PROG_TYPE_SOCK_OPS, &obj, &prog_fd)) {
-		printf("FAILED: load_bpf_file failed for: %s\n", file);
-		goto err;
-	}
+	skel = test_tcpbpf_kern__open_and_load();
+	if (CHECK(!skel, "open and load skel", "failed"))
+		return;
 
-	rv = bpf_prog_attach(prog_fd, cg_fd, BPF_CGROUP_SOCK_OPS, 0);
-	if (rv) {
-		printf("FAILED: bpf_prog_attach: %d (%s)\n",
-		       error, strerror(errno));
+	cg_fd = test__join_cgroup(CG_NAME);
+	if (CHECK(cg_fd < 0, "test__join_cgroup(" CG_NAME ")",
+		  "cg_fd:%d errno:%d", cg_fd, errno))
 		goto err;
-	}
 
-	map_fd = bpf_find_map(__func__, obj, "global_map");
-	if (map_fd < 0)
-		goto err;
+	map_fd = bpf_map__fd(skel->maps.global_map);
+	sock_map_fd = bpf_map__fd(skel->maps.sockopt_results);
 
-	sock_map_fd = bpf_find_map(__func__, obj, "sockopt_results");
-	if (sock_map_fd < 0)
+	skel->links.bpf_testcb = bpf_program__attach_cgroup(skel->progs.bpf_testcb, cg_fd);
+	if (!ASSERT_OK_PTR(skel->links.bpf_testcb, "attach_cgroup(bpf_testcb)"))
 		goto err;
 
 	run_test(map_fd, sock_map_fd);
 
-	error = 0;
 err:
-	bpf_prog_detach(cg_fd, BPF_CGROUP_SOCK_OPS);
 	if (cg_fd != -1)
 		close(cg_fd);
-
-	CHECK_FAIL(error);
+	test_tcpbpf_kern__destroy(skel);
 }


