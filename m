Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AA245D125
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345982AbhKXXaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345786AbhKXXaA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07D81610A1;
        Wed, 24 Nov 2021 23:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796410;
        bh=JCZvn0k2dRRURCrpzLbB4VB4Z34LCEUdL1EVN0QOts0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q71L1oeJu/ogYbCIVUszbsuxV7pflrUwves802FFjR+GOkYqubtAbCAv3zLFtdNv7
         SocTSbSEG9Mps4U/8STZoOraEAoNjBTvt7hjYxF51IJUkM9vJVc1BWtEuRWjkTvZQy
         t4ZssrDUqfocgLJWViXD2f3n8NgJiA0K0DQTIDO4qSTt2flcYoxlpxSP6aYoQFPEyq
         Ppr/Aai+FbZ6rnk+8CH7+TK/TyatOQEKFpY5NykPyokuMsF6ZrZRGYo31rfosbaqmr
         qjIu/Ps4W7lN9DE4bf2zsaeevyzkJqYxf4Ud4hKxIKJBUzVRfU106oJ5+HWcnXK5OL
         6WLGLeB8GBQbw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/9] selftests: tls: factor out cmsg send/receive
Date:   Wed, 24 Nov 2021 15:25:50 -0800
Message-Id: <20211124232557.2039757-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers for sending and receiving special record types.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 111 +++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 8fb7cf8c4bfb..642d1d629b28 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -123,6 +123,65 @@ static void ulp_sock_pair(struct __test_metadata *_metadata,
 	ASSERT_EQ(ret, 0);
 }
 
+/* Produce a basic cmsg */
+static int tls_send_cmsg(int fd, unsigned char record_type,
+			 void *data, size_t len, int flags)
+{
+	char cbuf[CMSG_SPACE(sizeof(char))];
+	int cmsg_len = sizeof(char);
+	struct cmsghdr *cmsg;
+	struct msghdr msg;
+	struct iovec vec;
+
+	vec.iov_base = data;
+	vec.iov_len = len;
+	memset(&msg, 0, sizeof(struct msghdr));
+	msg.msg_iov = &vec;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cbuf;
+	msg.msg_controllen = sizeof(cbuf);
+	cmsg = CMSG_FIRSTHDR(&msg);
+	cmsg->cmsg_level = SOL_TLS;
+	/* test sending non-record types. */
+	cmsg->cmsg_type = TLS_SET_RECORD_TYPE;
+	cmsg->cmsg_len = CMSG_LEN(cmsg_len);
+	*CMSG_DATA(cmsg) = record_type;
+	msg.msg_controllen = cmsg->cmsg_len;
+
+	return sendmsg(fd, &msg, flags);
+}
+
+static int tls_recv_cmsg(struct __test_metadata *_metadata,
+			 int fd, unsigned char record_type,
+			 void *data, size_t len, int flags)
+{
+	char cbuf[CMSG_SPACE(sizeof(char))];
+	struct cmsghdr *cmsg;
+	unsigned char ctype;
+	struct msghdr msg;
+	struct iovec vec;
+	int n;
+
+	vec.iov_base = data;
+	vec.iov_len = len;
+	memset(&msg, 0, sizeof(struct msghdr));
+	msg.msg_iov = &vec;
+	msg.msg_iovlen = 1;
+	msg.msg_control = cbuf;
+	msg.msg_controllen = sizeof(cbuf);
+
+	n = recvmsg(fd, &msg, flags);
+
+	cmsg = CMSG_FIRSTHDR(&msg);
+	EXPECT_NE(cmsg, NULL);
+	EXPECT_EQ(cmsg->cmsg_level, SOL_TLS);
+	EXPECT_EQ(cmsg->cmsg_type, TLS_GET_RECORD_TYPE);
+	ctype = *((unsigned char *)CMSG_DATA(cmsg));
+	EXPECT_EQ(ctype, record_type);
+
+	return n;
+}
+
 FIXTURE(tls_basic)
 {
 	int fd, cfd;
@@ -1160,60 +1219,30 @@ TEST_F(tls, mutliproc_sendpage_writers)
 
 TEST_F(tls, control_msg)
 {
-	if (self->notls)
-		return;
-
-	char cbuf[CMSG_SPACE(sizeof(char))];
-	char const *test_str = "test_read";
-	int cmsg_len = sizeof(char);
+	char *test_str = "test_read";
 	char record_type = 100;
-	struct cmsghdr *cmsg;
-	struct msghdr msg;
 	int send_len = 10;
-	struct iovec vec;
 	char buf[10];
 
-	vec.iov_base = (char *)test_str;
-	vec.iov_len = 10;
-	memset(&msg, 0, sizeof(struct msghdr));
-	msg.msg_iov = &vec;
-	msg.msg_iovlen = 1;
-	msg.msg_control = cbuf;
-	msg.msg_controllen = sizeof(cbuf);
-	cmsg = CMSG_FIRSTHDR(&msg);
-	cmsg->cmsg_level = SOL_TLS;
-	/* test sending non-record types. */
-	cmsg->cmsg_type = TLS_SET_RECORD_TYPE;
-	cmsg->cmsg_len = CMSG_LEN(cmsg_len);
-	*CMSG_DATA(cmsg) = record_type;
-	msg.msg_controllen = cmsg->cmsg_len;
+	if (self->notls)
+		SKIP(return, "no TLS support");
 
-	EXPECT_EQ(sendmsg(self->fd, &msg, 0), send_len);
+	EXPECT_EQ(tls_send_cmsg(self->fd, record_type, test_str, send_len, 0),
+		  send_len);
 	/* Should fail because we didn't provide a control message */
 	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
 
-	vec.iov_base = buf;
-	EXPECT_EQ(recvmsg(self->cfd, &msg, MSG_WAITALL | MSG_PEEK), send_len);
-
-	cmsg = CMSG_FIRSTHDR(&msg);
-	EXPECT_NE(cmsg, NULL);
-	EXPECT_EQ(cmsg->cmsg_level, SOL_TLS);
-	EXPECT_EQ(cmsg->cmsg_type, TLS_GET_RECORD_TYPE);
-	record_type = *((unsigned char *)CMSG_DATA(cmsg));
-	EXPECT_EQ(record_type, 100);
+	EXPECT_EQ(tls_recv_cmsg(_metadata, self->cfd, record_type,
+				buf, sizeof(buf), MSG_WAITALL | MSG_PEEK),
+		  send_len);
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 
 	/* Recv the message again without MSG_PEEK */
-	record_type = 0;
 	memset(buf, 0, sizeof(buf));
 
-	EXPECT_EQ(recvmsg(self->cfd, &msg, MSG_WAITALL), send_len);
-	cmsg = CMSG_FIRSTHDR(&msg);
-	EXPECT_NE(cmsg, NULL);
-	EXPECT_EQ(cmsg->cmsg_level, SOL_TLS);
-	EXPECT_EQ(cmsg->cmsg_type, TLS_GET_RECORD_TYPE);
-	record_type = *((unsigned char *)CMSG_DATA(cmsg));
-	EXPECT_EQ(record_type, 100);
+	EXPECT_EQ(tls_recv_cmsg(_metadata, self->cfd, record_type,
+				buf, sizeof(buf), MSG_WAITALL),
+		  send_len);
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
-- 
2.31.1

