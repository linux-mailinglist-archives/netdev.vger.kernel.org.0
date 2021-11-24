Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0240E45D12B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346834AbhKXXaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346233AbhKXXaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D30E8610E6;
        Wed, 24 Nov 2021 23:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796413;
        bh=aNS387HPl55LXcJcWNjuyY88ApZI871kUxLY6yQZWZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uztNmr3SQybT1yXaE3x0SJRtlHoLxzr5KXkqLzn6vaU9rFIXVjKLvzcD7RrmS/U/k
         XpzNvxjJtgNQr7JDT427lt/QW35srOoQNaw0E1MvDgp/wWooBE0+toLqG8tRc2eBCy
         wpvHq0i4twCGqjAo/VZL0SvbNCg2hXFrGsAOac/hlw4NupX2fz4XMIJFnA8PGLbrMP
         7BR3L4BtmxeqvSp0ApfaucVcE/DuXegxWmm6D0YajbvxS3mW2pts2y4IPdQbf18qHh
         aEXHyZ14dez+3Wk6jO4SpHjXzmZ88oEWgTklARLJEfHe5VWE1Zh3JP7NignjAoa7h1
         bcHA4yHJzss1A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 7/9] selftests: tls: test splicing decrypted records
Date:   Wed, 24 Nov 2021 15:25:55 -0800
Message-Id: <20211124232557.2039757-8-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add tests for half-received and peeked records.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 49 +++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 3dfa9d7dd4cc..6e78d7207cc1 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -679,6 +679,55 @@ TEST_F(tls, splice_dec_cmsg_to_pipe)
 	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
 }
 
+TEST_F(tls, recv_and_splice)
+{
+	int send_len = TLS_PAYLOAD_MAX_LEN;
+	char mem_send[TLS_PAYLOAD_MAX_LEN];
+	char mem_recv[TLS_PAYLOAD_MAX_LEN];
+	int half = send_len / 2;
+	int p[2];
+
+	ASSERT_GE(pipe(p), 0);
+	EXPECT_EQ(send(self->fd, mem_send, send_len, 0), send_len);
+	/* Recv hald of the record, splice the other half */
+	EXPECT_EQ(recv(self->cfd, mem_recv, half, MSG_WAITALL), half);
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, half, SPLICE_F_NONBLOCK),
+		  half);
+	EXPECT_EQ(read(p[0], &mem_recv[half], half), half);
+	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
+}
+
+TEST_F(tls, peek_and_splice)
+{
+	int send_len = TLS_PAYLOAD_MAX_LEN;
+	char mem_send[TLS_PAYLOAD_MAX_LEN];
+	char mem_recv[TLS_PAYLOAD_MAX_LEN];
+	int chunk = TLS_PAYLOAD_MAX_LEN / 4;
+	int n, i, p[2];
+
+	memrnd(mem_send, sizeof(mem_send));
+
+	ASSERT_GE(pipe(p), 0);
+	for (i = 0; i < 4; i++)
+		EXPECT_EQ(send(self->fd, &mem_send[chunk * i], chunk, 0),
+			  chunk);
+
+	EXPECT_EQ(recv(self->cfd, mem_recv, chunk * 5 / 2,
+		       MSG_WAITALL | MSG_PEEK),
+		  chunk * 5 / 2);
+	EXPECT_EQ(memcmp(mem_send, mem_recv, chunk * 5 / 2), 0);
+
+	n = 0;
+	while (n < send_len) {
+		i = splice(self->cfd, NULL, p[1], NULL, send_len - n, 0);
+		EXPECT_GT(i, 0);
+		n += i;
+	}
+	EXPECT_EQ(n, send_len);
+	EXPECT_EQ(read(p[0], mem_recv, send_len), send_len);
+	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
+}
+
 TEST_F(tls, recvmsg_single)
 {
 	char const *test_str = "test_recvmsg_single";
-- 
2.31.1

