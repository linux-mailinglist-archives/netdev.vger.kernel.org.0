Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC2757AA49
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbiGSXLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 19:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240583AbiGSXLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 19:11:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7FB62A79
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 16:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 691BBB81DB0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEA4C341CB;
        Tue, 19 Jul 2022 23:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658272299;
        bh=jLvBR/lx2h4N0YwudiM4YlCD5eTDwXOWCtuM2QVYK8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hs9VAIKx5WqUFc4goKQ3xWtI2woikj1le07L2rJZ88NdKJYT66TOWb9AhHzgy1DmY
         ylb/zD+sE9f/yeVFFSrWQlMQujVDXMP1ca/jW0sI4BnSsBV/qjknVxz2LSPCvz+Bpe
         N5U7sJ9WkUKF02JVmBadOZF6WBZij8+TPkpq9E2ZB6nj2QMjD6vtfLSYYRa/yjubIN
         sCE2GzeD2TZrnPoyR6biy8pC7dRzq1FfWKTjGujHoy1oGVMmesdOiVtyjtx8LRTA0x
         tMhfroupNyQySqvBAQQ6+/DEyF40HlFX0ctcz08tWK18yevCag3iJOJ6euE2W+u0ST
         jnKk7V2sn5oJg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/7] tls: rx: don't free the output in case of zero-copy
Date:   Tue, 19 Jul 2022 16:11:25 -0700
Message-Id: <20220719231129.1870776-4-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719231129.1870776-1-kuba@kernel.org>
References: <20220719231129.1870776-1-kuba@kernel.org>
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
index 0d4fc685b508..7345b41ded9d 100644
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
 
@@ -1881,7 +1881,6 @@ int tls_sw_recvmsg(struct sock *sk,
 	size_t flushed_at = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
-	struct sk_buff *skb;
 	ssize_t copied = 0;
 	bool async = false;
 	int target, err = 0;
@@ -1961,10 +1960,6 @@ int tls_sw_recvmsg(struct sock *sk,
 			goto recv_end;
 		}
 
-		skb = darg.skb;
-		rxm = strp_msg(skb);
-		tlm = tls_msg(skb);
-
 		async |= darg.async;
 
 		/* If the type of records being processed is not known yet,
@@ -1974,11 +1969,12 @@ int tls_sw_recvmsg(struct sock *sk,
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
 
@@ -1987,11 +1983,15 @@ int tls_sw_recvmsg(struct sock *sk,
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
@@ -2031,13 +2031,13 @@ int tls_sw_recvmsg(struct sock *sk,
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
2.36.1

