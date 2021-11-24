Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF89E45D133
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349895AbhKXXaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345916AbhKXXaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2549610A7;
        Wed, 24 Nov 2021 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796414;
        bh=7OtvmjUvwYPy3KI1TG3qdnDVOgZhIE0uqV48p/JiD9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9TbOMo1eEqC64c+ZjmNy7JfPdcr9cZurpdQLn5wBl7kkVzUwMgZbf90OIk73L5z+
         HY1om2oYcEpEgDeLPbd7DytRf+u+iS2BTC1QQj5J3J1Nar6f1MZNhMyRawkEF6/cZi
         6oKmUMao+78PPfpZOaElIcKVmLs1gTnfT2kXd773se74iMbDb7qzYSL2Jm8RLqSsvU
         WrTNRAjOM0koEmZ97ai2Tkic5IQEsWA+5IN+VA+CsaKL8GC5u3sp6V2uGf+4BRP6zv
         2z5p7J5ehwaXZ6rcgNhTPwXJJaqtuiop4Ea/qpbj8caZcIWAsa1BLLGoPwb/A81Z3e
         akHTvJNdvrwBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 9/9] selftests: tls: test for correct proto_ops
Date:   Wed, 24 Nov 2021 15:25:57 -0800
Message-Id: <20211124232557.2039757-10-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patch fixes overriding callbacks incorrectly. Triggering
the crash in sendpage_locked would be more spectacular but it's
hard to get to, so take the easier path of proving this is broken
and call getname. We're currently getting IPv4 socket info on an
IPv6 socket.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 55 +++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 6e78d7207cc1..8a22db0cca49 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1617,4 +1617,59 @@ TEST(keysizes) {
 	close(cfd);
 }
 
+TEST(tls_v6ops) {
+	struct tls_crypto_info_keys tls12;
+	struct sockaddr_in6 addr, addr2;
+	int sfd, ret, fd;
+	socklen_t len, len2;
+
+	tls_crypto_info_init(TLS_1_2_VERSION, TLS_CIPHER_AES_GCM_128, &tls12);
+
+	addr.sin6_family = AF_INET6;
+	addr.sin6_addr = in6addr_any;
+	addr.sin6_port = 0;
+
+	fd = socket(AF_INET6, SOCK_STREAM, 0);
+	sfd = socket(AF_INET6, SOCK_STREAM, 0);
+
+	ret = bind(sfd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+	ret = listen(sfd, 10);
+	ASSERT_EQ(ret, 0);
+
+	len = sizeof(addr);
+	ret = getsockname(sfd, &addr, &len);
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+
+	len = sizeof(addr);
+	ret = getsockname(fd, &addr, &len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	if (ret) {
+		ASSERT_EQ(errno, ENOENT);
+		SKIP(return, "no TLS support");
+	}
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, SOL_TLS, TLS_TX, &tls12, tls12.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(fd, SOL_TLS, TLS_RX, &tls12, tls12.len);
+	ASSERT_EQ(ret, 0);
+
+	len2 = sizeof(addr2);
+	ret = getsockname(fd, &addr2, &len2);
+	ASSERT_EQ(ret, 0);
+
+	EXPECT_EQ(len2, len);
+	EXPECT_EQ(memcmp(&addr, &addr2, len), 0);
+
+	close(fd);
+	close(sfd);
+}
+
 TEST_HARNESS_MAIN
-- 
2.31.1

