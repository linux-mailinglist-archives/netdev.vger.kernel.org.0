Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E10189366
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 02:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgCRBCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 21:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727131AbgCRBCc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 21:02:32 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74D912073E;
        Wed, 18 Mar 2020 01:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584493351;
        bh=SFattD/ZlKFBawfjwW4N1/55Y6nlkygYuEWqRuxj+Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5XqStm0r59pB05paE1OTRTOI8mNndq0VMAtPFRMRHBL3aE25HlM+1Fmda79tDFAl
         eo6HBB3jjhSo8gDmT/GIMlchU60xkLX+u/gGtORv9RptjDxHaOcpBZVNlcERCJfznG
         0LPJXL0Mlyqr7bSAl9rEPpEfUYhML+ns11apshHw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     keescook@chromium.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, luto@amacapital.net, wad@chromium.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com, Tim.Bird@sony.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v5 5/5] selftests: tls: run all tests for TLS 1.2 and TLS 1.3
Date:   Tue, 17 Mar 2020 18:01:53 -0700
Message-Id: <20200318010153.40797-6-kuba@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200318010153.40797-1-kuba@kernel.org>
References: <20200318010153.40797-1-kuba@kernel.org>
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
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/net/tls.c | 93 ++++++-------------------------
 1 file changed, 17 insertions(+), 76 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 0ea44d975b6c..c5282e62df75 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -101,6 +101,21 @@ FIXTURE(tls)
 	bool notls;
 };
 
+FIXTURE_VARIANT(tls)
+{
+	unsigned int tls_version;
+};
+
+FIXTURE_VARIANT_ADD(tls, 12)
+{
+	.tls_version = TLS_1_2_VERSION,
+};
+
+FIXTURE_VARIANT_ADD(tls, 13)
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
+	tls12.info.version = variant->tls_version;
 	tls12.info.cipher_type = TLS_CIPHER_AES_GCM_128;
 
 	addr.sin_family = AF_INET;
@@ -733,7 +748,7 @@ TEST_F(tls, bidir)
 		struct tls12_crypto_info_aes_gcm_128 tls12;
 
 		memset(&tls12, 0, sizeof(tls12));
-		tls12.info.version = TLS_1_3_VERSION;
+		tls12.info.version = variant->tls_version;
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
2.25.1

