Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15187183F72
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgCMDSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbgCMDSC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:18:02 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D122071C;
        Fri, 13 Mar 2020 03:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584069481;
        bh=eXsajFvCM9vSssTjEQAMyx5f9bmFy8Atwcln1l3tdSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFe0TZWSJ7ppM3pO0o2VA7S8gJa0XcMI8uB2/RCEy/GGMWkvJvYELmha/e0+Dpg1J
         iif6jkXF45llpTgi/nNwR3qPN1uCKZ7Ey9qAg3aNSTb82t535+RXNTFD83G6oTFj36
         4mxcnCT6mTO9rm4j5T1YQEF8LjaFXAEMQr/Ii2vA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     shuah@kernel.org
Cc:     keescook@chromium.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5/5] selftests: tls: run all tests for TLS 1.2 and TLS 1.3
Date:   Thu, 12 Mar 2020 20:17:52 -0700
Message-Id: <20200313031752.2332565-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313031752.2332565-1-kuba@kernel.org>
References: <20200313031752.2332565-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLS 1.2 and TLS 1.3 differ in the implementation.
Use fixture parameters to run all tests for both
versions, and remove the one-off TLS 1.2 test.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 93 ++++++-------------------------
 1 file changed, 17 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 0ea44d975b6c..63029728ac97 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -101,6 +101,21 @@ FIXTURE(tls)
 	bool notls;
 };
 
+FIXTURE_PARAMS(tls)
+{
+	unsigned int tls_version;
+};
+
+FIXTURE_PARAMS_ADD(tls, 12)
+{
+	.tls_version = TLS_1_2_VERSION,
+};
+
+FIXTURE_PARAMS_ADD(tls, 13)
+{
+	.tls_version = TLS_1_3_VERSION,
+};
+
 FIXTURE_SETUP(tls)
 {
 	struct tls12_crypto_info_aes_gcm_128 tls12;
@@ -112,7 +127,7 @@ FIXTURE_SETUP(tls)
 	len = sizeof(addr);
 
 	memset(&tls12, 0, sizeof(tls12));
-	tls12.info.version = TLS_1_3_VERSION;
+	tls12.info.version = params->tls_version;
 	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
 
 	addr.sin_family = AF_INET;
@@ -733,7 +748,7 @@ TEST_F(tls, bidir)
 		struct tls12_crypto_info_aes_gcm_128 tls12;
 
 		memset(&tls12, 0, sizeof(tls12));
-		tls12.info.version = TLS_1_3_VERSION;
+		tls12.info.version = params->tls_version;
 		tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
 
 		ret = setsockopt(self->fd, SOL_TLS, TLS_RX, &tls12,
@@ -1258,78 +1273,4 @@ TEST(keysizes) {
 	close(cfd);
 }
 
-TEST(tls12) {
-	int fd, cfd;
-	bool notls;
-
-	struct tls12_crypto_info_aes_gcm_128 tls12;
-	struct sockaddr_in addr;
-	socklen_t len;
-	int sfd, ret;
-
-	notls = false;
-	len = sizeof(addr);
-
-	memset(&tls12, 0, sizeof(tls12));
-	tls12.info.version = TLS_1_2_VERSION;
-	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
-
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
-
-	if (!notls) {
-		ret = setsockopt(fd, SOL_TLS, TLS_TX, &tls12,
-				 sizeof(tls12));
-		ASSERT_EQ(ret, 0);
-	}
-
-	cfd = accept(sfd, &addr, &len);
-	ASSERT_GE(cfd, 0);
-
-	if (!notls) {
-		ret = setsockopt(cfd, IPPROTO_TCP, TCP_ULP, "tls",
-				 sizeof("tls"));
-		ASSERT_EQ(ret, 0);
-
-		ret = setsockopt(cfd, SOL_TLS, TLS_RX, &tls12,
-				 sizeof(tls12));
-		ASSERT_EQ(ret, 0);
-	}
-
-	close(sfd);
-
-	char const *test_str = "test_read";
-	int send_len = 10;
-	char buf[10];
-
-	send_len = strlen(test_str) + 1;
-	EXPECT_EQ(send(fd, test_str, send_len, 0), send_len);
-	EXPECT_NE(recv(cfd, buf, send_len, 0), -1);
-	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
-
-	close(fd);
-	close(cfd);
-}
-
 TEST_HARNESS_MAIN
-- 
2.24.1

