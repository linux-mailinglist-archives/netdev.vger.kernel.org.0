Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA88575AE5
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbiGOFXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiGOFW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1335796BA
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F221B82A82
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B4DC3411E;
        Fri, 15 Jul 2022 05:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862569;
        bh=C6g0nb8pKpXNjnN4NaMrrpfNEleAaFeHY2IzK/RCOo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PYGWBBZRxDEIsiayC3MeIzdMYZsD4/q5jwrYxnQUGDiRliluenbRQU6dchVpMuBkc
         D9BBDeSMmM5dhrdxAm6YYMtxn6nJ/8ngJAWg+u/c3N4soxiEHturXQuwfl1APWXr2K
         zQ4/lD6jJwWOHVmck8wEc+R9Zc6OWrYk9d7qohOGtQHPLPjvKP8FhaQghqSfCbFntr
         csmrJHTFScW+j8zIWtkbNdlvwrmSmdPTO1N9m22t5fJOUC61fkZwu8B3EOrSjLftfg
         bGXdN3pxO7dNJv6VbV6wBIjIkerMky1nPGIJPSWI5KacY7zVD6rmcgQwMPxvAkzbOF
         c/rsy4n4nB6SA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 10/11] tls: rx: async: don't put async zc on the list
Date:   Thu, 14 Jul 2022 22:22:34 -0700
Message-Id: <20220715052235.1452170-11-kuba@kernel.org>
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

The "zero-copy" path in SW TLS will engage either for no skbs or
for all but last. If the recvmsg parameters are right and the
socket can do ZC we'll ZC until the iterator can't fit a full
record at which point we'll decrypt one more record and copy
over the necessary bits to fill up the request.

The only reason we hold onto the ZC skbs which went thru the async
path until the end of recvmsg() is to count bytes. We need an accurate
count of zc'ed bytes so that we can calculate how much of the non-zc'd
data to copy. To allow freeing input skbs on the ZC path count only
how much of the list we'll need to consume.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 40 +++++++++++++++++++---------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index f767501e178d..1c9a0705ee63 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1675,7 +1675,6 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 			   u8 *control,
 			   size_t skip,
 			   size_t len,
-			   bool zc,
 			   bool is_peek)
 {
 	struct sk_buff *skb = skb_peek(&ctx->rx_list);
@@ -1709,12 +1708,10 @@ static int process_rx_list(struct tls_sw_context_rx *ctx,
 		if (err <= 0)
 			goto out;
 
-		if (!zc || (rxm->full_len - skip) > len) {
-			err = skb_copy_datagram_msg(skb, rxm->offset + skip,
-						    msg, chunk);
-			if (err < 0)
-				goto out;
-		}
+		err = skb_copy_datagram_msg(skb, rxm->offset + skip,
+					    msg, chunk);
+		if (err < 0)
+			goto out;
 
 		len = len - chunk;
 		copied = copied + chunk;
@@ -1824,9 +1821,9 @@ int tls_sw_recvmsg(struct sock *sk,
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
+	ssize_t decrypted = 0, async_copy_bytes = 0;
 	struct sk_psock *psock;
 	unsigned char control = 0;
-	ssize_t decrypted = 0;
 	size_t flushed_at = 0;
 	struct strp_msg *rxm;
 	struct tls_msg *tlm;
@@ -1855,7 +1852,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		goto end;
 
 	/* Process pending decrypted records. It must be non-zero-copy */
-	err = process_rx_list(ctx, msg, &control, 0, len, false, is_peek);
+	err = process_rx_list(ctx, msg, &control, 0, len, is_peek);
 	if (err < 0)
 		goto end;
 
@@ -1939,19 +1936,20 @@ int tls_sw_recvmsg(struct sock *sk,
 		chunk = rxm->full_len;
 		tls_rx_rec_done(ctx);
 
-		if (async) {
-			/* TLS 1.2-only, to_decrypt must be text length */
-			chunk = min_t(int, to_decrypt, len);
-put_on_rx_list:
-			decrypted += chunk;
-			len -= chunk;
-			__skb_queue_tail(&ctx->rx_list, skb);
-			continue;
-		}
-
 		if (!darg.zc) {
 			bool partially_consumed = chunk > len;
 
+			if (async) {
+				/* TLS 1.2-only, to_decrypt must be text len */
+				chunk = min_t(int, to_decrypt, len);
+				async_copy_bytes += chunk;
+put_on_rx_list:
+				decrypted += chunk;
+				len -= chunk;
+				__skb_queue_tail(&ctx->rx_list, skb);
+				continue;
+			}
+
 			if (bpf_strp_enabled) {
 				err = sk_psock_tls_strp_read(psock, skb);
 				if (err != __SK_PASS) {
@@ -2018,10 +2016,10 @@ int tls_sw_recvmsg(struct sock *sk,
 		/* Drain records from the rx_list & copy if required */
 		if (is_peek || is_kvec)
 			err = process_rx_list(ctx, msg, &control, copied,
-					      decrypted, false, is_peek);
+					      decrypted, is_peek);
 		else
 			err = process_rx_list(ctx, msg, &control, 0,
-					      decrypted, true, is_peek);
+					      async_copy_bytes, is_peek);
 		decrypted = max(err, 0);
 	}
 
-- 
2.36.1

