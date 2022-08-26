Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FF55A1D86
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244254AbiHZAGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbiHZAGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:06:43 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E40C8747;
        Thu, 25 Aug 2022 17:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472402; x=1693008402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EQeW0sSy7Q8sjLsXJaxr3iBIqJE/m2vT7eadVIV6FfE=;
  b=LfWI+1nUvt2X0eV7MZPtIfXNg/+qTHNQWNVj/tfM4Pfa4NFQGtTHXWeY
   ptbXaFs1GJ9/uAPVBUnvrwz/tcMfIbAB/b4YO+0EaX8qw9MOTTZxwyKft
   BU5F3+TMoX4cOZUGYEKFN8ucEjTqFzGkB5PYTQDbixyZHFTTHtC1uN/G/
   Q=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="221027636"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:06:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id D493DA275A;
        Fri, 26 Aug 2022 00:06:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:06:22 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:06:18 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 03/13] selftest: sysctl: Add test for flock(LOCK_MAND).
Date:   Thu, 25 Aug 2022 17:04:35 -0700
Message-ID: <20220826000445.46552-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds test cases for LOCK_MAND:

  - LOCK_MAND with/without LOCK_READ/LOCK_WRITE
  - read/write
    - same fd
    - different fd
      - same PID
      - different PID

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/sysctl/.gitignore     |   2 +
 tools/testing/selftests/sysctl/Makefile       |   9 +-
 tools/testing/selftests/sysctl/sysctl_flock.c | 157 ++++++++++++++++++
 3 files changed, 163 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/sysctl/.gitignore
 create mode 100644 tools/testing/selftests/sysctl/sysctl_flock.c

diff --git a/tools/testing/selftests/sysctl/.gitignore b/tools/testing/selftests/sysctl/.gitignore
new file mode 100644
index 000000000000..a3382ba798a6
--- /dev/null
+++ b/tools/testing/selftests/sysctl/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+/sysctl_flock
diff --git a/tools/testing/selftests/sysctl/Makefile b/tools/testing/selftests/sysctl/Makefile
index 110301f9f5be..eb565b6c8340 100644
--- a/tools/testing/selftests/sysctl/Makefile
+++ b/tools/testing/selftests/sysctl/Makefile
@@ -2,12 +2,11 @@
 # Makefile for sysctl selftests.
 # Expects kernel.sysctl_writes_strict=1.
 
-# No binaries, but make sure arg-less "make" doesn't trigger "run_tests".
-all:
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
+CFLAGS += -D_GNU_SOURCE
 
 TEST_PROGS := sysctl.sh
 
-include ../lib.mk
+TEST_GEN_PROGS += sysctl_flock
 
-# Nothing to clean up.
-clean:
+include ../lib.mk
diff --git a/tools/testing/selftests/sysctl/sysctl_flock.c b/tools/testing/selftests/sysctl/sysctl_flock.c
new file mode 100644
index 000000000000..4c4be10ae0d3
--- /dev/null
+++ b/tools/testing/selftests/sysctl/sysctl_flock.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+
+#include <unistd.h>
+#include <sys/file.h>
+#include <sys/types.h>
+
+#include "../kselftest_harness.h"
+
+#define SYSCTL_PATH	"/proc/sys/net/ipv4/tcp_migrate_req"
+#define SYSCTL_BUFLEN	8
+
+FIXTURE(proc_sysctl_flock)
+{
+	int fd;
+	char buf[SYSCTL_BUFLEN];
+	int len;
+};
+
+FIXTURE_VARIANT(proc_sysctl_flock)
+{
+	int cmd;
+};
+
+FIXTURE_VARIANT_ADD(proc_sysctl_flock, lock_mand)
+{
+	.cmd = LOCK_MAND,
+};
+
+FIXTURE_VARIANT_ADD(proc_sysctl_flock, lock_mand_read)
+{
+	.cmd = LOCK_MAND | LOCK_READ,
+};
+
+FIXTURE_VARIANT_ADD(proc_sysctl_flock, lock_mand_write)
+{
+	.cmd = LOCK_MAND | LOCK_WRITE,
+};
+
+FIXTURE_VARIANT_ADD(proc_sysctl_flock, lock_mand_read_write)
+{
+	.cmd = LOCK_MAND | LOCK_READ | LOCK_WRITE,
+};
+
+int proc_sysctl_open(struct __test_metadata *_metadata)
+{
+	int fd;
+
+	fd = open(SYSCTL_PATH, O_RDWR);
+	ASSERT_NE(-1, fd);
+
+	return fd;
+}
+
+FIXTURE_SETUP(proc_sysctl_flock)
+{
+	self->fd = proc_sysctl_open(_metadata);
+	ASSERT_EQ(0, flock(self->fd, variant->cmd));
+
+	self->len = read(self->fd, self->buf, sizeof(self->buf));
+	ASSERT_NE(-1, self->len);
+
+	ASSERT_EQ(self->len, write(self->fd, self->buf, self->len));
+}
+
+FIXTURE_TEARDOWN(proc_sysctl_flock)
+{
+	flock(self->fd, LOCK_UN);
+	close(self->fd);
+}
+
+int is_readable(int cmd)
+{
+	return cmd & LOCK_READ;
+}
+
+int is_writable(int cmd)
+{
+	return cmd & LOCK_WRITE;
+}
+
+void proc_sysctl_newfd_read(struct __test_metadata *_metadata,
+			    FIXTURE_DATA(proc_sysctl_flock) *self,
+			    const FIXTURE_VARIANT(proc_sysctl_flock) *variant)
+{
+	char buf[SYSCTL_BUFLEN];
+	int err, fd;
+
+	fd = proc_sysctl_open(_metadata);
+
+	err = read(fd, buf, SYSCTL_BUFLEN);
+	if (is_readable(variant->cmd)) {
+		ASSERT_EQ(self->len, err);
+	} else {
+		ASSERT_EQ(-1, err);
+	}
+
+	close(fd);
+}
+
+void proc_sysctl_newfd_write(struct __test_metadata *_metadata,
+			     FIXTURE_DATA(proc_sysctl_flock) *self,
+			     const FIXTURE_VARIANT(proc_sysctl_flock) *variant)
+{
+	int err, fd;
+
+	fd = proc_sysctl_open(_metadata);
+
+	err = write(fd, self->buf, self->len);
+	if (is_writable(variant->cmd)) {
+		ASSERT_EQ(self->len, err);
+	} else {
+		ASSERT_EQ(-1, err);
+	}
+
+	close(fd);
+}
+
+void proc_sysctl_fork(struct __test_metadata *_metadata,
+		      FIXTURE_DATA(proc_sysctl_flock) *self,
+		      const FIXTURE_VARIANT(proc_sysctl_flock) *variant,
+		      int read)
+{
+	int pid, status;
+
+	pid = fork();
+	if (pid == 0) {
+		if (read)
+			return proc_sysctl_newfd_read(_metadata, self, variant);
+		else
+			return proc_sysctl_newfd_write(_metadata, self, variant);
+	}
+
+	waitpid(pid, &status, 0);
+}
+
+TEST_F(proc_sysctl_flock, test_newfd_read)
+{
+	proc_sysctl_newfd_read(_metadata, self, variant);
+}
+
+TEST_F(proc_sysctl_flock, test_newfd_write)
+{
+	proc_sysctl_newfd_write(_metadata, self, variant);
+}
+
+TEST_F(proc_sysctl_flock, test_fork_newfd_read)
+{
+	proc_sysctl_fork(_metadata, self, variant, 1);
+}
+
+TEST_F(proc_sysctl_flock, test_fork_newfd_write)
+{
+	proc_sysctl_fork(_metadata, self, variant, 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

