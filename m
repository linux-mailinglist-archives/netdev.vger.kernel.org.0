Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C927220AF75
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgFZKOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:14:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23119 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726992AbgFZKOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJny7E23fS1s7un/bRpkyKDx/jsNOvH0yCowMaRTNv0=;
        b=KrFJfX8d0PokrZXlW04wzOO3OXALbJzerBt5JdwSn5tTSlIv22lLfrZ3APfUAUGZIFV0KT
        vISG21zB6iwqIWqAaU+Up1Zz8jlsyY/rCnxttRnRgeVQYaE1FSzAQLgRZwKZgUZ/kb8fpc
        2E2xiVwhNEIiRqLOIksO3tPvwF4Ni6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-x4KsYriVOaS_n_hTq9vkZQ-1; Fri, 26 Jun 2020 06:14:00 -0400
X-MC-Unique: x4KsYriVOaS_n_hTq9vkZQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28F44107ACCA;
        Fri, 26 Jun 2020 10:13:59 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010A25D9C5;
        Fri, 26 Jun 2020 10:13:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 4/4] mptcp: introduce token KUNIT self-tests
Date:   Fri, 26 Jun 2020 12:12:49 +0200
Message-Id: <848d6611c87790a6e4028b856e7c3323a53f2679.1593159603.git.pabeni@redhat.com>
In-Reply-To: <cover.1593159603.git.pabeni@redhat.com>
References: <cover.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unit tests for the internal MPTCP token APIs, using KUNIT

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/Kconfig      |   2 +-
 net/mptcp/Makefile     |   3 +-
 net/mptcp/token.c      |   9 +++
 net/mptcp/token_test.c | 139 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100644 net/mptcp/token_test.c

diff --git a/net/mptcp/Kconfig b/net/mptcp/Kconfig
index d7d5f9349366..af84fce70bb0 100644
--- a/net/mptcp/Kconfig
+++ b/net/mptcp/Kconfig
@@ -26,7 +26,7 @@ config MPTCP_KUNIT_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
-	  Currently covers the MPTCP crypto helpers.
+	  Currently covers the MPTCP crypto and token helpers.
 	  Only useful for kernel devs running KUnit test harness and are not
 	  for inclusion into a production build.
 
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index f9039804207b..c53f9b845523 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -5,4 +5,5 @@ mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
 	   mib.o pm_netlink.o
 
 mptcp_crypto_test-objs := crypto_test.o
-obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o
\ No newline at end of file
+mptcp_token_test-objs := token_test.o
+obj-$(CONFIG_MPTCP_KUNIT_TESTS) += mptcp_crypto_test.o mptcp_token_test.o
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 9c0771774815..8acea188323c 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -307,3 +307,12 @@ void __init mptcp_token_init(void)
 		spin_lock_init(&token_hash[i].lock);
 	}
 }
+
+#if IS_MODULE(CONFIG_MPTCP_KUNIT_TESTS)
+EXPORT_SYMBOL_GPL(mptcp_token_new_request);
+EXPORT_SYMBOL_GPL(mptcp_token_new_connect);
+EXPORT_SYMBOL_GPL(mptcp_token_accept);
+EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
+EXPORT_SYMBOL_GPL(mptcp_token_destroy_request);
+EXPORT_SYMBOL_GPL(mptcp_token_destroy);
+#endif
\ No newline at end of file
diff --git a/net/mptcp/token_test.c b/net/mptcp/token_test.c
new file mode 100644
index 000000000000..c0f76b8b0ce0
--- /dev/null
+++ b/net/mptcp/token_test.c
@@ -0,0 +1,139 @@
+#include <kunit/test.h>
+
+#include "protocol.h"
+
+static struct mptcp_subflow_request_sock *build_req_sock(struct kunit *test)
+{
+	struct mptcp_subflow_request_sock *req;
+
+	req = kunit_kzalloc(test, sizeof(struct mptcp_subflow_request_sock),
+			    GFP_USER);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, req);
+	mptcp_token_init_request((struct request_sock *)req);
+	return req;
+}
+
+static void mptcp_token_test_req_basic(struct kunit *test)
+{
+	struct mptcp_subflow_request_sock *req = build_req_sock(test);
+	struct mptcp_sock *null_msk = NULL;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			mptcp_token_new_request((struct request_sock *)req));
+	KUNIT_EXPECT_NE(test, 0, (int)req->token);
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(req->token));
+
+	/* cleanup */
+	mptcp_token_destroy_request((struct request_sock *)req);
+}
+
+static struct inet_connection_sock *build_icsk(struct kunit *test)
+{
+	struct inet_connection_sock *icsk;
+
+	icsk = kunit_kzalloc(test, sizeof(struct inet_connection_sock),
+			     GFP_USER);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, icsk);
+	return icsk;
+}
+
+static struct mptcp_subflow_context *build_ctx(struct kunit *test)
+{
+	struct mptcp_subflow_context *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(struct mptcp_subflow_context),
+			    GFP_USER);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, ctx);
+	return ctx;
+}
+
+static struct mptcp_sock *build_msk(struct kunit *test)
+{
+	struct mptcp_sock *msk;
+
+	msk = kunit_kzalloc(test, sizeof(struct mptcp_sock), GFP_USER);
+	KUNIT_EXPECT_NOT_ERR_OR_NULL(test, msk);
+	refcount_set(&((struct sock *)msk)->sk_refcnt, 1);
+	return msk;
+}
+
+static void mptcp_token_test_msk_basic(struct kunit *test)
+{
+	struct inet_connection_sock *icsk = build_icsk(test);
+	struct mptcp_subflow_context *ctx = build_ctx(test);
+	struct mptcp_sock *msk = build_msk(test);
+	struct mptcp_sock *null_msk = NULL;
+	struct sock *sk;
+
+	icsk->icsk_ulp_data = ctx;
+	ctx->conn = (struct sock*)msk;
+	sk = (struct sock*)msk;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			mptcp_token_new_connect((struct sock *)icsk));
+	KUNIT_EXPECT_NE(test, 0, (int)ctx->token);
+	KUNIT_EXPECT_EQ(test, ctx->token, msk->token);
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(ctx->token));
+	KUNIT_EXPECT_EQ(test, 2, (int)refcount_read(&sk->sk_refcnt));
+
+	mptcp_token_destroy(msk);
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(ctx->token));
+}
+
+static void mptcp_token_test_accept(struct kunit *test)
+{
+	struct mptcp_subflow_request_sock *req = build_req_sock(test);
+	struct mptcp_sock *msk = build_msk(test);
+
+	KUNIT_ASSERT_EQ(test, 0,
+			mptcp_token_new_request((struct request_sock *)req));
+	msk->token = req->token;
+	mptcp_token_accept(req, msk);
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(msk->token));
+
+	/* this is now a no-op */
+	mptcp_token_destroy_request((struct request_sock *)req);
+	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(msk->token));
+
+	/* cleanup */
+	mptcp_token_destroy(msk);
+}
+
+static void mptcp_token_test_destroyed(struct kunit *test)
+{
+	struct mptcp_subflow_request_sock *req = build_req_sock(test);
+	struct mptcp_sock *msk = build_msk(test);
+	struct mptcp_sock *null_msk = NULL;
+	struct sock *sk;
+
+	sk = (struct sock*)msk;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			mptcp_token_new_request((struct request_sock *)req));
+	msk->token = req->token;
+	mptcp_token_accept(req, msk);
+
+	/* simulate race on removal */
+	refcount_set(&sk->sk_refcnt, 0);
+	KUNIT_EXPECT_PTR_EQ(test, null_msk, mptcp_token_get_sock(msk->token));
+
+	/* cleanup */
+	mptcp_token_destroy(msk);
+}
+
+static struct kunit_case mptcp_token_test_cases[] = {
+	KUNIT_CASE(mptcp_token_test_req_basic),
+	KUNIT_CASE(mptcp_token_test_msk_basic),
+	KUNIT_CASE(mptcp_token_test_accept),
+	KUNIT_CASE(mptcp_token_test_destroyed),
+	{}
+};
+
+static struct kunit_suite mptcp_token_suite = {
+	.name = "mptcp-token",
+	.test_cases = mptcp_token_test_cases,
+};
+
+kunit_test_suite(mptcp_token_suite);
+
+MODULE_LICENSE("GPL");
\ No newline at end of file
-- 
2.26.2

