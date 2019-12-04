Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41406113505
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 19:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbfLDSaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 13:30:13 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:35815 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbfLDSaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 13:30:13 -0500
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 3E978239; Wed,  4 Dec 2019 19:30:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1575484206;
        bh=1INDlaCJpLn0+6hFM2qct798lptXvkxMEEVD7w8HTnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvdlIsyO7/kU9WQYpMjEaFJiIk89QPGWPjXwoB5h2q5HNFQUPHDoLGq5VJ8MI7txM
         0j0JR18glCTZ7O8GTTHDwD+pyZqcn3Ha4FsH9XBZWWMQ3jB/aVn7ci0vUDVbFLawiv
         d4ycgDXPPEGXABJoz6h4CALIDr5syFFWloJhcAC8ez40ynlpTQi3U12iC34FLthIJR
         IqGZYceR+xmj4cuJ8mT6piv/2H5cldoj/ZIjHUhuqPKGrA0otJFiHHgGXx8A3e9+WB
         awgSSUbmxytmQJvv6lOS1NNfdBef/mtYqMzVaAt7A4+I+6Asc4HqzODwc+KqxWZLqO
         ijt7aIv8rVK8g==
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [PATCH v2] net/tls: Fix return values for setsockopt
Date:   Wed,  4 Dec 2019 19:29:40 +0100
Message-Id: <20191204182940.29007-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191203145535.5a416ef3@cakuba.netronome.com>
References: <20191203145535.5a416ef3@cakuba.netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is not available in userspace:

  setsockopt failed, 524, Unknown error 524

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
v2: update error code in selftest

 net/tls/tls_main.c                | 4 ++--
 tools/testing/selftests/net/tls.c | 8 ++------
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bdca31ffe6da..5830b8e02a36 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 	/* check version */
 	if (crypto_info->version != TLS_1_2_VERSION &&
 	    crypto_info->version != TLS_1_3_VERSION) {
-		rc = -ENOTSUPP;
+		rc = -EINVAL;
 		goto err_crypto_info;
 	}
 
@@ -723,7 +723,7 @@ static int tls_init(struct sock *sk)
 	 * share the ulp context.
 	 */
 	if (sk->sk_state != TCP_ESTABLISHED)
-		return -ENOTSUPP;
+		return -ENOTCONN;
 
 	/* allocate tls context */
 	write_lock_bh(&sk->sk_callback_lock);
diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 1c8f194d6556..97c056ab43d9 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,10 +25,6 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
-#ifndef ENOTSUPP
-#define ENOTSUPP 524
-#endif
-
 FIXTURE(tls_basic)
 {
 	int fd, cfd;
@@ -1145,11 +1141,11 @@ TEST(non_established) {
 	/* TLS ULP not supported */
 	if (errno == ENOENT)
 		return;
-	EXPECT_EQ(errno, ENOTSUPP);
+	EXPECT_EQ(errno, ENOTCONN);
 
 	ret = setsockopt(sfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
 	EXPECT_EQ(ret, -1);
-	EXPECT_EQ(errno, ENOTSUPP);
+	EXPECT_EQ(errno, ENOTCONN);
 
 	ret = getsockname(sfd, &addr, &len);
 	ASSERT_EQ(ret, 0);
-- 
2.20.1

