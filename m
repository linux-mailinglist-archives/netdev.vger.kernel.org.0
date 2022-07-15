Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E23575AE9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiGOFWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiGOFWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFFF796A7
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBD2962258
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D274C341CA;
        Fri, 15 Jul 2022 05:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862564;
        bh=6hKcwexQKRwNtAIumGW968v6tHWxUvt5cPlytJ3KWgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDf++9ck9uvDiG+avKMdMOPc9Ng0sDoi3caNY1NQf3OE7ADS6r7SZt6BbYXCIn7vs
         x29ruuy/ldIsU5Ubld4LcqGv1OShYtyIvLSs96nIlQ2v8plSnH6J+Fz2ZstvL/M5rJ
         Jx4+ClLKNctuzd6XwLfxUzx1AJdSyohKtqByO9CATXh8EEm/jGch/fT/X3n3qLFXC4
         MYLFlx8lXB0K7CPzkX6WcHgOIERrmZv/iI38kh80+E27y28Kl2WZrAIbmrZCEswqDy
         3khfviXmcitFPBWM8EOjcl1r/r820lJgCyyKkWksi8Qz0G9V1qrsSYPHcKto/tPKXB
         y8DK1izhHlc+A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/11] tls: rx: don't keep decrypted skbs on ctx->recv_pkt
Date:   Thu, 14 Jul 2022 22:22:27 -0700
Message-Id: <20220715052235.1452170-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220715052235.1452170-1-kuba@kernel.org>
References: <20220715052235.1452170-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Detach the skb from ctx->recv_pkt after decryption is done,
even if we can't consume it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 49 +++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index acf65992aaca..f5f06d1ba024 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1648,6 +1648,12 @@ static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
 	return 1;
 }
 
+static void tls_rx_rec_done(struct tls_sw_context_rx *ctx)
+{
+	ctx->recv_pkt = NULL;
+	__strp_unpause(&ctx->strp);
+}
+
 /* This function traverses the rx_list in tls receive context to copies the
  * decrypted records into the buffer provided by caller zero copy is not
  * true. Further, the records are removed from the rx_list if it is not a peek
@@ -1902,15 +1908,20 @@ int tls_sw_recvmsg(struct sock *sk,
 		 * For tls1.3, we disable async.
 		 */
 		err = tls_record_content_type(msg, tlm, &control);
-		if (err <= 0)
+		if (err <= 0) {
+			tls_rx_rec_done(ctx);
+put_on_rx_list_err:
+			__skb_queue_tail(&ctx->rx_list, skb);
 			goto recv_end;
+		}
 
 		/* periodically flush backlog, and feed strparser */
 		tls_read_flush_backlog(sk, prot, len, to_decrypt,
 				       decrypted + copied, &flushed_at);
 
-		ctx->recv_pkt = NULL;
-		__strp_unpause(&ctx->strp);
+		/* TLS 1.3 may have updated the length by more than overhead */
+		chunk = rxm->full_len;
+		tls_rx_rec_done(ctx);
 
 		if (async) {
 			/* TLS 1.2-only, to_decrypt must be text length */
@@ -1921,8 +1932,6 @@ int tls_sw_recvmsg(struct sock *sk,
 			__skb_queue_tail(&ctx->rx_list, skb);
 			continue;
 		}
-		/* TLS 1.3 may have updated the length by more than overhead */
-		chunk = rxm->full_len;
 
 		if (!darg.zc) {
 			bool partially_consumed = chunk > len;
@@ -1943,10 +1952,8 @@ int tls_sw_recvmsg(struct sock *sk,
 
 			err = skb_copy_datagram_msg(skb, rxm->offset,
 						    msg, chunk);
-			if (err < 0) {
-				__skb_queue_tail(&ctx->rx_list, skb);
-				goto recv_end;
-			}
+			if (err < 0)
+				goto put_on_rx_list_err;
 
 			if (is_peek)
 				goto put_on_rx_list;
@@ -2020,7 +2027,6 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
-	bool from_queue;
 	int err = 0;
 	long timeo;
 	int chunk;
@@ -2029,8 +2035,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	if (timeo < 0)
 		return timeo;
 
-	from_queue = !skb_queue_empty(&ctx->rx_list);
-	if (from_queue) {
+	if (!skb_queue_empty(&ctx->rx_list)) {
 		skb = __skb_dequeue(&ctx->rx_list);
 	} else {
 		struct tls_decrypt_arg darg = {};
@@ -2047,6 +2052,8 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 			tls_err_abort(sk, -EBADMSG);
 			goto splice_read_end;
 		}
+
+		tls_rx_rec_done(ctx);
 	}
 
 	rxm = strp_msg(skb);
@@ -2055,29 +2062,29 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	/* splice does not support reading control messages */
 	if (tlm->control != TLS_RECORD_TYPE_DATA) {
 		err = -EINVAL;
-		goto splice_read_end;
+		goto splice_requeue;
 	}
 
 	chunk = min_t(unsigned int, rxm->full_len, len);
 	copied = skb_splice_bits(skb, sk, rxm->offset, pipe, chunk, flags);
 	if (copied < 0)
-		goto splice_read_end;
+		goto splice_requeue;
 
-	if (!from_queue) {
-		ctx->recv_pkt = NULL;
-		__strp_unpause(&ctx->strp);
-	}
 	if (chunk < rxm->full_len) {
-		__skb_queue_head(&ctx->rx_list, skb);
 		rxm->offset += len;
 		rxm->full_len -= len;
-	} else {
-		consume_skb(skb);
+		goto splice_requeue;
 	}
 
+	consume_skb(skb);
+
 splice_read_end:
 	tls_rx_reader_unlock(sk, ctx);
 	return copied ? : err;
+
+splice_requeue:
+	__skb_queue_head(&ctx->rx_list, skb);
+	goto splice_read_end;
 }
 
 bool tls_sw_sock_is_readable(struct sock *sk)
-- 
2.36.1

