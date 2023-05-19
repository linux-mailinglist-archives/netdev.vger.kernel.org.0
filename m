Return-Path: <netdev+bounces-3965-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8D0709D8B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 19:08:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37AAD1C21327
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 17:08:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C164125CA;
	Fri, 19 May 2023 17:08:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3910942;
	Fri, 19 May 2023 17:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FB5C433D2;
	Fri, 19 May 2023 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684516115;
	bh=XPRezjf3uWnVCchxZy0QwibFO9g9lepWWHZwAZDzTrg=;
	h=Subject:From:To:Cc:Date:From;
	b=kXnMXJIOzf33QsA2fZbMkE+FzzdfjzBkten4eTjlPbyMAGlxs63e8YM2am6oKzKHK
	 qg7vgAFSL2MfoCNTMNQlOqeAHThM/U6qHMl5U8/YevfSQKl45Zr+OLOHvBDtkjgoVX
	 pgcms6YrYMn9/mmJaG6bPDcjaSZSQ7ISqdedrbjuY/x2mdmPvEWWWXoYcWNM4gEob0
	 7VkpR3HihPfWVc+JvhhOT26eGrDeo8kmxcgVSDKAliV3ubDVSjOSq5c8yEQNATvsUh
	 wOydwpv/RpKAmUTpyWdb3vRlF5hBtkfSlDGWexZ/3kCm1o4i5OsgVCcyKM3POQY915
	 Bp2SluhRr5ngA==
Subject: [PATCH] net/handshake: Fix sock->file allocation
From: Chuck Lever <cel@kernel.org>
To: dan.carpenter@linaro.org
Cc: Chuck Lever <chuck.lever@oracle.com>, netdev@vger.kernel.org,
 kernel-tls-handshake@lists.linux.dev
Date: Fri, 19 May 2023 13:08:24 -0400
Message-ID: 
 <168451609436.45209.15407022385441542980.stgit@oracle-102.nfsv4bat.org>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Chuck Lever <chuck.lever@oracle.com>

	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
	^^^^                         ^^^^

sock_alloc_file() calls release_sock() on error but the left hand
side of the assignment dereferences "sock".  This isn't the bug and
I didn't report this earlier because there is an assert that it
doesn't fail.

net/handshake/handshake-test.c:221 handshake_req_submit_test4() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:233 handshake_req_submit_test4() warn: 'req' was already freed.
net/handshake/handshake-test.c:254 handshake_req_submit_test5() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:290 handshake_req_submit_test6() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:321 handshake_req_cancel_test1() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:355 handshake_req_cancel_test2() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:367 handshake_req_cancel_test2() warn: 'req' was already freed.
net/handshake/handshake-test.c:395 handshake_req_cancel_test3() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:407 handshake_req_cancel_test3() warn: 'req' was already freed.
net/handshake/handshake-test.c:451 handshake_req_destroy_test1() error: dereferencing freed memory 'sock'
net/handshake/handshake-test.c:463 handshake_req_destroy_test1() warn: 'req' was already freed.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 net/handshake/handshake-test.c |   42 +++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/net/handshake/handshake-test.c b/net/handshake/handshake-test.c
index e6adc5dec11a..daa1779063ed 100644
--- a/net/handshake/handshake-test.c
+++ b/net/handshake/handshake-test.c
@@ -209,6 +209,7 @@ static void handshake_req_submit_test4(struct kunit *test)
 {
 	struct handshake_req *req, *result;
 	struct socket *sock;
+	struct file *filp;
 	int err;
 
 	/* Arrange */
@@ -218,9 +219,10 @@ static void handshake_req_submit_test4(struct kunit *test)
 	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
 	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+	sock->file = filp;
 
 	err = handshake_req_submit(sock, req, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, err, 0);
@@ -241,6 +243,7 @@ static void handshake_req_submit_test5(struct kunit *test)
 	struct handshake_req *req;
 	struct handshake_net *hn;
 	struct socket *sock;
+	struct file *filp;
 	struct net *net;
 	int saved, err;
 
@@ -251,9 +254,10 @@ static void handshake_req_submit_test5(struct kunit *test)
 	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
 	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+	sock->file = filp;
 
 	net = sock_net(sock->sk);
 	hn = handshake_pernet(net);
@@ -276,6 +280,7 @@ static void handshake_req_submit_test6(struct kunit *test)
 {
 	struct handshake_req *req1, *req2;
 	struct socket *sock;
+	struct file *filp;
 	int err;
 
 	/* Arrange */
@@ -287,9 +292,10 @@ static void handshake_req_submit_test6(struct kunit *test)
 	err = __sock_create(&init_net, PF_INET, SOCK_STREAM, IPPROTO_TCP,
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
 	KUNIT_ASSERT_NOT_NULL(test, sock->sk);
+	sock->file = filp;
 
 	/* Act */
 	err = handshake_req_submit(sock, req1, GFP_KERNEL);
@@ -307,6 +313,7 @@ static void handshake_req_cancel_test1(struct kunit *test)
 {
 	struct handshake_req *req;
 	struct socket *sock;
+	struct file *filp;
 	bool result;
 	int err;
 
@@ -318,8 +325,9 @@ static void handshake_req_cancel_test1(struct kunit *test)
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
 
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
+	sock->file = filp;
 
 	err = handshake_req_submit(sock, req, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, err, 0);
@@ -340,6 +348,7 @@ static void handshake_req_cancel_test2(struct kunit *test)
 	struct handshake_req *req, *next;
 	struct handshake_net *hn;
 	struct socket *sock;
+	struct file *filp;
 	struct net *net;
 	bool result;
 	int err;
@@ -352,8 +361,9 @@ static void handshake_req_cancel_test2(struct kunit *test)
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
 
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
+	sock->file = filp;
 
 	err = handshake_req_submit(sock, req, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, err, 0);
@@ -380,6 +390,7 @@ static void handshake_req_cancel_test3(struct kunit *test)
 	struct handshake_req *req, *next;
 	struct handshake_net *hn;
 	struct socket *sock;
+	struct file *filp;
 	struct net *net;
 	bool result;
 	int err;
@@ -392,8 +403,9 @@ static void handshake_req_cancel_test3(struct kunit *test)
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
 
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
+	sock->file = filp;
 
 	err = handshake_req_submit(sock, req, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, err, 0);
@@ -436,6 +448,7 @@ static void handshake_req_destroy_test1(struct kunit *test)
 {
 	struct handshake_req *req;
 	struct socket *sock;
+	struct file *filp;
 	int err;
 
 	/* Arrange */
@@ -448,8 +461,9 @@ static void handshake_req_destroy_test1(struct kunit *test)
 			    &sock, 1);
 	KUNIT_ASSERT_EQ(test, err, 0);
 
-	sock->file = sock_alloc_file(sock, O_NONBLOCK, NULL);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sock->file);
+	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, filp);
+	sock->file = filp;
 
 	err = handshake_req_submit(sock, req, GFP_KERNEL);
 	KUNIT_ASSERT_EQ(test, err, 0);



