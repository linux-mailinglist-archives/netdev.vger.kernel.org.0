Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002BDFA618
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfKMBvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727687AbfKMBvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2888222D4;
        Wed, 13 Nov 2019 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609868;
        bh=6mgRnQfaykb8JmlmvCmBvxQ1eh9Cxc7VpaUNmu09KsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XaDKHjXyRtavgzW9sGDbli8PCWA0AyfPLK86+ECD+altbGHFHlRtKPuUs2B8eaOCm
         a19zFXoPPYcJ9tFmHUyZAQTysqUn2Md07dNWKU6yQe182BofZ6Jjn51fG8KQBx9IUX
         KCqwHg0CSPR5f06BU7GsXjqejBCVEJfWeUESXrnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vakul Garg <vakul.garg@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 033/209] selftests/tls: Fix recv(MSG_PEEK) & splice() test cases
Date:   Tue, 12 Nov 2019 20:47:29 -0500
Message-Id: <20191113015025.9685-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vakul Garg <vakul.garg@nxp.com>

[ Upstream commit 0ed3015c9964dab7a1693b3e40650f329c16691e ]

TLS test cases splice_from_pipe, send_and_splice &
recv_peek_multiple_records expect to receive a given nummber of bytes
and then compare them against the number of bytes which were sent.
Therefore, system call recv() must not return before receiving the
requested number of bytes, otherwise the subsequent memcmp() fails.
This patch passes MSG_WAITALL flag to recv() so that it does not return
prematurely before requested number of bytes are copied to receive
buffer.

Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 8fdfeafaf8c00..7549d39ccafff 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -288,7 +288,7 @@ TEST_F(tls, splice_from_pipe)
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_GE(write(p[1], mem_send, send_len), 0);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), 0);
-	EXPECT_GE(recv(self->cfd, mem_recv, send_len, 0), 0);
+	EXPECT_EQ(recv(self->cfd, mem_recv, send_len, MSG_WAITALL), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
@@ -322,13 +322,13 @@ TEST_F(tls, send_and_splice)
 
 	ASSERT_GE(pipe(p), 0);
 	EXPECT_EQ(send(self->fd, test_str, send_len2, 0), send_len2);
-	EXPECT_NE(recv(self->cfd, buf, send_len2, 0), -1);
+	EXPECT_EQ(recv(self->cfd, buf, send_len2, MSG_WAITALL), send_len2);
 	EXPECT_EQ(memcmp(test_str, buf, send_len2), 0);
 
 	EXPECT_GE(write(p[1], mem_send, send_len), send_len);
 	EXPECT_GE(splice(p[0], NULL, self->fd, NULL, send_len, 0), send_len);
 
-	EXPECT_GE(recv(self->cfd, mem_recv, send_len, 0), 0);
+	EXPECT_EQ(recv(self->cfd, mem_recv, send_len, MSG_WAITALL), send_len);
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
@@ -516,17 +516,17 @@ TEST_F(tls, recv_peek_multiple_records)
 	len = strlen(test_str_second) + 1;
 	EXPECT_EQ(send(self->fd, test_str_second, len, 0), len);
 
-	len = sizeof(buf);
+	len = strlen(test_str_first);
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, MSG_PEEK), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_PEEK | MSG_WAITALL), len);
 
 	/* MSG_PEEK can only peek into the current record. */
-	len = strlen(test_str_first) + 1;
+	len = strlen(test_str_first);
 	EXPECT_EQ(memcmp(test_str_first, buf, len), 0);
 
-	len = sizeof(buf);
+	len = strlen(test_str) + 1;
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, 0), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_WAITALL), len);
 
 	/* Non-MSG_PEEK will advance strparser (and therefore record)
 	 * however.
@@ -543,9 +543,9 @@ TEST_F(tls, recv_peek_multiple_records)
 	len = strlen(test_str_second) + 1;
 	EXPECT_EQ(send(self->fd, test_str_second, len, 0), len);
 
-	len = sizeof(buf);
+	len = strlen(test_str) + 1;
 	memset(buf, 0, len);
-	EXPECT_NE(recv(self->cfd, buf, len, MSG_PEEK), -1);
+	EXPECT_EQ(recv(self->cfd, buf, len, MSG_PEEK | MSG_WAITALL), len);
 
 	len = strlen(test_str) + 1;
 	EXPECT_EQ(memcmp(test_str, buf, len), 0);
-- 
2.20.1

