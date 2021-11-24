Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC3645D126
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346056AbhKXXaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345916AbhKXXaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 911986108F;
        Wed, 24 Nov 2021 23:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796411;
        bh=ZNujhvpe77ABOarq/M77Y5+zjnu0Hp1eKT4yXbYuqAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sSm5WoAmM4aOVsfFl2tdY8mVJrkjvnprNwE9rXPbi9rh/xmCHPUAyvOKqdx+JuqzC
         JCtbzHQzaXVvFnkAJSfFC36zwjdmv8GumM8MHK/cAT8PSz2PUraavX1rF9Ta14q8p1
         QKuK/Z76/cPK6Q4ynt5fRVMbg5/SD0bY8HLSrpXI/ZHWcZ/bZfdDljEnZG/BKLnwOe
         llkbCkfwtBNe+d54dtLZKpv0Q9HXswT+TESXkyl7KvmWh/v0Mfm5zJtiaMX1iEZgLE
         mHpGsfCauQpxHNNF26apG2hjRcd9yZ+pDK2B1wAz7IfbRNb3gvL6OLPunlIqMwcKgh
         z1//6GpPvx+nw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/9] selftests: tls: add tests for handling of bad records
Date:   Wed, 24 Nov 2021 15:25:51 -0800
Message-Id: <20211124232557.2039757-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test broken records.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 154 ++++++++++++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 642d1d629b28..2108b197d3f6 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1297,6 +1297,160 @@ TEST_F(tls, shutdown_reuse)
 	EXPECT_EQ(errno, EISCONN);
 }
 
+FIXTURE(tls_err)
+{
+	int fd, cfd;
+	int fd2, cfd2;
+	bool notls;
+};
+
+FIXTURE_VARIANT(tls_err)
+{
+	uint16_t tls_version;
+};
+
+FIXTURE_VARIANT_ADD(tls_err, 12_aes_gcm)
+{
+	.tls_version = TLS_1_2_VERSION,
+};
+
+FIXTURE_VARIANT_ADD(tls_err, 13_aes_gcm)
+{
+	.tls_version = TLS_1_3_VERSION,
+};
+
+FIXTURE_SETUP(tls_err)
+{
+	struct tls_crypto_info_keys tls12;
+	int ret;
+
+	tls_crypto_info_init(variant->tls_version, TLS_CIPHER_AES_GCM_128,
+			     &tls12);
+
+	ulp_sock_pair(_metadata, &self->fd, &self->cfd, &self->notls);
+	ulp_sock_pair(_metadata, &self->fd2, &self->cfd2, &self->notls);
+	if (self->notls)
+		return;
+
+	ret = setsockopt(self->fd, SOL_TLS, TLS_TX, &tls12, tls12.len);
+	ASSERT_EQ(ret, 0);
+
+	ret = setsockopt(self->cfd2, SOL_TLS, TLS_RX, &tls12, tls12.len);
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE_TEARDOWN(tls_err)
+{
+	close(self->fd);
+	close(self->cfd);
+	close(self->fd2);
+	close(self->cfd2);
+}
+
+TEST_F(tls_err, bad_rec)
+{
+	char buf[64];
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	memset(buf, 0x55, sizeof(buf));
+	EXPECT_EQ(send(self->fd2, buf, sizeof(buf), 0), sizeof(buf));
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EMSGSIZE);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), MSG_DONTWAIT), -1);
+	EXPECT_EQ(errno, EAGAIN);
+}
+
+TEST_F(tls_err, bad_auth)
+{
+	char buf[128];
+	int n;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	memrnd(buf, sizeof(buf) / 2);
+	EXPECT_EQ(send(self->fd, buf, sizeof(buf) / 2, 0), sizeof(buf) / 2);
+	n = recv(self->cfd, buf, sizeof(buf), 0);
+	EXPECT_GT(n, sizeof(buf) / 2);
+
+	buf[n - 1]++;
+
+	EXPECT_EQ(send(self->fd2, buf, n, 0), n);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+}
+
+TEST_F(tls_err, bad_in_large_read)
+{
+	char txt[3][64];
+	char cip[3][128];
+	char buf[3 * 128];
+	int i, n;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	/* Put 3 records in the sockets */
+	for (i = 0; i < 3; i++) {
+		memrnd(txt[i], sizeof(txt[i]));
+		EXPECT_EQ(send(self->fd, txt[i], sizeof(txt[i]), 0),
+			  sizeof(txt[i]));
+		n = recv(self->cfd, cip[i], sizeof(cip[i]), 0);
+		EXPECT_GT(n, sizeof(txt[i]));
+		/* Break the third message */
+		if (i == 2)
+			cip[2][n - 1]++;
+		EXPECT_EQ(send(self->fd2, cip[i], n, 0), n);
+	}
+
+	/* We should be able to receive the first two messages */
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), sizeof(txt[0]) * 2);
+	EXPECT_EQ(memcmp(buf, txt[0], sizeof(txt[0])), 0);
+	EXPECT_EQ(memcmp(buf + sizeof(txt[0]), txt[1], sizeof(txt[1])), 0);
+	/* Third mesasge is bad */
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+}
+
+TEST_F(tls_err, bad_cmsg)
+{
+	char *test_str = "test_read";
+	int send_len = 10;
+	char cip[128];
+	char buf[128];
+	char txt[64];
+	int n;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	/* Queue up one data record */
+	memrnd(txt, sizeof(txt));
+	EXPECT_EQ(send(self->fd, txt, sizeof(txt), 0), sizeof(txt));
+	n = recv(self->cfd, cip, sizeof(cip), 0);
+	EXPECT_GT(n, sizeof(txt));
+	EXPECT_EQ(send(self->fd2, cip, n, 0), n);
+
+	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
+	n = recv(self->cfd, cip, sizeof(cip), 0);
+	cip[n - 1]++; /* Break it */
+	EXPECT_GT(n, send_len);
+	EXPECT_EQ(send(self->fd2, cip, n, 0), n);
+
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), sizeof(txt));
+	EXPECT_EQ(memcmp(buf, txt, sizeof(txt)), 0);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+	EXPECT_EQ(recv(self->cfd2, buf, sizeof(buf), 0), -1);
+	EXPECT_EQ(errno, EBADMSG);
+}
+
 TEST(non_established) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.31.1

