Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD1522CF93
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 22:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgGXUim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 16:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgGXUik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 16:38:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58043C0619D3;
        Fri, 24 Jul 2020 13:38:40 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so6043039pgc.5;
        Fri, 24 Jul 2020 13:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=kggM0LN7USmLGbhWMK1o1G7Rh6jtOiaHJfL0mwaofwHfht6MDS7tITuA+YHQGUGOf6
         n+pBLSRaiZld2dZUbaHB1q8dfFEMsPHlniu721C0KpgW/YGL875Oop0pk6FzLBR+7hAy
         xnnbZnXZlZypyT40dU9ppYlHej/DM6JNyc8Jx4jM2vsjtnvYe0u07cLb9YGCPu+qDVSZ
         2z2F5ZKDUVy9LpD+yNtCCUGn8c2NP4zn+HWQG8Kd0ybtDilNrhW9Ydz3Vsxr+i3o8E+3
         B74+7OfWwx4NMaTXw2QmlOOIzXW3oSVQK1U1VQYRE6zO6FX8aTDnHIy9i81a8yfSTS5S
         4b7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=YpGNcg1hSyXaMnkpn2lswmi2B2OVOUn76GDN1p8rFvnDxqjIAoZgKweFPlKix1lOHY
         VasRyzE8u647RxVlAOvyWrugRHmNwBJ1/TRIBJqaMgV6t78sdj8G701qa1mSKj54PTlO
         geUClnkflYMtlvX3NnRglTTT14ozvNzI8hN0Any5WGdBoBCWyQ2B8eWQFs6P9PKl2di8
         Obrmr3ISldVz5djKTJUD9/Hb6N6m94XQdCzr9OD337U/gKwS4sts0cMILPj+Dun/UxAa
         0FR1ky1yMO7EvQUMudVInsSbVhge9C/d5RbR0qsin00M8pgWRPfkLQp4/dszVdjVdcC8
         Eung==
X-Gm-Message-State: AOAM531hyAVPFZNT9N0gIDSyFRmnoiXUEEdv/K/WMnK8vzPbn/Ym3ALW
        Ji3Al9rRNIoyRGJVeqVOf0w=
X-Google-Smtp-Source: ABdhPJw3zl+xrmGQFxBdTcrYCp+l9SyY0ej/SvnHT4vtOnDkBz/fpmNz9Nr5sZrwpGRoKNxVZTOUDw==
X-Received: by 2002:aa7:96d1:: with SMTP id h17mr10137806pfq.141.1595623119868;
        Fri, 24 Jul 2020 13:38:39 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id lr1sm8114461pjb.27.2020.07.24.13.38.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2020 13:38:39 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v4 bpf-next 4/4] selftests/bpf: Add bpffs preload test.
Date:   Fri, 24 Jul 2020 13:38:30 -0700
Message-Id: <20200724203830.81531-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200724203830.81531-1-alexei.starovoitov@gmail.com>
References: <20200724203830.81531-1-alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add a test that mounts two bpffs instances and checks progs.debug
and maps.debug for sanity data.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/test_bpffs.c     | 94 +++++++++++++++++++
 1 file changed, 94 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpffs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/test_bpffs.c b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
new file mode 100644
index 000000000000..172c999e523c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/test_bpffs.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define _GNU_SOURCE
+#include <sched.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <test_progs.h>
+
+#define TDIR "/sys/kernel/debug"
+
+static int read_iter(char *file)
+{
+	/* 1024 should be enough to get contiguous 4 "iter" letters at some point */
+	char buf[1024];
+	int fd, len;
+
+	fd = open(file, 0);
+	if (fd < 0)
+		return -1;
+	while ((len = read(fd, buf, sizeof(buf))) > 0)
+		if (strstr(buf, "iter")) {
+			close(fd);
+			return 0;
+		}
+	close(fd);
+	return -1;
+}
+
+static int fn(void)
+{
+	int err, duration = 0;
+
+	err = unshare(CLONE_NEWNS);
+	if (CHECK(err, "unshare", "failed: %d\n", errno))
+		goto out;
+
+	err = mount("", "/", "", MS_REC | MS_PRIVATE, NULL);
+	if (CHECK(err, "mount /", "failed: %d\n", errno))
+		goto out;
+
+	err = umount(TDIR);
+	if (CHECK(err, "umount " TDIR, "failed: %d\n", errno))
+		goto out;
+
+	err = mount("none", TDIR, "tmpfs", 0, NULL);
+	if (CHECK(err, "mount", "mount root failed: %d\n", errno))
+		goto out;
+
+	err = mkdir(TDIR "/fs1", 0777);
+	if (CHECK(err, "mkdir "TDIR"/fs1", "failed: %d\n", errno))
+		goto out;
+	err = mkdir(TDIR "/fs2", 0777);
+	if (CHECK(err, "mkdir "TDIR"/fs2", "failed: %d\n", errno))
+		goto out;
+
+	err = mount("bpf", TDIR "/fs1", "bpf", 0, NULL);
+	if (CHECK(err, "mount bpffs "TDIR"/fs1", "failed: %d\n", errno))
+		goto out;
+	err = mount("bpf", TDIR "/fs2", "bpf", 0, NULL);
+	if (CHECK(err, "mount bpffs " TDIR "/fs2", "failed: %d\n", errno))
+		goto out;
+
+	err = read_iter(TDIR "/fs1/maps.debug");
+	if (CHECK(err, "reading " TDIR "/fs1/maps.debug", "failed\n"))
+		goto out;
+	err = read_iter(TDIR "/fs2/progs.debug");
+	if (CHECK(err, "reading " TDIR "/fs2/progs.debug", "failed\n"))
+		goto out;
+out:
+	umount(TDIR "/fs1");
+	umount(TDIR "/fs2");
+	rmdir(TDIR "/fs1");
+	rmdir(TDIR "/fs2");
+	umount(TDIR);
+	exit(err);
+}
+
+void test_test_bpffs(void)
+{
+	int err, duration = 0, status = 0;
+	pid_t pid;
+
+	pid = fork();
+	if (CHECK(pid == -1, "clone", "clone failed %d", errno))
+		return;
+	if (pid == 0)
+		fn();
+	err = waitpid(pid, &status, 0);
+	if (CHECK(err == -1 && errno != ECHILD, "waitpid", "failed %d", errno))
+		return;
+	if (CHECK(WEXITSTATUS(status), "bpffs test ", "failed %d", WEXITSTATUS(status)))
+		return;
+}
-- 
2.23.0

