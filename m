Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D4D639921
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 02:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiK0BZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 20:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0BZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 20:25:26 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B2515839
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 17:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669512325; x=1701048325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DsMs96x/QRHwgdz6aP1cVuca3qatE3hNziGr0QQ0bcI=;
  b=g77gdOIdsaY4wfhCzPZtEpfgzynmkCtCf5Zgm4owpkr3fUMhsjMDw5CM
   1fVzGqavfSUd5QmBBsEnizuwonn6h287XY7Gqr234yUePOHFKINesZ/iF
   Qr/Q3VRhkCRLVO9GxKsQOEXXQcqj+RsMXa7TDXY4+EwXYjBsFFfxIo0He
   k=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2022 01:25:22 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 67FFF41778;
        Sun, 27 Nov 2022 01:25:21 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sun, 27 Nov 2022 01:25:20 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sun, 27 Nov 2022 01:25:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Felipe Gasper <felipe@felipegasper.com>,
        Wei Chen <harperchen1110@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        "Kuniyuki Iwashima" <kuni1840@gmail.com>, <netdev@vger.kernel.org>
Subject: [PATCH v2 net 2/2] af_unix: Add test for sock_diag and UDIAG_SHOW_UID.
Date:   Sun, 27 Nov 2022 10:24:12 +0900
Message-ID: <20221127012412.37969-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221127012412.37969-1-kuniyu@amazon.com>
References: <20221127012412.37969-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D23UWA001.ant.amazon.com (10.43.160.68) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test prog dumps a single AF_UNIX socket's UID with and without
unshare(CLONE_NEWUSER) and checks if it matches the result of getuid().

Without the preceding patch, the test prog is killed by a NULL deref
in sk_diag_dump_uid().

  # ./diag_uid
  TAP version 13
  1..2
  # Starting 2 tests from 3 test cases.
  #  RUN           diag_uid.uid.1 ...
  BUG: kernel NULL pointer dereference, address: 0000000000000270
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 105212067 P4D 105212067 PUD 1051fe067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.amzn2022.0.1 04/01/2014
  RIP: 0010:sk_diag_fill (./include/net/sock.h:920 net/unix/diag.c:119 net/unix/diag.c:170)
  ...
  # 1: Test terminated unexpectedly by signal 9
  #          FAIL  diag_uid.uid.1
  not ok 1 diag_uid.uid.1
  #  RUN           diag_uid.uid_unshare.1 ...
  # 1: Test terminated by timeout
  #          FAIL  diag_uid.uid_unshare.1
  not ok 2 diag_uid.uid_unshare.1
  # FAILED: 0 / 2 tests passed.
  # Totals: pass:0 fail:2 xfail:0 xpass:0 skip:0 error:0

With the patch, the test succeeds.

  # ./diag_uid
  TAP version 13
  1..2
  # Starting 2 tests from 3 test cases.
  #  RUN           diag_uid.uid.1 ...
  #            OK  diag_uid.uid.1
  ok 1 diag_uid.uid.1
  #  RUN           diag_uid.uid_unshare.1 ...
  #            OK  diag_uid.uid_unshare.1
  ok 2 diag_uid.uid_unshare.1
  # PASSED: 2 / 2 tests passed.
  # Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   2 +-
 .../testing/selftests/net/af_unix/diag_uid.c  | 178 ++++++++++++++++++
 3 files changed, 180 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/af_unix/diag_uid.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 3d7adee7a3e6..ff8fe93f679c 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 bind_bhash
 cmsg_sender
+diag_uid
 fin_ack_lat
 gro
 hwtstamp_config
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 969620ae9928..1e4b397cece6 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,3 +1,3 @@
-TEST_GEN_PROGS := test_unix_oob unix_connect
+TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/diag_uid.c b/tools/testing/selftests/net/af_unix/diag_uid.c
new file mode 100644
index 000000000000..5b88f7129fea
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/diag_uid.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <unistd.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/sock_diag.h>
+#include <linux/unix_diag.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/un.h>
+
+#include "../../kselftest_harness.h"
+
+FIXTURE(diag_uid)
+{
+	int netlink_fd;
+	int unix_fd;
+	__u32 inode;
+	__u64 cookie;
+};
+
+FIXTURE_VARIANT(diag_uid)
+{
+	int unshare;
+	int udiag_show;
+};
+
+FIXTURE_VARIANT_ADD(diag_uid, uid)
+{
+	.unshare = 0,
+	.udiag_show = UDIAG_SHOW_UID
+};
+
+FIXTURE_VARIANT_ADD(diag_uid, uid_unshare)
+{
+	.unshare = CLONE_NEWUSER,
+	.udiag_show = UDIAG_SHOW_UID
+};
+
+FIXTURE_SETUP(diag_uid)
+{
+	struct stat file_stat;
+	socklen_t optlen;
+	int ret;
+
+	if (variant->unshare)
+		ASSERT_EQ(unshare(variant->unshare), 0);
+
+	self->netlink_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_SOCK_DIAG);
+	ASSERT_NE(self->netlink_fd, -1);
+
+	self->unix_fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	ASSERT_NE(self->unix_fd, -1);
+
+	ret = fstat(self->unix_fd, &file_stat);
+	ASSERT_EQ(ret, 0);
+
+	self->inode = file_stat.st_ino;
+
+	optlen = sizeof(self->cookie);
+	ret = getsockopt(self->unix_fd, SOL_SOCKET, SO_COOKIE, &self->cookie, &optlen);
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE_TEARDOWN(diag_uid)
+{
+	close(self->netlink_fd);
+	close(self->unix_fd);
+}
+
+int send_request(struct __test_metadata *_metadata,
+		 FIXTURE_DATA(diag_uid) *self,
+		 const FIXTURE_VARIANT(diag_uid) *variant)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct unix_diag_req udr;
+	} req = {
+		.nlh = {
+			.nlmsg_len = sizeof(req),
+			.nlmsg_type = SOCK_DIAG_BY_FAMILY,
+			.nlmsg_flags = NLM_F_REQUEST
+		},
+		.udr = {
+			.sdiag_family = AF_UNIX,
+			.udiag_ino = self->inode,
+			.udiag_cookie = {
+				(__u32)self->cookie,
+				(__u32)(self->cookie >> 32)
+			},
+			.udiag_show = variant->udiag_show
+		}
+	};
+	struct sockaddr_nl nladdr = {
+		.nl_family = AF_NETLINK
+	};
+	struct iovec iov = {
+		.iov_base = &req,
+		.iov_len = sizeof(req)
+	};
+	struct msghdr msg = {
+		.msg_name = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov = &iov,
+		.msg_iovlen = 1
+	};
+
+	return sendmsg(self->netlink_fd, &msg, 0);
+}
+
+void render_response(struct __test_metadata *_metadata,
+		     struct unix_diag_req *udr, __u32 len)
+{
+	unsigned int rta_len = len - NLMSG_LENGTH(sizeof(*udr));
+	struct rtattr *attr;
+	uid_t uid;
+
+	ASSERT_GT(len, sizeof(*udr));
+	ASSERT_EQ(udr->sdiag_family, AF_UNIX);
+
+	attr = (struct rtattr *)(udr + 1);
+	ASSERT_NE(RTA_OK(attr, rta_len), 0);
+	ASSERT_EQ(attr->rta_type, UNIX_DIAG_UID);
+
+	uid = *(uid_t *)RTA_DATA(attr);
+	ASSERT_EQ(uid, getuid());
+}
+
+void receive_response(struct __test_metadata *_metadata,
+		      FIXTURE_DATA(diag_uid) *self)
+{
+	long buf[8192 / sizeof(long)];
+	struct sockaddr_nl nladdr = {
+		.nl_family = AF_NETLINK
+	};
+	struct iovec iov = {
+		.iov_base = buf,
+		.iov_len = sizeof(buf)
+	};
+	struct msghdr msg = {
+		.msg_name = &nladdr,
+		.msg_namelen = sizeof(nladdr),
+		.msg_iov = &iov,
+		.msg_iovlen = 1
+	};
+	struct unix_diag_req *udr;
+	struct nlmsghdr *nlh;
+	int ret;
+
+	ret = recvmsg(self->netlink_fd, &msg, 0);
+	ASSERT_GT(ret, 0);
+
+	nlh = (struct nlmsghdr *)buf;
+	ASSERT_NE(NLMSG_OK(nlh, ret), 0);
+	ASSERT_EQ(nlh->nlmsg_type, SOCK_DIAG_BY_FAMILY);
+
+	render_response(_metadata, NLMSG_DATA(nlh), nlh->nlmsg_len);
+
+	nlh = NLMSG_NEXT(nlh, ret);
+	ASSERT_EQ(NLMSG_OK(nlh, ret), 0);
+}
+
+TEST_F(diag_uid, 1)
+{
+	int ret;
+
+	ret = send_request(_metadata, self, variant);
+	ASSERT_GT(ret, 0);
+
+	receive_response(_metadata, self);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

