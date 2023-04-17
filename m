Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9176E4B85
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjDQOdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjDQOc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:32:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FF9AD3C
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 07:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DECC462616
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 14:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9593C433EF;
        Mon, 17 Apr 2023 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681741961;
        bh=5qUY/VyZjuo6WGF9gqPqLfrnYhZxyYNFpMS+XAwq5FY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=is4suBw8TJ9iG6b7mzE1JoChWyk8nq8cEANN9CNpP67nZtbpURgoYD/q6WjsN59xJ
         CoDeQ8s6bM4bHuFZOqczgKBrqFhgdRdlafgr6Izo3sa5x2merhzrrYywzTXZ/EWDSB
         CM+d2UMAG1iup7BRdDKDfcPlMLvRz49imkBDVg1MKWuDmx01gOdKNKLqcF5zyBxTTq
         FBcy6JUXknExnkVWLgcNwbcDTIaQuFTkFt6rjIock1h3MxTt75JnzqA6FJUnLi2Ou5
         bJ5IkDOVdpjskhPboMnK3gqcGTesbqeVKrqGJrpn2XWpqfUDSCrJLYMxYl91g63/SM
         XbkO8+G+peYWA==
Subject: [PATCH v10 4/4] net/handshake: Add Kunit tests for the handshake
 consumer API
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
Date:   Mon, 17 Apr 2023 10:32:39 -0400
Message-ID: <168174195975.9520.14259868313919992583.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
References: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

These verify the API contracts and help exercise lifetime rules for
consumer sockets and handshake_req structures.

One way to run these tests:

./tools/testing/kunit/kunit.py run --kunitconfig ./net/handshake/.kunitconfig

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/Kconfig                    |   15 +
 net/handshake/.kunitconfig     |   11 +
 net/handshake/Makefile         |    2 
 net/handshake/handshake-test.c |  523 ++++++++++++++++++++++++++++++++++++++++
 net/handshake/handshake.h      |    5 
 net/handshake/netlink.c        |    7 +
 net/handshake/request.c        |    5 
 net/handshake/tlshd.c          |    1 
 8 files changed, 569 insertions(+)
 create mode 100644 net/handshake/.kunitconfig
 create mode 100644 net/handshake/handshake-test.c

diff --git a/net/Kconfig b/net/Kconfig
index 4b800706cc76..7d39c1773eb4 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -73,6 +73,21 @@ config NET_HANDSHAKE
 	depends on SUNRPC || NVME_TARGET_TCP || NVME_TCP
 	default y
 
+config NET_HANDSHAKE_KUNIT_TEST
+	tristate "KUnit tests for the handshake upcall mechanism" if !KUNIT_ALL_TESTS
+	default KUNIT_ALL_TESTS
+	depends on KUNIT
+	help
+	  This builds the KUnit tests for the handshake upcall mechanism.
+
+	  KUnit tests run during boot and output the results to the debug
+	  log in TAP format (https://testanything.org/). Only useful for
+	  kernel devs running KUnit test harness and are not for inclusion
+	  into a production build.
+
+	  For more information on KUnit and unit tests in general, refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
 config INET
 	bool "TCP/IP networking"
 	help
diff --git a/net/handshake/.kunitconfig b/net/handshake/.kunitconfig
new file mode 100644
index 000000000000..5c48cf4abca2
--- /dev/null
+++ b/net/handshake/.kunitconfig
@@ -0,0 +1,11 @@
+CONFIG_KUNIT=y
+CONFIG_UBSAN=y
+CONFIG_STACKTRACE=y
+CONFIG_NET=y
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_INET=y
+CONFIG_MULTIUSER=y
+CONFIG_NFS_FS=y
+CONFIG_SUNRPC=y
+CONFIG_NET_HANDSHAKE=y
+CONFIG_NET_HANDSHAKE_KUNIT_TEST=y
diff --git a/net/handshake/Makefile b/net/handshake/Makefile
index a089f7e3df24..247d73c6ff6e 100644
--- a/net/handshake/Makefile
+++ b/net/handshake/Makefile
@@ -9,3 +9,5 @@
 
 obj-y += handshake.o
 handshake-y := genl.o netlink.o request.o tlshd.o trace.o
+
+obj-$(CONFIG_NET_HANDSHAKE_KUNIT_TEST) += handshake-test.o
diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
new file mode 100644
index 000000000000..e6adc5dec11a
--- /dev/null
+++ b/net/handshake/handshake-test.c
@@ -0,0 +1,523 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2023 Oracle and/or its affiliates.
+ *
+ * KUnit test of the handshake upcall mechanism.
+ */
+
+#include <kunit/test.h>
+#include <kunit/visibility.h>
+
+#include <linux/kernel.h>
+
+#include <net/sock.h>
+#include <net/genetlink.h>
+#include <net/netns/generic.h>
+
+#include <uapi/linux/handshake.h>
+#include "handshake.h"
+
+MODULE_IMPORT_NS(EXPORTED_FOR_KUNIT_TESTING);
+
+static int test_accept_func(struct handshake_req *req, struct genl_info *info,
+			    int fd)
+{
+	return 0;
+}
+
+static void test_done_func(struct handshake_req *req, unsigned int status,
+			   struct genl_info *info)
+{
+}
+
+struct handshake_req_alloc_test_param {
+	const char			*desc;
+	struct handshake_proto		*proto;
+	gfp_t				gfp;
+	bool				expect_success;
+};
+
+static struct handshake_proto handshake_req_alloc_proto_2 = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_NONE,
+};
+
+static struct handshake_proto handshake_req_alloc_proto_3 = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_MAX,
+};
+
+static struct handshake_proto handshake_req_alloc_proto_4 = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
+};
+
+static struct handshake_proto handshake_req_alloc_proto_5 = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
+	.hp_accept		= test_accept_func,
+};
+
+static struct handshake_proto handshake_req_alloc_proto_6 = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
+	.hp_privsize		= UINT_MAX,
+	.hp_accept		= test_accept_func,
+	.hp_done		= test_done_func,
+};
+
+static struct handshake_proto handshake_req_alloc_proto_good = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
+	.hp_accept		= test_accept_func,
+	.hp_done		= test_done_func,
+};
+
+static const
+struct handshake_req_alloc_test_param handshake_req_alloc_params[] = {
+	{
+		.desc			= "handshake_req_alloc NULL proto",
+		.proto			= NULL,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc CLASS_NONE",
+		.proto			= &handshake_req_alloc_proto_2,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc CLASS_MAX",
+		.proto			= &handshake_req_alloc_proto_3,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc no callbacks",
+		.proto			= &handshake_req_alloc_proto_4,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc no done callback",
+		.proto			= &handshake_req_alloc_proto_5,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc excessive privsize",
+		.proto			= &handshake_req_alloc_proto_6,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= false,
+	},
+	{
+		.desc			= "handshake_req_alloc all good",
+		.proto			= &handshake_req_alloc_proto_good,
+		.gfp			= GFP_KERNEL,
+		.expect_success		= true,
+	},
+};
+
+static void
+handshake_req_alloc_get_desc(const struct handshake_req_alloc_test_param *param,
+			     char *desc)
+{
+	strscpy(desc, param->desc, KUNIT_PARAM_DESC_SIZE);
+}
+
+/* Creates the function handshake_req_alloc_gen_params */
+KUNIT_ARRAY_PARAM(handshake_req_alloc, handshake_req_alloc_params,
+		  handshake_req_alloc_get_desc);
+
+static void handshake_req_alloc_case(struct kunit *test)
+{
+	const struct handshake_req_alloc_test_param *param = test->param_value;
+	struct handshake_req *result;
+
+	/* Arrange */
+
+	/* Act */
+	result = handshake_req_alloc(param->proto, param->gfp);
+
+	/* Assert */
+	if (param->expect_success)
+		KUNIT_EXPECT_NOT_NULL(test, result);
+	else
+		KUNIT_EXPECT_NULL(test, result);
+
+	kfree(result);
+}
+
+static void handshake_req_submit_test1(struct kunit *test)
+{
+	struct socket *sock;
+	int err, result;
+
+	/* Arrange */
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	/* Act */
+	result = handshake_req_submit(sock, NULL, GFP_KERNEL);
+
+	/* Assert */
+	KUNIT_EXPECT_EQ(test, result, -EINVAL);
+
+	sock_release(sock);
+}
+
+static void handshake_req_submit_test2(struct kunit *test)
+{
+	struct handshake_req *req;
+	int result;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	/* Act */
+	result = handshake_req_submit(NULL, req, GFP_KERNEL);
+
+	/* Assert */
+	KUNIT_EXPECT_EQ(test, result, -EINVAL);
+
+	/* handshake_req_submit() destroys @req on error */
+}
+
+static void handshake_req_submit_test3(struct kunit *test)
+{
+	struct handshake_req *req;
+	struct socket *sock;
+	int err, result;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	sock->file = NULL;
+
+	/* Act */
+	result = handshake_req_submit(sock, req, GFP_KERNEL);
+
+	/* Assert */
+	KUNIT_EXPECT_EQ(test, result, -EINVAL);
+
+	/* handshake_req_submit() destroys @req on error */
+	sock_release(sock);
+}
+
+static void handshake_req_submit_test4(struct kunit *test)
+{
+	struct handshake_req *req, *result;
+	struct socket *sock;
+	int err;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	/* Act */
+	result = handshake_req_hash_lookup(sock->sk);
+
+	/* Assert */
+	KUNIT_EXPECT_NOT_NULL(test, result);
+	KUNIT_EXPECT_PTR_EQ(test, req, result);
+
+	handshake_req_cancel(sock->sk);
+	sock_release(sock);
+}
+
+static void handshake_req_submit_test5(struct kunit *test)
+{
+	struct handshake_req *req;
+	struct handshake_net *hn;
+	struct socket *sock;
+	struct net *net;
+	int saved, err;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+
+	net = sock_net(sock->sk);
+	hn = handshake_pernet(net);
+	KUNIT_ASSERT_NOT_NULL(test, hn);
+
+	saved = hn->hn_pending;
+	hn->hn_pending = hn->hn_pending_max + 1;
+
+	/* Act */
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+
+	/* Assert */
+	KUNIT_EXPECT_EQ(test, err, -EAGAIN);
+
+	sock_release(sock);
+	hn->hn_pending = saved;
+}
+
+static void handshake_req_submit_test6(struct kunit *test)
+{
+	struct handshake_req *req1, *req2;
+	struct socket *sock;
+	int err;
+
+	/* Arrange */
+	req1 = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req1);
+	req2 = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req2);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+
+	/* Act */
+	err = handshake_req_submit(sock, req1, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+	err = handshake_req_submit(sock, req2, GFP_KERNEL);
+
+	/* Assert */
+	KUNIT_EXPECT_EQ(test, err, -EBUSY);
+
+	handshake_req_cancel(sock->sk);
+	sock_release(sock);
+}
+
+static void handshake_req_cancel_test1(struct kunit *test)
+{
+	struct handshake_req *req;
+	struct socket *sock;
+	bool result;
+	int err;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	/* NB: handshake_req hasn't been accepted */
+
+	/* Act */
+	result = handshake_req_cancel(sock->sk);
+
+	/* Assert */
+	KUNIT_EXPECT_TRUE(test, result);
+
+	sock_release(sock);
+}
+
+static void handshake_req_cancel_test2(struct kunit *test)
+{
+	struct handshake_req *req, *next;
+	struct handshake_net *hn;
+	struct socket *sock;
+	struct net *net;
+	bool result;
+	int err;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	net = sock_net(sock->sk);
+	hn = handshake_pernet(net);
+	KUNIT_ASSERT_NOT_NULL(test, hn);
+
+	/* Pretend to accept this request */
+	next = handshake_req_next(hn, HANDSHAKE_HANDLER_CLASS_TLSHD);
+	KUNIT_ASSERT_PTR_EQ(test, req, next);
+
+	/* Act */
+	result = handshake_req_cancel(sock->sk);
+
+	/* Assert */
+	KUNIT_EXPECT_TRUE(test, result);
+
+	sock_release(sock);
+}
+
+static void handshake_req_cancel_test3(struct kunit *test)
+{
+	struct handshake_req *req, *next;
+	struct handshake_net *hn;
+	struct socket *sock;
+	struct net *net;
+	bool result;
+	int err;
+
+	/* Arrange */
+	req = handshake_req_alloc(&handshake_req_alloc_proto_good, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	net = sock_net(sock->sk);
+	hn = handshake_pernet(net);
+	KUNIT_ASSERT_NOT_NULL(test, hn);
+
+	/* Pretend to accept this request */
+	next = handshake_req_next(hn, HANDSHAKE_HANDLER_CLASS_TLSHD);
+	KUNIT_ASSERT_PTR_EQ(test, req, next);
+
+	/* Pretend to complete this request */
+	handshake_complete(next, -ETIMEDOUT, NULL);
+
+	/* Act */
+	result = handshake_req_cancel(sock->sk);
+
+	/* Assert */
+	KUNIT_EXPECT_FALSE(test, result);
+
+	sock_release(sock);
+}
+
+static struct handshake_req *handshake_req_destroy_test;
+
+static void test_destroy_func(struct handshake_req *req)
+{
+	handshake_req_destroy_test = req;
+}
+
+static struct handshake_proto handshake_req_alloc_proto_destroy = {
+	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
+	.hp_accept		= test_accept_func,
+	.hp_done		= test_done_func,
+	.hp_destroy		= test_destroy_func,
+};
+
+static void handshake_req_destroy_test1(struct kunit *test)
+{
+	struct handshake_req *req;
+	struct socket *sock;
+	int err;
+
+	/* Arrange */
+	handshake_req_destroy_test = NULL;
+
+	req = handshake_req_alloc(&handshake_req_alloc_proto_destroy, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, req);
+
+	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
+			    &sock, 1);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+
+	err = handshake_req_submit(sock, req, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, err, 0);
+
+	handshake_req_cancel(sock->sk);
+
+	/* Act */
+	sock_release(sock);
+
+	/* Assert */
+	KUNIT_EXPECT_PTR_EQ(test, handshake_req_destroy_test, req);
+}
+
+static struct kunit_case handshake_api_test_cases[] = {
+	{
+		.name			= "req_alloc API fuzzing",
+		.run_case		= handshake_req_alloc_case,
+		.generate_params	= handshake_req_alloc_gen_params,
+	},
+	{
+		.name			= "req_submit NULL req arg",
+		.run_case		= handshake_req_submit_test1,
+	},
+	{
+		.name			= "req_submit NULL sock arg",
+		.run_case		= handshake_req_submit_test2,
+	},
+	{
+		.name			= "req_submit NULL sock->file",
+		.run_case		= handshake_req_submit_test3,
+	},
+	{
+		.name			= "req_lookup works",
+		.run_case		= handshake_req_submit_test4,
+	},
+	{
+		.name			= "req_submit max pending",
+		.run_case		= handshake_req_submit_test5,
+	},
+	{
+		.name			= "req_submit multiple",
+		.run_case		= handshake_req_submit_test6,
+	},
+	{
+		.name			= "req_cancel before accept",
+		.run_case		= handshake_req_cancel_test1,
+	},
+	{
+		.name			= "req_cancel after accept",
+		.run_case		= handshake_req_cancel_test2,
+	},
+	{
+		.name			= "req_cancel after done",
+		.run_case		= handshake_req_cancel_test3,
+	},
+	{
+		.name			= "req_destroy works",
+		.run_case		= handshake_req_destroy_test1,
+	},
+	{}
+};
+
+static struct kunit_suite handshake_api_suite = {
+       .name                   = "Handshake API tests",
+       .test_cases             = handshake_api_test_cases,
+};
+
+kunit_test_suites(&handshake_api_suite);
+
+MODULE_DESCRIPTION("Test handshake upcall API functions");
+MODULE_LICENSE("GPL");
diff --git a/net/handshake/handshake.h b/net/handshake/handshake.h
index 52568dbe24f1..4dac965c99df 100644
--- a/net/handshake/handshake.h
+++ b/net/handshake/handshake.h
@@ -49,6 +49,7 @@ enum hr_flags_bits {
 struct handshake_proto {
 	int			hp_handler_class;
 	size_t			hp_privsize;
+	unsigned long		hp_flags;
 
 	int			(*hp_accept)(struct handshake_req *req,
 					     struct genl_info *info, int fd);
@@ -58,6 +59,10 @@ struct handshake_proto {
 	void			(*hp_destroy)(struct handshake_req *req);
 };
 
+enum hp_flags_bits {
+	HANDSHAKE_F_PROTO_NOTIFY,
+};
+
 /* netlink.c */
 int handshake_genl_notify(struct net *net, const struct handshake_proto *proto,
 			  gfp_t flags);
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 7264cac04047..8ea0ff993f9f 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -18,6 +18,8 @@
 #include <net/genetlink.h>
 #include <net/netns/generic.h>
 
+#include <kunit/visibility.h>
+
 #include <uapi/linux/handshake.h>
 #include "handshake.h"
 #include "genl.h"
@@ -38,6 +40,10 @@ int handshake_genl_notify(struct net *net, const struct handshake_proto *proto,
 	struct sk_buff *msg;
 	void *hdr;
 
+	/* Disable notifications during unit testing */
+	if (!test_bit(HANDSHAKE_F_PROTO_NOTIFY, &proto->hp_flags))
+		return 0;
+
 	if (!genl_has_listeners(&handshake_nl_family, net,
 				proto->hp_handler_class))
 		return -ESRCH;
@@ -262,6 +268,7 @@ struct handshake_net *handshake_pernet(struct net *net)
 	return handshake_net_id ?
 		net_generic(net, handshake_net_id) : NULL;
 }
+EXPORT_SYMBOL_IF_KUNIT(handshake_pernet);
 
 static int __init handshake_init(void)
 {
diff --git a/net/handshake/request.c b/net/handshake/request.c
index d5b2bc6de057..94d5cef3e048 100644
--- a/net/handshake/request.c
+++ b/net/handshake/request.c
@@ -20,6 +20,8 @@
 #include <net/genetlink.h>
 #include <net/netns/generic.h>
 
+#include <kunit/visibility.h>
+
 #include <uapi/linux/handshake.h>
 #include "handshake.h"
 
@@ -60,6 +62,7 @@ struct handshake_req *handshake_req_hash_lookup(struct sock *sk)
 	return rhashtable_lookup_fast(&handshake_rhashtbl, &sk,
 				      handshake_rhash_params);
 }
+EXPORT_SYMBOL_IF_KUNIT(handshake_req_hash_lookup);
 
 static bool handshake_req_hash_add(struct handshake_req *req)
 {
@@ -192,6 +195,7 @@ struct handshake_req *handshake_req_next(struct handshake_net *hn, int class)
 
 	return req;
 }
+EXPORT_SYMBOL_IF_KUNIT(handshake_req_next);
 
 /**
  * handshake_req_submit - Submit a handshake request
@@ -293,6 +297,7 @@ void handshake_complete(struct handshake_req *req, unsigned int status,
 		sock_put(sk);
 	}
 }
+EXPORT_SYMBOL_IF_KUNIT(handshake_complete);
 
 /**
  * handshake_req_cancel - Cancel an in-progress handshake
diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index 1b8353296060..fcbeb63b4eb1 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -249,6 +249,7 @@ static int tls_handshake_accept(struct handshake_req *req,
 static const struct handshake_proto tls_handshake_proto = {
 	.hp_handler_class	= HANDSHAKE_HANDLER_CLASS_TLSHD,
 	.hp_privsize		= sizeof(struct tls_handshake_req),
+	.hp_flags		= BIT(HANDSHAKE_F_PROTO_NOTIFY),
 
 	.hp_accept		= tls_handshake_accept,
 	.hp_done		= tls_handshake_done,


