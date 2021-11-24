Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6152E45D123
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345900AbhKXXaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344881AbhKXXaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E126108E;
        Wed, 24 Nov 2021 23:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796409;
        bh=dPyKAERBmL9tAEpyIw/1gLFLcdtyIoa99SpIrjtHsd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gDd67dRzSV1ONpT954/J3aipBpFh6wmlbJYG1tXSFjiAUD1krcT+5QZbKbh9Sdn3h
         wPKNuT18w+PaviETf6IxYrTkkjxTt1nycduBXasZSZqQ/7fdeWOWerSKQr/VzcOas6
         X+UEk6iROgFwiUohCTBg14rYMJXV8AoWVdgj0J45JrR1mQfcFNHuLxQEXuPvVJZ1tf
         //L3+p/3DuaHQWZxPn0uiyG3T082Ueq6tOPi0mjieKDZei9UQA1uhywsQ/+c7koK6I
         t7oNkO7KRc46Or6LxHKgXLzwaPfeFz87En8nGfz+jc6FSAxQn1aQf/cbJF81CTHaf6
         KMRnmLLY4nMsw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/9] selftests: tls: add helper for creating sock pairs
Date:   Wed, 24 Nov 2021 15:25:49 -0800
Message-Id: <20211124232557.2039757-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have the same code 3 times, about to add a fourth copy.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 128 +++++++-----------------------
 1 file changed, 29 insertions(+), 99 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index e61fc4c32ba2..8fb7cf8c4bfb 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -78,26 +78,21 @@ static void memrnd(void *s, size_t n)
 		*byte++ = rand();
 }
 
-FIXTURE(tls_basic)
-{
-	int fd, cfd;
-	bool notls;
-};
-
-FIXTURE_SETUP(tls_basic)
+static void ulp_sock_pair(struct __test_metadata *_metadata,
+			  int *fd, int *cfd, bool *notls)
 {
 	struct sockaddr_in addr;
 	socklen_t len;
 	int sfd, ret;
 
-	self->notls = false;
+	*notls = false;
 	len = sizeof(addr);
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = htonl(INADDR_ANY);
 	addr.sin_port = 0;
 
-	self->fd = socket(AF_INET, SOCK_STREAM, 0);
+	*fd = socket(AF_INET, SOCK_STREAM, 0);
 	sfd = socket(AF_INET, SOCK_STREAM, 0);
 
 	ret = bind(sfd, &addr, sizeof(addr));
@@ -108,26 +103,37 @@ FIXTURE_SETUP(tls_basic)
 	ret = getsockname(sfd, &addr, &len);
 	ASSERT_EQ(ret, 0);
 
-	ret = connect(self->fd, &addr, sizeof(addr));
+	ret = connect(*fd, &addr, sizeof(addr));
 	ASSERT_EQ(ret, 0);
 
-	self->cfd = accept(sfd, &addr, &len);
-	ASSERT_GE(self->cfd, 0);
+	*cfd = accept(sfd, &addr, &len);
+	ASSERT_GE(*cfd, 0);
 
 	close(sfd);
 
-	ret = setsockopt(self->fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	ret = setsockopt(*fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
 	if (ret != 0) {
 		ASSERT_EQ(errno, ENOENT);
-		self->notls = true;
+		*notls = true;
 		printf("Failure setting TCP_ULP, testing without tls\n");
 		return;
 	}
 
-	ret = setsockopt(self->cfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	ret = setsockopt(*cfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
 	ASSERT_EQ(ret, 0);
 }
 
+FIXTURE(tls_basic)
+{
+	int fd, cfd;
+	bool notls;
+};
+
+FIXTURE_SETUP(tls_basic)
+{
+	ulp_sock_pair(_metadata, &self->fd, &self->cfd, &self->notls);
+}
+
 FIXTURE_TEARDOWN(tls_basic)
 {
 	close(self->fd);
@@ -199,60 +205,21 @@ FIXTURE_VARIANT_ADD(tls, 13_sm4_ccm)
 FIXTURE_SETUP(tls)
 {
 	struct tls_crypto_info_keys tls12;
-	struct sockaddr_in addr;
-	socklen_t len;
-	int sfd, ret;
-
-	self->notls = false;
-	len = sizeof(addr);
+	int ret;
 
 	tls_crypto_info_init(variant->tls_version, variant->cipher_type,
 			     &tls12);
 
-	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = htonl(INADDR_ANY);
-	addr.sin_port = 0;
+	ulp_sock_pair(_metadata, &self->fd, &self->cfd, &self->notls);
 
-	self->fd = socket(AF_INET, SOCK_STREAM, 0);
-	sfd = socket(AF_INET, SOCK_STREAM, 0);
-
-	ret = bind(sfd, &addr, sizeof(addr));
-	ASSERT_EQ(ret, 0);
-	ret = listen(sfd, 10);
-	ASSERT_EQ(ret, 0);
+	if (self->notls)
+		return;
 
-	ret = getsockname(sfd, &addr, &len);
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len);
 	ASSERT_EQ(ret, 0);
 
-	ret = connect(self->fd, &addr, sizeof(addr));
+	ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12, tls12.len);
 	ASSERT_EQ(ret, 0);
-
-	ret = setsockopt(self->fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
-	if (ret != 0) {
-		self->notls = true;
-		printf("Failure setting TCP_ULP, testing without tls\n");
-	}
-
-	if (!self->notls) {
-		ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12,
-				 tls12.len);
-		ASSERT_EQ(ret, 0);
-	}
-
-	self->cfd = accept(sfd, &addr, &len);
-	ASSERT_GE(self->cfd, 0);
-
-	if (!self->notls) {
-		ret = setsockopt(self->cfd, IPPROTO_TCP, TCP_ULP, "tls",
-				 sizeof("tls"));
-		ASSERT_EQ(ret, 0);
-
-		ret = setsockopt(self->cfd, SOL_TLS, TLS_RX, &tls12,
-				 tls12.len);
-		ASSERT_EQ(ret, 0);
-	}
-
-	close(sfd);
 }
 
 FIXTURE_TEARDOWN(tls)
@@ -1355,62 +1322,25 @@ TEST(non_established) {
 
 TEST(keysizes) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
-	struct sockaddr_in addr;
-	int sfd, ret, fd, cfd;
-	socklen_t len;
+	int ret, fd, cfd;
 	bool notls;
 
-	notls = false;
-	len = sizeof(addr);
-
 	memset(&tls12, 0, sizeof(tls12));
 	tls12.info.version = TLS_1_2_VERSION;
 	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_256;
 
-	addr.sin_family = AF_INET;
-	addr.sin_addr.s_addr = htonl(INADDR_ANY);
-	addr.sin_port = 0;
-
-	fd = socket(AF_INET, SOCK_STREAM, 0);
-	sfd = socket(AF_INET, SOCK_STREAM, 0);
-
-	ret = bind(sfd, &addr, sizeof(addr));
-	ASSERT_EQ(ret, 0);
-	ret = listen(sfd, 10);
-	ASSERT_EQ(ret, 0);
-
-	ret = getsockname(sfd, &addr, &len);
-	ASSERT_EQ(ret, 0);
-
-	ret = connect(fd, &addr, sizeof(addr));
-	ASSERT_EQ(ret, 0);
-
-	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
-	if (ret != 0) {
-		notls = true;
-		printf("Failure setting TCP_ULP, testing without tls\n");
-	}
+	ulp_sock_pair(_metadata, &fd, &cfd, &notls);
 
 	if (!notls) {
 		ret = setsockopt(fd, SOL_TLS, TLS_TX, &tls12,
 				 sizeof(tls12));
 		EXPECT_EQ(ret, 0);
-	}
-
-	cfd = accept(sfd, &addr, &len);
-	ASSERT_GE(cfd, 0);
-
-	if (!notls) {
-		ret = setsockopt(cfd, IPPROTO_TCP, TCP_ULP, "tls",
-				 sizeof("tls"));
-		EXPECT_EQ(ret, 0);
 
 		ret = setsockopt(cfd, SOL_TLS, TLS_RX, &tls12,
 				 sizeof(tls12));
 		EXPECT_EQ(ret, 0);
 	}
 
-	close(sfd);
 	close(fd);
 	close(cfd);
 }
-- 
2.31.1

