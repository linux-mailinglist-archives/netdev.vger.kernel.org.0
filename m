Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB75D4F9CC7
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiDHSeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbiDHSds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:33:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9047BEDF0A
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 217EE62231
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C08CC385A3;
        Fri,  8 Apr 2022 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442701;
        bh=/Gus6T8+0tBB5XF2GP4U/joSdffUvX1k2R6z0dkw2m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJNyU9Y7+1ODu0ZcgR0HDK56LMp6WoHJZBraUInDjUswCwAqC4T/FoNYFC7+lcEmp
         QYunaE+QFKjBHQqZVL9eOSh91DCW6hx+b6hUu/fWS0vjRj1KxRHMXFr9UHlv+wOhBj
         uouyMpLfGki7AgOJc9q87xJF7Fe0Nbe9r4UKJlN0Hd4FtAskettcBsHR/pRlbhBJ3k
         w3EEEAhao+uUl9v4/XvLIxGmZ1ciCHskVSgJjMNIPmLACjBystPiIXKmjFQcNQNgwF
         HcMQRcL6wRxg/kxD4n9qHkph4teJvdcBLd/hnoG5h+oVwhOFO2NCWzBZv+4RhfcFK/
         hN5uTWsmH82BQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/11] tls: rx: don't handle async in tls_sw_advance_skb()
Date:   Fri,  8 Apr 2022 11:31:29 -0700
Message-Id: <20220408183134.1054551-7-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls_sw_advance_skb() caters to the async case when skb argument
is NULL. In that case it simply unpauses the strparser.

These are surprising semantics to a person reading the code,
and result in higher LoC, so inline the __strp_unpause and
only call tls_sw_advance_skb() when we actually move past
an skb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 103a1aaca934..6f17f599a6d4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1616,17 +1616,14 @@ static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
+	struct strp_msg *rxm = strp_msg(skb);
 
-	if (skb) {
-		struct strp_msg *rxm = strp_msg(skb);
-
-		if (len < rxm->full_len) {
-			rxm->offset += len;
-			rxm->full_len -= len;
-			return false;
-		}
-		consume_skb(skb);
+	if (len < rxm->full_len) {
+		rxm->offset += len;
+		rxm->full_len -= len;
+		return false;
 	}
+	consume_skb(skb);
 
 	/* Finished with message */
 	ctx->recv_pkt = NULL;
@@ -1898,10 +1895,9 @@ int tls_sw_recvmsg(struct sock *sk,
 		/* For async or peek case, queue the current skb */
 		if (async || is_peek || retain_skb) {
 			skb_queue_tail(&ctx->rx_list, skb);
-			skb = NULL;
-		}
-
-		if (tls_sw_advance_skb(sk, skb, chunk)) {
+			ctx->recv_pkt = NULL;
+			__strp_unpause(&ctx->strp);
+		} else if (tls_sw_advance_skb(sk, skb, chunk)) {
 			/* Return full control message to
 			 * userspace before trying to parse
 			 * another message type
-- 
2.34.1

