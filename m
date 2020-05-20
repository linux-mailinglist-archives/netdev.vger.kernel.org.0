Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53721DADC4
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 10:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgETImS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 04:42:18 -0400
Received: from novek.ru ([213.148.174.62]:52256 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbgETImR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 04:42:17 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 95217502975;
        Wed, 20 May 2020 11:42:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 95217502975
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1589964133; bh=dMzhrQZOQCJMLA73aFWszN6glSFDNtFyCC39AEvpazs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aVFGbQkeRw8E6Q1L2JY9E9wmu4ona/KO+6J1ThGqtQccEOP5jb8QF5DfTQWU4uc8Q
         kOHT9tys0ezDiA2sPJn0llLH5gK7XqFyREyGB1K4GIp2qErbsy1Z/wJQ2q6B9KUCVk
         LL8Vfbt86mnx24mg0/VFbv/Ty38xUJQaIcdUTsys=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [net v3 1/2] net/tls: fix encryption error checking
Date:   Wed, 20 May 2020 11:41:43 +0300
Message-Id: <1589964104-9941-2-git-send-email-vfedorenko@novek.ru>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
References: <1589964104-9941-1-git-send-email-vfedorenko@novek.ru>
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_exec_tx_verdict() can return negative value for copied
variable. In that case this value will be pushed back to caller
and the real error code will be lost. Fix it using signed type and
checking for positive value.

Fixes: d10523d0b3d7 ("net/tls: free the record on encryption error")
Fixes: d3b18ad31f93 ("tls: add bpf support to sk_msg handling")
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/tls/tls_sw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index d8ebdfc..e61c024 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -782,7 +782,7 @@ static int tls_push_record(struct sock *sk, int flags,
 
 static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
 			       bool full_record, u8 record_type,
-			       size_t *copied, int flags)
+			       ssize_t *copied, int flags)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
@@ -918,7 +918,8 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	unsigned char record_type = TLS_RECORD_TYPE_DATA;
 	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
 	bool eor = !(msg->msg_flags & MSG_MORE);
-	size_t try_to_copy, copied = 0;
+	size_t try_to_copy;
+	ssize_t copied = 0;
 	struct sk_msg *msg_pl, *msg_en;
 	struct tls_rec *rec;
 	int required_size;
@@ -1120,7 +1121,7 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 
 	release_sock(sk);
 	mutex_unlock(&tls_ctx->tx_lock);
-	return copied ? copied : ret;
+	return copied > 0 ? copied : ret;
 }
 
 static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
@@ -1134,7 +1135,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	struct sk_msg *msg_pl;
 	struct tls_rec *rec;
 	int num_async = 0;
-	size_t copied = 0;
+	ssize_t copied = 0;
 	bool full_record;
 	int record_room;
 	int ret = 0;
@@ -1236,7 +1237,7 @@ static int tls_sw_do_sendpage(struct sock *sk, struct page *page,
 	}
 sendpage_end:
 	ret = sk_stream_error(sk, flags, ret);
-	return copied ? copied : ret;
+	return copied > 0 ? copied : ret;
 }
 
 int tls_sw_sendpage_locked(struct sock *sk, struct page *page,
-- 
1.8.3.1

