Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE75545D12D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347165AbhKXXaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346093AbhKXXaD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:30:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49887610CA;
        Wed, 24 Nov 2021 23:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796412;
        bh=V7Si2rKAIbKixXcEUKaqm1g9/ZMRskUcNP4lEvlJL0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYqJhGkB7bIqXExa6JPE7O45QMSeOuNsqFmrBrQyqCbOgJrdE6Y9szmNHpsuAlqTC
         TlR87oAa9HL3Eo3rCKyBw1/yX02LmUPnUZyBE8Cqv0fMvV9yOo55BeiYHBUHU3RY6f
         VCb+7lxyNuahvpZBKojvKxx6maJ0Md9E/s0588+SiYSZHcGeCA1JR5x7SDFXk2ZX6e
         IkeImjKvINmHUv0HV/BljbBqVMXZDwIeXaqbnqS0otDbOKDKAX72/MU4OdSkwajxU1
         JjRXg7+4FGUz+YA+ggr56RK/ZHt0dmTvP9U5MnmEoLPgx3wZxjdqHKaYEGjmP9qm71
         xonzSoN3Ucn9g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, davejwatson@fb.com,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        vakul.garg@nxp.com, willemb@google.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 6/9] tls: splice_read: fix accessing pre-processed records
Date:   Wed, 24 Nov 2021 15:25:54 -0800
Message-Id: <20211124232557.2039757-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211124232557.2039757-1-kuba@kernel.org>
References: <20211124232557.2039757-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

recvmsg() will put peek()ed and partially read records onto the rx_list.
splice_read() needs to consult that list otherwise it may miss data.
Align with recvmsg() and also put partially-read records onto rx_list.
tls_sw_advance_skb() is pretty pointless now and will be removed in
net-next.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 2f11f1db917a..d3e7ff90889e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2005,6 +2005,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool from_queue;
 	int err = 0;
 	long timeo;
 	int chunk;
@@ -2014,14 +2015,20 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 	timeo = sock_rcvtimeo(sk, flags & SPLICE_F_NONBLOCK);
 
-	skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo, &err);
-	if (!skb)
-		goto splice_read_end;
+	from_queue = !skb_queue_empty(&ctx->rx_list);
+	if (from_queue) {
+		skb = __skb_dequeue(&ctx->rx_list);
+	} else {
+		skb = tls_wait_data(sk, NULL, flags & SPLICE_F_NONBLOCK, timeo,
+				    &err);
+		if (!skb)
+			goto splice_read_end;
 
-	err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
-	if (err < 0) {
-		tls_err_abort(sk, -EBADMSG);
-		goto splice_read_end;
+		err = decrypt_skb_update(sk, skb, NULL, &chunk, &zc, false);
+		if (err < 0) {
+			tls_err_abort(sk, -EBADMSG);
+			goto splice_read_end;
+		}
 	}
 
 	/* splice does not support reading control messages */
@@ -2037,7 +2044,17 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (copied < 0)
 		goto splice_read_end;
 
-	tls_sw_advance_skb(sk, skb, copied);
+	if (!from_queue) {
+		ctx->recv_pkt = NULL;
+		__strp_unpause(&ctx->strp);
+	}
+	if (chunk < rxm->full_len) {
+		__skb_queue_head(&ctx->rx_list, skb);
+		rxm->offset += len;
+		rxm->full_len -= len;
+	} else {
+		consume_skb(skb);
+	}
 
 splice_read_end:
 	release_sock(sk);
-- 
2.31.1

