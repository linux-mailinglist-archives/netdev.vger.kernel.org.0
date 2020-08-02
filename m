Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAAF239CD5
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgHBWaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 18:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727783AbgHBWaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 18:30:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B35C06174A;
        Sun,  2 Aug 2020 15:30:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so19782967plr.8;
        Sun, 02 Aug 2020 15:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=GXhyMkbTMvez7nLtU2m/LlS40A2EC+K9NMUW2q1e8eXdRh2n0I/gPL5t6sVfoC64SF
         0380jTYoVQrglXhn4fc6UZTnMEMe46dHxkn5Om/05lS6M4UPyCz6Jiil1JhjFuPGF9VE
         lyQqGLLpJ4dQYt5+cz2glICSVrmEnjTyct9MwB2MGzEhJp0wFt953oDltcrAnSETIewB
         DylwpWpaz3fBbEgzwbjdBnodMmbTJKLt6dbiMnQlQZ0Qs2x9QLsVZ2OwZF/yuW0xd1tk
         qDRAW1SssaDhU8lFShlETuPhfmAPXtpBnbQ51Ivj9lenYDkm8uzTJt7Nd8U0bnXKBn6F
         zBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=mX8i7PfDcF/nnwUZKuusg7fgnSttFtnv0RHZfq6qwUtgR9CJ440j6aYMYZf/FyLR6j
         8RTmPeoYYDY2IRYYvo6+o7IkLTCtl6juqkh19RFgReuA3Cf4OD72nUCNCYmFDxqY6bSE
         UQm3jdK17PYYHzYl28NitFIKVYywUyA7GS3qEEAYxqps1/0MJ/lMsiBEK3Glj2Vi8h1P
         Km+FosomukF3T4ENrb7v3hNW6MAxEYizIaTVzrqqrdc4ApLgKpUYbaqRU9klLfBiVHbD
         pthzcCtSxTeTMaw1VoLoYV2YH53JEoBV5Bo04HdtzNBEBcK/xdPZjR4vSFtoNCeLLl19
         oKAg==
X-Gm-Message-State: AOAM533/DC+9RD3yVjDpUVN5J5d3rWGDo1M9dZCiheqU2RWGWazezBv6
        igKtarYhFmSENsC72zVWPBM=
X-Google-Smtp-Source: ABdhPJwn7NqV+sBZpaRJwZdJ5H9fJhJGGV/xUVR9p8/X2wF7uZhgIqDDsSo7xItVxRYacLxGRwCIPA==
X-Received: by 2002:a17:902:900b:: with SMTP id a11mr2951354plp.315.1596407399427;
        Sun, 02 Aug 2020 15:29:59 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id g5sm15544414pjl.31.2020.08.02.15.29.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2020 15:29:58 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v5 bpf-next 4/4] selftests/bpf: Add bpffs preload test.
Date:   Sun,  2 Aug 2020 15:29:50 -0700
Message-Id: <20200802222950.34696-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
References: <20200802222950.34696-1-alexei.starovoitov@gmail.com>
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

