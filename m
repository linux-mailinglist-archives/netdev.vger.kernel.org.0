Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6384F9CC5
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbiDHSeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 14:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiDHSeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 14:34:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181E1ED93C
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A91B76223F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 18:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5462C385A1;
        Fri,  8 Apr 2022 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649442703;
        bh=Clnhavk35Hi1QZQyKXQqPf0V3bSVfULciyj0gmPWmTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOiFfTW/D3Tk/Ow/MVc/tWcvusI/tntnwX7W02H/+1wIj06L/o9TgHbaJl4raaYvk
         bm27noRnOfZ1Y6jHhXJLQ1Thr4BpCmlX7t+BcpuDf2Bfp66nSsdTcjKX7ffuFM22bn
         iNqfZY3E7oXq3GoNY7/zvSYlsb2asJCaUsOX1gA+o3O3z0FMTSbJnB+xR8OmjNa0a5
         A+mxvzWNHggET7QX0cJmEIz5Ec5TocrS40X1k8Z/q5YXuHB62UyTniuk9xrP8gW+GU
         aNNmqOQFvGYiNTYEX1/IbUdhKrVNk/MDa4sYETECunZkdAZIUfibIlSuOql+Wd7tmm
         8+AarjBHOZ/1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 09/11] tls: rx: inline consuming the skb at the end of the loop
Date:   Fri,  8 Apr 2022 11:31:32 -0700
Message-Id: <20220408183134.1054551-10-kuba@kernel.org>
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

tls_sw_advance_skb() always consumes the skb at the end of the loop.

To fall here the following must be true:

 !async && !is_peek && !retain_skb
   retain_skb => !zc && rxm->full_len > len
     # but non-full record implies !zc, so above can be simplified as
   retain_skb => rxm->full_len > len

 !async && !is_peek && !(rxm->full_len > len)
 !async && !is_peek && rxm->full_len <= len

tls_sw_advance_skb() returns false if len < rxm->full_len
which can't be true given conditions above.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 5ad0b2505988..3aa8fe1c6e77 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1611,27 +1611,6 @@ int decrypt_skb(struct sock *sk, struct sk_buff *skb,
 	return decrypt_internal(sk, skb, NULL, sgout, &darg);
 }
 
-static bool tls_sw_advance_skb(struct sock *sk, struct sk_buff *skb,
-			       unsigned int len)
-{
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
-	struct strp_msg *rxm = strp_msg(skb);
-
-	if (len < rxm->full_len) {
-		rxm->offset += len;
-		rxm->full_len -= len;
-		return false;
-	}
-	consume_skb(skb);
-
-	/* Finished with message */
-	ctx->recv_pkt = NULL;
-	__strp_unpause(&ctx->strp);
-
-	return true;
-}
-
 static int tls_record_content_type(struct msghdr *msg, struct tls_msg *tlm,
 				   u8 *control)
 {
@@ -1894,7 +1873,11 @@ int tls_sw_recvmsg(struct sock *sk,
 			skb_queue_tail(&ctx->rx_list, skb);
 			ctx->recv_pkt = NULL;
 			__strp_unpause(&ctx->strp);
-		} else if (tls_sw_advance_skb(sk, skb, chunk)) {
+		} else {
+			consume_skb(skb);
+			ctx->recv_pkt = NULL;
+			__strp_unpause(&ctx->strp);
+
 			/* Return full control message to
 			 * userspace before trying to parse
 			 * another message type
@@ -1902,8 +1885,6 @@ int tls_sw_recvmsg(struct sock *sk,
 			msg->msg_flags |= MSG_EOR;
 			if (control != TLS_RECORD_TYPE_DATA)
 				goto recv_end;
-		} else {
-			break;
 		}
 	}
 
-- 
2.34.1

