Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5BF6D50EE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 20:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbjDCSqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 14:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbjDCSqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 14:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D342722
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 11:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D996627CB
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 18:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58462C433D2;
        Mon,  3 Apr 2023 18:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680547576;
        bh=6NGpTlqsPiFBpsD7CAOuHGYbaML5yHmrxzQdEXq47Is=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F6xk+XLl0WMMkhLNBWxkUodkTWuwkbYT1ihEq4mCUVwegnfV3adISMmLukac+ENcJ
         kbUWYWWg4lZJyyEWoCOkjynKUQssKujEO2J0b6fdn3jBMz6LJxbPp1Ha4ZnXGbwlOd
         R22iEjuaIx4bYMrbM2x37DOADVCeFefKBKyiQKmUvWtr0BwZybZTlp3fidKYbauGqO
         g5WpClhySKRoKATO0jceCKQhRtlo/souZ1zeAZCVIioBtfePvlt80/aENx8kUvIYNR
         IGPcu2m6QC5vXEUtr63tDih1xT+17drJSXySc+rGXEyK4uPN6DF+dssahNBZWRtDwv
         F8MWKGEfdmBTw==
Subject: [PATCH v8 3/4] net/handshake: Add Kunit tests for the handshake
 consumer API
From:   Chuck Lever <cel@kernel.org>
To:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        borisp@nvidia.com
Cc:     netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Date:   Mon, 03 Apr 2023 14:46:15 -0400
Message-ID: <168054757552.2138.13089316455964656033.stgit@klimt.1015granger.net>
In-Reply-To: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

These verify the API contracts and help exercise lifetime rules for
consumer sockets and handshake_req structures.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/Kconfig                |   15 +
 net/handshake/Makefile     |    2 
 net/handshake/kunit-test.c |  523 ++++++++++++++++++++++++++++++++++++++++++++
 net/handshake/netlink.c    |   19 ++
 4 files changed, 559 insertions(+)
 create mode 100644 net/handshake/kunit-test.c

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
diff --git a/net/handshake/Makefile b/net/handshake/Makefile
index a089f7e3df24..d3b26a29118f 100644
--- a/net/handshake/Makefile
+++ b/net/handshake/Makefile
@@ -9,3 +9,5 @@
 
 obj-y += handshake.o
 handshake-y := genl.o netlink.o request.o tlshd.o trace.o
+
+obj-$(CONFIG_NET_HANDSHAKE_KUNIT_TEST) += kunit-test.o
diff --git a/net/handshake/kunit-test.c b/net/handshake/kunit-test.c
new file mode 100644
index 000000000000..50af0da6c485
--- /dev/null
+++ b/net/handshake/kunit-test.c
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
+	handshake_req_cancel(sock);
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
+	handshake_req_cancel(sock);
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
+	result = handshake_req_cancel(sock);
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
+	result = handshake_req_cancel(sock);
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
+	result = handshake_req_cancel(sock);
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
+	handshake_req_cancel(sock);
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
diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
index 0997fd4c6e0b..70765371b04e 100644
--- a/net/handshake/netlink.c
+++ b/net/handshake/netlink.c
@@ -24,6 +24,23 @@
 
 #include <trace/events/handshake.h>
 
+#if IS_ENABLED(CONFIG_KUNIT)
+
+/**
+ * handshake_genl_notify - Solve world hunger, tell no-one.
+ * @net: target network namespace
+ * @handler_class: target handler
+ * @flags: memory allocation control flags
+ *
+ * User agent generally isn't running during unit testing.
+ */
+int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags)
+{
+	return 0;
+}
+
+#else
+
 /**
  * handshake_genl_notify - Notify handlers that a request is waiting
  * @net: target network namespace
@@ -64,6 +81,8 @@ int handshake_genl_notify(struct net *net, int handler_class, gfp_t flags)
 	return -EMSGSIZE;
 }
 
+#endif
+
 /**
  * handshake_genl_put - Create a generic netlink message header
  * @msg: buffer in which to create the header


