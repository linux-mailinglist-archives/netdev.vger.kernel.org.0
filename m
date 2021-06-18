Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19F73AD38C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbhFRU1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230136AbhFRU1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:27:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 160036120A;
        Fri, 18 Jun 2021 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047907;
        bh=XiTs7KUeIa+gqd8IQz39teUm63HsJV+VbkBe6WB373g=;
        h=From:To:Cc:Subject:Date:From;
        b=d2MUmgosmvlOWjOON8N41jn935HiNyc7STn4c/OrFBNPO7/2D/E2TYrYPOGP/eZG9
         mBguzf7WBNC9mcqvCebR+vnLlD9BcHlfXZHSqObY6R91dszQshSY8N11nNg2GZc0yp
         yi3WJFYcE6VYUMGCMZ92FPyVQLkSh4cnNaXG92m0THYRVaoqrn+44LRHBowxfbRrW4
         MgkqtemHM6+PaX4uVsKsLVF58FoOU5xCVk2b6+VRnQ/PlAe7+z+DM78qC8Nosg0t05
         XXH8rxdUYq76oYGSbArMR0LFNAeHLHWOBhjDHoCP4hFE7o5xAqsGMeyh8cdL4xO0bW
         5MZHC0QAm6pPg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/2] selftests: tls: clean up uninitialized warnings
Date:   Fri, 18 Jun 2021 13:25:03 -0700
Message-Id: <20210618202504.1435179-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A bunch of tests uses uninitialized stack memory as random
data to send. This is harmless but generates compiler warnings.
Explicitly init the buffers with random data.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 426d07875a48..58fea6eb588d 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,18 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+static void memrnd(void *s, size_t n)
+{
+	int *dword = s;
+	char *byte;
+
+	for (; n >= 4; n -= 4)
+		*dword++ = rand();
+	byte = (void *)dword;
+	while (n--)
+		*byte++ = rand();
+}
+
 FIXTURE(tls_basic)
 {
 	int fd, cfd;
@@ -308,6 +320,8 @@ TEST_F(tls, recv_max)
 	char recv_mem[TLS_PAYLOAD_MAX_LEN];
 	char buf[TLS_PAYLOAD_MAX_LEN];
 
+	memrnd(buf, sizeof(buf));
+
 	EXPECT_GE(send(self->fd, buf, send_len, 0), 0);
 	EXPECT_NE(recv(self->cfd, recv_mem, send_len, 0), -1);
 	EXPECT_EQ(memcmp(buf, recv_mem, send_len), 0);
@@ -588,6 +602,8 @@ TEST_F(tls, recvmsg_single_max)
 	struct iovec vec;
 	struct msghdr hdr;
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_EQ(send(self->fd, send_mem, send_len, 0), send_len);
 	vec.iov_base = (char *)recv_mem;
 	vec.iov_len = TLS_PAYLOAD_MAX_LEN;
@@ -610,6 +626,8 @@ TEST_F(tls, recvmsg_multiple)
 	struct msghdr hdr;
 	int i;
 
+	memrnd(buf, sizeof(buf));
+
 	EXPECT_EQ(send(self->fd, buf, send_len, 0), send_len);
 	for (i = 0; i < msg_iovlen; i++) {
 		iov_base[i] = (char *)malloc(iov_len);
@@ -634,6 +652,8 @@ TEST_F(tls, single_send_multiple_recv)
 	char send_mem[TLS_PAYLOAD_MAX_LEN * 2];
 	char recv_mem[TLS_PAYLOAD_MAX_LEN * 2];
 
+	memrnd(send_mem, sizeof(send_mem));
+
 	EXPECT_GE(send(self->fd, send_mem, total_len, 0), 0);
 	memset(recv_mem, 0, total_len);
 
-- 
2.31.1

