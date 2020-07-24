Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0766E22BDCF
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXF7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgGXF7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 01:59:04 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7BCC0619D3;
        Thu, 23 Jul 2020 22:59:04 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z5so4666561pgb.6;
        Thu, 23 Jul 2020 22:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=jUAO/fn8NCR79Q27Ol/PYpSboZP1nP/mCe6IVFiI2Ak7exs5daGiQhJu1v2+Hgcxy6
         pNroD5VLIIMvwx42BfzLOVMFyFF0mL0u08DMigOM4MAVQ8eINpXxrNF3IEr74/+lsI0s
         JihRjZm9BRFVd3e0ePO6nbLed9zbjpgRY3hGZ0sbJ19mzBzyhS8JaRycLwv2HoEgKSng
         0+LFuJvgsnV7d2ms7PNm7m5EZUlVBdgwUl7V6i4wM8qb3iP8nUPElGzhd9KwfodJ2uDl
         Q0yLZsJe71+IfOF9+HZaQAFZIYoz9vtLylIw/W5NKcAM0fH/ZMjCZdMHV5LFQP2IJD5A
         ntlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=IQDxyLbTSOcyCJtSLmpbuL7Rgpe9xtbqjAfpPUoaZ4eBoLo1kQbfILhy1k+MaBomp0
         WjV9fLEGFC/EVmWA/r+DkH4HHYVd/5H4j8Ytd0qrAauZ8kfRvUCNzYo2pfs+maZuxIhm
         T1ls6OpVg2OCWX7q1ckChXCYRZpWhzc3rhBFKC2S35evPUqon3uK7tG/OR54ePJfyYkV
         k4Zl8ybQTFh1SUhhEss36/BAOIQxRLTUMoub2ykmV8LxR0EDOgdDJeI+y+U/iCVbJuLZ
         m+MY96dofClwmUvywaHwmElTHOr0usH0ek60MTdxwCKlmBGXDhPZDQmvAZ25HpZi5r4g
         AJrw==
X-Gm-Message-State: AOAM533WL2Tu7guEc1fenp3WD0Wr6o604IImi9So3MWP8xIx0fvFeM/c
        uuVYi0Mjxk9zRPPz7Vf8jE0=
X-Google-Smtp-Source: ABdhPJyA3y1L/MaGeCYGYhUPgDhBJ3MTpfKFAUW9FgLY6ypjVIkbRUaram5mSQ4Eww6WSPpyuP9RBQ==
X-Received: by 2002:aa7:9eca:: with SMTP id r10mr7379528pfq.301.1595570343837;
        Thu, 23 Jul 2020 22:59:03 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id j10sm4909893pgh.28.2020.07.23.22.59.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jul 2020 22:59:03 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 bpf-next 4/4] selftests/bpf: Add bpffs preload test.
Date:   Thu, 23 Jul 2020 22:58:54 -0700
Message-Id: <20200724055854.59013-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
References: <20200724055854.59013-1-alexei.starovoitov@gmail.com>
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

