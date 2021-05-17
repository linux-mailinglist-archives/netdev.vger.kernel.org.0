Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81D85386D47
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344231AbhEQWy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344178AbhEQWyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:54:49 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6106CC061756
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:32 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q5so8058164wrs.4
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pK3iupwBoYGtCvFJdATRExYDmiCQBy7a92C+G/Pbh88=;
        b=SbxIg04tx+ArMlJADwoOv/T14jsSdg+ly8uLk5Lu6In27+ip2ATi/DaOVhlO4w3eI3
         KAmn7K5KTETwDpcEn035JbNTZhD1YG1F0Sr9cY/8B56VNtzpZeHsVlnlCip5DoIKGD6U
         k2wqqncXkbcO5SOt0ZZsrhmJIkT26gzfzbpqDnSwWZyCwszOuEO5xkoTEm2IBMhmwxJl
         6ANqtkLqZEZAl5KCkvL/dS6pa+RvRZ6qqB73PPF02C5O7g/fURiGTQmp1XcaYZsLEV0x
         oe0mjkOxxdxKIQHWRKyhSfXchsiTKjAtOFOaagJxPZulK3GczNPZy0LgluK8fFBGN1gr
         hzPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pK3iupwBoYGtCvFJdATRExYDmiCQBy7a92C+G/Pbh88=;
        b=Soxyd0FtkzV8D/ap9c5OrCjX64fWtERBPYRqU8WovpPzbp2ENvGyWMdW/Bv4Et28rO
         5x/YL4pXXOKnms8ABjI/FFAhxTqf2nEXsvChA+tVWjex4tMkUbJEnS0sFWtAealHitlY
         AzYfHtShnTjdOIRz8pKrmTykM0IwSN0GHah0KN6GtoFU0E4rlqdjU3w+3y8J19YX+Sdv
         q9r+0vrWLifZc2rscBXIIC1GY0haAv9QsOa77dJ1pJ2CMkpyevBGIZGZFoqazERN3uDL
         McP9tyGeqjkNxARs04hDAdroHO7BQM2iRQ/9DdEb+gJf+QebYtrC+Smo6WXQ/al0GkPt
         cChA==
X-Gm-Message-State: AOAM532U2Yaf0eiyBJUvJLeT4hvXUpMMSRm+5qQ6D84LCzwVEv271FMr
        J+S39Cjgd/rX8UrtPOA1lL+Lyg==
X-Google-Smtp-Source: ABdhPJxV1/zzO94H4gXiuw9I2n83v9F3qnNxRE7auETPKA17XyRgwOIfnPCs9UOydQoEw/FgZq5Cxg==
X-Received: by 2002:adf:ed46:: with SMTP id u6mr1405382wro.295.1621292011131;
        Mon, 17 May 2021 15:53:31 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id h14sm23557487wrq.45.2021.05.17.15.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:30 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 03/11] bpfilter: Add IO functions
Date:   Tue, 18 May 2021 02:53:00 +0400
Message-Id: <20210517225308.720677-4-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce IO functions for:
1) reading and writing data from a descriptor: read_exact(), write_exact(),
2) reading and writing memory of other processes: pvm_read(), pvm_write().

read_exact() and write_exact() are wrappers over read(2)/write(2) with
correct handling of partial read/write. These functions are intended to
be used for communication over pipe with the kernel part of bpfilter.

pvm_read() and pvm_write() are wrappers over
process_vm_readv(2)/process_vm_writev(2) with an interface that uses a
single buffer instead of vectored form. These functions are intended to
be used for readining/writing memory buffers supplied to iptables ABI
setsockopt(2) from other processes.

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile                         |   2 +-
 net/bpfilter/io.c                             |  77 ++++++++++++++
 net/bpfilter/io.h                             |  18 ++++
 .../testing/selftests/bpf/bpfilter/.gitignore |   2 +
 tools/testing/selftests/bpf/bpfilter/Makefile |  17 +++
 .../testing/selftests/bpf/bpfilter/test_io.c  | 100 ++++++++++++++++++
 6 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/io.c
 create mode 100644 net/bpfilter/io.h
 create mode 100644 tools/testing/selftests/bpf/bpfilter/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpfilter/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpfilter/test_io.c

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index 874d5ef6237d..69a6c139fc7a 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o
+bpfilter_umh-objs := main.o bflog.o io.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/io.c b/net/bpfilter/io.c
new file mode 100644
index 000000000000..e645ae9d7a50
--- /dev/null
+++ b/net/bpfilter/io.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "io.h"
+
+#include <errno.h>
+#include <sys/uio.h>
+#include <unistd.h>
+
+#define do_exact(fd, op, buffer, count)                                                            \
+	({                                                                                         \
+		size_t total = 0;                                                                  \
+		int err = 0;                                                                       \
+												   \
+		do {                                                                               \
+			const ssize_t part = op(fd, (buffer) + total, (count) - total);            \
+			if (part > 0) {                                                            \
+				total += part;                                                     \
+			} else if (part == 0 && (count) > 0) {                                     \
+				err = -EIO;                                                        \
+				break;                                                             \
+			} else if (part == -1) {                                                   \
+				if (errno == EINTR)                                                \
+					continue;                                                  \
+				err = -errno;                                                      \
+				break;                                                             \
+			}                                                                          \
+		} while (total < (count));                                                         \
+												   \
+		err;                                                                               \
+	})
+
+int read_exact(int fd, void *buffer, size_t count)
+{
+	return do_exact(fd, read, buffer, count);
+}
+
+int write_exact(int fd, const void *buffer, size_t count)
+{
+	return do_exact(fd, write, buffer, count);
+}
+
+int pvm_read(pid_t pid, void *to, const void *from, size_t count)
+{
+	const struct iovec r_iov = { .iov_base = (void *)from, .iov_len = count };
+	const struct iovec l_iov = { .iov_base = to, .iov_len = count };
+	size_t total_bytes;
+
+	total_bytes = process_vm_readv(pid, &l_iov, 1, &r_iov, 1, 0);
+	if (total_bytes == -1)
+		return -errno;
+
+	if (total_bytes != count)
+		return -EFAULT;
+
+	return 0;
+}
+
+int pvm_write(pid_t pid, void *to, const void *from, size_t count)
+{
+	const struct iovec l_iov = { .iov_base = (void *)from, .iov_len = count };
+	const struct iovec r_iov = { .iov_base = to, .iov_len = count };
+	size_t total_bytes;
+
+	total_bytes = process_vm_writev(pid, &l_iov, 1, &r_iov, 1, 0);
+	if (total_bytes == -1)
+		return -errno;
+
+	if (total_bytes != count)
+		return -EFAULT;
+
+	return 0;
+}
diff --git a/net/bpfilter/io.h b/net/bpfilter/io.h
new file mode 100644
index 000000000000..ab56c8bb8e61
--- /dev/null
+++ b/net/bpfilter/io.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_IO_H
+#define NET_BPFILTER_IO_H
+
+#include <stddef.h>
+#include <sys/types.h>
+
+int read_exact(int fd, void *buffer, size_t count);
+int write_exact(int fd, const void *buffer, size_t count);
+
+int pvm_read(pid_t pid, void *to, const void *from, size_t count);
+int pvm_write(pid_t pid, void *to, const void *from, size_t count);
+
+#endif // NET_BPFILTER_IO_H
diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
new file mode 100644
index 000000000000..f5785e366013
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+test_io
diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
new file mode 100644
index 000000000000..c02d72d89199
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0
+
+top_srcdir = ../../../../..
+TOOLSDIR := $(abspath ../../../../)
+TOOLSINCDIR := $(TOOLSDIR)/include
+APIDIR := $(TOOLSINCDIR)/uapi
+BPFILTERSRCDIR := $(top_srcdir)/net/bpfilter
+
+CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
+
+TEST_GEN_PROGS += test_io
+
+KSFT_KHDR_INSTALL := 1
+
+include ../../lib.mk
+
+$(OUTPUT)/test_io: test_io.c $(BPFILTERSRCDIR)/io.c
diff --git a/tools/testing/selftests/bpf/bpfilter/test_io.c b/tools/testing/selftests/bpf/bpfilter/test_io.c
new file mode 100644
index 000000000000..e4294930c581
--- /dev/null
+++ b/tools/testing/selftests/bpf/bpfilter/test_io.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "io.h"
+
+#include <signal.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+FIXTURE(test_pvm)
+{
+	int wstatus;
+	int fd[2];
+	pid_t pid;
+	pid_t ppid;
+	char expected[5];
+	char actual[5];
+};
+
+FIXTURE_SETUP(test_pvm)
+{
+	snprintf(self->expected, sizeof(self->expected), "ipfw");
+	memset(self->actual, 0, sizeof(self->actual));
+	self->ppid = getpid();
+	ASSERT_EQ(pipe(self->fd), 0);
+	self->pid = fork();
+	ASSERT_NE(self->pid, -1) TH_LOG("Cannot fork(): %m\n");
+	close(self->fd[!!self->pid]);
+};
+
+FIXTURE_TEARDOWN(test_pvm)
+{
+	int wstatus;
+
+	if (!self->pid)
+		exit(0);
+
+	kill(self->pid, SIGKILL);
+	waitpid(self->pid, &wstatus, -2);
+	close(self->fd[1]);
+}
+
+TEST_F(test_pvm, read)
+{
+	if (!self->pid) {
+		const uint8_t baton = 'x';
+
+		memcpy(self->actual, self->expected, sizeof(self->actual));
+		ASSERT_EQ(write(self->fd[1], &baton, sizeof(baton)), sizeof(baton));
+
+		pause();
+		exit(0);
+	} else {
+		int err;
+		uint8_t baton;
+
+		EXPECT_EQ(read(self->fd[0], &baton, sizeof(baton)), sizeof(baton));
+		EXPECT_EQ(baton, 'x');
+
+		err = pvm_read(self->pid, &self->actual, &self->actual, sizeof(self->actual));
+		EXPECT_EQ(err, 0)
+		TH_LOG("Cannot pvm_read(): %s\n", strerror(-err));
+
+		EXPECT_EQ(memcmp(&self->expected, &self->actual, sizeof(self->actual)), 0);
+	}
+}
+
+TEST_F(test_pvm, write)
+{
+	if (getuid())
+		SKIP(return, "pvm_write requires CAP_SYS_PTRACE");
+
+	if (!self->pid) {
+		const uint8_t baton = 'x';
+		int err;
+
+		err = pvm_write(self->ppid, &self->actual, &self->expected, sizeof(self->expected));
+		EXPECT_EQ(err, 0) TH_LOG("Cannot pvm_write: %s\n", strerror(-err));
+
+		ASSERT_EQ(write(self->fd[1], &baton, sizeof(baton)), sizeof(baton));
+
+		pause();
+		exit(0);
+
+	} else {
+		uint8_t baton;
+
+		EXPECT_EQ(read(self->fd[0], &baton, sizeof(baton)), sizeof(baton));
+		EXPECT_EQ(baton, 'x');
+
+		EXPECT_EQ(memcmp(&self->expected, &self->actual, sizeof(self->actual)), 0);
+	}
+}
+
+TEST_HARNESS_MAIN
-- 
2.25.1

