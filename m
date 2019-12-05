Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FDF113BDF
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 07:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfLEGl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 01:41:59 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:35007 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfLEGl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 01:41:59 -0500
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 438C8259; Thu,  5 Dec 2019 07:41:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1575528111;
        bh=OB+SZs5rfmEg2YpaajnWTgRGbhgtXbh7/dsMRhvSEvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUwhhZX8KE6YqiwotdEQYg73OU44aU8b4fTKn/G9VUDqB4ytVof19uH3YNBTZD6O3
         MenGTV93mMIzTr3CKzOlNulkl+xMzyaLXdQEPcRmFhWWo4yjomvtg/BYoTIuEEu/AG
         UgixDXMDjekNw19FkRsY4Rm3cMWLGrnC8VteuOORpvHqPbbahxPStldGByzXZW7PN6
         pw4hgeqq69SpSKQfp5SgpQebyldJDKWC5ygEFhwZWOlrrkG1yRV6SLI3tkE7XxR0/l
         w0oJ2tPNUB5TllPMk05uTnV4S093tIEMi//zFMs/ROuUlL1m+RnN76rDQI5sVREtlR
         ABXfhiEbMfEiA==
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
Date:   Thu,  5 Dec 2019 07:41:18 +0100
Message-Id: <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191204.165528.1483577978366613524.davem@davemloft.net>
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is not available in userspace, for example:

  setsockopt failed, 524, Unknown error 524

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
v3: replace ENOTSUPP in other functions
v2: update error code in selftest

 net/tls/tls_device.c              | 8 ++++----
 net/tls/tls_main.c                | 4 ++--
 net/tls/tls_sw.c                  | 8 ++++----
 tools/testing/selftests/net/tls.c | 8 ++------
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0683788bbef0..cd91ad812291 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -429,7 +429,7 @@ static int tls_push_data(struct sock *sk,
 
 	if (flags &
 	    ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL | MSG_SENDPAGE_NOTLAST))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	if (unlikely(sk->sk_err))
 		return -sk->sk_err;
@@ -571,7 +571,7 @@ int tls_device_sendpage(struct sock *sk, struct page *page,
 	lock_sock(sk);
 
 	if (flags & MSG_OOB) {
-		rc = -ENOTSUPP;
+		rc = -EOPNOTSUPP;
 		goto out;
 	}
 
@@ -1023,7 +1023,7 @@ int tls_set_device_offload(struct sock *sk, struct tls_context *ctx)
 	}
 
 	if (!(netdev->features & NETIF_F_HW_TLS_TX)) {
-		rc = -ENOTSUPP;
+		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
 
@@ -1098,7 +1098,7 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 	}
 
 	if (!(netdev->features & NETIF_F_HW_TLS_RX)) {
-		rc = -ENOTSUPP;
+		rc = -EOPNOTSUPP;
 		goto release_netdev;
 	}
 
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
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index da9f9ce51e7b..2969dc30e4e0 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -900,7 +900,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	int ret = 0;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
@@ -1215,7 +1215,7 @@ int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY |
 		      MSG_NO_SHARED_FRAGS))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return tls_sw_do_sendpage(sk, page, offset, size, flags);
 }
@@ -1228,7 +1228,7 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 
 	if (flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL |
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	mutex_lock(&tls_ctx->tx_lock);
 	lock_sock(sk);
@@ -1927,7 +1927,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 		/* splice does not support reading control messages */
 		if (ctx->control != TLS_RECORD_TYPE_DATA) {
-			err = -ENOTSUPP;
+			err = -EINVAL;
 			goto splice_read_end;
 		}
 
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

