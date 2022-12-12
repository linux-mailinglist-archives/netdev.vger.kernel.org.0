Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F99649C84
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 11:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbiLLKmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 05:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232053AbiLLKlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 05:41:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21807B874;
        Mon, 12 Dec 2022 02:35:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4F4660F95;
        Mon, 12 Dec 2022 10:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05ABAC433D2;
        Mon, 12 Dec 2022 10:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841355;
        bh=+9tYdiXiVtNUDpzsv9a5rJQ3Oi8R6HjunfYohCyTXWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JIHcd0BWjlON1TYon1OM9M/bRVNiwb9pPR+aZsmsf0Kdln/dWFMovJne1KYxpyG23
         6xGnqxBpG/ohthlXCsNzAFk7FNFI5Oi4YbP6OHKv+Xtb6KnRkxvFgRignnQkJEmY3E
         f31LpXoi6Lk+J/vjGINhMD4nKvXuzM79MUALXlOrqCgRPXcOgF6Pbbc5zQgVVf9AEy
         PS5EWze7g1ssqN5tgDKbcJgt45l6rQHzYVBJbPnHWYwiYPK/gfsQtupCl2o77GipS7
         y+8wioVCpf0VfE6K+eo4c8AeJ5W1FRFXGTznqntwZTGDs770HItFaV6iLaN7Kh6xCG
         gIPJB2W85GZbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 6/7] af_unix: Add test for sock_diag and UDIAG_SHOW_UID.
Date:   Mon, 12 Dec 2022 05:35:02 -0500
Message-Id: <20221212103504.299281-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103504.299281-1-sashal@kernel.org>
References: <20221212103504.299281-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit ac011361bd4f6206b36d2a242500239881bf8d2a ]

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
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   2 +-
 .../testing/selftests/net/af_unix/diag_uid.c  | 178 ++++++++++++++++++
 3 files changed, 180 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/af_unix/diag_uid.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index de7d5cc15f85..951b3bfe29eb 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
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
2.35.1

