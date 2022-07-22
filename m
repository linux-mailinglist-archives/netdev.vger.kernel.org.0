Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6ED557EA70
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236495AbiGVXus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 19:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236460AbiGVXuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 19:50:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16135BA277
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 16:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7868622A5
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 23:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACCCC341CE;
        Fri, 22 Jul 2022 23:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658533844;
        bh=xJBVjwgTpuk+e2jorS4qDVkm8TOnjCFMrr7LSLmzs9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pEhLIc5NMb1eosZse/fjIyQBkDOakDHNvYTWSe2hEINYVW5WIP/mSrV1My4Gaom9X
         c+evpWlgk0EAwWlP2PCPBu0XVghvugl8vcrWXgV/HtBTeoYdv1VBMVkPOPRd3vkU+V
         pjoWZN0ZSX1pR/AWPJA1jJ85ESmRHPNts4VG/+QSHwdUeltgg7SBTE4yaNNjQApvG/
         OwzvCWjxF5lT8fGXmAshOrJdRIHmRIr4/E4XhIcpbpRoNyoIL+iWdLkTwkm+5+C+nA
         USqbSjzZYrGClQTboh6Q5fC+OYSh9tx3gDqrTCWvUNo147jrXVCuBwBtXkWLg7Opn0
         1cDOUPs0zyXHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 3/7] tls: rx: don't free the output in case of zero-copy
Date:   Fri, 22 Jul 2022 16:50:29 -0700
Message-Id: <20220722235033.2594446-4-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722235033.2594446-1-kuba@kernel.org>
References: <20220722235033.2594446-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the future we'll want to reuse the input skb in case of
zero-copy so we shouldn't always free darg.skb. Move the
freeing of darg.skb into the non-zc cases. All cases will
now free ctx->recv_pkt (inside let tls_rx_rec_done()).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: borisp@nvidia.com
CC: john.fastabend@gmail.com
---
 net/tls/tls_sw.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index eed52f853418..fe38b49a2607 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1416,6 +1416,8 @@ tls_alloc_clrtxt_skb(struct sock *sk, struct sk_buff *skb,
  *    zc | Zero-copy decrypt allowed | Zero-copy performed
  * async | Async decrypt allowed     | Async crypto used / in progress
  *   skb |            *              | Output skb
+ *
+ * If ZC decryption was performed darg.skb will point to the input skb.
  */
 
 /* This function decrypts the input skb into either out_iov or in out_sg
@@ -1615,12 +1617,10 @@ tls_decrypt_sw(struct sock *sk, struct tls_context *tls_ctx,
 		return tls_decrypt_sw(sk, tls_ctx, msg, darg);
 	}
 
-	if (darg->skb == ctx->recv_pkt)
-		ctx->recv_pkt = NULL;
-
 	pad = tls_padding_length(prot, darg->skb, darg);
 	if (pad < 0) {
-		consume_skb(darg->skb);
+		if (darg->skb != tls_strp_msg(ctx))
+			consume_skb(darg->skb);
 		return pad;
 	}
 
@@ -1890,7 +1890,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	size_t flushed_at = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
-	struct sk_buff *skb;
 	ssize_t copied = 0;
 	bool async = false;
 	int target, err = 0;
@@ -1970,10 +1969,6 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
-		skb = darg.skb;
-		rxm = strp_msg(skb);
-		tlm = tls_msg(skb);
-
 		async |= darg.async;
 
 		/* If the type of records being processed is not known yet,
@@ -1983,11 +1978,12 @@ int tls_sw_recvmsg(struct sock *sk,
 		 * is known just after record is dequeued from stream parser.
 		 * For tls1.3, we disable async.
 		 */
-		err = tls_record_content_type(msg, tlm, &control);
+		err = tls_record_content_type(msg, tls_msg(darg.skb), &control);
 		if (err <= 0) {
+			DEBUG_NET_WARN_ON_ONCE(darg.zc);
 			tls_rx_rec_done(ctx);
 put_on_rx_list_err:
-			__skb_queue_tail(&ctx->rx_list, skb);
+			__skb_queue_tail(&ctx->rx_list, darg.skb);
 			goto recv_end;
 		}
 
@@ -1996,11 +1992,15 @@ int tls_sw_recvmsg(struct sock *sk,
 				       decrypted + copied, &flushed_at);
 
 		/* TLS 1.3 may have updated the length by more than overhead */
+		rxm = strp_msg(darg.skb);
 		chunk = rxm->full_len;
 		tls_rx_rec_done(ctx);
 
 		if (!darg.zc) {
 			bool partially_consumed = chunk > len;
+			struct sk_buff *skb = darg.skb;
+
+			DEBUG_NET_WARN_ON_ONCE(darg.skb == ctx->recv_pkt);
 
 			if (async) {
 				/* TLS 1.2-only, to_decrypt must be text len */
@@ -2040,13 +2040,13 @@ int tls_sw_recvmsg(struct sock *sk,
 				rxm->full_len -= chunk;
 				goto put_on_rx_list;
 			}
+
+			consume_skb(skb);
 		}
 
 		decrypted += chunk;
 		len -= chunk;
 
-		consume_skb(skb);
-
 		/* Return full control message to userspace before trying
 		 * to parse another message type
 		 */
-- 
2.37.1

