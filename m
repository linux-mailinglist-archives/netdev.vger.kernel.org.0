Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2715D24941A
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 06:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgHSE2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 00:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgHSE2J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 00:28:09 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AACC061343;
        Tue, 18 Aug 2020 21:28:08 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id d22so11032552pfn.5;
        Tue, 18 Aug 2020 21:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=M3opla1rdhM7+KhzZMACkPruYe5naDoEOt2lGHY0/jSl6OgAGJSsRdKBHH8cY6MDci
         opHZGEoue/uRVWKo0fGTzuf10zo4BF5hGcZhFW8/mooLDB6gSHRWAWM9NH08xMn7i85w
         h0dLj1xVN/iavPD6wvMWtZPsHFJUbgu88aXWeKEDWz4plT2GZzqPiuJ488GveQ1hsR8i
         Xhf4T5jHQJn0UZLLyOk8DyNSHzmE9q2S6iqaQpjFz+wQRGK9DnvcWr6rOIR82F8LwGTH
         Cjf0WF+DPQKisvZyohk32mBctbabEVlU1Al2NGwtctrw1ttuMd60KWwV4PwHlRoZLQra
         DQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d1e0dJuipbcjgmvHRIYxapAopDQPQpa1n+aq2kwlZRQ=;
        b=lEP+2Wagp7pQTcaRGcV3/qX8g37mnlKzH4B7WZUNK82MBEsfcR8oKwcdcpWJ6EwZfa
         OboE3Vxre4EwRZk5US7nrVou07NapmiL7thcHAo/P688ChYr1IkaA8vl5E7DGhFeKxFB
         imwq3ham/9FW2x9XTlPSTYt+VyxskCBiaHYxfrLZh09HYSQeqHQUE74IkxGPi9KOSO6L
         y5Psh7C60QP4TvVOobz9bzEHLqBSS//GQpIr0CzGblBA3bs0Vy7a5EnJOo3XMzF0T+m2
         +3GAvxrdiSkwGHm+U1Y5Ed2pmZoTKDCv/cSILu8vUOULunfpUAtdb0+65XYTn1WodnFZ
         dh8Q==
X-Gm-Message-State: AOAM532seB4b6VOsT4kngYgYzrgLIO9nyBkfcg0SijraqcVpLiBVFph0
        piXq2AqKlQ9XTMiu0qAQjUsAp+TNVfA=
X-Google-Smtp-Source: ABdhPJy+ybfW4fdN8XzJ/Ps/SRP200kfQVuvG2lATVtp84YJvrr9zGnamG4HozTQ50VnIjpXX/85IA==
X-Received: by 2002:aa7:96f4:: with SMTP id i20mr17060921pfq.43.1597811288520;
        Tue, 18 Aug 2020 21:28:08 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id f6sm24132023pga.9.2020.08.18.21.28.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 21:28:07 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH v6 bpf-next 4/4] selftests/bpf: Add bpffs preload test.
Date:   Tue, 18 Aug 2020 21:27:59 -0700
Message-Id: <20200819042759.51280-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
References: <20200819042759.51280-1-alexei.starovoitov@gmail.com>
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

