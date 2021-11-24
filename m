Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E203345D129
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbhKXXaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345786AbhKXXaC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B532F610A8;
        Wed, 24 Nov 2021 23:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796412;
        bh=WPnaoNNL8lFpWsKtw744ZRdnfGac/Wix2jr1XIqQJO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghp51quEtFDWBMAz3iCucYDimESL/6hGjKfn15nVOlwsvcrVvE6mjU6MJEhDjZWQB
         s/bC0rODVtOQf6Qz41tGz8osyxeq/Y23eYHk64OO4Wij4V1uLD8I6ePReNGZW7lnb4
         YpwW+rpicFQXP8Mpj1y6pvU04bdvfJh/ngqceHweaH5ySWMK+77cFXn+iptPKWtbrJ
         I4CZZ92Ey5AA9U+IGlZLEs65Z0noVLxVAarkG4l0ibA5FJsmrZ4XmgXM45+5gSJMlV
         p89bMJl4k0rA6Ls+S1edTuXu/nYrHy8dWxZgaWym0h1BEaevTPgz6SvgJdX2rMIbWQ
         Xx6YJ3kg8caJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 5/9] selftests: tls: test splicing cmsgs
Date:   Wed, 24 Nov 2021 15:25:53 -0800
Message-Id: <20211124232557.2039757-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we correctly reject splicing non-data records.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/tls.c | 40 +++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 2108b197d3f6..3dfa9d7dd4cc 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -639,6 +639,46 @@ TEST_F(tls, splice_to_pipe)
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
+TEST_F(tls, splice_cmsg_to_pipe)
+{
+	char *test_str = "test_read";
+	char record_type = 100;
+	int send_len = 10;
+	char buf[10];
+	int p[2];
+
+	ASSERT_GE(pipe(p), 0);
+	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
+	EXPECT_EQ(errno, EINVAL);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(errno, EIO);
+	EXPECT_EQ(tls_recv_cmsg(_metadata, self->cfd, record_type,
+				buf, sizeof(buf), MSG_WAITALL),
+		  send_len);
+	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
+}
+
+TEST_F(tls, splice_dec_cmsg_to_pipe)
+{
+	char *test_str = "test_read";
+	char record_type = 100;
+	int send_len = 10;
+	char buf[10];
+	int p[2];
+
+	ASSERT_GE(pipe(p), 0);
+	EXPECT_EQ(tls_send_cmsg(self->fd, 100, test_str, send_len, 0), 10);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(errno, EIO);
+	EXPECT_EQ(splice(self->cfd, NULL, p[1], NULL, send_len, 0), -1);
+	EXPECT_EQ(errno, EINVAL);
+	EXPECT_EQ(tls_recv_cmsg(_metadata, self->cfd, record_type,
+				buf, sizeof(buf), MSG_WAITALL),
+		  send_len);
+	EXPECT_EQ(memcmp(test_str, buf, send_len), 0);
+}
+
 TEST_F(tls, recvmsg_single)
 {
 	char const *test_str = "test_recvmsg_single";
-- 
2.31.1

